//
//  ResultView.swift
//  FlappyBird
//
//  Created by Max BG on 7/29/24.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let highScore: Int
    let resetAction: () -> Void
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            Text("Score: \(score)")
                .font(.title)
            Text("Best: \(highScore)")
                .padding()
            Button("RESET", action: resetAction)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .background(.white.opacity(0.8))
                .clipShape(.rect(cornerRadius: 20))
                .padding()
            
        }
        .background(.white.opacity(0.4))
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    ResultView(score: 5, highScore: 4, resetAction: {})
}
