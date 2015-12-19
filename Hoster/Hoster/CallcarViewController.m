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
#import "AddTableViewCell.h"
#import "SendGoodsViewController.h"
#import "StartViewController.h"
#define Height     [UIScreen mainScreen].bounds.size.height
#define Width      [UIScreen mainScreen].bounds.size.width
#define LineY      100

@interface CallcarViewController ()<UITableViewDataSource,UITableViewDelegate,sendStrDelegate>
{
    AddressCell *addressCell;
    TapyTableViewCell *tapyCell;
    OtherTableViewCell *otherCell;
    AddTableViewCell *addCell;
    CLLocation *_currentLoction;
    NSArray *placeholderArr;
    NSMutableArray *passAddressArr;
    NSMutableArray *timeArr;
    NSString *carStly;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation CallcarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupNav];
}

#pragma mark - init
- (void)setupData
{
    placeholderArr = @[@"请输入起始地", @"请输入目的地"];
    passAddressArr = [NSMutableArray array];
}
- (void)setupUI {
    // 下部分UI
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - LineY, Width, LineY)];
    self.bottomView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.bottomView];
    
    // 上部分的UI
    self.detailsTVB = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width , Height - LineY-64) style:UITableViewStyleGrouped];
    self.detailsTVB.delegate = self;
    self.detailsTVB.dataSource = self;
    self.detailsTVB.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.detailsTVB];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 30)];
    freightLabel.text = @"选择地址和车型后将显示里程和运费";
    freightLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1];
    freightLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:freightLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(20, CGRectGetMaxY(freightLabel.frame) + 20 , self.view.frame.size.width - 40, 30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.bottomView addSubview:submitBtn];
    
}



#pragma mark setupNAV
- (void)setupNav {
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor cyanColor];
    titleLabel.text             = @"发货信息";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)leftAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableViewDatasouse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 3) {
        return 1;
    }
    if (section == 2) {
        return passAddressArr.count;
    }
    
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customecell"];
    switch (indexPath.section) {
        case 1:
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
            if (nib.count > 0) {
                addressCell = [nib objectAtIndex:0];
                addressCell.titleLabel.text = self.mypostion;
                if (addressCell.titleLabel.text.length > 0) {
                    addressCell.placeholderLabel.hidden = YES;
                } else {
                    addressCell.placeholderLabel.text = @"请输入起始地";
                }
                cell = addressCell;
            }
            return cell;
        }
            break;
        case 2:
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddTableViewCell" owner:self options:nil];
            if (nib.count > 0) {
                addCell = [nib objectAtIndex:0];
                cell = addCell;
            }
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
            if (nib.count > 0) {
                addressCell = [nib objectAtIndex:0];
                addressCell.titleLabel.text = self.mypostion;
                if (addressCell.titleLabel.text.length > 0) {
                    addressCell.placeholderLabel.hidden = YES;
                } else {
                    addressCell.placeholderLabel.text = @"请输入目的地";
                }
                cell = addressCell;
            }
            return cell;
        }
        case 4:
        {
            if (indexPath.row == 0) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddTableViewCell" owner:self options:nil];
                if (nib.count > 0) {
                    addCell = [nib objectAtIndex:0];
                    addCell.titlelabel.text = @"给司机捎句话";
                    cell = addCell;
                }
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                return cell;
            }
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTableViewCell" owner:self options:nil];
            if (nib.count > 0) {
                otherCell = [nib objectAtIndex:0];
                cell = otherCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        default:
            break;
    }
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TapyTableViewCell" owner:self options:nil];
    if (nib.count > 0) {
        tapyCell = [nib objectAtIndex:0];
        
        if (indexPath.row == 0 && 0 == indexPath.section) {
            tapyCell.detailLabel.text = @"小型面包";
            if (carStly) {
                tapyCell.detailLabel.text = carStly;
            }
            tapyCell.otherLabel.text = @"请选择";
        }

        if (indexPath.row == 1 ) {
            tapyCell.titleLabel.text = @"用车时间";
            tapyCell.detailLabel.text = @"现在";
            tapyCell.otherLabel.text = @"点击修改";
        }
        cell = tapyCell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
#pragma mark -footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section  == 3) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
        footView.backgroundColor = [UIColor whiteColor];
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        selectBtn.frame = CGRectMake(0, 10, Width / 3, 40);
        [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setTitle:@"添加途经地" forState:UIControlStateNormal];
        [footView addSubview:selectBtn];
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame) + 20, CGRectGetMinY(selectBtn.frame), Width / 3 * 2 - 30, 40)];
        detailsLabel.numberOfLines = 0;
        detailsLabel.text = @"中国人民解放军开赴大别山根据地开展人民群众动员工作";
        detailsLabel.font = [UIFont systemFontOfSize:12];
        [footView addSubview:detailsLabel];
        return footView;
    }
    return nil;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 0.01;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 60;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SendGoodsViewController *sendGoodsVC = [SendGoodsViewController new];
            sendGoodsVC.delegate = self;
            [self.navigationController pushViewController:sendGoodsVC animated:YES];
            return;
        } else {
            
            return;
        }
    }
    if (indexPath.section == 4 ) {
        
        return;
    }
    StartViewController *startVC = [StartViewController new];
    [self.navigationController pushViewController:startVC animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark 提交编辑操作时会调用这个方法(删除，添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    [passAddressArr removeObjectAtIndex:(indexPath.row )];
    // 2.更新UITableView UI界面
    
    [self.detailsTVB deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationRight];
}

#pragma mark 途经地
- (void)selectAction:(UIButton *)sender
{
    [passAddressArr addObject:@"爱尔兰"];
    [self.detailsTVB reloadData];
}

#pragma mark delegate 传值

-(void)sendStr:(NSString *)str
{
    carStly = str;
    [self.detailsTVB reloadData];
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
