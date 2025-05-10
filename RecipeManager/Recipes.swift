//
//  Recipes.swift
//  RecipeManager
//
//  Created by Fuad Salehov on 10.05.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Recipes: Identifiable {
    var id = UUID()
    var name: String
    var ingredients: String
    var instructions: String
    @Attribute(.externalStorage) var imageData: Data?
    var review: String
    var rating: Int
    var isFavorite: Bool = false
    
    init(name: String, ingredients: String, instructions: String, imageData: Data? = nil, review: String, rating: Int) {
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
        self.review = review
        self.rating = rating
    }
}
