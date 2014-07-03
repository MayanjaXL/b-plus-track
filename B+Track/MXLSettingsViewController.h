//
//  mxlProfileTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLEntitySelectionVC.h"
#import "MXLWeekSelectionVC.h"
#import "MXLSession.h"
#import "MXLTableViewController.h"

@interface MXLSettingsViewController : UITableViewController <MXLTableViewControllerDelegate,
    MXLCurrentSessionRefreshedDelegate>


@property (weak,nonatomic) IBOutlet UILabel *defaultLevelField;
@property (weak,nonatomic) IBOutlet UILabel *weekNo;
/*@property (weak,nonatomic) IBOutlet UITableViewCell* resetCache;*/
@property (weak, nonatomic) IBOutlet UITableViewCell *resetCache;
@property (weak, nonatomic) IBOutlet UITableViewCell *reloadCacheCell;
@property (weak, nonatomic) IBOutlet UINavigationItem *mainUINavigation2;

@property (weak, nonatomic) IBOutlet UITableViewCell *fetchBackgroundData;
- (IBAction)btnDone_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *chkRefreshAutomatically;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellBadgeStockout;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellBadgeReportingRate;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellNoBadge;

@end
