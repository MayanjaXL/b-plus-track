//
//  mxlAppDelegate.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "mxlAppDelegate.h"
#import "MXLSession.h"
#import "MXLDataRetriever.h"
#import "MXLKPIs.h"

@implementation mxlAppDelegate


/* didFinishLaunchingWithOptions
 _____________________________________________________________________________________________________________________________ */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"START!");
//    NSLog();
    self.Session = [MXLSession new];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kBadge: @badgeStockouts}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kDefaultEntity: @"Uganda"}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kAutoRefresh: @true}];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:kDefaultEntity] != nil) {
        [MXLSession currentSession].currentEntity  = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultEntity];
    }
    
    [mxlAppDelegate setIconBadge];
    
    // Attempt to laod some cache data
    [MXLDataRetriever.Queue addOperationWithBlock:^{
        [[MXLSession currentSession] loadWeekNumbers];
        [[MXLSession currentSession] loadEntities];
    }];

    [[UIView appearance] setTintColor:[UIColor orangeColor]];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

/* applicationWillResignActive
 _____________________________________________________________________________________________________________________________ */

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/* applicationDidEnterBackground
 _____________________________________________________________________________________________________________________________ */

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/* applicationWillEnterForeground
 _____________________________________________________________________________________________________________________________ */

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Foreground!");
}

/* applicationDidBecomeActive
 _____________________________________________________________________________________________________________________________ */

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [MXLSession currentSession].kpiRefreshNeeded = true;
}

/* applicationWillTerminate
 _____________________________________________________________________________________________________________________________ */

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"TERM!");
}

/* performFetchWithCompletionHandler
 _____________________________________________________________________________________________________________________________ */

-(void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[MXLSession currentSession] loadBunch];
/*    [MXLSession currentSession].forceKPIRefresh = true;
    [[MXLSession currentSession] loadKPIs];
    [[MXLSession currentSession] loadFacilities];*/
    
    // fetching the data here ...
    
    bool failedFetch = ([MXLSession currentSession].kpis == nil);
    if(failedFetch) { // use your own flag here
        completionHandler(UIBackgroundFetchResultFailed);
    }
    else {
        if(true) { // use your own flag here
            completionHandler(UIBackgroundFetchResultNewData);
        }
        else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }
}

/* setIconBadge
 _____________________________________________________________________________________________________________________________ */

+ (void) setIconBadge {
    if ([MXLSession currentSession].kpis != nil) {
        NSInteger stockOuts = [MXLSession currentSession].kpis.arvStockouts + [MXLSession currentSession].kpis.testKitStockouts;
        switch ([MXLSession currentSession].badgeIcon) {
            case badgeStockouts: {
                if (stockOuts > 0) {
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:stockOuts];
                }
                else {
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                }
                break;
            }
            case badgeReportingRate: {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[MXLSession currentSession].kpis.reportingRate];
                break;
            }
            case badgeNever: {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                break;
            }
                
        }
    }
    else {
        // Leave as is! Don't update the badge.
    }
}


@end
