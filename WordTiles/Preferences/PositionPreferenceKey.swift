//
//  PositionPreferenceKey.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileFramePreferenceKey: PreferenceKey {
    static var defaultValue: [CGPoint: CGRect] = [:]
    
    static func reduce(value: inout [CGPoint: CGRect], nextValue: () -> [CGPoint: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
