//
//  BIRDView.swift
//  FlappyBird
//
//  Created by Max BG on 7/29/24.
//

import SwiftUI

struct BIRDView: View {
    let birdSize: Double
    var body: some View {
        Image(.flappyBird)
            .resizable()
            .scaledToFit()
            .frame(width: birdSize, height: birdSize)
    }
}

#Preview {
    BIRDView(birdSize: 80)
}
