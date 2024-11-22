//
//  all_views.swift
//  Let's Meditate
//
//  Created by Aswin V B on 21/11/24.
//

import SwiftUI

struct AllViews: View {
    @EnvironmentObject var sharedData: SharedData
    @FocusState private var focusedField: FocusField?

    enum FocusField {
        case hours, minutes, seconds
    }

    
    var body: some View {
        VStack(spacing: 10) {
            // timer view
            timer_view

            // Interval Selector
            intervalSelectorView

            // Buttons
//            actionButtons
        }
        .padding(.top, 10)
        .padding(.bottom, 40)
        .frame(width: 300)
        .onAppear {
            setupFloatingWindow()
//            loadSavedInterval()
        }
    }
    
    var timer_view: some View {
        HStack {
                        // Hours Box
            TextField("00", value: $sharedData.elapsed_hours, formatter: NumberFormatter())
                            .frame(width: 50, height: 40)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)
//                            .disabled(true)
                        
                        Text(":")
                        
                        // Minutes Box
            TextField("00", value: $sharedData.elapsed_minutes, formatter: NumberFormatter())
                            .frame(width: 50, height: 40)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)
                        
                        Text(":")
                        
                        // Seconds Box
            TextField("00", value: $sharedData.elapsed_seconds, formatter: NumberFormatter())
                            .frame(width: 50)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .padding(5)
                            .multilineTextAlignment(.center)
                    }
                    .font(.title)
    }

    var intervalSelectorView: some View {
            HStack(spacing: 7) {
                timeSelectionControl(label: "Hours", value: $sharedData.interval_hours, range: 0...Int.max, field: .hours)
                timeSelectionControl(label: "Minutes", value: $sharedData.interval_minutes, range: 0...59, field: .minutes)
                timeSelectionControl(label: "Seconds", value: $sharedData.interval_seconds, range: 0...59, field: .seconds)
            }
            .onAppear {
                 focusedField = .minutes
             }
    }

    func timeSelectionControl(label: String, value: Binding<Int>, range: ClosedRange<Int>, field: FocusField) -> some View {
        VStack {
            Text(label).font(.system(size: 12))
            HStack(spacing: 3) {
                TextField("0", value: value, formatter: NumberFormatter(), onCommit: {
                    validateTimeValue(binding: value, range: range)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: field)
            }
        }
        .frame(width: 80)
    }

//     Validate time values to ensure they're within 0-59 range for minutes/seconds
    func validateTimeValue(binding: Binding<Int>, range: ClosedRange<Int>) {
        if binding.wrappedValue < range.lowerBound {
            binding.wrappedValue = range.lowerBound
        } else if binding.wrappedValue > range.upperBound {
            binding.wrappedValue = range.upperBound
        }
    }
//
//
//    var actionButtons: some View {
//        HStack(spacing: 20) {
//            Button(action: toggleTimer) {
//                                Text(timerActive ? "Pause" : "Start")
//                                    .foregroundColor(.white)
//                            }
//            .buttonStyle(.borderedProminent)
//            .accentColor(timerActive ? Color.orange : Color.green)
//
//            Button(action: resetTimer) {
//                 Text("Reset")
//                     .foregroundColor(.white)
//             }
//             .disabled(!timerActive)
//            .buttonStyle(.bordered)
//        }
//        .padding(.top, 30)
//    }
//    
    func setupFloatingWindow() {
        if let window = NSApplication.shared.windows.first {
            window.level = .floating
            window.isMovableByWindowBackground = true
            window.setFrame(NSRect(x: 100, y: 100, width: 300, height: 300), display: true)
        }
    }
    
//    func loadSavedInterval() {
//        hours = UserDefaults.standard.integer(forKey: "intervalHours")
//        minutes = UserDefaults.standard.integer(forKey: "intervalMinutes")
//        seconds = UserDefaults.standard.integer(forKey: "intervalSeconds")
//    }
}
