//
//  FindMyMeal.swift
//  FindMyMeal
//
//  Created by Tanner Macpherson on 3/7/24.
//

import SwiftUI
import SwiftData

@main
 struct FindMyMeal: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DataItem.self)
    }
}
