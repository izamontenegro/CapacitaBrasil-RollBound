//
//  SwipeInitiativeCard.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 25/06/25.
//
import SwiftUI

struct SwipeInitiativeCard: View {
    @State var entity: Entity
    
    var body: some View {
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
                
                Text("\(entity.name)")
                    .font(.custom("Sora", size: 18))
                    .fontWeight(.bold)
                    .lineLimit(1)
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
            
            Image("HamburguerMenuIcon")
                .foregroundStyle(Color.AppColors.active)
            
        }
        .padding(20)
        .background(Color.AppColors.primary)
    }
}
