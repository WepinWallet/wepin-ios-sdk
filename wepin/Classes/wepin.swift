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
    
    public static func bringHimToShow(on: UIView) -> NSLayoutConstraint {
        on.addSubview(viewWeb)
        
        viewWeb.bottomAnchor.constraint(equalTo: on.bottomAnchor).isActive = true
        viewWeb.leftAnchor.constraint(equalTo: on.safeAreaLayoutGuide.leftAnchor).isActive = true
        viewWeb.rightAnchor.constraint(equalTo: on.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        let constHeight = viewWeb.heightAnchor.constraint(equalToConstant: on.frame.height * 6/7)
        
        constHeight.isActive = true

        return constHeight
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
    
    func getUrl(appKey: String) -> String? {
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
        if viewWeb != nil {
            return
        }
        
        let wVConfig = WKWebViewConfiguration()
        wVConfig.applicationNameForUserAgent = wVConfig.applicationNameForUserAgent! + "io.wepin"
        let vW = WKWebView(frame: .zero , configuration: wVConfig)
                
        vW.translatesAutoresizingMaskIntoConstraints = false

        window?.addSubview(vW)
        window?.sendSubviewToBack(vW)
        
        viewWeb = vW

        let url = URL(string: urlString)!
        let req = URLRequest(url: url)

        Wepin.viewWeb.load(req)
    }
    
    public static func viewWebStop() {
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
            Wepin.instance().delegate?.onWepinError(errMsg: "Invalid appKey.")
            return
        }
        
        Wepin.viewWebStart(urlString: urlString!)
        self.wepinVC = showWepinWidget(showType: self.widgetAttributes!.type)

        
        completionHandler?(true, nil)
    }
    
    public func isInitialized() -> Bool {
        return self.initialized
    }
    
    public func finalize(){
        print("Wepin finalize")
        if(isInitialized() == false){
            Wepin.instance().delegate?.onWepinError(errMsg: "WEPIN NOT INITIALIZED")
            return
        }

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
        var address:String
        var network:String
        
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
     Login Provider에 맞게 로그인을 실행 한다.
     */
    func login(provider:Wepin.LoginProvider)
    
    /**
     에러 발생시 에러 메세지 반환
     */
    func onWepinError(errMsg: String)
    
}

///
/// Internal functions for Wipin  ====================================================================
///
func showWepinWidget(showType: Wepin.WidgetType) -> WepinMainViewController {
    let rootVc = UIApplication.shared.keyWindow?.rootViewController
    
    let vcWebIn = WepinMainViewController(nibName: nil, bundle: nil)
    vcWebIn.attributes = Wepin.instance().widgetAttributes
    
    vcWebIn.heightOfMain = 700

    vcWebIn.prepareInit()

    if(showType == Wepin.WidgetType.show){
        rootVc?.present(vcWebIn, animated: true)
    }
    
    return vcWebIn
}
