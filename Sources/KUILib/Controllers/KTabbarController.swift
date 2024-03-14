//
//  KTabbarController.swift
//  
//
//  Created by An Nguyen on 23/12/2023.
//

import Foundation
import UIKit
import Then

open class SubTabWrapper {
    public let viewController: UIViewController
    open var name: String
    open var defaultIcon: UIImage
    open var selectedIcon: UIImage
    open var tag: Int
    
    public init(viewController: UIViewController, name: String, defaultIcon: UIImage, selectedIcon: UIImage, tag: Int) {
        self.viewController = viewController
        self.name = name
        self.defaultIcon = defaultIcon
        self.selectedIcon = selectedIcon
        self.tag = tag
    }
}


open class KTabbarController: UITabBarController {
    
    open var attribute: KTabbarAttribute = KTabbarAttribute()
    
    public private(set) var isTabbarHidden: Bool = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.addBorder(edges: [.top, .right], color: attribute.seperatorLine)
        tabBar.tintColor = .red
    }
    
    public func registerTabController(tabbarData: SubTabWrapper, animated: Bool = true) {
        let vc = tabbarData.viewController
        vc.tabBarItem =  UITabBarItem(title: tabbarData.name, image: tabbarData.defaultIcon, selectedImage: tabbarData.selectedIcon)
        vc.tabBarItem.tag = tabbarData.tag
        let newVCs = (viewControllers ?? []) + [vc]
        setViewControllers(newVCs, animated: animated)
    }
    
    public func registerTabControllers(tabbarData: [SubTabWrapper], animated: Bool = true) {
        let viewControllers = tabbarData.map {
            let vc = $0.viewController
            vc.tabBarItem = UITabBarItem(title: $0.name, image: $0.defaultIcon, selectedImage: $0.selectedIcon)
            return vc
        }
        
        setViewControllers(viewControllers, animated: animated)
    }
    
    public func updateTabBarItem(forIndex index: Int, name: String? = nil, defaultIcon: UIImage? = nil, selectedIcon: UIImage? = nil) {
        guard let vc = viewControllers?[safe: index] else { return }
        if let name = name {
            vc.tabBarItem.title = name
        }
        if let defaultIcon = defaultIcon {
            vc.tabBarItem.image = defaultIcon
        }
        if let selectedIcon = selectedIcon {
            vc.tabBarItem.selectedImage = selectedIcon
        }
    }
    
    public func showHideTabbar(isHidden: Bool, animate: Bool) {
        guard let vc = selectedViewController else { return }
        guard self.isTabbarHidden != isHidden else { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = isHidden ? height : -height
        var performShowHide = {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            self.selectedViewController?.view.frame = CGRect(
                x: 0,
                y: 0,
                width: vc.view.frame.width,
                height: vc.view.frame.height + offsetY
            )
            
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: performShowHide) { [weak self] _ in
                self?.isTabbarHidden = isHidden
            }
        } else {
            performShowHide()
            self.isTabbarHidden = isHidden
        }
    }
    
    public struct KTabbarAttribute {
        let seperatorLine: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.navigationItem.title = viewController.title
    }
    
}

extension KTabbarController: UITabBarControllerDelegate {
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
