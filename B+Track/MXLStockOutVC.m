//
//  MXLStockOutVC.m
//  B+Track
//
//  Created by Fitti Weissglas on 16/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLStockOutVC.h"
#import "mxlAppDelegate.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "BPlus_Track-Swift.h"
#import "mxlEntity.h"
#import "MXLEntitySelectionVC.h"
#import "MXLWeekSelectionVC.h"
#import "MXLFacilityListVC.h"

@interface MXLStockOutVC ()

@end

@implementation MXLStockOutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Add the refresher
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self->observerName = @"kpis";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data Loading and Displaying

/* refresh
 _____________________________________________________________________________________________________________________________ */

- (void)refresh:(id)sender
{
    [MXLSession currentSession].forceKPIRefresh = true;
    [self launchLoadData];
}

/* launchLoadData
 _____________________________________________________________________________________________________________________________ */

- (void) launchLoadData {
    
    if (self->loadingData)
        return;
    
    [super launchLoadData];
    self->loadingData = true;
    
    // Data already loaded – no need to do anything
    if ([MXLSession currentSession].kpis != nil) {
        @synchronized (self) {
            [self displayData];
            [self.refreshControl endRefreshing];
        }
    }
    // Initiate a background load event, and see where it will go.
    else {
        //        [self startSpinner];
        if (!self.refreshControl.isRefreshing) {
            [self.refreshControl beginRefreshing];
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
        }
        
        // Initiate a week number load background
        
        [MXLDataRetriever.Queue addOperationWithBlock:^{
            [[MXLSession currentSession] loadWeekNumbers];
            //NSString* w = [MXLSession currentSession].currentWeek;
            [[MXLSession currentSession] loadKPIs];
        }];
    }
}

/* displayData
 _____________________________________________________________________________________________________________________________ */

- (void) displayData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    
    self.lblArvStockouts.text = [NSString stringWithFormat:@"%d", (int) [MXLSession currentSession].kpis.arvStockouts];
    self.lblTestKitStockouts.text = [NSString stringWithFormat:@"%d", (int) [MXLSession currentSession].kpis.testKitStockouts];

    int stockOuts = (int) [MXLSession currentSession].kpis.testKitStockouts + (int) [MXLSession currentSession].kpis.arvStockouts;
    if (stockOuts > 0) {
        UITabBarItem* stockOutTab = [self.navigationController.tabBarController.tabBar.items objectAtIndex:(1)];
        if (stockOutTab != nil)
            [stockOutTab setBadgeValue:[NSString stringWithFormat:@"%d", stockOuts]];
    }
}

/* dataLoadSuccessNotification
 _____________________________________________________________________________________________________________________________ */

- (void) dataLoadSuccessNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        [self.refreshControl endRefreshing];
        
        @synchronized (self) {
            [self displayData];
        }
    }];
    self->loadingData = false;
}

/* dataLoadFailNotification
 _____________________________________________________________________________________________________________________________ */

- (void) dataLoadFailNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        [self.refreshControl endRefreshing];
    }];
    self->loadingData = false;
}

/* viewWillAppear
 _____________________________________________________________________________________________________________________________ */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([MXLSession currentSession].kpiRefreshNeeded) {
        [MXLSession currentSession].forceKPIRefresh = true;
        [self launchLoadData];
    }
    
    if(self.refreshControl.isRefreshing) {
        CGPoint offset = self.tableView.contentOffset;
        [self.refreshControl endRefreshing];
        [self.refreshControl beginRefreshing];
        self.tableView.contentOffset = offset;
    }
}

/* prepareForSegue
 _____________________________________________________________________________________________________________________________ */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowFacilitiesNoTestkits"])  {
        MXLFacilityListVC *customViewController = (MXLFacilityListVC *) segue.destinationViewController;
        customViewController.facilitiesToShow = NoTestkits;
    }
    else if ([[segue identifier] isEqualToString:@"ShowFacilitiesNoARVs"]) {
        MXLFacilityListVC *customViewController = (MXLFacilityListVC *) segue.destinationViewController;
        customViewController.facilitiesToShow = NoARVS;
    }
}

@end
