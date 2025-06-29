// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 29.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Controllers/GraydateController.swift
// 
// Makabak1880, 2025. All rights reserved.

import Foundation
import Vapor

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
}

struct GraydateController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let graydates = routes
            .grouped("grayscale")

        graydates.get("today", use: today)
    }

    func today(_ req: Request) async throws -> some AsyncResponseEncodable {
        let today = Date().startOfDay
        let tomorrow = Date().endOfDay

        let graydate = try await Graydate.query(on: req.db)
            .filter(\.$date, .greaterThanOrEqual, today)
            .filter(\.$date, .lessThanOrEqual, tomorrow)
            .first()

        struct GrayscaleResponse: Content {
            var gray: Bool
            var reason: String?
        }

        return GrayscaleResponse(
            gray: graydate != nil,
            reason: graydate?.reason
        )
    }
}