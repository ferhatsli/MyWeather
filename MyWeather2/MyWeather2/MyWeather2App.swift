//
//  MyWeather2App.swift
//  MyWeather2
//
//  Created by ferhat taşlı on 18.12.2023.
//

import SwiftUI

@main
struct MyWeather2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DistrictsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
