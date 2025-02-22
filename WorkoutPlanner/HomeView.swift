//
//  HomeView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/20/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel // Access authentication model
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Welcome to LiftLog!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                
                // Navigate to program creation
                NavigationLink(destination: NewProgramView()) {
                    Text("Create New Program")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                // Sign Out Button
                Button(action: {
                    authViewModel.signOut()
                }){
                    Text("Sign Out")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel()) // Ensure environment object is provided
}
