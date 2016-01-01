//
//  DrawingView.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/31/15.
//  Copyright © 2015 USF. All rights reserved.
//

import UIKit

@IBDesignable
class DrawingView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 10
    
    var axesCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer()
        drawer.drawAxesInRect(bounds, origin: axesCenter, pointsPerUnit: scale)
    }

}
