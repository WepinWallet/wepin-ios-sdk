//
//  NativeRedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct NativeRedyToWidgetModel: APIResponserWithParamter {

    var request: BaseRequest?
    
    var responseFrom: BaseRequest.Header.CaseRequestTo?
    var responseTo: String?
    var responseId: Int?
    var responseState: String?
    var responseDesc: String?
    var responseCommand: BaseRequest.Body.CaseCommand?
    
    var result: Param_Native_Response_RedyToWidget?
    
    mutating func procAfterInit() {
        
        let wepin = Wepin.instance()
        var att: Param_Native_Response_RedyToWidget.attr? = nil
        
        if(wepin.widgetAttributes != nil){
            att = Param_Native_Response_RedyToWidget.attr(
                                            type: (wepin.widgetAttributes?.type.rawValue)!,
                                            defaultLanguage: wepin.widgetAttributes?.defaultLanguage,
                                            defaultCurrency: wepin.widgetAttributes?.defaultCurrendy
                                        )
        }

        result = Param_Native_Response_RedyToWidget(
                                        appKey: wepin.appKey!,
                                        domain: wepin.domain!,
                                        platform: PlatformType.iosSDK.rawValue,
                                        attributes: att
                                    )
        responseState = "SUCCESS"
    }

    func requestParameter() -> BaseParameter? {
        return result
    }
}
