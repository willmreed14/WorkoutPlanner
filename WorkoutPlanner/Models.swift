//
//  Models.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/17/25.
//

import Foundation

struct Exercise: Identifiable {
    let id = UUID() // Unique identifier
    let name: String
    let sets: [Set]
}

struct Set: Identifiable {
    let id = UUID() // Unique identifier
    let number: Int
    let reps: Int
    let weight: Int
}
