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
                ContentView()
                    .navigationTitle("Multiplication")
            }
            .tabItem {
                Label("Multiplication", systemImage: "multiply.circle")
            }
            NavigationStack {
                DivisionGame()
                    //.navigationTitle("Division")
            }
                .tabItem {
                    Label("Division", systemImage: "divide.circle")
                }
        }
    }
}

#Preview {
    AppSwitcher()
}
