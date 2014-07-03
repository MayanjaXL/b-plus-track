//
//  MXLWeekPopupVC.m
//  B+Track
//
//  Created by Fitti Weissglas on 15/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeekPopupVC.h"

@interface MXLWeekPopupVC ()

@end

@implementation MXLWeekPopupVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCancel_Click:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
