//
//  mxlProfileTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLProfileViewController.h"
#import "MXLEntitySelectionViewController.h"
#import "MXLWeekSelectionViewController.h"
#import "MXLDataRetriever.h"
#import "mxlAppDelegate.h"
#import "MXLSession.h"

@interface MXLProfileViewController ()

@end

@implementation MXLProfileViewController

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
    mxlAppDelegate* appDelegate = (mxlAppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.Session.delegate = self;
    
}

- (void) currentSessionRefreshed:(MXLSession *)session {
    

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _fetchBackgroundData.detailTextLabel.text = [NSString stringWithFormat:@"%@", session.latestRefresh];
    }];

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
        MXLEntitySelectionViewController *customViewController = (MXLEntitySelectionViewController *) segue.destinationViewController;
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"showWeek"])
    {
        // Get a reference to your custom view controller
        MXLWeekSelectionViewController *customViewController = (MXLWeekSelectionViewController *) segue.destinationViewController;
        
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
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
            [messageAlert show];

        }
        else if (cell.tag == 2) {
            [MXLDataRetriever.Queue addOperationWithBlock:^{
                [MXLDataRetriever simulateBackgroundLoadOfData];
            }];
            
        }
    }
    
    
    // Display Alert Message
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)addItemViewController:(UITableViewController *)controller didFinishEnteringItem:entity
{
    MXLEntity* entity2 = (MXLEntity*)entity;
    self.defaultLevelField.text = entity2.name;
}

- (void)addItemViewController:(UITableViewController *)controller didFinishSelectingWeek:(MXLWeek *)week
{

    self.weekNo.text = week.weekno;
}





/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

