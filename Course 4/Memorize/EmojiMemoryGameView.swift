//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  View

import SwiftUI

// 计算属性：每次调用都会执行花括号中的内容
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
    
    var body:some View{
        Grid(viewModel.cards){card in
            CardView(card: card)
                .onTapGesture{ viewModel.choose(card: card) }
                .padding(5)
        }
            .padding()
            .foregroundColor(Color.orange)
    }
}

struct CardView: View{
    var card: MemoryGame<String>.Card
    
    var body:some View {
        GeometryReader{ geometry in
            ZStack{
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched{
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    func fontSize(for size:CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
