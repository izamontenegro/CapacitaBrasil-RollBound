//
//  CapacitaBrasil_RollBoundApp.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora Montenegro on 26/05/25.
//

import SwiftUI
import SwiftData

@main
struct CapacitaBrasil_RollBoundApp: App {
    var body: some Scene {
        WindowGroup {
            RollView()
        }
        .modelContainer(for: [Entity.self, Dice.self, Roll.self])
    }
}
