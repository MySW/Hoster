//
//  CallcarViewController.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/14.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapAPIKey.h"

@interface CallcarViewController : UIViewController

@property (nonatomic, strong)UITableView *detailsTVB;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)NSString *mypostion;
@property (nonatomic, strong)NSString *startTime;
@end
