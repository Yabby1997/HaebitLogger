//
//  HaebitLog.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

/// A log data struct for ``HaebitLogger``.
public struct HaebitLog: Hashable {
    /// Unique identifier of ``HaebitLog`` instance.
    public let id: UUID
    /// A `Date` instance indiciating the creation date.
    public let date: Date
    /// A ``HaebitCoordinate`` instance indicating the location.
    public let coordinate: HaebitCoordinate?
    /// Relative path to image file from Home directory.
    public let image: String
    /// A `UInt16` value indicating the focal length in mm.
    public let focalLength: UInt16
    /// A `UInt16` value indicating the ISO.
    public let iso: UInt16
    /// A `Float` value indicating the denominator of shutter speed in second.
    public let shutterSpeed: Float
    /// A `Float` value indicating the aperture value in f-stop number.
    public let aperture: Float
    /// A `String` value indicating the memo.
    public let memo: String
    
    /// Initializes new ``HaebitLog`` instance.
    ///
    /// - Parameters:
    ///     - id: Unique identifier of ``HaebitLog`` instance.
    ///     - date: A `Date` instance indiciating the creation date.
    ///     - coordinate: A ``HaebitCoordinate`` instance indicating the location.
    ///     - image: Relative path to image file from Home directory.
    ///     - focalLength: A `UInt16` value indicating the focal length in mm.
    ///     - iso: A `UInt16` value indicating the ISO.
    ///     - shutterSpeed: A `Float` value indicating the denominator of shutter speed in second.
    ///     - aperture: A `Float` value indicating the aperture value in f-stop number.
    ///     - memo: A `String` value indicating the memo.
    public init(
        id: UUID = UUID(),
        date: Date,
        coordinate: HaebitCoordinate?,
        image: String,
        focalLength: UInt16,
        iso: UInt16,
        shutterSpeed: Float,
        aperture: Float,
        memo: String
    ) {
        self.id = id
        self.date = date
        self.coordinate = coordinate
        self.image = image
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
    
    /// Initializes new ``HaebitCoordinate``.
    ///
    /// - Parameters:
    ///     - latitude: The latitude of coordinate.
    ///     - longitude: The longitude of coordinate.
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
