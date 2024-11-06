//
//  GridView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GridView: View {
    let tiles: [Tile]
    let rows: Int
    let columns: Int
    private let tileSpacing: CGFloat = 10
    
    @Binding var selectedPositions: [CGPoint]
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            
            let tileWidth = (availableWidth - (tileSpacing * CGFloat(columns - 1))) / CGFloat(columns)
            let tileHeight = (availableHeight - (tileSpacing * CGFloat(rows - 1))) / CGFloat(rows)
            
            let tileSize = min(tileWidth, tileHeight)
            
            ZStack {
                ForEach(tiles) { tile in
                    let position = CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))
                    TileView(
                        letter: tile.letter,
                        isSelected: selectedPositions.contains(position),
                        gridPosition: position
                    )
                    .frame(width: tileSize, height: tileSize)
                    .position(
                        x: CGFloat(tile.column) * (tileSize + tileSpacing) + tileSize / 2,
                        y: CGFloat(tile.row) * (tileSize + tileSpacing) + tileSize / 2
                    )
                    .animation(.default, value: tile.row)
                }
            }
            .frame(width: availableWidth, height: availableHeight, alignment: .topLeading)
        }
    }
}

#Preview {
    GridView(tiles: [Tile(letter: Letter(character: "A"), row: 0, column: 0), Tile(letter: Letter(character: "B"), row: 0, column: 1), Tile(letter: Letter(character: "C"), row: 0, column: 2)],
             rows: 2, columns: 3, selectedPositions: .constant([CGPoint.zero]))
}
