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


    private func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
