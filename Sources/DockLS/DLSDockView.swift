//
//  DLSDockView.swift
//  
//
//  Created by Noah Little on 26/6/2022.
//

import UIKit
import DockLSC

class DLSDockView: UIView {
    private var hStack: UIStackView!
    private var background: MTMaterialView!
    
    init(frame: CGRect, listView: SBDockIconListView) {
        super.init(frame: frame)
        
        if localSettings.showBG {
            background = MTMaterialView(recipe: 19, configuration: 1)
            background.translatesAutoresizingMaskIntoConstraints = false
            if !localSettings.isHomeButtoniPhone {
                background.clipsToBounds = true
                background.layer.cornerRadius = 30
            }
            addSubview(background)
            //Constraints
            background.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
            background.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
            background.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            background.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.alignment = .center
        hStack.axis = .horizontal
        hStack.spacing = listView.horizontalIconPadding
        hStack.distribution = .fillEqually
        
        let appList = listView.subviews.filter({$0 is SBIconView})
        
        for case let icon as SBIconView in appList {
            //App icon button setup
            let appButton = UIButton(type: .custom)
            appButton.frame = CGRect(x: 0, y: 0, width: icon.frame.width, height: icon.frame.height)
            appButton.translatesAutoresizingMaskIntoConstraints = false
            appButton.setImage(DLSManager.sharedInstance.iconFromBundleID(icon.applicationBundleIdentifierForShortcuts), for: .normal)
            appButton.imageView?.contentMode = .scaleAspectFit
            //Tap action
            appButton.addAction {
                DLSManager.sharedInstance.openApplication(withBundleID: icon.applicationBundleIdentifierForShortcuts)
            }
            //Constraints
            appButton.heightAnchor.constraint(equalToConstant: icon.frame.height).isActive = true
            appButton.widthAnchor.constraint(equalToConstant: icon.frame.width).isActive = true
            //Add to stack
            hStack.addArrangedSubview(appButton)
        }
        
        addSubview(hStack)
        //Constraints
        hStack.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        hStack.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -appList.first!.frame.width/2 - 5).isActive = true
        hStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
