//
//  RootView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group { // is user authenticated?
            if authViewModel.isAuthenticated {
                WeekView() // redirect to home page if auth'd
            } else {
                SignInView() // otherwise, direct to sign-in
            }
        }
        .environmentObject(authViewModel) // pass the authViewModel to child views
        .onAppear{
            authViewModel.isAuthenticated = Auth.auth().currentUser != nil
        }
    }
}

#Preview {
    RootView()
}
