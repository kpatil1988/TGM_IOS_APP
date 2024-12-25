import SwiftUI

struct MoodCheckinView: View {
    @ObservedObject var viewModel: MoodCheckinViewModel // Accept the view model
    @State private var moodFilter: String = "" // For filtering mood tags
    @State private var isDropdownOpen: Bool = false // Controls the dropdown visibility
    @State private var isMoodNoteSubmitted: Bool = false // Tracks if mood note is submitted
    @State private var isUserLoggedIn = false
    @State private var isSidebarVisible = false
    @State private var showSignIn = false
    @State private var showSignUp = false
    
    // Sample mood tags
    let moodTags = ["Happy", "Sad", "Anxious", "Excited", "Calm", "Angry"]

    // Computed property for filtered mood tags
    var filteredMoodTags: [String] {
        if moodFilter.isEmpty {
            return moodTags
        } else {
            return moodTags.filter { $0.lowercased().contains(moodFilter.lowercased()) }
        }
    }

    var body: some View {
        VStack {
//            HeaderView(
//                isUserLoggedIn: $isUserLoggedIn,
//                showSignIn : $showSignIn,
//                showSignUp : $showSignUp,
//                isSidebarVisible: $isSidebarVisible // Match the binding required
//                
//            )
            
            Text("Mood Check-In")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Picker for selecting log type (Changed order)
            Picker("Select Log Type", selection: $viewModel.selectedLogType) {
                Text("Instant Love").tag("Liquid Love")
                Text("Morning Log").tag("Morning Log")
                Text("Night Log").tag("Night Log")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // Mood input form based on selected log type
            VStack(spacing: 15) {
                // Filterable mood tag dropdown
                HStack {
                    TextField("Filter Moods...", text: $moodFilter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onTapGesture {
                            isDropdownOpen.toggle()
                        }

                    Button(action: {
                        isDropdownOpen.toggle()
                    }) {
                        Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                    }
                }

                if isDropdownOpen {
                    ScrollView {
                        ForEach(filteredMoodTags, id: \.self) { mood in
                            MultipleSelectionRow(title: mood, isSelected: viewModel.selectedMoods.contains(mood)) {
                                if viewModel.selectedMoods.contains(mood) {
                                    viewModel.selectedMoods.remove(at: viewModel.selectedMoods.firstIndex(of: mood)!)
                                } else if viewModel.selectedMoods.count < 5 {
                                    viewModel.selectedMoods.append(mood)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .padding(.vertical)
                }

                // Showing selected moods
                if !viewModel.selectedMoods.isEmpty {
                    Text("Selected Moods:")
                        .font(.headline)
                        .padding(.leading, 20)

                    HStack {
                        ForEach(viewModel.selectedMoods, id: \.self) { mood in
                            HStack {
                                Text(mood)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(5)

                                Button(action: {
                                    viewModel.selectedMoods.removeAll(where: { $0 == mood })
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Enlarged Mood Note input
                TextField("Mood Note", text: $viewModel.moodNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(height: 100)

                Button(action: {
                    submitMoodLog()
                }) {
                    Text("Submit Mood Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .onTapGesture {
                    if viewModel.selectedLogType == "Instant Love" {
                        isMoodNoteSubmitted = true
                    }
                }

                // Additional feedback field and submit feedback button for Instant Love
                if viewModel.selectedLogType == "Instant Love" && isMoodNoteSubmitted {
                    TextField("Activity Feedback", text: $viewModel.activityFeedback)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(height: 100)

                    Button(action: {
                        submitFeedback()
                    }) {
                        Text("Submit Feedback")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }

    private func submitMoodLog() {
        // Handle the mood log submission
        print("Log Type: \(viewModel.selectedLogType)")
        print("Selected Moods: \(viewModel.selectedMoods)")
        print("Mood Note: \(viewModel.moodNote)")
        if viewModel.selectedLogType == "Instant Love" {
            print("Activity Feedback: \(viewModel.activityFeedback)")
        }
    }

    private func submitFeedback() {
        // Handle feedback submission
        print("Feedback: \(viewModel.activityFeedback)")
        isMoodNoteSubmitted = false // Reset for next operation
        viewModel.resetState() // Clear states after submission
    }
}

// Custom Row for multi-selection
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(5)
        }
    }
}


