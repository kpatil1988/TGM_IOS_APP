//
//  Landing.swift
//  GoldenMinds
//
//  Created by Karthik patil on 25/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isUserLoggedIn = false
    @State private var isSidebarVisible = true
    @State private var showSignIn = false
    @State private var showSignUp = false


    var body: some View {
        NavigationView {
            ZStack { // Use ZStack to layer views appropriately
                // Background Color
                Color(UIColor.systemGray6) // Light gray background
                    .ignoresSafeArea() // Stretch to edges

                VStack(spacing: 0) { // Use zero spacing to avoid gaps between elements
                    /* HeaderView(
                        isUserLoggedIn: $isUserLoggedIn,
                        showSignIn : $showSignIn,
                        showSignUp : $showSignUp,
                        isSidebarVisible: $isSidebarVisible // Match the binding required
                        
                    ) */

                    Text("Welcome! Please Sign In.")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.primary) // Dynamic foreground color

                    Spacer() // Add spacer to push content down
                }
                .padding(.top, 0) // Remove top padding in VStack
            }
            .navigationBarHidden(true) // Hide the navigation bar
            .sheet(isPresented: $showSignIn) {
                SignInView() // Present sign-in view
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView() // Present sign-up view
            }
        }
    }
}
