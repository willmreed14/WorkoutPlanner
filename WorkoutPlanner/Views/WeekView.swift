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
    @State private var programTitle: String = "Loading..." // Store program title
    @State private var days: [String] = [] // Store only day titles initially
    @State private var loading: Bool = true // Track loading state

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading program...")
                } else {
                    Text(programTitle)
                        .font(.title)
                        .bold()
                        .padding()

                    List(days.indices, id: \.self) { index in
                        Text(days[index])
                            .font(.headline)
                            .padding()
                    }

                }
            }
            .navigationTitle("Week View")
        }
        .onAppear(perform: fetchProgramData) // Fetch program data
    }

    // Fetch the title and days of the active program
    func fetchProgramData() {
        guard let userID = authViewModel.user?.uid else {
            print("User not signed in!")
            loading = false
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        // Fetch the active program ID
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching active program ID: \(error.localizedDescription)")
                loading = false
                return
            }

            guard let activeProgramID = document?.data()?["activeProgram"] as? String else {
                print("No active program found.")
                programTitle = "No Program Selected"
                loading = false
                return
            }

            // Fetch the program details
            let programRef = db.collection("users").document(userID).collection("programs").document(activeProgramID)
            programRef.getDocument { programDoc, error in
                if let error = error {
                    print("Error fetching active program: \(error.localizedDescription)")
                    loading = false
                    return
                }

                if let programData = programDoc?.data() {
                    self.programTitle = programData["title"] as? String ?? "Unknown Program"
                    
                    // Extract day titles
                    if let daysArray = programData["days"] as? [[String: Any]] {
                        self.days = daysArray.compactMap { $0["title"] as? String }
                    } else {
                        self.days = []
                    }
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
