//
//  DefaultHaebitLogRepository.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import CoreData
import Foundation

public final class DefaultHaebitLogRepository: HaebitLogRepository {
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    public init() {
        let bundle = Bundle(for: DefaultHaebitLogRepository.self)
        guard let modelURL = bundle.url(forResource: "HaebitLoggerModels", withExtension: "momd"),
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
        try context.fetch(NSManagedHaebitLog.fetchRequest()).compactMap { $0.haebitLog }
    }
    
    public func save(log: HaebitLog) async throws {
        guard let managedObject = log.managedObject(with: context) else {
            return
        }
        context.insert(managedObject)
        try context.save()
    }
    
    public func remove(log: HaebitLog) async throws {
        guard let managedObject = log.managedObject(with: context) else {
            return
        }
        context.delete(managedObject)
        try context.save()
    }
}

extension NSManagedHaebitLog {
    fileprivate var haebitLog: HaebitLog? {
        guard let id,
              let date,
              let coordinate = coordinate?.haebitCoordinate,
              let image = image?.haebitImage,
              let memo else {
            return nil
        }
        
        return .init(
            id: id,
            date: date,
            coordinate: coordinate,
            image: image,
            iso: UInt16(bitPattern: iso),
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
    }
}

extension NSManagedHaebitImage {
    fileprivate var haebitImage: HaebitImage? {
        guard let photo else { return nil }
        return .init(photo: photo, video: video)
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
        managedObject.iso = Int16(iso)
        managedObject.memo = memo
        managedObject.shutterSpeed = shutterSpeed
        managedObject.coordinate = coordinate.managedObject(with: context)
        managedObject.image = image.managedObject(with: context)
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

extension HaebitImage {
    fileprivate func managedObject(with context: NSManagedObjectContext) -> NSManagedHaebitImage? {
        guard let managedObject = NSManagedHaebitImage(with: context) else { return nil }
        managedObject.photo = photo
        managedObject.video = video
        return managedObject
    }
}