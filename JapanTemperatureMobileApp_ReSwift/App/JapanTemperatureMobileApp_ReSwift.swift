//
//  JapanTemperatureMobileApp_ReSwift.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


@main
struct JapanTemperatureMobileApp_ReSwift: App {
@StateObject private var observableStore = ObservableStore(store: mainStore)
var body: some Scene {
WindowGroup {
ContentView_ReSwift()
.environmentObject(observableStore)
}
}
}
