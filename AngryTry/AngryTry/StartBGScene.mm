//
//  StartScene.m
//  AngryTry
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "StartBGScene.h"
#import "ParticleManager.h"

@implementation StartBGScene

+ (id) scene
{
    CCScene * sc = [CCScene node];
    StartBGScene *ss = [StartBGScene node];
    [sc addChild:ss];
    return sc;
}

//+ (id) node
//{
//    return [[[[self class] alloc] init] autorelease];
//}

- (id) init
{
    self = [super init];
    if (self)
    {
        CGSize s = [[CCDirector sharedDirector] winSize];
        // 得到屏幕宽高
        bgSprite = [CCSprite spriteWithFile:@"startbg.png"];
        [bgSprite setPosition:ccp(360.0f, s.height/2.0f)];
        [bgSprite setScaleX:1.5f];
        // 以图片创建背景精灵
        [self addChild:bgSprite];

        [self tick2:nil];
        // 加一个定时器
        [self schedule:@selector(tick:) interval:3.5f];
        // 加第二个定时器
        [self schedule:@selector(tick2:) interval:20.f];

//        StartButtonScene *startButtonScene = [StartButtonScene scene];
//        [self addChild:startButtonScene];
        CCParticleSystem *snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        [self addChild:snow];
        
    }
    return self;
}

- (void) creatOneBird
{   
    CGFloat birdfloat = (arc4random()%3 + 1.0f);
    NSInteger birdint = (int)birdfloat;
    NSString *birdkind = nil;
    switch (birdint) {
        case 1:
            birdkind = [[NSString alloc] initWithFormat:@"bird1.png"];
            break;
        case 2:
            birdkind = [[NSString alloc] initWithFormat:@"bluebird1.png"];
            break;
        case 3:
            birdkind = [[NSString alloc] initWithFormat:@"yellowbird1.png"];
            break;
        default:
            break;
    }
    CCSprite *bird = [[CCSprite alloc] initWithFile:birdkind];
                      //priteWithFile:@"bird1.png"];
    CGPoint startPoint = ccp(0.0f-arc4random()%100, 70.0f);
    [bird setPosition:startPoint];
    [bird setScale:(arc4random()%1+0.5)];
    CGPoint endPoint = ccp(300.0f + arc4random()%100, 70.0f);
    // 设置一个终点
    CGFloat height = arc4random()%320+30.0f;
    CGFloat time = arc4random()%3 + 4.0f;
    CGFloat jumpnum = arc4random()%2 + 2.0f;
    id actionJump = [CCJumpTo actionWithDuration:time position:endPoint height:height jumps:jumpnum];
    // 设置动作，跳跃
    id actionFinish = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    // 完成动作
//    id actionO = CCCallFuncO actionWithTarget:self selector:	 object:<#(id)#>
    CCSequence *BirdActions = [CCSequence actions:actionJump, actionFinish, nil];
    // 动作序列
    
    
    [bird runAction:BirdActions];
    
    // 给bird一个动作
    [self addChild:bird];
    [bird release];
}

- (void) actionFinish:(CCNode *)currentNode
//- (void) ActionFinish:(CCNode *)currentNode
{
//    CCParticleSystem *explosition = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
//    [explosition setPosition:[currentNode position]];
//    [self addChild:explosition];
    // 只要这个方法被调用，就说明动作已经执行完成
    // currentNode其实就是这个bird
    // 从屏幕上删除bird
    [currentNode removeFromParentAndCleanup:YES];
}

- (void) backGroundMove
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    // 得到屏幕宽高
    CGPoint FowardPoint = ccp(120.0f, s.height/2.0f);
    CGPoint BackPoint = ccp(360.0f, s.height/2.0f);
    id BgMoveFoward = [CCMoveTo actionWithDuration:10.0f position:FowardPoint];
    id BgMoveBack = [CCMoveTo actionWithDuration:10.0f position:BackPoint];
    CCSequence *BGAction = [CCSequence actions:BgMoveFoward, BgMoveBack, nil];
    [bgSprite runAction:BGAction];
//    [bgSprite release];
}

- (void) tick:(double)dt
{
    [self creatOneBird];
}

- (void) tick2:(double)dt
{
    [self backGroundMove];
}


@end
