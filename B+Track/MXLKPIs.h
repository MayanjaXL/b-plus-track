//
//  MXLKPIs.h
//  B+Track
//
//  Created by Fitti Weissglas on 15/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLKPIs : NSObject

@property NSDate* lastRefreshed;

/* Reporting */
@property NSInteger facilitiesReporting;
@property NSInteger numberOfFacilities;
@property NSInteger facilitiesNotReporting;
@property NSInteger reportingRate;
@property NSString* reportingRateString;

/* ANC */
@property NSInteger noOfANC1Visits;
@property NSInteger noTestedForHIV;
@property NSInteger noTestedPositiveForHIV;
@property NSInteger noAtndKnownStatus;
@property NSInteger noInitiatedART;
@property NSInteger noAlreadyOnART;
@property NSInteger noMissedAppointments;

@property NSInteger testKitStockouts;
@property NSInteger arvStockouts;

@property double propTested;
@property double propInitiated;
@property double propTestedPositive;

@property NSInteger noEIDTests;
@property NSInteger noEIDTestsPositive;
@property double propEIDPositive;

@property NSString* eidDateImported;
@property NSString* eidMonth;


/* Week and Entity */
@property NSString* weekno;
@property NSString* entity;


- (id) getKPIWithName:(NSString*) kpiName;
- (void) setKPIWithName:(NSString*) kpiName object:(id) object;
- (void) setFakeData;
- (void) setKPIsWithDictionary:(NSDictionary*) newDictionary;


@end
