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
                Text("Monday:")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Push")
                    .font(.title)
                
                Image(systemName:"dumbbell")
                    .font(.title)
                
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

