//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by ๅค้ on 2021/3/16.
//
//  ViewModel

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
    @Published var theme: Theme?
    
    @Published private var game: MemoryGame<String>?
    
    
    private let themes: [Theme] = [
        Theme(name: "Halloween", contents: ["๐ป","๐","๐ฆ","๐ท","๐"], color: Color.orange),
        Theme(name: "Animals", contents: ["๐ถ","๐ฑ","๐ปโโ๏ธ","๐ฐ","๐ฆ","๐ฆ"], color: Color.blue),
        Theme(name: "Faces", contents: ["๐","๐","๐คช","๐","๐","๐คฉ"], color: Color.yellow),
        Theme(name: "Cars", contents: ["๐","๐","๐","๐","๐","๐"], color: Color.red),
        Theme(name: "Sports", contents: ["โฝ๏ธ","โพ๏ธ","๐ฅ","๐พ","๐","๐"], color: Color.gray),
        Theme(name: "Countries", contents: ["๐ฉ๐ฐ","๐จ๐ณ","๐ฑ๐ท","๐ฎ๐ธ"], color: Color.purple, gradientColor: Color.red, isRandom: false)
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
    
    // MARK: - Intents๏ผไบคไบ๏ผ
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
