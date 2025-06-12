//
//  PrimaryButton.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/06/25.
//

import SwiftUI

struct PrimaryButton: View {
    @State var isActive: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("Adicionar")
                .lineLimit(1)
                .font(.custom("Sora", size: 21))
                .foregroundStyle(Color.AppColors.primary)
                .fontWeight(.bold)
                .padding()
                .background {
                    isActive ? Color.AppColors.active : Color.AppColors.unactive
                }
                .cornerRadius(18)
        })
        .disabled(!isActive)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PrimaryButton(action: {
        print("Ação do botão!")
    })
}
