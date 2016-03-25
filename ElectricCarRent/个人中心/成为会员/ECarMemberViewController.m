//
//  ECarMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/12/3.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarMemberViewController.h"
#import "ECarBuyMemberViewController.h"

// 调用接口获得价格
#import "ECarUser.h"
#import "ECarUserManager.h"

@interface ECarMemberViewController () <ECarBuyMemberViewControllerDelegate>

@property (nonatomic , strong)UIButton * leftBtn;
@property (nonatomic , strong)UIButton * rightButton;

//获得价格
@property (nonatomic , strong)ECarUser * zz;
@property (nonatomic , strong)ECarUserManager * manage;

@end

@implementation ECarMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获得价格
    ECarConfigs * user=[ECarConfigs shareInstance];
    _zz = user.user;
    _manage = [ECarUserManager new];
    
    self.view.backgroundColor = WhiteColor;
    self.title = @"成为会员";
    
    [self loadData];
}

// 加载数据
- (void)loadData{
    weak_Self(self);
    [weakSelf showHUD:@"加载中..."];
    [[_manage getAllMemberInfoByPhone:_zz.phone] subscribeNext:^(id x) {
        [weakSelf hideHUD];
        NSDictionary * dic = x;
        NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
        if (success.boolValue == 0) {
            NSString * msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        NSArray *  vipArr = dic[@"obj"];
        self.text = dic[@"phoneMsg"];
        NSDictionary * dic1 = vipArr[0];
        NSDictionary * dic2 = vipArr[1];
        NSDictionary * dic3 = vipArr[2];
        NSDictionary * dic4 = vipArr[3];
        
        self.putongMemPrice = [NSString stringWithFormat:@"%zd",[dic1[@"levelMoney"] integerValue]];
        self.putongMemText = [NSString stringWithFormat:@"%@",dic1[@"levelName"]];
        self.putongType = [NSString stringWithFormat:@"%@",dic1[@"levelCode"]];
        self.putongUnit = [NSString stringWithFormat:@"%@",dic1[@"levelUnit"]];
        self.putongNote = [NSString stringWithFormat:@"%@",dic1[@"note"]];
        
        self.vipMemPrice = [NSString stringWithFormat:@"%zd",[dic2[@"levelMoney"] integerValue]];
        self.vipMemText = [NSString stringWithFormat:@"%@",dic2[@"levelName"]];
        self.vipType = [NSString stringWithFormat:@"%@",dic2[@"levelCode"]];
        self.vipUnit = [NSString stringWithFormat:@"%@",dic2[@"levelUnit"]];
        self.vipNote = [NSString stringWithFormat:@"%@",dic2[@"note"]];
        
        self.svipMemPrice = [NSString stringWithFormat:@"%zd",[dic3[@"levelMoney"] integerValue]];
        self.svipMemText = [NSString stringWithFormat:@"%@",dic3[@"levelName"]];
        self.svipType = [NSString stringWithFormat:@"%@",dic3[@"levelCode"]];
        self.svipUnit = [NSString stringWithFormat:@"%@",dic3[@"levelUnit"]];
        self.svipNote = [NSString stringWithFormat:@"%@",dic3[@"note"]];
        
        self.wumaiPrice = [NSString stringWithFormat:@"%zd",[dic4[@"levelMoney"] integerValue]];
        self.wumaiText = [NSString stringWithFormat:@"%@",dic4[@"levelName"]];
        self.wumaiUnit = [NSString stringWithFormat:@"%@",dic4[@"levelUnit"]];
        self.wumaiType = [NSString stringWithFormat:@"%@",dic4[@"levelCode"]];
        
        [self createMemberUI];
        
    } error:^(NSError *error) {
        [self creatNoNetImageView];
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:@"网络异常"];
    } completed:^{
        
    }];
}

- (void)fromOtherViewPopMyView
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self loadData];
}

// 创建没网的情况下的图片
- (void)creatNoNetImageView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:view.frame];
    [imageView setImage:[UIImage imageNamed:@"yichang"]];
    [view addSubview:imageView];
    [self.view addSubview:view];
}

// btn点击事件
- (void)leftBtnAction:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightButtonAction:(UIButton *)sender
{
    [self callServerAction];
}

- (void)callServerAction
{
    UIAlertView *serviceAlert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-8939091" delegate:self cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
    [serviceAlert show];
}

// 创建界面
- (void)createMemberUI
{
    // btn
    UIButton * putongMem = [self creatHuiyuanBtnWithFrame:CGRectMake(0, 64, kScreenW, 90 / 667.f * kScreenH ) andLabelUpTitle:self.putongMemText andLabelDownTitle:[NSString stringWithFormat:@"%@%@",self.putongMemPrice,self.putongUnit]];
    [putongMem addTarget:self action:@selector(putongMemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putongMem];
    
    UIButton * vipButton = [self creatHuiyuanBtnWithFrame:CGRectMake(0, CGRectGetMaxY(putongMem.frame) - 1, kScreenW, 90/ 667.f * kScreenH ) andLabelUpTitle:self.vipMemText andLabelDownTitle:[NSString stringWithFormat:@"%@%@",self.vipMemPrice,self.vipUnit]];
    [vipButton addTarget:self action:@selector(vipMemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vipButton];
    
    UIButton * svipButton = [self creatHuiyuanBtnWithFrame: CGRectMake(0, CGRectGetMaxY(vipButton.frame) - 1, kScreenW, 90/ 667.f * kScreenH ) andLabelUpTitle:self.svipMemText andLabelDownTitle:[NSString stringWithFormat:@"%@%@",self.svipMemPrice,self.svipUnit]];
    [svipButton addTarget:self action:@selector(svipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:svipButton];
    
    // 描述
    NSString * str =self.text;
    UITextView * ztLabel = [[UITextView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(svipButton.frame) + 90 / 667.f * kScreenH , kScreenW - 30, kScreenH - (CGRectGetMaxY(svipButton.frame) + 90 / 667.f * kScreenH ))];
    ztLabel.scrollEnabled = NO;
    ztLabel.backgroundColor = [UIColor clearColor];
    ztLabel.text = str;
    ztLabel.editable = NO;
    ztLabel.selectable = NO;
    ztLabel.font = [UIFont systemFontOfSize:14.0f];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    ztLabel.attributedText = [[NSAttributedString alloc] initWithString:ztLabel.text attributes:attributes];
    ztLabel.textColor = RedColor;
    [self.view addSubview:ztLabel];
}

// 创建Btn方法
- (UIButton *)creatHuiyuanBtnWithFrame:(CGRect)frame andLabelUpTitle:(NSString * )labelUpTitle andLabelDownTitle:(NSString *)labelDownTitle{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
    UILabel * labelUp = [self creatLabelWithName:labelUpTitle andFrame:CGRectMake(0, 20 / 667.f * kScreenH , kScreenW, 25 / 667.f * kScreenH )];
    [btn addSubview:labelUp];
    UILabel * labelDown = [self creatLabelWithName:labelDownTitle andFrame:CGRectMake(0, 45 / 667.f * kScreenH , kScreenW, 25 / 667.f * kScreenH )];
    labelDown.textColor = RedColor;
    [btn addSubview:labelDown];
    
    return btn;
}

// 创建label方法
- (UILabel *)creatLabelWithName:(NSString *)name andFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    return label;
}

// 月
- (void)putongMemClicked:(UIButton *)button
{
    ECarBuyMemberViewController * buyMemberVC = [[ECarBuyMemberViewController alloc]init];
    buyMemberVC.text = self.putongMemText;
    buyMemberVC.messege = self.putongNote;
    buyMemberVC.levelCode = self.putongType;
    buyMemberVC.levelUnit = self.putongUnit;
    buyMemberVC.levelMoney = [NSString stringWithFormat:@"%@%@",self.putongMemPrice,self.putongUnit];
    buyMemberVC.currentMoney = self.putongMemPrice;
    buyMemberVC.memberDelegate = self;
    [self.navigationController pushViewController:buyMemberVC animated:YES];
}


// 半年
- (void)vipMemClicked:(UIButton *)button
{
    ECarBuyMemberViewController * buyMemberVC = [[ECarBuyMemberViewController alloc]init];
    buyMemberVC.text = self.vipMemText;
    buyMemberVC.messege = self.vipNote;
    buyMemberVC.levelCode = self.vipType;
    buyMemberVC.levelUnit = self.vipUnit;
    buyMemberVC.levelMoney = [NSString stringWithFormat:@"%@%@",self.vipMemPrice,self.vipUnit];
    buyMemberVC.currentMoney = self.vipMemPrice;
    buyMemberVC.memberDelegate = self;
    [self.navigationController pushViewController:buyMemberVC animated:YES];
}

// 年
- (void)svipButtonClicked:(UIButton *)button
{
    ECarBuyMemberViewController * buyMemberVC = [[ECarBuyMemberViewController alloc]init];
    buyMemberVC.text = self.svipMemText;
    buyMemberVC.messege = self.svipNote;
    buyMemberVC.levelCode = self.svipType;
    buyMemberVC.levelUnit = self.svipUnit;
    buyMemberVC.levelMoney = [NSString stringWithFormat:@"%@%@",self.svipMemPrice,self.svipUnit];
    buyMemberVC.currentMoney = self.svipMemPrice;
    buyMemberVC.memberDelegate = self;
    
    buyMemberVC.wumaiText = self.wumaiText;
    buyMemberVC.wumaiMoney = [NSString stringWithFormat:@"%@%@",self.wumaiPrice,self.wumaiUnit];
    buyMemberVC.wumaiType = self.wumaiType;
    
    [self.navigationController pushViewController:buyMemberVC animated:YES];
}

@end
