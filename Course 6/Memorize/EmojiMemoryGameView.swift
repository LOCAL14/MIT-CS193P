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
                Button("New Game", action: {
                    withAnimation(.easeInOut) {
                        viewModel.resetGame()
                    }
                })
            }
                .font(.title2)
               
            
            Divider()
            
            Grid(viewModel.cards){card in
                CardView(card: card, theme: viewModel.theme!)
                    .onTapGesture{
                        withAnimation(.linear(duration: 0.75)) {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
            }
            
        }
            .padding()
      
    }
}

struct CardView: View{
    var card: MemoryGame<String>.Card
    
    var theme: EmojiMemoryGame.Theme
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBounsTimeAnimated() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body:some View {
        GeometryReader{ geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack{
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(-90),
                            endAngle: Angle.degrees(-animatedBonusRemaining*360-90),
                            clockwise: true)
                            .padding(5).opacity(0.4)
                            .onAppear {
                                self.startBounsTimeAnimated()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(-90),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                            clockwise: true)
                            .padding(5).opacity(0.4)
                    }
                    
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                        
                }
                .cardify(isFaceUp: card.isFaceUp, theme: theme)
                .transition(AnyTransition.scale)
                
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
