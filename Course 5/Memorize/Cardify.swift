//
//  Cardify.swift
//  Memorize
//
//  Created by 夏震 on 2021/4/1.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var theme: EmojiMemoryGame.Theme
    
    func body(content: Content) -> some View {
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(lineWidth: edgeLineWidth)
                content
            } else {
                // 当theme设定了gradientColor时，卡片背面采用渐变色
                let firstColor = theme.color
                if let secondColor = theme.gradientColor {
                    let gradient = LinearGradient(gradient: Gradient(colors: [firstColor,secondColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    RoundedRectangle(cornerRadius: cornerRadius).fill(gradient)
                } else{
                    RoundedRectangle(cornerRadius: cornerRadius).fill(firstColor)
                }
            }
        }

        .foregroundColor(theme.color)
    }

    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify(isFaceUp: Bool, theme: EmojiMemoryGame.Theme) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, theme: theme))
    }
}
