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

class CSMainPageContentViewController_Hook: ClassHook<CSMainPageContentViewController> {
    typealias Group = tweak
    
    @Property (.nonatomic, .retain) var dockController = DLSDockViewController(withIconList: DLSManager.sharedInstance.dockList)

    func viewDidLoad() {
        orig.viewDidLoad()
        
        dockController = DLSDockViewController(withIconList: DLSManager.sharedInstance.dockList)
        target.addChild(dockController)
        dockController.view.translatesAutoresizingMaskIntoConstraints = false
        target.view.addSubview(dockController.view)
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        
        target.view.bringSubviewToFront(dockController.view)
        //Constraints
        dockController.view.heightAnchor.constraint(equalTo: target.view.heightAnchor).isActive = true
        dockController.view.widthAnchor.constraint(equalTo: target.view.widthAnchor).isActive = true
        dockController.view.centerXAnchor.constraint(equalTo: target.view.centerXAnchor).isActive = true
        dockController.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor).isActive = true
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
        let AndroBarHeight = (GSUtilities.sharedInstance().isAndroBarInstalled() && UIScreen.main.bounds.height > UIScreen.main.bounds.width) ? GSUtilities.sharedInstance().androBarHeight : 0.0
        return DLSManager.sharedInstance.dockHeight + (localSettings.inset * 2) + AndroBarHeight
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
