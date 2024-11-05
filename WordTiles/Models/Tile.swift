//
//  Tile.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import Foundation

struct Tile: Identifiable {
    let id = UUID()
    let letter: String
    let row: Int
    let column: Int
}
