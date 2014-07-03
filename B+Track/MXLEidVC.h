//
//  MXLEidVC.h
//  B+Track
//
//  Created by Fitti Weissglas on 18/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"

@interface MXLEidVC : MXLTableViewController
@property (weak, nonatomic) IBOutlet UILabel *lblEIDMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfTests;
@property (weak, nonatomic) IBOutlet UILabel *lblNoPositive;
@property (weak, nonatomic) IBOutlet UILabel *lnlPropPositive;
@property (weak, nonatomic) IBOutlet UILabel *lblNoFacilityReports;

@property (weak, nonatomic) IBOutlet UILabel *lblEIDDate;
@end
