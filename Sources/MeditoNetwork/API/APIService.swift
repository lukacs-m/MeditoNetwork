//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Combine
import Foundation
import Networking

enum SampleDataType {
    case backgroundSounds
    
    func getName() -> String {
        switch self {
        case .backgroundSounds:
            return "BackgroundSounds"
        }
    }
}

public protocol NetworkDataFetching {
    func configureAPI(with config: NetworkConfiguration)
    
    func getData<ReturnType: NetworkingJSONDecodable>(ofKind: ReturnType.Type,
                                                      from path: String,
                                                      with params: Params?) -> AnyPublisher<ReturnType, Error>
//
//    func getData<ReturnType: NetworkingJSONDecodable>(ofKind: ReturnType.Type,
//                                                      from path: String) -> AnyPublisher<ReturnType, Error>
}

extension NetworkDataFetching {
    
    public func getData<ReturnType: NetworkingJSONDecodable>(ofKind: ReturnType.Type,
                                                      from path: String,
                                                      with params: Params? = nil) -> AnyPublisher<ReturnType, Error> {
        getData(ofKind: ofKind, from: path, with: params)
    }
}

final public class APIService: NetworkingService {
    public var network = NetworkingClient(baseURL: APIConfig.baseUrl)
    private var apiKey: String?
    
    init() {
        setUp()
    }
    
    public func configureAPI(with config: NetworkConfiguration) {
        apiKey = config.apiKey
        network.headers["Authorization"] = config.apiKey
    }
}

extension APIService: NetworkDataFetching {
    public func getData<ReturnType: NetworkingJSONDecodable>(ofKind: ReturnType.Type,
                                                             from path: String,
                                                             with params: Params?) -> AnyPublisher<ReturnType, Error> {
        guard apiKey != nil else {
            return AnyPublisher(Fail<ReturnType, Error>(error: APIServiceErrors.notConfigured))
        }
        if let params = params {
           return get(path, params: params)
        } else {
           return get(path)
        }
    }
//    
//    public func getData<ReturnType: NetworkingJSONDecodable>(ofKind: ReturnType.Type,
//                                                             from path: String) -> AnyPublisher<ReturnType, Error> {
//        get(path)
//    }
}

extension APIService {
    private func setUp() {
        #if DEBUG
        network.logLevels = .debug
        network.timeout = 5
        #else
        network.logLevels = .off
        network.timeout = APIConfig.settings.timeout
        #endif
    }
}
