//
//  ViewController.m
//  Imaginarium
//
//  Created by PeterWang on 1/26/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "IGMMainViewController.h"

//Controller
#import "IGMImageViewController.h"

@interface IGMMainViewController ()

@end

@implementation IGMMainViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[IGMImageViewController class]]) {
        IGMImageViewController *ivc = (IGMImageViewController *)segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Font Face"]) {
            ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://truth.bahamut.com.tw/s01/201412/2396030e0f273f37f47b0d5bdd55074c.JPG"]];
        }
        else if ([segue.identifier isEqualToString:@"Side Face"]) {
            ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://truth.bahamut.com.tw/s01/201412/7bb96d3cc5bf51ba6c48e251dafb4ba0.JPG"]];
        }
        else if ([segue.identifier isEqualToString:@"Back Face"]) {
            ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://truth.bahamut.com.tw/s01/201412/4b40e50d6541d374931b10cb27b8d79d.JPG"]];
        }
        ivc.title = segue.identifier;
    }
}

@end
