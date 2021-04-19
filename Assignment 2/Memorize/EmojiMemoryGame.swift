//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  ViewModel

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
    @Published var theme: Theme?
    
    @Published private var game: MemoryGame<String>?
    
    
    private let themes: [Theme] = [
        Theme(name: "Halloween", contents: ["👻","🎃","🦇","🕷","🌋"], color: Color.orange),
        Theme(name: "Animals", contents: ["🐶","🐱","🐻‍❄️","🐰","🦊","🦁"], color: Color.blue),
        Theme(name: "Faces", contents: ["😀","😇","🤪","😘","😒","🤩"], color: Color.yellow),
        Theme(name: "Cars", contents: ["🚗","🚕","🚙","🚌","🚎","🚓"], color: Color.red),
        Theme(name: "Sports", contents: ["⚽️","⚾️","🥎","🎾","🏐","🏉"], color: Color.gray),
        Theme(name: "Countries", contents: ["🇩🇰","🇨🇳","🇱🇷","🇮🇸"], color: Color.purple, gradientColor: Color.red, isRandom: false)
    ]
    
    func createMemoryGame(){
        theme = themes[Int.random(in: themes.indices)]
        let emojis = theme!.contents
        
        var game = MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2..<emojis.count)){ pairIndex in
            return emojis[pairIndex]
        }
        
        /// Shuffle cards
        if theme!.isRandom{
            game.cards.shuffle()
        }

        self.game = game
    }

    // MARK: - Getter
    var cards: Array<MemoryGame<String>.Card>{
        return game?.cards ?? []
    }
    
    var score: Int{
        return game?.score ?? 0
    }
    
    // MARK: - Intents（交互）
    func choose(card: MemoryGame<String>.Card){
        game?.choose(card: card)
    }
    
    struct Theme {
        var name: String
        var contents: [String]
        var color: Color
        var gradientColor: Color?
        var isRandom: Bool = true
    }
}
