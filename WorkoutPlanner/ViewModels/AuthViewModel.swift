import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: User? // Store the current Firebase user
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? // error message if login does not work
    @Published var signUpSuccess: Bool = false // Track successful sign up

    init() {
        // Check if a user is already signed in when the app launches
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                // Update errorMessage with a user-friendly message
                self?.errorMessage = "Invalid credentials. Please try again."
                print("Error signing in: \(error.localizedDescription)")
            } else {
                self?.user = result?.user
                self?.isAuthenticated = true
                self?.errorMessage = nil
                print("Successfully signed in as \(self?.user?.email ?? "Unknown User")")
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }

            self?.user = result?.user
            self?.isAuthenticated = true
            self?.signUpSuccess = true
            print("Successfully signed up as \(self?.user?.email ?? "Unknown User")")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
