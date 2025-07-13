//
//  AppDelegate.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //테스트용 임시코드
        AppConfig.shared.currentUser = UserSession(
            id: 4,
            name: "테스트유저",
            email: "test@example.com",
            authToken:"eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIzIiwidHlwZSI6ImFjY2VzcyIsImlhdCI6MTc1MjMwODkxNiwiZXhwIjoxMDM5MjIyMjUxNn0.Qtdr8tx5_yEHRyllWh47-zYP9Ow2KUy0ANXCuz-bg5Jlfj_qjO2NMXQ4k_CAB0_TVCk5fPsLcq-EF7BtwcNYMqFJEJVbeeZgFdYdkOY2VIwYA-mC7tqtE1DnjAV8EGOJBsBiztgRyzpbNeG_oniZaxOTOmhhvjsLPownZ_FXfAFT6dcumcwWbUTZIAzaXbGdipXFamvLhlS2ugUHhU-I5-wy-U4IgZgrB-cm1IUM-A2kLJA8cmOhGVUOcEireozvpD7JR5KQbzV9SlExf60l5cia7JPnqiedlnrBjOflQsdSUxlD3dnJFdeit8QTHjdSTFJcWn46zuAT8xE2qi2_mA", // 여기에 실제 또는 더미 토큰 문자열 입력
            refreshToken: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIzIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NTIzMDg5MTYsImV4cCI6MTc1MjkxMzcxNn0.tpl84beaoZclYJkRVqAebkdRdeP9X_EOsF6KY7OJx1JZoCoVK3sjiJGHQJdOwU6-4VVM_GygXcTR7Gt4p24bpOi6Wk1lF41QgKMjB3BusqkEkvxEvf3xmUD2rsL-YGWXV1BWKqyywZRLBhQ1EkP_iIcaMRWB33S7LTLI9nh28StWsQfCcU59BnoQY5Hu0FIfmyfM6E8iYjRdGdqsdF7cMiBedmDfK9vOPCJDgl-l7aW3PQAnvk9ABIbxE1h9JEn7plMEyljz8Pp_nLNJfpV8RUiS4TzuKswDtsKrRUhbv76fdcYHbIMfUnbfaLxVT7PFHtUsvrexXXQiy6XTOkGcvA"
        )
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

