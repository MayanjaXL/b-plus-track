//
//  mxlProfileTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLEntitySelectionViewController.h"
#import "MXLWeekSelectionViewController.h"
#import "MXLSession.h"

@interface MXLProfileViewController : UITableViewController <MXLEntitySelectionViewControllerDelegate, MXLWeekSelectionViewControllerDelegate, MXLCurrentSessionRefreshedDelegate>


@property (weak,nonatomic) IBOutlet UILabel *defaultLevelField;
@property (weak,nonatomic) IBOutlet UILabel *weekNo;
/*@property (weak,nonatomic) IBOutlet UITableViewCell* resetCache;*/
@property (weak, nonatomic) IBOutlet UITableViewCell *resetCache;
@property (weak, nonatomic) IBOutlet UITableViewCell *reloadCacheCell;
@property (weak, nonatomic) IBOutlet UINavigationItem *mainUINavigation2;

@property (weak, nonatomic) IBOutlet UITableViewCell *fetchBackgroundData;

@end
