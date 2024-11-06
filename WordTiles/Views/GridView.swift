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
    var maxHeight: CGFloat
    private let tileSpacing: CGFloat = 10
    
    @Binding var selectedPositions: [CGPoint]
    
    var body: some View {
        let gridSize = min(maxHeight, maxHeight)
        let tileSize = preferredTileSize(gridSize: gridSize, spacing: tileSpacing, rows: rows, columns: columns)
        
        ForEach(tiles) { tile in
            let position = CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))
            TileView(
                letter: tile.letter,
                isSelected: selectedPositions.contains(position),
                gridPosition: position
            )
            .frame(width: tileSize.width, height: tileSize.height)
            .position(
                x: tilePosition(size: tileSize.width, alignment: tile.column, spacing: tileSpacing),
                y: tilePosition(size: tileSize.height, alignment: tile.row, spacing: tileSpacing)
            )
            .animation(.default, value: tile.row)
        }
    }
    
    private func tilePosition(size: CGFloat, alignment: Int, spacing: CGFloat) -> CGFloat {
        return (CGFloat(alignment) * (size + spacing) + size / 2) + spacing
    }
    
    private func preferredTileSize(gridSize: CGFloat, spacing: CGFloat, rows: Int, columns: Int) -> CGSize {
        let tileSize: CGSize
        if rows > columns {
            let size = gridSize / CGFloat(rows)
            tileSize = CGSize(width: size, height: size)
        } else if columns > rows {
            let size = gridSize / CGFloat(columns)
            tileSize = CGSize(width: size, height: size)
        } else {
            let size = gridSize / CGFloat(columns)
            tileSize = CGSize(width: size, height: size)
        }
        
        let spacedTileSize: CGSize = CGSize(width: tileSize.width - spacing, height: tileSize.height - spacing)
        
        return spacedTileSize
    }
}

#Preview {
    GameView()
}
