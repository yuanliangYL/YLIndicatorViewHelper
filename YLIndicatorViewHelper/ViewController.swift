//
//  ViewController.swift
//  YLIndicatorViewHelper
//
//  Created by AlbertYuan on 2021/9/28.
//

import UIKit

class ViewController: UIViewController {

    var threeDot:YLThreeDotIndicator!
    var hourglass:YLHourglassIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        hourGlass()

    }

    func hourGlass(){

        hourglass = YLHourglassIndicator(inView: view, blur: true)

        hourglass.showWhileExecutingBlock {
            sleep(10)
        } completion: {
            print("finish")
        }


    }

    func dot(){
        threeDot = YLThreeDotIndicator.init(inView: view, blur: true)
        threeDot.showWhileExecutingBlock {
            sleep(10)
        } completion: {
            print("finish")
        }
    }


}

