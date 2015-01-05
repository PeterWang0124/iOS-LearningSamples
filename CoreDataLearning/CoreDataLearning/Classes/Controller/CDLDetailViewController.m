//
//  CDLDetailViewController.m
//  CoreDataLearning
//
//  Created by PeterWang on 12/30/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "CDLDetailViewController.h"

//Model
#import "CDLNationalParkInfo.h"
#import "CDLNationalParkDetail.h"

@interface CDLDetailViewController ()

@property (strong, nonatomic) CDLNationalParkDetail *nationalParkDetail;

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
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nationalParkDetail:(CDLNationalParkDetail *)newNationalParkDetail {
    if (_nationalParkDetail != newNationalParkDetail) {
        _nationalParkDetail = newNationalParkDetail;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.nationalParkDetail) {
        CDLNationalParkInfo *info = self.nationalParkDetail.info;
        self.parkNameLabel.text = info.name;
        self.parkTypeLabel.text = info.type;
        self.parkCodeLabel.text = info.code;
        
        self.parkNoteTextView.text = self.nationalParkDetail.note;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        NSLog(@"%@", [formatter stringFromDate:self.nationalParkDetail.updateTime]);
        self.updateTimeLabel.text = [formatter stringFromDate:self.nationalParkDetail.updateTime];
    }
}

@end
