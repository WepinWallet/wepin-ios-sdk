//
//  NativeRedyToWidget.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation

struct NativeSetAccountsModel: APIResponserWithParamter {

    var request: BaseRequest?
    
    var responseFrom: BaseRequest.Header.CaseRequestTo?
    var responseTo: String?
    var responseId: Int?
    var responseState: String?

    var responseDesc: String?
    var responseCommand: BaseRequest.Body.CaseCommand?
    
    var result: Param_Native_Response_SetAccounts?
    
    mutating func procAfterInit() {
        guard let param = request?.body.parameter as? Param_Native_Request_SetAccounts else {
            let err = ErrorCodeForWebUI.errorProcessParamNotExist
            responseDesc = err.desc(comment: nil)
            return
        }
        
        for account in param.accounts {
            print("account :", account)
            
            let newAcc = Wepin.Account(
                address: account.address,
                network: account.network
            )
            Wepin.instance().accounts.append(newAcc)
        }

        result = Param_Native_Response_SetAccounts()
        responseState = "SUCCESS"
    }

    func requestParameter() -> BaseParameter? {
        return result
    }
}
