//
//  MXLWeeklyReport.h
//  B+Track
//
//  Created by Fitti Weissglas on 18/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLWeeklyReport : NSObject

@property NSString* weekno;
@property NSString* health_facility;
@property NSString* organisationunitid;
@property NSString* org_unit_group;
@property NSString* district;
@property NSString* no_anc1_visits;
@property NSString* no_tested_hiv;
@property NSString* no_tested_pos;
@property NSString* no_atnd_known_status;
@property NSString* no_initiated;
@property NSString* no_already_on_art;
@property NSString* no_missed_appointments;
@property NSString* test_kit_stockout;
@property NSString* arv_stockout;
@property NSString* week_complete;
@property NSString* pct_total_tested;
@property NSString* pct_total_initiated;
@property NSString* art_accredited;
@property NSString* facility_level;
@property NSString* delivery_zone;
@property NSString* region;
@property NSString* reported;

@end
