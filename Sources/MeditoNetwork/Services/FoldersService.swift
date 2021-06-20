//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Foundation

import Combine
import Foundation
import MeditoModels
import Networking

public protocol FoldersServicing {
    func getFolder(for id: String, and params: Params) -> AnyPublisher<Folder, Error>
}

extension FoldersServicing {
    public func getFolder(for id: String, and params: Params = APIConfig.DefaultParams.folderParams) -> AnyPublisher<Folder, Error> {
        getFolder(for: id, and: params)
    }
}

final public class FoldersService: FoldersServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, Folder> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getFolder(for id: String, and params: Params ) -> AnyPublisher<Folder, Error> {
        let path = "\(APIConfig.EndPoints.folder)/\(id)"

        if let cachedFolder = cache[path] {
            return Just(cachedFolder).switchToAnyPublisher(with: Error.self)
        }

        return api.getData(ofKind: FolderContainer.self, from: path, with: params)
            .map { [weak self] folderContainer in
                let folder = folderContainer.folder
                self?.cache[path] = folder
                return folder
            }.eraseToAnyPublisher()
    }
}
