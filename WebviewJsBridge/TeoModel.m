//
//  TeoModel.m
//  WebviewJsBridge
//
//  Created by Thinkive on 16/6/12.
//  Copyright © 2016年 Thinkive. All rights reserved.
//

#import "TeoModel.h"

@implementation TeoModel

// Js调用了callSystemCamera
- (void)jsCallOpenCamera:(NSString *)string {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    NSLog(@"Js调用了OC的方法，参数为：%@", string);
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    JSValue *jsFunc = self.jsContext[string];
    [jsFunc callWithArguments:@[@"CCCC"]];
    
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('ewmcontent').value='朱祁林';"];
    
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallOpenCamera");
    }
}

- (void)jsCallMediaRecorder:(NSString *)string{
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallMediaRecorder");
    }
}

- (void)jsCallAlbum:(NSString *)string{
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallAlbum");
    }
}

- (void)jsCallMail:(NSString *)string{
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallMail");
    }
}


- (void)jsCallRecordVideo:(NSString *)string{
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallRecordVideo");
    }
}

- (void)jsCallOpenTel{
    if (_jscallObjcBlock) {
        _jscallObjcBlock(@"jsCallOpenTel");
    }
}


@end
