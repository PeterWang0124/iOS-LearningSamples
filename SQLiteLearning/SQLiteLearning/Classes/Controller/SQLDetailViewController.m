//
//  SQLDetailViewController.m
//  SQLiteLearning
//
//  Created by PeterWang on 12/29/14.
//  Copyright (c) 2014 PeterWang. All rights reserved.
//

#import "SQLDetailViewController.h"

//Model
#import "SQLNationalParkDatabase.h"
#import "SQLNationalPark.h"

@interface SQLDetailViewController ()

@property (strong, nonatomic) SQLNationalPark *nationalParkDetail;

@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *parkNoteTextView;

@end

@implementation SQLDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set national park detail.
    self.nationalParkDetail = [[SQLNationalParkDatabase sharedDatabase] nationalParkDetailWithId:self.nationalParkUniqueId];
    if (self.nationalParkDetail) {
        self.title = self.nationalParkDetail.name;
        
        self.uidLabel.text = [NSString stringWithFormat:@"%zd", self.nationalParkUniqueId];
        self.parkNameLabel.text = self.nationalParkDetail.name;
        self.parkTypeLabel.text = self.nationalParkDetail.type;
        self.parkCodeLabel.text = self.nationalParkDetail.code;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        self.updateTimeLabel.text = [formatter stringFromDate:self.nationalParkDetail.updateTime];
        
        self.parkNoteTextView.text = self.nationalParkDetail.note;
    }
    else {
        self.title = @"Unknown Park";
        
        self.uidLabel.text = @"Unknown ID";
        self.parkNameLabel.text = @"Unknown Name";
        self.parkTypeLabel.text = @"Unknown Type";
        self.parkCodeLabel.text = @"Unknown Code";
        self.updateTimeLabel.text = @"Unknown Time";
        self.parkNoteTextView.text = @"Unknown Note";
    }
}

@end
