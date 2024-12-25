//
//  DailyNurtures.swift
//  GoldenMinds
//
//  Created by Karthik patil on 25/12/24.
//
import SwiftUI

struct DailyNurturesView: View {
    @State private var isUserLoggedIn = false  // Tracks user login state
    @State private var isSidebarVisible = false
    @State private var showSignIn = false
    @State private var showSignUp = false

    var body: some View {
        VStack {
//            HeaderView(
//                isUserLoggedIn: $isUserLoggedIn,
//                showSignIn : $showSignIn,
//                showSignUp : $showSignUp,
//                isSidebarVisible: $isSidebarVisible // Match the binding required
//                
//            )

            // Main content for Daily Nurtures
            Text("Daily Nurtures")
                .font(.title)
                .padding()

            // Add your list or activity content...
            Spacer()
        }
    }
}
