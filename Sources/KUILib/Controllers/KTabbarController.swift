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

//public protocol KTabChildKey {
//    var key: String { get }
//}

open class KTabbarController: UITabBarController {
    
    open var attribute: KTabbarAttribute = KTabbarAttribute()
    
//    open var keyValueViewControllers: [String: (UIViewController & KTabChildKey)] = [:]
    
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
    
    public struct KTabbarAttribute {
        let seperatorLine: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}

extension KTabbarController: UITabBarControllerDelegate {
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
