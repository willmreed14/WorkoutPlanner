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
    @State private var loading: Bool = true // Track loading state

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading program...")
                } else {
                    Text(programTitle) // Display program title
                        .font(.title)
                        .bold()
                        .padding()

                    Spacer()
                }
            }
            .navigationTitle("Week View")
        }
        .onAppear(perform: fetchProgramTitle) // Fetch only the title for now
    }

    // Fetch the title of the active program
    func fetchProgramTitle() {
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

            // Fetch the program details using the activeProgramID
            let programRef = db.collection("users").document(userID).collection("programs").document(activeProgramID)
            programRef.getDocument { programDoc, error in
                if let error = error {
                    print("Error fetching active program: \(error.localizedDescription)")
                    loading = false
                    return
                }

                if let programData = programDoc?.data(),
                   let title = programData["title"] as? String {
                    self.programTitle = title
                } else {
                    self.programTitle = "Unknown Program"
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
