//
//  MemoryGame.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/16.
//
//  Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    var score: Int = 0
    
    var timeOfLatestMatch: Date?
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get{
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        
        set{
            for index in cards.indices {
                if index == newValue {
                    // 被点击的卡片正面朝上
                    cards[index].isFaceUp = true
                } else if cards[index].isFaceUp{
                    // 未被点击的、正面朝上的卡片，反面朝上并标记Seen
                    cards[index].isFaceUp = false
                    cards[index].isSeen = true
                }
            }
        }
    }
    
    /// 匹配得分
    /// 规则：距离上次匹配10s内，每1s多加2分
    var bonusScore: Int {
        if let lastTime = timeOfLatestMatch {
            let now = Date()
            let timeInterval = now.timeIntervalSince(lastTime)
            return max(10-Int(timeInterval), 1) * 2
        } else {
          return 2
        }
    }
    
    mutating func choose(card: Card){
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[potentialMatchIndex].content == cards[chosenIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += bonusScore
                    timeOfLatestMatch = Date()
                } else {
                    score -= cards[chosenIndex].isSeen ? 1 : 0
                    score -= cards[potentialMatchIndex].isSeen ? 1 : 0
                }
                cards[chosenIndex].isFaceUp = true
           }else{
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
           }
        }
    }
    
    
    init(numberOfPairsOfCards: Int, isRandom: Bool, cardContentFactory:(Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content,id: pairIndex*2))
            cards.append(Card(content: content,id: pairIndex*2+1))
        }
        
        /// Shuffle cards
        if isRandom{ cards.shuffle()}
    }
    
    struct Card: Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
    }
    
}
