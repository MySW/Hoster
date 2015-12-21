//
//  StartViewController.h
//  Hoster
//
//  Created by 梧桐树 on 15/12/17.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendStartDelegate <NSObject>

@optional
- (void)senderOthereMessge:(NSString *)sender;
- (void)senderPassAddress:(NSString *)sender with:(NSInteger)myflag;
- (void)senderMessage:(NSString *)sender;
@end

@interface StartViewController : UIViewController
@property (nonatomic, assign) id<sendStartDelegate>delegate;
@property (nonatomic, assign) NSInteger flag; // 途经地标示
@property (nonatomic, assign) NSInteger flag_section;  //标示第几个section
@end
