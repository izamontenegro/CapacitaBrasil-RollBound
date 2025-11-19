//
//  OnboardingStartView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 21/07/25.
//

import SwiftUI

struct OnboardingStartView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            VStack {
                HStack(spacing: 0) {
                    Text("Bem-Vindo ao")
                        .font(.custom("Sora", size: 17))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.AppColors.active)
                    
                    Text(" RollBound")
                        .font(.custom("Sora", size: 17))
                        .fontWeight(.black)
                        .foregroundStyle(Color.AppColors.active)
                }
                
                Image("Onboarding-Illustration5")
                
                Spacer()
                
                Text("Comece a sua jornada no mundo dos Dados!")
                    .fontWeight(.semibold)
                    .font(.custom("Sora", size: 17))
                    .foregroundStyle(Color.AppColors.active)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                
                PrimaryButton(label: "Rolar", isActive: true, action: {
                    hasSeenOnboarding = true
                })
                .padding()
                
                Spacer()
            }
            .padding()
            .padding(.top)
        }
    }
}

#Preview {
    OnboardingStartView()
}
