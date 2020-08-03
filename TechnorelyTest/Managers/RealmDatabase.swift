//
//  RealmDatabase.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmDatabaseService {
    
    /// Starts the database service and initializes the Realm database.
    func start()
    
    /// Update object in the local database.
    ///
    /// - Parameters:
    ///   - block: The block to save.
    func updateObject(_ block: (() -> Void))
    
    /// Adds a new object or updates an existing object in the local database.
    ///
    /// - Parameters:
    ///   - object: The object to save.
    func saveObject<T: Object>(object: T)
    
    /// Adds or updates an array of objects in the local database.
    ///
    /// - Parameters:
    ///   - objects: The objects to save.
    func saveObjects<T: Object>(objects: [T])
    
    /// Generic function to retrieve multiple objects from the db.
    ///
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>() -> [T]?
    
    /// Generic function to retrieve multiple objects from the db according to a given query filter.
    ///
    /// - Parameter filter: The filter used to perform the query.
    /// - Returns: The retrieved results object. If nil, no objects were found.
    func getObjects<T: Object>(_ ofType: T.Type, filter: NSPredicate?) -> Results<T>?
    
    /// Generic function to retrieve a single object from the db according to a primary key.
    ///
    /// - Parameter id: The object's primary key.
    /// - Returns: The found object, otherwise nil.
    func getObject<T: Object>(id: Any) -> T?
    
    /// Deletes a given object from the db.
    ///
    /// - Parameter object: The object to delete.
    func deleteObject(object: Object)
    
    /// Deletes multiple objects from the db.
    ///
    /// Realm wrote: "Do not pass in a slice to a `Results` or any other auto-updating Realm collection type.
    /// Directly passing in a view into an auto-updating collection may result in 'index out of bounds' exceptions being thrown.
    ///
    /// - Parameter objects: An Array with all the objects to delete.
    func deleteObjects<T>(objects: Array<T>) where T: Object
    
    /// Deletes all records in all tables.
    func clearDatabase() throws
}

final class RealmDatabaseServiceImplementation: RealmDatabaseService {
    
    private var realm: Realm?
    
    func start() {
        
        var configuration = Realm.Configuration()

        // Deal with migration when required. For now simply delete realm if migration is needed
        configuration.deleteRealmIfMigrationNeeded = true

        if let _ = NSClassFromString("XCTest") {
            configuration.inMemoryIdentifier = UUID().uuidString
        }

        do {
            realm = try Realm(configuration: configuration)
            
        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }
    }
    
    func updateObject(_ block: (() -> Void)) {
        try? realm?.write {
            block()
        }
    }
    
    func saveObject<T>(object: T) where T : Object {
        try? realm?.write {
            realm?.add(object, update: .all)
        }
    }
    
    func saveObjects<T>(objects: [T]) where T : Object {
        try? realm?.write {
            objects.forEach { (object) in
                realm?.add(object, update: .all)
            }
        }
    }
    
    func getObjects<T>() -> [T]? where T : Object {
        guard let results = realm?.objects(T.self) else { return nil }
        return Array(results)
    }
    
    func getObject<T>(id: Any) -> T? where T : Object {
        return realm?.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func getObjects<T: Object>(_ ofType: T.Type, filter: NSPredicate?) -> Results<T>? {
        guard let filter = filter else { return realm?.objects(T.self) }
        return realm?.objects(T.self).filter(filter)
    }
    
    func deleteObject(object: Object) {
        try? realm?.write {
            realm?.delete(object)
        }
    }
    
    func deleteObjects<T>(objects: Array<T>) where T : Object {
        if let realm = realm {
            realm.delete(objects)
        }
    }
    
    func clearDatabase() throws {
        try? realm?.write {
            self.realm?.deleteAll()
        }
    }
}
