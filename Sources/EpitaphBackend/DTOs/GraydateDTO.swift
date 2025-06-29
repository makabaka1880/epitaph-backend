// Created by Sean L. on Jun. 29.
// Last Updated by Sean L. on Jun. 29.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/GraydateDTO.swift
// 
// Makabak1880, 2025. All rights reserved.

import Vapor

struct GraydateDTO: Content {
    var id: UUID?
    var reason: String
    var date: Date
}

extension GraydateDTO {
    func toModel() -> Graydate {
        Graydate(id: self.id, reason: self.reason, date: self.date);
    }
}