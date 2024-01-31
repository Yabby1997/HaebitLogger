//
//  HaebitLogRepository.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public protocol HaebitLogRepository {
    func logs() async throws -> [HaebitLog]
    func save(logs: [HaebitLog]) async throws
}
