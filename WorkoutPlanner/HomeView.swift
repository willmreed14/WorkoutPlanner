//
//  HomeView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/20/25.
//

import SwiftUI

struct HomeView: View {
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
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
