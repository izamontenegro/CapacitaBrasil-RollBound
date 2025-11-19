//
//  AddEntitySheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 20/06/25.
//
import SwiftUI
import SwiftData
import SwiftUI
import PhotosUI

struct AddEntitySheet: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var entityType: EntityType
    
    @State var entityName: String = ""
    @State var hpValue: Int = 1
    @State var defenseValue: Int = 1
    
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
                
                Text("Adicionar \(entityType.displayText)")
                    .font(.custom("Sora", fixedSize: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(entityType == .character ? Color.AppColors.active : Color.AppColors.enemy)
                
                CustomTextfield(fieldName: "Nome do \(entityType.displayText)", input: $entityName)
                    .padding(.horizontal)
                
                HStack {
                    AttributeSelector(selectedValue: $hpValue, type: .hp)
                    
                    Spacer()
                    
                    AttributeSelector(selectedValue: $defenseValue, type: .defense)
                }
                .padding(.horizontal)
                
                PrimaryButton(label: "Adicionar", isActive: entityName != "", action: {
                    entityViewModel.createEntity(
                        context: context,
                        name: entityName,
                        photo: selectedImageData,
                        health: hpValue,
                        defense: defenseValue,
                        type: entityType
                    )
                    dismiss()
                })
                .id(entityName)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddEntitySheet(entityType: .character)
}

