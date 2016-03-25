//
//  ECarBuyMemberViewController.h
//  ElectricCarRent
//
//  Created by 彭懂 on 15/12/3.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECarUserManager.h"
#import "ECarUser.h"
#import "ECarZhiFuViewController.h"

@protocol ECarBuyMemberViewControllerDelegate <NSObject>

- (void)fromOtherViewPopMyView;

@end

@interface ECarBuyMemberViewController : ECarBaseViewController

//@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * messege;

@property (nonatomic , copy)NSString * levelMoney;
@property (nonatomic , copy)NSString * orderID;
@property (nonatomic , copy)NSString * levelCode;
@property (nonatomic , copy)NSString * levelUnit;
@property (nonatomic , copy)NSString * currentMoney;

@property (nonatomic , copy)NSString * wumaiMoney;
@property (nonatomic , copy)NSString * wumaiText;
@property (nonatomic , copy)NSString * wumaiType;

@property (nonatomic, assign) id <ECarBuyMemberViewControllerDelegate> memberDelegate;

@end
