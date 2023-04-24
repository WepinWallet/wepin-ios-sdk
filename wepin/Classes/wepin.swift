//
//  wepin.swift
//  WepinSDK
//
//  Created by musicgi on 2023/02/06.
//

import Foundation
import UIKit
import WebKit

public typealias CompletionHandler = (_ result:Bool?, _ error:WepinError?) -> Void
public typealias GetAccountsCompletionHandler = (_ result:[Wepin.Account]?, _ error:WepinError?) -> Void

public enum WepinError {
    case errorInvalidParameters
    case errorNotInitialized
}

public class Wepin {
    var initialized: Bool = false
    var appId: String? = nil
    var appKey: String? = nil
    var domain: String? = nil
    var accounts: [Account] = []
    var widgetAttributes: Wepin.WidgetAttributes? = nil
    
    public var delegate: WepinDelegate? = nil
    
    static let defaultInstance = Wepin()
    
    var wepinVC: WepinMainViewController?
    
    ///
    /// APIs for initialize & login ====================================================================
    ///
    public static func instance() -> Wepin {
        return defaultInstance
    }
    
    static var viewWeb:WKWebView! = nil
    
    static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    public static func bringHimToShow(on: UIView) {
        print("bringHimToShow")
        
        on.addSubview(viewWeb)
        
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height
        print("satatusBarHeight", statusBarHeight)
        var fixedHeight = on.frame.height - statusBarHeight!
        print("fixed_height", fixedHeight)
        viewWeb.bottomAnchor.constraint(equalTo: on.bottomAnchor).isActive = true
        viewWeb.leftAnchor.constraint(equalTo: on.safeAreaLayoutGuide.leftAnchor).isActive = true
        viewWeb.rightAnchor.constraint(equalTo: on.safeAreaLayoutGuide.rightAnchor).isActive = true
        //viewWeb.heightAnchor.constraint(equalToConstant: (on.frame.height - statusBarHeight!) * 6/7).isActive = true
        //viewWeb.heightAnchor.constraint(equalToConstant: (on.frame.height - statusBarHeight!)).isActive = true
        viewWeb.heightAnchor.constraint(equalToConstant: fixedHeight).isActive = true
        
        //  웹뷰 배경화면 투명처리
        viewWeb.backgroundColor = UIColor.clear
        viewWeb.isOpaque = false
        //
        
        //
        //viewWeb.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //viewWeb.uiDelegate = self //웹뷰에서 실행하는 window.open() 에 필요!!
        viewWeb.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true //window.close에 필요!!

    }
    
    func dataRemoveAll(){
        print("dataRemoveAll")
        self.accounts  = []
    }
    
    public static func makeHimHide() {
        viewWeb.removeConstraints(viewWeb.constraints)
        
        window?.addSubview(viewWeb)
        window?.sendSubviewToBack(viewWeb)
        
        viewWeb.frame = .zero
    }
    
    public func getUrl(appKey: String) -> String? {
        var urlString:String? = nil
        
        if (appKey.hasPrefix("ak_live_")) {
            urlString = "https://widget.wepin.io/"
        }else if(appKey.hasPrefix("ak_test_")) {
            urlString = "https://stage-widget.wepin.io/"
        }else if(appKey.hasPrefix("ak_dev_")) {
            urlString = "https://dev-widget.wepin.io/"
        }

        return urlString
    }
    
    public static func viewWebStart(urlString: String) {
        print("viewWebStart loadUrl : " + urlString)
        if viewWeb != nil {
            print("viewWeb is not nil")
            return
        }
        
        
        let wVConfig = WKWebViewConfiguration()
        wVConfig.applicationNameForUserAgent = wVConfig.applicationNameForUserAgent! + "io.wepin"
        wVConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let vW = WKWebView(frame: .zero , configuration: wVConfig)
        
        vW.translatesAutoresizingMaskIntoConstraints = false
        
        window?.addSubview(vW)
        window?.sendSubviewToBack(vW)
        
        viewWeb = vW

        let url = URL(string: urlString)!
        let req = URLRequest(url: url)

//        let testUrlStr = "http://192.168.0.152:5173/"
//        let url = URL(string: testUrlStr)!
//        let req = URLRequest(url: url)
        //Wepin.viewWeb.load(req)
        viewWeb.load(req)
    }
    

    public func handleUniversalLink(paramUrl: URL) {
        
        
        
        if Wepin.viewWeb == nil {
            print("VIEWEB IS NIL")
            delegate?.onWepinError(errMsg: "VIEWEB IS NIL")
            return
        }
        //Wepin.viewWebStop()
        
        
        //finalize()
        // 구글로그인 후 유니버셜링크로 위젯에서 네이티브로 돌아올때 쿼리에 파이어베이스 토큰을 넣어줌
        let urlString = paramUrl.absoluteString
        print("handleUniversalLink : ", urlString)
        
        // URLComponents는 queryItems 객체에 접근 가능
        guard let urlComponents = URLComponents(string: paramUrl.absoluteString) else {
            print("URL COMPONENT IS NIL")
            delegate?.onWepinError(errMsg: "URL COMPONENT IS NIL")
            return
        }
               
        guard let params = urlComponents.queryItems else {
            print("QUERY ITEMS ARE NOT EXIST")
            delegate?.onWepinError(errMsg: "QUERY ITEMS ARE NOT EXIST")
            return
        }
        
        guard "token" == params.first?.name else {
            print("TOKEN NAME IS NOT EXIST")
            delegate?.onWepinError(errMsg: "TOKEN NAME IS NOT EXIST")
            return
        }
        
        guard let token = params.first?.value else {
            print("TOKEN VALUE IS NOT EXIST")
            delegate?.onWepinError(errMsg: "TOKEN VALUE IS NOT EXIST")
            return
        }
        
        print("received firebase token : ", token)
        
        let getUrlStr: String? = getUrl(appKey: self.appKey!)
        var components = URLComponents(string: getUrlStr!)
        components?.path.append("login")
        let queryItem = URLQueryItem(name: "token", value: token)
        components?.queryItems = [queryItem]
       // let url = URL(string: urlString)
        let req = URLRequest(url: (components?.url)!)
        print("component Url : ", components?.url)
        
//        // for test
//        print("Widget url to load : ", urlString)
//        Wepin.viewWebStart(urlString: req.url?.absoluteString ?? "")
//        self.wepinVC = showWepinWidget(showType: self.widgetAttributes!.type)

        //Wepin.viewWeb.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //Wepin.viewWebStart(urlString: req.url?.absoluteString ?? "")
        
        //Wepin.viewWebStart(urlString: "https://www.naver.com")
        //self.wepinVC = showWepinWidget(showType: self.widgetAttributes!.type)
        
//
//        if queryItem.value?.isEmpty == true {
//            print("token is empty")
//            // 웹뷰 모든 데이터 삭제
////            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: {
////                (records) -> Void in
////                for record in records {
////                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
////                    // remove callback
////                 }
////             })
//            //Wepin.viewWebStop()
//
//            //self.wepinVC = showWepinWidget(showType: self.widgetAttributes!.type)
//
////            // 웹뷰 원하는 데이터만 삭제
//            let websiteDataTypes = NSSet(array:
//                                                        [WKWebsiteDataTypeDiskCache, // 디스크 캐시 fail
//                                                         WKWebsiteDataTypeMemoryCache, // 메모리 캐시 fail
//                                                         WKWebsiteDataTypeCookies, // 웹 쿠키, never
//
//                                                         WKWebsiteDataTypeOfflineWebApplicationCache, // 앱 캐시 fail
//                                                         WKWebsiteDataTypeWebSQLDatabases, // 웹 SQL 데이터 베이스
//                                                         WKWebsiteDataTypeIndexedDBDatabases, // 데이터 베이스 정보
//
//                                                         WKWebsiteDataTypeLocalStorage, // 로컬 스토리지 never
//                                                         //WKWebsiteDataTypeSessionStorage // 세션 스토리지
//                                                        ])
//                    let date = NSDate(timeIntervalSince1970: 0)
//            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date as Date, completionHandler:{
//                print("initialize webview")
//
//            })
//            Wepin.viewWebStart(urlString: req.url?.absoluteString ?? "")
//
//        }else{
//            Wepin.viewWeb.load(req)
//        }

        //Wepin.viewWeb.load(req)
        
//            // 웹뷰 원하는 데이터만 삭제
//            let websiteDataTypes = NSSet(array:
//                                                        [WKWebsiteDataTypeDiskCache, // 디스크 캐시 fail
//                                                         WKWebsiteDataTypeMemoryCache, // 메모리 캐시 fail
//                                                         //WKWebsiteDataTypeCookies, // 웹 쿠키, never
//
//                                                         WKWebsiteDataTypeOfflineWebApplicationCache, // 앱 캐시 fail
//                                                         WKWebsiteDataTypeWebSQLDatabases, // 웹 SQL 데이터 베이스
//                                                         WKWebsiteDataTypeIndexedDBDatabases, // 데이터 베이스 정보
//
//                                                         WKWebsiteDataTypeLocalStorage, // 로컬 스토리지 never
//                                                         WKWebsiteDataTypeSessionStorage // 세션 스토리지
//                                                        ])
//                    let date = NSDate(timeIntervalSince1970: 0)
//            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date as Date, completionHandler:{
//                print("initialize webview")
//
//            })
//
        
        
        
        Wepin.viewWeb.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        Wepin.viewWeb.load(req)
        
    }


    public static func viewWebStop() {
        print("viewWebStop")
        viewWeb?.removeFromSuperview()
        viewWeb = nil
        
    }

    public func initialize(appId: String, appKey: String, attributes: WidgetAttributes,_ completionHandler: CompletionHandler? = nil){
        print("Wepin initialize")
        
        self.dataRemoveAll()

        self.appId = appId
        self.appKey = appKey
        self.widgetAttributes = attributes
        self.domain = Bundle.main.bundleIdentifier!

        //
        let urlString: String? = getUrl(appKey: self.appKey!)
        
        if(urlString == nil){
            Wepin.instance().delegate?.onWepinError(errMsg: "INVALID APIKEY")
            return
        }
        
        print("Widget url to load : ", urlString)
        Wepin.viewWebStart(urlString: urlString!)
        self.wepinVC = showWepinWidget(showType: self.widgetAttributes!.type)
        completionHandler?(true, nil)
    }
    
    public func isInitialized() -> Bool {
        return self.initialized
    }
    
    public func finalize(){
        print("Wepin finalize")
//        if(isInitialized() == false){
//            Wepin.instance().delegate?.onWepinError(errMsg: "WEPIN NOT INITIALIZED")
//            return
//        }

        self.dataRemoveAll()
        
        Wepin.viewWebStop()
        
        self.initialized = false
    }
    
    public func completeLogin(user: User) {
        print("completeLogin: ", user)
        let idToken = user.idToken
        self.wepinVC?.loginWepinResponseProcess(token: idToken!)
    }
    
    ///
    /// APIs for Widget Open/Close  ====================================================================
    ///
    public func openWidget(_ completionHandler: CompletionHandler? = nil) {
        
        if(isInitialized() == false){
            Wepin.instance().delegate?.onWepinError(errMsg: "WEPIN NOT INITIALIZED")
            completionHandler?(nil, nil)
            return
        }

        
        let header = BaseEventRequest.Header(request_from: "native", request_to: "wepin_widget", id: 2678140026900)
        let body =  BaseEventRequest.Body(command: "open_widget", parameter: "")
        let request =  BaseEventRequest(header: header, body: body)

        let data = try! JSONEncoder().encode(request)
        self.wepinVC?.modelGoodListener.timeToEventToWeb(event: EventsFromNaviteToWeb.WEPIN_NATIVE_EVENT, params: data)
        self.wepinVC = showWepinWidget(showType: Wepin.WidgetType.show)

        completionHandler?(true, nil)
    }
    
    public func closeWidget(_ completionHandler: CompletionHandler? = nil) {
        if(isInitialized() == false){
            Wepin.instance().delegate?.onWepinError(errMsg: "WEPIN NOT INITIALIZED")
            completionHandler?(nil, nil)
            return
        }

        completionHandler?(true, nil)
    }
    
    ///
    /// APIs for common  ====================================================================
    ///
    public func getAccounts(networks: [String]? = nil, _ completionHandler: GetAccountsCompletionHandler? = nil) {
        if(isInitialized() == false){
            Wepin.instance().delegate?.onWepinError(errMsg: "WEPIN NOT INITIALIZED")
            completionHandler?(nil, nil)
            return
        }
        print("GetAccounts : ", self.accounts)
        var newAccounts:[Account] = []
        
        if let nets = networks {
            for network in nets {
                for account in self.accounts {
                    print("account :", account)
                    
                    if(network == account.network){
                        let newAcc = Wepin.Account(
                            address: account.address,
                            network: account.network
                        )
                        newAccounts.append(newAcc)
                    }
                }
            }
        } else {
            newAccounts = self.accounts
        }
        
        completionHandler?(newAccounts, nil)
    }
   
    ///
    /// APIs for provider   ====================================================================
    ///
    
    
    
    ///
    /// Enum    ====================================================================
    ///
    /**
     floating: floating type widget
     show: show widget after initialized
     hide: do now show sidget after initialized
     */
    public enum WidgetType:String {
//        case floating
        case show
        case hide
    }
    /**
     Google: google login provider
     */
    public enum LoginProvider: String {
        case Google
        
        public init?(rawValue: String) {
            switch rawValue {
            case "google": self = .Google
            default: return nil
            }
        }
    }
    
    ///
    /// Structure    ====================================================================
    ///
    ///
    /**
     Widget Attributes
        Widget Type
        Default language used in widget
        Default current used in widget
     */
    public struct WidgetAttributes {
        var type: WidgetType
        var defaultLanguage: String
        var defaultCurrendy: String
        
        public init(type: WidgetType, defaultLanguage: String = "ko", defaultCurrendy: String = "KRW") {
            self.type = type
            self.defaultLanguage = defaultLanguage
            self.defaultCurrendy = defaultCurrendy
        }
    }
    
    /**
     User information of logined
        User ID
        name
        emal
        idToken
     */
    public struct User {
        var userID: String?
        var name: String?
        var email: String?
        var idToken: String?

        public init(userID: String?, name: String?, email: String?, idToken: String?) {
              self.userID = userID
              self.name = name
              self.email = email
              self.idToken = idToken
        }
    }
    /**
     Account struct
        address: address of account
        network: network of account
     */
    public struct Account {

    public var address:String
    public var network:String
        
        public init(address: String, network: String) {
              self.address = address
              self.network = network
            
        }
        
    }
}

///
/// Protocols for Wipin  ====================================================================
///
public protocol WepinDelegate {
    
    /**
     에러 발생시 에러 메세지 반환
     */
    func onWepinError(errMsg: String)
    
    /**
     계정이 생성되었음을 알려줌
     */
    func onAccountSet()
    
}

///
/// Internal functions for Wipin  ====================================================================
///
func showWepinWidget(showType: Wepin.WidgetType) -> WepinMainViewController {
    
    print("showWepinWidget")
    
    let rootVc = UIApplication.shared.keyWindow?.rootViewController
    let vcWebIn = WepinMainViewController(nibName: nil, bundle: nil)
    vcWebIn.attributes = Wepin.instance().widgetAttributes
    
    //vcWebIn.heightOfMain = 700
    vcWebIn.prepareInit()

    if(showType == Wepin.WidgetType.show){
        rootVc?.present(vcWebIn, animated: true)
        
    }
    return vcWebIn
}
