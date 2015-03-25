//
//  MLXUIViewController.h
//  BPlus_Track
//
//  Created by Fitti Weissglas on 04/07/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXLUIViewController : UIViewController  {

@protected
NSString* observerName;

@protected
bool loadingData;
}

- (void) stopSpinner;
- (void) startSpinner;
- (void) launchLoadData;

@end


