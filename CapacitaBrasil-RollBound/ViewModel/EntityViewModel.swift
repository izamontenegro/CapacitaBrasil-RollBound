//
//  EntityViewModel.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora Montenegro on 02/06/25.
//

import SwiftUI
import SwiftData

class EntityViewModel: ObservableObject {
    @Published var entities: [Entity] = []
    
    // MARK: ADICIONAR NOVA ENTIDADE
    func createEntity(context: ModelContext, name: String, photo: Data?, health: Int, defense: Int, type: EntityType) {
        let newEntity = Entity(name: name, photo: photo, health: health, defense: defense, type: type)
        
        entities.append(newEntity)
        context.insert(newEntity)
        
        do {
            try context.save()
        } catch {
            print("Falha ao adicionar nova entidade: \(error)")
        }
    }
    
    // MARK: BUSCA DE ENTIDADES
    func fetchEntity(context: ModelContext, type: EntityType) {
        let descriptor = FetchDescriptor<Entity>(sortBy: [SortDescriptor(\.name)])
        do {
            entities = try context.fetch(descriptor)
        } catch {
            print("Falha ao buscar entidades: \(error)")
        }
    }
    
    // MARK: EDITAR ENTIDADE
    func updateEntity(context: ModelContext, entity: Entity, name: String?, photo: Data?, health: Int?, defense: Int?) {
        entity.name = name ?? entity.name
        entity.photo = photo ?? entity.photo
        entity.health = health ?? entity.health
        entity.defense = defense ?? entity.defense
        
        do {
            try context.save()
        } catch {
            print("Erro ao atualizar entidade: \(error.localizedDescription)")
        }
    }
    
    // MARK: DELETAR ENTIDADE
    func deleteEntity(context: ModelContext, entity: Entity) {
        entities.removeAll { $0.id == entity.id }
        context.delete(entity)
        
        do {
            try context.save()
        } catch {
            print("Erro ao deletar entidade: \(error.localizedDescription)")
        }
    }

}

private struct EntityViewModelView: View {
    @Environment(\.modelContext) var context
    @StateObject var viewModel: EntityViewModel = EntityViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: ADICIONANDO ENTIDADE
            HStack {
                Button(action: {
                    viewModel.createEntity(context: context, name: "Test Entity\(viewModel.entities.count + 1)", photo: nil, health: 90, defense: 50, type: .character)
                }, label: {
                    Text("Adicionar personagem")
                })
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    viewModel.createEntity(context: context, name: "Test Entity\(viewModel.entities.count + 1)", photo: nil, health: 90, defense: 50, type: .initiative)
                }, label: {
                    Text("Adicionar iniciativa")
                })
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
            
            // MARK: EDITANDO, REMOVENDO E **LISTANDO** ENTIDADES
            Text("Entidades:")
                .font(.title)
            
            ForEach(viewModel.entities) { entity in
                HStack {
                    VStack {
                        // MARK: DADOS DA ENTIDADE
                        Text(entity.name)
                            .foregroundStyle(entity.type == .initiative ? .red : .green)
                        Text(entity.health.description)
                        Text(entity.defense.description)
                        Text(entity.type.displayText)
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.deleteEntity(context: context, entity: viewModel.entities.first!)
                    }, label: {
                        Text("delete")
                    })
                    Button(action: {
                        viewModel.updateEntity(context: context, entity: entity, name: "atualizado", photo: nil, health: 1000, defense: nil)
                    }, label: {
                        Text("edit")
                    })
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    EntityViewModelView()
}
