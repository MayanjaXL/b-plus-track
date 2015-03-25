//
//  MXLWeek.m
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLWeek.h"

@implementation MXLWeek

- (id) initWithWeekNo:(NSString *)weekno displayName:(NSString*)displayName {
    self = [super init];
    if (self) {
        self.weekno = weekno;
        self.displayName = displayName;
    }
    
    return self;
}

- (id) initWithWeekNo:(NSString *)weekno startDate:(NSDate*)startDate endDate:(NSDate*)endDate {
    self = [super init];
    if (self) {
        self.weekno = weekno;
        self.startDate = startDate;
        self.endDate = endDate;
        self.displayName = [NSString stringWithFormat:@"Week ending %@", endDate];
    }
    
    return self;
}

@end
