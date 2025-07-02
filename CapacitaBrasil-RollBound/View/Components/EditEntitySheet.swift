//
//  EditEntitySheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 25/06/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditEntitySheet: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var entity: Entity
    
    @Binding var showDeleteSheet: Bool
    
    @State var entityName: String = ""
    @State var hpValue: Int = 0
    @State var defenseValue: Int = 0
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        ZStack {
            Color.AppColors.primary
                .ignoresSafeArea(.all)
            
            VStack(spacing: 35) {
                ZStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        ZStack {
                            if let data = selectedImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } else if let data = entity.photo,
                                      let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .frame(width: 150)
                                    .foregroundStyle(Color.AppColors.superUnactive)
                                
                                Image("PenIcon")
                                    .foregroundStyle(Color.AppColors.active)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                withAnimation {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Button {
                            dismiss()
                            showDeleteSheet = true
                            print(showDeleteSheet)
                        } label: {
                            Image("TrashIcon")
                                .foregroundStyle(Color.AppColors.red)
                        }
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image("CloseIcon")
                                .foregroundStyle(Color.AppColors.active)
                        }
                    }
                    .padding()
                }
                
                Text("Editar \(entity.type.displayText)")
                    .font(.custom("Sora", fixedSize: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(entity.type == .character ? Color.AppColors.active : Color.AppColors.enemy)
                
                CustomTextfield(fieldName: "Nome do \(entity.type.displayText)", input: $entityName)
                    .padding(.horizontal)
                
                HStack {
                    AttributeSelector(selectedValue: $hpValue, type: .hp)
                    Spacer()
                    AttributeSelector(selectedValue: $defenseValue, type: .defense)
                }
                .padding(.horizontal)
                
                PrimaryButton(label: "Salvar", isActive: entityName != "", action: {
                    entityViewModel.updateEntity(
                        context: context,
                        entity: entity,
                        name: entityName,
                        photo: selectedImageData,
                        health: hpValue,
                        defense: defenseValue
                    )
                    dismiss()
                })
                .id(entityName)
            }
            .padding(.horizontal)
        }
        .onAppear {
            entityName = entity.name
            hpValue = entity.health
            defenseValue = entity.defense
        }
    }
}
