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
    @Binding var selectedPositions: [CGPoint]
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 10

            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height

            let tileWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let tileHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
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
                        x: CGFloat(tile.column) * (tileSize + spacing) + tileSize / 2,
                        y: CGFloat(tile.row) * (tileSize + spacing) + tileSize / 2
                    )
                    .animation(.default, value: tile.row)
                }
            }
            .frame(width: availableWidth, height: availableHeight, alignment: .topLeading)
        }
    }
}

#Preview {
    GridView(tiles: [Tile(letter: Letter(character: "A", frequency: 8.12, points: 1), row: 0, column: 0), Tile(letter: Letter(character: "B", frequency: 1.49, points: 6), row: 0, column: 1), Tile(letter: Letter(character: "C", frequency: 2.71, points: 4), row: 0, column: 2)], rows: 1, columns: 3, selectedPositions: .constant([CGPoint.zero]))
}
