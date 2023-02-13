//
//  GoodResponderModel.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation
import WebKit

protocol GoodResponderModelDelegate : AnyObject {
    
    var viewWebInside: WKWebView? { get }
    func timeToResponseToTheWeb(message:String?)
}

extension GoodResponderModelDelegate {
    func timeToResponseToTheWeb(message:String?) {

        if let msg = message {
            self.viewWebInside?.evaluateJavaScript("onResponse(" + msg + ");", completionHandler: nil)
        }
        else {
            self.viewWebInside?.evaluateJavaScript("onResponse();", completionHandler: nil)
        }
    }
}

class GoodResponderModel {
    
}
