//
//  StartButtonScene.m
//  AngryTry
//
//  Created by apple on 13-7-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "StartButtonScene.h"
#import "levelScene.h"

@implementation StartButtonScene

+ (id) scene
{
    CCScene *sc = [CCScene node];
    StartButtonScene *sbsc = [StartButtonScene node];
    [sc addChild:sbsc];
    return sc;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        // 创建菜单
        CGSize s = [[CCDirector sharedDirector] winSize];
        // 得到屏幕宽高
//        CCSprite *bgSprite = [CCSprite spriteWithFile:@"startbg.png"];
//        [bgSprite setPosition:ccp(s.width/2.0f, s.height/2.0f)];
//        // 以图片创建背景精灵
//        [self addChild:bgSprite];
        
        CCSprite *angryBirdSprite = [CCSprite spriteWithFile:@"angrybird.png"];
        [angryBirdSprite setPosition:ccp(240.0f, 250.0f)];
        [self addChild:angryBirdSprite];
        
        // 加菜单
        CCSprite *beginSprite = [CCSprite spriteWithFile:@"start.png"];
        CCSprite *biggerbeginSprite = [CCSprite spriteWithFile:@"start.png"];
        [biggerbeginSprite setScale:1.03f];
        //[CCSprite spriteWithFile:@"start@2x.png"];
        [beginSprite setAnchorPoint:ccp(0.5, 0.5)];
        [biggerbeginSprite setAnchorPoint:ccp(0.5, 0.5)];
        
        CCMenuItemSprite *beginMenuItem = [CCMenuItemSprite itemFromNormalSprite:beginSprite selectedSprite:biggerbeginSprite target:self selector:@selector(beginGame:)];
//        CCMenuItemSprite *biggerMenuItem = [CCMenuItemSprite itemFromNormalSprite:biggerbeginSprite selectedSprite:nil target:self selector:@selector(beginGame:)];
        // 创建一个菜单项，里面放两个精灵
        // 正常状态和点击状态
//        [beginMenuItem setAnchorPoint:ccp(0.5, 0.5)];
        CCMenu *menu = [CCMenu menuWithItems:beginMenuItem, nil];
//        [CCMenu menuWithItems:	, nil]	
//        [menu setPositionInPixels:];
//        [menu]				
//        [menu setAnchorPoint:ccp(0.5, 0.5)];
        [menu setPosition:ccp(s.width/2.0f, s.height/2.0f-30.0f)];
        [menu alignItemsHorizontally];
        [self addChild:menu];
        
    }
    return self;
}

- (void) beginGame:(id)arg
{
    NSLog(@"开始游戏");
    CCScene *level = [levelScene scene];
//  1.切入效果
//    CCTransitionScene *trans = [[CCTransitionSplitCols alloc] initWithDuration:2.0f scene:level];
//  2.雷达效果
//    CCTransitionScene *trans = [[CCTransitionRadialCCW alloc] initWithDuration:2.0f scene:level];
//  3.小格子动画
//    CCTransitionScene *trans = [[CCTransitionTurnOffTiles alloc] initWithDuration:2.0f scene:level];
//  4.滑动效果
//    CCTransitionScene *trans = [[CCTransitionSlideInL alloc] initWithDuration:2.0f scene:level];
//  5.翻转效果
//    CCTransitionScene *trans = [[CCTransitionFlipX alloc] initWithDuration:2.0f scene:level];
//  6.
    CCTransitionScene *trans = [[CCTransitionCrossFade alloc] initWithDuration:0.5f scene:level];
    // 给一个时间，让他动画到level剧场
    // trans本来也是一个剧场
    [[CCDirector sharedDirector] replaceScene:trans];
    [trans release];
//    CCJumpBy
}

@end
