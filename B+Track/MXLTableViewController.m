//
//  MXLTableViewController.m
//  B+Track
//
//  Created by Fitti Weissglas on 14/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLTableViewController.h"

@interface MXLTableViewController ()

@end

@implementation MXLTableViewController

UIActivityIndicatorView* spinner;


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
    
    // Register for default notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadSuccessNotification:) name:[NSString stringWithFormat:@"%@_success", observerName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadFailNotification:) name:[NSString stringWithFormat:@"%@_fail", observerName] object:nil];
    
    // Ensure loadData gets called
    [self launchLoadData];
}

- (void) launchLoadData {
}

- (void) dataLoadSuccessNotification:(NSNotification *) notification {

}

- (void) dataLoadFailNotification:(NSNotification *) notification {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startSpinner {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center; //set some center
    [self.tableView addSubview: spinner];
    [self.tableView bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    [spinner startAnimating];
}

- (void) stopSpinner {
    if (spinner != NULL)
        [spinner stopAnimating];
}




@end
