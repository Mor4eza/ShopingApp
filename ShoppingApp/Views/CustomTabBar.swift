    //
    //  CustomTabBar.swift
    //  ShoppingApp
    //
    //  Created by Morteza on 2/27/22.
    //

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = roundCornersPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor(named: "TabBackColor")?.cgColor
        shapeLayer.lineWidth = 0.5

        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        }else{
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor =  UIColor(named: "TabInactiveColor")
        self.tintColor = UIColor(named: "TabActiveColor")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 110
        return size
    }
    
    func roundCornersPath() -> CGPath {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 25.0)

        return path.cgPath
    }
}
