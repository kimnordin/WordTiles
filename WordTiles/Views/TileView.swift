//
//  TileView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileView: View {
    let letter: String
    var isSelected: Bool
    let gridPosition: CGPoint

    var body: some View {
        Text(letter)
            .font(.largeTitle)
            .frame(width: 80, height: 80)
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: TileFramePreferenceKey.self, value: [gridPosition: geometry.frame(in: .named("GameView"))])
                }
            )
            .background(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
            .cornerRadius(8)
            .contentShape(Rectangle())
    }
}

#Preview {
    TileView(letter: "Q", isSelected: true, gridPosition: CGPoint(x: 50, y: 50))
}
