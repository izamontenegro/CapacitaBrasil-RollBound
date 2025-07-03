//
//  DiceSelect.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/06/25.
//
import SwiftUI

struct DiceSelector: View {
    @Binding var selectedDices: [DiceSides]
    @State private var tappedDice: DiceSides? = nil
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(DiceSides.allCases, id: \.self) { side in
                Button(action: {
                    tappedDice = side
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                        selectedDices.append(side)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tappedDice = nil
                    }
                }, label: {
                    VStack {
                        Text(side.rawValue)
                            .font(.custom("Sora", size: 18))
                            .foregroundStyle(Color.AppColors.active)
                            .fontWeight(.bold)
                        Image(side.rawValue)
                            .resizable()
                            .scaledToFit()
                    }
                    .padding()
                    .background {
                        Color.AppColors.primary
                    }
                    .cornerRadius(9)
                    .scaleEffect(tappedDice == side ? 0.85 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: tappedDice == side)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background {
            Color.AppColors.secondary
        }
        .cornerRadius(9)
    }
}

#Preview {
    @Previewable @State var selectedDices: [DiceSides] = []
    DiceSelector(selectedDices: $selectedDices)
}
