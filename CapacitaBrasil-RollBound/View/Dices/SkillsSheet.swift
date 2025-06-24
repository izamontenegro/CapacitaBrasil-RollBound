//
//  SkillsSheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//

import SwiftUI

enum SkillTabOptions {
    case skills
    case save
}

struct SkillsSheet: View {
    @ObservedObject var skillViewModel: SkillViewModel = SkillViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedTab: SkillTabOptions
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image("CloseIcon").foregroundStyle(Color.AppColors.active)
                        })
                    }
                    .padding(.horizontal)
                    
                    SegmentedControl(selectedTab: $selectedTab)
                }
                
                ForEach(skillViewModel.skills, id: \.self) { skill in
                    SkillCard(skill: skill)
                }
            }
        }
    }
}

struct skill: View {
    @ObservedObject var skillViewModel: SkillViewModel = SkillViewModel.shared
    @State var selectedTab: SkillTabOptions = .skills
    @State var showSheet: Bool = true
    var body: some View {
        VStack {
            Button(action: {
                showSheet = true
            }, label: {
                Text("Abrir sheet")
            })
        }
        .sheet(isPresented: $showSheet, content: {
            SkillsSheet(selectedTab: $selectedTab)
                .presentationDetents([.medium, .large])
        })
        .onAppear {
            skillViewModel.skills = [
                Skill(
                    dices: [
                        Dice(numberOfSides: .D20, rollValue: 12),
                        Dice(numberOfSides: .D20, rollValue: 8),
                        Dice(numberOfSides: .D20, rollValue: 20),
                        Dice(numberOfSides: .D4, rollValue: 4)
                    ],
                    skillName: "Skill 1"
                ),
                Skill(
                    dices: [
                        Dice(numberOfSides: .D6, rollValue: 5),
                        Dice(numberOfSides: .D6, rollValue: 3),
                        Dice(numberOfSides: .D8, rollValue: 7)
                    ],
                    skillName: "Skill 2"
                ),
                Skill(
                    dices: [
                        Dice(numberOfSides: .D12, rollValue: 11),
                        Dice(numberOfSides: .D10, rollValue: 9)
                    ],
                    skillName: "Skill 3"
                )
            ]
        }
    }
}

#Preview {
    skill()
}
