//
//  NearbyViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "NearbyViewController.h"
#import "BaseMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapAPIKey.h"

@interface NearbyViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    CLLocation *_currentLoction;

}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation NearbyViewController

@synthesize mapView     = _mapView;
@synthesize search      = _search;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI
{
    [self initMapView];
    [self initSearch];
}

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, 22);
    [self.view addSubview:self.mapView];
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsBuildings = YES;
    self.mapView.showTraffic = YES;
    self.mapView.zoomLevel = 16;
    
    // 隐藏比例尺 和指南针
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
}

- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

// 获取当前定位的地图坐标
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"user%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        _currentLoction = [userLocation.location copy];
    }
}

//  选中当前定位的标注
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    // 选中当前的定位地址进行逆地里编码
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self reGeoAction];
    }
}

//---------------------------------逆地理编码请求
- (void)reGeoAction
{
    if(_currentLoction){
        // 构造搜索请求对象
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLoction.coordinate.latitude longitude:_currentLoction.coordinate.longitude];
        request.radius = 10000;
        request.requireExtension = YES;
        
        // 发起你地理编码
        [self.search AMapReGoecodeSearch:request];
    }
}

// --------------------------------实现逆地理编码的回调函数
/*            请求失败时             */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"request: %@, error: %@", request, error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
        // 通过搜索请求对象处理搜索结果
        NSString *title = response.regeocode.addressComponent.building;
        if (title.length == 0) {
            title = response.regeocode.addressComponent.district;
        }
        self.mapView.userLocation.title = title;
        self.mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    
    [_mapView addAnnotation:pointAnnotation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
