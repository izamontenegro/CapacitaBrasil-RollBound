//
//  CharactersView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct CharactersView: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context

    @State private var showAddEntitySheet = false
    @State private var showDeleteEntitySheet = false

    @State private var selectedEntity: Entity?
    @State private var entityToDelete: Entity?

    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea(.all)

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

                    Text("Personagens")
                        .font(.custom("Sora", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                }
                .padding()

                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        ForEach(entityViewModel.entities, id: \.self) { entity in
                            VStack(spacing: 0) {
                                Button {
                                    selectedEntity = entity
                                } label: {
                                    SwipeCharacterCard(
                                        entity: entity,
                                        showDeleteSheet: Binding(
                                            get: { false },
                                            set: { newValue in
                                                if newValue {
                                                    entityToDelete = entity
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        showDeleteEntitySheet = true
                                                    }
                                                }
                                            }
                                        ),
                                        showEditSheet: Binding(
                                            get: { false },
                                            set: { newValue in
                                                if newValue {
                                                    selectedEntity = entity
                                                }
                                            }
                                        )
                                    )
                                }
                                
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 4)
                                    .foregroundStyle(Color.AppColors.secondary)
                            }
                        }
                    }
                }
            }

            if showAddEntitySheet || showDeleteEntitySheet || selectedEntity != nil {
                Color.black.opacity(0.4).ignoresSafeArea()
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
            AddEntitySheet(entityType: .character)
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
}

#Preview {
    CharactersView()
}
