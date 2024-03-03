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
    public let coordinate: HaebitCoordinate?
    public let assetIdentifier: String?
    public let thumbnailPath: String
    public let focalLength: UInt16
    public let iso: UInt16
    public let shutterSpeed: Float
    public let aperture: Float
    public let memo: String
    
    public init(
        id: UUID = UUID(),
        date: Date,
        coordinate: HaebitCoordinate?,
        assetIdentifier: String?,
        thumbnailPath: String,
        focalLength: UInt16,
        iso: UInt16,
        shutterSpeed: Float,
        aperture: Float,
        memo: String
    ) {
        self.id = id
        self.date = date
        self.coordinate = coordinate
        self.assetIdentifier = assetIdentifier
        self.thumbnailPath = thumbnailPath
        self.focalLength = focalLength
        self.iso = iso
        self.shutterSpeed = shutterSpeed
        self.aperture = aperture
        self.memo = memo
    }
    
    public func hash(into hasher: inout Hasher) {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    public static func == (lhs: HaebitLog, rhs: HaebitLog) -> Bool {
        lhs.id == rhs.id
    }
}

/// The coordinate data model for ``HaebitLog``.
public struct HaebitCoordinate {
    /// The latitude of coordinate.
    public let latitude: Double
    /// The longitude of coordinate.
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Calculates the distance from this coordinate to given coordinate in Km.
    /// - Parameters:
    ///     - coordinate: Other coordinate to measure distance from this coordinate.
    public func distance(to coordinate: HaebitCoordinate) -> Double {
        let earthRadius = 6_371.0

        let deltaLatitude = (coordinate.latitude - latitude).degreesToRadians
        let deltaLongitude = (coordinate.longitude - longitude).degreesToRadians

        let a = sin(deltaLatitude / 2.0) * sin(deltaLatitude / 2.0) 
                + cos(latitude.degreesToRadians) * cos(coordinate.latitude.degreesToRadians)
                * sin(deltaLongitude / 2.0) * sin(deltaLongitude / 2.0)

        let b = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))

        let distance = earthRadius * b
        return distance
    }
}

extension Double {
    fileprivate var degreesToRadians: Double {
        return self * .pi / 180.0
    }
}
