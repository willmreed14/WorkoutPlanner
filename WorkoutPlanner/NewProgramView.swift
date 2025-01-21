//
//  NewProgramView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/20/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewProgramView: View {
    @State private var programTitle: String = ""
    @State private var days: [Day] = Array(repeating: Day(title: "", exercises: []), count: 7)

    var body: some View {
        NavigationStack {
            VStack {
                // Program Title Input
                TextField("Enter Program Title", text: $programTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Days Input
                List(0..<7, id: \.self) { index in
                    Section(header: Text("Day \(index + 1)")) {
                        TextField("Day Title", text: $days[index].title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        ForEach(days[index].exercises.indices, id: \.self) { exerciseIndex in
                            VStack(alignment: .leading) {
                                TextField("Exercise Name", text: $days[index].exercises[exerciseIndex].name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.bottom, 5)

                                ForEach(days[index].exercises[exerciseIndex].sets.indices, id: \.self) { setIndex in
                                    HStack {
                                        TextField("Reps", value: $days[index].exercises[exerciseIndex].sets[setIndex].reps, formatter: NumberFormatter())
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)

                                        TextField("Weight", value: $days[index].exercises[exerciseIndex].sets[setIndex].weight, formatter: NumberFormatter())
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)
                                    }
                                }
                                Button("Add Set") {
                                    days[index].exercises[exerciseIndex].sets.append(Set(reps: 0, weight: 0))
                                }
                            }
                            .padding(.vertical)
                        }
                        Button("Add Exercise") {
                            days[index].exercises.append(Exercise(name: "", sets: []))
                        }
                    }
                }

                // Save Button
                Button(action: saveProgram) {
                    Text("Save Program")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("New Program")
        }
    }

    // Function to save program
    func saveProgram() {
        // Prepare program data for Firestore
        let program = Program(title: programTitle, days: days)
        let db = Firestore.firestore()

        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not signed in!")
            return
        }

        do {
            let programData = try Firestore.Encoder().encode(program)
            db.collection("users").document(userID).collection("programs").addDocument(data: programData) { error in
                if let error = error {
                    print("Error saving program: \(error.localizedDescription)")
                } else {
                    print("Program saved successfully!")
                }
            }
        } catch {
            print("Error encoding program: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NewProgramView()
}
