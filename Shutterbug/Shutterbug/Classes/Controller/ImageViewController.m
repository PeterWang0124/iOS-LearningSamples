//
//  ImageViewController.m
//  Imaginarium
//
//  Created by PeterWang on 1/26/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add image view to scroll view.
    [self.scrollView addSubview:self.imageView];
    
    //Set navigation bar buttion item.
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupUI];
}

#pragma mark - Properties

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    [self setupUI];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self startDownloadImage];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.loadingIndicator stopAnimating];
    [self setupUI];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Method

- (void)setupUI {
    //Set scroll view zoom scale.
    CGFloat widthScale = self.image ? CGRectGetWidth(self.scrollView.bounds) / self.image.size.width : 1.0;
    CGFloat heightScale = self.image ? CGRectGetHeight(self.scrollView.bounds) / self.image.size.height : 1.0;
    CGFloat minScale = MIN(widthScale, heightScale);
    self.scrollView.zoomScale = 1.0;
    self.scrollView.minimumZoomScale = (minScale < 1.0) ? minScale : 1.0;
    self.scrollView.maximumZoomScale = MAX(minScale, 2.0);
    
    //Cause set scroll view may call after set image.
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    self.scrollView.contentOffset = CGPointZero;
}

- (void)startDownloadImage {
    self.image = nil;
    if (self.imageURL) {
        [self.loadingIndicator startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error) {
                //Check the request is same as image.
                if ([request.URL isEqual:self.imageURL]) {
                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    //Dispatch to main queue and do the setting.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                    });
                }
            }
        }];
        [task resume];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
