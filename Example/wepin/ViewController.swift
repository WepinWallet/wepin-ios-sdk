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

    //let appKey: String = "ak_test_2rKZgsq6pybCfMpBbLNI1j8OkigMj7slqOFsD4ETBR7" //stage key
    let appKey: String = "ak_dev_7T1bSnw3TVqnNDY8lMxvGF9PEUIfLAPExE1moWryc6V" //dev key
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
    func login(provider:Wepin.LoginProvider) {
        print("WepinDelegate - login ")
        if provider == .Google {
            print("start google login")
            //  Start to Google Login
            guard let clientID = FirebaseApp.app()?.options.clientID else { // GoogleService-Info.plist 의 REVESED_CLIENT_ID 값을 반대로 얻어옴!! 요렇게 넣어야됨
                print("get Firebase Client Id failed!!")
                return
            }
            
            print("Firebase Client Id : ", clientID)
            let signInConfig = GIDConfiguration.init(clientID: clientID)

            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else { return }
                
                guard let authentication = user?.authentication else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
                
                // access token 부여 받음
                // 파베 인증정보 등록
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                    if let error = error {
                        print("Firebase sign in error: \(error)")
                        return
                    }
                    // 구글 로그인에 셍공한 후 사용자 토큰 갱신
                    Auth.auth().currentUser?.getIDTokenResult(){result,error in
                        if let error = error {
                            print("Token Refresh Failed")
                            return
                        }
                        
                        print("userId : ", user?.userID)
                        print("userName : ", user?.profile?.name)
                        print("userEmail : ", user?.profile?.email)
                        print("userRefreshToken : ", result?.token)
                        
                        let wepinUser = Wepin.User(
                            userID: user?.userID,
                            name: user?.profile?.name,
                            email: user?.profile?.email,
                            idToken: result?.token
                        )
                        self.wepin.completeLogin(user: wepinUser)
                    }
                }
            }
            
        }
    }
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

