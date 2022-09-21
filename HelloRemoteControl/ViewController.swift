//
//  ViewController.swift
//  HelloRemoteControl
//
//  Created by 申潤五 on 2022/7/18.
//

import UIKit

import FirebaseRemoteConfig

class ViewController: UIViewController {

    var mRemotConfig:RemoteConfig!
    
    @IBOutlet weak var uilabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取得實體
        mRemotConfig = RemoteConfig.remoteConfig()
        //測試模式
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        mRemotConfig.configSettings = settings
        
        //設定預設
        mRemotConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        let color = self.mRemotConfig["homePageTitleBackgroundColor"].stringValue ?? ""
        self.uilabel.backgroundColor = UIColor(hex: color)
        
        //更新與執行
        mRemotConfig.fetch { status, error in
            switch status{
            case .success:
                self.mRemotConfig.activate { chaned, error in
                    let color = self.mRemotConfig["homePageTitleBackgroundColor"].stringValue ?? ""
                    DispatchQueue.main.async {
                        self.uilabel.backgroundColor = UIColor(hex: color)
                    }
                }
            default:
                break
            }
        }
    }
}



extension UIColor{
    //由 hex 的顏色表示字串，轉換為 UIColor
    convenience init?(hex:String){
        if  hexColor.count >= 7,
            let redDec = Int((hexColor as NSString).substring(with: NSMakeRange(1, 2)), radix:16),
            let greenDec = Int((hexColor as NSString).substring(with: NSMakeRange(3, 2)), radix:16),
            let blueDec = Int((hexColor as NSString).substring(with: NSMakeRange(5, 2)), radix:16){
            
            self.init(red: CGFloat(redDec) / 255,green: CGFloat(greenDec) / 255,blue: CGFloat(blueDec) / 255,alpha: 1)
        }else{
            return nil
        }
    }
}
