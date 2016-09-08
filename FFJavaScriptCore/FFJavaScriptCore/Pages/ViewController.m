//
//  ViewController.m
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import "ViewController.h"
#import "FFJSObject.h"
#import "FFPerson.h"
#import "MyClass.h"
#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor orangeColor];
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
    
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
        
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
    //异常处理
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
    [context evaluateScript:@"ider.zheng = 21"];
    
    //使用Block的注意事项
    //在Block内都不要直接使用其外部定义的JSContext对象或者JSValue，应该将其当做参数传入到Block中，
    //或者通过JSContext的类方法+ (JSContext *)currentContext;来获得。否则会造成循环引用使得内存无法被正确释放。
    
    /************************************************************************/
    //所有的对象其实可以视为一组键值对的集合，
    //所以JavaScript中的对象可以返回到Objective-C中当做NSDictionary类型进行访问。
    JSValue *obj =[context evaluateScript:@"var jsObj = { number:7, name:'Ider' }; jsObj"];
    NSLog(@"%@, %@", obj[@"name"], obj[@"number"]);
    NSDictionary *dic = [obj toDictionary];
    NSLog(@"%@, %@", dic[@"name"], dic[@"number"]);
    
    //同样的，NSDicionary和NSMutableDictionary传入到JSContext之后也可以直接当对象来调用:
    NSDictionary *dic2 = @{@"name": @"Ider", @"#":@(21)};
    context[@"dic"] = dic2;
    [context evaluateScript:@"log(dic.name, dic['#'])"];
    /************************************************************************/
    
    FFPerson *person = [[FFPerson alloc] init];
    context[@"p"] = person;
    person.firstName = @"Ider";
    person.lastName = @"Zheng";
    person.urls = @{@"site": @"http://www.iderzheng.com"};
    
    // ok to get fullName
    [context evaluateScript:@"log(p.fullName());"];
    // cannot access firstName
    [context evaluateScript:@"log(p.firstName);"];
    // ok to access dictionary as object
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog);"];
    // ok to change urls property
    [context evaluateScript:@"p.urls = {blog:'http://blog.iderzheng.com'}"];
    [context evaluateScript:@"log('-------AFTER CHANGE URLS-------')"];
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog);"];
    
    // affect on Objective-C side as well
    NSLog(@"%@", person.urls);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:",class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1)); imp();
    NSLog(@"==========================================================");
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");

}

@end
