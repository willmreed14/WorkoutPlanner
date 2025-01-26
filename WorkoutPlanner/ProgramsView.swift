//
//  ProgramsView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/25/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProgramsView: View {
    @State private var programs: [Program] = []
    @State private var activeProgramID: String? // Track the active program's ID
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Programs")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                if programs.isEmpty {
                    Text("No programs available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(programs, id: \.id) { program in
                        HStack {
                            Text(program.title)
                                .font(.headline)

                            Spacer()

                            // Indicate if the program is active
                            if program.id == activeProgramID {
                                Text("Active")
                                    .foregroundColor(.green)
                                    .bold()
                            }

                            Button(action: {
                                if let programID = program.id {
                                    setActiveProgram(programID)
                                } else {
                                    print("Error: Program ID is nil")
                                }
                            }) {
                                Text("Set Active")
                                    .bold()
                                    .foregroundColor(.blue)
                            }

                        }
                    }
                }
            }
            .padding()
            .onAppear(perform: fetchPrograms)
        }
    }
    
    // Fetch programs from Firestore
    private func fetchPrograms() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userID).collection("programs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching programs: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.programs = documents.compactMap { doc -> Program? in
                try? doc.data(as: Program.self)
            }
        }
    }
    
    // Set a program as active
    private func setActiveProgram(_ programID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).updateData(["activeProgram": programID]) { error in
            if let error = error {
                print("Error setting active program: \(error.localizedDescription)")
            } else {
                self.activeProgramID = programID
                print("Active program updated to: \(programID)")
            }
        }
    }
}

#Preview {
    ProgramsView()
        .environmentObject(AuthViewModel())
}
