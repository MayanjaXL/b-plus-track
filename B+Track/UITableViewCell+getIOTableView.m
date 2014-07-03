//
//  UITableViewCell+getIOTableView.m
//  BPlus_Track
//
//  Created by Fitti Weissglas on 01/07/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "UITableViewCell+getIOTableView.h"

@implementation UITableViewCell (ParentTableView)


- (UITableView *)parentTableView {
    UITableView *tableView = nil;
    UIView *view = self;
    while(view != nil) {
        if([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
            break;
        }
        view = [view superview];
    }
    return tableView;
}


@end