//
//  File.swift
//  
//
//  Created by An Nguyen on 23/01/2024.
//

import Foundation
import UIKit

public class GradientTextColor {
    private class func gradientColor(gradientLayer :CAGradientLayer) -> UIColor? {

          UIGraphicsBeginImageContext(gradientLayer.bounds.size)
          gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return UIColor(patternImage: image!)
    }


    public class func makeGradientColor(gradient: GradientBackground, for bounds: CGRect) -> UIColor? {
        let gradient: CAGradientLayer = gradient.buildLayer(size: bounds)
        return gradientColor(gradientLayer: gradient)
    }
}
