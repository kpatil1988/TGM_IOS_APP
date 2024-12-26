//
//  MoodCheckinViewModel.swift
//  GoldenMinds
//
//  Created by Karthik patil on 25/12/24.
//


import SwiftUI

// Sample view model; ensure this is fleshed out with the necessary logic
class MoodCheckinViewModel: ObservableObject {
    @Published var selectedLogType: String = "Instant Love"
    @Published var selectedMoods: [String] = []
    @Published var moodNote: String = ""
    @Published var activityFeedback: String = ""

    func resetState() {
        selectedLogType = "Instant Love"
        selectedMoods.removeAll()
        moodNote = ""
        activityFeedback = ""
    }
}
