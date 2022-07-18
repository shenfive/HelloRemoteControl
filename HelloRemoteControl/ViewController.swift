//
//  ViewController.swift
//  HelloRemoteControl
//
//  Created by 申潤五 on 2022/7/18.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {

    let remoteConfig:RemoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchValues()
    }
    
    func fetchValues(){
        let defaults:[String:NSObject] = ["AppName":"NameFromAPP" as NSObject]
        remoteConfig.setDefaults(defaults)
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        
        self.remoteConfig.fetch(withExpirationDuration: 100) { status, error in
            if status == .success, error == nil{
                self.remoteConfig.activate { theBool, error in
                    if error != nil {
                        print("activate error")
                        print(error?.localizedDescription)
                        return
                    }
                    let value = self.remoteConfig.configValue(forKey: "AppName")
                    print(value.stringValue)
                }
            }else{
                print("fetch error")
                print(error?.localizedDescription)
            }
        }
    }


}

