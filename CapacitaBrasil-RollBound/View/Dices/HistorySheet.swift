//
//  HistorySheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//
import SwiftUI

struct HistorySheet: View {
    @ObservedObject var rollViewModel: RollViewModel = RollViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            
            VStack {
                ZStack {
                    Text("Ultimas \(rollViewModel.rolls.count) Rolagens")
                        .font(.custom("Sora", size: 21))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image("CloseIcon").foregroundStyle(Color.AppColors.active)
                        })
                    }
                }
                .padding()
                .padding(.top)
                
                ScrollView(.vertical) {
                    ForEach(rollViewModel.rolls, id: \.self) { roll in
                        VStack {
                            HistoryCard(roll: roll)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 4)
                                .foregroundStyle(Color.AppColors.secondary)
                                .padding(.top, 16)
                        }
                    }
                }
                
            }
        }
        .onAppear {
            RollViewModel.shared.rolls = [
                Roll(dices: [Dice(numberOfSides: .D20, rollValue: 12), Dice(numberOfSides: .D20, rollValue: 8), Dice(numberOfSides: .D20, rollValue: 20), Dice(numberOfSides: .D4, rollValue: 4)], total: 44),
                Roll(dices: [Dice(numberOfSides: .D6, rollValue: 4), Dice(numberOfSides: .D6, rollValue: 5)], total: 9),
                Roll(dices: [Dice(numberOfSides: .D8, rollValue: 7)], total: 7),
                Roll(dices: [Dice(numberOfSides: .D10, rollValue: 3), Dice(numberOfSides: .D4, rollValue: 2)], total: 5),
                Roll(dices: [Dice(numberOfSides: .D20, rollValue: 18), Dice(numberOfSides: .D6, rollValue: 6), Dice(numberOfSides: .D6, rollValue: 6)], total: 24),
                Roll(dices: [Dice(numberOfSides: .D12, rollValue: 11)], total: 11),
                Roll(dices: [Dice(numberOfSides: .D4, rollValue: 1), Dice(numberOfSides: .D4, rollValue: 4)], total: 5),
                Roll(dices: [Dice(numberOfSides: .D8, rollValue: 8), Dice(numberOfSides: .D6, rollValue: 6)], total: 14),
                Roll(dices: [Dice(numberOfSides: .D10, rollValue: 9)], total: 9),
                Roll(dices: [Dice(numberOfSides: .D20, rollValue: 20)], total: 20)
            ]
        }
    }
}


#Preview {
    HistorySheet()
}
