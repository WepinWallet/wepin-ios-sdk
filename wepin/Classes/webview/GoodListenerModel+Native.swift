//
//  GoodListenerModel+Native.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

extension GoodListenerModel {
    func understandMessageForNative(request:BaseRequest, requestFrom: String) {
        print("\(request.header.request_to.rawValue) : \(request.body.command.rawValue)")
        
        var modelInfo:APIResponserWithParamter? = nil
        var modelInfoAsync:APIAsyncResponserWithParamter? = nil
        
        switch request.body.command {
            case .ready_to_widget:
                modelInfo = NativeRedyToWidgetModel(request: request)
            case .login_wepin:
                modelInfoAsync = ASyncMaintainer.shared.returnOrCreateObjectForKey(key: .NativeLoginWepinModel, with: request)
                modelInfoAsync?.procAfterInit()
                return
            case .set_accounts:
                modelInfo = NativeSetAccountsModel(request: request)
            case .initialized_widget:
                modelInfo = NativeInitializedWidgetModel(request: request)
            case .close_wepin_widget:
                modelInfo = NativeCloseWepinWidgetModel(request: request)
            case .expand_wepin_widget:
                modelInfo = NativeExpandWepinWidgetModel(request: request)
            case .shrink_wepin_widget:
                modelInfo = NativeShrinkWepinWidgetModel(request: request)
        }
        if let m = modelInfo {
            timeToBackToWeb(response: m.requestPrettyResponse())
        }
        else {
            print(">> not made model yet. or Async request")
        }
    }
    
    func asyncLoginWepinResponseProcess(token: String) {
        var modelInfoAsync:APIAsyncResponserWithParamter? = nil

        modelInfoAsync = ASyncMaintainer.shared.objectForKey(key: .NativeLoginWepinModel)

        if var m = modelInfoAsync {
            m.resetResponseParams()
            m.asyncResponseSetParam(param: token)
            m.requestAsyncProcess {
                self.timeToBackToWeb(response: m.requestPrettyResponse())
            }
        }
    }
}
