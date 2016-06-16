//
//  ViewController.m
//  WebviewJsBridge
//
//  Created by Thinkive on 16/6/8.
//  Copyright © 2016年 Thinkive. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioViewController.h"
#import "TeoModel.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,MFMailComposeViewControllerDelegate>

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) JSContext *jsContext;
@property(nonatomic,strong) UIWebView *webView;

//拍照
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic,assign) BOOL isAlbum;
@property(nonatomic,assign) BOOL isVideo;

//录音


@end


@implementation ViewController

- (void)loadExamplePage:(UIWebView*)webView {
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    TeoModel *model  = [[TeoModel alloc] init];
    self.jsContext[@"WebViewFunc"] = model;
    model.jsContext = self.jsContext;
    
    __weak typeof(self) weakSelf = self;
    model.jscallObjcBlock = ^(NSString *name){
        NSLog(@"%@",name);
        
        if ([name isEqualToString:@"jsCallOpenCamera"]) {
//            相机
            _isVideo = NO;
            [weakSelf selectImageFromCameraWith:NO];
        }else if ([name isEqualToString:@"jsCallAlbum"]){
//            相册
            _isVideo = NO;
            [weakSelf selectImageFromCameraWith:YES];

        }else if ([name isEqualToString:@"jsCallMediaRecorder"]){
//            录音
            [weakSelf toAudio];
            
        }else if ([name isEqualToString:@"jsCallRecordVideo"]){
//            录视频
            _isVideo = YES;
            [weakSelf selectImageFromCameraWith:NO];

            
        }else if ([name isEqualToString:@"jsCallMail"]){
//            发邮件
            [weakSelf toEmal];
            
        }else if ([name isEqualToString:@"jsCallOpenTel"]){
            //            打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:18566742667"]]];
        }
        
    };
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self loadExamplePage:self.webView];
    
}


//******************************** 相机 ****************************
- (void)selectImageFromCameraWith:(BOOL)isAlbum{
    _isAlbum = isAlbum;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark 从摄像头获取图片或视频
#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker
{
    if (!_imagePicker)
    {
        _imagePicker=[[UIImagePickerController alloc] init];
        //设置image picker的来源，这里设置为摄像头
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //设置使用哪个摄像头，这里设置为后置摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
        _imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    if (self.isVideo) {
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        //设置摄像头模式（拍照，录制视频）
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        [_imagePicker  setVideoMaximumDuration:20];
        
    }else{
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
    }
    
    if (!_isAlbum)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置使用哪个摄像头，这里设置为后置摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    }
    else
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }

    
    return _imagePicker;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         self.imagePicker = nil;
     }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         self.imagePicker = nil;
     }];
    
}


//******************************** 录音 ****************************
- (void)toAudio{
    AudioViewController *adVC = [[AudioViewController alloc] init];
    [self presentViewController:adVC animated:YES completion:nil];
}


//******************************** 邮件 ****************************
- (void)toEmal{
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    //设置邮件主题
    [vc setSubject:@""];
    [vc setMessageBody:@"" isHTML:NO];
    [vc setToRecipients:@[]];
    //设置代理
    vc.mailComposeDelegate = self;
    //显示控制器
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 *  点击取消按钮会自动调用
 *
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
