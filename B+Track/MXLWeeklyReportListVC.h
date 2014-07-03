//
//  MXLWeeklyReportListVC.h
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"
#import "MXListTableViewController.h"

@interface MXLWeeklyReportListVC : MXListTableViewController
    <UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

 
@end
