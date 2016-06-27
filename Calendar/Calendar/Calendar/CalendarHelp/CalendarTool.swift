//
//  CalendarTool.swift
//  Calendar
//
//  Created by PJTZ on 16/6/24.
//  Copyright © 2016年 PJTZ. All rights reserved.
//
//获取日期类

import UIKit

public class CalendarTool: NSObject {
    /**
     返回年
     - parameter date: 数据
     - returns: 年
     */
    public class func Year(date:NSDate)->Int{
        let components = NSCalendar.currentCalendar().components(.Year, fromDate: date)
        return components.year
    }
    
    /**
     返回月
     - parameter date: 数据
     - returns: 月
     */
    public class func Month(date:NSDate)->Int{
        let components = NSCalendar.currentCalendar().components(.Month, fromDate: date)
        return components.month
    }
    
    /**
     返回日
     - parameter date: 数据
     - returns: 日
     */
    public class func Day(date:NSDate)->Int{
        let components = NSCalendar.currentCalendar().components(.Day, fromDate: date)
        return components.day
    }
    
    
    
    /**
     返回这个月的天数
     - parameter date:数据
     - returns: 天
     */
    public class func DaysInMonth(date:NSDate)->Int{
        let days = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        return days.length
    }
    
    /**
     获取上一个月
     - parameter date: 数据
     - returns: 上一月
     */
    public class func UpMonth(date:NSDate)->NSDate{
        let dateComponents = NSDateComponents()
        dateComponents.month  = -1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .WrapComponents)
        return newDate!
    }
    
    
    /**
     获取下一个月
     - parameter date: 数据
     - returns: 下一月
     */
    public class func NextMonth(date:NSDate)->NSDate{
        let dateComponents = NSDateComponents()
        dateComponents.month  = +1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .WrapComponents)
        return newDate!
    }
    
    /**
     获取上一个年
     - parameter date: 数据
     - returns: 上一年
     */
    public class func UpYear(date:NSDate)->NSDate{
        let dateComponents = NSDateComponents()
        dateComponents.year  = -1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .WrapComponents)
        return newDate!
    }
    /**
     获取下一个年
     - parameter date: 数据
     - returns: 下一年
     */
    public class func NextYear(date:NSDate)->NSDate{
        let dateComponents = NSDateComponents()
        dateComponents.year  = +1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: .WrapComponents)
        return newDate!
    }
    
    
    
    /**
     这个月的第一天是星期几
     - parameter date: 数据
     - returns: 周几
     */
    public class func DayinWeek(date:NSDate)->Int{

        let interval = date.timeIntervalSince1970;
        var days = Int(interval / 86400);
        days =  days - Day(date) + 1
        return (days - 3) % 7;
    }
    
    
    
    
    
    
    
}
