//
//  Skill.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 05/06/25.
//

import SwiftData

@Model
class Skill {
    var dices: [Dice]
    var skillName: String
    
    init(dices: [Dice], skillName: String) {
        self.dices = dices
        self.skillName = skillName
    }
}

