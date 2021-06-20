//
//  File.swift
//  
//
//  Created by Martin Lukacs on 20/06/2021.
//

import Combine
import Foundation
import MeditoModels

public protocol ArticlesServicing {
    func getArticle(for id: String) -> AnyPublisher<Article, Error>
}

final public class ArticlesService: ArticlesServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, Article> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getArticle(for id: String) -> AnyPublisher<Article, Error> {
        let path = "\(APIConfig.EndPoints.article)/\(id)"
        
        if let cachedArticle = cache[path] {
            return Just(cachedArticle).switchToAnyPublisher(with: Error.self)
        }

        return api.getData(ofKind: ArticleContainer.self, from: path)
            .map { [weak self] articleContainer in
                let article = articleContainer.article
                self?.cache[path] = article
                return article
            }.eraseToAnyPublisher()
    }
}
