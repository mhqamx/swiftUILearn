//
//  swiftUILearnApp.swift
//  swiftUILearn
//
//  Created by 马霄 on 2026/2/13.
//

import SwiftUI
import SwiftData

@main
struct swiftUILearnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [SwiftDataBook.self])
    }
}

#Preview {
    ContentView()
}
