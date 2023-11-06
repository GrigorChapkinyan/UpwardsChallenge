//
//  IRemoteStorage.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/4/23.
//

import Foundation

/// This is an abstract interface representing a layer for interacting with remote storage.
protocol IRemoteStorage: IStorage where T : IModelStructObject, E == T {}
