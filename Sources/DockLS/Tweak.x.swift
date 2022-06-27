import Orion
import DockLSC
import UIKit

struct localSettings {
    static var isEnabled: Bool!
    static var showBG: Bool!
    
    static var isHomeButtoniPhone: Bool {
        return (!UIDevice.tf_deviceHasFaceID() && !UIDevice.currentIsIPad())
    }
    
    static var inset: Double {
        return isHomeButtoniPhone ? 0 : 12
    }
}

struct tweak: HookGroup {}

class SBDockIconListView_Hook: ClassHook<SBDockIconListView> {
    typealias Group = tweak

    func initWithModel(_ arg1: AnyObject, layoutProvider arg2: AnyObject, iconLocation arg3: AnyObject, orientation arg4: UInt64, iconViewProvider arg5: AnyObject) -> Target {
        
        let target = orig.initWithModel(arg1, layoutProvider: arg2, iconLocation: arg3, orientation: arg4, iconViewProvider: arg5)
        DLSManager.sharedInstance.dockList = target
        return target
    }
}

class CSCoverSheetViewController_Hook: ClassHook<CSCoverSheetViewController> {
    typealias Group = tweak

    func viewDidLoad() {
        orig.viewDidLoad()
        
        if DLSManager.sharedInstance.dockList.iconLocation == "SBIconLocationFloatingDock" {
            DLSManager.sharedInstance.dockHeight = 116
        } else {
            if FileManager().fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/DockSearch.dylib") {
                DLSManager.sharedInstance.dockHeight = DLSManager.sharedInstance.dockList.frame.height - 60
            } else {
                DLSManager.sharedInstance.dockHeight = DLSManager.sharedInstance.dockList.frame.height
            }
        }
        
        DLSManager.sharedInstance.dock = DLSDockView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - (localSettings.inset * 2), height: DLSManager.sharedInstance.dockHeight), listView: DLSManager.sharedInstance.dockList)
        DLSManager.sharedInstance.dock.translatesAutoresizingMaskIntoConstraints = false
        target.view.addSubview(DLSManager.sharedInstance.dock)
        //Constraints
        DLSManager.sharedInstance.dock.heightAnchor.constraint(equalToConstant: DLSManager.sharedInstance.dockHeight).isActive = true
        DLSManager.sharedInstance.dock.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (localSettings.inset * 2)).isActive = true
        DLSManager.sharedInstance.dock.centerXAnchor.constraint(equalTo: target.view.centerXAnchor).isActive = true
        DLSManager.sharedInstance.dock.bottomAnchor.constraint(equalTo: target.view.bottomAnchor, constant: -localSettings.inset).isActive = true
    }
}

class CSCombinedListViewController_Hook: ClassHook<CSCombinedListViewController> {
    typealias Group = tweak

    func _listViewDefaultContentInsets() -> UIEdgeInsets {
        var insets = orig._listViewDefaultContentInsets()
        insets.bottom = DLSManager.sharedInstance.dockHeight + localSettings.inset + 50
        return insets
    }
}

class CSQuickActionsView_Hook: ClassHook<CSQuickActionsView> {
    typealias Group = tweak

    func _insetY() -> CGFloat {
        return DLSManager.sharedInstance.dockHeight + (localSettings.inset * 2)
    }
}

class CSTeachableMomentsContainerView_Hook: ClassHook<CSTeachableMomentsContainerView> {
    typealias Group = tweak

    func didMoveToWindow() {
        target.removeFromSuperview()
    }
}

class SBUICallToActionLabel_Hook: ClassHook<SBUICallToActionLabel> {
    typealias Group = tweak

    func initWithFrame(_ frame: CGRect) -> Target? {
        return nil
    }
}

class CSHomeAffordanceView_Hook: ClassHook<CSHomeAffordanceView> {
    typealias Group = tweak

    func initWithFrame(_ frame: CGRect) -> Target? {
        return nil
    }
}

class CSPageControl_Hook: ClassHook<CSPageControl> {
    typealias Group = tweak

    func initWithFrame(_ frame: CGRect) -> Target? {
        return nil
    }
}

//MARK: - Preferences
func readPrefs() {
    
    let path = "/var/mobile/Library/Preferences/com.ginsu.dockls.plist"
    
    if !FileManager().fileExists(atPath: path) {
        try? FileManager().copyItem(atPath: "Library/PreferenceBundles/dockls.bundle/defaults.plist", toPath: path)
    }
    
    guard let dict = NSDictionary(contentsOfFile: path) else {
        return
    }
    
    //Reading values
    localSettings.isEnabled = dict.value(forKey: "isEnabled") as? Bool ?? true
    localSettings.showBG = dict.value(forKey: "showBG") as? Bool ?? true

}

struct DockLS: Tweak {
    init() {
        readPrefs()
        if (localSettings.isEnabled) {
            tweak().activate()
        }
    }
}
