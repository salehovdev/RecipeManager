//
//  RecipeDetailView.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import StoreKit
import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    
    @State private var infoText = ""
    @State private var showDeleteAlert = false
    @State private var showEditScreen = false
    
    let recipe: Recipes
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let image = imageFromData(recipe.imageData) {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(.rect(cornerRadius: 20))
                            .padding(.leading, 0)
                    }
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.orange, in: .capsule)
                        .shadow(radius: 10)
                    RatingView(rating: .constant(recipe.rating))
                        .padding()
                }
                .padding()
                
                Divider()
                
                VStack {
                    HStack {
                        Text("Ingredients")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray.opacity(0.8))
                            .padding()
                        
                        Spacer()
                    }
                    
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 350, height: 200)
                            .clipShape(.rect(cornerRadius: 20))
                        Text(recipe.ingredients)
                            .font(.headline)
                            .padding()
                    }
                }
                .padding([.horizontal,.bottom], 10)
                
                VStack {
                    HStack {
                        Text("Instructions")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray.opacity(0.8))
                            .padding()
                        
                        Spacer()
                    }
                    
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 350, height: 200)
                            .clipShape(.rect(cornerRadius: 20))
                        Text(recipe.instructions)
                            .font(.headline)
                            .padding()
                    }
                }
                .padding([.horizontal,.bottom], 10)
                
                
            }
            .navigationTitle("Recipe detail")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete recipe", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteRecipe)
                Button("Cancel", role: .cancel) { requestReview() }
            } message: {
                Text("Are you sure to delete \(recipe.name)?")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDeleteAlert.toggle()
                        
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        recipe.isFavorite.toggle()
                    } label: {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(.red)
                    }

                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showEditScreen.toggle()
                    } label: {
                        Text("Edit")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal, 150)
                            .background(
                                Color.blue
                                    .clipShape(.capsule)
                                    .shadow(radius: 10)
                            )
                    }
                    .fullScreenCover(isPresented: $showEditScreen) {
                        EditRecipeView(recipe: recipe)
                    }
                }
            }
        }
    }
    
    func deleteRecipe() {
        modelContext.delete(recipe)
        dismiss()
    }
    
    func imageFromData(_ data: Data?) -> Image? {
        guard let data = data, let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}

struct InfoView: View {
    @Binding var infoText: String
    var text = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray.opacity(0.8))
                    .padding()
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(width: 350, height: 200)
                    .clipShape(.rect(cornerRadius: 20))
                Text(infoText)
                    .font(.headline)
                    .padding()
            }
        }
        .padding([.horizontal,.bottom], 10)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipes.self, configurations: config)
        let example = Recipes(name: "Spagetti Carbonara", ingredients: "Ingredients", instructions: "Instrcutions", imageData: Data(), review: "", rating: 4)
        
        return RecipeDetailView(recipe: example)
            .modelContainer(container)
    } catch {
        return Text("Failed")
    }
}
