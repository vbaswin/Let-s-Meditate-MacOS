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

struct MeditationHelperApp: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var interval: TimeInterval = 10 // Default interval (in seconds)
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    @State private var resetButtonDisabled = true
    @State private var selectedVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-US")

    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 10) {
            stopwatchView
            intervalSelectorView
            actionButtons
            voicePickerView
        }
        .padding()
//        .frame(width: 300)
        .onAppear {
            setupFloatingWindow()
        }
    }

    // Subviews for better readability and compiler performance

    var stopwatchView: some View {
        Text(formatTime(elapsedTime))
            .font(.system(size: 50))
            .padding()
    }

    var intervalSelectorView: some View {
        VStack(spacing: 5) {
            Text("Select Interval")
                .font(.system(size: 14))
            HStack(spacing: 5) {
                intervalPicker(label: "Hours", value: Binding(
                    get: { Int(interval / 3600) },
                    set: { interval = TimeInterval($0 * 3600 + minutesComponent() * 60 + secondsComponent()) }
                ))
                intervalPicker(label: "Minutes", value: Binding(
                    get: { minutesComponent() },
                    set: { interval = TimeInterval(Int(interval / 3600) * 3600 + $0 * 60 + secondsComponent()) }
                ))
                intervalPicker(label: "Seconds", value: Binding(
                    get: { secondsComponent() },
                    set: { interval = TimeInterval(Int(interval / 3600) * 3600 + minutesComponent() * 60 + $0) }
                ))
            }
        }
    }

    func intervalPicker(label: String, value: Binding<Int>) -> some View {
        Picker(label, selection: value) {
            ForEach(0..<60) { item in
                Text("\(item)").tag(item)
            }
        }
        .frame(width: 60)
        .clipped()
    }

    var actionButtons: some View {
        HStack(spacing: 10) {
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
    }

    var voicePickerView: some View {
        Picker("Voice", selection: Binding(
            get: { selectedVoice },
            set: { selectedVoice = $0 }
        )) {
            ForEach(AVSpeechSynthesisVoice.speechVoices(), id: \.identifier) { voice in
                Text(voice.name).tag(voice as AVSpeechSynthesisVoice?)
            }
        }
        .pickerStyle(.menu)
        .frame(width: 200)
    }

    // Helper functions
    func startTimer() {
        timerActive = true
        resetButtonDisabled = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
            if elapsedTime.truncatingRemainder(dividingBy: interval) == 0 {
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

    func speakElapsedTime() {
        let elapsedString = formatElapsedTime(elapsedTime)
        let systemTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let speech = "Time elapsed. \(elapsedString). Current time. \(systemTime)"

        let utterance = AVSpeechUtterance(string: speech)
        utterance.voice = selectedVoice ?? AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

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

    func minutesComponent() -> Int {
        return (Int(interval) % 3600) / 60
    }

    func secondsComponent() -> Int {
        return Int(interval) % 60
    }

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
