//
//  LoginViewController.h
//  OrangeFun
//
//  Created by yuebo.jiang on 2018/3/5.
//  Copyright © 2018年 Jerry. All rights reserved.
//

#import "ViewController.h"

@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBT;

@property (weak, nonatomic) IBOutlet UIButton *loginBT;

@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBT;

@end
