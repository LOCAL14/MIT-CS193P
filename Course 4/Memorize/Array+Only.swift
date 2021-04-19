//
//  Array+Only.swift
//  Memorize
//
//  Created by 夏震 on 2021/3/29.
//

import Foundation

extension Array {
    var only: Element? {
        // count == 1? first : nil
        count == 1 ? self.first : nil
    }
}
