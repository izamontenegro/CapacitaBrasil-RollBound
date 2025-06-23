//
//  HistoryCard.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//
import SwiftUI

struct HistoryCard: View {
    @State var roll: Roll
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text(diceDescription(for: roll))
                    .font(.custom("Sora", size: 18))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppColors.active)
                
                Spacer()
                
                Text("SUM: \(roll.total)")
                    .font(.custom("Sora", size: 18))
                    .foregroundStyle(Color.AppColors.primary)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background {
                        Color.AppColors.active
                    }
                    .cornerRadius(5)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    let groupedDices = Dictionary(grouping: roll.dices, by: { $0.numberOfSides })
                    
                    ForEach(groupedDices.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { key, dices in
                        VStack {
                            HStack {
                                ForEach(dices, id: \.self) { dice in
                                    ZStack {
                                        Image(dice.numberOfSides.rawValue)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 65, height: 65)
                                        
                                        Text("\(dice.rollValue)")
                                            .font(.custom("Sora", size: 24))
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.AppColors.secondary)
                                    }
                                }
                            }
                            
                            Text(key.rawValue)
                                .font(.custom("Sora", size: 16))
                                .fontWeight(.bold)
                                .foregroundStyle(Color.AppColors.active)
                        }
                        .padding(8)
                        .background(Color.AppColors.secondary)
                        .cornerRadius(15)
                    }
                }
            }
        }
    }
    
    func diceDescription(for roll: Roll) -> String {
        let counts = Dictionary(grouping: roll.dices, by: { $0.numberOfSides })
            .mapValues { $0.count }

        let parts = counts.map { "\($0.value)\($0.key.rawValue)" }
            .sorted()

        return parts.joined(separator: " + ")
    }
}
