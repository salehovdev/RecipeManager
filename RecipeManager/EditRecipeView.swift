//
//  EditRecipeView.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var recipe: Recipes
    
    @State private var name: String
    @State private var ingredients: String
    @State private var instructions: String
    @State private var imageData = Data()
    @State private var review: String
    @State private var rating = 4
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
    init(recipe: Recipes) {
        self.recipe = recipe
        _name = State(initialValue: recipe.name)
        _ingredients = State(initialValue: recipe.ingredients)
        _instructions = State(initialValue: recipe.instructions)
        _imageData = State(initialValue: recipe.imageData ?? Data())
        _rating = State(initialValue: recipe.rating)
        _review = State(initialValue: recipe.review)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    PhotosPicker(selection: $selectedImage) {
                        if let processedImage {
                            processedImage
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 20))
                        } else {
                            ContentUnavailableView("No photo", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                                .padding(.top)
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedImage, loadImage)
                    
                }
                
                Section("Name") {
                    TextField("", text: $name)
                }
                
                Section("Ingredients") {
                    TextEditor(text: $ingredients)
                        .frame(height: 100)
                }
                
                Section("Instructions") {
                    TextEditor(text: $instructions)
                        .frame(height: 125)
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                
            }
            
            Button {
                recipe.name = name
                recipe.ingredients = ingredients
                recipe.instructions = instructions
                recipe.imageData = imageData
                recipe.rating = rating
                
                dismiss()
            } label: {
                Text("Update".uppercased())
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal, 150)
                    .background(
                        (name.isEmpty || ingredients.isEmpty || instructions.isEmpty || imageData.isEmpty ?
                        Color.gray : Color.blue)
                            .clipShape(.capsule)
                            .shadow(radius: 10)
                    )
                
            }
            .disabled(name.isEmpty || ingredients.isEmpty || instructions.isEmpty || imageData.isEmpty)
            .navigationTitle("Edit recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if !imageData.isEmpty {
                    if let uiImage = UIImage(data: imageData) {
                        processedImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            self.imageData = imageData
            self.processedImage = Image(uiImage: inputImage)
        }
    }
}

#Preview {
    EditRecipeView(recipe: .init(name: "Spagetti Carbonara", ingredients: "Ingredients", instructions: "Instructions", imageData: Data(), review: "", rating: 3))
}
