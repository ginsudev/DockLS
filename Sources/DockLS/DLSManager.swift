//
//  DLSManager.swift
//  
//
//  Created by Noah Little on 24/2/2022.
//

import Foundation
import DockLSC

final class DLSManager: NSObject {
    static let sharedInstance = DLSManager()
    var dockList: SBDockIconListView!
    var dock: DLSDockView!
    var dockHeight: CGFloat = 0.0
    
    func iconFromBundleID(_ id: String) -> UIImage {
        //Returns a UIImage object of an app's icon.
        let icon: SBIcon? = SBIconController.sharedInstance().model.expectedIcon(forDisplayIdentifier: id)
        let imageSize = CGSize(width: 60, height: 60)
        let imageInfo = SBIconImageInfo(size: imageSize,
                                        scale: UIScreen.main.scale,
                                        continuousCornerRadius: 12)
        
        let img = icon?.generateImage(with: imageInfo) as? UIImage ?? UIImage(systemName: "questionmark.square.fill")!
        return img
    }
    
    func openApplication(withBundleID bundleIdentifier: String) {
        let launchOptions = [
            FBSOpenApplicationOptionKeyPromptUnlockDevice: NSNumber(value: 1),
            FBSOpenApplicationOptionKeyUnlockDevice: NSNumber(value: 1)
        ]
        
        let service = FBSSystemService.sharedService() as! FBSSystemService
        service.openApplication(bundleIdentifier, options: launchOptions, withResult: nil)
    }
    
    private override init() { }
}
