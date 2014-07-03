//
//  MXLReportingRateViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLSession.h"
#import "MXLTableViewController.h"
#import "MXLDataRetriever.h"


@interface MXLKPIsVC : MXLTableViewController <MXLCurrentSessionRefreshedDelegate, MXLTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *mainNavigationItem;

- (IBAction)btnChangeWeek:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfFacilities;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilitiesReported;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilitiesNotReporting;
@property (weak, nonatomic) IBOutlet UILabel *lblReportingRate;
@property (weak, nonatomic) IBOutlet UILabel *lblLastRefreshed;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentReportingWeek;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentLevel;

@property (weak, nonatomic) IBOutlet UILabel *lblNoReportsReceived;


@end
