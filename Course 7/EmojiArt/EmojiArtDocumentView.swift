//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by 夏震 on 2021/4/18.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(EmojiArtDocument.palette.map{ String($0) }, id: \.self){ emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag{ return NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            
            GeometryReader{ geometry in
                ZStack{
                    Color.white
                        .overlay(
                            Group{
                                if document.backgroundImage != nil {
                                    Image(uiImage: document.backgroundImage!)
                                }
                            }
                        )
                        .edgesIgnoringSafeArea([.horizontal,.vertical])
                        .onDrop(of: ["public.image","public.text"], isTargeted: nil){ providers, location in
                            var location = geometry.convert(location, from: .global)
                            location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                            return drop(providers: providers, at: location)
                        }
                    
                    ForEach(document.emojis){ emoji in
                        Text(emoji.text)
                            .font(font(for: emoji))
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
                
                
            
            }
        }
    }
    
    private let defaultEmojiSize: CGFloat = 40
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self){ url in
            print("dropped \(url)")
            document.setBackgroundURL(url)
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self){ string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        
        return found
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentView()
//    }
//}
