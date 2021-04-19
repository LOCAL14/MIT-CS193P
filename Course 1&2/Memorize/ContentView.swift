//
//  ContentView.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  View

import SwiftUI
// 计算属性：每次调用都会执行花括号中的内容
struct ContentView: View {
    var viewModel : EmojiMemoryGame
        
    var body: some View {
        HStack{  // 当仅有一个方法时，return可省略；当没有任何参数时，()可省略
            // 当最后一个参数是{}时，可以将其放在外面（尾随闭包），ForEach( 0..<4 ,content:{index in CardView()})
            // ForEach()内需要放可迭代+可识别的参数，比如0..<4或内部元素可识别的数组
            ForEach(viewModel.cards){ card in
                CardView(card: card).onTapGesture{
                    viewModel.choose(card: card)
                }
            }
        }
            .padding() // padding在ZStack周围增加了间距
            .foregroundColor(Color.orange) // foregroundColor对ZStack没有意义，所以向内传递至ZStack内的所有元素
    }
}

struct CardView: View{
    var card: MemoryGame<String>.Card
    
    var body:some View {
        ZStack{
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).strokeBorder(lineWidth: 3.0)
                Text(card.content).font(Font.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
