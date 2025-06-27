// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// /Sources/EpitaphBackend/Middlewares/Headers.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor

struct MemorialHeaderMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).map { response in
            response.headers.add(name: "X-Memorial-For", value: "James Li")
            return response
        }
    }
}
