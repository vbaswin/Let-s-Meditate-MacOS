//
//  MeditationHelperApp.swift
//  Let's Meditate
//
//  Created by Aswin V B on 20/11/24.
//

import SwiftUI
import AVFoundation

struct MeditationHelperApp: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var interval: TimeInterval = 10 // Default interval (in seconds)
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    @State private var resetButtonDisabled = true

    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 20) {
            // Stopwatch TextBox
            Text(formatTime(elapsedTime))
                .font(.largeTitle)
                .padding()

            // Interval Selector
            VStack {
                Text("Select Interval")
                    .font(.headline)
                HStack(spacing: 10) {
                    // Hours Picker
                    Picker("Hours", selection: Binding(
                        get: { Int(interval / 3600) },
                        set: { interval = TimeInterval($0 * 3600 + minutesComponent() * 60 + secondsComponent()) }
                    )) {
                        ForEach(0..<24) { hour in
                            Text("\(hour) h").tag(hour)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)

                    // Minutes Picker
                    Picker("Minutes", selection: Binding(
                        get: { minutesComponent() },
                        set: { interval = TimeInterval(Int(interval / 3600) * 3600 + $0 * 60 + secondsComponent()) }
                    )) {
                        ForEach(0..<60) { minute in
                            Text("\(minute) m").tag(minute)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)

                    // Seconds Picker
                    Picker("Seconds", selection: Binding(
                        get: { secondsComponent() },
                        set: { interval = TimeInterval(Int(interval / 3600) * 3600 + minutesComponent() * 60 + $0) }
                    )) {
                        ForEach(0..<60) { second in
                            Text("\(second) s").tag(second)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }
            }

            // Buttons
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
        }
        .padding()
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
        let elapsedString = formatTime(elapsedTime)
        let systemTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        let speech = "Time elapsed: \(elapsedString). Current time: \(systemTime)."

        let utterance = AVSpeechUtterance(string: speech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func minutesComponent() -> Int {
        return (Int(interval) % 3600) / 60
    }

    func secondsComponent() -> Int {
        return Int(interval) % 60
    }
}

//struct MeditationHelperApp_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationHelperApp()
//    }
//}

#Preview {
    MeditationHelperApp()
}
