//
//  ViewController.m
//  SendMessageAndEmail
//
//  Created by iosdev on 17/6/1.
//  Copyright © 2017年 iosdev. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction]; // 调用发送邮件的代码
    }else{
        NSLog(@"用户未设置邮箱账户");
    }
    //发送短信
    if ([MFMessageComposeViewController canSendText]) {
        [self sendMessageAction];
    }else{
        NSLog(@"用户不能发送短信");
    }

    
}

#pragma mark -发送邮件
- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"邮箱号码"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    UIImage *image = [UIImage imageNamed:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"pdf文件"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存草稿文件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送成功");
            break;
        default:
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -发送短信
//  调用系统API发送短信
- (void)sendMessageAction{
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    // 设置短信代理
    messageVC.messageComposeDelegate = self;
    // 发送给谁
    messageVC.recipients = @[@"18701235678"];
    // 发送的内容
    messageVC.body = @"hello world";
    // 弹出发送短信的视图
    [self presentViewController:messageVC animated:YES completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
