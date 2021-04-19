//
//  Grid.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/28.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item],viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader {geometry in
            // 引入课程提供的代码 GridLayout.swift
            let gridLayout = GridLayout(itemCount: items.count, in: geometry.size)
            
            ForEach(items){ item in
                let index = items.firstIndex(matching: item)!
                
                viewForItem(item)
                    .frame(width: gridLayout.itemSize.width, height: gridLayout.itemSize.height)
                    .position(gridLayout.location(ofItemAt: index))
            }
            
        }
    }
    
   
}


