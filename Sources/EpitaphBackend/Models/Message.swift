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

enum MessageStatus: String, Codable {
    case pending
    case removed
    case rejected
}

// MARK: - Shared Protocol

protocol BaseMessage: Model {
	var id: UUID? { get set }
	var createdAt: Date { get set }
	var name: String { get set }
	var note: String { get set }
	var recipient: String { get set }
	var updatedAt: Date { get set }

	func toDTO() -> MessageDTO
}

extension BaseMessage {
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


// MARK: Structures
final class Message: Model, @unchecked Sendable, BaseMessage {
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
	var updatedAt: Date

	init() { }

	init(id: UUID? = nil, createdAt: Date, name: String, note: String, recipient: String, updatedAt: Date) {
		self.id = id
		self.createdAt = createdAt
		self.name = name
		self.note = note
		self.recipient = recipient
		self.updatedAt = updatedAt
	}
}


final class ReviewMessage: Model, @unchecked Sendable, BaseMessage {
	static let schema = "review_stack_messages"

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
	var updatedAt: Date

    @Enum(key: "status")
    var status: MessageStatus

	init() { }

	init(id: UUID? = nil, createdAt: Date, name: String, note: String, recipient: String, updatedAt: Date, status: MessageStatus) {
		self.id = id
		self.createdAt = createdAt
		self.name = name
		self.note = note
		self.recipient = recipient
		self.updatedAt = updatedAt
        self.status = status
	}

    init(name: String, note: String, recipient: String) {
        self.createdAt = Date()
        self.name = name
        self.note = note
        self.recipient = recipient
        self.status = .pending
    }
}

extension ReviewMessage {

	func promote() -> Message {
		Message(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt
		)
	}
    func reject() -> ReviewMessage {
        ReviewMessage(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt,
            status: .rejected
		)
    }
    func toDTO() -> ReviewMessageDTO {
        ReviewMessageDTO(createdAt: self.createdAt, name: self.name, note: self.note, recipient: self.recipient, updatedAt: Date(), status: self.status)
    }
}

extension Message {
    func remove() -> ReviewMessage {
        ReviewMessage(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt,
            status: .removed
		)
    }
}