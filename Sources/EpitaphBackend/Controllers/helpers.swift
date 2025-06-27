// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Controllers/helpers.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor

struct ListResponse<T: Content>: Content {
    let count: Int
    let results: [T]

    init(_ results: [T]) {
        self.count = results.count
        self.results = results
    }
}

func extractQuery(_ query: String, req: Request) -> String? {
    try? req.query.get(String.self, at: query) 
}

