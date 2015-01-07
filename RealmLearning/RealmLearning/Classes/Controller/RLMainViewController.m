//
//  RLMainViewController.m
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLMainViewController.h"

//Model
#import "RLSpecimen.h"
#import "RLCategory.h"
#import "RLSpecimenAnnotation.h"

//Controller
#import "RLAddNewEntryViewController.h"

@interface RLMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) RLMResults *specimens;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKAnnotationView *lastAnnotationView;

@end

@implementation RLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Map";
    
    //Init location.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    //Init View.
    self.mapView.delegate = self;
    
    //Init data
    [self updateMap];
}

#pragma mark - Data funcitons

- (void)updateMap {
    NSLog(@"Update Map");
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.specimens = [RLSpecimen allObjects];
    for (RLSpecimen *specimen in self.specimens) {
        RLSpecimenAnnotation *specimenAnnotation = [[RLSpecimenAnnotation alloc] initWithSpecimen:specimen];
        [self.mapView addAnnotation:specimenAnnotation];
    }
}

- (void)addNewAnnotation {
    NSLog(@"Add new Annotation");
    RLSpecimen *newSpecimen = [[RLSpecimen alloc] init];
    newSpecimen.latitude = self.mapView.centerCoordinate.latitude;
    newSpecimen.longitude = self.mapView.centerCoordinate.longitude;

    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] addObject:newSpecimen];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    RLSpecimenAnnotation *specimenAnnotation = [[RLSpecimenAnnotation alloc] initWithSpecimen:newSpecimen];
    
    [self.mapView addAnnotation:specimenAnnotation];
    [self.mapView selectAnnotation:specimenAnnotation animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"View for Annotation");
    if ([annotation isKindOfClass:[RLSpecimenAnnotation class]]) {
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([MKPinAnnotationView class])];
        if (!pin) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([MKPinAnnotationView class])];
        }
        pin.annotation = annotation;
        pin.draggable = YES;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.enabled = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return pin;
    }

    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Select Annotation");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Deselect Annotation");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Callout Accessory Control Tapped");
    if ([view.annotation isKindOfClass:[RLSpecimenAnnotation class]]) {
        RLSpecimen *specimen = ((RLSpecimenAnnotation *)view.annotation).specimen;
        RLAddNewEntryViewController *controller = [[RLAddNewEntryViewController alloc] initWithNibName:NSStringFromClass([RLAddNewEntryViewController class]) bundle:[NSBundle mainBundle]];
        [controller setSpecimen:specimen];
        
        //Clear title.
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - IBAction

- (IBAction)clickAddNewEntryButton:(UIBarButtonItem *)sender {
    NSLog(@"Click Add New Entry Button");
    [self addNewAnnotation];
}

@end
