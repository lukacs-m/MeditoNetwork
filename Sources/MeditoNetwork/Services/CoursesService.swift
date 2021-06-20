//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine
import Foundation
import MeditoModels

public protocol CoursesServicing {
    func getCourses() -> AnyPublisher<[Course], Error>
}

final public class CoursesService: CoursesServicing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, [Course]> = Cache()

    public init(apiService: NetworkDataFetching) {
        self.api = apiService
    }

    public func getCourses() -> AnyPublisher<[Course], Error> {
        let path = APIConfig.EndPoints.courses
        if let cachedCourses = cache[path] {
            return Just(cachedCourses).switchToAnyPublisher(with: Error.self)
        }

        return api.getData(ofKind: CoursesContainer.self, from: path)
            .map { [weak self] courseContainer in
                let courses = courseContainer.courses
                self?.cache[path] = courses
                return courses
            }.eraseToAnyPublisher()
    }
}
