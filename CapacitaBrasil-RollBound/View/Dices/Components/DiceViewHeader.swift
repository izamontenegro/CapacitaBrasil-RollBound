//
//  DiceViewHeader.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/07/25.
//

import SwiftUI

struct DiceViewHeader: View {
    @ObservedObject var rollViewModel = RollViewModel.shared
    @Binding var selectedDices: [Dice]
    var body: some View {
        if rollViewModel.state == .idle {
            Text("Nova rolagem")
                .font(.custom("Sora", size: 22))
                .fontWeight(.bold)
                .foregroundStyle(Color.AppColors.active)
                .padding()

            DiceSelector(selectedDices: $selectedDices)
        } else {
            Text("Soma: \(rollViewModel.currentValue)")
                .font(.custom("Sora", size: 22))
                .fontWeight(.bold)
                .foregroundStyle(Color.AppColors.active)
                .padding(.top)
        }
    }
}
