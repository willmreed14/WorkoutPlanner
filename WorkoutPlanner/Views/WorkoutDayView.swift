//
//  WorkoutDayView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/15/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// Function to format numbers (removes trailing .0 if whole number)
func formatNumber(_ value: Double) -> String {
    return value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(value))" : "\(value)"
}

struct WorkoutDayView: View {
    let day: Day // Pass a `Day` object dynamically

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(day.exercises, id: \.title) { exercise in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(exercise.title)
                                .font(.headline)
                                .bold()

                            ForEach(exercise.sets.indices, id: \.self) { index in
                                Text("Set \(index + 1): Reps: \(formatNumber(exercise.sets[index].reps)), Weight: \(formatNumber(exercise.sets[index].weight)) lbs")
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
                    Text("\(day.title):")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .zIndex(1)
        }
        .navigationBarTitle("") // Remove nav bar text
    }
}

#Preview {
    WorkoutDayView(day: Day(title: "Push", exercises: [
        Exercise(title: "Lat Pulldown", sets: [
            Set(reps: 10, weight: 100),
            Set(reps: 10, weight: 100),
            Set(reps: 10, weight: 100)
        ]),
        Exercise(title: "Bench Press", sets: [
            Set(reps: 8, weight: 150),
            Set(reps: 8, weight: 150),
            Set(reps: 8, weight: 150)
        ])
    ]))
}
