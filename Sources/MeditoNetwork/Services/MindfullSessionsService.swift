//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine
import Foundation
import Networking
import MeditoModels

public protocol SessionServicing {
    func getSession(for id: String, contentType: ContentType, and params: Params) -> AnyPublisher<MindfullSession, Error>
}

extension SessionServicing {
   public func getSession(for id: String,
                    contentType: ContentType,
                    and params: Params = APIConfig.DefaultParams.mindfullSessionParams) -> AnyPublisher<MindfullSession, Error> {
        getSession(for: id, contentType: contentType, and: params)
    }
}

final public class SessionService: SessionServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, MindfullSession> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getSession(for id: String, contentType: ContentType, and params: Params) -> AnyPublisher<MindfullSession, Error> {
        let path = buildPath(for: id, contentType: contentType)

        if let cachedSession = cache[path] {
            return Just(cachedSession).switchToAnyPublisher(with: Error.self)
        }
        return api.getData(ofKind: MindfullSessionContainer.self, from: path, with: params)
            .map { [weak self] sessionContainer in
                let session = sessionContainer.mindfullSession
                self?.cache[path] = session
                return session
            }.eraseToAnyPublisher()
    }
}


extension SessionService {
    private func buildPath(for id: String, contentType: ContentType) -> String {
        "\(contentType == ContentType.session ? APIConfig.EndPoints.session : APIConfig.EndPoints.dailies)/\(id)"
    }
}
