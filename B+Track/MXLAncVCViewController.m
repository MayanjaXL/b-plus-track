//
//  MXLAncVCViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 16/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLAncVCViewController.h"
#import "mxlAppDelegate.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "BPlus_Track-Swift.h"
#import "mxlEntity.h"
#import "MXLEntitySelectionVC.h"
#import "MXLWeekSelectionVC.h"

@interface MXLAncVCViewController ()

@end

@implementation MXLAncVCViewController

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
    
    self.lblNoOfANC1Visits.text = [NSString stringWithFormat:@"%d", (int)[MXLSession currentSession].kpis.noOfANC1Visits];
    self.lnlNoTestedForHIV.text = [NSString stringWithFormat:@"%d", (int)[MXLSession currentSession].kpis.noTestedForHIV];
    self.lblPropTested.text = [NSString stringWithFormat:@"%0.1f%%", [MXLSession currentSession].kpis.propTested];
    self.lblPropInitiated.text = [NSString stringWithFormat:@"%0.1f%%", [MXLSession currentSession].kpis.propInitiated];
    self.lblNoTestedPositiveForHIV.text = [NSString stringWithFormat:@"%d", (int)[MXLSession currentSession].kpis.noTestedPositiveForHIV];
    self.lnlNoInitiatedART.text =[NSString stringWithFormat:@"%d", (int)[MXLSession currentSession].kpis.noInitiatedART];

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

- (void) dataLoadFailNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        [self.refreshControl endRefreshing];
    }];
    self->loadingData = false;
}

-(void)viewWillAppear:(BOOL)animated{
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




@end
