//
//  ViewController.m
//  MySIPPhone
//
//  Created by PeterWang on 2/11/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "ViewController.h"
#import "MSPMyPJSUAManager.h"

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

- (IBAction)initPJSUAButtone:(id)sender {
    [[MSPMyPJSUAManager sharedManager] initPJSUA];
}

@end
