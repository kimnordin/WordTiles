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
                    HStack(spacing: tileSpacing) {
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
                    .padding(.horizontal, calculateHorizontalPadding(for: tilesByRow[rowIndex], tileSize: tileSize, spacing: tileSpacing, totalWidth: width))
                }
            }
            .frame(width: width, height: height, alignment: .bottom)
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
    
    private func calculateHorizontalPadding(for rowTiles: [Tile], tileSize: CGFloat, spacing: CGFloat, totalWidth: CGFloat) -> CGFloat {
        let totalTileWidth = CGFloat(rowTiles.count) * tileSize
        let totalSpacing = CGFloat(rowTiles.count - 1) * spacing
        let usedWidth = totalTileWidth + totalSpacing
        let remainingWidth = totalWidth - usedWidth
        return max(remainingWidth / 2, 0)
    }
}

#Preview {
    GridView(tiles: [Tile(letter: Letter(character: "A", frequency: 8.12), row: 0, column: 0), Tile(letter: Letter(character: "B", frequency: 1.49), row: 0, column: 1), Tile(letter: Letter(character: "C", frequency: 2.71), row: 0, column: 2)],
             rows: 2, columns: 3, selectedPositions: .constant([CGPoint.zero]))
}
