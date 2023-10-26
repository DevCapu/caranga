//
//  ContentView.swift
//  Caranga
//
//  Created by Felipe Moreno Borges on 25/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            CarListingView(path: $path)
                .navigationDestination(for: NavigationType.self) { type in
                switch type {
                case .detail(let car):
                    CarDetailView(car: .constant(car), path: $path)
                case .form(let car):
                    CarFormView(car: .constant(car), path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
