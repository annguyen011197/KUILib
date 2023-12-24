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
    
    public init(viewController: UIViewController, name: String, defaultIcon: UIImage, selectedIcon: UIImage) {
        self.viewController = viewController
        self.name = name
        self.defaultIcon = defaultIcon
        self.selectedIcon = selectedIcon
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
    
//    public func updateTabBarItem(key: String, name: String? = nil, defaultIcon: UIImage? = nil, selectedIcon: UIImage? = nil) {
//        guard let vc = viewControllers?.compactMap({
//            $0 as? UIViewController & KTabChildKey
//        }).first(where: {
//            $0.key == key
//        }) else { return }
//        if let name = name {
//            vc.tabBarItem.title = name
//        }
//        if let defaultIcon = defaultIcon {
//            vc.tabBarItem.image = defaultIcon
//        }
//        if let selectedIcon = selectedIcon {
//            vc.tabBarItem.selectedImage = selectedIcon
//        }
//    }
    
//    open override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
//        let newDict = viewControllers?.compactMap({
//            $0 as? UIViewController & KTabChildKey
//        }).reduce([String: (UIViewController & KTabChildKey)](), { partialResult, vc in
//            var dict = partialResult
//            dict[vc.key] = vc
//            return dict
//        }) ?? [:]
//        keyValueViewControllers = newDict
//        super.setViewControllers(Array(keyValueViewControllers.values), animated: animated)
//    }
    
    public struct KTabbarAttribute {
        let seperatorLine: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}

extension KTabbarController: UITabBarControllerDelegate {
    
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
