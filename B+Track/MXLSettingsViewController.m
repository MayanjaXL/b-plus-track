//
//  mxlProfileTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLSettingsViewController.h"
#import "MXLEntitySelectionVC.h"
#import "MXLWeekSelectionVC.h"
#import "MXLDataRetriever.h"
#import "mxlAppDelegate.h"
#import "BPlus_Track-Swift.h"
#import "MXLSession.h"
#import "mxlEntity.h"

@interface MXLSettingsViewController ()

@end

@implementation MXLSettingsViewController
int badge;

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
    _defaultLevelField.text = @"Test";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    _reloadCacheCell.textLabel.textColor = [button titleColorForState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentSessionRefreshed:) name:@"background_simulation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:@"current_week_changed" object:nil];
    self.defaultLevelField.text = [MXLEntity prettifyForDistrict:[MXLEntity prettifyForIP:[[NSUserDefaults standardUserDefaults] stringForKey:kDefaultEntity]]];
    
//    appDelegate.Session.delegate = self;
    
    
}

- (void) currentSessionRefreshed:(NSNotification *) notification {
    
    MXLSession* session = [MXLSession currentSession];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _fetchBackgroundData.detailTextLabel.text = [NSString stringWithFormat:@"%@", session.latestRefresh];
    }];

}

- (void) dataLoaded:(NSNotification *) notification {
    
    NSLog(@"Week numbers came in... loading!");
    [self displayData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"showDefaultLevel"])
    {
        // Get a reference to your custom view controller
        MXLEntitySelectionVC *customViewController = (MXLEntitySelectionVC *) segue.destinationViewController;
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"showWeek"])
    {
        // Get a reference to your custom view controller
        MXLWeekSelectionVC *customViewController = (MXLWeekSelectionVC *) segue.destinationViewController;
        
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self displayData];
}

- (void) displayData {
    
    self.chkRefreshAutomatically.on = [MXLSession currentSession].refreshAutomatically;
    switch ([MXLSession currentSession].badgeIcon) {
        case badgeStockouts: {
            [self.cellBadgeStockout setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
        case badgeReportingRate: {
            [self.cellBadgeReportingRate setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
        case badgeNever: {
            [self.cellNoBadge setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
    }

    
    NSLog(@"displat data current week: %@",[MXLSession currentSession].currentWeek);
    if ([MXLSession currentSession].currentWeek == nil)
        self.weekNo.text = @"loading...";
    else {
        self.weekNo.text = [MXLSession currentSession].currentWeek;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil) {
        if (cell.tag == 1)
        {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Row Selected" message:@"Cache cleared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [MXLDataRetriever clearCache];
            [[MXLSession currentSession] clearCache];
            [messageAlert show];

        }
        else if (cell.tag == 2) {
            [MXLDataRetriever.Queue addOperationWithBlock:^{
                [MXLDataRetriever simulateBackgroundLoadOfData];
            }];
            
        }
        else if (cell.tag == 11 |  cell.tag == 12 | cell.tag == 13) {
            [self.cellBadgeReportingRate setAccessoryType:UITableViewCellAccessoryNone];
            [self.cellBadgeStockout setAccessoryType:UITableViewCellAccessoryNone];
            [self.cellNoBadge setAccessoryType:UITableViewCellAccessoryNone];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            badge = cell.tag == 11 ? badgeStockouts : cell.tag == 12 ? badgeReportingRate : badgeNever;
        }
    }
    
    
    // Display Alert Message
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didSelectEntity:(UITableViewController *)controller selectedEntity:(id)item {
    
    if ([controller.restorationIdentifier isEqualToString:@"SelectAWeek"]) {
        MXLWeek* week = (MXLWeek*) item;
        [MXLSession currentSession].currentWeek = week.weekno;
        self.weekNo.text = week.weekno;
    }
    else if ([controller.restorationIdentifier isEqualToString:@"SelectALevel"]) {
        MXLEntity* entity2 = (MXLEntity*)item;
        [[NSUserDefaults standardUserDefaults] setObject:[MXLSession currentSession].currentEntity forKey:kDefaultEntity];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MXLSession currentSession].currentEntity = entity2.name;
        self.defaultLevelField.text = [MXLEntity prettifyForIP:[MXLEntity prettifyForDistrict:entity2.name]];
    }
    [MXLSession currentSession].kpiRefreshNeeded = true;
}



- (IBAction)btnDone_Click:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[MXLSession currentSession].currentEntity forKey:kDefaultEntity];
    [[NSUserDefaults standardUserDefaults] setInteger:self.chkRefreshAutomatically.on ? 1 : 0 forKey:kAutoRefresh];
    [[NSUserDefaults standardUserDefaults] setInteger:badge forKey:kBadge];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

