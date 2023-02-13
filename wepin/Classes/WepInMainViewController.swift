//
//  WebInMainViewController.swift
//  WebinExample
//
//  Created by Abraham Park on 2023/02/03.
//

import UIKit
import Foundation

import WebKit

public class WepinMainViewController: UIViewController {
    private var constraintHeightOfMain: NSLayoutConstraint?
    
    let modelGoodListener = GoodListenerModel()
    
    public var heightOfMain: CGFloat = 10 {
        didSet {
            constraintHeightOfMain?.constant = heightOfMain
        }
    }
    
    public var attributes: Wepin.WidgetAttributes? = nil
    
    func prepareInit() {
        self.modelGoodListener.goodResponder = self
        self.prepareMessageHandler()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        constraintHeightOfMain = Wepin.bringHimToShow(on: self.view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToClose(gs:))))
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
}

extension WepinMainViewController: WKScriptMessageHandler {
    
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
