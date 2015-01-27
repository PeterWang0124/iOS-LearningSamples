//
//  IGMImageViewController.m
//  Imaginarium
//
//  Created by PeterWang on 1/26/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "IGMImageViewController.h"

@interface IGMImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation IGMImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateUI];
}

#pragma mark - Properties

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    [self updateUI];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
//    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//    self.image = [UIImage imageWithData:imageData];
    [self startDownloadImage];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    [self.loadingIndicator stopAnimating];
    [self updateUI];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Method

- (void)updateUI {
    CGFloat widthScale = self.image ? CGRectGetWidth(_scrollView.bounds) / self.image.size.width : 1.0;
    CGFloat heightScale = self.image ? CGRectGetHeight(_scrollView.bounds) / self.image.size.height : 1.0;
    CGFloat minScale = MIN(widthScale, heightScale);
    self.scrollView.minimumZoomScale = (minScale < 1.0) ? minScale : 1.0;
    self.scrollView.maximumZoomScale = MAX(minScale, 2.0);
    
    //Cause set scroll view may call after set image.
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
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
