//
//  SwipeInitiativeCard.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 25/06/25.
//
import SwiftUI

struct Entityy: Identifiable, Equatable {
    let id = UUID()
    var name: String
}

struct DragReorderView: View {
    @State var onDelete: () -> Void =  {
        
    }
    @State var showEditSheet: Bool = false
    
    private let swipeThreshold: CGFloat = -90
    @State private var offsetX: CGFloat = 0
    @GestureState private var isDragging = false
    
    @State private var entities: [Entityy] = [
        .init(name: "Kleber Banban"),
        .init(name: "Yves Klavidian"),
        .init(name: "Jairzinho")
    ]
    
    @State private var draggingEntity: Entityy?
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 12) {
            ForEach(entities) { entity in
                ZStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button(action: {
                            onDelete()
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
                          showEditSheet = true
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
                Text(entity.name)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(draggingEntity?.id == entity.id ? Color.gray.opacity(0.3) : Color.blue)
                    .cornerRadius(10)
                    .offset(y: draggingEntity?.id == entity.id ? dragOffset : 0)
                    .zIndex(draggingEntity?.id == entity.id ? 1 : 0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                draggingEntity = entity
                                dragOffset = value.translation.height

                                if let fromIndex = entities.firstIndex(of: entity) {
                                    let toIndex = calculateTargetIndex(from: fromIndex, drag: value.translation.height)
                                    if fromIndex != toIndex {
                                        withAnimation {
                                            entities.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                                        }
                                    }
                                }
                            }
                            .onEnded { _ in
                                draggingEntity = nil
                                dragOffset = 0
                            }
                    )
            }
        }
        .padding()
    }

    private func calculateTargetIndex(from currentIndex: Int, drag: CGFloat) -> Int {
        let rowHeight: CGFloat = 72
        let offset = Int((drag / rowHeight).rounded())
        return max(0, min(entities.count - 1, currentIndex + offset))
    }
}

#Preview {
    DragReorderView()
}
