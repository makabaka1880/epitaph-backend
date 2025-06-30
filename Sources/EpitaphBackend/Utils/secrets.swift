// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/Utils/SecretsManager.swift
// 
// Sean L., 2025. All rights reserved.

#if DEBUG
import SwiftDotenv
#endif
import Foundation

enum SecretsKey: String, CaseIterable {
	case dbUsername         = "DB_USERNAME"
	case dbPassword         = "DB_PASSWORD"
	case dbHost             = "DB_HOST"
	case dbName             = "DB_NAME"
	case dbPort             = "DB_PORT"
	case adminPanelKey      = "ADMIN_PANEL_TOKEN"
    case adminReviewKey     = "ADMIN_REVIEW_TOKEN"
	case maintenanceMode    = "MAINTENANCE_MODE"
    case writeToken         = "DB_WRITE_TOKEN"
    case deleteToken        = "DB_DELETE_TOKEN"
    case badgeFetchPAT      = "BADGE_FETCH_PAT"
}

class SecretsManager {
	static func configure() {
		#if DEBUG
		do {
			try Dotenv.configure()
			print("✅ Loaded .env for DEBUG")
		} catch {
			print("⚠️ Could not load .env file: \(error)")
		}
		#else
		let secretsPath = "/run/secrets"
		let fm = FileManager.default

		for key in SecretsKey.allCases {
			let filename = key.rawValue
			let fullPath = secretsPath + "/" + filename

			if fm.fileExists(atPath: fullPath),
			let contents = try? String(contentsOfFile: fullPath, encoding: .utf8) {
				let trimmed = contents.trimmingCharacters(in: .whitespacesAndNewlines)
				setenv(filename, trimmed, 1)
				print("🔐 Loaded secret: \(filename)")
			} else {
                if ProcessInfo.processInfo.environment[filename] == nil {
                    print("⚠️ Missing or unreadable secret: \(filename)")
                } else {
                    print("✅ Secret loaded from env var: \(filename)")
                }
			}
		}
		#endif
	}

	/// Check if a given token matches the environment secret for that key
	static func authenticate(key: SecretsKey, against test: String) -> Bool {
		guard let actual = ProcessInfo.processInfo.environment[key.rawValue] else {
			print("⚠️ Secret \(key.rawValue) not found in environment")
			return false
		}
		return actual == test
	}

	/// Helper to fetch secret string from environment
	static func get(_ key: SecretsKey) -> String? {
		return ProcessInfo.processInfo.environment[key.rawValue]
	}
}
