//
//  MXListTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 19/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"

@interface MXListTableViewController : MXLTableViewController

@property (nonatomic) NSMutableArray* dataSource;
@property (nonatomic) NSMutableArray *searchResults;

// A dictionary holding categories and their objects
@property (nonatomic) NSMutableDictionary* categories;

// A sorted array with only the names of the categories
@property (nonatomic) NSArray* categoryNames;


@property (nonatomic) NSObject* selectedEntity;
@property (nonatomic) NSString* failErrorMessage;
@property (nonatomic) NSString* detailSegueName;
@property (nonatomic) NSString* categoryProperty;
@property (nonatomic) NSString* cellText;
@property (nonatomic) NSString* cellDetailText;
@property (nonatomic) NSString* noDataText;
@property (nonatomic) UILabel* lblNoDataMessage;
@property (nonatomic) NSString* detailsDataSourceProperty;



/* Methods */

- (void) assignDataSource;
- (void) loadDataSource;
- (NSObject*) getSelectedEntityForIndexPath:(NSIndexPath*) indexPath __deprecated;
- (NSObject*) getSelectedEntityForIndexPath:(NSIndexPath*) indexPath tableView:(UITableView*) tableView;
- (void) updateSearchResultsForString:(NSString*) searchString;

@end
