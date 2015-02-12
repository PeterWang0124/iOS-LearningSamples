//
//  MSPTransportTypeTableViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/12/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "MSPTransportTypeTableViewController.h"

@interface MSPTransportTypeTableViewController ()

@end

@implementation MSPTransportTypeTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select : %zd", indexPath.row);
    if ([self.transportTypeDelegate respondsToSelector:@selector(transportTypeDidSelectedByType:)]) {
        [self.transportTypeDelegate transportTypeDidSelectedByType:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"MSPTransportTypeTableViewController prepareForSegue");
}

@end
