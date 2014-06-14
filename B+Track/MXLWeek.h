//
//  MXLWeek.h
//  B+Track
//
//  Created by Fitti Weissglas on 12/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLWeek : NSObject

@property (strong,nonatomic) NSString* weekno;
@property (strong,nonatomic) NSString* displayName;
@property (strong,nonatomic) NSDate* startDate;
@property (strong,nonatomic) NSDate* endDate;

- (id) initWithWeekNo:(NSString *)weekno displayName:(NSString*)displayName;

- (id) initWithWeekNo:(NSString *)weekno startDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
