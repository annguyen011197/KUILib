//
//  UIView+Extensions.swift
//  
//
//  Created by An Nguyen on 24/12/2023.
//

import Foundation
import UIKit
import SnapKit

public struct GradientBackground {
    public enum Orientation {
        case vertical, horizontal, halfRadiant
    }
    
    public var colors: [UIColor]
    public var locations: [NSNumber]?
    public var orientation: Orientation
    
    public init(colors: [UIColor], locations: [NSNumber]? = nil, orientation: Orientation) {
        self.colors = colors
        self.locations = locations
        self.orientation = orientation
    }
    
    public func buildLayer(size: CGRect) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = size
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        switch orientation {
        case .vertical:
            break
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .halfRadiant:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.type = .radial
        }
        return gradient
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
        self.layer.sublayers?.filter({
            $0.name == "gradient_background"
        }).forEach({
            $0.removeFromSuperlayer()
        })
        let gradient: CAGradientLayer = value.buildLayer(size: self.bounds)
        gradient.name = "gradient_background"
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    public func clickAnimation(backgroundColor: UIColor = .lightGray) {
        let preBackground = self.backgroundColor
        self.backgroundColor = backgroundColor
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = preBackground
        }
    }
    
    public func clickEffectAnimation() {
        let group = CAAnimationGroup()
        group.animations = [pulsateEffect(), flashEffect()]
        group.duration = 0.2
        layer.add(group, forKey: "clickEffectAnimationGroup")
    }
    
    private func pulsateEffect() -> CABasicAnimation {
        return CASpringAnimation(keyPath: "transform.scale").then { pulse in
            pulse.duration = 0.4
            pulse.fromValue = 0.98
            pulse.toValue = 1.0
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
        }
    }
    
    private func flashEffect() -> CABasicAnimation {
        return CABasicAnimation(keyPath: "opacity").then { flash in
            flash.duration = 0.3
            flash.fromValue = 1
            flash.toValue = 0.1
            flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
    }
    
    public func pulsate() {
        layer.add(pulsateEffect(), forKey: nil)
    }
    
    public func flash() {
        layer.add(flashEffect(), forKey: nil)
    }
    
    private func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        self.layer.sublayers?.filter({
            $0.name == "gradient_background"
        }).forEach({
            $0.removeFromSuperlayer()
        })
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.name = "gradient_background"
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
    
    public func onTapListener(animation: Bool = true, _ closure: @escaping()->()) {
        isUserInteractionEnabled = true
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) {
                self.closure = closure
            }
            @objc func invoke() {
                closure()
            }
        }
        
        let sleeve = animation
        ?  ClosureSleeve({ [weak self] in
            guard let self = self else { return }
            self.clickEffectAnimation()
            closure()
        })
        :  ClosureSleeve(closure)
        addGestureRecognizer(
            UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        )
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    public func height(_ value: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(value)
        }
    }
    
    public func width(_ value: CGFloat) {
        self.snp.makeConstraints { make in
            make.width.equalTo(value)
        }
    }
    
    public static func imageBtn(image: UIImage? = nil) -> UIButton {
        return UIButton(type: .custom).then { btn in
            btn.setTitle("", for: .normal)
            btn.setImage(image, for: .normal)
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
