//
//  MXListTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXListTableViewController.h"
#import "MXLFacilityDetailsVC.h"
#import "UITableViewCell+getIOTableView.h"
#import <objc/message.h>
#import "MXLDataRetriever.h"

@interface MXListTableViewController ()


@end

@implementation MXListTableViewController

#pragma mark View Loading and Appearing

/* initWithNibName [MUST OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (id) initWithCoder:(NSCoder *) coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        // Custom initialization
        self.failErrorMessage = @"Error loading the data.";
        self.detailSegueName = @"ShowDetails";
        self.noDataText = @"There is no data to show.";
        self.detailsDataSourceProperty = @"dataSource";
    }
    return self;
}

/* viewDidLoad [MUST OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (void )viewDidLoad {
    if (self.lblNoDataMessage)
        self.lblNoDataMessage.text = @"";
    
    [super viewDidLoad];
    
}

/* viewWillAppear [MAY OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

/* Loading Data */
#pragma mark Loading Data



/* launchLoadData
 _____________________________________________________________________________________________________________________________ */

// This method will:
// 1. Attempt to assign a data source
// 2. If an assigned data source was nil, it will call loadDataSource, which should load the data from wherever
// 3. loadDataSource will be called on a seperate thread, and a spinner will appear.
 - (void) launchLoadData {

     @synchronized (self) {
         [self assignDataSource];
     }
     // Data already loaded – no need to do anything
     if (self.dataSource != nil) {
         @synchronized (self) {
             [self.tableView reloadData];
         }
     }
     // Initiate a background load event, and see where it will go.
     else {
         [self startSpinner];
         [MXLDataRetriever.Queue addOperationWithBlock:^{
             [self loadDataSource];
         }];
     }
 }



/* assignDataSource [MUST OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

// Called when it's time to fill the data source, following a successful load notification.
// Categories should be created here as well. If no categories are to be used, leave categories set to 0.
- (void) assignDataSource {
    
    // Ensure that a data source has been set
    if (!self.dataSource) {
        return;
    }
    
    // Create default categories, alphabetically
    if (self.categoryProperty) {

        bool found;
        self.categories = [NSMutableDictionary new];
        for (NSObject *entity in self.dataSource)
        {
            NSString *c = [entity valueForKey:self.categoryProperty];
            found = false;
            for (NSString *str in [self.categories allKeys]) {
                if ([str isEqualToString:c]) {
                    found = true;
                }
            }
            if (!found) {
                [self.categories setValue:[[NSMutableArray alloc] init] forKey:c];
            }
        }
        
        NSArray* sortedKeys = [[self.categories allKeys] sortedArrayUsingSelector: @selector(compare:)];
        self.categoryNames = sortedKeys;
        NSMutableArray *sortedValues = [NSMutableArray array];
        for (NSString *key in sortedKeys) {
            [sortedValues addObject: [self.categories objectForKey: key]];
        }
        
        for (NSObject *entity in self.dataSource) {
            [[self.categories objectForKey:[entity valueForKey:self.categoryProperty]] addObject:entity];
        }
    }
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.dataSource count]];
    
    // Update the label in case there is no data to show
    if ([self.dataSource count] == 0 && self.lblNoDataMessage)
        self.lblNoDataMessage.text = self.noDataText;
    else
        self.lblNoDataMessage.text = @"";
    
}

/* loadDataSource
 _____________________________________________________________________________________________________________________________ */
// This methods gets called when there is no cache data available.
// This method should make the necessary database calls to load the data.

- (void) loadDataSource {
    
}


/* dataLoadFailNotification [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (void) dataLoadFailNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue]  addOperationWithBlock:^{
        [self stopSpinner];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:self.failErrorMessage message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }];
}


/* dataLoadSuccessNotification [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

// Assigns the data source and fills the tables
- (void) dataLoadSuccessNotification:(NSNotification *) notification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self stopSpinner];
        
        @synchronized (self) {
            [self assignDataSource];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark User Interface

/* prepareForSegue [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:self.detailSegueName])
    {
        UITableViewCell* cell = ((UITableViewCell*) sender);
        UITableView* tableView = [cell parentTableView];

        // Get a reference to your custom view controller
        MXLDetailTableViewController *customViewController;
        if ([segue.destinationViewController isKindOfClass:[MXLDetailTableViewController class]])
            customViewController = (MXLDetailTableViewController *) segue.destinationViewController;
        else
            customViewController = (MXLDetailTableViewController *) [[segue.destinationViewController viewControllers] objectAtIndex:0];

            
        
        //[object isKindOfClass:[ClassName class]]
    
        
        NSIndexPath* indexPath = [tableView indexPathForCell:sender];
        customViewController.dataSource = [self getSelectedEntityForIndexPath:indexPath tableView:tableView];
    }
}

#pragma mark Entities

/* getSelectedEntityForSender [MAY OVERRIDE]
 _____________________________________________________________________________________________________________________________ */


- (NSObject*) getSelectedEntityForIndexPath:(NSIndexPath*) indexPath {
    

/*	if (self.searchDisplayController.active) {
        if (indexPath)
            return self.searchResults[indexPath.row];
        else
            return nil;
    }
    else {*/
    if (self.categories) {
        NSMutableArray* entities = [self.categories objectForKey:self.categoryNames[indexPath.section]];
        if (entities)
            return entities[indexPath.row];
        else
            return nil;
    }
    else
        return self.dataSource[indexPath.row];
    
}

/* getSelectedEntityForIndexPath [MAY OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (NSObject*) getSelectedEntityForIndexPath:(NSIndexPath*) indexPath tableView:(UITableView*) tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults[indexPath.row];
    }
    else if (self.categories) {
        NSMutableArray* entities = [self.categories objectForKey:self.categoryNames[indexPath.section]];
        if (entities)
            return entities[indexPath.row];
        else
            return nil;
    }
    else
        return self.dataSource[indexPath.row];
    
}

#pragma mark Search

/* shouldReloadTableForSearchString
 _____________________________________________________________________________________________________________________________ */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self updateSearchResultsForString:searchString];
    return true;
}

/* updateSearchResults
 _____________________________________________________________________________________________________________________________ */

- (void) updateSearchResultsForString:(NSString*) searchString {
    
}


#pragma mark Displaying Data

/* numberOfSectionsInTableView [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
        
    if (self.categoryNames)
        return [self.categoryNames count];
    else
        return 1;
}

/* titleForHeaderInSection [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
        return @"Search results";
    else
        return self.categoryNames[section];
}

/* numberOfRowsInSection [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }
    else {
        if (self.categoryNames) {
            NSMutableArray* entities = [self.categories objectForKey:self.categoryNames[section]];
            if (entities)
                return entities.count;
            else
                return 0;
        }
        else if (self.dataSource) {
            return self.dataSource.count;
        }
        else
            return 0;
    }
}

/* cellForRowAtIndexPath [MAY OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntityCell" forIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EntityCell"];
    NSObject* entity;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        entity = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        entity = [self getSelectedEntityForIndexPath:indexPath tableView:tableView];
    }
    if (self.cellText)
        cell.textLabel.text = [entity valueForKey:self.cellText];
    cell.detailTextLabel.text = [entity valueForKey:self.cellDetailText];
    return cell;
}


/* accessoryButtonTappedForRowWithIndexPath [NO OVERRIDE]
 _____________________________________________________________________________________________________________________________ */

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedEntity = [self getSelectedEntityForIndexPath:indexPath tableView:tableView];
}



@end




























