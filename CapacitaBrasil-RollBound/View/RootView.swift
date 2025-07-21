//
//  RootView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 01/07/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Tab = .dices
    @ObservedObject var rollViewModel = RollViewModel.shared
    
    var body: some View {
        if hasSeenOnboarding {
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
        } else {
            ZStack {
                Color.AppColors.primary.ignoresSafeArea()
                TabView {
                    OnboardingWelcomeView()
                    OnboardingInitiativeView()
                    OnboardingDiceView()
                    OnboardingCharactersView()
                    OnboardingStartView()
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        
    }
}



#Preview {
    RootView()
}
