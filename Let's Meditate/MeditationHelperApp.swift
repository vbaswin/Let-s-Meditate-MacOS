//
//  MeditationHelperApp.swift
//  Let's Meditate
//
//  Created by Aswin V B on 20/11/24.
//

import SwiftUI
import AVFoundation


struct MeditationHelperApp {

    var sharedData: SharedData
    
    
//    let synthesizer = AVSpeechSynthesizer()
//    let aronVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
    
    init (_sharedData: SharedData) {
        sharedData = _sharedData
    }
    
    func toggleTimer() {
        if sharedData.timer_active {
              // Pause the timer
            sharedData.timer_active = false
            pauseTimer()
          } else {
              // Start the timer
              sharedData.timer_active = true
              startTimer()
          }
      }
    
    func startTimer() {
        
//        if timer != nil {
//            print("Timer already running")
//            return
//        }
        
        print("starting new timer")
        sharedData.timer_active = true
        

        sharedData.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if (sharedData.elapsed_seconds + 1 == 60) {
                if (sharedData.elapsed_minutes + 1 == 60) {
                    sharedData.elapsed_hours += 1;
                    sharedData.elapsed_minutes = 0
                } else {
                    sharedData.elapsed_minutes += 1;
                }
                sharedData.elapsed_seconds = 0
            } else{
                sharedData.elapsed_seconds += 1;
            }
        }
    }



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
    func pauseTimer() {
//        print("inside stop timer")
//        if timer != nil {
//            print("timer is not nil")
//        }
        sharedData.timer?.invalidate()
        sharedData.timer = nil
        sharedData.timer_active = false
//        resetButtonDisabled = false
    }
    
    func resetTimer() {
        pauseTimer() // Stop the timer
        sharedData.elapsed_hours = 0
        sharedData.elapsed_minutes = 0
        sharedData.elapsed_seconds = 0
    }
    
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

//#Preview {
//    MeditationHelperApp()
//}
