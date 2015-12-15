//
//  CallcarViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/14.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "CallcarViewController.h"
#import "AddressCell.h"
#import "TapyTableViewCell.h"
#import "OtherTableViewCell.h"
#import "SendGoodsViewController.h"

#define Height     [UIScreen mainScreen].bounds.size.height
#define Width      [UIScreen mainScreen].bounds.size.width
#define LineY      200

@interface CallcarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    AddressCell *addressCell;
    TapyTableViewCell *tapyCell;
    OtherTableViewCell *otherCell;
}


@end

@implementation CallcarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupNav];
}

- (void)setupData {
    
}
- (void)setupUI {
    // 下部分UI
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - LineY, Width, LineY)];
    self.bottomView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.bottomView];
    
    // 上部分的UI
    self.detailsTVB = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width , Height - LineY-64)];
    self.detailsTVB.delegate = self;
    self.detailsTVB.dataSource = self;
    [self.view addSubview:self.detailsTVB];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 30)];
    freightLabel.text = @"选择地址和车型后将显示里程和运费";
    freightLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1];
    freightLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:freightLabel];
    
    UILabel *generalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 6, CGRectGetMaxY(freightLabel.frame) +10, 100, 30)];
    
    generalLabel.layer.cornerRadius = 30;
    generalLabel.layer.masksToBounds = YES;
    generalLabel.text = @"-位常用司机";
    [self.bottomView addSubview:generalLabel];
    
    
    UILabel *nearlyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4 * 3 - 40, CGRectGetMaxY(freightLabel.frame) + 10, 100, 30)];
    nearlyLabel.layer.cornerRadius = 30;
    nearlyLabel.layer.masksToBounds = YES;
    nearlyLabel.text = @"-位附近司机";
    [self.bottomView addSubview:nearlyLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(20, CGRectGetMaxY(nearlyLabel.frame) + 30, self.view.frame.size.width - 40, 30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.bottomView addSubview:submitBtn];
    
}



- (void)setupNav {
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor cyanColor];
    titleLabel.text             = @"立即叫车";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返" style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customecell"];
    if (0 == indexPath.section) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
        if (nib.count > 0) {
            addressCell = [nib objectAtIndex:0];
            cell = addressCell;
        }
        
        return cell;
    }
    
    if (1 == indexPath.row && 2 == indexPath.section ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTableViewCell" owner:self options:nil];
        if (nib.count > 0) {
            otherCell = [nib objectAtIndex:0];
            cell = otherCell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TapyTableViewCell" owner:self options:nil];
    if (nib.count > 0) {
        tapyCell = [nib objectAtIndex:0];
        cell = tapyCell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        SendGoodsViewController *sendGoodsVC = [SendGoodsViewController new];
        [self.navigationController pushViewController:sendGoodsVC animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
