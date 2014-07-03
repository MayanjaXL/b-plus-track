//
//  MXLDataRetrieveer.h
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXLKPIs.h"


@interface MXLDataRetriever : NSObject

typedef enum {
    Success,
    Fail,
    AlreadyInProgress
} ResultType;

typedef enum {
    National,
    District,
    IP
} EntityType;

typedef enum {
    AllFacilities,
    NotReported,
    Reported,
    ARVStockout,
    TestkitStockout
} FacilityRequestType;


@property NSException* lastError;
@property ResultType lastResult;

+ (NSMutableArray*) getEntitiesWithLevel:(int)level Cached:(bool)cached;
+ (NSMutableArray*) getWeekNumbersWithCached:(bool)cached;
+ (NSMutableArray*) getCurrentWeekNumberWithCached:(bool)cached;
+ (void) cacheMetaData;
+ (bool) dataIsCached;
+ (void) clearCache;
+ (int)ThreadCount;
+ (void)setThreadCount:(int)newThreadCount;
+ (NSOperationQueue*) Queue;
+ (void) simulateBackgroundLoadOfData;


- (NSMutableArray*) loadWeekNumbers;
- (NSMutableArray*) loadEntitiesForType:(EntityType)entityType;
- (NSMutableArray*) loadEntities;
- (MXLKPIs*) loadKPIsForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadFacilitiesForEntity:(NSString*) entity;
- (NSMutableArray*) loadFacilitiesReportedForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadFacilitiesNotReportedForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadFacilitiesWithTestkitStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadFacilitiesWithARVStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadFacilitiesWithStockoutForEntity:(NSString*) entity weekno:(NSString*) weekno;
- (NSMutableArray*) loadWeeklyReportsForEntity:(NSString*) entity weekno:(NSString*) weekno;

@end
