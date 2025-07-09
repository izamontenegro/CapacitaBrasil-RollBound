//
//  DiceSelectCarouselView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 09/07/25.
//

import SwiftUI

struct CenteredDicePreferenceKey: PreferenceKey {
    static var defaultValue: Int? = nil

    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        if let next = nextValue() {
            value = next
        }
    }
}

struct DiceSelectedCarouselView: View {
    @Binding var selectedDices: [Dice]
    @ObservedObject var rollViewModel: RollViewModel
    
    @State private var centeredIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width / 2 - 120)

                    ForEach(Array(selectedDices.reversed().enumerated()), id: \.element.id) { offset, dice in
                        let actualIndex = selectedDices.count - 1 - offset
                        
                        Image(dice.numberOfSides.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .opacity(centeredIndex == actualIndex ? 1.0 : 0.4)
                            .id(dice.id)
                            .onTapGesture {
                                if centeredIndex == actualIndex {
                                    withAnimation(.spring()) {
                                        selectedDices.remove(at: actualIndex)
                                    }
                                }
                            }
                            .transition(.scale(scale: 0.05).combined(with: .opacity))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedDices)
                            .background(
                                GeometryReader { itemGeo in
                                    Color.clear.preference(
                                        key: CenteredDicePreferenceKey.self,
                                        value: {
                                            let itemMidX = itemGeo.frame(in: .named("carousel")).midX
                                            let scrollMidX = UIScreen.main.bounds.width / 2
                                            let distance = abs(itemMidX - scrollMidX)
                                            return distance < 130 / 2 ? actualIndex : nil
                                        }()
                                    )
                                }
                            )
                    }

                    Spacer()
                        .frame(width: UIScreen.main.bounds.width / 2 - 130 / 2)
                }
                .frame(height: 150)
            }
            .coordinateSpace(name: "carousel")
            .onPreferenceChange(CenteredDicePreferenceKey.self) { index in
                centeredIndex = index
            }
            .onChange(of: selectedDices) {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        if let last = selectedDices.last {
                            proxy.scrollTo(last.id, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}
