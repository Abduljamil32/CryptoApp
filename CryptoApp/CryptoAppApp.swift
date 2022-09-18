//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 14/09/22.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
