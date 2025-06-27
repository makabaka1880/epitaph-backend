// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/MessageDTO.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent
import Vapor

struct MessageDTO: Content {
	var id: UUID?
	var createdAt: Date
	var name: String
	var note: String
	var recipient: String
	var updatedAt: Date?
}

extension MessageDTO {
    func toModel() -> Message {
        Message(
            id: self.id,
            createdAt: self.createdAt,
            name: self.name,
            note: self.note,
            recipient: self.recipient,
            updatedAt: self.updatedAt
        )
    }
}