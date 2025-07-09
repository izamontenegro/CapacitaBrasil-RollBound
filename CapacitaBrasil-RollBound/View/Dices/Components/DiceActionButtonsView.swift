//
//  DiceActionButtonsView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/07/25.
//

import SwiftUI

struct DiceActionButtonsView: View {
    @Environment(\.modelContext) var context
    @ObservedObject var rollViewModel = RollViewModel.shared
    
    @Binding var showHistorySheet: Bool
    @Binding var showSkillsSheet: Bool
    @Binding var selectedDices: [Dice]
    
    
    var body: some View {
        if rollViewModel.state == .idle {
            HStack(spacing: 11) {
                Button(action: {
                    showHistorySheet = true
                }) {
                    Image("HistoryIcon")
                }
                
                PrimaryButton(label: "Rolar", isActive: !selectedDices.isEmpty) {
                    Task {
                        rollViewModel.state = .rolling
                        rollViewModel.rolledDices = []
                        
                        let sides = selectedDices.map { $0.numberOfSides }
                        await rollViewModel.rollDices(context: context, dices: sides)
                    }
                }
                
                Button(action: {
                    showSkillsSheet = true
                }) {
                    Image("SaveIcon")
                }
            }
        }
    }
}
