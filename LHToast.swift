//
//  LHToast.swift
//  BasicFrame
//
//  Created by rp.wang on 2019/3/5.
//  Copyright © 2019 Roan.L. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

//Toast默认停留时间
public let ToastDispalyDuration:CGFloat = 1.2
//Toast背景颜色
public let ToastBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)




class LHToast: NSObject {
    
    var window: UIWindow?
    var _duration: CGFloat = 0.0
    var _contentView: UIButton?
    
    //创建一个通知中心
    let notifacationName:String = "NameCustom";
    
    deinit {    //dealloc?!
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: 中间显示-----------------------------------------------------
    /**
     *  中间显示
     *  @param text 内容
     */
    class func showCenterWithText(text: String){
        self.showCenterWithTextAndDuration(text: text, duration: ToastDispalyDuration)
    }
    
    /**
     *  中间显示
     *  @param text 内容 duration 显示时长
     */
    class func showCenterWithTextAndDuration(text: String , duration: CGFloat) {
        let toast = LHToast.init(text: text)
        toast.setDuration(duration: duration)
        toast.show()
    }
    
    // MARK: 上方显示-----------------------------------------------------
    /**
     *  上方显示
     *  @param text 内容
     */
    class func showTopWithText(text: String) {
        self.showTopWithTextAndDurationAndTopOffset(text: text, duration: ToastDispalyDuration, topOffset: 100.0)
    }
    /**
     *  上方显示+自定义停留时间
     *  @param text 内容  duration 停留时间
     */
    class func showTopWithTextAndDuration(text: String, duration: CGFloat) {
        self.showTopWithTextAndDurationAndTopOffset(text: text, duration: duration, topOffset: 100.0)
    }
    
    /**
     *  上方显示+自定义距顶端距离
     *  @param text 内容 topOffset 到顶端距离
     */
    class func showTopWithTextAndTopOffset(text: String, topOffset:CGFloat) {
        self.showTopWithTextAndDurationAndTopOffset(text: text, duration: topOffset, topOffset: ToastDispalyDuration)
    }
    
    /**
     *  上方显示+自定义距顶端距离+自定义停留时间
     *  @param text 内容  topOffset 到顶端距离 duration 停留时间
     */
    class func showTopWithTextAndDurationAndTopOffset(text: String, duration:CGFloat, topOffset:CGFloat) {
        let toast = LHToast.init(text: text)
        toast.setDuration(duration: duration)
        toast.showFromTopOffset(top: topOffset)
    }
    
    // MARK: 下方显示-----------------------------------------------------
    /**
     *  下方显示
     *  @param text 内容
     */
    class func showBottomWithText (text: String) {
        self.showBottomWithTextAndDurationAndBottomOffset(text: text, duration: ToastDispalyDuration, bottomOffset: 100.0)
    }
    /**
     *  下方显示+自定义停留时间
     *  @param text  内容  @param duration 停留时间
     */
    class func showBottomWithTextAndDuration(text: String, duration: CGFloat) {
        self.showBottomWithTextAndDurationAndBottomOffset(text: text, duration: duration, bottomOffset: 100.0)
    }
    /**
     *  下方显示+自定义距底端距离
     *  @param text  内容  @param bottomOffset 距底端距离
     */
    class func showBottomWithTextAndBottomOffset(text: String, bottomOffset: CGFloat) {
        self.showBottomWithTextAndDurationAndBottomOffset(text: text, duration: ToastDispalyDuration, bottomOffset: 100.0)
    }
    /**
     *  下方显示+自定义距底端距离+自定义停留时间
     *  @param text  内容  @param bottomOffset 距底端距离  @param duration 停留时间
     */
    class func showBottomWithTextAndDurationAndBottomOffset(text: String, duration: CGFloat, bottomOffset: CGFloat) {
        let toast = LHToast.init(text: text)
        toast.setDuration(duration: duration)
        toast.showFromBottomOffset(bottom: bottomOffset)
    }
    
    // MARK: 显示、消失
    private func show () {  //中部
        window = UIApplication.shared.keyWindow
        _contentView?.center = CGPoint(x: window?.center.x ?? 1, y: window?.center.y ?? 1)
        window?.addSubview(_contentView!)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: NSNull(), afterDelay: TimeInterval(ToastDispalyDuration))
    }
    
    private func showFromTopOffset(top: CGFloat) {
        window = UIApplication.shared.keyWindow
        _contentView?.center = CGPoint(x: window?.center.x ?? 1, y: top + (_contentView?.frame.size.height ?? 1) / 2)
        window?.addSubview(_contentView!)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: NSNull(), afterDelay: TimeInterval(_duration))
    }
    
    private func showFromBottomOffset(bottom: CGFloat) {
        window = UIApplication.shared.keyWindow
        _contentView?.center = CGPoint(x: window?.center.x ?? 1, y: (window?.frame.size.height ?? 1) - (bottom + (_contentView?.frame.size.height ?? 1) / 2))
        window?.addSubview(_contentView!)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: NSNull(), afterDelay: TimeInterval(_duration))
    }
    
    @objc private func dismissToast() {
        _contentView?.removeFromSuperview()
    }
    
    
    // MARK: 初始化
    init(text:String) {
        super.init()
        print()
        let attriStr = NSMutableAttributedString.init(string: text)
        attriStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange.init(location: 0, length: text.count))
        let textHeight = attriStr.boundingRect(with: CGSize(width: 250, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        let textWidth = attriStr.boundingRect(with: CGSize(width: 250, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width
        
        let textLabel: UILabel = UILabel()
        textLabel.frame = CGRect(x: 0, y: 0, width: textWidth + 40, height: textHeight + 10)
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.text = text
        textLabel.numberOfLines = 0;
        
        _contentView = UIButton(type: .custom)
        _contentView?.frame = CGRect(x: 0, y: 0, width: textLabel.frame.size.width, height: textLabel.frame.size.height)
        _contentView?.layer.cornerRadius = 10.0
        _contentView?.backgroundColor = ToastBackgroundColor
        _contentView?.addSubview(textLabel)
        _contentView?.autoresizingMask = .flexibleWidth
        _contentView?.addTarget(self, action: #selector(toastTaped), for: .touchUpInside)
        _contentView?.alpha = 0.0
        
        _duration = ToastDispalyDuration
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChanged), name:NSNotification.Name(rawValue: notifacationName) , object: UIDevice.current);
    }
    
    // MARK: 动画相关
    private func showAnimation() {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(0.3)
        _contentView?.alpha = 1.0
        UIView.commitAnimations()
    }
    
    @objc private func hideAnimation() {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismissToast))
        UIView.setAnimationDuration(0.3)
        _contentView?.alpha = 0.0
        UIView.commitAnimations()
    }
    
    // MARK: getter
    func setDuration(duration : CGFloat) {
        _duration = duration
    }

    
    // MARK: 相关事件
    //按钮点击事件
    @objc func toastTaped(sender: UIButton) {
        self.hideAnimation()
    }
    //通知事件
    @objc func deviceOrientationDidChanged(notification:NSNotification)->Void {
        self.hideAnimation()
    }
    
}
