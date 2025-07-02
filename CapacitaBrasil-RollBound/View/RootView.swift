//
//  RootView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 01/07/25.
//

import SwiftUI

struct RootView: View {
    
    @State private var selectedTab: Tab = .dices
    var body: some View {
        TabView(selection: $selectedTab) {
            InitiativeView()
                .tabItem {
                    VStack {
                        Image(selectedTab == .initiative ? "PaperFillIcon" : "PaperIcon")
                            .renderingMode(.template)
                        Text("Início")
                            .font(.custom("Sora", size: 12))
                            .fontWeight(.bold)
                    }
                }
                .tag(Tab.initiative)
            
            InitiativeView()
                .tabItem {
                    VStack {
                        Image(selectedTab == .dices ? "DiceFillIcon" : "DiceIcon")
                            .renderingMode(.template)
                        Text("Explorar")
                            .font(.custom("Sora", size: 12))
                            .fontWeight(.bold)
                    }
                   
                }
                .tag(Tab.dices)
            
            InitiativeView()
                .tabItem {
                    VStack {
                        Image(selectedTab == .characters ? "GroupFillIcon" : "GroupIcon")
                            .renderingMode(.template)
                        Text("Perfil")
                            .font(.custom("Sora", size: 12))
                            .fontWeight(.bold)
                    }
                    .font(.custom("Sora", size: 13))
                }
                .tag(Tab.characters)
        }
    }
}

enum Tab {
    case initiative, dices, characters
}

#Preview {
    RootView()
}
