//
//  MXLWeeklyReportDetailsVW.h
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"
#import "MXLDetailTableViewController.h"

@interface MXLWeeklyReportDetailsVW : MXLDetailTableViewController

@property (weak, nonatomic) IBOutlet UILabel *lblANC1Visits;
@property (weak, nonatomic) IBOutlet UILabel *lblWomenTested;
@property (weak, nonatomic) IBOutlet UILabel *lblWomenTestedPositive;
@property (weak, nonatomic) IBOutlet UILabel *lblKnownPositive;
@property (weak, nonatomic) IBOutlet UILabel *lblInitiated;
@property (weak, nonatomic) IBOutlet UILabel *lblAlreadyOnART;
@property (weak, nonatomic) IBOutlet UILabel *lblARVStockout;
@property (weak, nonatomic) IBOutlet UILabel *lblTestkitStockout;
@property (weak, nonatomic) IBOutlet UILabel *lblMissedAppointments;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilityName;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilityLevel;

@property (weak, nonatomic) IBOutlet UILabel *lblDistrict;

@end
