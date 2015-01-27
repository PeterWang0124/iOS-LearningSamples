//
//  DetailViewController.m
//  TableViewTest
//
//  Created by PeterWang on 1/27/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.detailLabel.text = self.detail;
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    self.detailLabel.text = detail;
}

@end
