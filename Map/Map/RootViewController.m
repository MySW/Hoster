
//
//  RootViewController.m
//  Map
//
//  Created by 梧桐树 on 15/12/19.
//  Copyright © 2015年 梧桐树. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation RootViewController

NSDictionary* books;
NSArray* authors;

// selectedAuthor保存当前选中的作者
NSString* selectedAuthor;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200)];
    [self.view addSubview:self.picker];
    
    // 创建并初始化NSDictionary对象
    books = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSArray arrayWithObjects:@"飞鸟集" , @"吉檀迦利", nil]
             , @"泰戈尔",
             [NSArray arrayWithObjects:@"醒世恒言",@"喻世明言"
              , @"警世通言", nil] , @"冯梦龙",
             [NSArray arrayWithObjects:@"疯狂Android讲义",
              @"疯狂iOS讲义", @"疯狂Ajax讲义" , @"疯狂XML讲义", nil]
             , @"李刚" ,nil];
    // 使用authors保存books所有key组成的NSArray排序后的结果
    authors = [[books allKeys] sortedArrayUsingSelector:
               @selector(compare:)];
    // 设置默认选中的作者authors中的第一个元素
    selectedAuthor = [authors objectAtIndex:0];
    self.picker.dataSource = self;
    self.picker.delegate = self;
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
    // 即authors包含多少个元素，第一列包含多少个列表项
    if (component == 0) {
        return authors.count;
    }
    if (component == 1) {
        return [[books objectForKey:selectedAuthor] count];
    }
    // 如果是其他列（只有第二列），
    // 返回books中selectedAuthor对应的NSArray中元素的个数
    return [[books objectForKey:selectedAuthor] count];
    
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    // 如果是第一列，返回authors中row索引处的元素
    // 即第一列的元素由authors集合元素决定
    if (component == 0) {
        return [authors objectAtIndex:row];
    }
    // 如果是其他列（只有第二列），
    // 返回books中selectedAuthor对应的NSArray中row索引处的元素
    return [[books objectForKey:selectedAuthor] objectAtIndex:row];
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if(component == 0)
    {
        // 改变被选中的作者
        selectedAuthor = [authors objectAtIndex:row];
        // 控制重写加载第二个列表，根据选中的作者来加载第二个列表
        [self.picker reloadComponent:1];
    }
    NSArray* tmp  = component == 0 ? authors:
    [books objectForKey:selectedAuthor];
    NSString* tip = component == 0 ? @"作者": @"图书";
    // 使用一个UIAlertView来显示用户选中的列表项
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:[NSString stringWithFormat:@"你选中的%@是：%@，"
                                   , tip , [tmp objectAtIndex:row]]
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:
(NSInteger)component
{
    // 如果是第一列，宽度为90
    if (component == 0) {
        return 90;
    }
    return 100;  // 如果是其他列（只有第二列），宽度为210
}
@end