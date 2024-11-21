//
//  SharedData.swift
//  Let's Meditate
//
//  Created by Aswin V B on 21/11/24.
//

import SwiftUI
import Combine

class SharedData: ObservableObject {
    @State var hours: Int = UserDefaults.standard.integer(forKey: "intervalHours")
    @State var minutes: Int = UserDefaults.standard.integer(forKey: "intervalMinutes")
    @State var seconds: Int = UserDefaults.standard.integer(forKey: "intervalSeconds")
}
