//
//  OnboardingWelcomeView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 21/07/25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            VStack {
                Text("Bem-Vindo ao")
                    .font(.custom("Sora", size: 17))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.AppColors.active)
                
                Spacer()
                
                Image("Onboarding-Illustration1")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
            .padding()
            .padding(.top)
        }
    }
}

#Preview {
    OnboardingWelcomeView()
}
