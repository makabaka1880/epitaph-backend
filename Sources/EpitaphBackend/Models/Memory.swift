// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Models/Memory.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor
import Fluent
import Foundation

import Vapor
import Fluent
import Foundation

final class Memory: Model, @unchecked Sendable {
    static let schema: String = "memories"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "label")
    var label: String

    @Field(key: "date")
    var date: String

    @Field(key: "description")
    var description: String

    @Field(key: "image")
    var image: String

    init() { }

    init(
        id: UUID? = nil,
        label: String,
        date: String,
        description: String,
        image: String
    ) {
        self.id = id
        self.label = label
        self.date = date
        self.description = description
        self.image = image
    }

    func toDTO() -> MemoryDTO {
        MemoryDTO(
            id: self.id,
            label: self.label, 
            date: self.date, 
            description: self.description, 
            image: self.image
        )
    }
}
