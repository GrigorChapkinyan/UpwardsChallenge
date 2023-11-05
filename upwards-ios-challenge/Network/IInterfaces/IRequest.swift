//
//  IRequest.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

/// This is an abstract interface representing a generic request.
protocol IRequest: CustomStringConvertible {
    /// Tries to build and return URLRequest
    /// - Returns: URLRequest if no error was thrown
    func asURLRequest() throws -> URLRequest
}
