//
//  ErrorCodeForWebUI.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

enum ErrorCodeForWebUI:Int {
    case WorksGood                  = 0

    //
    case errorUnknown               = -1
    case errorGeneral               = 1
    case errorProcessNotSupport     = 2
    case errorProcessParamNotExist  = 3
    case errorProcessNotExist       = 4
    case errorProcessInternalError  = 5
    
    case errorProcessCanceled       = 7
    case errorProcessInvalidRequest = 8

    func desc(comment:String?) -> String {
        var rValue = ""
        
        switch self {
        case .WorksGood:
            rValue = "Works good!"
        case .errorProcessNotSupport:
            rValue = "Error in process not support"
        case .errorProcessParamNotExist:
            rValue = "Error in progress param not exist"
        case .errorProcessNotExist:
            rValue = "Error in progress not exist expected"
        case .errorProcessCanceled:
            rValue = "Progress canceled"
        case .errorUnknown:
            rValue = "Error unknown"
        case .errorGeneral:
            rValue = "Error general"
        case .errorProcessInternalError:
            rValue = "Internal error"
        case .errorProcessInvalidRequest:
            rValue = "Invalid request"
        }
        return rValue + " " + (comment ?? "")
    }
}



