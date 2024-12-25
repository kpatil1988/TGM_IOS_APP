import SwiftUI

struct SignInUsingUidPassView: View {
    @Binding var isUserLoggedIn: Bool
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.dismiss) var dismiss // Environment variable to dismiss the view

    var body: some View {
        VStack {
            Text("Sign In with User ID and Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            TextField("Email", text: $userID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: handleSignIn) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            Spacer()

            // Cancel Button
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }

    private func handleSignIn() {
        if userID.isEmpty || password.isEmpty {
            alertMessage = "Please enter a User ID and Password"
            showAlert = true
        } else if !isValidEmail(userID) {
            alertMessage = "Please enter a valid email address"
            showAlert = true
        } else {
            // Simulate successful login
            isUserLoggedIn = true
            dismiss() // Dismiss the view upon successful login
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
