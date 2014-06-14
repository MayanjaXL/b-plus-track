//
//  mxlFacility.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLFacility : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *level;
@property (strong,nonatomic) NSString *district;
@property (strong,nonatomic) NSString *subcounty;
@property (strong,nonatomic) NSString *ip;

- (id) initWithName:(NSString *)name level:(NSString*)level district:(NSString*)district subcounty:(NSString*)subcounty ip:(NSString*)ip;


@end
