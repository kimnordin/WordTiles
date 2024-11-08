//
//  TileView.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileView: View {
    let letter: Letter
    var isSelected: Bool
    let gridPosition: CGPoint

    var body: some View {
        GeometryReader { outerGeometry in
            ZStack {
                Rectangle()
                    .fill(isSelected ? .black.opacity(0.3) : .clear)
                    .background(
                        Text("\(letter.points)").font(.system(size: 10)) .padding(.trailing, 3).minimumScaleFactor(0.1), alignment: .topTrailing
                    )
                Text(letter.character)
                    .font(.largeTitle)
                    .minimumScaleFactor(0.1)
            }
            .background(letter.color)
            .cornerRadius(8)
            .contentShape(Rectangle())
            .overlay(
                GeometryReader { innerGeometry in
                    Color.clear.preference(
                        key: TileSelectionPreferenceKey.self,
                        value: [gridPosition: innerGeometry.frame(in: .named("GameView"))]
                    )
                }
                .padding(outerGeometry.size.width / 8)
            )
        }
    }
}

#Preview {
    TileView(letter: Letter(character: "Q"), isSelected: true, gridPosition: CGPoint.zero)
}
