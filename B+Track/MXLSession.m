//
//  MXLCurrentSession.m
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLSession.h"
#import "mxlAppDelegate.h"
#import "MXLDataRetriever.h"
#import "MXLKPIs.h"
#import "MXLWeek.h"
#import "MXLWeeklyReport.h"
#import "mxlFacility.h"




/* This is the smartest class that provides all the data */
@implementation MXLSession
NSMutableDictionary* _cache;

+ (MXLSession*) currentSession {
    
    mxlAppDelegate *appDelegate = (mxlAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.Session;
}

/* init
 _____________________________________________________________________________________________________________________________ */

- (id) init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary new];
        self.currentEntity = @"Uganda";
        self.currentWeek = nil;
        self.kpiRefreshNeeded = true;
    }
    return self;
}

/* DoCurrentSessionRefreshed
 _____________________________________________________________________________________________________________________________ */

- (void) DoCurrentSessionRefreshed {
    //_LatestRefresh = [NSDate date];
    self.latestRefresh = [NSDate date];
    
    // Fire a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KPIDataRefresh" object:self];
    
    // Fire the event
    [self.delegate currentSessionRefreshed:self];
}

#pragma mark Cache Implementations

/* clearCache
 _____________________________________________________________________________________________________________________________ */

- (void) clearCache {
    @synchronized (self ) {
        [_cache removeAllObjects];
    }
}


#pragma mark Property Implementations

- (bool) getRefreshAutomatically {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefresh] == 1;
}

- (int) getBadgeIcon {

    return (int) [[NSUserDefaults standardUserDefaults] integerForKey:kBadge ];
}

/* getWeekNumbers
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) getWeekNumbers {

    // Check if a refresh is needed
    if (self.kpis) {

        // A lot of code just to compare two dates...
        NSDate* lastRefresh = self.kpis.lastRefreshed;
        NSDate* currentDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger components = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents *firstComponents = [calendar components:components fromDate:lastRefresh];
        NSDateComponents *secondComponents = [calendar components:components fromDate:currentDate];
        
        lastRefresh = [calendar dateFromComponents:firstComponents];
        currentDate = [calendar dateFromComponents:secondComponents];
        
/*        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
        [dateformater setDateFormat:@"yyyyMMdd,HH:mm"];
        NSString *str = [dateformater stringFromDate: lastRefresh];*/
        
        if (![lastRefresh isEqualToDate:currentDate])
            return nil;
    }
    
    return [_cache objectForKey:@"week_numbers"];
}

- (NSMutableArray*) getTopLevel {
    
    return [_cache objectForKey:@"toplevel"];
}

- (NSMutableArray*) getDistricts {
    
    return [_cache objectForKey:@"districts"];
}

- (NSMutableArray*) getIPs {
    
    return [_cache objectForKey:@"ips"];
}

- (NSMutableArray*) getFacilities {
    
    return [_cache objectForKey:@"facilities"];
}

- (NSMutableArray*) getFacilitiesReported {
    
    return [_cache objectForKey:@"facilities_reported"];
}

- (NSMutableArray*) getFacilitiesNotReported {
    
    return [_cache objectForKey:@"facilities_not_reported"];
}

- (NSMutableArray*) getFacilitiesNoARVs {
    
    return [_cache objectForKey:@"facilities_no_arvs"];
}

- (NSMutableArray*) getFacilitiesNoTestkits {
    
    return [_cache objectForKey:@"facilities_no_testkits"];
}

- (MXLKPIs*) getKPIs {
    
    if (self.forceKPIRefresh) {
        self.forceKPIRefresh = false;
        return nil;
    }
    
    return (MXLKPIs*)[_cache objectForKey:@"kpis"];
}

- (NSMutableArray*) getWeeklyReports {
    
    return [_cache objectForKey:@"weekly_reports"];
}

#pragma mark Data Loaders

/* loadBunch
 _____________________________________________________________________________________________________________________________ */
// Loads a bunch of data, to be used in general refreshes

- (void) loadBunch {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![MXLSession currentSession].weekNumbers)
        [[MXLSession currentSession] loadWeekNumbers];
    
    [MXLSession currentSession].forceKPIRefresh = true;
    [[MXLSession currentSession] loadKPIs];
    [[MXLSession currentSession] loadFacilities];
    [[MXLSession currentSession] loadFacilitiesNotReported];
    [[MXLSession currentSession] loadFacilitiesWithStockouts];
    [[MXLSession currentSession] loadWeeklyReports];
    [[MXLSession currentSession] loadFacilitiesWithStockouts];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
/*    [_cache removeObjectForKey:@"facilities_no_testkits"];
    [_cache removeObjectForKey:@"facilities_no_arvs"];*/
    
}

/* processMessageWithMessage
 _____________________________________________________________________________________________________________________________ */

- (void) processMessageWithMessage:(NSString*)message dataToCache:(id)dataToCache lastResult:(ResultType)lastResult cacheKey:(NSString*) cacheKey exception:(NSException*) exception {
    
    @synchronized (self) {
        switch (lastResult) {
            case Success: {
                [_cache setObject:dataToCache forKey:cacheKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_success", message] object:dataToCache];

                break;
            }
            case AlreadyInProgress: {
                // Swallow – do nothing, some other thread will post the result in due time
                break;
            }
            case Fail: {
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_fail", message] object:exception];
            }
        }
    }
    
}


/* Returns true if the week numbers were successfully loaded, false otherwise */
/* loadWeekNumbers
 _____________________________________________________________________________________________________________________________ */

- (void) loadWeekNumbers {
    
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* weekNumbers = [retriever loadWeekNumbers];
    [self processMessageWithMessage:@"week_numbers" dataToCache:weekNumbers lastResult:retriever.lastResult cacheKey:@"week_numbers" exception:retriever.lastError];
    
    if (retriever.lastResult == Success & weekNumbers.count > 0)
        if (self.currentWeek == nil) {
            self.currentWeek = ((MXLWeek*) weekNumbers[0]).weekno;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"current_week_changed" object:nil];
        }
}

/* loadEntities
 _____________________________________________________________________________________________________________________________ */

- (void) loadEntities {
    
    // National entity
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* entities = retriever.loadEntities;
    if (entities != nil) {
        if ([entities count] == 3) {
            [self processMessageWithMessage:@"" dataToCache:entities[0] lastResult:retriever.lastResult cacheKey:@"toplevel" exception:retriever.lastError];
            [self processMessageWithMessage:@"" dataToCache:entities[1] lastResult:retriever.lastResult cacheKey:@"districts" exception:retriever.lastError];
            [self processMessageWithMessage:@"entities" dataToCache:entities[2] lastResult:retriever.lastResult cacheKey:@"ips" exception:retriever.lastError];
        }
    }
}

/* loadKPIs
 _____________________________________________________________________________________________________________________________ */

- (void) loadKPIs {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    if (!self.weekNumbers)
        [self loadWeekNumbers];

    MXLKPIs* kpis = [retriever loadKPIsForEntity:self.currentEntity weekno:self.currentWeek];
    self.kpiRefreshNeeded = false;
    @synchronized (self) {
        [self processMessageWithMessage:@"kpis" dataToCache:kpis lastResult:retriever.lastResult cacheKey:@"kpis" exception:retriever.lastError];
        [_cache removeObjectForKey:@"facilities"];  // Remove associated facilities so that they get reloaded
        [_cache removeObjectForKey:@"facilities_reported"];  // Remove associated facilities so that they get reloaded
        [_cache removeObjectForKey:@"facilities_not_reported"];  // Remove associated facilities so that they get reloaded
        [_cache removeObjectForKey:@"weekly_reports"];  // Remove associated facilities so that they get reloaded        
    }
    
    
}

/* loadFacilities
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilities {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* facilities = [retriever loadFacilitiesForEntity:self.currentEntity];
    [self processMessageWithMessage:@"facilities" dataToCache:facilities lastResult:retriever.lastResult cacheKey:@"facilities" exception:retriever.lastError];
}

/* loadFacilitiesReported
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilitiesReported {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* facilities = [retriever loadFacilitiesReportedForEntity:self.currentEntity weekno:self.currentWeek];
    [self processMessageWithMessage:@"facilities_reported" dataToCache:facilities lastResult:retriever.lastResult cacheKey:@"facilities_reported" exception:retriever.lastError];
}

/* loadFacilitiesNotReported
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilitiesNotReported {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* facilities = [retriever loadFacilitiesNotReportedForEntity:self.currentEntity weekno:self.currentWeek];
    [self processMessageWithMessage:@"facilities_not_reported" dataToCache:facilities lastResult:retriever.lastResult cacheKey:@"facilities_not_reported" exception:retriever.lastError];
}

/* loadFacilitiesNoTARVs
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilitiesNoTARVs {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* facilities = [retriever loadFacilitiesWithARVStockoutForEntity:self.currentEntity weekno:self.currentWeek];
    [self processMessageWithMessage:@"facilities_no_arvs" dataToCache:facilities lastResult:retriever.lastResult cacheKey:@"facilities_no_arvs2" exception:retriever.lastError];
}

/* loadFacilitiesNoTestkits
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilitiesNoTestkits {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* facilities = [retriever loadFacilitiesWithTestkitStockoutForEntity:self.currentEntity weekno:self.currentWeek];
    [self processMessageWithMessage:@"facilities_no_testkits" dataToCache:facilities lastResult:retriever.lastResult cacheKey:@"facilities_no_testkits2" exception:retriever.lastError];
}

/* loadFacilitiesWithStockouts
 _____________________________________________________________________________________________________________________________ */

- (void) loadFacilitiesWithStockouts {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* weeklyReports = [retriever loadFacilitiesWithStockoutForEntity:self.currentEntity weekno:self.currentWeek];
    
    if (weeklyReports == nil){
        [self processMessageWithMessage:@"facilities_no_stock" dataToCache:nil lastResult:retriever.lastResult cacheKey:nil exception:retriever.lastError];
        return;
    }
    
    NSMutableArray* noTestkits = [NSMutableArray new];
    NSMutableArray* noARVs = [NSMutableArray new];
    
    for(MXLWeeklyReport *report in weeklyReports) {
        MXLFacility* facility = [MXLFacility new];
        facility.health_facility = report.health_facility;
        facility.district = report.district;
        facility.subcounty = @"N/A";
        facility.facility_level = @"N/A";
        facility.org_unit_group = report.org_unit_group;
        facility.organisationunitid = facility.organisationunitid;
        if ([report.arv_stockout isEqualToString:@"1"]) {
            [noARVs addObject:facility];
        }
        if ([report.test_kit_stockout isEqualToString:@"1"]) {
            [noTestkits addObject:facility];
        }
    }
    
    [self processMessageWithMessage:@"" dataToCache:noTestkits lastResult:retriever.lastResult cacheKey:@"facilities_no_testkits" exception:retriever.lastError];
    
    [self processMessageWithMessage:@"stock_outs" dataToCache:noARVs lastResult:retriever.lastResult cacheKey:@"facilities_no_arvs" exception:retriever.lastError];
}

/* loadFacilitiesNoTestkits
 _____________________________________________________________________________________________________________________________ */

- (void) loadWeeklyReports {
    MXLDataRetriever* retriever = [MXLDataRetriever new];
    NSMutableArray* weeklyReports = [retriever loadWeeklyReportsForEntity:self.currentEntity weekno:self.currentWeek];
    [self processMessageWithMessage:@"weekly_reports" dataToCache:weeklyReports lastResult:retriever.lastResult cacheKey:@"weekly_reports" exception:retriever.lastError];
}



@end
