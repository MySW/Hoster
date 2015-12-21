//
//  StartViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/17.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "StartViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapAPIKey.h"
@interface StartViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    CLLocation *_currentLoction;
    NSArray *_poinsArr;
    UISearchBar *search_bar;
}
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSearchBar];
    [self initTableView];
//    [self initMapView];
    [self initSearch];
}

#pragma mark Init
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(search_bar.frame), self.view.bounds.size.width, (self.view.bounds.size.height)- 128) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initSearchBar
{
    search_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 64)];
    search_bar.placeholder = @"请输入要去的地址";
    search_bar.delegate = self;
    [self.view addSubview:search_bar];
}
/*-----------------------------------------------------------------------------------------------*/

#pragma mark - Mapsearch delegate
- (void)searchActionWith:(NSString *)str
{
    // 构造AMapInputTipsSearchRequest对象
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = str;
    tipsRequest.city = @"石家庄";
    // 发起输入提示搜索
    [_search AMapInputTipsSearch:tipsRequest];
}

/*               实现输入提示回调函数                 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.tips.count == 0) {
        return;
    }
    _poinsArr = response.tips;
    [self.tableView reloadData];
}

#pragma mark - searchBar -delegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchBarSearchButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchActionWith:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark --map delegate
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

#pragma mark -tableView dateSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _poinsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    AMapPOI *poi = _poinsArr[indexPath.row];
    cell.textLabel.text = poi.name;
    return cell;
}

#pragma mark --tableViewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.flag_section) {
        case 1:
        {
            AMapPOI *poi = _poinsArr[indexPath.row];
            [self.delegate senderMessage:poi.name];
        }
            break;
        case 2:
        {
            AMapPOI *poi = _poinsArr[indexPath.row];
            [self.delegate senderPassAddress:poi.name with:self.flag];
        }
            break;
        case 3:
        {
            AMapPOI *poi = _poinsArr[indexPath.row];
            [self.delegate senderOthereMessge:poi.name];
        }
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
