//
//  DicesView.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/07/25.
//

import SwiftUI

struct DicesView: View {
    @State var selectedDices: [DiceSides] = []
    
    @State var showHistorySheet: Bool = false
    @State var showSkillsSheet: Bool = false

    var body: some View {
        ZStack {
            Color.AppColors.primary.ignoresSafeArea(.all)
            
            VStack(spacing: 50) {
                Text("Nova rolagem")
                    .font(.custom("Sora", size: 22))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppColors.active)
                
                DiceSelector(selectedDices: $selectedDices)
                
                if selectedDices.isEmpty {
                    VStack {
                        Text("Selecione um Dado para Rolar")
                            .font(.custom("Sora", size: 17))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.AppColors.secondary)
                        
                        Image("DadosEmptyState")
                    }
                } else {
                    Image(selectedDices.last?.rawValue ?? "Dice4")
                    
                }
                
                HStack(spacing: 11) {
                    Button(action: {
                        showHistorySheet = true
                    }, label: {
                        Image("HistoryIcon")
                    })
                    
                    PrimaryButton(label: "Rolar", isActive: !selectedDices.isEmpty, action: {
                        // iniciar rolagem aqui
                    })
                    
                    Button(action: {
                        showSkillsSheet = true
                    }, label: {
                        Image("SaveIcon")
                    })
                }
            }
            .padding()
        }
    }
}

#Preview {
    DicesView()
}
