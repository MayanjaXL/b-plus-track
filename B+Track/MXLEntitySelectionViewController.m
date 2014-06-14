//
//  mxlEntitySelectionTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLEntitySelectionViewController.h"
#import "MXLEntity.h"
#import "MXLDataRetriever.h"

@interface MXLEntitySelectionViewController ()
{
    
    NSMutableArray *districts;
    NSMutableArray *ips;
    NSMutableArray *toplevel;
    MXLEntity *selectedEntity;
    bool dataLoaded;
    UIActivityIndicatorView* spinner;
    int currentThread;

    //id <mxlEntitySelectionTableViewControllerDelegate> delegate;
}

@end

@implementation MXLEntitySelectionViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dataLoaded = false;
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
    [super viewDidLoad];
    dataLoaded = false;
    selectedEntity = NULL;
    [self launchLoadData];
   
    
}

#pragma mark Data Loading

/* launchLoadData */
- (void) launchLoadData {

    // Do not create a thread unless it is really necessary
    if ([MXLDataRetriever dataIsCached]) {
        [self loadData];
        return;
    }
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center; //set some center
    [self.tableView addSubview: spinner];
    [self.tableView bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    [spinner startAnimating];
        NSLog(@"Main thread %@", [NSThread currentThread]);
    [MXLDataRetriever.Queue addOperationWithBlock:^{
        [self loadData];
    }];
    NSLog(@"Main thread continues %@", [NSThread currentThread]);
    
}

/* loadData */
- (void) loadData {
    NSLog(@"Starting %@", [NSThread currentThread]);
    
    @try {
        [MXLDataRetriever cacheMetaData]; // Cache all meta data at a go
        toplevel = [MXLDataRetriever getEntitiesWithLevel:1 Cached:true];
        districts = [MXLDataRetriever getEntitiesWithLevel:2 Cached:true];
        ips = [MXLDataRetriever getEntitiesWithLevel:3 Cached:true];
    }
    @catch (NSException *exception) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self failLoadData];
        }];
        return;
    }

    dataLoaded = true;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self finishLoadData];
    }];

}

/* failLoadData */
- (void) failLoadData {

    if (spinner != NULL)
        [spinner stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Unable to load the list. Please verify that you have an active Internet connection and try again" message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:TRUE];

}

/* finishLoadData */
- (void) finishLoadData {
    
    if (spinner != NULL)
        [spinner stopAnimating];
    
    [self.tableView reloadData];
}

#pragma mark Other


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!dataLoaded)
        return 0;
    
    // Return the number of rows in the section.
    switch (section) {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntityCell" forIndexPath:indexPath];
 
    // Configure the cell...
    MXLEntity *entity;
    switch (indexPath.section) {
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
    cell.textLabel.text = entity.name;
    cell.detailTextLabel.text = entity.level;
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    switch (indexPath.section) {
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
    // Fire the selection event
    [self.delegate addItemViewController:self didFinishEnteringItem:selectedEntity];
    
    // Return to previous screen
    [self.navigationController popViewControllerAnimated:TRUE];
}



@end
