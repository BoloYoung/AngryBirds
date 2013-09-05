//
//  LoadingScene.m
//  AngryTry
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "LoadingScene.h"
#import "StartScene.h"

@implementation LoadingScene
+ (id) scene
{
    CCScene *sc = [CCScene node];
    // 创建空的剧场
    LoadingScene *ls = [LoadingScene node];
    // 创建自己的节目
    [sc addChild:ls];
    // 把节目加到通用剧场尚
    return sc;
}
+ (id) node
{
    return [[[[self class] alloc] init]autorelease];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        // 标准init方法
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 通过导演类来获得屏幕宽高
        CCSprite *sp = [CCSprite spriteWithFile:@"loading.png"];
        // 创建一个图片精灵；
        [sp setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        // 设置精灵中心坐标
        // cpp = CGPointMake
        [self addChild:sp];
        // self为loadingScene
        
        loadingTitle = [[CCLabelBMFont alloc] initWithString:@"Loading" fntFile:@"arial16.fnt"];
        // 吧loading字符串加载
        [loadingTitle setAnchorPoint:ccp(0.0f, 0.0f)];
        // 设置锚点为（0.0f，0.0f）
        [loadingTitle setPosition:ccp(winSize.width - 80.0f, 10.0f)];
        [self addChild:loadingTitle];
        // 让loading每秒前进一个点
        [self schedule:@selector(loadTick:) interval:0.25f];
    }
    return self;
}

- (void) loadTick:(double)dt
{
    // 每隔1.5s调用一次
    static int count;
    count++;
    NSString *s = [NSString stringWithFormat:@"%@%@",[loadingTitle string], @"."];
    // 在原来字符串后追加一个.
    [loadingTitle setString:s];
    // 反赋值
    if (count >= 4)
    {
        [self unscheduleAllSelectors];
        CCScene *sc = [StartScene scene];
        [[CCDirector sharedDirector] replaceScene:sc];
    }
    
}

- (void) dealloc
{
    [loadingTitle release];
    loadingTitle = nil;
    [super dealloc];
}


@end
