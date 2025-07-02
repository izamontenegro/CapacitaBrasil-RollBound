//
//  EntityViewModel.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora Montenegro on 02/06/25.
//

import SwiftUI
import SwiftData

class EntityViewModel: ObservableObject {
    static let shared = EntityViewModel()
    
    @Published var entities: [Entity] = []
    
    private init() { }
    
    // MARK: ADICIONAR NOVA ENTIDADE
    func createEntity(context: ModelContext, name: String, photo: Data?, health: Int, defense: Int, type: EntityType) {
        let newEntity = Entity(name: name, photo: photo, health: health, defense: defense, type: type)
        
        entities.append(newEntity)
        
        if newEntity.type == .initiative {
            print("Personagem de iniciativa adicionada")
        } else {
            context.insert(newEntity)
        }
        
        do {
            try context.save()
        } catch {
            print("Falha ao adicionar nova entidade: \(error)")
        }
    }
    
    // MARK: BUSCAR ENTIDADES
    func fetchAllEntities(context: ModelContext) {
        let descriptor = FetchDescriptor<Entity>()
        do {
            self.entities = try context.fetch(descriptor)
        } catch {
            print("Erro ao buscar entidades: \(error)")
        }
    }
    
    func fetchEntitiesByType(context: ModelContext, type: EntityType) -> [Entity] {
        let descriptor = FetchDescriptor<Entity>()
        
        do {
            return try context.fetch(descriptor).filter { $0.type == type }
        } catch {
            print("Erro ao buscar entidades: \(error.localizedDescription)")
            return []
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
