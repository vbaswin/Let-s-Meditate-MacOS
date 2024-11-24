//
//  MeditationHelperApp.swift
//  Let's Meditate
//
//  Created by Aswin V B on 20/11/24.
//

import SwiftUI
import AVFoundation

struct MeditationHelperApp: View {
    @State private var interval_hours: Int = UserDefaults.standard.integer(forKey: "intervalHours")
    @State private var interval_minutes: Int = UserDefaults.standard.integer(forKey: "intervalMinutes")
    @State private var interval_seconds: Int = UserDefaults.standard.integer(forKey: "intervalSeconds")
    
    @State private var elapsed_seconds: Int = 0
    @State private var elapsed_minutes: Int = 0
    @State private var elapsed_hours: Int = 0
    

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
            timer_view
            intervalSelectorView
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
    
    var timer_view: some View {
        HStack {
                        // Hours Box
            TextField("00", value: $elapsed_hours, formatter: NumberFormatter())
                            .frame(width: 50, height: 40)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)
//                            .disabled(true)

                        Text(":")

                        // Minutes Box
            TextField("00", value: $elapsed_minutes, formatter: NumberFormatter())
                            .frame(width: 50, height: 40)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)

                        Text(":")

                        // Seconds Box
            TextField("00", value: $elapsed_seconds, formatter: NumberFormatter())
                            .frame(width: 50)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)
                    }
                    .font(.title)
    }

    var intervalSelectorView: some View {
//        VStack(spacing: 10) {
//            Text("Select Interval")
//                .font(.system(size: 14))
            HStack(spacing: 7) {
                timeSelectionControl(label: "Hours", value: $interval_hours, range: 0...Int.max, field: .hours)
                timeSelectionControl(label: "Minutes", value: $interval_minutes, range: 0...59, field: .minutes)
                timeSelectionControl(label: "Seconds", value: $interval_seconds, range: 0...59, field: .seconds)
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
            if elapsed_seconds + 1 == 60 {
                if elapsed_minutes + 1 == 60 {
                    elapsed_hours += 1
                    elapsed_minutes = 0
                } else {
                    elapsed_minutes += 1
                }
                elapsed_seconds = 0
                    
            } else {
                elapsed_seconds += 1;
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
        elapsed_hours = 0
        elapsed_minutes = 0
        elapsed_seconds = 0
        resetButtonDisabled = true
    }


    // Speech Logic
    func speakElapsedTime() {
        let systemTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let speech = "Time elapsed: \(elapsed_hours):\(elapsed_minutes):\(elapsed_seconds). Current time: \(systemTime)."

        let utterance = AVSpeechUtterance(string: speech)
        utterance.voice = aronVoice
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }




    // Save and Load Interval
    func saveInterval() {
        UserDefaults.standard.set(interval_hours, forKey: "intervalHours")
        UserDefaults.standard.set(interval_minutes, forKey: "intervalMinutes")
        UserDefaults.standard.set(interval_seconds, forKey: "intervalSeconds")
    }

    func loadSavedInterval() {
        interval_hours = UserDefaults.standard.integer(forKey: "intervalHours")
        interval_minutes = UserDefaults.standard.integer(forKey: "intervalMinutes")
        interval_seconds = UserDefaults.standard.integer(forKey: "intervalSeconds")
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
