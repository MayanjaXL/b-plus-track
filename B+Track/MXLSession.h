//
//  MXLCurrentSession.h
//  B+Track
//
//  Created by Fitti Weissglas on 13/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXLSession;

@protocol MXLCurrentSessionRefreshedDelegate <NSObject>
- (void)currentSessionRefreshed:(MXLSession*)session;

@end

@interface MXLSession : NSObject

@property (nonatomic) NSString* currentWeek;
@property (nonatomic) NSString* currentEntity;
@property NSDate* latestRefresh;
@property (nonatomic, weak) id <MXLCurrentSessionRefreshedDelegate> delegate;

- (void) DoCurrentSessionRefreshed;
+ (MXLSession*) currentSession;


@end
