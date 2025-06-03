//
//  Entity.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora Montenegro on 02/06/25.
//

import SwiftData
import SwiftUI

@Model
class Entity {
    var name: String
    var health: Int
    var defense: Int
    var type: EntityType
    var photo: Data?
    var id: UUID
    
    init(
        name: String,
        photo: Data? = nil,
        health: Int,
        defense: Int,
        type: EntityType)
    {
        self.name = name
        self.photo = photo
        self.health = health
        self.defense = defense
        self.type = type
        self.id = UUID()
    }
}

enum EntityType: String, CaseIterable, Codable {
    case character, initiative
    
    var displayText: String {
        switch self {
        case .character:
            return "Personagem"
        case .initiative:
            return "Iniciativa"
        }
    }
}
