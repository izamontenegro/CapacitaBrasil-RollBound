//
//  DestructiveButton.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/06/25.
//
import SwiftUI

struct DestructiveButton: View {
    @State var label: String
    @State var action: () -> Void 
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Spacer()
                Text(label)
                    .font(.custom("Sora", size: 21))
                    .foregroundStyle(Color.AppColors.primary)
                    .fontWeight(.bold)
                Spacer()
            }
                .padding()
                .background {
                    Color.AppColors.red
                }
                .cornerRadius(18)
        })
    }
}

#Preview {
    @Previewable @State var label: String = "Deletar"
    
    DestructiveButton(label: label, action: {
        print("Deletar")
    })
    .padding(.horizontal)
}
