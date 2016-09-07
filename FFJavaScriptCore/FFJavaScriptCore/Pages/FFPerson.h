//
//  FFPerson.h
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol FFPersonProtocol <JSExport>

@property (nonatomic, retain) NSDictionary *urls;
- (NSString *)fullName;

@end

@interface FFPerson :NSObject <FFPersonProtocol>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end;

