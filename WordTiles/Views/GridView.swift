//
//  GridView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GridView: View {
    let tiles: [Tile]
    let columns: Int
    @Binding var selectedPositions: [CGPoint]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: columns), spacing: 10) {
            ForEach(tiles) { tile in
                let position = CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))
                TileView(
                    letter: tile.letter,
                    isSelected: selectedPositions.contains(position),
                    gridPosition: position
                )
            }
        }
        .padding()
    }
}

#Preview {
    GridView(tiles: [Tile(letter: "A", row: 0, column: 0), Tile(letter: "B", row: 0, column: 1), Tile(letter: "C", row: 0, column: 2)], columns: 1, selectedPositions: .constant([CGPoint.zero]))
}
