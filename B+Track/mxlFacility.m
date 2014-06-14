//
//  mxlFacility.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLFacility.h"

@implementation MXLFacility


- (instancetype)initWithName:(NSString *)name level:(NSString*)level district:(NSString*)district subcounty:(NSString*)subcounty ip:(NSString*)ip
{
    self = [super init];
    if (self) {
        self.name = name;
        self.level = level;
        self.district = district;
        self.subcounty = subcounty;
        self.ip = ip;
    }
    return self;
}


@end
