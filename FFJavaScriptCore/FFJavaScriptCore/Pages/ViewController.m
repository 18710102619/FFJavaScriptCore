//
//  ViewController.m
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import "ViewController.h"
#import "FFJSObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JSContext *context = [[JSContext alloc] init];
    
    /************************************************************************/
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    context[@"test1"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    //此处我们没有写后台（但是前面我们已经知道iOS是可以调用js的，我们模拟一下）
    //首先准备一下js代码，来调用js的函数test1 然后执行
    //一个参数
    NSString *jsFunctStr=@"test1('参数1')";
    [context evaluateScript:jsFunctStr];
    
    //二个参数
    NSString *jsFunctStr1=@"test1('参数a','参数b')";
    [context evaluateScript:jsFunctStr1];
    
    
    /************************************************************************/
    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    FFJSObject *jsObject=[FFJSObject new];
    context[@"jsObject"]=jsObject;
    
    //同样我们也用刚才的方式模拟一下js调用方法
    NSString *jsStr1=@"jsObject.noParameter()";
    [context evaluateScript:jsStr1];
    NSString *jsStr2=@"jsObject.oneParameter('参数1')";
    [context evaluateScript:jsStr2];
    NSString *jsStr3=@"jsObject.towParameterSecondParameter('参数A','参数B')";
    [context evaluateScript:jsStr3];
    
    
    /************************************************************************/
    //JSValue则可以说是JavaScript和Object-C之间互换的桥梁，
    //它提供了多种方法可以方便地把JavaScript数据类型转换成Objective-C，或者是转换过去。
    JSValue *jsVal = [context evaluateScript:@"21+7"];
    int iVal = [jsVal toInt32];
    NSLog(@"JSValue: %@, int: %d", jsVal, iVal);
    
    //还可以存一个JavaScript变量在JSContext中，然后通过下标来获取出来。
    //而对于Array或者Object类型，JSValue也可以通过下标直接取值和赋值。
    [context evaluateScript:@"var arr = [21, 7 , 'iderzheng.com'];"];
    JSValue *jsArr = context[@"arr"]; // Get array from JSContext
    
    NSLog(@"JS Array: %@; Length: %@", jsArr, jsArr[@"length"]);
    jsArr[1] = @"blog"; // Use JSValue as array
    jsArr[7] = @7;
    
    NSLog(@"JS Array: %@; Length: %d", jsArr, [jsArr[@"length"] toInt32]);
    
    NSArray *nsArr = [jsArr toArray];
    NSLog(@"NSArray: %@", nsArr);
    

    /************************************************************************/
    //各种数据类型可以转换，
    //Objective-C的Block也可以传入JSContext中当做JavaScript的方法使用。
    context[@"log"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        //获取参数列表
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        //当前调用该方法的对象
        JSValue *this = [JSContext currentThis];
        //在JavaScript里，所有全局变量和方法其实都是一个全局变量的属性
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
    };
    
    [context evaluateScript:@"log('ider', [7, 21], { hello:'world', js:100 });"];
    
    
    /************************************************************************/
    //可以反过来将参数传进去来调用方法。
    [context evaluateScript:@"function add(a, b) { return a + b; }"];
    JSValue *add = context[@"add"];
    NSLog(@"Func: %@", add);
    
    JSValue *sum = [add callWithArguments:@[@(7), @(21)]];
    NSLog(@"Sum: %d",[sum toInt32]);
    
    
    /************************************************************************/
    
    /************************************************************************/
    
    /************************************************************************/
}



@end
