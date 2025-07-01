// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// epitaph/backend/Sources/EpitaphBackend/Models/Responses.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor

struct PaginatedResponse<T: Content>: Content {
    let count: Int           // number of items on this page
    let totalCount: Int      // total number of items in db
    let totalPages: Int      // total number of pages
    let currentPage: Int     // current page number (offset based)
    let results: [T]
}

struct IndexedResponse<T: Content>: Content {
    let count: Int
    let currentIndex: Int
    let result: T
}

struct PromotePayload: Content {
    let id: UUID
}

struct IndexInfo: Content {
    let message: String
    let totalMessages: Int
    let reviewQueue: Int
}