//
//  AddRecipeView.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct AddRecipeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var imageData = Data()
    @State private var review = ""
    @State private var rating = 3
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
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
                    TextField("Ex : Spagetti", text: $name)
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
                let newRecipe = Recipes(name: name, ingredients: ingredients, instructions: instructions, imageData: imageData, review: review, rating: rating)
                modelContext.insert(newRecipe)
                dismiss()
            } label: {
                Text("Save".uppercased())
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
            .navigationTitle("Add recipe")
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
    AddRecipeView()
}
