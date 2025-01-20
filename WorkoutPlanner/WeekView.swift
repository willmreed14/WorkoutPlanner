//
//  WeekView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let daysOfWeek = [
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    ]

    var body: some View {
        NavigationView {
            List(daysOfWeek, id: \.self) { day in
                NavigationLink(destination: WorkoutDayView(day: day)) { // pass in the day
                    Text(day)
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Week View")
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
    }
}

#Preview {
    WeekView()
}
