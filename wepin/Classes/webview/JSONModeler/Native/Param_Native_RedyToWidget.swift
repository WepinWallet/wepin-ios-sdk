//
//  Param_Native_RedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct Param_Native_Request_RedyToWidget: BaseParameter {
    
}

struct Param_Native_Response_RedyToWidget: BaseParameter {

    var appKey: String
    var domain: String
    var platform: String
    var attributes: attr?

    struct attr: Codable {
        var type: String
        var defaultLanguage: String?
        var defaultCurrency: String?
        
        init(type:String, defaultLanguage:String?, defaultCurrency:String?) {
            self.type = type
            self.defaultLanguage = defaultLanguage
            self.defaultCurrency = defaultCurrency
        }
    }
    init(appKey:String, domain:String, platform:String, attributes: attr?) {
        self.appKey = appKey
        self.domain = domain
        self.platform = platform
        self.attributes = attributes
    }
}
