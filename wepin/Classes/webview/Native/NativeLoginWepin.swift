//
//  NativeRedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

class NativeLoginWepinModel: APIAsyncResponserWithParamter {
   
    var token: String?
    
    var request: BaseRequest?
    
    var responseFrom: BaseRequest.Header.CaseRequestTo?
    var responseTo: String?
    var responseId: Int?
    var responseState: String?

    var responseDesc: String?
    var responseCommand: BaseRequest.Body.CaseCommand?
    
    var result: Param_Native_Response_LoginWepin?
    
    required init() {
        
    }
    
    func procAfterInit() {

        guard let param = request?.body.parameter as? Param_Native_Request_LoginWepin else {
            let err = ErrorCodeForWebUI.errorProcessParamNotExist
            responseDesc = err.desc(comment: nil)
            return
        }

    }
    func asyncResponseSetParam(param: Any) {
        
        guard let token = param as? String else {
            let err = ErrorCodeForWebUI.errorProcessParamNotExist
            responseDesc = err.desc(comment: nil)
            return
        }
        
        self.token = token
    }

    func requestAsyncProcess(closureResult: (() -> Void)?) {

        self.responseState = "SUCCESS"
        if let r = closureResult{ r() }
    }

    func requestParameter() -> BaseParameter? {
        
        return Param_Native_Response_LoginWepin(token: self.token!)
    }
}
