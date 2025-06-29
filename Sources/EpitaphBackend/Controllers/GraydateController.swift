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

        graydates.get("is-today", use: is_today)
    }

    func is_today(_ req: Request) async throws -> some AsyncResponseEncodable {
        let today = Date().startOfDay
        let tomorrow = Date().endOfDay

        let exists = try await req.db.query(Graydate.self)
            .filter(\.$date, .greaterThanOrEqual, today)
            .filter(\.$date, .lessThanOrEqual, tomorrow)
            .first()

        return ["today": exists != nil]
    }

}