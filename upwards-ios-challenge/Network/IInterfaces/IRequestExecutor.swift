//
//  IRequestExecutor.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

/// This is an abstract interface representing an API for executing requests of "IRequest" type.
protocol IRequestExecutor {
    /// Executes the passed request
    /// - Parameter request: Request to be executed
    /// - Returns: The result of the execution
    func execute(_ request: IRequest) async -> Result<Any, Error>
}
