//
//  MXLKPIs.m
//  B+Track
//
//  Created by Fitti Weissglas on 15/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLKPIs.h"

@implementation MXLKPIs
NSMutableDictionary* values;

- (id) init {
    self = [super init];
    if (self) {
        values = [NSMutableDictionary new];
    }
    
    return self;
}

- (void) setFakeData {
    
    [values setObject:@"50" forKey:@"registered_reporting_rate"];
    [values setObject:@"12" forKey:@"facilities_regiistered"];
    [values setObject:@"6" forKey:@"number_of_facilities_reporting"];
    [values setObject:@"6" forKey:@"number_of_facilities_not_reporting"];
    [values setObject:@"Uganda" forKey:@"entity"];
    [values setObject:@"2014W23" forKey:@"weekno"];
    [values setObject:@"Week ending 1 Jun 2014" forKey:@"weekno_display_name"];
    self.lastRefreshed = [NSDate date];
}

- (id) getKPIWithName:(NSString*) kpiName {
    
    return [values objectForKey:kpiName];
}

- (void) setKPIWithName:(NSString*) kpiName object:(id) object {
    
    [values setObject:object forKey:kpiName];
}

- (void) setKPIsWithDictionary:(NSDictionary*) newDictionary {
    values = [NSMutableDictionary dictionaryWithDictionary:newDictionary];
    
    /* Prettify */
    
    self.facilitiesReporting = [[values objectForKey:@"reports_received"] integerValue];
    self.numberOfFacilities = [[values objectForKey:@"facilities_registered"] integerValue];
    self.facilitiesNotReporting = self.numberOfFacilities - self.facilitiesReporting;
    self.reportingRate = [[values objectForKey:@"registered_reporting_rate"] integerValue];
    self.reportingRateString = [NSString stringWithFormat:@"%i%%", (int) self.reportingRate];

    self.weekno = [values objectForKey:@"weekno"];
    self.entity = [values objectForKey:@"entity"];
    self.lastRefreshed = [NSDate date];
    
    /* ANC1 */
    self.noOfANC1Visits = [[values objectForKey:@"no_anc1_visits"] integerValue];
    self.noTestedForHIV = [[values objectForKey:@"no_tested_hiv"] integerValue];
    self.noTestedPositiveForHIV = [[values objectForKey:@"no_tested_pos"] integerValue];
    self.noAtndKnownStatus = [[values objectForKey:@"no_atnd_known_status"] integerValue];
    self.noInitiatedART = [[values objectForKey:@"no_initiated"] integerValue];
    self.noAlreadyOnART = [[values objectForKey:@"no_already_on_art"] integerValue];
    self.noMissedAppointments = [[values objectForKey:@"no_missed_appointments"] integerValue];
    
    self.testKitStockouts = [[values objectForKey:@"test_kit_stockout"] integerValue];
    self.arvStockouts = [[values objectForKey:@"arv_stockout"] integerValue];
    
    self.propTested = [[values objectForKey:@"pct_total_tested"] doubleValue];
    self.propInitiated = [[values objectForKey:@"pct_total_initiated"] doubleValue];
    self.propTestedPositive =  (double) self.noTestedPositiveForHIV  / (double) self.noTestedForHIV;
    
    /* EID */
    self.noEIDTests = [[values objectForKey:@"no_children_tested"] integerValue];
    self.noEIDTestsPositive = [[values objectForKey:@"no_children_tested_positive"] integerValue];
    self.propEIDPositive = ((double) self.noEIDTestsPositive / (double) self.noEIDTests * 100);
    
    self.eidDateImported = [values objectForKey:@"eid_date_imported"];
    self.eidMonth = [values objectForKey:@"eid_month"];
    
    NSLog(@"%@", self.lastRefreshed);
    
}

@end
