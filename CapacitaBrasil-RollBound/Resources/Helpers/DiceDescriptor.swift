//
//  DiceDescriptor.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/06/25.
//

func diceDescription(for dices: [Dice]) -> String {
    let counts = Dictionary(grouping: dices, by: { $0.numberOfSides })
        .mapValues { $0.count }
    let parts = counts.map { "\($0.value) \($0.key.rawValue)" }.sorted()
    return parts.joined(separator: " + ")
}
