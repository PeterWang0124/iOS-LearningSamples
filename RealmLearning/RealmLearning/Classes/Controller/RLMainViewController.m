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
#import "RLLogViewController.h"

@interface RLMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) RLMResults *specimens;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateMap];
}

#pragma mark - Data funcitons

- (void)updateMap {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.specimens = [RLSpecimen allObjects];
    for (RLSpecimen *specimen in self.specimens) {
        RLSpecimenAnnotation *specimenAnnotation = [[RLSpecimenAnnotation alloc] initWithSpecimen:specimen];
        [self.mapView addAnnotation:specimenAnnotation];
    }
}

- (void)addNewAnnotation {
    RLSpecimen *newSpecimen = [[RLSpecimen alloc] init];
    newSpecimen.latitude = self.mapView.centerCoordinate.latitude;
    newSpecimen.longitude = self.mapView.centerCoordinate.longitude;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:newSpecimen.latitude longitude:newSpecimen.longitude];
    newSpecimen.distance = [location distanceFromLocation:self.mapView.userLocation.location];

    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] addObject:newSpecimen];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    RLSpecimenAnnotation *specimenAnnotation = [[RLSpecimenAnnotation alloc] initWithSpecimen:newSpecimen];
    
    [self.mapView addAnnotation:specimenAnnotation];
    [self.mapView selectAnnotation:specimenAnnotation animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Do something for user location annotation view.
    }
    else if ([annotation isKindOfClass:[RLSpecimenAnnotation class]]) {
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[RLSpecimenAnnotation class]]) {
        RLSpecimen *specimen = ((RLSpecimenAnnotation *)view.annotation).specimen;
        RLAddNewEntryViewController *controller = [[RLAddNewEntryViewController alloc] initWithNibName:NSStringFromClass([RLAddNewEntryViewController class]) bundle:[NSBundle mainBundle]];
        [controller setSpecimen:specimen];
        
        //Clear title.
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (oldState == MKAnnotationViewDragStateEnding && newState == MKAnnotationViewDragStateNone) {
        //Did dragged, update specimen distance.
        if ([view.annotation isKindOfClass:[RLSpecimenAnnotation class]]) {
            RLSpecimenAnnotation *specimenAnnotation = (RLSpecimenAnnotation *)view.annotation;
            RLSpecimen *specimen = specimenAnnotation.specimen;

            [[RLMRealm defaultRealm] beginWriteTransaction];
            specimen.latitude = specimenAnnotation.coordinate.latitude;
            specimen.longitude = specimenAnnotation.coordinate.longitude;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:specimen.latitude longitude:specimen.longitude];
            specimen.distance = [location distanceFromLocation:self.mapView.userLocation.location];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        }
    }
}

#pragma mark - IBAction

- (IBAction)clickAddNewEntryButton:(UIBarButtonItem *)sender {
    [self addNewAnnotation];
}

- (IBAction)clickShowLogButton:(UIBarButtonItem *)sender {
    RLLogViewController *controller = [[RLLogViewController alloc] initWithNibName:NSStringFromClass([RLLogViewController class]) bundle:[NSBundle mainBundle]];
    
    //Clear title.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickFocusBarButtonItem:(UIBarButtonItem *)sender {
    NSArray *annotations = [self.mapView selectedAnnotations];
    id<MKAnnotation> annotation = annotations[0];
    if (annotation) {
        MKMapRect mapRect = [self.mapView visibleMapRect];
        MKMapPoint pointCoord = MKMapPointForCoordinate([annotation coordinate]);
        mapRect.origin.x = pointCoord.x - mapRect.size.width * 0.5;
        mapRect.origin.y = pointCoord.y - mapRect.size.height * 0.5;
        [self.mapView setVisibleMapRect:mapRect animated:YES];
    }
}

@end
