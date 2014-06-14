//
//  mxlEntitySelectionTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLEntity.h"

@class MXLEntitySelectionViewController;
@protocol MXLEntitySelectionViewControllerDelegate <NSObject>

- (void)addItemViewController:(MXLEntitySelectionViewController *)controller didFinishEnteringItem:(MXLEntity *)item;

@end

@interface MXLEntitySelectionViewController : UITableViewController

@property (nonatomic, weak) id <MXLEntitySelectionViewControllerDelegate> delegate;


@end

