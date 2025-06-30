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
        let badges = resources.grouped(":badge")
        let bucket = resources.grouped("bucket") // under dev

        badges.get(use: getBadge)
    }

    func getBadge(_ req: Request) async throws -> Response {
        guard let badge = req.parameters.get("badge") else {
            req.logger.error("Badge parameter missing")
            throw Abort(.badRequest)
        }

        let url = "https://github.com/makabaka1880/epitaph-frontend/actions/workflows/\(badge)/badge.svg"
        let clientResponse = try await req.client.get(URI(string: url))
        let res = Response(status: clientResponse.status, headers: clientResponse.headers, body: clientResponse.body)
        return res
    }
}