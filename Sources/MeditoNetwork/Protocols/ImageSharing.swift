//
//  File.swift
//  
//
//  Created by Martin Lukacs on 20/06/2021.
//

import SwiftUI

public protocol ImageSharing {
    func getImage(named name: String) -> Image?
}

extension ImageSharing {
    public func getImage(named name: String) -> Image? {
        Image(name, bundle: Bundle.module)
    }
}
