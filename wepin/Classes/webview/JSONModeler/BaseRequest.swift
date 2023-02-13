//
//  BaseRequest.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/08.
//

import Foundation

struct BaseRequest {
    var header : Header
    var body : Body

    enum CodingKeys: String, CodingKey {
        case header
        case body
    }
    
    struct Header : Codable {
        var request_to : CaseRequestTo
        
        enum CaseRequestTo : String, Codable {
            case native
        }
        var request_from : String
        var id: Int
    }
    
    struct Body {
        var command : CaseCommand
        var parameter : BaseParameter?

        enum CodingKeys: String, CodingKey {
            case command
            case parameter
        }
        enum CaseCommand : String, Codable {
            case ready_to_widget
            case initialized_widget
            case close_wepin_widget
            case expand_wepin_widget
            case shrink_wepin_widget
            case set_accounts
            case login_wepin
        }
    }
    
    func createNewBaseResponse() -> BaseResponse {
        let respHeader = BaseResponse.Header(response_from: self.header.request_to,
                                             response_to: self.header.request_from,
                                             id: self.header.id)
        let respBody = BaseResponse.Body(command: self.body.command,
                                         state: "ERROR",
                                         data: nil)
        
        return BaseResponse(header: respHeader, body: respBody)
    }

    func KeyOfRequestToWithCommand() -> String {
        return header.request_to.rawValue + "-" + body.command.rawValue
    }
}

/// 아직 지원하지 않는 메시지가 넘어왔다면?
struct BaseRequestUnknown: Codable {
    var header : Header
    var body : Body
    
    struct Header: Codable {
        var request_to : String
        
    }
    struct Body: Codable {
        var command : String
//        var parameter : BaseParameter?
    }
    /// 현 Request를 기반으로 Response 기본형을 하나 반환한다.
    func createNewBaseResponseUnknown() -> BaseResponseUnknown {
        let respHeader = BaseResponseUnknown.Header(response_from: header.request_to,
                                                    code: ErrorCodeForWebUI.errorProcessNotSupport.rawValue,
                                                    description: ErrorCodeForWebUI.errorProcessNotSupport.desc(comment: nil),
                                                    index: nil, count: nil)
        let respBody = BaseResponseUnknown.Body(command: body.command)
        
        return BaseResponseUnknown(header: respHeader, body: respBody)
    }
}
