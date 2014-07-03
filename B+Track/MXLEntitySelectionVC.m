//
//  mxlEntitySelectionTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLEntitySelectionVC.h"
#import "MXLEntity.h"
#import "MXLDataRetriever.h"
#import "MXLSession.h"

@interface MXLEntitySelectionVC ()
{
    
    NSMutableArray *districts;
    NSMutableArray *ips;
    NSMutableArray *toplevel;
    MXLEntity *selectedEntity;
    int currentThread;
}

@end

@implementation MXLEntitySelectionVC



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    selectedEntity = NULL;
    self->observerName = @"entities";
    [super viewDidLoad];
}

#pragma mark Data Loading

/* launchLoadData
 _____________________________________________________________________________________________________________________________ */

- (void) launchLoadData {
    [super launchLoadData];
    
    if ([MXLSession currentSession].topLevel != nil & [MXLSession currentSession].districts != nil & [MXLSession currentSession].ips != nil) {
        @synchronized (self) {
            toplevel = [MXLSession currentSession].topLevel;
            districts = [MXLSession currentSession].districts;
            ips = [MXLSession currentSession].ips;
            [self.tableView reloadData];
        }
    }
    else {
        [self startSpinner];
        [MXLDataRetriever.Queue addOperationWithBlock:^{
            [[MXLSession currentSession] loadEntities];
        }];
    }
}

/* dataLoadSuccessNotification
 _____________________________________________________________________________________________________________________________ */

- (void) dataLoadSuccessNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [super stopSpinner];
        @synchronized (self) {
            toplevel = [MXLSession currentSession].topLevel;
            districts = [MXLSession currentSession].districts;
            ips = [MXLSession currentSession].ips;
            [self.tableView reloadData];
        }
    }];
}

- (void) dataLoadFailNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Unable to load the list. Please verify that you have an active Internet connection and try again." message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:TRUE];
    }];
}
#pragma mark Other



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/* numberOfRowsInSection
 _____________________________________________________________________________________________________________________________ */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    switch ([self.segSelection selectedSegmentIndex]) {
    case 0: {
        return toplevel.count;
        break;
    }
    case 1: {
        return districts.count;
        break;
    }
    case 2: {
        return ips.count;
        break;
    }
    }
    
    return 0;
}

/* cellForRowAtIndexPath
 _____________________________________________________________________________________________________________________________ */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntityCell" forIndexPath:indexPath];
 
    // Configure the cell...
    MXLEntity *entity;
    switch ([self.segSelection selectedSegmentIndex]) {
        case 0: {
            entity = toplevel[indexPath.row];
            break;
        }
        case 1: {
            entity = districts[indexPath.row];
            break;
        }
        case 2: {
            entity = ips[indexPath.row];
            break;
        }
    }
    cell.textLabel.text = [MXLEntity prettifyForIP:[MXLEntity prettifyForDistrict:entity.name]];
    cell.detailTextLabel.text = entity.level;
    return cell;
}

/* titleForHeaderInSection
 _____________________________________________________________________________________________________________________________ */

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    int segment = (int) [self.segSelection selectedSegmentIndex];
    
    switch (segment) {
        case 0:{
            return @"National";
        }
        case 1:{
            return @"Districts";
        }
        case 2:{
            return @"Implementing partners";
        }
    }
    
    return @"";
}

/* didSelectRowAtIndexPath
 _____________________________________________________________________________________________________________________________ */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.segSelection selectedSegmentIndex]) {
        case 0:{
            selectedEntity = toplevel[indexPath.row];
            break;
        }
        case 1:{
            selectedEntity = districts[indexPath.row];
            break;
        }
        case 2:{
            selectedEntity = ips[indexPath.row];
            break;
        }
    }
    
    [self.delegate didSelectEntity:self selectedEntity:selectedEntity];
    
    
    // Fire the selection event
//    [self.delegate addItemViewController:self didFinishEnteringItem:selectedEntity];
    
    // Return to previous screen
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (IBAction)segSelection_Changed:(id)sender {
    
    [self.tableView reloadData];
}
@end
