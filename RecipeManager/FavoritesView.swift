//
//  FavoritesView.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @Query(filter: #Predicate<Recipes> { $0.isFavorite == true }) var favoriteRecipes: [Recipes]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favoriteRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            Text(recipe.name)
                                .font(.headline)
                            RatingView(rating: .constant(recipe.rating))
                                .padding(.leading)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Back", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
}
