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
        VStack {
          
            HStack(alignment: .firstTextBaseline){
                Text(viewModel.theme!.name).font(.title)
                Text("(Score: \(viewModel.score))")
                Spacer()
                Button("New Game", action: viewModel.createMemoryGame)
            }
                .font(.title2)
               
            
            Divider()
            
            Grid(viewModel.cards){card in
                CardView(card: card, theme: viewModel.theme!)
                    .onTapGesture{ viewModel.choose(card: card) }
                    .padding(5)
            }
//                .foregroundColor(viewModel.theme!.color)
            
        }
            .padding()
      
    }
}

struct CardView: View{
    var card: MemoryGame<String>.Card
    
    var theme: EmojiMemoryGame.Theme
    
    var body:some View {
        GeometryReader{ geometry in
            ZStack{
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched{
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
        let game = EmojiMemoryGame()
        game.createMemoryGame()
        return EmojiMemoryGameView(viewModel: game)
    }
}
