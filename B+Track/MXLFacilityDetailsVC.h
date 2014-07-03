//
//  MXLFacilityDetailsVC.h
//  B+Track
//
//  Created by Fitti Weissglas on 16/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"
#import "mxlFacility.h"
#import "MXLDetailTableViewController.h"

@interface MXLFacilityDetailsVC : MXLDetailTableViewController

@property MXLFacility* facility;
@property (weak, nonatomic) IBOutlet UILabel *lblDistrict;

@property (weak, nonatomic) IBOutlet UILabel *lblHealthFacility;

@property (weak, nonatomic) IBOutlet UILabel *lblSubcounty;

@property (weak, nonatomic) IBOutlet UILabel *lblWarehouse;
@property (weak, nonatomic) IBOutlet UINavigationItem *uiHeader;

@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblARTAccredited;

- (IBAction)btnDone_Click:(id)sender;
@end
