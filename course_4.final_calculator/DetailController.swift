//
//  DetailController.swift
//  course_4.final_calculator
//
//  Created by 朱坤 on 10/17/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class DetailController: UIViewController, result_source {

    @IBOutlet weak var detail_view: coord!{
        didSet{
            detail_view.data_source = self
        }
    }
    
    var brain: CalculatorBrain? {
        didSet{
            detail_view?.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func get_result(x: Float) -> Float {
        if let br = brain {
            let result = br.evaluate_for_image(Double(x))
            return Float(result)
        }else{
            return Float(0)
        }
    }

}
