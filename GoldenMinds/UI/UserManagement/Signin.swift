import SwiftUI

struct SignInView: View {
    @State private var showUIDPassView = false
    @State private var showSignUpView = false
    @Environment(\.dismiss) private var dismiss // Use dismiss to handle returning

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            Spacer()

            // Login Options
            VStack(spacing: 20) {
                SignInButton(label: "Login with Gmail", iconName: "envelope.fill")
                SignInButton(label: "Login with Instagram", iconName: "camera.fill")
                SignInButton(label: "Login with LinkedIn", iconName: "link.circle.fill")
                SignInButton(label: "Login with User ID/Password", iconName: "person.fill") {
                    showUIDPassView = true
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // Sign Up Button
            Button(action: {
                showSignUpView = true
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            // Cancel Button
            Button(action: {
                dismiss() // Dismiss the current view
            }) {
                Text("Cancel")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)

        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showSignUpView) {
            SignUpView()
        }
        .sheet(isPresented: $showUIDPassView) {
            SignInUsingUidPassView(isUserLoggedIn: .constant(false))
        }
    }
}

// Custom Sign In Button View
struct SignInButton: View {
    let label: String
    let iconName: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                    .frame(width: 40, height: 40)
                Text(label)
                    .font(.headline)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.blue)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}
