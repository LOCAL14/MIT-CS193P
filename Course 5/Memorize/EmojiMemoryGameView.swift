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
            
        }
            .padding()
      
    }
}

struct CardView: View{
    var card: MemoryGame<String>.Card
    
    var theme: EmojiMemoryGame.Theme
    
    var body:some View {
        GeometryReader{ geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack{
                    Pie(
                        startAngle: Angle.degrees(-90),
                        endAngle: Angle.degrees(30),
                        clockwise: true
                    )
                        .padding(5)
                        .opacity(0.4)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                }
                .cardify(isFaceUp: card.isFaceUp, theme: theme)
            }
           
        }
    }
    
    private func fontSize(for size:CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.createMemoryGame()
        return EmojiMemoryGameView(viewModel: game)
    }
}
