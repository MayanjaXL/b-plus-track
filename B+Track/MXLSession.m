//
//  MXLCurrentSession.m
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLSession.h"
#import "mxlAppDelegate.h"

@implementation MXLSession

+ (MXLSession*) currentSession {
    
    mxlAppDelegate *appDelegate = (mxlAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.Session;
}


- (void) DoCurrentSessionRefreshed {
    //_LatestRefresh = [NSDate date];
    self.latestRefresh = [NSDate date];
    
    // Fire a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataRefresh" object:self];
    
    // Fire the event
    [self.delegate currentSessionRefreshed:self];
}


@end
