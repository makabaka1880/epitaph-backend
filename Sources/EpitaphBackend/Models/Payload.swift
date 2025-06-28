// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Epitaph - Backend
// Sources/EpitaphBackend/Models/Payload.swift
// 
// Makabak1880, 2025. All rights reserved.

import Vapor
import Foundation

struct PayloadMessage: Content {
    var name: String
    var note: String
    var recipient: String
}

extension PayloadMessage {
    func toReviewMessage() -> ReviewMessage {
        ReviewMessage(name: self.name, note: self.note, recipient: self.recipient)
    }
}