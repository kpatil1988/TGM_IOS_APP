import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isTermsAccepted: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Toggle("I accept the Terms and Conditions", isOn: $isTermsAccepted)
                .padding()

            Button(action: {
                if email.isEmpty || password.isEmpty || !isTermsAccepted {
                    showAlert = true
                } else {
                    print("User signed up with Email: \(email) and Password: \(password)")
                }
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please fill in all fields and accept the terms"), dismissButton: .default(Text("OK")))
            }

            Spacer()

            // Cancel Button
            Button(action: {
                dismiss() // Dismiss the sign-up view
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
}
