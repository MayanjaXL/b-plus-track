//
//  MXLFacilityDetailsVC.m
//  B+Track
//
//  Created by Fitti Weissglas on 16/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLFacilityDetailsVC.h"
#import "mxlEntity.h"

@interface MXLFacilityDetailsVC ()

@end

@implementation MXLFacilityDetailsVC

/* initWithNibName
 _____________________________________________________________________________________________________________________________ */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* viewDidLoad
 _____________________________________________________________________________________________________________________________ */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.facility)
        self.facility = (MXLFacility*) self.dataSource;
    self.lblHealthFacility.text = self.facility.health_facility;
    self.lblIP.text = [MXLEntity prettifyForIP:self.facility.org_unit_group];
    self.lblDistrict.text = self.facility.district;
    self.lblSubcounty.text = self.facility.subcounty;
    self.lblARTAccredited.text = self.facility.art_accredited;
    self.lblWarehouse.text = self.facility.delivery_zone;
    self.lblLevel.text = self.facility.facility_level;
    self.uiHeader.title = self.facility.health_facility;
}




/* btnDone_Click
 _____________________________________________________________________________________________________________________________ */

- (IBAction)btnDone_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
