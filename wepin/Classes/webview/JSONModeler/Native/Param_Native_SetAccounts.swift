//
//  Param_Native_RedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct Param_Native_Request_SetAccounts: BaseParameter {
    var accounts: [account]
    
    struct account: Codable {
        var network: String
        var address: String
    }
}

struct Param_Native_Response_SetAccounts: BaseParameter {
    
}
