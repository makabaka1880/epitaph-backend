// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Migrations/CreateMessage.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent

struct CreateMessage: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("messages")
            .id()
            .field("created_at", .datetime, .required)
            .field("name", .string, .required)
            .field("note", .string, .required)
            .field("recipient", .string, .required)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("messages").delete()
    }
}


struct CreateMemories: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("memories")
            .id()
            .field("label", .datetime, .required)
            .field("date", .string, .required)
            .field("description", .string, .required)
            .field("image", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("memories").delete()
    }
}
