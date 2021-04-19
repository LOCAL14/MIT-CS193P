//
//  MemoryGame.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  Model

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card){
        print("card chosen: \(card)")
        let chosenIndex = index(of: card)
        cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
    }
    
    func index(of card: Card) -> Int{
        for index in 0..<cards.count{
            if cards[index].id == card.id{
                return index
            }
        }
        return 0 //TODO
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory:(Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content,id: pairIndex*2))
            cards.append(Card(content: content,id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable{
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
