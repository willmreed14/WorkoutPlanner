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
    @State private var programTitle: String = "Loading..." // Store only the title initially
    @State private var days: [Day] = []
    @State private var loading: Bool = true // Track loading state

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading program...")
                } else {
                    // Display the program title
                    Text(programTitle)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)

                    List(days.indices, id: \.self) { index in
                        NavigationLink(destination: WorkoutDayView(day: days[index])) {
                            HStack {
                                Text("\(weekdayName(for: index)):") // Monday, Tuesday, etc.
                                    .font(.headline)
                                    .bold()
                                //Spacer()
                                Text("\(days[index].title.isEmpty ? "Active Rest" : days[index].title)")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("") // Keep navigation bar clean
        }
        .onAppear(perform: fetchProgramData)
    }

    // Convert index to weekday name
    func weekdayName(for index: Int) -> String {
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        return index < weekdays.count ? weekdays[index] : "Day \(index + 1)"
    }

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

                if let programData = programDoc?.data(),
                   let title = programData["title"] as? String,
                   let daysArray = programData["days"] as? [[String: Any]] {

                    var parsedDays: [Day] = []

                    for dayData in daysArray {
                        if let title = dayData["title"] as? String,
                           let exercisesArray = dayData["exercises"] as? [[String: Any]] {
                            
                            var exercises: [Exercise] = []

                            for exerciseData in exercisesArray {
                                if let exerciseTitle = exerciseData["title"] as? String,
                                   let setsArray = exerciseData["sets"] as? [[String: Any]] {

                                    var sets: [Set] = []
                                    for setData in setsArray {
                                        if let reps = setData["reps"] as? Double,
                                           let weight = setData["weight"] as? Double {
                                            sets.append(Set(reps: reps, weight: weight))
                                        }
                                    }
                                    exercises.append(Exercise(title: exerciseTitle, sets: sets))
                                }
                            }
                            parsedDays.append(Day(title: title, exercises: exercises))
                        }
                    }

                    DispatchQueue.main.async {
                        self.programTitle = title
                        self.days = parsedDays
                        self.loading = false
                    }
                } else {
                    print("Failed to parse Firestore data.")
                    loading = false
                }
            }
        }
    }
}

#Preview {
    WeekView()
        .environmentObject(AuthViewModel())
}
