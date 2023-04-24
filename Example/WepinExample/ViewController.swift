//
//  ViewController.swift
//  WebinExample
//
//  Created by Abraham Park on 2023/02/03.
//

import UIKit
import wepin

class ViewController: UIViewController {
    @IBOutlet weak var tvResult: UITextView!

    let appKey: String = "test_app_key"
    let appId: String = "test_app_id"
    
    let wepin: Wepin = Wepin.instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wepin.delegate = self

    }

    @IBAction func btnInitShow(_ sender: Any) {
        print("btnInitShow")
        
        if wepin.isInitialized(){
            self.tvResult.text = String("Already Initialized")
            return
        }

        //
        let attributes = Wepin.WidgetAttributes(type: Wepin.WidgetType.show)
        wepin.initialize(appId: self.appId, appKey: self.appKey, attributes: attributes){ (result, error) -> Void in
            print(result)
        }
        self.tvResult.text = String("Successed")
    }
    
    @IBAction func btnInitHide(_ sender: Any) {
        print("btnInitHide")
        
        if wepin.isInitialized(){
            self.tvResult.text = String("Already Initialized")
            return
        }
        
        let attributes = Wepin.WidgetAttributes(type: Wepin.WidgetType.hide)
        wepin.initialize(appId: self.appId, appKey: self.appKey, attributes: attributes)
        self.tvResult.text = String("Successed")
    }
    
    @IBAction func btnIsInit(_ sender: Any) {
        print("btnIsInit")
        let b = wepin.isInitialized()
        print(b)
        self.tvResult.text = String(b)
    }
    
    @IBAction func btnOpenWidget(_ sender: Any) {
        print("btnOpenWidget")
        wepin.openWidget()
        self.tvResult.text = String("Successed")
    }
    
    @IBAction func btnCloseWidget(_ sender: Any) {
        print("btnCloseWidget")
        wepin.closeWidget()
        self.tvResult.text = String("Successed")
    }
    
    @IBAction func btnGetAddress(_ sender: Any) {
        print("btnGetAddress")
        wepin.getAccounts() { (accounts, error) -> Void in
            if let walletAccounts = accounts {
                print("btnGetAddress : ", walletAccounts)
                self.tvResult.text = String(describing: walletAccounts)
                for account in walletAccounts {
                    print("address : ", account.address)
                    print("network : ", account.network)
                    
                }
            }
        }
        
    }
    
    @IBAction func btnFinalize(_ sender: Any) {
        print("btnFinalize")
        wepin.finalize()
        self.tvResult.text = String("Successed")
    }
}

extension ViewController: WepinDelegate {
    
    func onWepinError(errMsg: String) {
        print("onWepinError : ", errMsg)
        tvResult.text = "Error : " + errMsg
    }
    
    func onAccountSet() {
        print("onAccountSet")
        wepin.getAccounts() { (accounts, error) -> Void in
            if let walletAccounts = accounts {
                for account in walletAccounts {
                    print("network : ", account.network)
                    print("address : ", account.address)
                    
                }
            }
        }
    }
}

