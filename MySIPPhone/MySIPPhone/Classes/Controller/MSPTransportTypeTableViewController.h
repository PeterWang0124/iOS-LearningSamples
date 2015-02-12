//
//  MSPTransportTypeTableViewController.h
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSPTransportTypeTableViewControllerDelegate <NSObject>

- (void)transportTypeDidSelectedByType:(NSInteger)transportType;

@end

@interface MSPTransportTypeTableViewController : UITableViewController

@property (weak, nonatomic) id<MSPTransportTypeTableViewControllerDelegate> transportTypeDelegate;

@end
