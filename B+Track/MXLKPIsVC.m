//
//  MXLReportingRateViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLKPIsVC.h"
#import "mxlAppDelegate.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "BPlus_Track-Swift.h"
#import "mxlEntity.h"
#import "MXLEntitySelectionVC.h"
#import "MXLWeekSelectionVC.h"
#import "MXLFacilityListVC.h"

@interface MXLKPIsVC ()

@end

@implementation MXLKPIsVC

/* initWithStyle
 _____________________________________________________________________________________________________________________________ */

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}


/* viewDidLoad
 _____________________________________________________________________________________________________________________________ */

- (void)viewDidLoad
{
    // Add the refresher
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self->observerName = @"kpis";
    [super viewDidLoad];
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
        if (!self.refreshControl.isRefreshing) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
        }
        
       // Initiate a week number load background
        [MXLDataRetriever.Queue addOperationWithBlock:^{
            [[MXLSession currentSession] loadBunch];
        }];
    }
}


/* refresh
 _____________________________________________________________________________________________________________________________ */

- (void)refresh:(id)sender
{
    [MXLSession currentSession].forceKPIRefresh = true;
    [self launchLoadData];
}

/* displayData
 _____________________________________________________________________________________________________________________________ */

- (void) displayData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    self.lblLastRefreshed.text = [NSString stringWithFormat:@"last refreshed: %@", [dateFormatter stringFromDate:[MXLSession currentSession].kpis.lastRefreshed]] ;
    self.lblNumberOfFacilities.text = [NSString stringWithFormat:@"%d", (int) [MXLSession currentSession].kpis.numberOfFacilities];
    self.lblNoReportsReceived.text = self.lblFacilitiesReported.text = [NSString stringWithFormat:@"%d", (int) [MXLSession currentSession].kpis.facilitiesReporting];
    self.lblFacilitiesNotReporting.text = [NSString stringWithFormat:@"%d", (int)[MXLSession currentSession].kpis.facilitiesNotReporting];
    self.lblReportingRate.text = [MXLSession currentSession].kpis.reportingRateString;
    self.lblCurrentLevel.text = [MXLEntity prettifyForDistrict:[MXLEntity prettifyForIP:[MXLSession currentSession].kpis.entity]];
    self.lblCurrentReportingWeek.text = [MXLSession currentSession].kpis.weekno;
    NSLog(@"%@", [MXLSession currentSession].kpis.lastRefreshed);
    self.lblLastRefreshed.text = [NSString stringWithFormat:@"last refreshed: %@", [dateFormatter stringFromDate:[MXLSession currentSession].kpis.lastRefreshed]];

    NSInteger stockOuts = [MXLSession currentSession].kpis.testKitStockouts + [MXLSession currentSession].kpis.arvStockouts;
    UITabBarItem* stockOutTab = [self.navigationController.tabBarController.tabBar.items objectAtIndex:(1)];
    [stockOutTab  setBadgeValue:nil];
    if (stockOuts > 0) {
        if (stockOutTab != nil)
            [stockOutTab setBadgeValue:[NSString stringWithFormat:@"%d", (int) stockOuts]];
    }
    else {
        if (stockOutTab != nil)
            [stockOutTab  setBadgeValue:nil];
    }
    
    // Set app badge
    [mxlAppDelegate setIconBadge];
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
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Unable to load the weekly data. Please verify that you have an active Internet connection and try again." message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        self.lblLastRefreshed.text = @"error while loading reporting rates";
//        [self.navigationController popViewControllerAnimated:TRUE];
    }];
    self->loadingData = false;
}



/* currentSessionRefreshed
 _____________________________________________________________________________________________________________________________ */

- (void) currentSessionRefreshed:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        MXLSession* session = [MXLSession currentSession];
        [self.tableView footerViewForSection:1].textLabel.text = [NSString stringWithFormat:@"%@", session.latestRefresh];
    }];
    

}

/* viewWillAppear
 _____________________________________________________________________________________________________________________________ */

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Check if a certain time has elapsed, and if it has, refresh it.
    NSDate* currentTime = [NSDate date];
    if ([MXLSession currentSession].kpis) {
        NSDate* lastRefreshed = [MXLSession currentSession].kpis.lastRefreshed;
        NSTimeInterval timeElapsed = [currentTime timeIntervalSinceDate:lastRefreshed];
        if (timeElapsed > (60 * 10) & [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefresh] == 1) {
            [MXLSession currentSession].kpiRefreshNeeded = true;
            NSLog(@"Refreshing...");
        }
    }
    
    
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
    
    NSLog(@"View will appear");
}

/* btnChangeWeek
 _____________________________________________________________________________________________________________________________ */

- (IBAction)btnChangeWeek:(id)sender {
    [self performSegueWithIdentifier:@"sguSettings" sender:sender];
}

/* addItemViewController
 _____________________________________________________________________________________________________________________________ */

- (void)didSelectEntity:(UITableViewController *)controller selectedEntity:(id)item {
    
    if ([controller.restorationIdentifier isEqualToString:@"SelectAWeek"]) {
        MXLWeek* week = (MXLWeek*) item;
        [MXLSession currentSession].currentWeek = week.weekno;
    }
    else if ([controller.restorationIdentifier isEqualToString:@"SelectALevel"]) {
        MXLEntity* entity2 = (MXLEntity*)item;
        [MXLSession currentSession].currentEntity = entity2.name;
    }
    [MXLSession currentSession].kpiRefreshNeeded = true;

    [self refresh:nil];

}

/* prepareForSegue
 _____________________________________________________________________________________________________________________________ */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"SelectALevel"])
    {
        // Get a reference to your custom view controller
        MXLEntitySelectionVC *customViewController = (MXLEntitySelectionVC *) segue.destinationViewController;
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"SelectAWeek"])
    {
        // Get a reference to your custom view controller
        MXLWeekSelectionVC *customViewController = (MXLWeekSelectionVC *) segue.destinationViewController;
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"ShowAllFacilities"])
    {
        // Get a reference to your custom view controller
        MXLFacilityListVC *customViewController = (MXLFacilityListVC *) segue.destinationViewController;
        // Set your custom view controller's delegate
        customViewController.delegate = self;
        customViewController.facilitiesToShow = Entity;
    }
    else if ([[segue identifier] isEqualToString:@"ShowFacilitiesReported"])
    {
        // Get a reference to your custom view controller
        MXLFacilityListVC *customViewController = (MXLFacilityListVC *) segue.destinationViewController;
        // Set your custom view controller's delegate
        customViewController.delegate = self;
        customViewController.facilitiesToShow = FacilitiesReported;
    }
    else if ([[segue identifier] isEqualToString:@"ShowFacilitiesNotReported"])
    {
        // Get a reference to your custom view controller
        MXLFacilityListVC *customViewController = (MXLFacilityListVC *) segue.destinationViewController;
        // Set your custom view controller's delegate
        customViewController.delegate = self;
        customViewController.facilitiesToShow = FacilitiesNotReported;
    }
    
}

@end
