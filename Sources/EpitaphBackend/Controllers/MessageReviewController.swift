// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Controllers/MessageReviewController.swift
// 
// Makabak1880, 2025. All rights reserved.

import Foundation
import Vapor

struct AuthHeaderMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let authToken = request.headers["Authorization"].first,
            SecretsManager.authenticate(key: .adminReviewKey, against: authToken) else {
            throw Abort(.forbidden)
        }
        return try await next.respond(to: request)
    }
}

struct MessageReviewController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let reviews = routes
            .grouped("review")
            .grouped(AuthHeaderMiddleware())

        reviews.post("promote", use: promote)
        reviews.post("reject", use: reject)
    }

    func promote(_ req: Request) async throws -> MessageDTO {
        let payload = try req.content.decode(PromotePayload.self)

        guard let reviewMessage = try await ReviewMessage.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Review message not found")
        }

        let message = reviewMessage.promote()

        try await message.save(on: req.db)
        try await reviewMessage.delete(on: req.db)

        return message.toDTO()
    }

    func reject(_ req: Request) async throws -> MessageDTO {
        let payload = try req.content.decode(PromotePayload.self)

        guard let reviewMessage = try await ReviewMessage.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Review message not found")
        }

        reviewMessage.status = .rejected
        try await reviewMessage.save(on: req.db)

        return reviewMessage.toDTO()
    }
}