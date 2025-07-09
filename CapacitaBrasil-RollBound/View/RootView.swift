//
//  RootView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 01/07/25.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .dices
    @ObservedObject var rollViewModel = RollViewModel.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .initiative:
                    InitiativeView()
                case .dices:
                    DicesView()
                case .characters:
                    CharactersView()
                }
            }

            if rollViewModel.state == .idle {
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}



#Preview {
    RootView()
}
