//
//  AppSwitcher.swift
//  Multiplication Test
//
//  Created by Ambrose V on 13/08/2024.
//
import SwiftUI

struct AppSwitcher: View {
    var body: some View {
        TabView {
            NavigationStack {
                MultiplicationGameView()
                    .navigationTitle("Multiplication")
                    .environmentObject(GameCenterManager.shared)
            }
            .tabItem {
                Label("Multiplication", systemImage: "multiply.circle")
            }

            NavigationStack {
                DivisionGame()
                    .environmentObject(GameCenterManager.shared)
            }
            .tabItem {
                Label("Division", systemImage: "divide.circle")
            }

            NavigationStack {
                WordGameView()
                    .environmentObject(GameCenterManager.shared)
            }
            .tabItem {
                Label("Definitions", systemImage: "book.closed.fill")
            }
            NavigationStack {
                SettingsView()
                    .environmentObject(GameCenterManager.shared)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            
        }
    }
}

#Preview {
    AppSwitcher()
}
