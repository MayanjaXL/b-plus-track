//
//  MXLDataRetrieveer.m
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLDataRetriever.h"
#import "mxlEntity.h"
#import "MXLWeek.h"
#import "MXLSession.h"
#import "MXLKPIs.h"
#import "mxlAppDelegate.h"
#import "NSString+Encode.h"
#import "mxlFacility.h"
#import "MXLJson.h"





/* Handles concurrency and locking */
@implementation MXLDataRetriever(ConcurrencyHandler)
static NSCache* _lock;

+ (bool) operationIsLockedWithName:(NSString*)name {

    return [_lock objectForKey:name] != nil;
}

+ (void) lockOperationWithName:(NSString*)name {
    
    [_lock setObject:@"Locked" forKey:name];
}

+ (void) unlockOperationWithName:(NSString*)name {
    [_lock removeObjectForKey:name];
}

/// Returns: true if the operation indeed started, false if it was already on the way
/// Operations should not continue if this method returns false;
+ (bool) startOperation:(NSString*)name {

    if ([self operationIsLockedWithName:name]) {
        return false;
    }
    @synchronized (self) {
        [self lockOperationWithName:name];
    }
    return true;
}

/// Remember to include this statement in a "finally" block.
+ (void) finishOperation:(NSString*)name {

    @synchronized (self) {
        [self unlockOperationWithName:name];
    }
}


@end


@implementation MXLDataRetriever

#pragma mark Static variables
static NSCache* _cache;             // Keeps the meta-data
static NSCache* _currentData;       // Keeps the current data, e.g. KPIs and the current week

static int threadCount;
static NSOperationQueue* queue;
static bool backgroundLoad;
static bool backgroundLoadMetaData;


bool const fakeData = false;
bool const keepCache = true;

#pragma mark Properties

+ (int)ThreadCount {
    return threadCount;
}

+ (void)setThreadCount:(int)newThreadCount {
    threadCount = newThreadCount;
}

+ (NSOperationQueue*) Queue {
    return queue;
}



#pragma mark Public

+ (void) initialize {
    [super initialize];
    queue = [NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:1];
    _cache = [NSCache new];
    _lock = [NSCache new];
    backgroundLoad = false;
    backgroundLoadMetaData = false;
}

/// Caches all META data in advance
+ (void) cacheMetaData {

    [self getEntitiesWithLevel:1 Cached:true];
    [self getEntitiesWithLevel:2 Cached:true];
    [self getEntitiesWithLevel:3 Cached:true];
    [self getWeekNumbersWithCached:true];
    [self getCurrentWeekNumberWithCached:true];
}

/* DataIsCached */
+ (bool) dataIsCached {
    
    //    return cacheToplevel != nil && cacheDistricts != nil && cacheIPs != nil & cacheWeekNumbers != nil;
    return [_cache objectForKey:@"ip_entities"] != nil;
}

/* ClearCache */
+ (void) clearCache {
    // Clears the cache
    [_cache removeAllObjects];
}

#pragma mark Exposed Data Retrieval Methods

/* getWeekNumbersWithCached
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) getWeekNumbersWithCached:(bool)cached {
    
    NSMutableArray* weekNumbers;
    
    if (![_cache objectForKey:@"week_numbers"] || !cached) {
        if (fakeData) {
            [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W23" displayName:@"Week ending 6-10-2014"])];
            [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W22" displayName:@"Week ending 6-10-2014"])];
            [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W21" displayName:@"Week ending 6-10-2014"])];
            sleep(2);
        }
        else {
            weekNumbers = [MXLJson jsonGetWeeksWithMax:20];
        }
        [_cache setObject:weekNumbers forKey:@"week_numbers"];
    }

    return [_cache objectForKey:@"week_numbers"];
}

/* getCurrentWeekNumberWithCached
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) getCurrentWeekNumberWithCached:(bool)cached {
    
    NSMutableArray* weekNumber;
    
    if (![_cache objectForKey:@"current_week_number"] || !cached) {
        if (fakeData) {
            [weekNumber addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W23" displayName:@"Week ending 6-10-2014"])];
            sleep(2);
        }
        else {
            weekNumber = [MXLJson jsonGetWeeksWithMax:1];
        }
        [_cache setObject:weekNumber forKey:@"current_week_number"];
    }
    
    return [_cache objectForKey:@"current_week_number"];
}



/* simulateBackgroundLoadOfData
 _____________________________________________________________________________________________________________________________ */

+ (void) simulateBackgroundLoadOfData {
    
    if ([self startOperation:@"background_simulation"]) {
        sleep(5);
        [[MXLSession currentSession] DoCurrentSessionRefreshed];
        [self finishOperation:@"background_simulation"];
    }
    

    
}


/* getEntitiesWithLevel
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) getEntitiesWithLevel:(int)level {
    
    NSMutableArray* returnValue = [[NSMutableArray alloc] init];

    switch (level) {
        case 1:{        // National
            if (fakeData) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Uganda" type:@"National" level:@"National"])];
                sleep(1);
                
            }
            else {
            NSArray* entities = [MXLJson jsonGetEntities:@"National"];
            for(NSDictionary *item in entities) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:[item objectForKey:@"entity"] type:@"National" level:@"National"])];
            }
            }
            break;
        }
        case 2:{        // District
            if (fakeData) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Kampala" type:@"District" level:@"District"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Jinja" type:@"District" level:@"District"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Wakiso" type:@"District" level:@"District"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Butaleja" type:@"District" level:@"District"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Mukono" type:@"District" level:@"District"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Mubende" type:@"District" level:@"District"])];
                sleep(1);

            }
            else {
            NSArray* entities = [MXLJson jsonGetEntities:@"District"];
            for(NSDictionary *item in entities) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:[item objectForKey:@"entity"] type:@"District" level:@"District"])];
            }
            }
            //[NSException raise:@"Invalid foo value" format:@"foo of %d is invalid", 12];
            break;
        }
        case 3:{ // IPs
            if (fakeData) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Baylor" type:@"IP" level:@"IP"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"STAR-SW" type:@"IP" level:@"IP"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Reach Out" type:@"IP" level:@"IP"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"TASO" type:@"IP" level:@"IP"])];
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"CUAMM" type:@"IP" level:@"IP"])];
                sleep(1);
            }
            else {
            NSArray* entities = [MXLJson jsonGetEntities:@"IP"];
            for(NSDictionary *item in entities) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:[item objectForKey:@"entity"] type:@"IP" level:@"IP"])];
            }
            }
            break;
        }
    }
    
//    NSLog(@"Finished loading data for %@", [NSThread currentThread]);
    
    return returnValue;
}




#pragma mark -

/* GetEntitiesWithLevel */
+ (NSMutableArray*) getEntitiesWithLevel:(int)level Cached:(bool)cached {
    
    
    if (!keepCache) {
        [MXLDataRetriever clearCache];
    }
    switch (level) {
        case 1:{
            if (![_cache objectForKey:@"national_entities"] || !cached) {
                [_cache setObject:[MXLDataRetriever getEntitiesWithLevel:level] forKey:@"national_entities"];
            }
            return [_cache objectForKey:@"national_entities"];
        }
        case 2: {
            if (![_cache objectForKey:@"district_entities"] || !cached) {
                [_cache setObject:[MXLDataRetriever getEntitiesWithLevel:level] forKey:@"district_entities"];
            }
            return [_cache objectForKey:@"district_entities"];
        }
        case 3: {
            if (![_cache objectForKey:@"ip_entities"] || !cached) {
                [_cache setObject:[MXLDataRetriever getEntitiesWithLevel:level] forKey:@"ip_entities"];
            }
            return [_cache objectForKey:@"ip_entities"];
        }
         
    }
    
    return nil;
}

#pragma mark Instance Methods (Data Loaders) 

- (NSMutableArray*) loadWeekNumbers {
    
    NSMutableArray* weekNumbers = [NSMutableArray new];
    
    if ([MXLDataRetriever startOperation:@"week_numbers"]) {
        @try {
            if (fakeData) {
                [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W23" displayName:@"Week ending 6-10-2014"])];
                [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W22" displayName:@"Week ending 6-10-2014"])];
                [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W21" displayName:@"Week ending 6-10-2014"])];
                [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W20" displayName:@"Week ending 6-10-2014"])];
                [weekNumbers addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W19" displayName:@"Week ending 6-10-2014"])];
                sleep(3);
            }
            else {
                weekNumbers = [MXLJson jsonGetWeeksWithMax:15];
            }
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            weekNumbers = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"week_numbers"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    
    return weekNumbers;
}

- (NSMutableArray*) loadEntitiesForType:(EntityType)entityType {
    
    NSMutableArray* entities = [NSMutableArray new];
    
    @try {
        switch (entityType) {
            case National:{        // National
                if (fakeData) {
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Uganda" type:@"National" level:@"National"])];
                    sleep(1);
                }
                else {
                    entities = [MXLJson jsonGetEntities:@"National"];
                }
                break;
            }
            case District:{        // District
                if (fakeData) {
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Kampala" type:@"District" level:@"District"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Jinja" type:@"District" level:@"District"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Wakiso" type:@"District" level:@"District"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Butaleja" type:@"District" level:@"District"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Mukono" type:@"District" level:@"District"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Mubende" type:@"District" level:@"District"])];
                    sleep(1);
                }
                else {
                    entities = [MXLJson jsonGetEntities:@"District"];
                }
                break;
            }
            case IP:{ // IPs
                if (fakeData) {
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Baylor" type:@"IP" level:@"IP"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"STAR-SW" type:@"IP" level:@"IP"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"Reach Out" type:@"IP" level:@"IP"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"TASO" type:@"IP" level:@"IP"])];
                    [entities addObject: ([[MXLEntity alloc] initWithName:@"CUAMM" type:@"IP" level:@"IP"])];
                    sleep(1);
                }
                else {
                    entities = [MXLJson jsonGetEntities:@"IP"];
                }
                break;
            }
        }
    }
    @catch (NSException* exception) {
        _lastError = exception;
        _lastResult = Fail;
        entities = nil;
    }
    @finally {
        [MXLDataRetriever finishOperation:[NSString stringWithFormat:@"entities_%i", entityType]];
    }

    return entities;
}

/* loadEntities
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadEntities {
    
    NSMutableArray* entities = [NSMutableArray new];
    
    if ([MXLDataRetriever startOperation:@"entities"]) {
        @try {
            NSMutableArray* topLevel = [self loadEntitiesForType:National];
            if (_lastResult != Success) {
                return nil;
            }
            NSMutableArray* districts = [self loadEntitiesForType:District];
            if (_lastResult != Success) {
                return nil;
            }
            NSMutableArray* ips = [self loadEntitiesForType:IP];
            if (_lastResult != Success) {
                return nil;
            }
            [entities addObject:topLevel];
            [entities addObject:districts];
            [entities addObject:ips];
        }
        
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            entities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"entities"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    
    return entities;
}

/* loadKPIsForEntity
 _____________________________________________________________________________________________________________________________ */

- (MXLKPIs*) loadKPIsForEntity:(NSString*) entity weekno:(NSString*) weekno {
    
    MXLKPIs* kpis;
    
    if ([MXLDataRetriever startOperation:@"kpis"]) {
        @try {
            if (fakeData) {
                kpis = [MXLKPIs new];
                [kpis setFakeData];
                sleep(3);
            }
            else {
                kpis = [MXLJson jsonGetKPIsForEntity:entity weekno:weekno];
            }
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            kpis = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"kpis"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    
    return kpis;
}

/* loadFacilitiesForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesForEntity:(NSString*) entity {
    
    NSMutableArray* facilities;
    
    if ([MXLDataRetriever startOperation:@"facilities"]) {
        @try {
            facilities = [MXLJson jsonGetFaciltiessForEntity:entity weekno:nil requestType:AllFacilities];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            facilities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return facilities;
}

/* loadFacilitiesReportedForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesReportedForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* facilities;
    
    if ([MXLDataRetriever startOperation:@"facilities_reported"]) {
        @try {
            facilities = [MXLJson jsonGetFaciltiessForEntity:entity weekno:weekno requestType:Reported];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            facilities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities_reported"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return facilities;
}

/* loadFacilitiesNotReportedForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesNotReportedForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* facilities;
    
    if ([MXLDataRetriever startOperation:@"facilities_not_reported"]) {
        @try {
            facilities = [MXLJson jsonGetFaciltiessForEntity:entity weekno:weekno requestType:NotReported];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            facilities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities_not_reported"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return facilities;
}

/* loadFacilitiesWithARVStockoutForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesWithARVStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* facilities;
    
    if ([MXLDataRetriever startOperation:@"facilities_no_arvs"]) {
        @try {
            facilities = [MXLJson jsonGetFaciltiessForEntity:entity weekno:weekno requestType:ARVStockout];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            facilities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities_no_arvs"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return facilities;
}

/* loadFacilitiesWithTestkitStockoutForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesWithTestkitStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* facilities;
    
    if ([MXLDataRetriever startOperation:@"facilities_no_testkits"]) {
        @try {
            facilities = [MXLJson jsonGetFaciltiessForEntity:entity weekno:weekno requestType:TestkitStockout];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            facilities = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities_no_testkits"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return facilities;
}

/* loadFacilitiesWithStockoutForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadFacilitiesWithStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* weeklyReports;
    
    if ([MXLDataRetriever startOperation:@"facilities_stockouts"]) {
        @try {
            weeklyReports = [MXLJson jsonGetStockOutsForEntity:entity weekno:weekno];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            weeklyReports = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"facilities_stockouts"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return weeklyReports;
}

/* loadWeeklyReportsForEntity
 _____________________________________________________________________________________________________________________________ */

- (NSMutableArray*) loadWeeklyReportsForEntity:(NSString*) entity weekno:(NSString*) weekno  {
    
    NSMutableArray* weeklyReports;
    
    if ([MXLDataRetriever startOperation:@"weekly_reports"]) {
        @try {
            weeklyReports = [MXLJson jsonGetWeeklyReportsForEntity:entity weekno:weekno];
            _lastResult = Success;
        }
        @catch (NSException* exception) {
            _lastError = exception;
            _lastResult = Fail;
            weeklyReports = nil;
        }
        @finally {
            [MXLDataRetriever finishOperation:@"weekly_reports"];
        }
    }
    else {
        _lastResult = AlreadyInProgress;
    }
    return weeklyReports;
}

@end



