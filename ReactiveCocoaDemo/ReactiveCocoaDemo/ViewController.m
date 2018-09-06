//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 周旭斌 on 2018/6/25.
//  Copyright © 2018年 周旭斌. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import <RACEXTScope.h>
#import "TanLoginViewModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *juhuaView;
@property (strong, nonatomic) TanLoginViewModel *viewModel;

@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self textFieldChange];
    
//    [self textConvert];
    
//    [self vertifyLoginButton];
    
//    [self addButtonTarget];
    
//    [self loginButtonClick];
    
//    [self removeSubcriber];
    
//    [self firstSignalAndSecondSignal];
    
//    [self searchText];
    
//    [self finalSearchText];
    
//    [self signalMakeUp];
    
//    [self oneByOneSignals];
    
//    [self raccommandLogin];
    
    [self RACReplaySubject];
    
//    self.juhuaView.hidden = YES;
//    _viewModel = [[TanLoginViewModel alloc]init];
//
//    @weakify(self)
//    RAC(self.viewModel, userName) = self.userNameTF.rac_textSignal;
//    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
//    self.loginBtn.rac_command = self.viewModel.loginCommand;
//    [[self.viewModel.loginCommand executionSignals]
//     subscribeNext:^(RACSignal *x) {
//         @strongify(self)
//         self.juhuaView.hidden = NO;
//         [x subscribeNext:^(NSString *x) {
//             self.juhuaView.hidden = YES;
//             NSLog(@"%@",x);
//         }];
//     }];
}

#pragma mark - reactiveCocoa demo
/**
 监听文本框的输入
 */
- (void)textFieldChange {
    UITextField *textFidle = [[UITextField alloc] init];
    textFidle.frame = CGRectMake(100, 100, 200, 40);
    textFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textFidle];
    
    // 监听文本框的输入,而且只有大于3个长度的时候才会打印
    [[textFidle.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }]
     subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"%@", x);
     }];
}

/**
 类型的转换,可以理解为用map包装成其他的数据类型
 */
- (void)textConvert {
    UITextField *textFidle = [[UITextField alloc] init];
    textFidle.frame = CGRectMake(100, 100, 200, 40);
    textFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textFidle];
    
    // 监听文本框的输入,而且只有大于3个长度的时候才会打印,打印的信息是经过map包装过的，数据类型就是return的类型
    [[textFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 3);
    }]
     subscribeNext:^(NSNumber *  _Nullable x) {
         NSLog(@"%d", x.boolValue);
     }];
}

/**
 应用场景：两个文本框的输入正确的时候变成黄色
 */
- (void)vertifyTextField {
    UITextField *nameTextFidle = [[UITextField alloc] init];
    nameTextFidle.frame = CGRectMake(100, 100, 200, 40);
    nameTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:nameTextFidle];
    // 这里创建一个值为bool的信号,其中block的参数value为前面rac_textSignal的值，即text内容
    RACSignal *nameSignal = [nameTextFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidText:value]);
    }];
    /*
     第一种写法，比较麻烦
    // 把上面的信号的值再次包装成值为颜色的信号
    [[nameSignal map:^id _Nullable(NSNumber *  _Nullable value) {
        return value.boolValue ? [UIColor yellowColor] : [UIColor grayColor];
    }] subscribeNext:^(UIColor *  _Nullable x) {
        // 每次输入都会有一个颜色过来
        nameTextFidle.backgroundColor = x;
    }];
     */
    RAC(nameTextFidle, backgroundColor) = [nameSignal map:^id _Nullable(NSNumber *  _Nullable value) {
        return value.boolValue ? [UIColor yellowColor] : [UIColor grayColor];
    }];
    
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    RACSignal *pwdSignal = [pwdTextFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidText:value]);
    }];
    
    /*
    [[pwdSignal map:^id _Nullable(NSNumber *  _Nullable value) {
        return value.boolValue ? [UIColor yellowColor] : [UIColor grayColor];
    }] subscribeNext:^(UIColor *  _Nullable x) {
        pwdTextFidle.backgroundColor = x;
    }];
     */
    RAC(pwdTextFidle, backgroundColor) = [pwdSignal map:^id _Nullable(NSNumber *  _Nullable value) {
        return value.boolValue ? [UIColor yellowColor] : [UIColor grayColor];
    }];
}

/**
 组合信号，应用场景：当账号和密码都输入合法的时候登录按钮才能点击
 */
- (void)vertifyLoginButton {
    UITextField *nameTextFidle = [[UITextField alloc] init];
    nameTextFidle.frame = CGRectMake(100, 100, 200, 40);
    nameTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:nameTextFidle];
    // 这里创建一个值为bool的信号,其中block的参数value为前面rac_textSignal的值，即text内容
    RACSignal *nameSignal = [nameTextFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidText:value]);
    }];
    
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    RACSignal *pwdSignal = [pwdTextFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidText:value]);
    }];
    
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = [UIColor grayColor];
    loginButton.frame = CGRectMake(150, 220, 100, 100);
    [self.view addSubview:loginButton];
    
    // 组合了账号输入框的信号和密码的信号，当两个都合法的时候登录按钮的背景颜色变为绿色，把两个信号聚合成一个新的值为颜色的信号，并且信号值直接赋值给登录按钮的背景颜色
    RAC(loginButton, backgroundColor) = [RACSignal combineLatest:@[nameSignal, pwdSignal] reduce:^id _Nonnull(NSNumber *nameSignal, NSNumber *pwdSignal){
        return (nameSignal.boolValue && pwdSignal.boolValue) ? [UIColor yellowColor] : [UIColor grayColor];
    }];
}

/**
 按钮的点击事件
 */
- (void)addButtonTarget {
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = [UIColor grayColor];
    loginButton.frame = CGRectMake(150, 220, 100, 100);
    [self.view addSubview:loginButton];
    
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

/**
 登录按钮点击后根据返回的结果来执行后续的操作
 */
- (void)loginButtonClick {
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = [UIColor grayColor];
    loginButton.frame = CGRectMake(150, 220, 100, 100);
    [loginButton setTitle:@"测试" forState:UIControlStateNormal];
    [loginButton setTitle:@"测试5" forState:UIControlStateDisabled];
    [loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor yellowColor] forState:UIControlStateDisabled];
    [self.view addSubview:loginButton];
    
    [[[[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       //
      doNext:^(__kindof UIControl * _Nullable x) {
          loginButton.backgroundColor = [UIColor redColor];
      }]
      // 这个是把信号中的信号取出来，可以取出里面信号的值，也就是接口返回值(取出里面的信号，然后订阅这个信号)
      flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
          return [self loginSignal];
      }] subscribeNext:^(__kindof UIControl * _Nullable x) {
          loginButton.backgroundColor = [UIColor grayColor];
        NSLog(@"%@", x);
    }];
}

/**
 返回执行登录请求的信号，目的是为了能够获取到登录接口的返回值
 */
- (RACSignal *)loginSignal {
    RACSignal *siganal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 这里进行网络请求
        DELAY(1000000000);
        [subscriber sendNext:@"登录成功"];
        [subscriber sendCompleted];
//        [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1000 userInfo:@{@"aaa" : @"bbb"}]];
        return nil;
    }];
    return siganal;
}

/**
 信号订阅的移除
 */
- (void)removeSubcriber {
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    // 信号不订阅是不会执行block里面的代码的
    // 如果self对这个信号有抢引用的话，就会有循环引用的问题了
    @weakify(self)
    RACSignal *textSignal = [pwdTextFidle.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self)
        return @([self isValidText:value]);
    }];
    
    RACDisposable *disposable = [textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 移除订阅者之后，信号就会被销毁
    [disposable dispose];
}

/**
 当一个请求完成以后接着又要进行一个请求用then
 */
- (void)firstSignalAndSecondSignal {
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    // 先创建登录信号，并且订阅
    [[[[self loginSignal] then:^RACSignal * _Nonnull{
        // 这里返回一个信号，当上一个信号发送complete消息的时候会订阅这个信号
        return pwdTextFidle.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) {
        return [self isValidText:value];
    }]
     subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

/**
 这里接着上一个用法，新加一个功能，在then里面订阅了文本框的输入信号，随后根据文本框的内容来搜索内容，也就是模糊搜索，这里需要把文本框的next事件映射到新的信号中，所以要用到flattenmap，这里返回一个新的信号，也就是模糊搜索的信号，并且订阅他
 */
- (void)searchText {
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    // 先创建登录信号，并且订阅
    [[[[[[self loginSignal] then:^RACSignal * _Nonnull{
        // 这里返回一个信号，当上一个信号发送complete消息的时候会订阅这个信号
        NSLog(@"登录成功");
        return pwdTextFidle.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) {
        return [self isValidText:value];
    }] flattenMap:^__kindof RACSignal * _Nullable(NSString *  _Nullable value) {
        return [self signalForSearchWith:value];
    }]
      // 这里是切换到主线程
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id  _Nullable x) {
         // 这里的线程是和发送next事件的线城是相同的，所以在这里需要回到主线程
         NSLog(@"%@", x);
     } error:^(NSError * _Nullable error) {
         NSLog(@"%@", error);
     }];
}

- (RACSignal *)signalForSearchWith:(NSString *)searchContent {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 这里进行一个搜索的请求
            NSLog(@"searchContent%@", searchContent);
            DELAY(100000000);
            // 如果请求成功就发送next和complete事件,如果失败就发送error事件
            [subscriber sendNext:@"这里是返回值"];
            [subscriber sendCompleted];
        });
//        [subscriber sendError:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕后就会被销毁，没有订阅者的时候就会被销毁");
        }];
        return nil;
    }];
}

/**
 节流操作，指的是在一个时间段内，没有连续收到next事件才会执行后续的操作
 类似于这种模糊搜索不能再每次输入的时候就去执行搜搜请求，正确的做法是在输入后一段时间内如果没有接受到新的输入才开始执行搜索请求，假如用户连续的输入就不执行搜索请求
 这里接着上一个用法，新加一个功能，在then里面订阅了文本框的输入信号，随后根据文本框的内容来搜索内容，也就是模糊搜索，这里需要把文本框的next事件映射到新的信号中，所以要用到flattenmap，这里返回一个新的信号，也就是模糊搜索的信号，并且订阅他
 */
- (void)finalSearchText {
    UITextField *pwdTextFidle = [[UITextField alloc] init];
    pwdTextFidle.frame = CGRectMake(100, 160, 200, 40);
    pwdTextFidle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pwdTextFidle];
    
    // 先创建登录信号，并且订阅
    [[[[[[[self loginSignal] then:^RACSignal * _Nonnull{
        // 这里返回一个信号，当上一个信号发送complete消息的时候会订阅这个信号
        NSLog(@"登录成功");
        return pwdTextFidle.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) {
        return [self isValidText:value];
    }] throttle:3.0]
       flattenMap:^__kindof RACSignal * _Nullable(NSString *  _Nullable value) {
        return [self signalForSearchWith:value];
    }]
      // 这里是切换到主线程
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id  _Nullable x) {
         // 这里的线程是和发送next事件的线城是相同的，所以在这里需要回到主线程
         NSLog(@"%@", x);
     } error:^(NSError * _Nullable error) {
         NSLog(@"%@", error);
     }];
}

/**
 待两个任务都完成以后再执行后续的操作 应用场景：有时候需要有好几个网络任务一起进行，当这几个任务都执行完后再执行后面的操作，在使用RAC之外可以使用原生的任务调度组，可以到达同样的效果,这里只介绍RAC的用法
 */
- (void)signalMakeUp {
    // 信号1，网络请求1
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        DELAY(10000000000);
        [subscriber sendNext:@"任务一完成"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号取消订阅或者完成");
        }];
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        DELAY(100000000000);
        [subscriber sendNext:@"任务二完成"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号取消订阅或者完成");
        }];
    }];
    
    // 这个是把两个信号合在一起，返回一个新的信号
    [[RACSignal merge:@[signal1, signal2]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"aaa%@", x);
    } completed:^{
        NSLog(@"两个任务都完成了");
    }];
//    这个方法没有上面的好，但是可以同时拿到两个信号的值，上面那个方法虽然也可以拿到，但是并不是同时拿到的
//    [self rac_liftSelector:@selector(finalTask:second:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)finalTask:(id)signal1 second:(id)signal2 {
    NSLog(@"signal1%@=====signal2%@", signal1, signal2);
}

/**
 上面提到几个信号之间（几个网络请求）之间有先后可以用到then，这里建议一种合适的方法，并且开发用的比较多的用法
 */
- (void)oneByOneSignals {
    [[[[self firstSignal] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return nil;
        return [self secondSignal];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return [self thirdSignal];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"最后的结果%@", x);
    }];
}

- (RACSignal *)firstSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 这里进行一个搜索的请求
        DELAY(1000000000000);
        // 如果请求成功就发送next和complete事件,如果失败就发送error事件
        [subscriber sendNext:@"第一个任务"];
        [subscriber sendCompleted];
        //        [subscriber sendError:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"1默认信号发送完毕后就会被销毁，没有订阅者的时候就会被销毁");
        }];
    }];
}

- (RACSignal *)secondSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 这里进行一个搜索的请求
        DELAY(100000000000);
        // 如果请求成功就发送next和complete事件,如果失败就发送error事件
        [subscriber sendNext:@"第二个任务"];
        [subscriber sendCompleted];
        //        [subscriber sendError:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"2默认信号发送完毕后就会被销毁，没有订阅者的时候就会被销毁");
        }];
    }];
}

- (RACSignal *)thirdSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 这里进行一个搜索的请求
        DELAY(10000000000);
        // 如果请求成功就发送next和complete事件,如果失败就发送error事件
        [subscriber sendNext:@"第三个任务"];
        [subscriber sendCompleted];
        //        [subscriber sendError:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"3默认信号发送完毕后就会被销毁，没有订阅者的时候就会被销毁");
        }];
    }];
}

/**
 RACCommand raccommand通常用来封装一个个网络请求，而RACSubject通常当做代理来使用,两者一定要理清
 */
- (void)raccommandLogin {
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(100, 100, 100, 100);
    loginButton.backgroundColor = [UIColor redColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"123"];
                [subscriber sendCompleted];
            });
            //            [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:@{@"name" : @"hhh"}]];
            return nil;
        }];
    }];
//    RACCommand *command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        NSLog(@"正在加载。。。");
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            DELAY(10000000000000000)
//            NSLog(@"加载完成。。。");
//            [subscriber sendNext:@"123"];
//            [subscriber sendCom·pleted];
////            [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:100 userInfo:@{@"name" : @"hhh"}]];
//            return nil;
//        }];
//    }];
    loginButton.rac_command = command;
    
    [[command executionSignals] subscribeNext:^(RACSignal *  _Nullable x) {
        NSLog(@"正在加载...");
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"加载完成%@", x);
        }];
    }];
    // 这中方法可以直接取到信号中的信号
//    [[[_command executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"结果%@", x);
//    }];
    
    [command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"NSError%@", x);
    }];
    
    // skip是跳过第一次，
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"NSNumber%@", x);
    }];
}

/**
 重复提供信号类，这个类可以先发送信号，然后再订阅，订阅完了之后可以拿到之前所有的值，
 */
- (void)RACReplaySubject {
    // 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
    // 使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:3];
    
    [subject sendNext:@"111"];
    [subject sendNext:@"222"];
    [subject sendNext:@"333"];
    [subject sendNext:@"444"];
    
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者%@", x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者%@", x);
    }];
}

#pragma mark - priviete method
- (BOOL)isValidText:(NSString *)text {
    if (text.length > 3) {
        return YES;
    }else {
        return NO;
    }
}

- (void)injected {
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
