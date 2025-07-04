//
//  RestaurantRecommendApp.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/22/25.
//

import SwiftUI

@main
struct RestaurantRecommendApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // This links to your AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView() // Your starting view
        }
    }
}
