//
//  MXLReportingRateViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLSession.h"


@interface MXLReportingRateViewController : UITableViewController <MXLCurrentSessionRefreshedDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *mainNavigationItem;

@end
