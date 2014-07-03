//
//  MXLTableViewController.h
//  B+Track
//
//  Created by Fitti Weissglas on 14/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXLTableViewController;

@protocol MXLTableViewControllerDelegate <NSObject>

- (void)didSelectEntity:(MXLTableViewController *)controller selectedEntity:(id)item;


@end


@interface MXLTableViewController : UITableViewController
<UISearchBarDelegate> {

    @protected
    NSString* observerName;
    
@protected
    bool loadingData;
}

@property (nonatomic, weak) id <MXLTableViewControllerDelegate> delegate;

- (void) stopSpinner;
- (void) startSpinner;
- (void) launchLoadData;
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;*/

@end
