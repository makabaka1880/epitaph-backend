// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/MemoryDTO
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor
import Foundation

struct MemoryDTO: Content, Sendable {
	var id: UUID?
	var label: String
	var date: String
	var description: String
}

extension MemoryDTO {
	func toModel() -> Memory {
		Memory(
			id: id,
			label: label,
			date: date,
			description: description
		)
	}
}