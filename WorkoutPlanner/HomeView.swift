//
//  HomeView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/20/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Welcome to LiftLog!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                
                // Navigate to current program
                NavigationLink(destination: WeekView()) {
                    Text("Current Program")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
                
                // Navigate to program selection
                NavigationLink(destination: ProgramsView()) {
                    Text("My Programs")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
  
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
                
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
