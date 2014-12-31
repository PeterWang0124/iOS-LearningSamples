//
//  CDLDetailViewController.m
//  CoreDataLearning
//
//  Created by PeterWang on 12/30/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "CDLDetailViewController.h"

@interface CDLDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *parkNoteTextView;

@end

@implementation CDLDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
