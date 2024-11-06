//
//  Tile.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import Foundation

class Tile: Identifiable {
    let id = UUID()
    let letter: Letter
    var row: Int
    let column: Int
    
    init(letter: Letter, row: Int, column: Int) {
        self.letter = letter
        self.row = row
        self.column = column
    }
}

extension Tile: Equatable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}
