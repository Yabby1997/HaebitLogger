//
//  HaebitLogger.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

/// A Logger for ``HaebitLog``.
public class HaebitLogger {
    private let repository: HaebitLogRepository
    
    /// Initializes new ``HaebitLogger`` instance.
    ///
    /// - Parameters:
    ///     - repository: A ``HaebitLogRepository`` instance which represents data persistence for ``HaebitLog``s to be used.
    public init(repository: HaebitLogRepository) {
        self.repository = repository
    }
    
    /// Fetches all ``HaebitLog``s.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs() async throws -> [HaebitLog] {
        try await repository.logs()
    }
    
    /// Fetches all ``HaebitLog``s that within the range for the given coordinate.
    ///
    /// - Parameters:
    ///     - coordinate: A ``HaebitCoordinate`` value indicating the origin.
    ///     - distance: A `Double` value indicating the distance in KM from origin `coordinate`.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(near coordinate: HaebitCoordinate, range distance: Double) async throws -> [HaebitLog] {
        try await repository.logs().filter { log in
            guard let logCoordinate = log.coordinate else { return false }
            return coordinate.distance(to: logCoordinate) <= distance
        }
    }
    
    /// Fetches all ``HaebitLog``s with given focal length.
    ///
    /// - Parameters:
    ///     - focalLength: A `UInt16` value indicating the focal length in mm.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(focalLength: UInt16) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.focalLength == focalLength }
    }
    
    /// Fetches all ``HaebitLog``s with given ISO value.
    ///
    /// - Parameters:
    ///     - iso: A `UInt16` value indicating the ISO.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(iso: UInt16) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.iso == iso }
    }
    
    /// Fetches all ``HaebitLog``s with given shutter speed value.
    ///
    /// - Parameters:
    ///     - shutterSpeed: A `Float` value indicating the denominator of shutter speed in second.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(shutterSpeed: Float) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.shutterSpeed == shutterSpeed }
    }
    
    /// Fetches all ``HaebitLog``s with given aperture value.
    ///
    /// - Parameters:
    ///     - aperture: A `Float` value indicating the aperture value in f-stop number.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(aperture: Float) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.aperture == aperture }
    }
    
    /// Fetches all ``HaebitLog``s with given date.
    ///
    /// - Parameters:
    ///     - date: A `Date` value indicating the date of log.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(date: Date) async throws -> [HaebitLog] {
        try await repository.logs().filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    /// Fetches all ``HaebitLog``s with given range of dates.
    ///
    /// - Parameters:
    ///     - from: A `Date` value indicating the start of date range.
    ///     - to: A `Date` value indicating the end of date range.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(from: Date, to: Date) async throws -> [HaebitLog] {
        try await repository.logs().filter { DateInterval(start: from, end: to).contains($0.date) }
    }
    
    /// Fetches all ``HaebitLog``s with given memo.
    ///
    /// - Parameters:
    ///     - memo: A `String` value indicating the memo.
    ///
    /// - Returns: An array of ``HaebitLog``s.
    public func logs(containing memo: String) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.memo.lowercased().contains(memo.lowercased()) }
    }
    
    /// Saves a ``HaebitLog``.
    ///
    /// - Parameters:
    ///     - log: A new ``HaebitLog`` instance to write.
    public func save(log: HaebitLog) async throws {
        try await repository.save(log: log)
    }
    
    /// Removes a ``HaebitLog``.
    ///
    /// - Parameters:
    ///     - id: An unique identifier of ``HaebitLog`` instance to remove.
    public func remove(log id: UUID) async throws {
        try await repository.remove(log: id)
    }
}
