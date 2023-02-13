//
//  BaseParameter.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation


protocol BaseParameter : Codable {
    func encoding() throws -> Data?
}

extension BaseParameter {
    func encoding() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
