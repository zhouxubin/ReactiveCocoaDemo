//
//  TanLoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 周旭斌 on 2018/7/20.
//  Copyright © 2018年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import <RACEXTScope.h>

@interface TanLoginViewModel : NSObject

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong, readonly) RACCommand *loginCommand;

+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password;

@end
