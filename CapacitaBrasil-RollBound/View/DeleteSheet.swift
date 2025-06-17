//
//  DeleteSheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/06/25.
//

import SwiftUI
import SwiftData

struct DeleteSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @ObservedObject var entityViewModel = EntityViewModel.shared
    
    @Binding var selectedEntity: Entity
    
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(edges: .all)
            VStack(spacing: 51) {
                Text("Deletar personagem")
                    .font(.custom("Sora", size: 28))
                    .foregroundStyle(Color.AppColors.active)
                    .fontWeight(.bold)

                Group {
                    Text("Essa ação é ") +
                    Text("permanente ").fontWeight(.bold) +
                    Text("e ") +
                    Text("irreversível. ").fontWeight(.bold) +
                    Text("Tem certeza que deseja deletar ") +
                    Text("\(selectedEntity.name)").fontWeight(.bold) +
                    Text("?")
                }
                .font(.custom("Sora", size: 16))
                .foregroundStyle(Color.AppColors.active)
                
                VStack(spacing: 10) {
                    DestructiveButton(label: "Deletar", action: {
                        entityViewModel.deleteEntity(context: context, entity: selectedEntity)
                        dismiss()
                    })
                    .padding(.horizontal)
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancelar")
                            .font(.custom("Sora", size: 21))
                            .underline(true, color: Color.AppColors.active)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.AppColors.active)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedEntity: Entity = Entity(name: "Joana", photo: nil, health: 90, defense: 30, type: .character)
    DeleteSheet(selectedEntity: $selectedEntity)
}
