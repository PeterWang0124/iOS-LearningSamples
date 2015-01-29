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

#pragma mark - IBAction

- (IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSDictionary *propList = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        NSArray *photos = [propList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos; //Note : no need to use weak self, cause dispatch hold self strongly, but self not hold dispatch strongly.
        });
    });
}

@end
