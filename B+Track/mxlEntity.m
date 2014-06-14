//
//  mxlEntity.m
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLEntity.h"

@implementation MXLEntity

- (id) initWithName:(NSString *)name type:(NSString*)type level:(NSString*)level;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.level = level;
        self.type = type;
    }
    return self;
}


@end
