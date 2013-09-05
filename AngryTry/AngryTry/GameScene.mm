//
//  GameScene.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "GameScene.h"
#import <math.h>

#define SLINGSHOT_POS CGPointMake(85, 125)

@implementation GameScene

+ (id) sceneWithLevel:(int)level
{
    CCScene *sc = [CCScene node];
    GameScene *Gsc = [GameScene nodeWithLevel:level];
    [sc addChild:Gsc];
    return sc;
}

+ (id) nodeWithLevel:(int)level
{
    return [[[[self class] alloc] initWithLevel:level] autorelease];
}

- (id) initWithLevel:(int)level
{
    self = [super init];
    if (self) {
        GameScore = 0;
        currentLevel = level;
        // 创建精灵
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite];
        // 背景
        
        NSString *scoreStr = [NSString stringWithFormat:@"Score:"];
        NSString *scoreNum = [NSString stringWithFormat:@"%d",GameScore];
//        scorelabel = [[CCLabelTTF alloc] initWithString:scoreStr fontName:@"Arial" fontSize:25.0f dimensions:CGSizeMake(300, 300) hAlignment:kCTTextAlignmentCenter];
        scoreStrlabel = [[CCLabelTTF alloc] initWithString:scoreStr dimensions:CGSizeMake(100, 50) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:25.0f];
        scoreNumlabel = [[CCLabelBMFont alloc] initWithString:scoreNum fntFile:@"bitmapFontTest3.fnt"];
        
        [scoreStrlabel setColor:ccc3(255, 240, 0)];
        
        scoreStrlabel.position = ccp(310, 282);
        scoreNumlabel.position = ccp(355, 275);
        scoreNumlabel.anchorPoint = ccp(0, 0);
    
        [self addChild:scoreStrlabel];
        [self addChild:scoreNumlabel];
        // 分数
        
        CCSprite *leftShot = [CCSprite spriteWithFile:@"leftshot.png"];
        leftShot.position = ccp(85, 110);
        CCSprite *rightShot = [CCSprite spriteWithFile:@"rightshot.png"];
        rightShot.position = ccp(85, 110);
        [self addChild:leftShot z:5];
        [self addChild:rightShot z:1];
        // 弹弓左右臂
        
        slingShot1 = [[SlingShot alloc] init];
        slingShot2 = [[SlingShot alloc] init];
        slingShot1.startPoint = ccp(81, 128);
        slingShot2.startPoint = ccp(90, 127);
        slingShot1.endPoint = ccp(85, 123);
        slingShot2.endPoint = ccp(85, 123);
        slingShot1.contentSize = CGSizeMake(480, 320);
        slingShot2.contentSize = CGSizeMake(480, 320);
        slingShot1.position = ccp(240, 160);
        slingShot2.position = ccp(240, 160);
        [self addChild:slingShot1 z:4];
        [self addChild:slingShot2 z:2];
        
        // 打开触摸方法
        self.isTouchEnabled = YES;
        // 注册cocos2d特有的方法
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
        [self createWorld];
        [self createLevel];
    }
    return self;
}

- (void) createWorld
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    b2Vec2 gravity;
    gravity.Set(0.0f, -5.0f);
    // -5.0f y向下的重力
    world = new b2World(gravity, true);
    // 以gravity创建一个世界 true 表示如果世界中没有运动停止计算
    
    contactListrner = new MyContactListener(world, self);
    world->SetContactListener(contactListrner);
    // 给world设置监听对象
    
    // 创建地板
    b2BodyDef groundDef;
    groundDef.position.Set(0, 0);
    
    b2Body *groundBody = world->CreateBody(&groundDef);
    // 创建一个地板刚体
    // b2Fixture
    b2PolygonShape groundShape;
    // PTM_RATIO = 32. 每32点表示一米
    groundShape.SetAsEdge(b2Vec2(0, 87.0f/PTM_RATIO),
                          b2Vec2(screenSize.width/PTM_RATIO, 87.0f/PTM_RATIO));
    b2FixtureDef groundFixDef;
    groundFixDef.friction = 0.35f;
    groundFixDef.shape = &groundShape;
    groundBody->CreateFixture(&groundFixDef);
    
    
    // 启动定时器
    [self schedule:@selector(tick:)];
}

- (void) tick:(ccTime)dt
{
    // 让世界往前模拟
    world->Step(dt, 8, 6);
    // 更新cocos2d的界面
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            // userdata表示每个刚体可以存放一些私有数据 ccsprite self
            SpriteBase *spriteBase = (SpriteBase *)b->GetUserData();
            // 一个b2Body 对应一个sprite
            spriteBase.position = ccp(b->GetPosition().x*PTM_RATIO,
                                      b->GetPosition().y*PTM_RATIO);
            spriteBase.rotation = -1*CC_RADIANS_TO_DEGREES(b->GetAngle());
            // 把box2d里面的角度转换成cocos2d中的角度
        
            if (spriteBase.tag == BIRD_ID) {
                if (!b->IsAwake()) {
                    world->DestroyBody(b);
                    [spriteBase destory];
                    BirdsCount--;
                }
            }
            if (spriteBase.HP <= 0 || spriteBase.position.x > 480 || spriteBase.position.y < 84)
            {
                world->DestroyBody(b);
                if (spriteBase.tag == PIG_ID) {
                    PigsCount--;
                }
                [spriteBase destory];
            }
        }
    }
//    if ( BirdsCount <= 0 ) {
//        <#statements#>
//    }
}

- (void) createLevel
{
    PigsCount = 0;
    BirdsCount = 0;
    NSString *s = [NSString stringWithFormat:@"%d", currentLevel];
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:@"data"];
    NSArray *spriteArray = [JsonParser getAllSprite:path];
    for (SpriteModel *sm in spriteArray) {
        switch (sm.tag) {
            case PIG_ID:
            {
                PigsCount++;
                CCSprite *pig = [[Pig alloc] initWithX:sm.x andY:sm.y andWorld:world andLayer:self];
                [self addChild:pig];
                [pig release];
                break;
            }
            case ICE_ID:
            {
                CCSprite *ice = [[Ice alloc] initWithX:sm.x andY:sm.y andWorld:world andLayer:self];
                [self addChild:ice];
                [ice release];
                break;
            }
            default:
                break;
        }
    }
    birds = [[NSMutableArray alloc] init];
    Bird *bird = [[Bird alloc] initWithX:160 andY:93 andWorld:world andLayer:self];
    Bird *bird2 = [[Bird alloc] initWithX:140 andY:93 andWorld:world andLayer:self];
    Bird *bird3 = [[Bird alloc] initWithX:120 andY:93 andWorld:world andLayer:self];
    
    [self addChild:bird z:3];
    [self addChild:bird2 z:3];
    [self addChild:bird3 z:3];
    [birds addObject:bird];
    [birds addObject:bird2];
    [birds addObject:bird3];
    
    BirdsCount = [birds count];
    
    [bird release];
    [bird2 release];
    [bird3 release];
    
    [self BirdJump];
}

- (void) sprite:(SpriteBase *)sprite withScore:(int)score
{
//    int temp = GameScore;
    GameScore += score;
    [scoreNumlabel setString:[NSString stringWithFormat:@"%d", GameScore]];
    id ActionBig = [CCScaleTo actionWithDuration:0.1 scale:1.2];
    id ActionSmall = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    id act = [CCSequence actions:ActionBig, ActionSmall, nil];
    [scoreNumlabel runAction:act];
//    [ActionBig release];
//    [ActionSmall release];
//    [act release];
}

- (void) BirdJump
{
    if (birds.count > 0 && !gameFinish) {
        currentBird = [birds objectAtIndex:0];
        CCJumpTo *action = [[CCJumpTo alloc] initWithDuration:1 position:ccp(85, 127) height:50 jumps:1];
        CCCallBlockN *jumpFinish = [[CCCallBlockN alloc] initWithBlock:^(CCNode *node)
                                    {
                                        gameStart = YES;
                                        currentBird.isReady = YES;
                                    }];
        CCSequence *allActions = [CCSequence actions:action, jumpFinish, nil];
        [action release];
        [jumpFinish release];
        [currentBird runAction:allActions];
    }
}


#define TOUCH_UNKNOW 0
#define TOUCH_SHDTBIRD 1
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // 判断触摸点是否落在currentbird
    touchStatus = TOUCH_UNKNOW;
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (currentBird == nil)
    {
        return NO;
    }
    CGRect birdRect = currentBird.boundingBox;
    // 获得小鸟的区域
    if (CGRectContainsPoint(birdRect, location))
    {
        // 触摸点落在bird区域
        touchStatus = TOUCH_SHDTBIRD;
        return YES;
    }
    return NO;
}

// 触摸过程中
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (touchStatus == TOUCH_SHDTBIRD) {
        // 说明小鸟在选中，可拉动弹弓
        CGPoint location = [self convertTouchToNodeSpace:touch];
        // 取得当前手指的位置
        CGFloat ShotAngle = atan2(location.y - 127, location.x - 85);
        if (sqrt(pow((location.y-125), 2)+pow((location.x-85), 2)) < 40) {
            CGPoint newPoint;
//            CGFloat ration = [self getRatioFromPoint:slingShot1.startPoint toPoint:location];
            newPoint.x = location.x + 4 * cos(ShotAngle);
            newPoint.y = location.y + 4 * sin(ShotAngle);
            slingShot1.endPoint = newPoint;
            slingShot2.endPoint = newPoint;
            currentBird.position = location;
            // 把小鸟和弹弓位置设为location
        }
        else 
        {
            CGPoint birdPosition = ccp(40.0*cos(ShotAngle) + 85, 40.0*sin(ShotAngle) + 127);
            CGPoint newPoint;
//            CGFloat ration = [self getRatioFromPoint:slingShot1.startPoint toPoint:location];
            newPoint.x = birdPosition.x + 4 * cos(ShotAngle);
            newPoint.y = birdPosition.y + 4 * sin(ShotAngle);
            slingShot1.endPoint = newPoint;
            slingShot2.endPoint = newPoint;
            currentBird.position = birdPosition;
        }
    }
}

// from p1->p2
- (CGFloat) getRatioFromPoint:(CGPoint)p1 toPoint:(CGPoint) p2
{
    return (p2.y-p1.y)/(p2.x-p1.x);
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // 手放开时 1.让小鸟飞出去 2.让弹弓复位
    if (touchStatus == TOUCH_SHDTBIRD)
    {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        slingShot1.endPoint = SLINGSHOT_POS;
        slingShot2.endPoint = SLINGSHOT_POS;
        
        // 从location －－－> SLINGSHOT_POS
//        CGFloat r = [self getRatioFromPoint:location toPoint:SLINGSHOT_POS];
//        CGFloat endx = 300;
//        CGFloat endy = endx*r + location.y;
//        CGPoint destPoint = ccp(endx, endy);
//        CCMoveTo *moveAction = [[CCMoveTo alloc] initWithDuration:1.0 position:destPoint];
//        [currentBird runAction:moveAction];
//        [moveAction release];

//        float x = (85.0f-currentBird.position.x)*50.0f/70.0f;
//        float y = (125.0f-currentBird.position.y)*50.0f/70.0f;
//        
//        [currentBird setSpeedX:x andY:y andWorld:world];
        
        float x =(85.0f-currentBird.position.x)*50.0f/70.0f;
        float y =(125.0f-currentBird.position.y)*50.0f/70.0f;
//        NSLog(@"准备起飞。。");
        
        [currentBird setSpeedX:x andY:y andWorld:world];
        
        [birds removeObject:currentBird];
        currentBird = nil;
        [self performSelector:@selector(BirdJump) withObject:nil afterDelay:3.0f];
        // 3s后下一只小鸟上弹弓
        
    }
}

- (void) dealloc
{
    [birds release];
    [scoreStrlabel release];
    [scoreNumlabel release];
    [super dealloc];
}

@end

