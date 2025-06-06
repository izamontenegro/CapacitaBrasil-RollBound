//
//  Dice.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 05/06/25.
//
import SwiftData

@Model
class Dice {
    var numberOfSides: DiceSides
    var rollValue: Int

    init(numberOfSides: DiceSides, rollValue: Int) {
        self.numberOfSides = numberOfSides
        self.rollValue = rollValue
    }
}

enum DiceSides: String, CaseIterable, Codable {
    case D4, D6, D8, D10, D12, D20
}
