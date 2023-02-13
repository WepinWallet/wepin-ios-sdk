//
//  Param_Native_RedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct Param_Native_Request_LoginWepin: BaseParameter {
    var method: String
}

struct Param_Native_Response_LoginWepin: BaseParameter {
    var token: String

    init(token:String) {
        self.token = token
    }
}
