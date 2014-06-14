//
//  mxlEntity.h
//  B+Track
//
//  Created by Fitti Weissglas on 11/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLEntity : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *level;

- (id) initWithName:(NSString *)name type:(NSString*)type level:(NSString*)level;


@end
