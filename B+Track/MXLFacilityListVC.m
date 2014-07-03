//
//  mxlFacilityReportingViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLFacilityListVC.h"
#import "MXLFacility.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "MXLFacilityDetailsVC.h"


@implementation MXLFacilityListVC

/*NSMutableArray* facilities;
NSMutableArray* searchResultFacilities;
NSMutableDictionary* districts;
NSMutableArray* sortedDistricts;
MXLFacility* selectedFacility;
NSArray* categories;*/



/* initWithCoder
 _____________________________________________________________________________________________________________________________ */

- (id) initWithCoder:(NSCoder *) coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        // Custom initialization
        //        NSLog([self class]);

    }
    return self;
}

/* viewDidLoad
 _____________________________________________________________________________________________________________________________ */

- (void)viewDidLoad {

    switch (self.facilitiesToShow) {
        case Entity: {
            self->observerName = @"facilities";
            self.navigationItem.title = @"Facilities";
            break;
        }
        case FacilitiesReported: {
            self->observerName = @"facilities_reported";
            self.navigationItem.title = @"Facilities that reported";
            break;
        }
        case FacilitiesNotReported: {
            self->observerName = @"facilities_not_reported";
            self.navigationItem.title = @"Facilities that did not report";
            break;
        }
        case NoARVS : {
            self->observerName = @"stock_outs";
            self.navigationItem.title = @"Facilities reporting no ARVs";
            break;
        }
        case NoTestkits : {
            self->observerName = @"stock_outs";
            self.navigationItem.title = @"Facilities reporting no testkits";
            break;
        }
    }
    
    self.detailSegueName = @"FacilityDetails";
    self.cellText = nil;
    self.cellText = @"health_facility";
    self.cellDetailText = @"district";
    self.categoryProperty = @"district";
    self.detailsDataSourceProperty = @"facility";
    self.lblNoDataMessage = self.lblNoFacilities;
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EntityCell"];
    [super viewDidLoad];
}




#pragma mark Data Loading

/* assignDataSource
 _____________________________________________________________________________________________________________________________ */

- (void) assignDataSource {
    
    switch (self.facilitiesToShow) {
        case Entity: {
            self.dataSource = [MXLSession currentSession].facilities;
            break;
        }
        case FacilitiesReported: {
            self.dataSource = [MXLSession currentSession].facilitiesReported;
            break;
        }
        case FacilitiesNotReported: {
            self.dataSource = [MXLSession currentSession].facilitiesNotReported;
            break;
        }
        case NoARVS: {
            self.dataSource = [MXLSession currentSession].facilitiesNoARVs;
            break;
        }
        case NoTestkits: {
            self.dataSource = [MXLSession currentSession].facilitiesNoTestkits;
            break;
        }
    }
    
    [super assignDataSource];
}

/* loadDataSource
 _____________________________________________________________________________________________________________________________ */

- (void) loadDataSource {
    
    switch (self.facilitiesToShow) {
        case Entity: {
            [[MXLSession currentSession] loadFacilities];
            break;
        }
        case FacilitiesReported: {
            [[MXLSession currentSession] loadFacilitiesReported];
            break;
        }
        case FacilitiesNotReported: {
            [[MXLSession currentSession] loadFacilitiesNotReported];
            break;
        }
        case NoARVS: {
            [[MXLSession currentSession] loadFacilitiesWithStockouts];
            break;
        }
        case NoTestkits: {
            [[MXLSession currentSession] loadFacilitiesWithStockouts];
            break;
        }
    }
    [super loadDataSource];
}


/* updateSearchResults
 _____________________________________________________________________________________________________________________________ */

- (void) updateSearchResultsForString:(NSString*) searchString {
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    for (MXLFacility *facility in self.dataSource)
	{
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange facilityNameRange = NSMakeRange(0, facility.health_facility.length);
        NSRange foundRange = [facility.health_facility rangeOfString:searchString options:searchOptions range:facilityNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:facility];
        }
    }
}



#pragma mark - Table view data source



@end
