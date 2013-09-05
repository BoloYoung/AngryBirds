//
//  AppDelegate.m
//  AngryTry
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import "RootViewController.h"
#import "LoadingScene.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
    {
        // 设置导演类型
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
    }
    
    CCDirector *director = [CCDirector sharedDirector];
    // 取得当前导演
    // 创建一个舞台
    EAGLView *glView = [EAGLView viewWithFrame:[self.window bounds]pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
    [director setOpenGLView:glView];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        [director setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
        // 设置游戏方向为左横平
    }

    [director setAnimationInterval:1.0f/60.0f];
    // 设置游戏刷新率为每秒60真
    [director setDisplayFPS:YES];
    //
    
    RootViewController *rvc = [[RootViewController alloc] init];
    [rvc setView:glView];
    [self.window setRootViewController:rvc];
    [rvc release];
    // 把rvc作为window作为根视图
    
    [self.window makeKeyAndVisible];
    // 屏幕要显示第一个剧场
    CCScene *sc = [LoadingScene scene];
    [[CCDirector sharedDirector] runWithScene:sc];
    // 让导演运行剧场
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] pause];
    // 暂停游戏 
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CCDirector sharedDirector] stopAnimation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CCDirector sharedDirector] startAnimation];
    // 开始动画
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] resume];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    CCDirector *director = [CCDirector sharedDirector];
    [[director openGLView] removeFromSuperview];
    [self.window release];
    [director end];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) applicationSignificantTimeChange:(UIApplication *)application
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
