//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine

// MARK: - Extensions linked to Just
extension Just {
    
    /// Transforms a Just into a Anypublisher
    /// - Parameter errorType: The type of error the AnyPublisher should return
    /// - Returns: An AnyPublisher that returns the output and specified error type
    func switchToAnyPublisher<ReturnedError: Error>(with errorType: ReturnedError.Type) -> AnyPublisher<Output, ReturnedError> {
        self.setFailureType(to: errorType).eraseToAnyPublisher()
    }
}
