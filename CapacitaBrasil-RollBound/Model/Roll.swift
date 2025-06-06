//
//  Roll.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 04/06/25.
//

import SwiftUI
import SwiftData

@Model
class Roll {
    var dices: [Dice]
    var total: Int
    
    init(dices: [Dice], total: Int) {
        self.dices = dices
        self.total = total
    }
}
