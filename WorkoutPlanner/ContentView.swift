//
//  ContentView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/15/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) { // Left-aligned content items
                    ForEach(1...10, id: \.self) { index in
                        // Label for each exercise
                        Text("Exercise \(index)")
                            .fontWeight(.thin)
                        // Sets and details inside the disclosure group
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(1...3, id: \.self) { set in
                                Text("Set: \(set) Reps: 10 Weight: 100")
                                    .font(.subheadline)
                                    //.foregroundColor(.gray)
                            }
                            Divider()
                        }
                        //.padding()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading) // Enforce left alignment
            }
            
            // Floating label (your existing layout)
            VStack {
                HStack {
                    Text("Monday:")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Push")
                        .font(.title)
                    
                    Image(systemName: "dumbbell")
                        .font(.title)
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .zIndex(1)
        }
    }
}

#Preview {
    ContentView()
}

