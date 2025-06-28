// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/PlainTextDTO.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor
import Foundation

struct PlainTextDTO: Content {
    var id: UUID?
    var key: String
    var content: String
}

extension PlainTextDTO {
    func toModel() -> PlainText {
        PlainText(
            id: self.id,
            key: self.key,
            content: self.content
        )
    }
}