//
//  ViewController.m
//  SQLiteLearning
//
//  Created by PeterWang on 12/26/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "ViewController.h"
#import "SQLNationalParkDatabase.h"
#import "SQLNationalParkInfo.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nationalParkListTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"National Parks";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[SQLNationalParkDatabase sharedDatabase] nationalParkInfos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    //Set up the cell.
    SQLNationalParkInfo *info = [[SQLNationalParkDatabase sharedDatabase] nationalParkInfos][indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 info.code, info.type];
    
    return cell;
}

@end
