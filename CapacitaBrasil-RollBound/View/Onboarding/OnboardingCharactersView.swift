//
//  OnboardingCharactersView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 21/07/25.
//

import SwiftUI

struct OnboardingCharactersView: View {
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
                
                Image("Onboarding-Illustration4")
                
                Spacer()
                
                (
                    Text("Adicione os ").fontWeight(.semibold)
                    + Text("Personagens ").fontWeight(.black)
                    + Text("da sua party e configure seus  ").fontWeight(.semibold)
                    + Text("Status").fontWeight(.black)
                    
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
    OnboardingCharactersView()
}
