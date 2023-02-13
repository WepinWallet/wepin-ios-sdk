//
//  APIAsyncResponserWithParamter.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/10.
//

import Foundation

protocol APIAsyncResponserWithParamter: APIResponserWithParamter {

    func requestAsyncProcess(closureResult:(() -> Void)?)
    func asyncResponseSetParam(param: Any)
}

extension APIAsyncResponserWithParamter {
    
}

