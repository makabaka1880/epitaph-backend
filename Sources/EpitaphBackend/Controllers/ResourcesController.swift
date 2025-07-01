// Created by Sean L. on Jun. 30.
// Last Updated by Sean L. on Jun. 30.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Controllers/ResourcesController.swift
// 
// Makabak1880, 2025. All rights reserved.

import Vapor
import Foundation

struct ResourcesController: RouteCollection {
	func boot(routes: any RoutesBuilder) throws {
		let resources = routes.grouped("resources")
		let badges = resources.grouped("badges", ":repo", "**")
		let bucket = resources.grouped("bucket")

		badges.get(use: getBadge)
		bucket.get("single", use: getMemory)
	}

	func getBadge(_ req: Request) async throws -> Response {
		guard let repo = req.parameters.get("repo") else {
			throw Abort(.badRequest)
		}
		let badgeParts = req.parameters.getCatchall()
		guard !badgeParts.isEmpty else {
			throw Abort(.badRequest)
		}
		let badge = badgeParts.joined(separator: "/")

	
		let url = "https://github.com/makabaka1880/\(repo)/actions/workflows/\(badge)/badge.svg"
		let clientResponse = try await req.client.get(URI(string: url)) { req in
			req.headers.replaceOrAdd(name: .authorization, value: "token \(SecretsManager.get(.badgeFetchPAT) ?? "")")
		}
		return Response(
			status: clientResponse.status,
			headers: clientResponse.headers,
			body: clientResponse.body.map { .init(buffer: $0) } ?? .init()
		)
	}

	@Sendable
	func getMemory(req: Request) async throws -> IndexedResponse<MemoryDTO> {
		guard let _id = try? req.query.get(String.self, at: "id") else {
			throw Abort(.badRequest, reason: "Missing query `id`")
		}
		guard let id = UUID(_id) else {
			throw Abort(.badRequest, reason: "Query `id` is not a valid UUID")
		}
		let memory = try await Memory.find(id, on: req.db)

		guard let foundMemory = memory else {
			throw Abort(.notFound, reason: "Message not found")
		}

		return IndexedResponse(
			count: try await Memory.query(on: req.db).count(),
			result: foundMemory.toDTO()
		)
	}

}