//
//  HistorySheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/06/25.
//
import SwiftUI

struct HistorySheet: View {
    @ObservedObject var rollViewModel: RollViewModel = RollViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            
            if rollViewModel.rolls.isEmpty {
                VStack(spacing: 20) {
                    ZStack {
                        Text("Ultimas \(rollViewModel.rolls.count) Rolagens")
                            .font(.custom("Sora", size: 21))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.AppColors.active)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image("CloseIcon").foregroundStyle(Color.AppColors.active)
                            })
                        }
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Image("HistoricoEmptyState")
                    
                    Text("Adicione Dados a fila para salvar a rolagem")
                        .font(.custom("Sora", fixedSize: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.AppColors.emptyState)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
                
            } else {
                VStack {
                    ZStack {
                        Text("Ultimas \(rollViewModel.rolls.count) Rolagens")
                            .font(.custom("Sora", size: 21))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.AppColors.active)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image("CloseIcon").foregroundStyle(Color.AppColors.active)
                            })
                        }
                    }
                    .padding()
                    .padding(.top)
                    
                    ScrollView(.vertical) {
                        ForEach(rollViewModel.rolls, id: \.self) { roll in
                            VStack {
                                HistoryCard(roll: roll)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 4)
                                    .foregroundStyle(Color.AppColors.secondary)
                                    .padding(.top, 16)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}


#Preview {
    HistorySheet()
}
