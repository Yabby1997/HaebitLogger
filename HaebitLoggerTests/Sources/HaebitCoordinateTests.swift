//
//  HaebitCoordinateTests.swift
//  HaebitLoggerTests
//
//  Created by Seunghun on 2/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@testable import HaebitLogger
import XCTest

final class HaebitCoordinateTests: XCTestCase {
    func testLongDistances() {
        let sanFrancisco = HaebitCoordinate(latitude: 37.7749, longitude: -122.4194)
        let losAngeles = HaebitCoordinate(latitude: 34.0522, longitude: -118.2437)
        let cheongju = HaebitCoordinate(latitude: 36.6424341, longitude: 127.4890319)
        let seoul = HaebitCoordinate(latitude: 37.564214, longitude: 127.001699)
        
        XCTAssertEqual(sanFrancisco.distance(to: losAngeles), 559.12, accuracy: 0.1)
        XCTAssertEqual(cheongju.distance(to: seoul), 111.23, accuracy: 0.1)
        XCTAssertEqual(losAngeles.distance(to: seoul), 9584.40, accuracy: 0.1)
        XCTAssertEqual(sanFrancisco.distance(to: cheongju), 9062.97, accuracy: 0.1)
    }
    
    func testShortDistances() {
        let cnu = HaebitCoordinate(latitude: 36.362341, longitude: 127.344930)
        let yuseongStation = HaebitCoordinate(latitude: 36.353683, longitude: 127.341583)
        let konkukUniversity = HaebitCoordinate(latitude: 37.540783, longitude: 127.079322)
        let namsanTower = HaebitCoordinate(latitude: 37.551231, longitude: 126.988210)
        
        XCTAssertEqual(cnu.distance(to: yuseongStation), 1, accuracy: 0.1)
        XCTAssertEqual(konkukUniversity.distance(to: namsanTower), 8.12, accuracy: 0.1)
    }
}
