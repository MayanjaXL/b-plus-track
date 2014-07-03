//
//  mxlFacilityReportingViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLTableViewController.h"
#import "MXListTableViewController.h"

typedef enum F {
    Entity,
    FacilitiesReported,
    FacilitiesNotReported,
    NoARVS,
    NoTestkits
    
} FacilitiesToShow;

@interface MXLFacilityListVC : MXListTableViewController
<UISearchDisplayDelegate, UISearchBarDelegate>


@property FacilitiesToShow facilitiesToShow;
@property (weak, nonatomic) IBOutlet UINavigationItem *uiHeader;


//- (void) createCategories;
//@property (weak, nonatomic) IBOutlet UISearchBar *txtSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblNoFacilities;

@end
