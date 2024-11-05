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

            VStack(spacing: spacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            if let tile = tiles.first(where: {
                                $0.row == row && $0.column == column
                            }) {
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
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    GridView(tiles: [Tile(letter: "A", row: 0, column: 0), Tile(letter: "B", row: 0, column: 1), Tile(letter: "C", row: 0, column: 2)], rows: 1, columns: 3, selectedPositions: .constant([CGPoint.zero]))
}
