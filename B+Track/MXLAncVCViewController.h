//
//  MXLAncVCViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 16/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"

@interface MXLAncVCViewController : MXLTableViewController
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfANC1Visits;
@property (weak, nonatomic) IBOutlet UILabel *lnlNoTestedForHIV;
@property (weak, nonatomic) IBOutlet UILabel *lblNoTestedPositiveForHIV;
@property (weak, nonatomic) IBOutlet UILabel *lnlNoInitiatedART;
@property (weak, nonatomic) IBOutlet UILabel *lblPropTested;
@property (weak, nonatomic) IBOutlet UILabel *lblPropInitiated;

@end
