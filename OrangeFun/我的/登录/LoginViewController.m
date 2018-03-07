//
//  LoginViewController.m
//  OrangeFun
//
//  Created by yuebo.jiang on 2018/3/5.
//  Copyright © 2018年 Jerry. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+NSString.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)fetchVerifyCode:(UIButton *)sender {
    [self openCountdown];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    
}

- (void)initView{
    //手机号
    UIView *leftPhoneNumberImageFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 24)];
    UIImageView *phoneNumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 24)];
    phoneNumberImageView.image = [UIImage imageNamed:@"phonenumber"];
    [leftPhoneNumberImageFrameView addSubview:phoneNumberImageView];
    
    self.phoneNumberTF.leftView = leftPhoneNumberImageFrameView;
    self.phoneNumberTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumberTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //验证码
    UIView *leftVerifyImageFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 39, 22)];
    UIImageView *verifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 22)];
    verifyImageView.image = [UIImage imageNamed:@"verifycode"];
    [leftVerifyImageFrameView addSubview:verifyImageView];
    
    self.verifyCodeTF.leftView = leftVerifyImageFrameView;
    self.verifyCodeTF.leftViewMode = UITextFieldViewModeAlways;
    self.verifyCodeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //获取验证码按钮
    self.verifyCodeBT.layer.cornerRadius = 5;
    
    //登录按钮
    self.loginBT.layer.cornerRadius = 22;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = @"登录";
}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberTF resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.verifyCodeBT setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.verifyCodeBT setBackgroundColor:[UIColor colorWithString:@"#faa701"]];
                self.verifyCodeBT.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.verifyCodeBT setTitle:[NSString stringWithFormat:@"重发(%.2d)",seconds] forState:UIControlStateNormal];
                [self.verifyCodeBT setBackgroundColor:[UIColor colorWithString:@"#cccccc"]];
                self.verifyCodeBT.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
