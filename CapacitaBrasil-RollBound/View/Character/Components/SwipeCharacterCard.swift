//
//  EntityCard.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/06/25.
//
import SwiftUI

struct SwipeCharacterCard: View {
    @State var entity: Entity
    @Binding var showDeleteSheet: Bool
    
    var editAction: () -> Void
    
    private let swipeThreshold: CGFloat = -90
    @State private var offsetX: CGFloat = 0
    @GestureState private var isDragging = false
    
    init(entity: Entity, showDeleteSheet: Binding<Bool>, editAction: @escaping () -> Void) {
        self.entity = entity
        self._showDeleteSheet = showDeleteSheet
        self.editAction = editAction
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: {
                    showDeleteSheet = true
                }) {
                    HStack {
                        Text("Deletar")
                            .font(.custom("Sora", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(Color.AppColors.primary)
                            .padding()
                    }
                    .frame(minHeight: 100)
                    .background(Color.AppColors.red)
                }
            }
            
            HStack(spacing: 15) {
                if let photoData = entity.photo,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(Color.AppColors.active)
                        
                        Image("UserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundStyle(Color.AppColors.primary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {

                    Text("HP: \(entity.name)")
                        .font(.custom("Sora", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(entity.type == .initiative ? Color.AppColors.enemy : Color.AppColors.active)
                    
                    HStack {
                        HStack(spacing: 2) {
                            Text("HP: \(entity.health.description)")
                                .font(.custom("Sora", size: 14))
                                .fontWeight(.bold)
                            
                            Image("HeartIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                            
                        }
                        .foregroundStyle(Color.AppColors.red)
                        
                        HStack(spacing: 2) {
                            Text("DEF: \(entity.defense.description)")
                                .font(.custom("Sora", size: 14))
                                .fontWeight(.bold)
                            
                            Image("ShieldIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                            
                        }
                        .foregroundStyle(Color.AppColors.blue)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    editAction()
                }, label: {
                    Image("EditIcon")
                        .foregroundStyle(Color.AppColors.active)
                })
            }
            .padding(20)
            .background(Color.AppColors.primary)
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offsetX = max(value.translation.width, swipeThreshold - 40)
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < swipeThreshold {
                            offsetX = swipeThreshold
                        } else {
                            offsetX = 0
                        }
                    }
            )
            .animation(.spring(), value: offsetX)
        }
    }
}
