//
//  MXLCurrentSession.h
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXLKPIs.h"

#define kDefaultEntity        @"default_entity"
#define kBadge              @"badge"
#define kAutoRefresh        @"auto_refresh"

#define badgeNever          2
#define badgeStockouts      1
#define badgeReportingRate  0


@class MXLSession;

@protocol MXLCurrentSessionRefreshedDelegate <NSObject>
- (void)currentSessionRefreshed:(MXLSession*)session;

@end



@interface MXLSession : NSObject

/* Settings */
@property (readonly, getter=getRefreshAutomatically) bool refreshAutomatically;
@property (readonly, getter=getBadgeIcon) int badgeIcon;

/* Current Session */

@property NSString* currentWeek;
@property NSString* currentEntity;
@property bool kpiRefreshNeeded;
//@property bool forceWeekRefresh;
@property NSDate* latestRefresh;
@property (nonatomic, weak) id <MXLCurrentSessionRefreshedDelegate> delegate;
@property bool forceKPIRefresh;

- (void) DoCurrentSessionRefreshed;
+ (MXLSession*) currentSession;


/* new */

@property (readonly, getter=getWeekNumbers) NSMutableArray* weekNumbers;
@property (readonly, getter=getTopLevel) NSMutableArray* topLevel;
@property (readonly, getter=getDistricts) NSMutableArray* districts;
@property (readonly, getter=getIPs) NSMutableArray* ips;
@property (readonly, getter=getKPIs) MXLKPIs* kpis;
@property (readonly, getter=getFacilities) NSMutableArray* facilities;
@property (readonly, getter=getFacilitiesReported) NSMutableArray* facilitiesReported;
@property (readonly, getter=getFacilitiesNotReported) NSMutableArray* facilitiesNotReported;
@property (readonly, getter=getFacilitiesNoARVs) NSMutableArray* facilitiesNoARVs;
@property (readonly, getter=getFacilitiesNoTestkits) NSMutableArray* facilitiesNoTestkits;
@property (readonly, getter=getWeeklyReports) NSMutableArray* weeklyReports;


- (void) clearCache;
- (void) loadBunch;
- (void) loadWeekNumbers;
- (void) loadEntities;
- (void) loadKPIs;
- (void) loadFacilities;
- (void) loadFacilitiesReported;
- (void) loadFacilitiesNotReported;
/*- (void) loadFacilitiesNoTARVs;
- (void) loadFacilitiesNoTestkits;*/
- (void) loadFacilitiesWithStockouts;
- (void) loadWeeklyReports;

@end
