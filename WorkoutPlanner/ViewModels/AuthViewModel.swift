import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil
                self?.isAuthenticated = true
                print("User signed in: \(result?.user.uid ?? "")")
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil
                self?.isAuthenticated = true
                print("User signed up: \(result?.user.uid ?? "")")
            }
        }
    }
}
