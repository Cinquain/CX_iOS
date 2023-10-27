//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct CityXcapeApp: App {
    
    @ObservedObject private var store = Store()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(vm)
                .environmentObject(store)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
    return true
  }
    
}

