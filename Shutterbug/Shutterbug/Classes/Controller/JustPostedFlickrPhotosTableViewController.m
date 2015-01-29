//
//  JustPostedFlickrPhotosTableViewController.m
//  Shutterbug
//
//  Created by PeterWang on 1/28/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "JustPostedFlickrPhotosTableViewController.h"

//ThirdLibrary
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTableViewController ()

@end

@implementation JustPostedFlickrPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

#pragma mark - Methods

- (void)fetchPhotos {
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *propList = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    NSArray *photos = [propList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    self.photos = photos;
}

@end
