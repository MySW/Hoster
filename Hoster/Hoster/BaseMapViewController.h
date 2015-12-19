//
//  BaseMapViewController.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface BaseMapViewController : UIViewController<AMapSearchDelegate, MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationManager;

- (void)returnAction;
- (void)initTitle:(NSString *)title;

@end
