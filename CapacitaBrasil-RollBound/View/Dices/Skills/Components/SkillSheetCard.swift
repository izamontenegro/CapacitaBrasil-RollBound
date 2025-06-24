//
//  SkillCard.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//
import SwiftUI
import SwiftData

struct SkillSheetCard: View {
    @ObservedObject var skillViewModel = SkillViewModel.shared
    @Environment(\.modelContext) var context
    @State var skill: Skill
    var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Text(skill.skillName)
                        .font(.custom("Sora", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.active)
                    
                    Spacer()
                    
                    Button(action: {
                        skillViewModel.deleteSkill(context: context, skill: skill)
                    }, label: {
                        Image("TrashIcon")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.AppColors.red)
                            .frame(width: 30)
                    })
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(skill.dices) { dice in
                            Image(dice.numberOfSides.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65)
                        }
                    }
                }
            }
        .padding(.bottom, 20)
    }
}
