//
//  CalendarView.swift
//  Calendar
//
//  Created by PJTZ on 16/6/24.
//  Copyright © 2016年 PJTZ. All rights reserved.
//
// 日历面板

import UIKit
//MARK: - 定义一份协议
protocol CalendarDelegate{
    /**
     协议
     */
    func CalendarNavClickView(calendar:CalendarView,year:Int,month:Int)
}

class CalendarView: UIView {
    //外部调用的  代理和签到数据
    var delegate: CalendarDelegate?
    //签到的数据
    var SigninList = [Int](){
        didSet{
            for i in 0..<contentWrapperView.subviews.count{
                for j in 0..<SigninList.count{
                    if i == SigninList[j]{
                        let btn =  contentWrapperView.subviews[i] as! UIButton
                        logDate(btn)
                    }
                }
            }
        }
    }
    //-----------------------------------------星期标题的颜色----------------------------------------------------------
    var weekdayHeaderTextColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1) {                                //周一到周五的颜色
        didSet{
            for i in 0..<weekHeaderView.subviews.count{
                let label = weekHeaderView.subviews[i] as! UILabel
                label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            }
        }
    }
    var weekdayHeaderWeekendTextColor = UIColor(red: 0.75, green: 0.25, blue: 0.25, alpha: 1){                          //周六和周日的颜色
        didSet{
            for i in 0..<weekHeaderView.subviews.count{
                let label = weekHeaderView.subviews[i] as! UILabel
                label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            }
        }
    }
    //-----------------------------------------日历具体的颜色----------------------------------------------------------
    //月份字体的颜色
    var componentTextColor =  UIColor(red: CGFloat(110.0 / 255.0), green: CGFloat(110.0 / 255.0), blue: CGFloat(110.0 / 255.0), alpha: CGFloat(1.0)){
        didSet{
            for btn in contentWrapperView.subviews{
                let bt = btn as! UIButton
                bt.setTitleColor(componentTextColor, forState: .Normal)
            }
        }
    }
    //今日的背景色
    var todayIndicatorColor =  UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        {
        didSet{
            for btn in contentWrapperView.subviews{
                let bt = btn as! UIButton
                if bt.titleLabel?.text == "\(CalendarTool.Day(NSDate()))"{
                    bt.backgroundColor = todayIndicatorColor
                }
            }
        }
    }
    
    var highlightedComponentTextColor = UIColor.whiteColor()                                        //点击之后前景颜色
    var selectedIndicatorColor = UIColor(red: 0.74, green: 0.18, blue: 0.06, alpha: 1)              //点击的背景色
    
    //-----------------------------------------日历三大块----------------------------------------------------------
    private let navigationBar = UIView()                                                                       //主要标题栏
    private var textLabel = UILabel()                                                                          //标题栏文字
    private let weekHeaderView = UIView()                                                                     //星期标题栏
    private let contentWrapperView = UIView()                                                                 //日历内容栏
    private var Nowdate = NSDate()                                                                            //全局更改的时间
    //-----------------------------------------创建日历的方式-------------------------------------------------------
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /**
     布局三大控件
     */
    private func commonInit(){
        
        
        //添加导航栏
        navigationBar.frame = CGRectMake(0, 0, self.frame.width, 40)
        self.addSubview(navigationBar)
        CreateNavigationBar()
        
        
        //添加星期标题栏
        weekHeaderView.frame = CGRectMake(10, CGRectGetMaxY(navigationBar.frame), self.frame.width - 20, 20)
        self.addSubview(weekHeaderView)
        CreateWeekHeaderView()
        
        
        //添加日历内容栏
        contentWrapperView.frame = CGRectMake(10,CGRectGetMaxY(weekHeaderView.frame),self.frame.width - 20 ,self.frame.height - CGRectGetMaxY(weekHeaderView.frame))
        self.addSubview(contentWrapperView)
        CreatecontentWrapperView(Nowdate)
    }
}

//MARK:- 创建日历主要标题栏
extension CalendarView{
    /**
     创建主要标题栏
     */
    private func CreateNavigationBar(){
        let textLabel = UILabel()           //中间标题
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        textLabel.font = UIFont.systemFontOfSize(16)
        navigationBar.addSubview(textLabel)
        
        //布局
        self.addConstraint(NSLayoutConstraint(item: textLabel,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textLabel,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0))
        textLabel.text = "\(CalendarTool.Year(Nowdate))年\(CalendarTool.Month(Nowdate))月"
        self.textLabel = textLabel
        let prevBtn = UIButton(type: .Custom)   //左边按钮
        prevBtn.translatesAutoresizingMaskIntoConstraints = false
        prevBtn.tintColor = UIColor.grayColor()
        prevBtn.setBackgroundImage(UIImage(named: "prev")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        prevBtn.addTarget(self, action: Selector("prevButtonDidTap:"), forControlEvents: .TouchUpInside)
        navigationBar.addSubview(prevBtn)
        //布局
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant:16))
        
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant:30))
        
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant:30))
        
        
        let nextBtn = UIButton(type: .Custom)   //右边按钮
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.tintColor = UIColor.grayColor()
        nextBtn.setBackgroundImage(UIImage(named: "next")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        nextBtn.addTarget(self, action: Selector("nextButtonDidTap:"), forControlEvents: .TouchUpInside)
        navigationBar.addSubview(nextBtn)
        //布局
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: navigationBar,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant:-16))
        
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant:30))
        
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant:30))
    }
    
    /**
     左边按钮点击
     
     - parameter btn: 按钮
     */
    @objc private func prevButtonDidTap(btn:UIButton){
        for i in contentWrapperView.subviews{
            i.removeFromSuperview()
        }
        Nowdate = CalendarTool.UpMonth(Nowdate)
        
        if CalendarTool.Month(Nowdate) == 12{
            Nowdate = CalendarTool.UpYear(Nowdate)
        }
        
        CreatecontentWrapperView(Nowdate)           //添加月份
        textLabel.text = "\(CalendarTool.Year(Nowdate))年\(CalendarTool.Month(Nowdate))月"
        delegate?.CalendarNavClickView(self, year: CalendarTool.Year(Nowdate), month: CalendarTool.Month(Nowdate))
    }
    /**
     右边按钮点击
     
     - parameter btn: 按钮
     */
    @objc private func nextButtonDidTap(btn:UIButton){
        for i in contentWrapperView.subviews{
            i.removeFromSuperview()
        }
        Nowdate = CalendarTool.NextMonth(Nowdate)
        
        if CalendarTool.Month(Nowdate) == 1{
            Nowdate = CalendarTool.NextYear(Nowdate)
        }
        CreatecontentWrapperView(Nowdate)               //添加月份
        textLabel.text = "\(CalendarTool.Year(Nowdate))年\(CalendarTool.Month(Nowdate))月"
        delegate?.CalendarNavClickView(self, year: CalendarTool.Year(Nowdate), month: CalendarTool.Month(Nowdate))
    }
}
//MARK:- 创建日历星期标题栏
extension CalendarView{
    private func  CreateWeekHeaderView(){
        let array = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        let itemW = weekHeaderView.frame.width / 7
        
        for i in 0..<7{
            let x = itemW * CGFloat(i)
            let label = UILabel(frame: CGRectMake(x ,0,itemW,weekHeaderView.frame.height))
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            label.text = array[i]
            weekHeaderView.addSubview(label)
        }
    }
}
//MARK:- 创建日历内容栏
extension CalendarView{
    private func  CreatecontentWrapperView(date:NSDate){
        let wid :CGFloat = 5
        let itemWH = (contentWrapperView.frame.width - 8 * wid) / 7
        
        
        let UpMonthdays = CalendarTool.DaysInMonth( CalendarTool.UpMonth(date))        //上个月有多少天
        let monthDays = CalendarTool.DaysInMonth(date)        //这个月的总天数
        let Weekday    = CalendarTool.DayinWeek(date)          //第一天为周几
        var day = 0
        
        
        
        for i in 0..<42{
            let x  = CGFloat(i % 7) * itemWH
            let y  = CGFloat(i / 7) * itemWH
            let spacew = CGFloat(i % 7) * wid + wid
            
            let btn = UIButton(frame: CGRectMake(x + spacew,  y  ,itemWH ,itemWH))
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn.setTitleColor(componentTextColor, forState: .Normal)
            btn.layer.cornerRadius = itemWH / 2
            
            if (i < Weekday) {
                day = UpMonthdays - Weekday + i + 1
                btn.alpha = 0.2
            }else if (i > Weekday + monthDays - 1){
                day = i + 1 - Weekday - monthDays;
                btn.alpha = 0.2
            }else{
                day = i - Weekday + 1;
                btn.alpha = 1.0
                if day == CalendarTool.Day(date) && CalendarTool.Month(Nowdate) == CalendarTool.Month(NSDate()) && CalendarTool.Year(Nowdate) == CalendarTool.Year(NSDate()){
                    btn.backgroundColor = todayIndicatorColor
                }
                //按钮点击   签到到这里我是用不上的   所以这里并没有添加
                //                    btn.addTarget(self, action: Selector("logDate:"), forControlEvents: .TouchUpInside)
            }
            contentWrapperView.addSubview(btn)
            btn.setTitle("\(day)", forState: .Normal)
            
            
        }
    }
    
    @objc private func logDate(btn:UIButton){
        btn.selected = true
        btn.backgroundColor = btn.selected ?  selectedIndicatorColor : nil
        btn.setTitleColor(highlightedComponentTextColor, forState: .Selected)
    }
    
}




