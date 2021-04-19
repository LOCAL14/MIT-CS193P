//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by 夏震 on 2021/4/18.
//

import Foundation

struct EmojiArt {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable{
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int){
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiId = 0
    
    ///为了解决Emoji的Identifiable的ID唯一性问题（也可以使用``UUID()``）
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int ){
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
