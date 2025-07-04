//
//  CustomTabBarView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer() 

                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack(spacing: 4) {
                            Image(selectedTab == tab ? tab.activeIcon : tab.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color.AppColors.active)
                            
                            Text(tab.title)
                                .font(.custom("Sora", size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color.AppColors.active)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top)
            .background(
                Color.AppColors.primary
                    .ignoresSafeArea(edges: .bottom)
                
            )
        }
    }
}


enum Tab: CaseIterable {
    case initiative, dices, characters

    var title: String {
        switch self {
        case .initiative: "Iniciativa"
        case .dices: "Dados"
        case .characters: "Personagens"
        }
    }

    var icon: String {
        switch self {
        case .initiative: "PaperIcon"
        case .dices: "DiceIcon"
        case .characters: "GroupIcon"
        }
    }
    
    var activeIcon: String {
        switch self {
        case .initiative: "PaperFillIcon"
        case .dices: "DiceFillIcon"
        case .characters: "GroupFillIcon"
        }
    }
}
