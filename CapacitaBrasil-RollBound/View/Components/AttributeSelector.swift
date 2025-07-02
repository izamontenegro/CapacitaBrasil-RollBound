//
//  AttributeSelector.swift
//  CapacitaBrasil-RollBound
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 17/06/25.
//
import SwiftUI

enum SelectorType {
    case hp
    case defense
}

struct AttributeSelector: View {
    @Binding var selectedValue: Int
    let type: SelectorType

    @State private var textValue: String = ""
    @State private var isTextFieldVisible: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    let range: ClosedRange<Int> = 0...99
    let itemWidth: CGFloat = 55
    let spacing: CGFloat = 20

    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 4) {
                Text(type == .hp ? "HP" : "DEF")
                    .font(.custom("Sora", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(type == .hp ? Color.AppColors.red : Color.AppColors.blue)

                Image(type == .hp ? "HeartIcon" : "ShieldIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor(type == .hp ? Color.AppColors.red : Color.AppColors.blue)
            }

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -5) {
                        ForEach(range, id: \.self) { value in
                            VStack(spacing: 4) {
                                if value == selectedValue && isTextFieldVisible {
                                    TextField("", text: $textValue)
                                        .font(.custom("Sora", size: 29))
                                        .foregroundColor(Color.AppColors.unactive)
                                        .fontWeight(.bold)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            textValue = "\(selectedValue)"
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                isTextFieldFocused = true
                                            }
                                        }
                                        .onChange(of: textValue) {
                                            if let intValue = Int(textValue) {
                                                selectedValue = min(max(range.lowerBound, intValue), range.upperBound)
                                            }
                                        }
                                        .onSubmit {
                                            isTextFieldVisible = false
                                        }
                                } else {
                                    Text("\(value)")
                                        .font(.custom("Sora", size: 29))
                                        .foregroundColor(Color.AppColors.unactive)
                                        .fontWeight(.bold)
                                        .scaleEffect(1.2)
                                        .onTapGesture {
                                            if value == selectedValue {
                                                isTextFieldVisible = true
                                            }
                                        }
                                }

                                Rectangle()
                                    .frame(height: value == selectedValue ? 4 : 0)
                                    .foregroundColor(Color.AppColors.unactive)
                                    .cornerRadius(2)
                                    .padding(.horizontal, 4)
                                    .opacity(value == selectedValue ? 1 : 0)
                            }
                            .frame(width: itemWidth)
                            .id(value)
                        }
                    }
                    .padding(.horizontal, (UIScreen.main.bounds.width - itemWidth) / 2)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let offset = -value.translation.width
                                let progress = offset / (itemWidth + spacing)
                                let newValue = selectedValue + Int(round(progress))
                                let clamped = min(max(range.lowerBound, newValue), range.upperBound)

                                withAnimation(.spring()) {
                                    selectedValue = clamped
                                    proxy.scrollTo(clamped, anchor: .center)
                                    isTextFieldVisible = false
                                }
                            }
                    )
                    .onAppear {
                        proxy.scrollTo(selectedValue, anchor: .center)
                    }
                    .onChange(of: selectedValue) {
                        withAnimation {
                            proxy.scrollTo(selectedValue, anchor: .center)
                        }
                    }
                }
            }
        }
        .frame(width: 150)
    }
}


#Preview {
    @Previewable @State var attribute: Int = 1
    AttributeSelector(selectedValue: $attribute, type: .hp)
    AttributeSelector(selectedValue: $attribute, type: .defense)

}
