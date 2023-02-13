//
//  BaseRequestDecoder.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

extension BaseRequest : Decodable {
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: BaseRequest.CodingKeys.self)
        
        header = try values.decode(BaseRequest.Header.self, forKey: .header)
        
        let bodyValues = try values.nestedContainer(keyedBy: BaseRequest.Body.CodingKeys.self, forKey: .body)
        let bodyCommand = try bodyValues.decode(BaseRequest.Body.CaseCommand.self , forKey: .command)
        
        body = Body(command: bodyCommand, parameter: nil)
        
        try procRequestWith(bodyValues)
    }
    
    mutating func procRequestWith(_ values:KeyedDecodingContainer<BaseRequest.Body.CodingKeys>) throws  {
        switch header.request_to {
        case .native:
            try procParamsWithNativeCommand(values)
        }
    }
    
    mutating func procParamsWithNativeCommand(_ values:KeyedDecodingContainer<BaseRequest.Body.CodingKeys>) throws  {
        switch(self.body.command) {
        case .initialized_widget:
            print("ENTER case initialized_widget")
            body.parameter = try values.decode(Param_Native_Request_InitializedWidget.self, forKey: .parameter)
            print("END case initialized_widget")
        case .set_accounts:
            body.parameter = try values.decode(Param_Native_Request_SetAccounts.self, forKey: .parameter)
        case .login_wepin:
            body.parameter = try values.decode(Param_Native_Request_LoginWepin.self, forKey: .parameter)
        default:
            print("파라미터가 필요없는 커멘드 케이스 \(body.command) in request " + header.request_to.rawValue)
        }
    }
 
}

