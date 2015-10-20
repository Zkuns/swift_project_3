//
//  coord.swift
//  course_4.final_calculator
//
//  Created by 朱坤 on 10/17/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

protocol result_source{
    func get_result(x: Float) -> Float
}
import UIKit

class coord: UIView {
    var data_source: result_source?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var drawcenter: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    var size: CGFloat = 50{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: drawcenter, pointsPerUnit: size)
        let path = UIBezierPath()
        UIColor.blueColor().set()
        path.lineWidth = 1.0
        path.moveToPoint(CGPoint(x: CGFloat(0), y: drawcenter.y))
        for(var x: CGFloat = 0.0; x < bounds.size.width; x += (1.0/contentScaleFactor)) {
            path.addLineToPoint(conver_to_point(x))
        }
        path.stroke()
    }
    
    private func conver_to_point(x: CGFloat) -> CGPoint{
        let coo_x = conver_x_to_coo(x)
        if let data = data_source{
            let coo_y = data.get_result(coo_x)
            return CGPoint(x: conver_x_to_real(coo_x), y: conver_y_to_real(coo_y))
        }else{
            return CGPoint(x: CGFloat(0), y: drawcenter.y)
        }
    }
    
    private func conver_x_to_coo(x: CGFloat) -> Float{
        return Float((x - drawcenter.x)/size)
    }
    
    private func conver_x_to_real(x: Float) -> CGFloat{
        return CGFloat(x)*size + drawcenter.x
    }
    
    private func conver_y_to_real(y: Float) -> CGFloat{
        return drawcenter.y + CGFloat(-y)*size
    }
}
