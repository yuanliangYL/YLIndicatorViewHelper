//
//  YLIndicatorProtocol.swift
//  YLIndicatorViewHelper
//
//  Created by AlbertYuan on 2021/9/28.
//

import Foundation
import UIKit

//显示与任务协议
protocol YLIndicatorProtocol{

//    属性要求
    var isShowing :Bool{ get set}
    var container :UIView{ get set}

//    方法要求
    func show()

    func dismiss()

    func showWhileExecutingBlock(mission: (() -> Void)? )

    func showWhileExecutingBlock(mission: (() -> Void)? , completion: (() -> Void)? )

}
