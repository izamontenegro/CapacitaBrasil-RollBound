//
//  CustomTextfield.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 16/06/25.
//
import SwiftUI

struct CustomTextfield: View {
    var fieldName: String
    @Binding var input: String

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if input.isEmpty {
                    Text(fieldName)
                        .foregroundColor(Color.AppColors.active)
                        .font(.custom("Sora", size: 21))
                        .fontWeight(.bold)
                }

                TextField("", text: $input)
                    .foregroundColor(Color.AppColors.active)
                    .tint(.white)
                    .font(.custom("Sora", size: 21))
                    .fontWeight(.bold)
            }

            Rectangle()
                .foregroundStyle(Color.AppColors.unactive)
                .frame(maxWidth: .infinity, maxHeight: 2)
        }
    }
}

#Preview {
    @Previewable @State var input: String = ""
    @Previewable @State var fieldName: String = "Nome do personagem "
    CustomTextfield(fieldName: fieldName, input: $input)
        .padding(.horizontal)
}
