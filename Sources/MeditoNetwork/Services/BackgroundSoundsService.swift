//
//  File.swift
//  
//
//  Created by Martin Lukacs on 20/06/2021.
//

import Foundation

import Combine
import Foundation
import MeditoModels

public protocol BackgroundSoundsServicing {
    var backgroundSoundsTitles: CurrentValueSubject<[String], Never> { get }
    func getSound(for soundTitle: String) -> BackgroundSound?
    func getSoundImageName(for soundTitle: String) -> String
}

public enum BackgroundSoundsImages: String, CaseIterable {
    case forest
    case peace
    case wind
    case waves
    case river
    case rainy
    case safe
    case spring
    case zen
    
    public static func getImageName(for sound: String) -> String {
        guard let name = BackgroundSoundsImages.allCases.first(where: { sound.lowercased().contains($0.rawValue) }) else {
            return BackgroundSoundsImages.forest.rawValue
        }
        return name.rawValue
    }
}

final public class BackgroundSoundsService: BackgroundSoundsServicing, ImageSharing {
    private var api: NetworkDataFetching
    private var cache: Cache<String, BackgroundSoundsContainer> = Cache()
    private var backgroundSounds: [String: BackgroundSound] = [:]
    private let cacheKey = "backgroundSounds"
    private var soundsName: [String] = []
    public  var backgroundSoundsTitles: CurrentValueSubject<[String], Never> = .init([])
    private var cancelBag = Set<AnyCancellable>()
    
    public init(apiService: NetworkDataFetching) {
        self.api = apiService
        setUp()
    }
    
    public func getSound(for soundTitle: String) -> BackgroundSound? {
        backgroundSounds[soundTitle]
    }
    
    public func getSoundImageName(for soundTitle: String) -> String {
        BackgroundSoundsImages.getImageName(for: soundTitle)
    }
}

extension BackgroundSoundsService {
    private func setUp() {
        if let cachedSoundsContainer = cache[cacheKey],
           !cachedSoundsContainer.backgroundSounds.isEmpty {
            setupData(with: cachedSoundsContainer)
            return
        }
        
        api.getData(ofKind: BackgroundSoundsContainer.self,
                    from: APIConfig.EndPoints.backgroundSounds,
                    with: APIConfig.DefaultParams.backgroundSoundsParams)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            }) { [weak self] soundsContainer in
                guard let self = self else { return }
                if !soundsContainer.backgroundSounds.isEmpty {
                    self.cache[self.cacheKey] = soundsContainer
                }
                self.setupData(with: soundsContainer)
            }.store(in: &cancelBag)
    }
    
    private func setupData(with container: BackgroundSoundsContainer) {
        var soundsNames: [String] = []
        soundsNames.append("None")
        for sound in container.backgroundSounds {
            backgroundSounds[sound.name] = sound
            soundsNames.append(sound.name)
        }
        soundsNames.sort()
        backgroundSoundsTitles.send(soundsNames)
    }
}
