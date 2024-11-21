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
    private var elapsedTime: TimeInterval = 0
    private var hours_elapsed: TimeInterval = 0
    private var minutes_elapsed: TimeInterval = 0
    private var seconds_elapsed: TimeInterval = 0

    @EnvironmentObject var sharedData: SharedData
    
    @State private var timerActive = false
    @State private var resetButtonDisabled = false
    
    @State private var timer: Timer? = nil
//    @State private var timerActive: Bool = false
    @FocusState private var focusedField: FocusField?

    enum FocusField {
        case hours, minutes, seconds
    }


    let synthesizer = AVSpeechSynthesizer()
    let aronVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")

    var body: some View {
        AllViews()
    }

    // Timer Logic
//    func startTimer() {
//        timerActive = true
//        resetButtonDisabled = true
//        saveInterval()
//
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
////            elapsedTime += 1
//            if Int(elapsedTime) % calculateIntervalInSeconds() == 0 {
//                speakElapsedTime()
//            }
//        }
//    }
//    func toggleTimer() {
//          if timerActive {
//              // Pause the timer
//              timerActive = false
//          } else {
//              // Start the timer
//              timerActive = true
//              startTimer()
//          }
//      }
//
//    func pauseTimer() {
//        timer?.invalidate()
//        timer = nil
//        timerActive = false
//        resetButtonDisabled = false
//    }
//
//    func resetTimer() {
////        elapsedTime = 0
//        resetButtonDisabled = true
//    }
//
//    func calculateIntervalInSeconds() -> Int {
//        return hours * 3600 + minutes * 60 + seconds
//    }
//
//    // Speech Logic
//    func speakElapsedTime() {
//        let elapsedString = formatElapsedTime(elapsedTime)
//        let systemTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
//        let speech = "Time elapsed: \(elapsedString). Current time: \(systemTime)."
//
//        let utterance = AVSpeechUtterance(string: speech)
//        utterance.voice = aronVoice
//        utterance.rate = 0.5
//        synthesizer.speak(utterance)
//    }

    // Time Formatting
//    func formatTime(_ time: TimeInterval) -> String {
//        let hours = Int(time) / 3600
//        let minutes = (Int(time) % 3600) / 60
//        let seconds = Int(time) % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//
//    func formatElapsedTime(_ time: TimeInterval) -> String {
//        let hours = Int(time) / 3600
//        let minutes = (Int(time) % 3600) / 60
//        let seconds = Int(time) % 60
//
//        var components: [String] = []
//        if hours > 0 { components.append("\(hours) hours") }
//        if minutes > 0 { components.append("\(minutes) minutes") }
//        if seconds > 0 { components.append("\(seconds) seconds") }
//        return components.joined(separator: ", ")
//    }

    // Save and Load Interval
//    func saveInterval() {
//        UserDefaults.standard.set(hours, forKey: "intervalHours")
//        UserDefaults.standard.set(minutes, forKey: "intervalMinutes")
//        UserDefaults.standard.set(seconds, forKey: "intervalSeconds")
//    }

}

#Preview {
    MeditationHelperApp()
}
