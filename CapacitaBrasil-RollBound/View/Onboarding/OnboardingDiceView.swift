//
//  OnboardingDiceView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 21/07/25.
//

import SwiftUI

struct OnboardingDiceView: View {
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
                
                Image("Onboarding-Illustration3")
                
                (
                    Text("Role seis diferentes tipos de ").fontWeight(.semibold)
                    + Text("Dados").fontWeight(.black)
                    + Text(", verifique seu").fontWeight(.semibold)
                    + Text(" Histórico").fontWeight(.black)
                    + Text(" de rolagem e salve").fontWeight(.semibold)
                    + Text(" Habilidades").fontWeight(.black)
                    
                )
                .font(.custom("Sora", size: 17))
                .foregroundStyle(Color.AppColors.active)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
            .padding(.top)
        }
    }
}

#Preview {
    OnboardingDiceView()
}
