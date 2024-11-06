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
            let width = geometry.size.width
            let height = geometry.size.height
            let tileWidth = (width - (tileSpacing * CGFloat(columns + 1))) / CGFloat(columns)
            let tileHeight = (height - (tileSpacing * CGFloat(rows + 1))) / CGFloat(rows)
            let tileSize = min(tileWidth, tileHeight)
            
            let tilesByRow = groupTilesByRow(tiles: tiles, rows: rows, columns: columns)
            
            VStack {
                Spacer()
                ForEach(0..<rows, id: \.self) { rowIndex in
                    HStack {
                        if rowIndex < tilesByRow.count {
                            let rowTiles = tilesByRow[rowIndex]
                            ForEach(rowTiles) { tile in
                                TileView(
                                    letter: tile.letter,
                                    isSelected: selectedPositions.contains(CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))),
                                    gridPosition: CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))
                                )
                                .frame(width: tileSize, height: tileSize)
                                .animation(.default, value: tile.row)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private func groupTilesByRow(tiles: [Tile], rows: Int, columns: Int) -> [[Tile]] {
        var groupedTiles: [[Tile]] = Array(repeating: [], count: rows)
        
        for tile in tiles {
            if tile.row < rows && tile.column < columns {
                groupedTiles[tile.row].append(tile)
            }
        }
        return groupedTiles
    }
}

#Preview {
    GridView(tiles: [Tile(letter: Letter(character: "A"), row: 0, column: 0), Tile(letter: Letter(character: "B"), row: 0, column: 1), Tile(letter: Letter(character: "C"), row: 0, column: 2)],
             rows: 2, columns: 3, selectedPositions: .constant([CGPoint.zero]))
}
