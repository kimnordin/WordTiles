//
//  TileLetterPreferenceKey.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileLetterPreferenceKey: PreferenceKey {
    static var defaultValue: [CGPoint: String] = [:]

    static func reduce(value: inout [CGPoint: String], nextValue: () -> [CGPoint: String]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
