//
//  ContentView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/15/25.
//

import SwiftUI

struct WorkoutDayView: View {
    
    let day: String // accept the day as a parameter
    
    let exercises: [Exercise] = [
        Exercise(name: "Lat Pulldown", sets: [
            Set(number: 1, reps: 10, weight: 100),
            Set(number: 2, reps: 10, weight: 100),
            Set(number: 3, reps: 10, weight: 100)
        ]),
        Exercise(name: "Bench Press", sets: [
            Set(number: 1, reps: 8, weight: 150),
            Set(number: 2, reps: 8, weight: 150),
            Set(number: 3, reps: 8, weight: 150)
        ])
    ]

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Add an invisible spacer to simulate initial scroll offset
                    Color.clear
                        .frame(height: 50) // Adjust height to match the space you want to skip

                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(exercise.name)
                                .font(.headline)
                            
                            ForEach(exercise.sets) { set in
                                Text("Set: \(set.number) Reps: \(set.reps) Weight: \(set.weight)")
                                    .font(.subheadline)
                            }
                            Divider()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            
            // Floating label
            VStack {
                HStack {
                    Text("\(day):")
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
        .padding(.top, -50) // Adjust for nav bar
        .navigationBarTitle("") // Remove nav bar text
        .navigationBarHidden(false) // keep the back button
    }
}

#Preview {
    WorkoutDayView(day: "Monday")
}


