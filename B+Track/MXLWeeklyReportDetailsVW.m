//
//  MXLWeeklyReportDetailsVW.m
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeeklyReportDetailsVW.h"
#import "MXLWeeklyReport.h"
#import "MXLFacilityDetailsVC.h"
#import "mxlFacility.h"

@interface MXLWeeklyReportDetailsVW ()

@end

@implementation MXLWeeklyReportDetailsVW
MXLFacility* facility;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MXLWeeklyReport* report = (MXLWeeklyReport*) self.dataSource;
    self.lblANC1Visits.text = report.no_anc1_visits;
    self.lblWomenTested.text = report.no_tested_hiv;
    self.lblWomenTestedPositive.text = report.no_tested_pos;
    self.lblKnownPositive.text = report.no_atnd_known_status;
    self.lblMissedAppointments.text = report.no_missed_appointments;
    self.lblInitiated.text = report.no_initiated;
    self.lblARVStockout.text = [report.arv_stockout  isEqual: @"1"] ? @"Yes" : @"No";;
    self.lblTestkitStockout.text = [report.test_kit_stockout  isEqual: @"1"] ? @"Yes" : @"No";
    self.lblFacilityName.text = report.health_facility;
    self.lblDistrict.text = report.district;
    facility = [MXLFacility new];
    facility.health_facility = report.health_facility;
    facility.facility_level = report.facility_level;
    facility.district = report.district;
    facility.delivery_zone = report.delivery_zone;
    facility.art_accredited = report.art_accredited;
    facility.org_unit_group = report.org_unit_group;
    facility.subcounty = @"(unknown)";
    //facility.subcounty = report.su
}

/* prepareForSegue
 _____________________________________________________________________________________________________________________________ */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"FacilityDetails"])
    {
        // Get a reference to your custom view controller
        
        MXLFacilityDetailsVC *customViewController = (MXLFacilityDetailsVC *) [(UINavigationController*) segue.destinationViewController viewControllers][0];
        customViewController.facility = facility;
    }
}


@end
