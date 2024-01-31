//
//  HaebitLog.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public struct HaebitLog: Hashable {
    public let id: UUID
    public let date: Date
    public let coordinate: HaebitCoordinate
    public let image: HaebitImage
    public let iso: UInt16
    public let shutterSpeed: Float
    public let aperture: Float
    public let memo: String
    
    public func hash(into hasher: inout Hasher) {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    public static func == (lhs: HaebitLog, rhs: HaebitLog) -> Bool {
        lhs.id == rhs.id
    }
}

public struct HaebitCoordinate {
    public let altitude: Double
    public let longitude: Double
}

public struct HaebitImage {
    public let photo: URL
    public let video: URL?
}
