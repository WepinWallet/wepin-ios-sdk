//
//  KeyForAsyncMaintainer.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/10.
//

import Foundation

enum KeyForAsyncMaintainer : String {
    case NativeLoginWepinModel
    
    func createInstance(for key:KeyForAsyncMaintainer) -> APIAsyncResponserWithParamter {
        switch key {
        case .NativeLoginWepinModel:
            return WepinSDK.NativeLoginWepinModel()
        }
    }
}

class ASyncMaintainer {
    static let shared = ASyncMaintainer()
    
    var objectsForAsync:[KeyForAsyncMaintainer:APIAsyncResponserWithParamter] = [:]
    
    func objectForKey(key:KeyForAsyncMaintainer) -> APIAsyncResponserWithParamter? {
        return objectsForAsync[key]
    }
    
    func setObject(object:APIAsyncResponserWithParamter?, for key:KeyForAsyncMaintainer) {
        objectsForAsync[key] = object
    }

    func removeObject(for key:KeyForAsyncMaintainer) {
        objectsForAsync[key] = nil
    }

    func returnOrCreateObjectForKey(key:KeyForAsyncMaintainer, with newRequest:BaseRequest?) -> APIAsyncResponserWithParamter {
        if var obj = objectForKey(key: key) {
            if let req = newRequest {
                obj.request = req
            }
            return obj
        }

        var obj = key.createInstance(for: key)
        
        if let req = newRequest {
            obj.request = req
        }
        setObject(object: obj, for: key)
        
        return obj
    }
}
