//
//  SendGoodsViewController.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/15.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendStrDelegate <NSObject>

- (void)sendStr: (NSString *)str;

@end

@interface SendGoodsViewController : UIViewController

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign)id<sendStrDelegate>delegate;
@end
