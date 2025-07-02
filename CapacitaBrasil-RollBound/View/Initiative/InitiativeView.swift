//
//  InitiativeView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 01/07/25.
//

import SwiftUI

struct InitiativeView: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context

    @State private var showAddEntitySheet = false
    @State private var showEditEntitySheet = false
    @State private var showDeleteEntitySheet = false

    @State private var offsetX: CGFloat = 0
    @GestureState private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    @State private var draggingEntity: Entity?
    @State private var wasDragged: Bool = false
    private let swipeThreshold: CGFloat = -90
    
    @State private var targetIndex: Int? = nil

    @State private var selectedEntity: Entity?
    @State private var entityToDelete: Entity?

    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)

            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            showAddEntitySheet = true
                        } label: {
                            Image("PlusIcon")
                        }
                    }

                    Text("Iniciativa")
                        .font(.custom("Sora", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                }
                .padding()

                ScrollView(.vertical) {
                    VStack {
                        ForEach(Array(entityViewModel.entities.enumerated()), id: \.1) { index, entity in
                            VStack(spacing: 0) {
                                if let target = targetIndex, target == index, draggingEntity != nil {
                                    Rectangle()
                                        .fill(Color.AppColors.active)
                                        .frame(height: 3)
                                        .padding(.horizontal, 12)
                                        .transition(.opacity)
                                }

                                Button {
                                    if wasDragged {
                                        wasDragged = false
                                    } else {
                                        selectedEntity = entity
                                    }
                                } label: {
                                    SwipeInitiativeCard(entity: entity)
                                }
                                .offset(y: draggingEntity?.id == entity.id ? dragOffset : 0)
                                .zIndex(draggingEntity?.id == entity.id ? 1 : 0)
                                .gesture(
                                    LongPressGesture(minimumDuration: 0.3)
                                        .sequenced(before: DragGesture())
                                        .onChanged { value in
                                            switch value {
                                            case .first(true):
                                                draggingEntity = entity
                                            case .second(true, let drag):
                                                dragOffset = drag?.translation.height ?? 0

                                                if let fromIndex = entityViewModel.entities.firstIndex(of: entity),
                                                   let dragging = draggingEntity,
                                                   let draggingIndex = entityViewModel.entities.firstIndex(of: dragging) {
                                                    let offset = Int(((drag?.translation.height ?? 0) / 100).rounded())
                                                    let newIndex = max(0, min(entityViewModel.entities.count - 1, draggingIndex + offset))
                                                    if newIndex != targetIndex {
                                                        targetIndex = newIndex
                                                    }
                                                }
                                            default:
                                                break
                                            }
                                        }
                                        .onEnded { value in
                                            guard let fromIndex = entityViewModel.entities.firstIndex(of: entity) else { return }

                                            switch value {
                                            case .second(true, let drag):
                                                let toIndex = calculateTargetIndex(
                                                    from: fromIndex,
                                                    drag: drag?.translation.height ?? 0
                                                )
                                                if fromIndex != toIndex {
                                                    withAnimation {
                                                        entityViewModel.entities.move(
                                                            fromOffsets: IndexSet(integer: fromIndex),
                                                            toOffset: toIndex
                                                        )
                                                    }
                                                }
                                            default:
                                                break
                                            }

                                            draggingEntity = nil
                                            dragOffset = 0
                                            targetIndex = nil
                                            wasDragged = true
                                        }
                                )
                            }
                        }
                    }
                }
            }
        }
        .overlay {
            if showAddEntitySheet || showEditEntitySheet || showDeleteEntitySheet {
                Color.black.opacity(0.4).ignoresSafeArea(.all)
            }
        }
        .onAppear {
            entityViewModel.fetchAllEntities(context: context)
        }
        .sheet(item: $selectedEntity) { entity in
            if let index = entityViewModel.entities.firstIndex(of: entity) {
                EditEntitySheet(
                    entity: $entityViewModel.entities[index],
                    showDeleteSheet: Binding(
                        get: { showDeleteEntitySheet },
                        set: { newValue in
                            if newValue {
                                entityToDelete = entity
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDeleteEntitySheet = true
                                }
                            }
                        }
                    )
                )
                .presentationDetents([.fraction(0.7)])
            }
        }
        .sheet(isPresented: $showAddEntitySheet) {
            AddEntitySheet(entityType: .initiative)
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(isPresented: $showDeleteEntitySheet) {
            if let entity = entityToDelete,
               let index = entityViewModel.entities.firstIndex(of: entity) {
                DeleteEntitySheet(selectedEntity: $entityViewModel.entities[index])
                    .presentationDetents([.fraction(0.5)])
            } else {
                Text("Erro: entidade não disponível.")
            }
        }
    }

    private func calculateTargetIndex(from currentIndex: Int, drag: CGFloat) -> Int {
        let rowHeight: CGFloat = 100
        let offset = Int((drag / rowHeight).rounded())
        return max(0, min(entityViewModel.entities.count - 1, currentIndex + offset))
    }
}
