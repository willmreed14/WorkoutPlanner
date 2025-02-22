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
    @State private var days: [Day] = [] // Store all days
    @State private var loading: Bool = true // Track loading state

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading program...")
                } else {
                    List(days.indices, id: \.self) { index in
                        DayView(day: days[index]) // ✅ Extracted into a separate view
                    }
                }
            }
            .navigationTitle("Week View")
        }
        .onAppear(perform: fetchProgramData)
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

                if let programData = programDoc?.data() {
                    do {
                        let program = try Firestore.Decoder().decode(Program.self, from: programData)
                        self.days = program.days
                    } catch {
                        print("Error decoding program: \(error.localizedDescription)")
                    }
                }

                loading = false
            }
        }
    }
}

// ✅ Helper View for Each Day
struct DayView: View {
    let day: Day

    var body: some View {
        VStack(alignment: .leading) {
            Text(day.title)
                .font(.headline)
                .bold()
                .padding(.bottom, 5)

            if !day.exercises.isEmpty {
                ForEach(day.exercises.indices, id: \.self) { exerciseIndex in
                    Text("- \(day.exercises[exerciseIndex].title)")
                        .font(.subheadline)
                        .padding(.leading)
                }
            } else {
                Text("No exercises")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.leading)
            }
        }
        .padding()
    }
}


#Preview {
    WeekView()
        .environmentObject(AuthViewModel())
}
