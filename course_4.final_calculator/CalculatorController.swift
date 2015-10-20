//
//  ViewController.swift
//  course_4.final_calculator
//
//  Created by 朱坤 on 10/11/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController{
    
    @IBOutlet weak var process: UILabel!
    let brain = CalculatorBrain()
    var is_middle_type = false
    var result_value: Double{
        set{
            result_label.text = "\(newValue)"
        }
        get{
            return NSNumberFormatter().numberFromString(result_label.text!)!.doubleValue
        }
    }

    @IBOutlet weak var result_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressNumber(sender: UIButton) {
        print(brain.operations)
        let text = sender.currentTitle!
        if (text == "." && result_label.text!.rangeOfString(".") != nil) { return }
        if is_middle_type {
            result_label.text! = result_label.text! + text
        } else {
            is_middle_type = true
            result_label.text! = text
        }
    }
    
    @IBAction func pressConstant(sender: UIButton) {
        let text = sender.currentTitle!
        result_label.text! = text
        is_middle_type = false
    }

    @IBAction func pressOperation(sender: UIButton) {
        print(brain.operations)
        let sym = sender.currentTitle!
        enter()
        let callback = brain.addOperation(sym)
        if callback.run { result_value = callback.result }
        process.text = callback.desc + "="
    }
    
    @IBAction func equal(sender: UIButton) {
        enter()
        evaluate()
        if !brain.has_m() { brain.clear() }
    }
    
    @IBAction func clear() {
        brain.clear()
        is_middle_type = false
        result_value = 0
        process.text! = ""
    }
    
    @IBAction func enterM(sender: UIButton) {
        brain.enterM(result_label.text!)
        result_value = brain.evaluate()
        is_middle_type = false
    }
    
    func enter(){
        brain.addNumber(result_label.text!)
        is_middle_type = false
    }
    
    func evaluate(){
        process.text! = brain.process + "="
        result_value = brain.evaluate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let contro = segue.destinationViewController as? DetailController{
            if let identify = segue.identifier{
                switch identify{
                case "show_image":
                    contro.brain = self.brain
                default: break
                }
            }
        }
    }
}

