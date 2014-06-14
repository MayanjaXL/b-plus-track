//
//  MXLWeekSelectionViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLWeek.h"

@class MXLWeekSelectionViewController;
@protocol MXLWeekSelectionViewControllerDelegate <NSObject>

- (void)addItemViewController:(MXLWeekSelectionViewController *)controller didFinishSelectingWeek:(MXLWeek *)item;

@end


@interface MXLWeekSelectionViewController : UITableViewController


@property (nonatomic, weak) id <MXLWeekSelectionViewControllerDelegate> delegate;

@end
