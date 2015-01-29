//
//  FlickrPhotosTableViewController.m
//  Shutterbug
//
//  Created by PeterWang on 1/28/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"

//ThirdLibrary
#import "FlickrFetcher.h"

//Controller
#import "ImageViewController.h"

@interface FlickrPhotosTableViewController () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitViewController.delegate = self;
}

#pragma mark - Properties

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UI setup

- (void)prepareImageViewController:(ImageViewController *)ivc withDisplayPhoto:(NSDictionary *)photo {
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.splitViewController && [self.splitViewController.viewControllers count] > 1) {
        //If device is iPad, image view controller is the secondary view controller in the split view controller.
        id controller = self.splitViewController.viewControllers[1];
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [((UINavigationController *)controller).viewControllers firstObject];
        }
        
        if ([controller isKindOfClass:[ImageViewController class]]) {
            [self prepareImageViewController:controller withDisplayPhoto:self.photos[indexPath.row]];
        }
    }
    else {
        //If device is iPhone, there was no secondary view controller in split view controller.
        //So new image view controller and push it.
        ImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewController class])];
        [self prepareImageViewController:controller withDisplayPhoto:self.photos[indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    //Return YES to indicate that you do not want the split view controller to do anything with the secondary view controller.
    //Return NO to let the split view controller try and incorporate the secondary view controller’s content into the collapsed interface.
    //If device is iPhone, secondary view controller would be collapse.
    return YES;
}

@end
