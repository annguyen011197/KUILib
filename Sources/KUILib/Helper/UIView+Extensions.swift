//
//  UIView+Extensions.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import Foundation
import UIKit

public struct GradientBackground {
    public enum Orientation {
        case vertical, horizontal
    }
    
    public var colors: [UIColor]
    public var locations: [NSNumber]?
    public var orientation: Orientation
    
    public init(colors: [UIColor], locations: [NSNumber]? = nil, orientation: Orientation) {
        self.colors = colors
        self.locations = locations
        self.orientation = orientation
    }
}

extension UIView {
    
    public enum ViewSide {
        case top, right, bottom, left
    }
    
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    public func addBorder(edges: Set<ViewSide>, padding: CGFloat = 0, color: UIColor = .black, size: CGFloat = 1) {
        for edge in edges {
            switch edge {
            case .top:
                addBorderUtility(x: padding, y: 0, width: frame.width - padding * 2, height: size, color: color)
            default:
                break
            }
        }
    }
    
    @discardableResult
    public func makeGradient(value: GradientBackground) -> CAGradientLayer {
        return applyGradient(colours: value.colors, locations: value.locations).then { layer in
            if value.orientation == .horizontal {
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint(x: 1, y: 0.5)
            }
        }
    }

    public func clickAnimation(backgroundColor: UIColor = .lightGray) {
        let preBackground = self.backgroundColor
        self.backgroundColor = backgroundColor
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = preBackground
        }
    }

    private func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    public func addShadow(corner: CGFloat = 10, color: UIColor = .black, radius: CGFloat = 15, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.2) {
        layer.do {
            $0.shadowColor = color.cgColor
            $0.shadowOffset = offset
            $0.shadowRadius = radius
            $0.shadowOpacity = opacity
            $0.cornerRadius = 10
            $0.masksToBounds = false
            $0.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: corner).cgPath
        }

    }
}

//extension UITableViewCell {
//    public func addShadow(corner: CGFloat = 10, color: UIColor = .black, radius: CGFloat = 15, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.2) {
//        let cell = self
//        cell.contentView.layer.borderWidth = 0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//        cell.layer.shadowColor = color.cgColor
//        cell.layer.shadowOffset = offset
//        cell.layer.shadowRadius = radius
//        cell.layer.shadowOpacity = opacity
//        cell.layer.cornerRadius = 10
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//    }
//}
