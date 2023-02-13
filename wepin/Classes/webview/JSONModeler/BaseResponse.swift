//
//  BaseResponse.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

struct BaseResponse {
    var header : Header
    var body : Body
    
    enum CodingKeys : String, CodingKey {
        case header, body
    }
    
    struct Header : Codable {
        var response_from : BaseRequest.Header.CaseRequestTo
        var response_to : String
        var id : Int
    }
    struct Body {
        var command : BaseRequest.Body.CaseCommand
        var state : String?
        var data : BaseParameter?
        
        enum CodingKeys : String, CodingKey {
            case command
            case state
            case data
        }
    }
}

extension BaseResponse : Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BaseResponse.CodingKeys.self)
        
        try container.encode(header, forKey: .header)
        
        var containerBody = container.nestedContainer(keyedBy: BaseResponse.Body.CodingKeys.self, forKey: .body)
        
        try containerBody.encode(body.command, forKey: .command)
        try containerBody.encode(body.state, forKey: .state)

        try procResponseWith(&containerBody)
    }
    func procResponseWith(_ container:inout KeyedEncodingContainer<BaseResponse.Body.CodingKeys>) throws{
        switch header.response_from {
        case .native:
            try procParamsForNative(&container)
        }
    }
    func procParamsForNative(_ container:inout KeyedEncodingContainer<BaseResponse.Body.CodingKeys>) throws {
        switch body.command {
            case .ready_to_widget :
                if let param = body.data as? Param_Native_Response_RedyToWidget {
                    try container.encode(param, forKey: .data)
                }
            case .login_wepin :
                if let param = body.data as? Param_Native_Response_LoginWepin {
                    try container.encode(param, forKey: .data)
                }
            case .set_accounts :
                if let param = body.data as? Param_Native_Response_SetAccounts {
                    try container.encode(param, forKey: .data)
                }
            case .initialized_widget :
                if let param = body.data as? Param_Native_Response_InitializedWidget {
                    try container.encode(param, forKey: .data)
                }
            case .close_wepin_widget :
                if let param = body.data as? Param_Native_Response_CloseWepinWidget {
                    try container.encode(param, forKey: .data)
                }
            case .expand_wepin_widget :
                if let param = body.data as? Param_Native_Response_ExpandWepinWidget {
                    try container.encode(param, forKey: .data)
                }
            case .shrink_wepin_widget :
                if let param = body.data as? Param_Native_Response_ShrinkWepinWidget {
                    try container.encode(param, forKey: .data)
                }
        }
    }

}

struct BaseResponseUnknown: Codable {
    var header : Header
    var body : Body
    
    enum CodingKeys : String, CodingKey {
        case header, body
    }
    
    struct Header : Codable {
        var response_from : String
        var code : Int
        var description : String
        var index : Int?
        var count : Int?
    }
    struct Body: Codable {
        var command : String
    }
}
