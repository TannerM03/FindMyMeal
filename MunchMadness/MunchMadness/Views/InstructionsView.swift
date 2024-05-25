//
//  InstructionsView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 5/24/24.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Instructions")
                 .font(.title)
            Text("* Select your filters")
            Text("* Swipe away the restaurant you don't want")
            Text("* Choose to add winning restaurants to your favorites and leave notes")
        }
    }
}

#Preview {
    InstructionsView()
}
