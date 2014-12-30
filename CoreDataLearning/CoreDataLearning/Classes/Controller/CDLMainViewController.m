//
//  CDLMainViewController.m
//  CoreDataLearning
//
//  Created by PeterWang on 12/30/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "CDLMainViewController.h"

//Model
#import "CDLNationalParkInfo.h"

@interface CDLMainViewController ()

@property (strong, nonatomic) NSArray *nationalParkInfos;

@end

@implementation CDLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CDLNationalParkInfo class]) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.nationalParkInfos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.title = @"National Parks";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nationalParkInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //Set up the cell.
    CDLNationalParkInfo *info = self.nationalParkInfos[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", info.code, info.type];
    
    return cell;
}

@end
