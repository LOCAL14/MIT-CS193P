//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  ViewModel

import SwiftUI


class EmojiMemoryGame {
    private var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String>{
        let emojis: Array<String> = ["👻","🎃","🦇"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count){ pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Getter
    var cards: Array<MemoryGame<String>.Card>{
        return game.cards
    }
    
    // MARK: - Intents（交互）
    func choose(card: MemoryGame<String>.Card){
        game.choose(card: card)
    }
    
}
