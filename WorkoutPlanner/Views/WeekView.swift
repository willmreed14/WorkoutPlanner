//
//  WeekView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct WeekView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var programTitle: String = "Loading..."
    @State private var days: [Day] = [] // Store the decoded days
    @State private var loading: Bool = true

    let daysOfWeek = [
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    ]

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading program...")
                } else if days.isEmpty {
                    Text("No program selected.")
                        .font(.headline)
                        .padding()
                } else {
                    Text(programTitle) // Display program title
                        .font(.title)
                        .bold()
                        .padding()

                    List(0..<days.count, id: \.self) { index in
                        NavigationLink(destination: WorkoutDayView(day: days[index])) {
                            Text(daysOfWeek[index])
                                .font(.headline)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Week View")
        }
        .onAppear(perform: fetchProgramData)
    }

    // Fetches and constructs the full program manually from Firestore
    func fetchProgramData() {
        guard let userID = authViewModel.user?.uid else {
            print("User not signed in!")
            loading = false
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching active program ID: \(error.localizedDescription)")
                loading = false
                return
            }

            guard let activeProgramID = document?.data()?["activeProgram"] as? String else {
                print("No active program found.")
                loading = false
                return
            }

            let programRef = db.collection("users").document(userID).collection("programs").document(activeProgramID)
            programRef.getDocument { programDoc, error in
                if let error = error {
                    print("Error fetching active program: \(error.localizedDescription)")
                    loading = false
                    return
                }

                guard let programData = programDoc?.data() else {
                    print("No data found for active program.")
                    loading = false
                    return
                }

                print("🔥 Firestore Raw Data: \(programData)")

                // Extract title
                let title = programData["title"] as? String ?? "Unknown Program"
                programTitle = title

                // Extract days manually
                if let daysArray = programData["days"] as? [[String: Any]] {
                    var constructedDays: [Day] = []

                    for dayData in daysArray {
                        let dayTitle = dayData["title"] as? String ?? "Untitled Day"
                        var constructedExercises: [Exercise] = []

                        if let exercisesArray = dayData["exercises"] as? [[String: Any]] {
                            for exerciseData in exercisesArray {
                                let exerciseTitle = exerciseData["title"] as? String ?? "Untitled Exercise"
                                var constructedSets: [Set] = []

                                if let setsArray = exerciseData["sets"] as? [[String: Any]] {
                                    for setData in setsArray {
                                        let reps = setData["reps"] as? Double ?? 0
                                        let weight = setData["weight"] as? Double ?? 0
                                        constructedSets.append(Set(reps: reps, weight: weight))
                                    }
                                }
                                constructedExercises.append(Exercise(title: exerciseTitle, sets: constructedSets))
                            }
                        }
                        constructedDays.append(Day(title: dayTitle, exercises: constructedExercises))
                    }

                    print("✅ Successfully Decoded Days: \(constructedDays)")
                    self.days = constructedDays
                } else {
                    print("❌ Error: No valid days array in Firestore.")
                    self.days = []
                }

                loading = false
            }
        }
    }
}

#Preview {
    WeekView()
        .environmentObject(AuthViewModel())
}
