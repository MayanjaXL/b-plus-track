//
//  MXLWeek.swift
//  BPlus_Track
//
//  Created by Fitti Weissglas on 04/10/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

import Foundation

@objc
public class MXLWeek : NSObject {
    
    public var weekno: String;
    public var displayName: String;
    public var startDate: NSDate?;
    public var endDate: NSDate?;
    
    public init(weekNo: String, displayName: String) {
        self.weekno = weekNo;
        self.displayName = displayName;
    }
    
    
    public init(weekNo: String, startDate: NSDate, endDate: NSDate) {
        self.weekno = weekNo;
        self.startDate = startDate;
        self.endDate = endDate;
        self.displayName = NSString(format:"SWIFT! Week ending %@", endDate);
    }
}

