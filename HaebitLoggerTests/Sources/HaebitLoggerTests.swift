//
//  HaebitLoggerTests.swift
//  HaebitLoggerTests
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@testable import HaebitLogger
import XCTest

final class HaebitLoggerTests: XCTestCase {
    class MockRepository: HaebitLogRepository {
        let image = HaebitImage(photo: URL(string: "https://test.com")!, video: nil)
        let sanFrancisco = HaebitCoordinate(latitude: 37.7749, longitude: -122.4194)
        let sanFrancisco1 = HaebitCoordinate(latitude: 37.775051043038545, longitude: -122.41237811867396)
        let losAngeles = HaebitCoordinate(latitude: 34.0522, longitude: -118.2437)
        let losAngeles1 = HaebitCoordinate(latitude: 34.05298616055887, longitude: -118.24058668970835)
        let losAngeles2 = HaebitCoordinate(latitude: 34.052263606700585, longitude: -118.24858092220602)
        let losAngeles3 = HaebitCoordinate(latitude: 34.048108802507194, longitude: -118.24901697125135)
        
        var testData: [HaebitLog] {
            [
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1706972400),
                    coordinate: sanFrancisco,
                    image: image,
                    focalLength: 28,
                    iso: 100,
                    shutterSpeed: 30,
                    aperture: 2,
                    memo: "Spongebob"
                ),
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1706764329),
                    coordinate: sanFrancisco1,
                    image: image,
                    focalLength: 50,
                    iso: 100,
                    shutterSpeed: 60,
                    aperture: 1.4,
                    memo: "Patrick"
                ),
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1707220190),
                    coordinate: losAngeles,
                    image: image,
                    focalLength: 28,
                    iso: 400,
                    shutterSpeed: 15,
                    aperture: 11,
                    memo: "Squidward"
                ),
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1707210190),
                    coordinate: losAngeles1,
                    image: image,
                    focalLength: 70,
                    iso: 800,
                    shutterSpeed: 30,
                    aperture: 16,
                    memo: "Spongebob square pants"
                ),
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1707112990),
                    coordinate: losAngeles2,
                    image: image,
                    focalLength: 200,
                    iso: 800,
                    shutterSpeed: 60,
                    aperture: 2,
                    memo: "Spongebob and Patrick"
                ),
                HaebitLog(
                    id: UUID(),
                    date: Date(timeIntervalSince1970: 1707210210),
                    coordinate: losAngeles3,
                    image: image,
                    focalLength: 50,
                    iso: 800,
                    shutterSpeed: 8,
                    aperture: 22,
                    memo: "Squid"
                ),
            ]
        }
        
        var data: [HaebitLog] = []
        
        init() {
            self.data = testData
        }
        
        func logs() async throws -> [HaebitLog] {
            data
        }
        
        func save(log: HaebitLog) async throws {
            data.append(log)
        }
        
        func remove(log: HaebitLog) async throws {
            data.removeAll { $0 == log }
        }
    }
    
    func testLogs() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs()
        XCTAssertEqual(logs.count, 6)
    }
    
    func testLogsWithAperture() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(aperture: 2)
        XCTAssertEqual(logs.count, 2)
    }
    
    func testLogsWithFocalLength() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(focalLength: 70)
        XCTAssertEqual(logs.count, 1)
    }
    
    func testLogsWithISO() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(iso: 800)
        XCTAssertEqual(logs.count, 3)
    }
    
    func testLogsWithShutterSpeed() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(shutterSpeed: 15)
        XCTAssertEqual(logs.count, 1)
    }
    
    func testLogsWithShutterMemo() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(containing: "spongebob")
        XCTAssertEqual(logs.count, 3)
    }
    
    func testLogsWithDate() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(date: Date(timeIntervalSince1970: 1707145200))
        XCTAssertEqual(logs.count, 3)
    }
    
    func testLogsWithDateInterval() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs = try await logger.logs(from: Date(timeIntervalSince1970: 1706886000), to: Date(timeIntervalSince1970: 1707145200))
        XCTAssertEqual(logs.count, 2)
    }
    
    func testLogsWithNearbyCoordinate() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs1 = try await logger.logs(near: repository.losAngeles, range: 1)
        XCTAssertEqual(logs1.count, 4)
        let logs2 = try await logger.logs(near: repository.sanFrancisco, range: 1)
        XCTAssertEqual(logs2.count, 2)
        let logs3 = try await logger.logs(near: repository.sanFrancisco, range: 1000)
        XCTAssertEqual(logs3.count, 6)
    }
    
    func testSave() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs1 = try await logger.logs()
        XCTAssertEqual(logs1.count, 6)
        try await logger.save(
            log: HaebitLog(
                id: UUID(),
                date: Date(),
                coordinate: HaebitCoordinate(latitude: .zero, longitude: .zero),
                image: HaebitImage(photo: URL(string: "https://example.com")!, video: nil), 
                focalLength: 50,
                iso: 100,
                shutterSpeed: 60,
                aperture: 1.4,
                memo: ""
            )
        )
        let logs2 = try await logger.logs()
        XCTAssertEqual(logs2.count, 7)
    }
    
    func testRemove() async throws {
        let repository = MockRepository()
        let logger = HaebitLogger(repository: repository)
        let logs1 = try await logger.logs()
        XCTAssertEqual(logs1.count, 6)
        guard let log = repository.data.first else {
            XCTFail()
            return
        }
        try await logger.remove(log: log)
        let logs2 = try await logger.logs()
        XCTAssertEqual(logs2.count, 5)
    }
}
