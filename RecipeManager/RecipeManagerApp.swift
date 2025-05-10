//
//  RecipeManagerApp.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import SwiftUI
import SwiftData

@main
struct RecipeManagerApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeView()
        }
        .modelContainer(for: Recipes.self)
    }
}
