//
//  WeekView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI

struct WeekView: View {
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
    }
}

#Preview {
    WeekView()
}
