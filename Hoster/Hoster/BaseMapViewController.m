//
//  BaseMapViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController ()

@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation BaseMapViewController

@synthesize mapView = _mapView;
@synthesize search = _search;
@synthesize locationManager = _locationManager;

#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}


- (void)clearLocationManager
{
    [self.locationManager stopUpdatingLocation];
    
    //Restore Default Value
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    self.locationManager.delegate = nil;
}

#pragma mark - HandleAction

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];

    [self clearMapView];
    
    [self clearSearch];
    
    [self clearLocationManager];
}

#pragma mark - MALocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"%s, didUpdateLocation = {lat:%f; lon:%f;}", __func__, location.coordinate.latitude, location.coordinate.longitude);
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
}

#pragma mark - initialization
- (void)initMapView
{
    self.mapView.frame = self.view.bounds;
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)initSearch
{
    self.search.delegate = self;
}

- (void)initLocationManager
{
    self.locationManager.delegate = self;
}

- (void)initBaseNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(returnAction)];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.text = title;
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isFirstAppear)
    {
        self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
        _isFirstAppear = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)dealloc
{
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
}

#pragma mark - life Cycle
- (id)init
{
    if (self = [super init])
    {
        
        /* 初始化search. */
        [self initSearch];
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
