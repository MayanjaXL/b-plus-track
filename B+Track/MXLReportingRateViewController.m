//
//  MXLReportingRateViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLReportingRateViewController.h"
#import "mxlAppDelegate.h"
#import "MXLSession.h"

@interface MXLReportingRateViewController ()

@end

@implementation MXLReportingRateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _mainNavigationItem.prompt = @"Hello I have woken up!";
    NSLog(@"Into view");
//    mxlAppDelegate *appDelegate = (mxlAppDelegate *)[[UIApplication sharedApplication] delegate];
    _mainNavigationItem.prompt = [MXLSession currentSession].currentWeek;
    [MXLSession currentSession].delegate = self;;
    [[NSNotificationCenter defaultCenter] ]
    NSLog(@"Deletegate set");
    
}

- (void) currentSessionRefreshed:(MXLSession *)session {
    
    NSLog(@"CSF");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView footerViewForSection:1].textLabel.text = [NSString stringWithFormat:@"%@", session.latestRefresh];
    }];
    

}

@end
