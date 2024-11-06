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
    private let bottomPadding: CGFloat = 25
    
    @Binding var selectedPositions: [CGPoint]
    
    var body: some View {
        let gridSize = min(maxHeight, maxHeight)
        let tileSize = preferredTileSize(gridSize: gridSize, spacing: tileSpacing, rows: rows, columns: columns)
        let gridOffset = gridOffset(gridSize: gridSize, tileSize: tileSize, rows: rows, columns: columns)
        
        ForEach(tiles) { tile in
            let position = CGPoint(x: CGFloat(tile.column), y: CGFloat(tile.row))
            TileView(
                letter: tile.letter,
                isSelected: selectedPositions.contains(position),
                gridPosition: position
            )
            .frame(width: tileSize.width, height: tileSize.height)
            .position(
                x: tilePosition(tileSize: tileSize.width, alignment: tile.column, spacing: tileSpacing) + gridOffset.width,
                y: (tilePosition(tileSize: tileSize.height, alignment: tile.row, spacing: tileSpacing) + gridOffset.height) - bottomPadding
            )
            .animation(.default, value: tile.row)
        }
    }
    
    private func tilePosition(tileSize: CGFloat, alignment: Int, spacing: CGFloat) -> CGFloat {
        return (CGFloat(alignment) * (tileSize + spacing) + tileSize / 2) + spacing
    }
    
    private func gridOffset(gridSize: CGFloat, tileSize: CGSize, rows: Int, columns: Int) -> CGSize {
        var offset = CGSize(width: 0, height: 0)
        if rows > columns {
            offset = CGSize(width: (gridSize - (CGFloat(columns) * (tileSize.width + tileSpacing))) / 2, height: 0)
        } else if columns > rows {
            offset = CGSize(width: 0, height: gridSize - (CGFloat(rows) * (tileSize.height + tileSpacing)))
        }
        return offset
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
