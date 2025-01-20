//
//  SignInView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: { viewModel.signIn(email: email, password: password) }) {
                Text("Sign In")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            NavigationLink(destination: SignUpView()) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    SignInView()
}
