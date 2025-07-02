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

    @State var showAddEntitySheet: Bool = false
    @State var showEditEntitySheet: Bool = false
    @State var showDeleteEntitySheet: Bool = false

    private let swipeThreshold: CGFloat = -90
    @State private var offsetX: CGFloat = 0
    @GestureState private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    @State private var draggingEntity: Entity?
    @State private var entities: [Entity] = []
    @State private var wasDragged: Bool = false

    @State var selectedEntity: Entity?

    @State private var entidades: [Entity] = [
        Entity(name: "Kleber Banban", health: 10, defense: 5, type: .character),
        Entity(name: "Yves Klavidian", health: 12, defense: 6, type: .character),
        Entity(name: "Jairzinho", health: 14, defense: 4, type: .initiative),
        Entity(name: "Carmelita da Lua", health: 8, defense: 9, type: .initiative),
        Entity(name: "Zé do Código", health: 20, defense: 2, type: .character)
    ]

    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddEntitySheet = true
                        }, label: {
                            Image("PlusIcon")
                        })
                    }

                    Text("Iniciativa")
                        .font(.custom("Sora", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                }
                .padding()

                ScrollView(.vertical) {
                    VStack {
                        ForEach(entities, id: \.self) { entity in
                            Button(action: {
                                if wasDragged {
                                    wasDragged = false
                                } else {
                                    selectedEntity = entity
                                    showEditEntitySheet = true
                                }
                            }, label: {
                                SwipeInitiativeCard(entity: entity)
                            })
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
                                        default:
                                            break
                                        }
                                    }
                                    .onEnded { value in
                                        guard let fromIndex = entities.firstIndex(of: entity) else { return }

                                        switch value {
                                        case .second(true, let drag):
                                            let toIndex = calculateTargetIndex(
                                                from: fromIndex,
                                                drag: drag?.translation.height ?? 0
                                            )
                                            if fromIndex != toIndex {
                                                withAnimation {
                                                    entities.move(
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
                                        wasDragged = true
                                    }
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            entityViewModel.fetchAllEntities(context: context)
            entityViewModel.entities.append(contentsOf: entidades)
            entities = entityViewModel.entities
        }
        .sheet(item: $selectedEntity) { entity in
            if let index = entityViewModel.entities.firstIndex(of: entity) {
                EditEntitySheet(entity: $entityViewModel.entities[index], showDeleteSheet: $showDeleteEntitySheet)
                    .presentationDetents([.fraction(0.7)])
            }
        }
        .sheet(isPresented: $showAddEntitySheet) {
            AddEntitySheet(entityType: .initiative)
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(isPresented: $showDeleteEntitySheet) {
            if let selectedEntity = selectedEntity,
               let index = entityViewModel.entities.firstIndex(of: selectedEntity) {
                DeleteEntitySheet(selectedEntity: $entityViewModel.entities[index])
                    .presentationDetents([.fraction(0.7)])
                    .onAppear {
                        print("DeleteEntitySheet apareceu com:", selectedEntity.name)
                    }
            } else {
                Text("Erro: selectedEntity não está disponível.")
            }
        }
    }

    private func calculateTargetIndex(from currentIndex: Int, drag: CGFloat) -> Int {
        let rowHeight: CGFloat = 100
        let offset = Int((drag / rowHeight).rounded())
        return max(0, min(entities.count - 1, currentIndex + offset))
    }
}
