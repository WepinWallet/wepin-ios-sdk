//
//  SceneDelegate.swift
//  WebinExample
//
//  Created by Abraham Park on 2023/02/03.
//

import UIKit
import wepin

class SceneDelegate: UIResponder, UIWindowSceneDelegate{

    var window: UIWindow?
    
    // !!! 주의 !!!  유니버셜링크 (URL scheme)로 실행된 경우 아래 함수가 가장 먼저 호출됨 !!!
    // 요기에서 유니버셜 링크에 대한 처리를 하면된다!!
    //SceneDelegate 가 없는 경우에는 AppDelegate의 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{ } 에서 처리!!
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        // !! 위핀 실행 후 구글로그인 버튼을 누르면 브라우저에서 구글로그인을 한 후 유니버셜 링크를 통해서 앱으로 돌아온다
        // 요기서 아래와 같이 처리를 하면됨
        
        guard let url = URLContexts.first?.url else { return }
        
        let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
        print("bundleId " + bundleId)
        let checkScheme = bundleId + ".wepin"
        // url scheme  체크
        guard url.scheme == checkScheme else {
            print("invalid url scheme : " + url.scheme!)
            return
        }
        
        // 받은 url을 wepin에 넘겨준다
        Wepin.instance().handleUniversalLink(paramUrl: url)
        //
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

