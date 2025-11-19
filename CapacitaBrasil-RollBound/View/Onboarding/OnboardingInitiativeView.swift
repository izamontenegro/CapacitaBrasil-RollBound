//
//  OnboardingCombatView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 21/07/25.
//

import SwiftUI

struct OnboardingInitiativeView: View {
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
                
                Spacer()
                
                Image("Onboarding-Illustration2")
                
                (
                    Text("Controle a ").fontWeight(.semibold)
                    + Text("Iniciativa").fontWeight(.black)
                    + Text(" da sua party e adicione ").fontWeight(.semibold)
                    + Text("Inimigos").fontWeight(.black)
                )
                .font(.custom("Sora", size: 17))
                .foregroundStyle(Color.AppColors.active)
                .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .padding(.top)
        }
    }
}

#Preview {
    OnboardingInitiativeView()
}
