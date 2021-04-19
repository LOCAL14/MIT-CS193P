//
//  Cardify.swift
//  Memorize
//
//  Created by 夏震 on 2021/4/1.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var theme: EmojiMemoryGame.Theme
    
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    // 相当于重命名rotation
    var animatableData: Double {
        get{ rotation }
        set{ rotation = newValue }
    }
    
    
    init(isFaceUp: Bool, theme: EmojiMemoryGame.Theme) {
        self.rotation = isFaceUp ? 0 : 180
        self.theme = theme
    }
    
    func body(content: Content) -> some View {
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            
            Group{
                // 当theme设定了gradientColor时，卡片背面采用渐变色
                let firstColor = theme.color
                if let secondColor = theme.gradientColor {
                    let gradient = LinearGradient(gradient: Gradient(colors: [firstColor,secondColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    RoundedRectangle(cornerRadius: cornerRadius).fill(gradient)
                } else{
                    RoundedRectangle(cornerRadius: cornerRadius).fill(firstColor)
                }
            }
                .opacity(!isFaceUp ? 1 : 0)
        }
            .foregroundColor(theme.color)
            .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }

    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify(isFaceUp: Bool, theme: EmojiMemoryGame.Theme) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, theme: theme))
    }
}
