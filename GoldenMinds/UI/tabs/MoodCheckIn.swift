import SwiftUI
import Speech
import AVFoundation



struct MoodCheckinView: View {
    @ObservedObject var viewModel: MoodCheckinViewModel
    @State private var moodFilter: String = ""
    @State private var isDropdownOpen: Bool = false
    @State private var isMoodNoteSubmitted: Bool = false
    
    // State for speech recognition
    @State private var isRecording = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?

    let moodTags = ["Happy", "Sad", "Anxious", "Excited", "Calm", "Angry"]

    var filteredMoodTags: [String] {
        if moodFilter.isEmpty {
            return moodTags
        } else {
            return moodTags.filter { $0.lowercased().contains(moodFilter.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            Text("Mood Check-In")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Picker("Select Log Type", selection: $viewModel.selectedLogType) {
                Text("Instant Love").tag("Instant Love")
                Text("Morning Log").tag("Morning Log")
                Text("Night Log").tag("Night Log")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            VStack(spacing: 15) {
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
                                    viewModel.selectedMoods.removeAll(where: { $0 == mood })
                                } else if viewModel.selectedMoods.count < 5 {
                                    viewModel.selectedMoods.append(mood)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .padding(.vertical)
                }

                // Mood Note Input with Speech-to-Text Button
                HStack {
                    TextField("Mood Note", text: $viewModel.moodNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(height: 100)

                    Button(action: toggleRecording) {
                        Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .disabled(!(speechRecognizer?.isAvailable ?? false) || !isAuthorized())
                }

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
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: requestSpeechAuthorization)
    }

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                if authStatus != .authorized {
                    print("Speech recognition authorization denied")
                }
            }
        }
    }

    private func toggleRecording() {
        if isRecording {
            stopSpeechRecognition()
        } else {
            startSpeechRecognition()
        }
    }

    private func startSpeechRecognition() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Can't create recognition request.")
        }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.viewModel.moodNote = result.bestTranscription.formattedString
            }

            if error != nil || result?.isFinal == true {
                self.stopSpeechRecognition()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
        }
    }

    private func stopSpeechRecognition() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }

    private func isAuthorized() -> Bool {
        return SFSpeechRecognizer.authorizationStatus() == .authorized
    }

    private func submitMoodLog() {
        print("Logging Mood: \(viewModel.moodNote)")
        viewModel.resetState()
    }

    private func submitFeedback() {
        print("Feedback: \(viewModel.activityFeedback)")
        isMoodNoteSubmitted = false
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

struct MoodCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheckinView(viewModel: MoodCheckinViewModel())
    }
}
