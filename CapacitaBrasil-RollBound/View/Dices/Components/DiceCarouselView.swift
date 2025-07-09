//
//  DiceCarouselView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 08/07/25.
//
import SwiftUI

private struct CenteredDicePreferenceKey: PreferenceKey {
    static var defaultValue: Int? = nil

    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        if let next = nextValue() {
            value = next
        }
    }
}

struct DiceCarouselView: View {
    @Binding var selectedDices: [Dice]
    @ObservedObject var rollViewModel: RollViewModel
    @Binding var currentGradientColors: [Color]
    
    var body: some View {
        if rollViewModel.state == .finished || rollViewModel.state == .rolling {
            ScrollViewReader { proxy in
                VStack(spacing: 90) {
                    Spacer()
                    
                    Text("\(rollViewModel.displayedValue)")
                        .font(.custom("Sora", size: 155))
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: currentGradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 180)
                    
                    VStack(spacing: 0) {
                        GeometryReader { geometry in
                            let screenCenter = geometry.size.width / 2
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 60) {
                                    ForEach(Array(selectedDices.reversed().enumerated()), id: \.offset) { index, dice in
                                        VStack(spacing: 12) {
                                            Image(dice.numberOfSides.rawValue)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 130)
                                                .opacity(isActive(index: index) ? 1.0 : 0.4)
                                            
                                            Text(dice.numberOfSides.rawValue.uppercased())
                                                .font(.custom("Sora", size: 28))
                                                .fontWeight(.bold)
                                                .opacity(isActive(index: index) ? 1.0 : 0.4)
                                                .foregroundStyle(isActive(index: index) ? Color.AppColors.active : Color.AppColors.secondary)
                                        }
                                        .background(
                                            GeometryReader { itemGeo in
                                                Color.clear.preference(
                                                    key: CenteredDicePreferenceKey.self,
                                                    value: {
                                                        let itemMidX = itemGeo.frame(in: .global).midX
                                                        let screenMidX = UIScreen.main.bounds.width / 2
                                                        let distance = abs(itemMidX - screenMidX)
                                                        return distance < 130 / 2 ? index : nil
                                                    }()
                                                )
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, screenCenter - 130 / 2)
                            }
                            .onChange(of: rollViewModel.displayedValue) {
                                guard rollViewModel.state == .rolling else { return }
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(rollViewModel.currentDiceIndex, anchor: .center)
                                }
                            }
                        }
                        .onPreferenceChange(CenteredDicePreferenceKey.self) { centeredIndex in
                            
                            guard let index = centeredIndex else { return }
                            
                            let realIndex = rollViewModel.rolledDices.count - 1 - index
                            
                            guard rollViewModel.rolledDices.indices.contains(realIndex) else { return }
                            
                            let visibleDice = rollViewModel.rolledDices[realIndex]
                            
                            rollViewModel.displayedValue = visibleDice.rollValue
                            
                            rollViewModel.currentValue = rollViewModel.rolledDices.suffix(from: realIndex).map { $0.rollValue }.reduce(0, +)
                            
                            rollViewModel.currentDiceIndex = index
                            
                            currentGradientColors = gradientCategory(for: visibleDice.rollValue, sides: visibleDice.numberOfSides.sides).colors
                        }
                        
                        Spacer()
                        
                        if rollViewModel.state == .finished {
                            PrimaryButton(label: "Nova rolagem", isActive: true) {
                                selectedDices.removeAll()
                                rollViewModel.state = .idle
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func isActive(index: Int) -> Bool {
        return index == rollViewModel.currentDiceIndex
    }
    
    private func gradientCategory(for value: Int, sides: Int) -> GradientCategory {
        if value == 1 {
            return .worst
        } else if value == sides {
            return .perfect
        } else if value <= sides / 2 {
            return .lowHalf
        } else {
            return .upperHalf
        }
    }
    
    enum GradientCategory {
        case worst, lowHalf, upperHalf, perfect

        var colors: [Color] {
            switch self {
            case .worst:
                return [Color.AppColors.worst1, Color.AppColors.worst2]
            case .lowHalf:
                return [Color.AppColors.lowHalf1, Color.AppColors.lowHalf2]
            case .upperHalf:
                return [Color.AppColors.upperHalf1, Color.AppColors.upperHalf2]
            case .perfect:
                return [Color.AppColors.perfect1, Color.AppColors.perfect2]
            }
        }
    }
}
