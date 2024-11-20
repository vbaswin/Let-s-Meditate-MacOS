//
//  MeditationHelperApp.swift
//  Let's Meditate
//
//  Created by Aswin V B on 20/11/24.
//

import SwiftUI
import AVFoundation
import SwiftUI
import AVFoundation
import SwiftUI
import AVFoundation

struct MeditationHelperApp: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var hours: Int = UserDefaults.standard.integer(forKey: "intervalHours")
    @State private var minutes: Int = UserDefaults.standard.integer(forKey: "intervalMinutes")
    @State private var seconds: Int = UserDefaults.standard.integer(forKey: "intervalSeconds")
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    @State private var resetButtonDisabled = true
//    @State private var timerActive: Bool = false
    @FocusState private var focusedField: FocusField?

    enum FocusField {
        case hours, minutes, seconds
    }


    let synthesizer = AVSpeechSynthesizer()
    let aronVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")

    var body: some View {
        VStack(spacing: 10) {
            // Stopwatch
            Text(formatTime(elapsedTime))
                .font(.system(size: 50))
                .padding()

            // Interval Selector
            intervalSelectorView

            // Buttons
            actionButtons
        }
        .padding(.top, 10)
        .padding(.bottom, 40)
        .frame(width: 300)
        .onAppear {
            setupFloatingWindow()
            loadSavedInterval()
        }
    }

    var intervalSelectorView: some View {
//        VStack(spacing: 10) {
//            Text("Select Interval")
//                .font(.system(size: 14))
            HStack(spacing: 7) {
                timeSelectionControl(label: "Hours", value: $hours, range: 0...Int.max, field: .hours)
                timeSelectionControl(label: "Minutes", value: $minutes, range: 0...59, field: .minutes)
                timeSelectionControl(label: "Seconds", value: $seconds, range: 0...59, field: .seconds)
            }
            .onAppear {
                 focusedField = .minutes
             }
//        }
    }

    func timeSelectionControl(label: String, value: Binding<Int>, range: ClosedRange<Int>, field: FocusField) -> some View {
        VStack {
            Text(label).font(.system(size: 12))
            HStack(spacing: 5) {
//                Stepper("", value: value, in: range)
//                    .labelsHidden()
                TextField("0", value: value, formatter: NumberFormatter(), onCommit: {
                    validateTimeValue(binding: value, range: range)
                    startTimer()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: field)
            }
        }
        .frame(width: 100)
    }

    // Validate time values to ensure they're within 0-59 range for minutes/seconds
    func validateTimeValue(binding: Binding<Int>, range: ClosedRange<Int>) {
        if binding.wrappedValue < range.lowerBound {
            binding.wrappedValue = range.lowerBound
        } else if binding.wrappedValue > range.upperBound {
            binding.wrappedValue = range.upperBound
        }
    }
//


    func stepperView(label: String, value: Binding<Int>) -> some View {
        VStack {
            Text(label).font(.system(size: 12))
            Stepper(value: value, in: 0...59, step: 1) {
                Text("\(value.wrappedValue)")
                    .frame(width: 40, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .frame(width: 80)
    }

    var actionButtons: some View {
        HStack(spacing: 20) {
            Button(timerActive ? "Pause" : "Start") {
                if timerActive {
                    pauseTimer()
                } else {
                    startTimer()
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Reset") {
                resetTimer()
            }
            .buttonStyle(.bordered)
            .disabled(resetButtonDisabled)
        }
        .padding(.top, 30)
    }

    // Timer Logic
    func startTimer() {
        timerActive = true
        resetButtonDisabled = true
        saveInterval()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
            if Int(elapsedTime) % calculateIntervalInSeconds() == 0 {
                speakElapsedTime()
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        timerActive = false
        resetButtonDisabled = false
    }

    func resetTimer() {
        elapsedTime = 0
        resetButtonDisabled = true
    }

    func calculateIntervalInSeconds() -> Int {
        return hours * 3600 + minutes * 60 + seconds
    }

    // Speech Logic
    func speakElapsedTime() {
        let elapsedString = formatElapsedTime(elapsedTime)
        let systemTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let speech = "Time elapsed: \(elapsedString). Current time: \(systemTime)."

        let utterance = AVSpeechUtterance(string: speech)
        utterance.voice = aronVoice
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    // Time Formatting
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func formatElapsedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60

        var components: [String] = []
        if hours > 0 { components.append("\(hours) hours") }
        if minutes > 0 { components.append("\(minutes) minutes") }
        if seconds > 0 { components.append("\(seconds) seconds") }
        return components.joined(separator: ", ")
    }

    // Save and Load Interval
    func saveInterval() {
        UserDefaults.standard.set(hours, forKey: "intervalHours")
        UserDefaults.standard.set(minutes, forKey: "intervalMinutes")
        UserDefaults.standard.set(seconds, forKey: "intervalSeconds")
    }

    func loadSavedInterval() {
        hours = UserDefaults.standard.integer(forKey: "intervalHours")
        minutes = UserDefaults.standard.integer(forKey: "intervalMinutes")
        seconds = UserDefaults.standard.integer(forKey: "intervalSeconds")
    }

    // Window Configuration
    func setupFloatingWindow() {
        if let window = NSApplication.shared.windows.first {
            window.level = .floating
            window.isMovableByWindowBackground = true
            window.setFrame(NSRect(x: 100, y: 100, width: 300, height: 300), display: true)
        }
    }
}

#Preview {
    MeditationHelperApp()
}
