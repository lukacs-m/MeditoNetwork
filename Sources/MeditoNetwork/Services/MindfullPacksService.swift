//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine
import Foundation
import MeditoModels

public protocol MindfullPacksServicing {
    func getMindfullPacks() -> AnyPublisher<[MindfullPack], Error>
}

final public class MindfullPacksService: MindfullPacksServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, [MindfullPack]> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getMindfullPacks() -> AnyPublisher<[MindfullPack], Error> {
        let path = APIConfig.EndPoints.packs
        if let cachedPacks = cache[path] {
            return Just(cachedPacks).switchToAnyPublisher(with: Error.self)
        }

        return api.getData(ofKind: MindfullPacksContainer.self, from: path)
            .map { [weak self] packsContainer in
                let packs = packsContainer.mindfullPacks
                self?.cache[path] = packs
                return packs
            }.eraseToAnyPublisher()
    }
}
