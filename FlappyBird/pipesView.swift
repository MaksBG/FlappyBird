//
//  pipesView.swift
//  FlappyBird
//
//  Created by Max BG on 7/29/24.
//

import SwiftUI

struct pipesView: View {
    let topPipeHeight: Double
    let pipeWidth: Double
    let pipeSpacing: Double
    
    var body: some View {
        // upper pipe
        GeometryReader { geometry in
            VStack {
                Image(.flappeBirdPipe)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: pipeWidth, height: topPipeHeight)
                // Spacer
                Spacer(minLength: pipeSpacing)
                // Lower pipe
                Image(.flappeBirdPipe)
                    .resizable()
                    .frame(
                        width: pipeWidth,
                        height: geometry.size.height - topPipeHeight - pipeSpacing)
            }
        }
    }
}

#Preview {
    pipesView(topPipeHeight: 300, pipeWidth: 100, pipeSpacing: 100)
}
