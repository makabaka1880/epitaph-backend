import Fluent
import Vapor

struct MemoriesController: RouteCollection {
	func boot(routes: any RoutesBuilder) throws {
		let memories = routes.grouped("memories")

		memories.get(use: self.index)
		memories.post(use: self.create)
		memories.group(":memoryID") { memory in
			memory.delete(use: self.delete)
		}
	}
	@Sendable
	func index(req: Request) async throws -> PaginatedResponse<MemoryDTO> {
		let totalCount = try await Memory.query(on: req.db).count()
		let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
		let totalPages = (totalCount + limit - 1) / limit
		let page = (try? req.query.get(Int.self, at: "page")) ?? 1

		let lastDate = extractQuery("date", req: req)

		var query = Memory.query(on: req.db)
			.sort(\.$date, .descending)
			.limit(limit)

		if let last = lastDate {
			query = query.filter(\.$date < last)
		} else {
			query = query.range((page - 1) * limit..<(page * limit))
		}

		let memories = try await query.all()
		return PaginatedResponse(
			count: memories.count,
			totalCount: totalCount,
			totalPages: totalPages,
			currentPage: page,
			results: memories.map { $0.toDTO() }
		)
	}


	@Sendable
	func create(req: Request) async throws -> MemoryDTO {
		guard let authToken = req.headers["Authorization"].first, SecretsManager.authenticate(key: .writeToken, against: authToken) else {
			throw Abort(.forbidden)
		}

		let memory = try req.content.decode(MemoryDTO.self).toModel()

		try await memory.save(on: req.db)
		return memory.toDTO()
	}

	@Sendable
	func delete(req: Request) async throws -> HTTPStatus {
		guard let authToken = req.headers["Authorization"].first, SecretsManager.authenticate(key: .deleteToken, against: authToken) else {
			throw Abort(.forbidden)
		}
		guard let memory = try await Memory.find(req.parameters.get("memoryID"), on: req.db) else {
			throw Abort(.notFound)
		}

		try await memory.delete(on: req.db)
		return .noContent
	}
}