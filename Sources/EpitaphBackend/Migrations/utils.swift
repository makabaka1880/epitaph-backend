// Created by Sean L. on Jun. 29.
// Last Updated by Sean L. on Jun. 29.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Migrations/utils.swift
// 
// Makabak1880, 2025. All rights reserved.

import Fluent
import FluentSQL
import Vapor

extension Database {
    func createPostgresEnumIfNeeded(name: String, cases: [String]) async throws {
        guard let sql = self as? any SQLDatabase else {
            throw Abort(.internalServerError, reason: "Database does not support raw SQL.")
        }

        let enumValues = cases.map { "'\($0)'" }.joined(separator: ", ")
        try await sql.raw("""
            DO $$
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = '\(unsafeRaw: name)') THEN
                    CREATE TYPE \(unsafeRaw: name) AS ENUM (\(unsafeRaw: enumValues));
                END IF;
            END
            $$;
        """).run()
    }

    func dropPostgresEnumIfExists(name: String) async throws {
        guard let sql = self as? any SQLDatabase else {
            throw Abort(.internalServerError, reason: "Database does not support raw SQL.")
        }

        try await sql.raw("DROP TYPE IF EXISTS \(unsafeRaw: name);").run()
    }
}
