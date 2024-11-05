//
//  TileSelectionPath.swift
//  WordTiles
//
//  Created by Kim on 2024-11-05.
//

import SwiftUI

struct TileSelectionPath: View {
    @Binding var selectedPositions: [CGPoint]
    @Binding var tileFrames: [CGPoint: CGRect]
    
    var body: some View {
        Path { path in
            guard !selectedPositions.isEmpty else { return }
            if let firstPos = selectedPositions.first, let firstFrame = tileFrames[firstPos] {
                let startPoint = CGPoint(x: firstFrame.midX, y: firstFrame.midY)
                path.move(to: startPoint)
                for pos in selectedPositions.dropFirst() {
                    if let frame = tileFrames[pos] {
                        let point = CGPoint(x: frame.midX, y: frame.midY)
                        path.addLine(to: point)
                    }
                }
            }
        }
        .stroke(Color.blue, lineWidth: 5)
    }
}
