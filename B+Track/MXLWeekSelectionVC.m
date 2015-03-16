//
//  MXLWeekSelectionViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeekSelectionVC.h"
#import "BPlus_Track-Swift.h"
#import "MXLDataRetriever.h"
#import "MXLSession.h"

@interface MXLWeekSelectionVC () {
    bool dataLoaded;
    NSMutableArray *weeks;
    MXLWeek* selectedWeek;
}

@end

@implementation MXLWeekSelectionVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        dataLoaded = false;
    }
    return self;
}

- (void)viewDidLoad
{
    dataLoaded = false;
    selectedWeek = NULL;
    self->observerName = @"week_numbers";
    [super viewDidLoad];
}

#pragma mark Data Loading

/* launchLoadData */
- (void) launchLoadData {
    
    [super launchLoadData];
    
    // Data already loaded – no need to do anything
    if ([MXLSession currentSession].weekNumbers != nil) {
        @synchronized (self) {
            weeks = [MXLSession currentSession].weekNumbers;
            [self.tableView reloadData];
        }
    }
    // Initiate a background load event, and see where it will go.
    else {
        [self startSpinner];
        // Initiate a week number load background
        [MXLDataRetriever.Queue addOperationWithBlock:^{
            [[MXLSession currentSession] loadWeekNumbers];
        }];
    }
}

- (void) dataLoadSuccessNotification:(NSNotification *) notification {

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        @synchronized (self) {
            weeks = [MXLSession currentSession].weekNumbers;
            [self.tableView reloadData];
        }
    }];
}

- (void) dataLoadFailNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Unable to load the week numbers. Please verify that you have an active Internet connection and try again" message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:TRUE];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return weeks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekNoCell" forIndexPath:indexPath];
    MXLWeek* week =  weeks[indexPath.row];
    
    cell.textLabel.text = week.weekno;
    cell.detailTextLabel.text = week.displayName;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedWeek = weeks[indexPath.row];
    [self.delegate didSelectEntity:self selectedEntity:selectedWeek];
    
    // Fire the selection event
//    [self.delegate addItemViewController:self didFinishSelectingWeek:selectedWeek];
    
    // Return to previous screen
    [self.navigationController popViewControllerAnimated:TRUE];
}



@end
