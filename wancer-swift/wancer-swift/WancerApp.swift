//
//  WancerApp.swift
//  wancer-swift
//
//  Created by Kenny Lin on 3/16/24.
//

import SwiftUI
import SwiftData

@main
struct WancerApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:User.self)
    }
    
}
