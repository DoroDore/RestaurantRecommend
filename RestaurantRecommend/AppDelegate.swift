//
//  AppDelegate.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import UIKit
import Firebase // Still need this for FirebaseApp.configure()

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        print("Firebase has been configured!")
        return true
    }

    // You can remove the 'application(_:open:options:)' method entirely if not doing authentication now.
    // func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //     // Remove any GIDSignIn.sharedInstance.handle(url) or similar lines
    //     return false // Or true if you handle other URL types
    // }
}
