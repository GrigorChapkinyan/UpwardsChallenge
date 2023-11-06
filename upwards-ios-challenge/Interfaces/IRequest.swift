//
//  IRequest.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

// MARK: - URLRequest

/// This is an abstract interface representing a generic request.
protocol IRequest: CustomStringConvertible {}

// MARK: - URLRequest + IRequest

extension URLRequest: IRequest {}

// MARK: - IURLRequestConvertable

protocol IURLRequestConvertable: IRequest {
    /// Tries to build and return URLRequest
    /// - Returns: URLRequest if no error was thrown
    func asURLRequest() throws -> URLRequest
}

// MARK: - IRequestError

enum IRequestError: Swift.Error {
    case invalidRequestPassed
}

extension IRequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidRequestPassed:
                return "An invalid request was passed for execution."
        }
    }
}
