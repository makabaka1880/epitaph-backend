// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// epitaph/backend/Sources/EpitaphBackend/Models/PlainText.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent
import Vapor
import Foundation

final class PlainText: Model, @unchecked Sendable {
    static let schema = "plaintext"

    @ID(key: .id)
    var id: UUID?;

    @Field(key: "key")
    var key: String;

    @Field(key: "content")
    var content: String;

    init() {}

    init(id: UUID? = nil, key: String, content: String) {
        self.id = id
        self.key = key
        self.content = content
    }

    func toDTO() -> PlainTextDTO {
        PlainTextDTO(
            id: self.id,
            key: self.key,
            content: self.content
        )
    }
}