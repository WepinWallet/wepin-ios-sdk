//
//  APIResponserWithParamter.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

protocol APIResponserWithParamter {
    var request:BaseRequest? {get set}
    
    var responseFrom:BaseRequest.Header.CaseRequestTo? {get set}
    var responseTo:String? {get set}
    var responseId:Int? {get set}
    var responseState:String? {get set}

    
    var responseCommand:BaseRequest.Body.CaseCommand? {get set}
    
    init()
    init(request:BaseRequest)

    mutating func procAfterInit()

    func requestParameter() -> BaseParameter?

    mutating func resetResponseParams()
}

extension APIResponserWithParamter {
    init(request:BaseRequest) {
        self.init()
        
        self.request = request
        
        procAfterInit()
    }
    
    func prepareNewResponse() -> BaseResponse? {
        var rValue:BaseResponse? = nil
        
        if let r = request {
            rValue = r.createNewBaseResponse()
        }
        return rValue
    }

    func requestPrettyResponse() -> BaseResponse? {
        guard var resp = prepareNewResponse() else {
            return nil
        }
        resp.body.data = requestParameter()
        
        if let r = responseFrom         { resp.header.response_from = r }
        if let r = responseTo           { resp.header.response_to = r }
        if let r = responseId           { resp.header.id = r }

        if let r = responseState           { resp.body.state = r }
        
        return resp
    }
    mutating func resetResponseParams() {
    }
}
