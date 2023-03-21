//
//  BaseEventRequest.swift
//  WepinSDK
//
//  Created by musicgi on 2023/03/16.
//

import Foundation


struct BaseEventRequest : BaseParameter{
    var header : Header
    var body : Body
    

    struct Header : Codable {
        var request_from : String
        var request_to : String
        var id : Int
    }
    
    struct Body : Codable{
        var command : String
        var parameter : String
    }
}



