//
//  MXLWeekSelectionViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeekSelectionViewController.h"
#import "MXLWeek.h"
#import "MXLDataRetriever.h"

@interface MXLWeekSelectionViewController () {
    bool dataLoaded;
    UIActivityIndicatorView* spinner;
    NSMutableArray *weeks;
    MXLWeek* selectedWeek;
}

@end

@implementation MXLWeekSelectionViewController





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
    [super viewDidLoad];
    
    [super viewDidLoad];
    dataLoaded = false;
    selectedWeek = NULL;
    [self launchLoadData];
    
}

#pragma mark Data Loading

/* launchLoadData */
- (void) launchLoadData {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center; //set some center
    [self.tableView addSubview: spinner];
    [self.tableView bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    [spinner startAnimating];
    [MXLDataRetriever.Queue addOperationWithBlock:^{
        [self loadData];
    }];
}

/* loadData */
- (void) loadData {
    
    @try {
        [MXLDataRetriever cacheMetaData]; // Cache all meta data at a go
        weeks = [MXLDataRetriever getWeekNumbersWithCached:true];
    }
    @catch (NSException *exception) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self failLoadData];
        }];
        return;
    }
    
    dataLoaded = true;
    
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
                          initWithTitle:@"Unable to load the week numbers. Please verify that you have an active Internet connection and try again" message:nil delegate:nil
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
    NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
    selectedWeek = weeks[indexPath.row];
    // Fire the selection event
    [self.delegate addItemViewController:self didFinishSelectingWeek:selectedWeek];
    
    // Return to previous screen
    [self.navigationController popViewControllerAnimated:TRUE];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
