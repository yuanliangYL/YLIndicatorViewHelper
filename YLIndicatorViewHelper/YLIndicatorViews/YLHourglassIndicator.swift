//
//  YLHourglassIndicator.swift
//  YLIndicatorViewHelper
//
//  Created by AlbertYuan on 2021/9/28.
//

import UIKit

class YLHourglassIndicator: UIView, YLIndicatorProtocol  {

    typealias innerBlock = (() -> Void)?

    // MARK: -- 对外属性
    public var isShowing :Bool = false
    public var indicatorSize:CGSize = CGSize(width: 60, height: 80)
    //32,178,170
    public var indicatorColor = UIColor(red: 32/255.0, green: 178/255.0, blue: 170/255.0, alpha: 1)

    // MARK: -- 内部属性
    var container:UIView

    // MARK: -- 内部属性
    fileprivate var topLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var bottomLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var lineLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var containerLayer:CALayer = CALayer()

    // MARK: -- animation
    fileprivate var topAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
    fileprivate var bottomAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
    fileprivate var lineAnimation:CAKeyframeAnimation = CAKeyframeAnimation()
    fileprivate var containerAnimation:CAKeyframeAnimation = CAKeyframeAnimation()


    init(inView:UIView , blur: Bool){
        container = inView
        super.init(frame: inView.bounds)

        initCommon(isBlur: blur)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -- 初始化
extension YLHourglassIndicator{

    func initCommon(isBlur: Bool){
        isShowing = false

        backgroundColor = UIColor.clear

        if isBlur {
            //待处理
        }
        initContainer()
        initTop()
        initBottom()
        initLine()
        initAnimation()
        show()
    }

    func initContainer(){
        containerLayer.backgroundColor = UIColor.clear.cgColor
        containerLayer.frame = CGRect(x: 0, y: 0, width: indicatorSize.width, height: indicatorSize.height)
        containerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        containerLayer.position = self.center
        self.layer.addSublayer(containerLayer)
    }


    func initTop(){

        let triangle = UIBezierPath()
        triangle .move(to: CGPoint(x: 0, y: 0))
        triangle.addLine(to: CGPoint(x: indicatorSize.width, y: 0))
        triangle.addLine(to: CGPoint(x: indicatorSize.width/2, y: indicatorSize.height/2))
        triangle.addLine(to: CGPoint(x: 0, y: 0))
        triangle.close()

        topLayer.frame = CGRect(x: 0, y: 0, width: indicatorSize.width, height: indicatorSize.height/2)
        topLayer.path = triangle.cgPath
        topLayer.lineWidth = 0.0
        topLayer.fillColor = indicatorColor.cgColor
        topLayer.strokeColor = indicatorColor.cgColor

        //需要改变变化的锚点:核心 锚点与position的实际运用
        topLayer.anchorPoint = CGPoint(x: 0.5 , y: 1.0)
        topLayer.position = CGPoint(x: indicatorSize.width/2, y: indicatorSize.height/2)
        containerLayer.addSublayer(topLayer)
    }

    func initBottom(){

        let triangle = UIBezierPath()
        triangle .move(to: CGPoint(x: indicatorSize.width / 2, y: 0))
        triangle.addLine(to: CGPoint(x: indicatorSize.width, y: indicatorSize.height/2))
        triangle.addLine(to: CGPoint(x: 0, y: indicatorSize.height/2))
        triangle.addLine(to: CGPoint(x: indicatorSize.width / 2, y: 0))
        triangle.close()

        bottomLayer.frame = CGRect(x: 0, y: indicatorSize.height/2, width: indicatorSize.width, height: indicatorSize.height/2)
        bottomLayer.path = triangle.cgPath
        bottomLayer.lineWidth = 0.0
        bottomLayer.fillColor = indicatorColor.cgColor
        bottomLayer.strokeColor = indicatorColor.cgColor

        //需要改变变化的锚点:核心 锚点与position的实际运用
        bottomLayer.anchorPoint = CGPoint(x: 0.5 , y: 1.0)
        bottomLayer.position = CGPoint(x: indicatorSize.width/2, y: indicatorSize.height)
        containerLayer.addSublayer(bottomLayer)


    }

    func initLine(){

        let line = UIBezierPath()
        line .move(to: CGPoint(x: indicatorSize.width / 2, y: 0))
        line.addLine(to: CGPoint(x: indicatorSize.width / 2 , y: indicatorSize.height/2))

        lineLayer.frame = CGRect(x: 0, y: indicatorSize.height / 2, width: indicatorSize.width, height: indicatorSize.height/2)
        lineLayer.path = line.cgPath
        lineLayer.lineWidth = 1.0
        lineLayer.lineJoin = .miter
        lineLayer.strokeColor = indicatorColor.cgColor

        lineLayer.lineDashPhase = 3.0
        lineLayer.lineDashPattern = [NSNumber(1),NSNumber(1)]

        lineLayer.strokeEnd = 0.0
        containerLayer.addSublayer(lineLayer)



    }



    func initAnimation(){

        let duration = 2.0

        topAnimation.keyPath = "transform.scale"
        topAnimation.duration = duration
        topAnimation.repeatCount = MAXFLOAT
        topAnimation.keyTimes = [NSNumber(0.0),NSNumber(0.9),NSNumber(1.0)]
        topAnimation.values = [NSNumber(1.0),NSNumber(0.0),NSNumber(0.0)]


        bottomAnimation.keyPath = "transform.scale"
        bottomAnimation.duration = duration
        bottomAnimation.repeatCount = MAXFLOAT
        bottomAnimation.keyTimes = [NSNumber(0.0),NSNumber(0.9),NSNumber(1.0)]
        bottomAnimation.values = [NSNumber(0.0),NSNumber(1.0),NSNumber(1.0)]


        lineAnimation.keyPath = "strokeEnd"
        lineAnimation.duration = duration
        lineAnimation.repeatCount = MAXFLOAT
        lineAnimation.keyTimes = [NSNumber(0.0),NSNumber(0.1),NSNumber(0.9),NSNumber(1.0)]
        lineAnimation.values = [NSNumber(0.0),NSNumber(1.0),NSNumber(1.0),NSNumber(1.0)]


        containerAnimation.keyPath = "transform.rotation.z"
        containerAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 1, 0.8, 0)
        containerAnimation.duration = duration
        containerAnimation.repeatCount = MAXFLOAT
        containerAnimation.keyTimes = [NSNumber(0.7),NSNumber(1.0)]
        //选择180度，执行往后动画会重新开始开始
        containerAnimation.values = [NSNumber(0.0),NSNumber(value: Double.pi)]
    }

}

// MARK: -- 协议实现
extension YLHourglassIndicator{
    public func show(){

        if isShowing {
            return
        }
        isShowing = true

        topLayer.add(topAnimation, forKey: nil)
        bottomLayer.add(bottomAnimation, forKey: nil)
        lineLayer.add(lineAnimation, forKey: nil)
        containerLayer.add(containerAnimation, forKey: nil)

        container.addSubview(self)
    }

    public func dismiss(){
        if !isShowing {
            return
        }

        isShowing = false
        topLayer.removeAllAnimations()
        bottomLayer.removeAllAnimations()
        lineLayer.removeAllAnimations()
        containerLayer.removeAllAnimations()

        self.removeFromSuperview()

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
