// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Controllers/misc.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor
import Fluent


struct PlainTextController: RouteCollection {
    func boot(routes: any RoutesBuilder) {
        let plaintext = routes.grouped("plaintext")
        plaintext.get(use: index)
    }

    @Sendable
    func index(req: Request) async throws -> PlainTextDTO {
        let key: String
        do {
            key = try req.query.get(String.self, at: "key")
        } catch {
            throw Abort(.badRequest, reason: "Missing 'key' query parameter.")
        }

        guard let plainText = try await PlainText.query(on: req.db)
            .filter(\.$key == key)
            .first() else {
            throw Abort(.notFound, reason: "No content found for key '\(key)'.")
        }

        return plainText.toDTO()
    }
}