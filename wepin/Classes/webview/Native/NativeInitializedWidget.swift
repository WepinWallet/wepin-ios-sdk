//
//  NativeRedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct NativeInitializedWidgetModel: APIResponserWithParamter {

    var request: BaseRequest?
    
    var responseFrom: BaseRequest.Header.CaseRequestTo?
    var responseTo: String?
    var responseId: Int?
    var responseState: String?

    var responseDesc: String?
    var responseCommand: BaseRequest.Body.CaseCommand?
    
    var result: Param_Native_Response_InitializedWidget?
    
    mutating func procAfterInit() {
        
        guard let param = request?.body.parameter as? Param_Native_Request_InitializedWidget else {
            let err = ErrorCodeForWebUI.errorProcessParamNotExist
            responseDesc = err.desc(comment: nil)
            return
        }
        
        if(param.result == true){
            Wepin.instance().initialized = true
        }else{
            Wepin.instance().initialized = false
        }
        
        result = Param_Native_Response_InitializedWidget()
        responseState = "SUCCESS"
    }

    func requestParameter() -> BaseParameter? {
        return result
    }
}
