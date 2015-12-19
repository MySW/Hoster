
//
//  SendGoodsViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "SendGoodsViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapAPIKey.h"

@interface SendGoodsViewController ()<UITableViewDelegate, UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate>
{
    CLLocation *_currentLoction;
    NSString *address;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITableView *sendTableView;
@end

@implementation SendGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self data];
}

- (void)data
{
    address = @"分数爱";
}

- (void)initTableView
{
    self.title = @"发货信息";
    self.sendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.sendTableView.delegate = self;
    self.sendTableView.dataSource = self;
    [self.view addSubview:self.sendTableView];
    
    UIButton *submit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit_btn setBackgroundColor:[UIColor greenColor]];
    [submit_btn setTitle:@"确定" forState:UIControlStateNormal];
    submit_btn.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width - 40, 40);
    [submit_btn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit_btn];
    
    [self initMapView];
    [self initSearch];
    
}

- (void)submitAction:(UIButton *)sender
{
    NSLog(@"I'm a button");
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
    
}



#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.textLabel.text = address;
    return cell;
}

#pragma mark - tableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate sendStr:address];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
