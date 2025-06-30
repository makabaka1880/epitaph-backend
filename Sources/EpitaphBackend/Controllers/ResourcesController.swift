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
		let badges = resources.grouped("badges", ":repo" ,":badge")
		let bucket = resources.grouped("bucket") // under dev

		badges.get(use: getBadge)
	}

	func getBadge(_ req: Request) async throws -> Response {
		guard let badge = req.parameters.get("badge") else {
			throw Abort(.badRequest, reason: "badge parameter missing")
		}
		guard let repo = req.parameters.get("repo") else {
			throw Abort(.badRequest, reason: "repo parameter missing")
		}

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


}