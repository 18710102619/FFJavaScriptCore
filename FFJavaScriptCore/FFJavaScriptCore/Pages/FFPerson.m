//
//  FFPerson.m
//  FFJavaScriptCore
//
//  Created by 张玲玉 on 16/9/7.
//  Copyright © 2016年 bj.zly.com. All rights reserved.
//

#import "FFPerson.h"

@implementation FFPerson

@synthesize firstName, lastName, urls;

- (NSString *)fullName {
    
    NSLog(@"*********我被调用了*********");
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
