//
//  Let_s_MeditateApp.swift
//  Let's Meditate
//
//  Created by Aswin V B on 20/11/24.
//

import SwiftUI

@main
struct Let_s_MeditateApp: App {
    @StateObject private var sharedData = SharedData()
    
    var body: some Scene {
        WindowGroup {
            AllViews(med_helper: MeditationHelperApp(_sharedData: sharedData))
                .environmentObject(sharedData)
                
        }
    }
}
