// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/DTOs/MemoryDTO
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor
import Foundation

struct MemoryDTO: Content, Sendable, Codable {
	var id: UUID?
	var label: String
	var date: String
	var description: String

	var image: String {
		get { ("\(SecretsManager.get(.bucketUrl) ?? "")/memories/\(self.id ?? UUID()).webp").lowercased() }
	}

	enum CodingKeys: String, CodingKey {
		case id, label, date, description, image
	}

	init(id: UUID?, label: String, date: String, description: String) {
		self.id = id
		self.label = label
		self.date = date
		self.description = description
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(UUID.self, forKey: .id)
		label = try container.decode(String.self, forKey: .label)
		date = try container.decode(String.self, forKey: .date)
		description = try container.decode(String.self, forKey: .description)
	}

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encode(label, forKey: .label)
		try container.encode(date, forKey: .date)
		try container.encode(description, forKey: .description)
		try container.encode(image, forKey: .image)
	}
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