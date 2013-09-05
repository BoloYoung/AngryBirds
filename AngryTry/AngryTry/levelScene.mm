//
//  levelScene.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "levelScene.h"
#import "GameUtils.h"
#import "StartScene.h"
#import "GameScene.h"


@implementation levelScene

+ (id) scene
{
    CCScene *sc = [CCScene node];
    levelScene *lsc = [levelScene node];
    [sc addChild:lsc];
    return sc;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"selectlevel.png"];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite z:0];
        CCSprite *backsp = [CCSprite spriteWithFile:@"backarrow.png"];
        backsp.position = ccp(40.0f, 40.0f);
        backsp.scale = 0.5f;
        backsp.tag = 100;
        [self addChild:backsp];
        
        // 把self触摸开关打开
        [self setIsTouchEnabled:YES];
        
        // 加上14关
        succeedLevel = [GameUtils readLevelFromFile];
        NSString *imgPath = nil;
        for (int i = 0; i < 14; i++) {
            if (i < succeedLevel)
            {
                // 已通关
                imgPath = @"level.png";
                NSString *str = [NSString stringWithFormat:@"%d",i+1];
                NSLog(@"%@",str);
                CCLabelTTF *numlabel = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(60.0f, 60.0f) alignment:NSTextAlignmentCenter fontName:@"Marker Felt" fontSize:30.0f];
                
                float x = 60+i%7*60;
                float y = 320-95-i/7*80;
                numlabel.position = ccp(x, y);
                [self addChild:numlabel z:2];
            }
            else
            {
                // 未通关
                imgPath = @"clock.png";
            }
            CCSprite *levelSprite = [CCSprite spriteWithFile:imgPath];
            // 设置图片精灵
            levelSprite.tag = i+1; // i+1为了避免tag为0
            float x = 60+i%7*60;
            float y = 320-80-i/7*80;
            levelSprite.position = ccp(x, y);
            levelSprite.scale = 0.6f;
            [self addChild:levelSprite z:1];
        }
    }
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸开始");
}

// 触摸结束的时候
// touches 就是触摸点的集合
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. 拿到ui触摸点
    UITouch *oneTouch = [touches anyObject];
    UIView *touchView = [oneTouch view];
    NSLog(@"触摸点所触摸到的View：x = %f; y = %f",oneTouch.view.frame.origin.x, oneTouch.view.frame.origin.y);
    // 取到当前触摸到的一个uiview
    // 这里的touchview 就是 glview
    CGPoint location = [oneTouch locationInView:touchView];
    // oneTouch 相对 touchView 上的坐标
    NSLog(@"触摸点于所在View上的位置：x = %f, y = %f", location.x, location.y);
    // 2.转成world opengl point
    CGPoint worldGLPoint = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"触摸点转换成世界点：x = %f, y = %f", worldGLPoint.x, worldGLPoint.y);
    CGPoint nodePoint = [self convertToNodeSpace:worldGLPoint];
    NSLog(@"世界点转换成node点：x = %f, y = %f", nodePoint.x, nodePoint.y);
    // 把世界坐标转化为node坐标 self
    // self.children.count self 上所有的孩子
    for (int i = 0; i < self.children.count; i++) {
        CCSprite *oneSprite = [self.children objectAtIndex:i];
        // 取得第i个精灵
        if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == 100) {
            // 如果nodePoint包含在oneSprite中
            // 并且tag为100
            CCScene *sc = [StartScene scene];
            CCTransitionScene *trans = [[CCTransitionCrossFade alloc] initWithDuration:0.5f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        }
        else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag < succeedLevel + 1 && oneSprite.tag > 0)
        {
            NSLog(@"选中了第%d关", oneSprite.tag);
            CCScene *gameScene = [GameScene sceneWithLevel:oneSprite.tag];
            [[CCDirector sharedDirector] replaceScene:gameScene];
        }
        
    }
    
}

@end
