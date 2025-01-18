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
                VStack(alignment: .leading, spacing: 20) { // Left-aligned content items
                    ForEach(1...10, id: \.self) { index in
                        DisclosureGroup {
                            // Sets and details inside the disclosure group
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(1...3, id: \.self) { set in
                                    Text("Set: \(set) Reps: 10 Weight: 100")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Exercise \(index)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
                .padding(.horizontal)
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

