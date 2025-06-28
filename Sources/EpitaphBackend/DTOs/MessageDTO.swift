// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/MessageDTO.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent
import Vapor

protocol MessageModelConvertible {
	init(id: UUID?, createdAt: Date, name: String, note: String, recipient: String, updatedAt: Date)
}

extension Message: MessageModelConvertible { }

extension ReviewMessage: MessageModelConvertible {
    convenience init(id: UUID?, createdAt: Date, name: String, note: String, recipient: String, updatedAt: Date) {
        self.init(
            id: id,
            createdAt: createdAt,
            name: name,
            note: note,
            recipient: recipient,
            updatedAt: updatedAt,
            status: .removed
        )
    }
}

struct MessageDTO: Content {
	var id: UUID?
	var createdAt: Date
	var name: String
	var note: String
	var recipient: String
	var updatedAt: Date
}

struct ReviewMessageDTO: Content {
	var id: UUID?
	var createdAt: Date
	var name: String
	var note: String
	var recipient: String
	var updatedAt: Date
    var status: MessageStatus
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
    func toModel(_ status: MessageStatus = .removed) -> ReviewMessage {
		ReviewMessage(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt,
            status: status
		)
	}
}

extension MessageDTO {
	init(from message: any BaseMessage) {
		self.id = message.id
		self.createdAt = message.createdAt
		self.name = message.name
		self.note = message.note
		self.recipient = message.recipient
		self.updatedAt = message.updatedAt
	}
}

extension ReviewMessageDTO {
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

    func toModel() -> ReviewMessage {
		ReviewMessage(
			id: self.id,
			createdAt: self.createdAt,
			name: self.name,
			note: self.note,
			recipient: self.recipient,
			updatedAt: self.updatedAt,
            status: self.status
		)
	}
}