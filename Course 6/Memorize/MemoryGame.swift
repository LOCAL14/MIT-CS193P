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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if !isFaceUp {
                    stopUsingBonusTime()
                }
            }
        }
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
        
        
        
// MARK: - Bouns Times (直接给的代码)
        // this could give matcing bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        //can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        //how long this card has ever been face up
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up(and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in past
        // (i.e not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left befor the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
    
    

    
}
