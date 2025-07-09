//
//  DicesView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct DicesView: View {
    @Environment(\.modelContext) var context
    @ObservedObject var skillViewModel = SkillViewModel.shared
    @ObservedObject var rollViewModel = RollViewModel.shared
    
    @State var selectedDices: [Dice] = []
    
    @State var showHistorySheet: Bool = false
    @State var showSkillsSheet: Bool = false
    @State var selectedSkillSheetTab: SkillTabOptions = .skills
    
    @State private var currentGradientColors: [Color] = [Color.AppColors.active, Color.AppColors.active]
    
    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea(.all)
            
            VStack {
                DiceViewHeader(selectedDices: $selectedDices)
                
                Spacer()
                
                DiceCarouselView(
                    selectedDices: $selectedDices,
                    rollViewModel: rollViewModel,
                    currentGradientColors: $currentGradientColors
                )
                
                
                if rollViewModel.state == .idle {
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
                        Image(selectedDices.last?.numberOfSides.rawValue ?? "Dice4")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 130)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    selectedDices.removeLast()
                                    return
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.6).combined(with: .opacity),
                                removal: .scale(scale: 0.05).combined(with: .opacity)
                            ))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedDices)
                            .id(selectedDices.count)
                    }
                }
                
                Spacer()
                
                DiceActionButtonsView(showHistorySheet: $showHistorySheet, showSkillsSheet: $showSkillsSheet, selectedDices: $selectedDices)
            }
            .padding()
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 50)
            }
            .onChange(of: selectedDices) {
                selectedSkillSheetTab = selectedDices.isEmpty ? .skills : .save
            }
            .onAppear {
                skillViewModel.fetchAllSkills(context: context)
                rollViewModel.fetchAllRolls(context: context)
            }
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
}
