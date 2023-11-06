//
//  LocalStorageRequestExecutor.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation
import CoreData

class LocalStorageRequestExecutor<T, E>: IRequestExecutor where T: IModelManagedObject, E: IModelStructObject {
    // MARK: - Private Properties
    
    private var moc: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: T.getPersistentContainerName())
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - IRequestExecutor
    
    func execute(_ request: IRequest) async -> Result<Any, Error> {
        do {
            guard let localStorageRequest = request as? LocalStorageRequest<T, E> else {
                throw IRequestError.invalidRequestPassed
            }
            
            switch localStorageRequest.requestType {
                case .fetch(let predicate, let sortDescriptor, let limit):
                    let result = try fetch(predicate: predicate, sortDescriptor: sortDescriptor, limit: limit)
                    return .success(result)
                case .update:
                    let result: Void = try update()
                    return .success(result)
                case .delete(let items):
                    let managedObjects = items.compactMap({ $0.getManagedObject(context: moc) as? T })
                    let result: Void = try delete(managedObjects)
                    return .success(result)
                case .add(let items):
                    let managedObjects = items.compactMap({ $0.getManagedObject(context: moc) as? T })
                    let result: Void = try add(managedObjects)
                    return .success(result)
            }
        }
        catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private API

    private func fetch(predicate: NSPredicate?, sortDescriptor: SortDescriptor<T>?, limit: Int?) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.getEntityName())
        fetchRequest.predicate = predicate
        
        // Setting sortDescriptor if exist
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [NSSortDescriptor(sortDescriptor)]
        }
        
        // Setting the limit of items
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }

        do {
            let fetchRequestResult = try moc.performAndWait {
                try moc.fetch(fetchRequest)
            }
           
            return fetchRequestResult
        }
        catch {
            throw LocalStorageRequestExecutorError.fetchRequestFailed(error: error)
        }
    }
    
    private func delete(_ items: [T]) throws {
        for itemIter in items {
            moc.performAndWait {
                moc.delete(itemIter)
            }
        }
        try update()
    }
    
    private func add(_ items: [T]) throws {
        try update()
    }
    
    private func update() throws {
        if moc.hasChanges {
            try moc.performAndWait {
                do {
                    try moc.save()
                }
                catch {
                    throw LocalStorageRequestExecutorError.updateRequestFailed(error: error)
                }
            }
        }
    }
}

// MARK: - LocalStorageRequestExecutorError

enum LocalStorageRequestExecutorError: Swift.Error {
    case fetchRequestFailed(error: Error)
    case updateRequestFailed(error: Error)
}

extension LocalStorageRequestExecutorError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .fetchRequestFailed(let error):
                return "\"LocalStorageRequestExecutor\": Fetch request failed with: \(error.localizedDescription)"
            case .updateRequestFailed(let error):
                return "\"LocalStorageRequestExecutor\": Update request failed with: \(error.localizedDescription)"
        }
    }
}
