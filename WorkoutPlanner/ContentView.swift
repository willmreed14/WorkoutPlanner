//
//  ContentView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{ // Vertical stack
            HStack{ // Horizontal stack
                Label("Monday: Push", systemImage: /*@START_MENU_TOKEN@*/"42.circle"/*@END_MENU_TOKEN@*/)
                Spacer() // Push the content to the left
            }
            Spacer() // Push the content to the top
        }
        .padding() // Keep it spaced from the screen edges
    }
}

#Preview {
    ContentView()
}

