//
//  ECarBuyMemberViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 15/12/3.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ECarBuyMemberViewController.h"

@interface ECarBuyMemberViewController ()<UITextFieldDelegate>

// 调用后台用
@property (nonatomic , strong)ECarUser * zz;
@property (nonatomic , strong)ECarUserManager * manage;
@property (nonatomic , strong)UITextField * textField;
@property (nonatomic , strong)UILabel * labelLine;
@property (nonatomic , strong)UIButton * selectBtn;
@property (nonatomic , copy)NSString * lastNum;
@property (nonatomic , copy)NSString * lastMoney;

@end

@implementation ECarBuyMemberViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ECarConfigs * user=[ECarConfigs shareInstance];
    _zz = user.user;
    _manage = [ECarUserManager new];
    
    self.view.backgroundColor = WhiteColor;
    self.title = self.text;
    [self creatUI];
}


- (void)goBack
{
    if ([self.memberDelegate respondsToSelector:@selector(fromOtherViewPopMyView)]) {
        [self.memberDelegate fromOtherViewPopMyView];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    
    UIButton * putongMem = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.levelCode isEqualToString:@"20160218003"]) {
        // 限行会员 XX元/月
        UILabel * labelLeft = [[UILabel alloc]init];
        labelLeft.text = self.text;
        CGSize sizeLeft = [labelLeft.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;
        labelLeft.frame =CGRectMake(0, 0, sizeLeft.width, 35);
        labelLeft.font = [UIFont systemFontOfSize:14.0f];
        
        UILabel * labelRight = [[UILabel alloc]init];
        labelRight.text = self.levelMoney;
        CGSize sizeRight = [labelRight.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
        labelRight.textColor = RedColor;
        labelRight.font = [UIFont systemFontOfSize:14.0f];
        labelRight.frame = CGRectMake(sizeLeft.width + 10,0 , sizeRight.width, 35);
        
        UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - sizeLeft.width - sizeRight.width - 10) / 2, 0, sizeLeft.width + sizeRight.width + 10, 35)];
        [firstView addSubview:labelLeft];
        [firstView addSubview:labelRight];
        
        UIView * topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 20, kScreenW, 35)];
        [topBgView addSubview:firstView];
        [self.view addSubview:topBgView];
        
        // 加号
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiahao20*20"]];
        imageView.frame = CGRectMake(0, 0, 20, 20);
        imageView.center = CGPointMake(kScreenW / 2, CGRectGetMaxY(topBgView.frame) + 20);
        [self.view addSubview:imageView];
        
        // 雾霾保险和勾选框
        UILabel * labelLeft1 = [[UILabel alloc]init];
        labelLeft1.text = self.wumaiText;
        CGSize sizeLeft1 = [labelLeft1.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size;
        labelLeft1.frame = CGRectMake(0, 0, sizeLeft1.width, 35);
        labelLeft1.font = [UIFont systemFontOfSize:14.0f];
        
        UILabel * labelRight1 = [[UILabel alloc]init];
        labelRight1.text = self.wumaiMoney;
        CGSize sizeRight1 = [labelRight1.text boundingRectWithSize:CGSizeMake(0, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size;
        labelRight1.frame = CGRectMake(sizeLeft1.width + 10, 0, sizeRight1.width, 35);
        labelRight1.textColor = RedColor;
        labelRight1.font = [UIFont systemFontOfSize:14.0f];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.selected = YES;
        [_selectBtn setImage:[UIImage imageNamed:@"wumaixiankuang22*22"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"wumaixiankuanggou22*22"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn.frame = CGRectMake(sizeLeft1.width + 10 + sizeRight1.width + 15, 6.5, 26, 24);
        
        UIView * view1 = [[UIView alloc]init];
        view1.frame = CGRectMake((kScreenW - sizeRight1.width - sizeLeft1.width - 25 - self.selectBtn.bounds.size.width) / 2, 0, sizeLeft1.width + sizeRight1.width + 25 + self.selectBtn.bounds.size.width, 35);
        [view1 addSubview:labelLeft1];
        [view1 addSubview:labelRight1];
        [view1 addSubview:self.selectBtn];
        
        UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, kScreenW , 35)];
        [bgView1 addSubview:view1];
        [self.view addSubview:bgView1];
        
        // 限行会员和输入框
        UILabel * labelHaoma = [[UILabel alloc]init];
        labelHaoma.text = @"     请输入限行尾号";
        CGSize sizeHaoma = [labelHaoma.text boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size;
        labelHaoma.frame = CGRectMake(0, 0, sizeHaoma.width, 40);
        labelHaoma.textColor = RedColor;
        labelHaoma.font = [UIFont systemFontOfSize:14.0f];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(sizeHaoma.width + 10, 1, 38, 38)];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textColor = RedColor;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.background = [UIImage imageNamed:@"xianxingweihaokuang38*38"];
        
        UIView * haomaView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - (sizeHaoma.width + 40 + 10)) / 2, 0, sizeHaoma.width + 40 + 10, 40)];
        [haomaView addSubview:labelHaoma];
        [haomaView addSubview:_textField];
        
        UIView * haomaBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame) + 30, kScreenW, 40)];
        [haomaBgView addSubview:haomaView];
        [self.view addSubview:haomaBgView];
        
        _labelLine = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(haomaBgView.frame) + 20, kScreenW - 20, 1)];
        _labelLine.backgroundColor = GrayColor;
        [self.view addSubview:_labelLine];
    }else{
        putongMem.frame = CGRectMake(0, 64, kScreenW, 55);
        [putongMem setTitle:self.levelMoney forState:UIControlStateNormal];
        [putongMem setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
        putongMem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [putongMem setBackgroundImage:[UIImage imageNamed:@"beijingkuang374*55"] forState:UIControlStateNormal];
        putongMem.enabled = NO;
        [self.view addSubview:putongMem];
        _labelLine = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(putongMem.frame), kScreenW - 20, 1)];
        _labelLine.backgroundColor = GrayColor;
        [self.view addSubview:_labelLine];
    }
    
    // 添加会员文案描述
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(23, CGRectGetMaxY(_labelLine.frame) + 20, kScreenW - 46, kScreenH - (CGRectGetMaxY(_labelLine.frame) + 20) - 30 - 49)];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.backgroundColor = [UIColor clearColor];
    textView.selectable = NO;
    textView.editable = NO;
    textView.text = self.messege;
    // 添加间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    [self.view addSubview:textView];
    // 购买按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitleColor:[UIColor colorWithRed:224/255.0f green:54/255.0f blue:134/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    buyBtn.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    [buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    // 添加下面的线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW , 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0];
    [self.view addSubview:lineView1];
    
    // 添加点击事件
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGesture{
    [_textField resignFirstResponder];
}

#pragma mark btnAction
- (void)selectBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0) {
        unichar uc = [string characterAtIndex:0];
        if (uc > 57 || uc < 48) {
            return NO;
        }
    }
    _textField.text = string;
    _lastNum = _textField.text;
    return NO;
}

// 修改
// 购买按钮点击事件
- (void)buyBtnAction:(UIButton *)btn{
    weak_Self(self);
    if (_textField.text.length == 0 && ([self.levelCode isEqualToString:@"20160218003"] || [self.levelCode isEqualToString:@"20160218004"])) {
        UIAlertView * noTextAlert = [[UIAlertView alloc] initWithTitle:@"限行号" message:@"请输入您的机动车尾号。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [noTextAlert show];
    } else {
        if (![self.levelCode isEqualToString:@"20160218003"] && ![self.levelCode isEqualToString:@"20160218004"]) {
            _lastNum = [NSString stringWithFormat:@"10"];
        }
        [weakSelf showHUD:@"加载中..."];
        ECarZhiFuViewController * zhifuVC = [[ECarZhiFuViewController alloc]init];
        if (_selectBtn.selected) {
            self.levelCode = self.wumaiType;
            _lastMoney = [NSString stringWithFormat:@"%zd",[self.levelMoney integerValue] + [self.wumaiMoney integerValue]];
        }else{
            _lastMoney = self.levelMoney;
        }
        [[_manage creatOrderByRenyuanID:_zz.phone vipType:self.levelCode lastNum:_lastNum]subscribeNext:^(id x) {
            [weakSelf hideHUD];
            NSDictionary * dic = x;
            NSString * success = [NSString stringWithFormat:@"%@", dic[@"success"]];
            if (success.boolValue == 0) {
                NSString * msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            NSDictionary * dictx = dic[@"obj"];
            ECarConfigs * config = [ECarConfigs shareInstance];
            config.orignOrderNo = [NSString stringWithFormat:@"%@", [dictx objectForKey:@"orderId"]];
            config.currentPrice = [NSString stringWithFormat:@"%@", self.currentMoney];
            zhifuVC.priceCar = [NSString stringWithFormat:@"%zd",[_lastMoney integerValue]];
            zhifuVC.priceUnit = self.levelUnit;
            zhifuVC.orderID = dictx[@"orderId"];
            zhifuVC.canBack = YES;
            zhifuVC.sendType = sendToHouTaiByVip;
            [self.navigationController pushViewController:zhifuVC animated:YES];
        } error:^(NSError *error) {
            [weakSelf hideHUD];
            [weakSelf delayHidHUD:@"网络异常"];
        } completed:^{
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
