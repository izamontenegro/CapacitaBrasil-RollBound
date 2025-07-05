//
//  DicesView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct DicesView: View {
    @ObservedObject var skillViewModel = SkillViewModel.shared
    @ObservedObject var rollViewModel = RollViewModel.shared
    
    @Environment(\.modelContext) var context
    
    @State var selectedDices: [Dice] = []
    @State var showHistorySheet: Bool = false
    @State var showSkillsSheet: Bool = false
    @State var selectedSkillSheetTab: SkillTabOptions = .skills
    
    var isCurrentDiceIndexValid: Bool {
        (0..<selectedDices.count).contains(rollViewModel.currentDiceIndex)
    }
    
    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea(.all)
            
            VStack {
                if !rollViewModel.isRolling {
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
                
                Spacer()
                
                if rollViewModel.isRolling && isCurrentDiceIndexValid {
                    Text("\(rollViewModel.displayedValue)")
                        .font(.custom("Sora", size: 155))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                        .frame(height: 180)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 60) {
                                ForEach(Array(selectedDices.reversed().enumerated()), id: \.offset) { index, dice in
                                    VStack(spacing: 12) {
                                        Image(dice.numberOfSides.rawValue)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 130)
                                            .opacity(index == rollViewModel.currentDiceIndex ? 1.0 : 0.4)
                                        
                                        Text(dice.numberOfSides.rawValue.uppercased())
                                            .font(.custom("Sora", size: 14))
                                            .foregroundStyle(index == rollViewModel.currentDiceIndex ? Color.AppColors.active : Color.AppColors.secondary)
                                            .opacity(index == rollViewModel.currentDiceIndex ? 1.0 : 0.4)
                                    }
                                    .id(index)
                                    .frame(width: 120)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        .frame(height: 260)
                        .onAppear {
                            scrollToLastDice(proxy: proxy)
                        }
                        .onChange(of: rollViewModel.currentDiceIndex) {
                            scrollToCurrentDice(proxy: proxy)
                        }
                    }
                }
                
                if !rollViewModel.isRolling {
                    if selectedDices.isEmpty {
                        VStack {
                            Text("Selecione um Dado para Rolar")
                                .font(.custom("Sora", size: 17))
                                .fontWeight(.bold)
                                .foregroundStyle(Color.AppColors.secondary)
                            Image("DadosEmptyState")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(maxHeight: 130)
                    } else {
                        VStack {
                            Image(selectedDices.last?.numberOfSides.rawValue ?? "Dice4")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 130)
                        }
                    }
                }
                
                Spacer()
                
                if !rollViewModel.isRolling {
                    HStack(spacing: 11) {
                        Button(action: {
                            showHistorySheet = true
                        }, label: {
                            Image("HistoryIcon")
                        })
                        
                        PrimaryButton(label: "Rolar", isActive: true, action: {
                            Task {
                                let sides = selectedDices.map { $0.numberOfSides }
                                await rollViewModel.rollDices(context: context, dices: sides)
                                selectedDices = []
                            }
                        })
                        
                        Button(action: {
                            showSkillsSheet = true
                        }, label: {
                            Image("SaveIcon")
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .onChange(of: selectedDices) {
                selectedSkillSheetTab = selectedDices.isEmpty ? .skills : .save
            }
            .onAppear {
                skillViewModel.fetchAllSkills(context: context)
                rollViewModel.fetchAllRolls(context: context)
            }
            
            buildSheets()
        }
    }
    
    
    private func scrollToCurrentDice(proxy: ScrollViewProxy) {
        guard isCurrentDiceIndexValid else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(selectedDices.count - 1 - rollViewModel.currentDiceIndex, anchor: .center)
        }
    }
    
    private func scrollToLastDice(proxy: ScrollViewProxy) {
        guard !selectedDices.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(selectedDices.count - 1, anchor: .trailing)
        }
    }
    
    @ViewBuilder
    private func buildSheets() -> some View {
        EmptyView()
            .sheet(isPresented: $showHistorySheet) {
                HistorySheet()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showSkillsSheet) {
                SkillsSheet(selectedTab: $selectedSkillSheetTab, selectedDices: selectedDices)
                    .presentationDetents([.fraction(0.7)])
            }
    }
}
