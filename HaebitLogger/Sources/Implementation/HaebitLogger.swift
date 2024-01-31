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
    
    public init(repository: HaebitLogRepository) {
        self.repository = repository
    }
    
    func logs() async throws -> [HaebitLog] {
        []
    }
    
    func logs(near coordinate: HaebitCoordinate, range: Double) async throws -> [HaebitLog] {
        []
    }
    
    func logs(iso: UInt16) async throws -> [HaebitLog] {
        []
    }
    
    func logs(shutterSpeed: Float) async throws -> [HaebitLog] {
        []
    }
    
    func logs(aperture: Float) async throws -> [HaebitLog] {
        []
    }
    
    func logs(date: Date) async throws -> [HaebitLog] {
        []
    }
    
    func logs(from: Date, to: Date) async throws -> [HaebitLog] {
        []
    }
    
    func logs(containing memo: String) async throws -> [HaebitLog] {
        []
    }
    
    func save(log: HaebitLog) async throws {}
    func save(logs: [HaebitLog]) async throws {}
}
