//
//  TileSelectionPreferenceKey.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileSelectionPreferenceKey: PreferenceKey {
    static var defaultValue: [CGPoint: CGRect] = [:]
    
    static func reduce(value: inout [CGPoint: CGRect], nextValue: () -> [CGPoint: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
