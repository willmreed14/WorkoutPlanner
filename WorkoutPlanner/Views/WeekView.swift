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
    @State private var program: Program? = nil // Store the active program
    @State private var loading: Bool = true // Track loading state

    let daysOfWeek = [
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    ]

    var body: some View {
        NavigationView {
            if loading {
                // Show a loading state while fetching data
                ProgressView("Loading program...")
            } else if let program = program {
                // Display days of the week linked to WorkoutDayView
                List(0..<7, id: \.self) { index in
                    NavigationLink(
                        destination: WorkoutDayView(day: program.days[index])
                    ) {
                        Text(daysOfWeek[index])
                            .font(.headline)
                            .padding()
                    }
                }
                .navigationTitle("Week View")
            } else {
                // No program available
                Text("No program selected.")
                    .font(.headline)
                    .padding()
            }
        }

        // Add a sign-out button for testing
        Button(action: {
            authViewModel.signOut()
        }) {
            Text("Sign Out")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .onAppear(perform: fetchProgram) // Fetch program data on load
    }

    // Fetch the active program from Firestore
    func fetchProgram() {
        guard let userID = authViewModel.user?.uid else {
            print("User not signed in!")
            loading = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("programs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching programs: \(error.localizedDescription)")
                loading = false
                return
            }

            if let documents = snapshot?.documents,
               let programData = documents.first?.data() {
                do {
                    let program = try Firestore.Decoder().decode(Program.self, from: programData)
                    self.program = program
                } catch {
                    print("Error decoding program: \(error.localizedDescription)")
                }
            }

            loading = false
        }
    }
}

#Preview {
    WeekView()
        .environmentObject(AuthViewModel())
}
