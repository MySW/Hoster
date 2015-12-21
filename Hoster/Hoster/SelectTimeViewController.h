//
//  SelectTimeViewController.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/21.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDateDelegate <NSObject>
- (void)sendDateString: (NSString *)str;
@end

@interface SelectTimeViewController : UIViewController

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) id<sendDateDelegate>delegate;
@end
