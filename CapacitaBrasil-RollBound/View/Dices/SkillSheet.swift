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
    @Environment(\.modelContext) var context

    @Binding var selectedTab: SkillTabOptions
    @State var selectedDices: [Dice]
    @State var skillName: String = ""

    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                SkillSheetHeader(dismiss: dismiss, selectedTab: $selectedTab)
                    .padding(.bottom)

                switch selectedTab {
                case .skills:
                    if skillViewModel.skills.isEmpty {
                        SkillEmptyStateView()
                    } else {
                        ScrollView(.vertical) {
                            VStack {
                                ForEach(skillViewModel.skills, id: \.self) { skill in
                                    VStack {
                                        Button(action: { }, label: {
                                            SkillSheetCard(skill: skill)
                                        })
                                        .padding(.horizontal)
                                        .padding(.top, 25)

                                        Rectangle()
                                            .frame(maxWidth: .infinity, maxHeight: 4)
                                            .foregroundStyle(Color.AppColors.secondary)
                                    }
                                }
                            }
                        }
                    }

                case .save:
                    if selectedDices.isEmpty {
                        SaveSkillEmptyStateView()
                    } else {
                        VStack(spacing: 40) {
                            CustomTextfield(fieldName: "Nome da Skill", input: $skillName)
                                .padding(.horizontal)
                                .padding(.top, 25)

                            ScrollView(.horizontal) {
                                VStack(spacing: 25) {
                                    HStack {
                                        Text(diceDescription(for: selectedDices))
                                            .font(.custom("Sora", size: 18))
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.AppColors.active)
                                        Spacer()
                                    }
                                    HStack(spacing: 15) {
                                        ForEach(selectedDices, id: \.self) { dice in
                                            Image(dice.numberOfSides.rawValue)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 65)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            PrimaryButton(label: "Salvar rolagem", isActive: !skillName.isEmpty, action: {
                                skillViewModel.createSkill(context: context, skillName: skillName, dices: selectedDices)
                                dismiss()
                            })
                            .id(skillName)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

private struct SkillEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("SalvosEmptyState")
            Text("Você ainda não tem nenhuma Skill salva")
                .font(.custom("Sora", fixedSize: 16))
                .fontWeight(.bold)
                .foregroundStyle(Color.AppColors.emptyState)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

private struct SaveSkillEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("SkillEmptyState")
            Text("Adicione Dados a fila para salvar a rolagem")
                .font(.custom("Sora", fixedSize: 16))
                .fontWeight(.bold)
                .foregroundStyle(Color.AppColors.emptyState)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}
