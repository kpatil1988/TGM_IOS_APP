// HeaderView.swift
import SwiftUI

struct HeaderView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var showSignIn: Bool
    @Binding var showSignUp: Bool

    var body: some View {
        HStack {
            Text("GoldenMinds")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            Menu {
                if isUserLoggedIn {
                    Button(action: { /* Profile action */ }) {
                        Label("Profile", systemImage: "person.fill")
                    }
                    Button(action: { signOut() }) {
                        Label("Sign Out", systemImage: "arrow.right.circle.fill")
                    }
                } else {
                    Button(action: {
                        showSignIn = true
                    }) {
                        Label("Sign In", systemImage: "arrow.forward.circle.fill")
                    }
                    Button(action: {
                        showSignUp = true
                    }) {
                        Label("Sign Up", systemImage: "person.badge.plus")
                    }
                }
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $showSignIn) {
                SignInView()
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
        .padding(.vertical)
        .background(Color(UIColor.systemGray6))
    }

    private func signOut() {
        isUserLoggedIn = false
    }
}
