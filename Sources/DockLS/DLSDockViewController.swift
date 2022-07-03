//
//  DLSDockViewController.swift
//  
//
//  Created by Noah Little on 30/6/2022.
//

import UIKit
import DockLSC

class DLSDockViewController: SBFTouchPassThroughViewController {
    private var iconList: SBDockIconListView!
    
    convenience init(withIconList list: SBDockIconListView) {
        self.init(nibName: nil, bundle: nil, iconList: list)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, iconList list: SBDockIconListView) {
        super.init(nibName: nil, bundle: nil)
        iconList = list
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set proper height
        if iconList.iconLocation == "SBIconLocationFloatingDock" {
            DLSManager.sharedInstance.dockHeight = 116
        } else {
            if GSUtilities.sharedInstance().isDockSearchInstalled() {
                DLSManager.sharedInstance.dockHeight = DLSManager.sharedInstance.dockList.frame.height - 60
            } else {
                DLSManager.sharedInstance.dockHeight = DLSManager.sharedInstance.dockList.frame.height
            }
        }
        
        //Init and add dock
        DLSManager.sharedInstance.dock = DLSDockView(frame: CGRect.zero, listView: iconList)
        DLSManager.sharedInstance.dock.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(DLSManager.sharedInstance.dock)
        //Constraints
        DLSManager.sharedInstance.dock.heightAnchor.constraint(equalToConstant: DLSManager.sharedInstance.dockHeight).isActive = true
        DLSManager.sharedInstance.dock.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (localSettings.inset * 2)).isActive = true
        DLSManager.sharedInstance.dock.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let AndroBarHeight = GSUtilities.sharedInstance().isAndroBarInstalled() ? GSUtilities.sharedInstance().androBarHeight : 0.0
        DLSManager.sharedInstance.dock.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -localSettings.inset - AndroBarHeight).isActive = true
    }
    
    override func _canShowWhileLocked() -> Bool {
        return true
    }
    
}
