//
//  MapLocation.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/18.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation
- (NSString *)title{
    return @"您的位置！";
}
- (NSString *)subtitle{
    NSMutableString *ret = [[NSMutableString alloc] init];
    if (_state)
        [ ret appendString:_state];
    if (_city) {
        [ret appendString:_city];
    }
    if (_city && _state) {
        [ret appendString:@","];
    }
    if (_streetAddress && (_city || _state || _zip)) {
        [ret appendString:@"?"];
    }
    if (_streetAddress) {
        [ret appendString:_streetAddress];
    }
    if (_zip) {
        [ret appendFormat:@",%@",_zip];
    }		return ret;
}
@end
