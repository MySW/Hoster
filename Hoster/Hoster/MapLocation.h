//
//  MapLocation.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/18.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapLocation : NSObject
@property (nonatomic , readwrite) CLLocationCoordinate2D coordinate; // 地理坐标
@property (nonatomic , copy) NSString *streetAddress; // 街道信息属性
@property (nonatomic , copy) NSString *city;    // 城市信息属性
@property (nonatomic , copy) NSString *state;   // 州、省、市信息
@property (nonatomic , copy) NSString *zip;     // 邮编
@end
