//
//  NativeRequestModel.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

class GoodListenerModel {

    weak var goodResponder: GoodResponderModelDelegate!
    let decoderForJSON  = JSONDecoder()
    let encoderForJSON = JSONEncoder()
    
    func requestFromWebUI(messageBody :Any, requestFrom:String) -> (isError:Bool, msgData:Data?) {
        print("ENTER requestFromWebUI")
        guard let msgData = (messageBody as? String)?.data(using: .utf8) else {
            print("Convert to data failed")
            return (true, nil)
        }

        guard let request = try? decoderForJSON.decode(BaseRequest.self , from: msgData) else {
            print("Parse Failed - An unsupported message was sent.")
            return (true, msgData)
        }
        
        switch request.header.request_to {
            case .native:
                self.understandMessageForNative(request: request, requestFrom: requestFrom)
        }

        return (false, nil)
    }
    
    func timeToBackToWeb(response:BaseResponse?) {
        let result = try! encoderForJSON.encode(response)
        
        print("\n-----------timeToBackToWeb------------\n")
        print(result)
        print(result.stringUTF8!)
        print("\n--------------------------------------\n")

        goodResponder.timeToResponseToTheWeb(message: result.stringUTF8)
    }
}
