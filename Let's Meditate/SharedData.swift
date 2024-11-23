//
//  SharedData.swift
//  Let's Meditate
//
//  Created by Aswin V B on 21/11/24.
//

import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var elapsed_hours: Int = 0
    @Published var elapsed_minutes: Int = 0
    @Published var elapsed_seconds: Int = 0
    
    @AppStorage("intervalHours") var interval_hours: Int = 0
    @AppStorage("intervalMinutes") var interval_minutes: Int = 0
    @AppStorage("intervalSeconds") var interval_seconds: Int = 0
    
    public var timer_active: Bool = false
    
    @State var timer: Timer? = nil
}
