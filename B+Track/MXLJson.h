//
//  MXLDataRetriever+JSON.h
//  B+Track
//
//  Created by Fitti Weissglas on 17/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXLKPIs.h"
#import "MXLDataRetriever.h"

@interface MXLJson : NSObject

+ (NSMutableArray*) jsonGetEntities:(NSString*)level;
+ (NSMutableArray*) jsonGetWeeksWithMax:(int)max;
+ (MXLKPIs*) jsonGetKPIsForEntity:(NSString*) entity weekno:(NSString*) weekno;
+ (NSMutableArray*) jsonGetFaciltiessForEntity:(NSString*) entity weekno:(NSString*) weekno requestType:(FacilityRequestType) requestType;
+ (NSMutableArray*) jsonGetStockOutsForEntity:(NSString*) entity weekno:(NSString*) weekno;
+ (NSMutableArray*) jsonGetWeeklyReportsForEntity:(NSString*) entity weekno:(NSString*) weekno;

@end


