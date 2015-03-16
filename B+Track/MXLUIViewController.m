//
//  MLXUIViewController.m
//  BPlus_Track
//
//  Created by Fitti Weissglas on 04/07/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLUIViewController.h"

@interface MXLUIViewController ()



@end

@implementation MXLUIViewController

UIActivityIndicatorView* spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self.view addSubview: spinner];
    [self.view bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    [spinner startAnimating];
}

- (void) stopSpinner {
    if (spinner != NULL)
        [spinner stopAnimating];
}

@end
