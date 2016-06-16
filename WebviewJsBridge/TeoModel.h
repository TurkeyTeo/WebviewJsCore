//
//  TeoModel.h
//  WebviewJsBridge
//
//  Created by Thinkive on 16/6/12.
//  Copyright © 2016年 Thinkive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

// JS调用此方法来调用OC的系统相册方法
- (void)jsCallOpenCamera:(NSString *)string;
- (void)jsCallMediaRecorder:(NSString *)string;
- (void)jsCallAlbum:(NSString *)string;
- (void)jsCallMail:(NSString *)string;
- (void)jsCallRecordVideo:(NSString *)string;
- (void)jsCallOpenTel;

@end

typedef void(^JSCallObjcBlock)(NSString *name);

@interface TeoModel : NSObject<JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, copy) JSCallObjcBlock jscallObjcBlock;

@end
