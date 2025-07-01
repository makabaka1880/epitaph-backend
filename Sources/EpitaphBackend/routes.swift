import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        let total = try await Message.query(on: req.db).count()
        let pending = try await ReviewMessage.query(on: req.db)
            .filter(\.$status == .pending)
            .count()
        return IndexInfo(
            message: "Epitaph is ready. Leave your words of remembrance.",
            totalMessages: total,
            reviewQueue: pending
        )
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    try app.register(collection: MessagesController())
    try app.register(collection: PlainTextController())
    try app.register(collection: MessageReviewController())
    try app.register(collection: GraydateController())
    try app.register(collection: ResourcesController())
}
