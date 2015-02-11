//
//  ViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "ViewController.h"
#import "MSPMyPjsuaManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)initPjsuaButtone:(id)sender {
    [[MSPMyPjsuaManager sharedManager] initPjsua];
}

- (IBAction)initPjsuaTransportButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] initPjsuaTransport];
}

- (IBAction)startPjsuaButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] startPjsua];
}

- (IBAction)registerSipServerButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] registerSipServer];
}

- (IBAction)makeCallButton:(id)sender {
    [[MSPMyPjsuaManager sharedManager] makeCall];
}

@end
