//
//  GoodResponderModel.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/09.
//

import Foundation
import WebKit

/// 네이티브가 웹으로 보낼 수 있는 이벤트 목록
enum EventsFromNaviteToWeb : String {
    case WEPIN_NATIVE_EVENT // close 된 위젯을 다시 오픈해달라고 요청
}

protocol GoodResponderModelDelegate : AnyObject {
    
    var viewWebInside: WKWebView? { get }
    func timeToResponseToTheWeb(message:String?)
    func timeToEventToTheWeb(event:EventsFromNaviteToWeb, of message:String?)
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
    
    /// EVENT -> Native to Web
    func timeToEventToTheWeb(event:EventsFromNaviteToWeb, of message:String?) {
        if let msg = message {
            let f = "try{ onNativeEvent(\"" + event.rawValue + "\"," + msg + ");}catch(error){root.onError(error.message);};"
            print(f + "\n\n")
            self.viewWebInside?.evaluateJavaScript(f , completionHandler: nil)
        }
        else {
            let f = "try{ onNativeEvent(\"" + event.rawValue + "\",\"\");}catch(error){root.onError(error.message);};"
            print(f + "\n\n")
            self.viewWebInside?.evaluateJavaScript(f , completionHandler: nil)
        }
    }
}

class GoodResponderModel {
    
}
