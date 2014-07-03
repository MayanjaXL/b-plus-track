//
//  MXLWeeklyReportListVC.m
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeeklyReportListVC.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "MXLWeeklyReport.h"

@interface MXLWeeklyReportListVC ()

@end

@implementation MXLWeeklyReportListVC

/* initWithCoder
 _____________________________________________________________________________________________________________________________ */

- (id) initWithCoder:(NSCoder *) coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        // Custom initialization

    }
    return self;
}



/* viewDidLoad
 _____________________________________________________________________________________________________________________________ */

- (void)viewDidLoad {
    self->observerName = @"weekly_reports";
    self.detailSegueName = @"ShowWeeklyReportDetails";
    self.cellText = nil;
    self.cellText = @"health_facility";
    self.cellDetailText = @"district";
    self.categoryProperty = @"district";
    self.lblNoDataMessage = self.lblNoData;
    self.navigationItem.title = @"Weekly reports";
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EntityCell"];
    //    self.searchDisplayController.delegate = self;
    [super viewDidLoad];
}

/* viewWillAppear
 _____________________________________________________________________________________________________________________________ */

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark Overridden

/* launchLoadData depcrated
 _____________________________________________________________________________________________________________________________ */
/*
- (void) launchLoadData {
    
    [super launchLoadData];
    // Data already loaded – no need to do anything
    if ([MXLSession currentSession].weeklyReports != nil) {
        @synchronized (self) {
            [self assignDataSource];
            [self.tableView reloadData];
        }
    }
    // Initiate a background load event, and see where it will go.
    else {
        [self startSpinner];
        [MXLDataRetriever.Queue addOperationWithBlock:^{
            [[MXLSession currentSession] loadWeeklyReports];
        }];
    }
}*/
   
/* assignDataSource
 _____________________________________________________________________________________________________________________________ */

- (void) assignDataSource {

    self.dataSource = [MXLSession currentSession].weeklyReports;
    [super assignDataSource];
}

/* loadDataSource
 _____________________________________________________________________________________________________________________________ */

- (void) loadDataSource {
    
    [[MXLSession currentSession] loadWeeklyReports];
    [super loadDataSource];
}

/* updateSearchResults
 _____________________________________________________________________________________________________________________________ */

- (void) updateSearchResultsForString:(NSString*) searchString {
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    for (MXLWeeklyReport *report in self.dataSource)
	{
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange facilityNameRange = NSMakeRange(0, report.health_facility.length);
        NSRange foundRange = [report.health_facility rangeOfString:searchString options:searchOptions range:facilityNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:report];
        }
    }
}



/* cellForRowAtIndexPath [MAY OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntityCell"  forIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EntityCell"];
    
    MXLWeeklyReport* report;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        report = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        report = (MXLWeeklyReport*) [self getSelectedEntityForIndexPath:indexPath tableView:tableView];
    }
    
    cell.textLabel.text = report.health_facility;
    cell.detailTextLabel.text = report.district;
    if ([report.arv_stockout isEqualToString:@"1"] | [report.test_kit_stockout isEqualToString:@"1"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Stockout – %@", report.district];
        [cell.detailTextLabel setTextColor:[UIColor redColor]];
    }
    else {
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    }
    return cell;
}




@end



