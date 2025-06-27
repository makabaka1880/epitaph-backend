import Fluent
import Vapor

struct MessagesController: RouteCollection {
	func boot(routes: any RoutesBuilder) throws {
		let messages = routes.grouped("messages")

		messages.get(use: self.index)
		messages.post(use: self.create)
		messages.group(":messageID") { message in
			message.delete(use: self.delete)
		}
	}
	@Sendable
	func index(req: Request) async throws -> PaginatedResponse<MessageDTO> {
		let totalCount = try await Message.query(on: req.db).count()
		let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
		let totalPages = (totalCount + limit - 1) / limit

		let lastCreatedAt = try? req.query.get(Date.self, at: "lastCreatedAt")
		let page = (try? req.query.get(Int.self, at: "page")) ?? 1

		var query = Message.query(on: req.db)
			.sort(\.$createdAt, .descending)
			.limit(limit)

		if let last = lastCreatedAt {
			query = query.filter(\.$createdAt < last)
		} else {
			query = query.range((page - 1) * limit..<(page * limit))
		}

		let messages = try await query.all()
		return PaginatedResponse(
			count: messages.count,
			totalCount: totalCount,
			totalPages: totalPages,
			currentPage: page,
			results: messages.map { $0.toDTO() }
		)
	}

	@Sendable
	func create(req: Request) async throws -> MessageDTO {
		guard let authToken = req.headers["Authorization"].first, SecretsManager.authenticate(key: .writeToken, against: authToken) else {
			throw Abort(.forbidden)
		}

		let message = try req.content.decode(MessageDTO.self).toModel()

		try await message.save(on: req.db)
		return message.toDTO()
	}

	@Sendable
	func delete(req: Request) async throws -> HTTPStatus {
		guard let authToken = req.headers["Authorization"].first, SecretsManager.authenticate(key: .deleteToken, against: authToken) else {
			throw Abort(.forbidden)
		}
		guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
			throw Abort(.notFound)
		}

		try await message.delete(on: req.db)
		return .noContent
	}
}
