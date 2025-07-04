//
//  DicesView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct DicesView: View {
    @State var selectedDices: [DiceSides] = []
    @State var showHistorySheet: Bool = false
    @State var showSkillsSheet: Bool = false
    @State var selectedSkillSheetTab: SkillTabOptions = .skills

    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea(.all)
            
            VStack() {
                Text("Nova rolagem")
                    .font(.custom("Sora", size: 22))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppColors.active)
                    .padding()

                DiceSelector(selectedDices: $selectedDices)
                
                Spacer()
                
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
                        Image(selectedDices.last?.rawValue ?? "Dice4")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 130)
                    }
                }
                
                Spacer()

                HStack(spacing: 11) {
                    Button(action: {
                        showHistorySheet = true
                    }, label: {
                        Image("HistoryIcon")
                    })
                    
                    PrimaryButton(label: "Rolar", isActive: !selectedDices.isEmpty, action: {
                        // iniciar rolagem aqui
                    })
                    
                    Button(action: {
                        showSkillsSheet = true
                    }, label: {
                        Image("SaveIcon")
                    })
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .sheet(isPresented: $showHistorySheet, content: {
                HistorySheet()
                    .presentationDetents([.medium, .large])
            })
            .sheet(isPresented: $showSkillsSheet, content: {
                SkillsSheet(selectedTab: $selectedSkillSheetTab, selectedDices: selectedDices)
                    .presentationDetents([.medium, .large])
            })
            .onChange(of: selectedDices, {
                if selectedDices.isEmpty {
                    selectedSkillSheetTab = .skills
                } else {
                    selectedSkillSheetTab = .save
                }
            })
        }
    }
}

#Preview {
    DicesView()
}
