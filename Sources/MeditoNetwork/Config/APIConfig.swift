//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Foundation

public enum APIConfig {
    static let baseUrl = "https://api.medito.app"
}

// MARK: - API endpoints

extension APIConfig {
    enum EndPoints {
        static let packs = "/items/packs"
        static let folder = "/items/folders"
        static let dailies = "/items/dailies"
        static let article = "/items/articles"
        static let session = "/items/sessions"
        static let announcement = "/items/announcement"
        static let backgroundSounds = "/items/background_sounds"
        static let courses = "/items/courses"
        static let dailyMessage = "/items/daily_message"
        static let menu = "/items/menu"
        static let shortcuts = "/items/shortcuts"
    }
    
    static let timerEndpoint = "/items/sessions/155"
    static let soundsEndpoint = "/items/folders/22"
    static let sleepEndpoint = "/items/folders/33"
}

// MARK: - Request options

extension APIConfig {
    enum Settings {
        static let timeout: Double = 15
        
        static let timerPageId = "155"
    }
    
    // MARK: - Cache
    
    enum Cache {
        static let entryLifetime: TimeInterval = 172_800 // 2 days
        static let maximumEntryCount: Int = 1000
    }
}


extension APIConfig {
    public enum DefaultParams {
        public static let folderParams =
            [
                "fields": "*,items.item:folders.id,items.item:folders.type,items.item:folders.title,items.item:folders.subtitle,items.item:sessions.id,items.item:sessions.type,items.item:sessions.title,items.item:sessions.subtitle,items.item:dailies.id,items.item:dailies.type,items.item:dailies.title,items.item:dailies.subtitle,items.item:articles.id,items.item:articles.type,items.item:articles.title,items.item:articles.subtitle"
            ]
        
        public static let mindfullSessionParams =
            ["fields": "*,author.body,audio.file.id,audio.file.voice,audio.file.length"]
        
        public static let backgroundSoundsParams = ["fields": "*,file.id,file.length"]
    }
}

// MARK: - API Authentification variables

//
//extension APIConfig {
//    static var apiKey: String {
//        // 1
//        guard let filePath = Bundle.main.path(forResource: "Medito-Info", ofType: "plist") else {
//            fatalError("Couldn't find file 'Medito-Info.plist'.")
//        }
//        // 2
//        let plist = NSDictionary(contentsOfFile: filePath)
//        guard let value = plist?.object(forKey: "API_KEY") as? String else {
//            fatalError("Couldn't find key 'API_KEY' in 'Medito-Info.plist'.")
//        }
//        // 3
//        if value.starts(with: "_") {
//            fatalError("Register for a Medito developer account and get an API key at https://meditofoundation.org/volunteer.")
//        }
//        return value
//    }
//}
