//
//  ViewController.m
//  SQLiteLearning
//
//  Created by PeterWang on 12/26/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "SQLMainViewController.h"

//Model
#import "SQLNationalParkDatabase.h"
#import "SQLNationalPark.h"

//Controller
#import "SQLDetailViewController.h"

@interface SQLMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nationalParkListTableView;

@end

@implementation SQLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"National Parks";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[SQLNationalParkDatabase sharedDatabase] nationalParks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    //Set up the cell.
    SQLNationalPark *info = [[SQLNationalParkDatabase sharedDatabase] nationalParks][indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", info.code, info.type];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SQLDetailViewController *controller = [[SQLDetailViewController alloc] initWithNibName:NSStringFromClass([SQLDetailViewController class]) bundle:[NSBundle mainBundle]];
    SQLNationalPark *info = [[SQLNationalParkDatabase sharedDatabase] nationalParks][indexPath.row];
    controller.nationalParkUniqueId = info.uniqueId;
    
    //Clear bar item title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
