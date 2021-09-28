//
//  YLThreeDotIndicator.swift
//  YLIndicatorViewHelper
//
//  Created by AlbertYuan on 2021/9/28.
//

import UIKit

public class YLThreeDotIndicator: UIView, YLIndicatorProtocol {

    typealias innerBlock = (() -> Void)?
    
    // MARK: -- 对外属性
    public var isShowing :Bool = false
    // MARK: -- 内部属性
    var container:UIView
    
    fileprivate var containerDotLayer:CALayer = CALayer()
    fileprivate var threeDotsArray:[CALayer] = []
    // MARK: -- animation
    fileprivate var rotateAnimation:CABasicAnimation = CABasicAnimation()
    fileprivate var glowAnimation = CAKeyframeAnimation()
    fileprivate var colorGlowAnimation = CAKeyframeAnimation()
    fileprivate var colorDotAnimation = CAKeyframeAnimation()
    fileprivate var groupAnimation = CAAnimationGroup()

    
    public init(inView: UIView, blur: Bool){
        container = inView

        super.init(frame: inView.bounds)

        //内部初始化
        commonInit()
        initBackgroundBlur(isBlur: blur)
        initThreeDot()
        initAniamtion()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//内部初始化
extension YLThreeDotIndicator{

//    公共部分
    func commonInit(){
        isShowing  = false
    }

//    背景
    func initBackgroundBlur(isBlur: Bool){
        if isBlur{
            //待处理
            backgroundColor = UIColor.clear
        }
    }

//   点层
    func initThreeDot(){

        containerDotLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        containerDotLayer.backgroundColor = UIColor.clear.cgColor
        containerDotLayer.position = self.center

        let size: Double = 20

        for i in 0 ..< 3 {
            //点
            let dot:CALayer = CALayer()
            switch i{
            case 0:
                dot.frame = CGRect(x: 15, y: 0, width: size, height: size)
            case 1:
                dot.frame = CGRect(x: 0, y: 29.5, width: size, height: size)
            case 2:
                dot.frame = CGRect(x: 30.5, y: 29.5, width: size, height: size)
            default :
                dot.frame = .zero
            }

            dot.backgroundColor = UIColor.gray.cgColor
            dot.cornerRadius = size / 2

            dot.shadowColor = UIColor.gray.cgColor
            dot.shadowOpacity = 1
            dot.shadowOffset = CGSize(width: 0, height: 0)
            dot.shadowRadius = 15

            containerDotLayer.addSublayer(dot)
            threeDotsArray.append(dot)
        }
        layer.addSublayer(containerDotLayer)
    }


//   动画处理
    func initAniamtion(){

        let duration = 1.5
        let keyTimes = [NSNumber(0),NSNumber(0.5), NSNumber(1.0)]
        let changeColor = [
            UIColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1).cgColor,
            UIColor(red: 0/255.0, green: 206/255.0, blue: 209/255.0, alpha: 1).cgColor,
            UIColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1).cgColor
        ]

        //旋转动画
        rotateAnimation.keyPath = "transform.rotation.z"
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = duration

        //修改阴影
        glowAnimation.keyPath = "shadowRadius"
        glowAnimation.keyTimes = keyTimes
        glowAnimation.values = [NSNumber(5.0),NSNumber(20.0), NSNumber(5.0)]
        glowAnimation.repeatCount = MAXFLOAT
        glowAnimation.duration = duration

//        //修改颜色
        colorGlowAnimation.keyPath = "shadowColor"
        colorGlowAnimation.keyTimes = keyTimes
        colorGlowAnimation.values = changeColor
        colorGlowAnimation.repeatCount = MAXFLOAT
        colorGlowAnimation.duration = duration

        colorDotAnimation.keyPath = "backgroundColor"
        colorDotAnimation.values = changeColor
        colorDotAnimation.keyTimes = keyTimes
        colorDotAnimation.repeatCount = MAXFLOAT
        colorDotAnimation.duration = duration


//        //动画组
        groupAnimation.duration = duration
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        groupAnimation.repeatCount = MAXFLOAT
        groupAnimation.animations = [glowAnimation,colorDotAnimation,colorGlowAnimation]
    }

}


// MARK: -- 对外方法 闭包方式
extension YLThreeDotIndicator{



    public func show(){

        if isShowing {
            return
        }
        isShowing = true
        containerDotLayer .add(rotateAnimation, forKey: nil)

        for dot in threeDotsArray {
            dot.add(groupAnimation, forKey: nil)
        }
        container.addSubview(self)
    }

    public func dismiss(){
        if !isShowing {
            return
        }
        
        for dot in threeDotsArray {
            dot.removeAllAnimations()
        }
        containerDotLayer.removeAllAnimations()
        self .removeFromSuperview()
    }


    // MARK: -- 闭包回调
    public func showWhileExecutingBlock(mission: (() -> Void)? ){
        showWhileExecutingBlock(mission: mission, completion: nil)
    }

    public func showWhileExecutingBlock(mission: (() -> Void)?, completion: (() -> Void)? ) {
        guard let task = mission else {
            return
        }
        show()

        DispatchQueue.global().async {
            task()
            //UIdate UI
            DispatchQueue.main.async {
                guard let complete = completion else {
                    return
                }
                complete()
                self.dismiss()
            }
        }
    }
}
