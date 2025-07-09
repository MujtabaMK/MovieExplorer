//
//  MovieExplorerApp.swift
//  MovieExplorer
//
//  Created by Mujtaba Khan on 08/07/25.
//

import SwiftUI
import RealmSwift

// 👇 Alias Realm’s App to avoid naming conflict
typealias RealmApp = RealmSwift.App

func setupRealmMigration() {
    let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                // No manual migration needed for added properties
            }
        }
    )

    Realm.Configuration.defaultConfiguration = config
}

@main
struct MovieExplorerApp: SwiftUI.App { // 👈 Explicitly use SwiftUI.App if needed
    init() {
        setupRealmMigration()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Explore", systemImage: "film")
                    }

                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
        }
    }
}
