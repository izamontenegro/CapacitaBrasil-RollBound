//
//  RootView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 01/07/25.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .initiative
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .initiative:
                    InitiativeView()
                case .dices:
                    EmptyView()
                case .characters:
                    CharactersView()
                }
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    RootView()
}
