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

#pragma mark - HandleAction

- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
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

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor cyanColor];
    titleLabel.text = title;
    
    self.navigationItem.titleView = titleLabel;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    [self initSearch];
    
}

- (void)dealloc
{
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
