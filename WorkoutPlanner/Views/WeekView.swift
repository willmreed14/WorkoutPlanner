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
                print("❌ Error fetching active program ID: \(error.localizedDescription)")
                loading = false
                return
            }
            
            guard let activeProgramID = document?.data()?["activeProgram"] as? String else {
                print("⚠️ No active program found.")
                loading = false
                return
            }
            
            let programRef = db.collection("users").document(userID).collection("programs").document(activeProgramID)
            programRef.getDocument { programDoc, error in
                if let error = error {
                    print("❌ Error fetching active program: \(error.localizedDescription)")
                    loading = false
                    return
                }
                if let programData = programDoc?.data() {
                    print("🔥 Firestore Raw Data: \(programData)")
                    if let daysArray = programData["days"] as? [[String: Any]] {
                        do {
                            // Extract and print raw program data
                            print("🔥 Firestore Raw Data: \(programData)")

                            // Extract title
                            let programTitle = programData["title"] as? String ?? "Untitled Program"
                            print("✅ Decoded Title: \(programTitle)")

                            // Extract days array safely
                            guard let daysRaw = programData["days"] as? [[String: Any]] else {
                                print("❌ Error: Could not find 'days' array")
                                return
                            }
                            
                            // Decode days manually
                            let jsonDaysData = try JSONSerialization.data(withJSONObject: daysRaw)
                            let decodedDays = try JSONDecoder().decode([Day].self, from: jsonDaysData)
                            print("✅ Successfully Decoded Days: \(decodedDays)")

                            // Manually construct the Program object
                            let decodedProgram = Program(id: activeProgramID, title: programTitle, days: decodedDays)
                            print("✅ Successfully Constructed Program: \(decodedProgram)")

                        } catch {
                            print("❌ Error Decoding Full Program: \(error.localizedDescription)")
                        }

                    }

                    /*
                     if let daysArray = programData["days"] as? [[String: Any]] {
                     for (dayIndex, day) in daysArray.enumerated() {
                     print("🟢 Day \(dayIndex + 1) Title: \(day["title"] ?? "Unknown")")
                     
                     if let exercisesArray = day["exercises"] as? [[String: Any]] {
                     for (exerciseIndex, exercise) in exercisesArray.enumerated() {
                     print("🟡 Exercise \(exerciseIndex + 1): \(exercise)")
                     
                     // Check if title exists
                     if exercise["title"] == nil {
                     print("❌ ERROR: Missing 'title' field in Exercise \(exerciseIndex + 1) of Day \(dayIndex + 1)")
                     }
                     
                     // Check if sets exist
                     if let setsArray = exercise["sets"] as? [[String: Any]] {
                     for (setIndex, set) in setsArray.enumerated() {
                     print("   🔹 Set \(setIndex + 1): \(set)")
                     
                     // Check if reps and weight exist
                     if set["reps"] == nil || set["weight"] == nil {
                     print("❌ ERROR: Missing 'reps' or 'weight' in Set \(setIndex + 1) of Exercise \(exerciseIndex + 1)")
                     }
                     }
                     } else {
                     print("❌ ERROR: Missing or incorrect 'sets' array in Exercise \(exerciseIndex + 1) of Day \(dayIndex + 1)")
                     }
                     }
                     } else {
                     print("🔴 ERROR: Exercises missing for Day \(dayIndex + 1)")
                     }
                     }
                     }
                     */
                    
                    /*
                     if let daysArray = programData["days"] as? [[String: Any]] {
                     for (index, day) in daysArray.enumerated() {
                     print("🟢 Day \(index + 1) Title: \(day["title"] ?? "Unknown")")
                     
                     if let exercisesArray = day["exercises"] as? [[String: Any]] {
                     print("🟡 Exercises for Day \(index + 1): \(exercisesArray)")
                     } else {
                     print("🔴 Exercises missing or empty for Day \(index + 1)")
                     }
                     }
                     } else {
                     print("❌ Error: Days array is missing or not in the expected format")
                     }
                     }
                     */
                    /*
                     if let programData = programDoc?.data() {
                     print("🔥 Firestore Raw Data: \(programData)") // Log Firestore data
                     
                     do {
                     // ✅ Step 1: Decode only the title
                     let title = programData["title"] as? String ?? "Unknown"
                     print("✅ Decoded Title: \(title)")
                     
                     // ✅ Step 2: Decode only days array
                     let daysArray = programData["days"] as? [[String: Any]]
                     print("✅ Decoded Days Raw: \(String(describing: daysArray))")
                     
                     // ✅ Step 3: Decode entire program
                     let program = try Firestore.Decoder().decode(Program.self, from: programData)
                     print("✅ Fully Decoded Program: \(program)")
                     
                     // ✅ Update UI with decoded data
                     self.days = program.days
                     } catch {
                     print("❌ Error decoding program: \(error.localizedDescription)")
                     }
                     */
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
