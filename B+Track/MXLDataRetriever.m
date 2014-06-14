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
#import "mxlAppDelegate.h"


@interface MXLDataRetriever(JSon)
+ (NSArray*) jsonGetEntities:(NSString*)level;

@end

@implementation MXLDataRetriever(JSon)

NSString * const urlGetEntities = @"http://dhis2sms.ug:8080/BPlusWS/services/BPlusWS/getEntities?level=%@&response=application/json";
NSString * const urlGetWeeks = @"http://dhis2sms.ug:8080/BPlusWS/services/BPlusWS/getWeeks?max=%i&response=application/json";


#pragma mark JSon Data Retrieval

/* Retrieves JSon for a level */
+ (NSArray*) jsonGetEntities:(NSString*)level {
    
    NSLog(@"JSon Entities: %@", [NSThread currentThread]);
    NSString* requestURL = [NSString stringWithFormat:urlGetEntities, level];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *entities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    NSLog(@"retrieved entities");
    return entities;
}

+ (NSMutableArray*) jsonGetWeeksWithMax:(int)max {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetWeeks, max];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonWeeks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    NSLog(@"retrieved weeks");
    
    NSMutableArray* weeks = [NSMutableArray new];
    for(NSDictionary *item in jsonWeeks) {
        NSLog(@"%@", [item objectForKey:@"weekno"]);
        [weeks addObject:[[MXLWeek alloc] initWithWeekNo:[item objectForKey:@"weekno"]
                                               startDate:[item objectForKey:@"startdate"]
                                                 endDate:[item objectForKey:@"enddate"]]];
    }
    return weeks;
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


bool const fakeData = false;;
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
    queue = [NSOperationQueue new];
    _cache = [NSCache new];
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

/* GetWeekNumbersWithCached */
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
            weekNumbers = [self jsonGetWeeksWithMax:20];
        }
        [_cache setObject:weekNumbers forKey:@"week_numbers"];
    }

    return [_cache objectForKey:@"week_numbers"];
}

+ (NSMutableArray*) getCurrentWeekNumberWithCached:(bool)cached {
    
    NSMutableArray* weekNumber;
    
    if (![_cache objectForKey:@"current_week_number"] || !cached) {
        if (fakeData) {
            [weekNumber addObject: ([[MXLWeek alloc] initWithWeekNo:@"2014W23" displayName:@"Week ending 6-10-2014"])];
            sleep(2);
        }
        else {
            weekNumber = [self jsonGetWeeksWithMax:1];
        }
        [_cache setObject:weekNumber forKey:@"current_week_number"];
    }
    
    return [_cache objectForKey:@"current_week_number"];
}


+ (void) simulateBackgroundLoadOfData {
    
    //@synchronized (self) {
    @synchronized (self) {
    
        if (backgroundLoad) {
            NSLog(@"Additional request ignored");
            return; // Do not load if already loading
        }
    
        backgroundLoad = true;
    }
    NSLog(@"Background log starting");
    sleep(5);
    @synchronized (self) {
            backgroundLoad =  false;
    }
    @synchronized (self) {
        mxlAppDelegate* appDelegate = (mxlAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.Session DoCurrentSessionRefreshed];
        NSLog(@"%@", appDelegate.Session.latestRefresh);
    }
    NSLog(@"Background log finished");
    //}
}


/* getEntitiesWithLevel */
+ (NSMutableArray*) getEntitiesWithLevel:(int)level {
    
    NSMutableArray* returnValue = [[NSMutableArray alloc] init];
//    NSLog(@"Loading data for %@", [NSThread currentThread]);

    switch (level) {
        case 1:{        // National
            if (fakeData) {
                [returnValue addObject: ([[MXLEntity alloc] initWithName:@"Uganda" type:@"National" level:@"National"])];
                sleep(1);
                NSLog(@"Wait sleep... %d", self.ThreadCount);
                
            }
            else {
            NSArray* entities = [self jsonGetEntities:@"National"];
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
            NSArray* entities = [self jsonGetEntities:@"District"];
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
            NSArray* entities = [self jsonGetEntities:@"IP"];
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


@end

    

