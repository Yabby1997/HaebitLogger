//
//  DefaultHaebitLogRepository.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import CoreData
import Foundation

/// Default implementation of ``HaebitLogRepository``.
public final actor DefaultHaebitLogRepository: HaebitLogRepository {
    private let persistentContainer: NSPersistentContainer
    
    /// Initializes new ``DefaultHaebitLogRepository`` isntance.
    public init() {
        guard let modelURL = Bundle.module.url(forResource: "HaebitLoggerModels", withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: modelURL)else {
            fatalError("Failed to locate model file in the framework bundle.")
        }
        self.persistentContainer = NSPersistentContainer(name: "HaebitLoggerModels", managedObjectModel: objectModel)
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    public func logs() async throws -> [HaebitLog] {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                do {
                    let logs = try context.fetch(NSManagedHaebitLog.fetchRequest()).compactMap { $0.haebitLog }
                    continuation.resume(returning: logs)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func save(log: HaebitLog) async throws {
        let existingManagedObject = try await fetch(with: log.id)
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                if let existingManagedObject {
                    existingManagedObject.override(with: context, haebitLog: log)
                } else {
                    guard let newManagedObject = log.managedObject(with: context) else {
                        continuation.resume()
                        return
                    }
                    context.insert(newManagedObject)
                }
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func remove(log id: UUID) async throws {
        let existingManagedObject = try await fetch(with: id)
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                guard let existingManagedObject else {
                    continuation.resume()
                    return
                }
                context.delete(existingManagedObject)
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func fetch(with id: UUID) async throws -> NSManagedHaebitLog? {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSManagedHaebitLog> = NSManagedHaebitLog.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                continuation.resume(returning: try? context.fetch(fetchRequest).first)
            }
        }
    }
}

extension NSManagedHaebitLog {
    fileprivate var haebitLog: HaebitLog? {
        guard let id,
              let date,
              let image,
              let memo else {
            return nil
        }
        
        return .init(
            id: id,
            date: date,
            coordinate: coordinate?.haebitCoordinate,
            image: image,
            focalLength: UInt16(bitPattern: focalLength),
            iso: UInt16(bitPattern: iso),
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
    }
    
    fileprivate func override(with context: NSManagedObjectContext,  haebitLog: HaebitLog) {
        date = haebitLog.date
        coordinate = haebitLog.coordinate?.managedObject(with: context)
        image = haebitLog.image
        focalLength = Int16(bitPattern: haebitLog.focalLength)
        iso = Int16(bitPattern: haebitLog.iso)
        shutterSpeed = haebitLog.shutterSpeed
        aperture = haebitLog.aperture
        memo = haebitLog.memo
    }
}

extension NSManagedHaebitCoordinate {
    fileprivate var haebitCoordinate: HaebitCoordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}

extension NSManagedObject {
    fileprivate convenience init?(with context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context) else {
            return nil
        }
        self.init(entity: entity, insertInto: context)
    }
}

extension HaebitLog {
    fileprivate func managedObject(with context: NSManagedObjectContext) -> NSManagedHaebitLog? {
        guard let managedObject = NSManagedHaebitLog(with: context) else { return nil }
        managedObject.id = id
        managedObject.aperture = aperture
        managedObject.date = date
        managedObject.focalLength = Int16(bitPattern: focalLength)
        managedObject.iso = Int16(bitPattern: iso)
        managedObject.memo = memo
        managedObject.shutterSpeed = shutterSpeed
        managedObject.coordinate = coordinate?.managedObject(with: context)
        managedObject.image = image
        return managedObject
    }
}

extension HaebitCoordinate {
    fileprivate func managedObject(with context: NSManagedObjectContext) -> NSManagedHaebitCoordinate? {
        guard let managedObject = NSManagedHaebitCoordinate(with: context) else { return nil }
        managedObject.latitude = latitude
        managedObject.longitude = longitude
        return managedObject
    }
}
