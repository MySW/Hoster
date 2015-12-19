//
//  MainViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/14.
//  Copyright © 2015年 梧桐树. All rights reserved.
//
#import <MAMapKit/MAMapKit.h>
#import "MainViewController.h"
#import "CallcarViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapAPIKey.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,MAMapViewDelegate, AMapSearchDelegate>
{
    CLLocation *_currentLoction;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"首页";
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    [self initMapView];
    [self initSearch];
}

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(-10, 10, 10, 10)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 16;
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
    _currentLoction = userLocation.location;
    [self reGeoAction];
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
        NSString *title = response.regeocode.addressComponent.city;
        if (title.length == 0) {
            title = response.regeocode.addressComponent.province;
        }
        self.mapView.userLocation.title = title;
        self.mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    }
    self.address = self.mapView.userLocation.subtitle;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:self.mapView.userLocation.title style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    
}


#pragma  mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"立即叫车";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - TableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        CallcarViewController *callCarVC = [CallcarViewController new];
        callCarVC.mypostion = self.address;
        [self.navigationController pushViewController:callCarVC animated:NO];
    }
    NSLog(@"%@", self.mapView.userLocation.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{

 }

@end
