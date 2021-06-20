//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine
import Foundation
import MeditoModels

public protocol ShortcutsServicing {
    func getShortcuts() -> AnyPublisher<[Shortcut], Error>
}

final public class ShortcutsService: ShortcutsServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, [Shortcut]> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getShortcuts() -> AnyPublisher<[Shortcut], Error> {
        let path = APIConfig.EndPoints.shortcuts
        if let cachedShortcuts = cache[path] {
            return Just(cachedShortcuts).switchToAnyPublisher(with: Error.self)
        }

        return api.getData(ofKind: ShortcutsContainer.self, from: path)
            .map { [weak self] shortcutContainer in
                let shortcuts = shortcutContainer.shortcuts
                self?.cache[path] = shortcutContainer.shortcuts
                return shortcuts
            }.eraseToAnyPublisher()
    }
}
