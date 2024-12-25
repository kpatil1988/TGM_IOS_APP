//
//  MoodCheckinViewModel.swift
//  GoldenMinds
//
//  Created by Karthik patil on 25/12/24.
//


import SwiftUI

class MoodCheckinViewModel: ObservableObject {
    @Published var selectedLogType: String = "Morning Log" // Selected log type
    @Published var selectedMoods: [String] = [] // Selected moods
    @Published var moodNote: String = "" // Mood note text
    @Published var activityFeedback: String = "" // For instant log feedback

    func resetState() {
        selectedLogType = "Morning Log"
        selectedMoods.removeAll()
        moodNote = ""
        activityFeedback = ""
    }
}
