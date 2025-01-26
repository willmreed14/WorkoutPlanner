//
//  Models.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/17/25.
//

import Foundation
import FirebaseFirestore

/*
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
*/

// Data Models
struct Program: Codable, Identifiable {
    @DocumentID var id: String? // Firestore document ID
    var title: String
    var days: [Day]
}

struct Day: Codable {
    var title: String
    var exercises: [Exercise]
}

struct Exercise: Codable {
    var name: String
    var sets: [Set]
}

struct Set: Codable {
    var reps: Int
    var weight: Int
}
