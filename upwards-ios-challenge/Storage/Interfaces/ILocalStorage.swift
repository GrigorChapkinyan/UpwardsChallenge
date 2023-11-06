//
//  ILocalStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/5/23.
//

import Foundation

/// This is an abstract interface representing a layer for interacting with local storage.
protocol ILocalStorage: IStorage where T: IModelManagedObject, E: IModelStructObject {}
