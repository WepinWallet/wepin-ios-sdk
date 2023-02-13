//
//  NativeRedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct NativeCloseWepinWidgetModel: APIResponserWithParamter {

    var request: BaseRequest?
    
    var responseFrom: BaseRequest.Header.CaseRequestTo?
    var responseTo: String?
    var responseId: Int?
    var responseState: String?

    var responseDesc: String?
    var responseCommand: BaseRequest.Body.CaseCommand?
    
    var result: Param_Native_Response_CloseWepinWidget?
    
    mutating func procAfterInit() {
        
        Wepin.instance().wepinVC!.dismiss(animated: true)
        
        result = Param_Native_Response_CloseWepinWidget()
        responseState = "SUCCESS"
    }

    func requestParameter() -> BaseParameter? {
        return result
    }
}
