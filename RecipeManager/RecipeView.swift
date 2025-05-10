//
//  ContentView.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import SwiftUI
import SwiftData

struct RecipeView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showAddScreen = false
    @State private var showFavoriteScreen = false
    
    @Query var recipes: [Recipes]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            if let image = imageFromData(recipe.imageData) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .clipShape(.rect(cornerRadius: 20))
                            }
                            
                            VStack {
                                Text(recipe.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", systemImage: "plus") {
                        showAddScreen.toggle()
                    }
                    .sheet(isPresented: $showAddScreen) {
                        AddRecipeView()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Favorites", systemImage: "heart.fill") {
                        showFavoriteScreen.toggle()
                    }
                    .fullScreenCover(isPresented: $showFavoriteScreen) {
                        FavoritesView()
                    }
                }
            }
        }
    }
    
    func imageFromData(_ data: Data?) -> Image? {
        guard let data = data, let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}

#Preview {
    RecipeView()
}
