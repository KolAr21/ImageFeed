//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Арина Колганова on 07.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.rootViewController = UIStoryboard(
            name: "Main",
            bundle: .main
                ).instantiateInitialViewController()
        let splashViewController = SplashViewController()
        window?.rootViewController = splashViewController

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}


}

