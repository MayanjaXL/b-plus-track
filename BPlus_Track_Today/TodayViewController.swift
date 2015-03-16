//
//  TodayViewController.swift
//  BPlus_Track_Today
//
//  Created by Fitti Weissglas on 04/10/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

import UIKit
import NotificationCenter
//import BPlus_Track_Lib



class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lblWeekNo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        updateData();
        completionHandler(NCUpdateResult.NewData)
    }
    
/*    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }*/
    
    func updateData() {
        //var session = MXLSession.currentSession();
        //lblWeekNo.text = session.currentWeek;
        
        //var dataRetriever = MXLDataRetriever();
        //        var week = MXLWeek.initialize();
        //var k = MXLKPIs.initialize();
        //var week = MXLWeek(weekNo: "W120", displayName: "DD");
        
        
        
        
    }
    
}
