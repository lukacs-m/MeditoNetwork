//
//  File.swift
//  
//
//  Created by Martin Lukacs on 19/06/2021.
//

import Foundation
import Networking
import MeditoModels

extension ArticleContainer: NetworkingJSONDecodable {}
extension Article: NetworkingJSONDecodable {}

extension BackgroundSoundsContainer: NetworkingJSONDecodable {}
extension BackgroundSound: NetworkingJSONDecodable {}
extension SoundFile: NetworkingJSONDecodable {}

extension CoursesContainer: NetworkingJSONDecodable {}
extension Course: NetworkingJSONDecodable {}

extension FolderContainer: NetworkingJSONDecodable {}
extension Folder: NetworkingJSONDecodable {}
extension Item: NetworkingJSONDecodable {}
extension ItemContent: NetworkingJSONDecodable {}

extension MindfullPacksContainer: NetworkingJSONDecodable {}
extension MindfullPack: NetworkingJSONDecodable {}

extension MindfullSessionContainer: NetworkingJSONDecodable {}
extension MindfullSession: NetworkingJSONDecodable {}
extension AudioContainer: NetworkingJSONDecodable {}
extension AudioFile: NetworkingJSONDecodable {}
extension Author: NetworkingJSONDecodable {}

extension ShortcutsContainer: NetworkingJSONDecodable {}
extension Shortcut: NetworkingJSONDecodable {}
