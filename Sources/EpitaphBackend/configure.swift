// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/configure.swift
// 
// Makabaka1880, 2025. All rights reserved.


import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    SecretsManager.configure() // ⬅️ make sure we load secrets first

    let dbHost = SecretsManager.get(.dbHost) ?? "localhost"
    let dbPort = SecretsManager.get(.dbPort).flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber
    let dbUsername = SecretsManager.get(.dbUsername) ?? "vapor_username"
    let dbPassword = SecretsManager.get(.dbPassword) ?? "vapor_password"
    let dbName = SecretsManager.get(.dbName) ?? "vapor_database"


    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: dbHost,
                port: dbPort,
                username: dbUsername,
                password: dbPassword,
                database: dbName,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )

    app.logger.info("🔌 Connecting to PostgreSQL at \(dbHost):\(dbPort) as \(dbUsername) on database '\(dbName)'")

    app.migrations.add(CreateMessage())
    app.migrations.add(CreateMemories())

    Task {
        do {
            let count = try await Message.query(on: app.db).count()
            app.logger.info("📬 Connected to DB — found \(count) messages in 'messages' table.")
        } catch {
            app.logger.error("❌ Failed to query 'messages' table: \(error)")
        }
    }
    
    // MARK: Middlewares
    app.middleware.use(MemorialHeaderMiddleware())
    
    try routes(app)
}
