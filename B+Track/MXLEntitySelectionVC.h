//
//  mxlEntitySelectionTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLEntity.h"
#import "MXLTableViewController.h"

@class MXLEntitySelectionVC;


@interface MXLEntitySelectionVC : MXLTableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segSelection;

- (IBAction)segSelection_Changed:(id)sender;



@end

