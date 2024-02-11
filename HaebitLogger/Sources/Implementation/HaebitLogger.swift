//
//  HaebitLogger.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public class HaebitLogger {
    private let repository: HaebitLogRepository
    
    /// Initializes new ``HaebitLogger`` instance.
    ///
    /// - Parameters:
    ///     - repository: A ``HaebitLogRepository`` instance which represents data persistence for ``HaebitLog``s to be used.
    public init(repository: HaebitLogRepository) {
        self.repository = repository
    }
    
    public func logs() async throws -> [HaebitLog] {
        try await repository.logs()
    }
    
    public func logs(near coordinate: HaebitCoordinate, range distance: Double) async throws -> [HaebitLog] {
        try await repository.logs().filter { log in
            guard let logCoordinate = log.coordinate else { return false }
            return coordinate.distance(to: logCoordinate) <= distance
        }
    }
    
    public func logs(focalLength: UInt16) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.focalLength == focalLength }
    }
    
    public func logs(iso: UInt16) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.iso == iso }
    }
    
    public func logs(shutterSpeed: Float) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.shutterSpeed == shutterSpeed }
    }
    
    public func logs(aperture: Float) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.aperture == aperture }
    }
    
    public func logs(date: Date) async throws -> [HaebitLog] {
        try await repository.logs().filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    public func logs(from: Date, to: Date) async throws -> [HaebitLog] {
        try await repository.logs().filter { DateInterval(start: from, end: to).contains($0.date) }
    }
    
    public func logs(containing memo: String) async throws -> [HaebitLog] {
        try await repository.logs().filter { $0.memo.lowercased().contains(memo.lowercased()) }
    }
    
    public func save(log: HaebitLog) async throws {
        try await repository.save(log: log)
    }
    
    public func remove(log: HaebitLog) async throws {
        try await repository.remove(log: log)
    }
}
