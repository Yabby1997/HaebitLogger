//
//  HaebitLogRepository.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

/// An interface for data persistence that used by ``HaebitLogger`` to save and fetch ``HaebitLog``.
public protocol HaebitLogRepository {
    /// Fetches all ``HaebitLog`` from data persistence.
    ///
    /// - Returns: An array of ``HaebitLog`` saved into data persistence.
    func logs() async throws -> [HaebitLog]
    
    /// Saves a ``HaebitLog`` into data persistence.
    ///
    /// - Parameters:
    ///     - log: A ``HaebitLog`` instance to save.
    ///
    /// - Note: If the `log` already exists, it will override the existing one.
    func save(log: HaebitLog) async throws
    
    /// Removes a ``HaebitLog`` from data persistence.
    ///
    /// - Parameters:
    ///     - id: An unique identifier of ``HaebitLog`` instance to remove.
    func remove(log id: UUID) async throws
}
