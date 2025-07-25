//
//  CustomSheet.swift
//  CapacitaBrasil-RollBound
//
//  Created by Ian Pacini on 18/07/25.
//

import SwiftUI
import PhotosUI


extension View {
    @ViewBuilder func customSheet(isPresented: Binding<Bool>, actionType: SheetActionType, entityType: EntityType) -> some View {
        
        self.privateCustomSheet(isPresented: isPresented,
                         actionType: actionType,
                         entity: .init(name: "",
                                       health: 1,
                                       defense: 1,
                                       type: entityType))
    }
    
    @ViewBuilder func customSheet(isPresented: Binding<Bool>, actionType: SheetActionType, entity: Entity) -> some View {
        
        self.privateCustomSheet(isPresented: isPresented,
                         actionType: actionType,
                         entity: entity)
    }
    
    @ViewBuilder private func privateCustomSheet(isPresented: Binding<Bool>, actionType: SheetActionType, entity: Entity) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
            }
            
            if isPresented.wrappedValue {
                CustomSheet(entity: entity,
                            actionType: .add) {
                    withAnimation {
                        isPresented.wrappedValue = false
                    }
                }
                            .ignoresSafeArea()
                
            }
        }
    }
}

enum SheetActionType {
    case add, editStats, editAll
}

struct CustomSheet: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context
    
    @State var entity: Entity
    let actionType: SheetActionType
    let onDismiss: () -> Void
    
    @State private var isDeleting: Bool = false
    
    init(entity: Entity, actionType: SheetActionType, onDismiss: @escaping () -> Void) {
        self.entity = entity
        self.actionType = actionType
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        if isDeleting {
            DeletingSheet(entity: entity, isDeleting: $isDeleting)
                .transition(.move(edge: .bottom))
        } else {
            EntitySheet(entity: entity,
                        isDeleting: $isDeleting,
                        actionType: actionType,
                        onDismiss: onDismiss)
            .transition(.move(edge: .bottom))
        }
    }
}

private struct EntitySheet: View {
    @ObservedObject var entityViewModel = EntityViewModel.shared
    @Environment(\.modelContext) var context
    
    @State var entity: Entity
    @Binding private var isDeleting: Bool
    let actionType: SheetActionType
    let onDismiss: () -> Void
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    let imageWidth: CGFloat = 150
    
    
    init(entity: Entity, isDeleting: Binding<Bool>, actionType: SheetActionType, onDismiss: @escaping () -> Void) {
        self.entity = entity
        self._isDeleting = isDeleting
        self.actionType = actionType
        self.onDismiss = onDismiss
        self.selectedImageData = entity.photo
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
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
                                .frame(width: imageWidth, height: imageWidth)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .foregroundStyle(Color.AppColors.primary)
                                .frame(width: imageWidth + 30, height: imageWidth + 30)
                                .overlay {
                                    Circle()
                                        .foregroundStyle(.gray)
                                        .overlay {
                                            Image("PenIcon")
                                        }
                                        .padding(15)
                                    
                                    Image("PenIcon")
                                        .foregroundStyle(Color.AppColors.active)
                                }
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
            }
            .offset(y: imageWidth/2) // metade do raio pra fora
            .zIndex(1)
            
            // CONTAINER PRINCIPAL
            VStack {
                HStack {
                    if actionType != .add {
                        Button {
                            withAnimation {
                                isDeleting = true
                            }
                        } label: {
                            Image("TrashIcon")
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .font(.title)
                            .bold()
                            .foregroundStyle(Color.AppColors.active)
                    }
                    .foregroundStyle(.white)
                }
                .padding(24)
                
                bodyContent
                
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.AppColors.primary)
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    var bodyContent: some View {
        VStack(spacing: 44) {
            Text(self.contentTitle)
                .font(.custom("Sora", fixedSize: 25))
                .fontWeight(.bold)
                .foregroundStyle(entity.type == .character ? Color.AppColors.active : Color.AppColors.enemy)
            
            if actionType != .editStats {
                CustomTextfield(fieldName: "Nome do \(entity.type.displayText)", input: $entity.name)
            }
            
            HStack {
                AttributeSelector(selectedValue: $entity.health, type: .hp)
                
                Spacer()
                
                AttributeSelector(selectedValue: $entity.defense, type: .defense)
            }
            
            if actionType == .add {
                PrimaryButton(label: "Adicionar", isActive: entity.name != "", action: {
                    entityViewModel.createEntity(
                        context: context,
                        name: entity.name,
                        photo: selectedImageData,
                        health: entity.health,
                        defense: entity.defense,
                        type: entity.type
                    )
                    onDismiss()
                })
                .id(entity.name)
            } else {
                PrimaryButton(label: "Salvar", isActive: entity.name != "", action: {
                    entityViewModel.updateEntity(
                        context: context,
                        entity: entity,
                        name: entity.name,
                        photo: selectedImageData,
                        health: entity.health,
                        defense: entity.defense
                    )
                    onDismiss()
                })
                .id(entity.name)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
    
    var contentTitle: String {
        if actionType == .add {
            return "Adicionar \(entity.type.displayText)"
        } else if actionType == .editAll {
            return "Editar Personagem"
        } else {
            return entity.name
        }
    }

}

private struct DeletingSheet: View {
    @Environment(\.modelContext) var context
    
    var entity: Entity
    @Binding var isDeleting: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                VStack(spacing: 52) {
                    Text("Deletar Personagem")
                        .font(.largeTitle)
                        .bold()
                        
                    Group {
                        Text("Essa ação é ")
                        +
                        Text("permanente ")
                            .bold()
                        +
                        Text("e ")
                        +
                        Text("irreversível")
                            .bold()
                        +
                        Text(". permanente e irreversível. Tem certeza que deseja deletar ")
                        +
                        Text("\(entity.name)?")
                            .bold()
                    }
                    
                    VStack {
                        Button {
                            context.delete(entity)
                            
                            do {
                                try context.save()
                            } catch {
                                // TODO: caso de erro
                                print("Não consegui salvar a deleção")
                            }
                        } label: {
                            Text("Deletar")
                                .font(.title2)
                                .bold()
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.primary)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color.AppColors.red)
                                }
                            
                        }
                        
                        Button {
                            withAnimation {
                                self.isDeleting.toggle()
                            }
                        } label: {
                            Text("Cancelar")
                                .font(.title2)
                                .bold()
                                .underline()
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 52)
                .padding(.horizontal, 30)
                .foregroundStyle(Color.AppColors.active)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.AppColors.primary)
                )
            }
        }
    }
}


#Preview {
    @Previewable @State var isShowingSheet = true
    
    Color.clear
        .customSheet(isPresented: $isShowingSheet,
                        actionType: .editStats,
                        entityType: .initiative)
}
