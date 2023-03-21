//
//  WebInMainViewController.swift
//  WebinExample
//
//  Created by Abraham Park on 2023/02/03.
//

import UIKit
import Foundation

import WebKit

public class WepinMainViewController: UIViewController, WKUIDelegate {
    private var constraintHeightOfMain: NSLayoutConstraint?
    
    let modelGoodListener = GoodListenerModel()
//
//    public var heightOfMain: CGFloat = 10 {
//        didSet {
//
//            constraintHeightOfMain?.constant = heightOfMain
//            print("yskim didset heightOfMain : ", heightOfMain)
//        }
//    }
    
    public var attributes: Wepin.WidgetAttributes? = nil
    
    func prepareInit() {
        self.modelGoodListener.goodResponder = self
        self.prepareMessageHandler()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        //constraintHeightOfMain = Wepin.bringHimToShow(on: self.view)
        Wepin.bringHimToShow(on: self.view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToClose(gs:))))
        Wepin.viewWeb.uiDelegate = self //웹뷰에서 실행하는 window.open() 에 필요!!
    }
    
    @objc private func tapToClose(gs: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Wepin.makeHimHide()
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        
        print("called by open.window()")
        
        let loadUrl : String = navigationAction.request.url!.absoluteString
        print("loadUrl : ", loadUrl)
        if (loadUrl.contains("http://") || loadUrl.contains("https://") ) {
            if #available(iOS 10.0,*) { // ios version 10.0 이상인지 체크
                if let aString = URL(string:(navigationAction.request.url?.absoluteString )!) {
                    UIApplication.shared.open(aString, options:[:], completionHandler: { success in
                    })
                }
                if let aString = URL(string:(navigationAction.request.url?.absoluteString )!) {
                    UIApplication.shared.openURL(aString)
                }
            }
        } else {
            print("invalid url format")
        }
        
        return nil
    }
}

extension WepinMainViewController: WKScriptMessageHandler{
    
    func prepareMessageHandler() {
        if(Wepin.instance().isInitialized() == false){
            Wepin.viewWeb.configuration.userContentController.removeAllScriptMessageHandlers()
            Wepin.viewWeb.configuration.userContentController.add(self, name: "log")
            Wepin.viewWeb.configuration.userContentController.add(self, name: "post")
        }
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "log" {
            return
        }
        
        if message.name == "post" {
            processPost(message: message)
            return
        }
    }
    
    func processPost (message: WKScriptMessage) {
        print("\n---------- Request From Web-----------\n")
        print("message : ", message.body)
        print("\n--------------------------------------\n")

        let result = modelGoodListener.requestFromWebUI(messageBody: message.body, requestFrom: message.name)
        print("result : ", result)
    }
    
    func loginWepinResponseProcess (token: String) {
        Wepin.instance().wepinVC?.modelGoodListener.asyncLoginWepinResponseProcess(token: token)
    }
    
}


extension WepinMainViewController : GoodResponderModelDelegate {
    var viewWebInside: WKWebView? {
        get {
            Wepin.viewWeb
        }
    }
}
