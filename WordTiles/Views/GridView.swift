//
//  GridView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct GridView: View {
    let tiles: [Tile]
    @Binding var selectedPositions: [CGPoint]

    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 10
            let horizontalPadding: CGFloat = spacing * 2
            let verticalPadding: CGFloat = spacing * 2
            
            let availableWidth = geometry.size.width - horizontalPadding
            let availableHeight = geometry.size.height - verticalPadding
            
            // Minimum and maximum Tile sizes
            let minTileSize: CGFloat = 50
            let maxTileSize: CGFloat = 150
            
            // Optimal number of Columns
            let (columns, rows, tileSize) = calculateGridLayout(
                tileCount: tiles.count,
                availableWidth: availableWidth,
                availableHeight: availableHeight,
                spacing: spacing,
                minTileSize: minTileSize,
                maxTileSize: maxTileSize
            )
    
            if columns == 0 || rows == 0 { // No Tiles to Generate
                Text("No tiles to display")
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                // Calculate the actual Grid size
                let gridWidth = (tileSize * CGFloat(columns)) + (spacing * CGFloat(columns - 1))
                let gridHeight = (tileSize * CGFloat(rows)) + (spacing * CGFloat(rows - 1))
                
                VStack(spacing: spacing) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<columns, id: \.self) { column in
                                let index = (row * columns) + column
                                if index < tiles.count {
                                    let tile = tiles[index]
                                    let position = CGPoint(x: CGFloat(column), y: CGFloat(row))
                                    TileView(
                                        letter: tile.letter,
                                        isSelected: selectedPositions.contains(position),
                                        gridPosition: position
                                    )
                                    .frame(width: tileSize, height: tileSize)
                                } else {
                                    Spacer()
                                        .frame(width: tileSize, height: tileSize)
                                }
                            }
                        }
                    }
                }
                .frame(width: gridWidth, height: gridHeight)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
    
    private func calculateGridLayout(
        tileCount: Int,
        availableWidth: CGFloat,
        availableHeight: CGFloat,
        spacing: CGFloat,
        minTileSize: CGFloat,
        maxTileSize: CGFloat
    ) -> (columns: Int, rows: Int, tileSize: CGFloat) {
        guard tileCount > 0 else { // No Tiles
            return (columns: 0, rows: 0, tileSize: minTileSize)
        }

        var bestColumns = 1
        var bestRows = tileCount
        var bestTileSize: CGFloat = minTileSize
        var minDifference = Int.max

        for columns in 1...tileCount {
            let rows = Int(ceil(Double(tileCount) / Double(columns)))
            let tileWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let tileHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let tileSize = min(tileWidth, tileHeight)

            if tileSize >= minTileSize && tileSize <= maxTileSize {
                let difference = abs(columns - rows)
                if difference < minDifference || (difference == minDifference && tileSize > bestTileSize) {
                    bestColumns = columns
                    bestRows = rows
                    bestTileSize = tileSize
                    minDifference = difference
                }
            }
        }
        return (bestColumns, bestRows, bestTileSize)
    }
}

#Preview {
    GridView(tiles: [Tile(letter: "A"), Tile(letter: "B"), Tile(letter: "C")], selectedPositions: .constant([CGPoint.zero]))
}
