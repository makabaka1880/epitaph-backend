// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Models/Message.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent
import Vapor
import Foundation

// MARK: - Fluent Model

final class Message: Model, @unchecked Sendable {
	static let schema = "messages"
	
	@ID(key: .id)
	var id: UUID?

	@Field(key: "created_at")
	var createdAt: Date

	@Field(key: "name")
	var name: String

	@Field(key: "note")
	var note: String

	@Field(key: "recipient")
	var recipient: String

	@Field(key: "updated_at")
	var updatedAt: Date?

	init() { }

	init(id: UUID? = nil, createdAt: Date, name: String, note: String, recipient: String, updatedAt: Date? = nil) {
		self.id = id
		self.createdAt = createdAt
		self.name = name
		self.note = note
		self.recipient = recipient
		self.updatedAt = updatedAt
	}

	func toDTO() -> MessageDTO {
		MessageDTO(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt
		)
	}
}