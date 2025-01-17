//
//  ContentView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .top){ // Overlay layout w/ content and label
            ScrollView{ // Scrollable content
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(1...50, id: \.self) { item in
                        Text("Content item \(item)")
                            .font(.headline)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Floating Label Overlay
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
                .padding()
                .background(Color(.systemBackground).opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .zIndex(1.0) // Ensure floating label stays above scroll view
        }
    }
}

#Preview {
    ContentView()
}

