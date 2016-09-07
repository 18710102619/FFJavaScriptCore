//
//  FFJSObject.m
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import "FFJSObject.h"

@implementation FFJSObject

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)noParameter
{
    NSLog(@"this is ios TestNOParameter");
}
-(void)oneParameter:(NSString *)message
{
    NSLog(@"this is ios TestOneParameter=%@",message);
}
-(void)towParameter:(NSString *)message1 SecondParameter:(NSString *)message2
{
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}

@end
