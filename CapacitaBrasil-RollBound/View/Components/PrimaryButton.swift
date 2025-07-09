//
//  PrimaryButton.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/06/25.
//

import SwiftUI

struct PrimaryButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(label)
                .lineLimit(1)
                .font(.custom("Sora", size: 21))
                .foregroundStyle(Color.AppColors.primary)
                .fontWeight(.bold)
                .padding(.vertical, 11)
                .padding(.horizontal, 22)
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
    @Previewable @State var label: String = "Adicionar"
    
    PrimaryButton(label: label, isActive: true, action: {
        print("Ação do botão!")
    })
}
