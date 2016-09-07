//
//  FFJSObject.h
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
-(void)noParameter;
-(void)oneParameter:(NSString *)message;
-(void)towParameter:(NSString *)message1 SecondParameter:(NSString *)message2;

@end

//让我们创建的类实现上边的协议
@interface FFJSObject : NSObject<JSObjectProtocol>

@end
