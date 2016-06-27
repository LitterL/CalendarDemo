//
//  ViewController.swift
//  Calendar
//
//  Created by PJTZ on 16/6/24.
//  Copyright © 2016年 PJTZ. All rights reserved.
//

import UIKit

var signinList = [10,11,12,13]          //默认签到的坐标
class ViewController: UIViewController {
    
    //日历面板
    @IBOutlet weak var calendar: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calendar.delegate = self        //实现代理
        
        
//        calendar.weekdayHeaderTextColor = UIColor.redColor()            //周一到周五的颜色
//        calendar.weekdayHeaderWeekendTextColor = UIColor.blueColor()    //周六和周日的颜色
//        calendar.componentTextColor = UIColor.redColor()                //月份字体的颜色
//        calendar.todayIndicatorColor = UIColor.yellowColor()            //今日的背景色
//        calendar.highlightedComponentTextColor                          //点击之后前景颜色
//        calendar.selectedIndicatorColor = UIColor.orangeColor()         //点击的背景色
        
//        calendar.SigninList = signinList            //默认签到的坐标
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SigninClick(sender: AnyObject) {
//        CalendarTool.Day(NSDate())          今天是多少日
//        CalendarTool.DayinWeek(NSDate())    这个月第一天是周几
    
        let today = CalendarTool.Day(NSDate()) + CalendarTool.DayinWeek(NSDate()) - 1   //今天的坐标
        signinList.append(today)
        calendar.SigninList = signinList
        
    }
    
}


// MARK: - CalendarDelegate
extension UIViewController:CalendarDelegate{
    /**
     点击上月下月所执行的代理方法
     
     - parameter calendar: calendar
     - parameter year:     年
     - parameter month:    月
     */
    func CalendarNavClickView(calendar: CalendarView, year: Int, month: Int) {
        
        calendar.SigninList = signinList
    }
}
