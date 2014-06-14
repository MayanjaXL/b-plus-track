//
//  MXLDataRetrieveer.h
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLDataRetriever : NSObject

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

@end
