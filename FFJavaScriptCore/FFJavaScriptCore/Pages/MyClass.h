//
//  MyClass.h
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/8.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;

- (void)method1; - (void)method2;
+ (void)classMethod1;

@end
