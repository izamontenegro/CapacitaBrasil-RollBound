//
//  SegmentedControl.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var selectedTab: SkillTabOptions
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    selectedTab = .skills
                }
            }, label: {
                Text("Skills")
                    .font(.custom("Sora", size: 21))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppColors.active)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background {
                if selectedTab == .skills {
                    Color.AppColors.primary
                        .cornerRadius(10)
                } else {
                    Color.clear
                }
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = .save
                }
            }, label: {
                Text("Salvar")
                    .font(.custom("Sora", size: 21))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppColors.active)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background {
                if selectedTab == .save {
                    Color.AppColors.primary
                        .cornerRadius(10)
                } else {
                    Color.clear
                }
            }
        }
        .padding(10)
        .background {
            Color.AppColors.secondary
        }
        .cornerRadius(15)
    }
}


