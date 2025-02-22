//
//  SignUpView.swift
//  WorkoutPlanner
//
//  Created by Will Reed on 1/19/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) private var dismiss // Add dismiss environment variable

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.signUpSuccess {
                    // Confirmation Message
                    VStack {
                        Text("Account Created!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                            .padding(.bottom, 10)

                        Text("You can now sign in using your email and password.")
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        Button(action: {
                            dismiss() // Navigate back
                        }) {
                            Text("Go to Sign In")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        /*
                        NavigationLink(destination: SignInView()) {
                            Text("Go to Sign In")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                         }
                         */
                        .padding()
                    }
                    .padding()
                } else {
                    // Sign-Up Form
                    Text("Sign Up")
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

                    Button(action: { viewModel.signUp(email: email, password: password) }) {
                        Text("Sign Up")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    SignUpView()
}
