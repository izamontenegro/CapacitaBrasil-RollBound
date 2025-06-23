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
    @State var type: SelectorType
    let range: ClosedRange<Int> = 0...999
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
                                Text("\(value)")
                                    .font(.custom("Sora", size: value == selectedValue ? 29 : 25))
                                    .foregroundColor(Color.AppColors.unactive)
                                    .fontWeight(.bold)
                                    .scaleEffect(value == selectedValue ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedValue)
                                
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
                                }
                            }
                    )
                    .onAppear {
                        proxy.scrollTo(selectedValue, anchor: .center)
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
