//
//  TableViewController.m
//  TableViewTest
//
//  Created by PeterWang on 1/27/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Test%zd_%zd", indexPath.section, indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(section , row) = (%zd, %zd)", indexPath.section, indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetailViewController *dvc = (DetailViewController *)segue.destinationViewController;
        dvc.detail = [NSString stringWithFormat:@"Test Table View Cell at section : %zd, row : %zd", indexPath.section, indexPath.row];
    }
}

@end
