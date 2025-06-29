// Created by Sean L. on Jun. 29.
// Last Updated by Sean L. on Jun. 29.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Models/Graydate.swift
// 
// Makabak1880, 2025. All rights reserved.

import Vapor
import Fluent


final class Graydate: Model, @unchecked Sendable {
    static let schema = "grayout_dates"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "reason")
    var reason: String

    @Field(key: "date")
    var date: Date

    init() {}

    init(id: UUID? = nil, reason: String, date: Date) {
        self.id = id
        self.reason = reason
        self.date = date
    }
}

extension Graydate {
    func toDTO() -> GraydateDTO {
        GraydateDTO(id: self.id, reason: self.reason, date: self.date)
    }
}