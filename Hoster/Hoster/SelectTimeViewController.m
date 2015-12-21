
//
//  SelectTimeViewController.m
//  Hoster
//
//  Created by 梧桐树 on 15/12/21.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "SelectTimeViewController.h"

#define Height   [UIScreen mainScreen].bounds.size.height
#define Width    [UIScreen mainScreen].bounds.size.width
#define LineY    300
#define PickerH  200
#define LableH   30
#define LineX    20

@interface SelectTimeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *dataArr;
    NSMutableArray *housArr;
    NSMutableArray *minuteArr;
    NSString *selectHous;
    NSString *selectMinute;
    NSString *str;
}
@end

@implementation SelectTimeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self getData];
}

#pragma mark -设置界面
- (void)setupUI
{
    self.view.backgroundColor = [UIColor clearColor];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(LineX, Height-LineY, Width-2*LineX, PickerH)];
    self.picker.layer.cornerRadius = 5;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:self.picker];
    
    UILabel *selectLaber = [[UILabel alloc] initWithFrame:CGRectMake(LineX, Height-LineY, Width-2*LineX, LableH)];
    selectLaber.layer.cornerRadius = 5;
    selectLaber.layer.masksToBounds = YES;
    selectLaber.backgroundColor = [UIColor greenColor];
    selectLaber.text = @"选择用车时间";
    selectLaber.textColor = [UIColor whiteColor];
    selectLaber.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:selectLaber];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(LineX, CGRectGetMaxY(self.picker.frame) + 20, (Width-3*LineX) / 2, 40);
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(LineX + CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(self.picker.frame) + 20, (Width-3*LineX) / 2, 40);
    confirm.layer.cornerRadius = 5;
    confirm.layer.borderWidth = 0.5;
    confirm.layer.borderColor = [UIColor greenColor].CGColor;
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setBackgroundColor:[UIColor greenColor]];
    [confirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
}

#pragma mark -取消按钮事件
- (void)cancelBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark - 确定按钮点击事件
- (void)confirmBtnAction:(UIButton *)sender
{
    
    [self.delegate sendDateString:str];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}

#pragma mark - 设置数据源
- (void)getData
{
    NSString *plishPath = [[NSBundle mainBundle] pathForResource:@"TimeSelect" ofType:@"plist"];
    dataArr = [NSMutableArray arrayWithContentsOfFile:plishPath];
    selectHous = [[[[dataArr objectAtIndex:0] objectForKey:@"daytime"] objectForKey:@"hous"] objectAtIndex:0];
    selectMinute = [[[[dataArr objectAtIndex:0] objectForKey:@"daytime"] objectForKey:@"minute"] objectAtIndex:0];;
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;  // 返回2表明该控件只包含2列
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    // 如果是第一列，返回authors中元素的个数
    if (component == 0) {
        return dataArr.count;
    }
    if (component == 1) {
        return [[[dataArr[0] objectForKey:@"daytime"] objectForKey:@"hous"] count];
    }
    return [[[dataArr[0] objectForKey:@"daytime"] objectForKey:@"minute"] count];;
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    // 如果是第一列，返回authors中row索引处的元素
    // 即第一列的元素由authors集合元素决定
    if (component == 0) {
        return [dataArr[row] objectForKey:@"day"];
    }
    if (component == 1) {
        return [[dataArr[0] objectForKey:@"daytime"] objectForKey:@"hous"][row];
    }
    return [[dataArr[0] objectForKey:@"daytime"] objectForKey:@"minute"][row];
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSString *dayStr;
    NSString *housStr;
    NSString *minuteStr;
    
    if (component == 0) {
        dayStr = [dataArr[row] objectForKey:@"day"];
        [pickerView reloadComponent:1];
        [pickerView selectRow:13 inComponent:1 animated:YES];
        [pickerView selectRow:1 inComponent:2 animated:YES];
        str = dayStr;
        if (row == 0) {
            dayStr = [dataArr[row] objectForKey:@"day"];
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
    if (component == 1) {
        [pickerView reloadComponent:0];
        [pickerView selectRow:1 inComponent:0 animated:YES];
        [pickerView selectRow:1 inComponent:2 animated:YES];
        housStr = [[dataArr[0] objectForKey:@"daytime"] objectForKey:@"hous"][row];
        str = [NSString stringWithFormat:@"%@%2@时",str ,housStr];
    }
    if (component == 2) {
        [pickerView reloadComponent:0];
        [pickerView selectRow:1 inComponent:0 animated:YES];
        [pickerView selectRow:1 inComponent:1 animated:YES];
        minuteStr = [[dataArr[0] objectForKey:@"daytime"] objectForKey:@"minute"][row];
        str = [NSString stringWithFormat:@"%@%@分",str ,minuteStr];
    }
    
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:
(NSInteger)component
{
    return (self.picker.frame.size.width / 3);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
