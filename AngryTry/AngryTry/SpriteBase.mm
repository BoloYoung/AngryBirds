//
//  SpriteBase.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SpriteBase.h"

@implementation SpriteBase
@synthesize HP;

- (id) initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    return nil;
}

- (void) runEnd:(id)sender
{
    // 碎片动作结束时从画面上删除
    CCSprite *temp = (CCSprite *)sender;
    if (temp.tag == BIRD_ID) {
        [self destoryBody:sender];
    }
    [myLayer removeChild:sender cleanup:YES];
}

- (void) destoryBody:(id)sender
{
    CCSprite *temp = (CCSprite*)sender;
    temp.tag = 0;
    
    for (b2Body *b = myWorld->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetUserData()) {
            SpriteBase *spb = (SpriteBase *)b->GetUserData();
            if (spb.tag == 0) {
                myWorld->DestroyBody(b);
            }
        }
    }
    temp = NULL;
}

- (void) destoryPig
{
    // 摧毁猪时添加得分图片
    CCSprite *score = [CCSprite spriteWithFile:@"100001.png"];
    score.scale = 0.2;
    score.position = self.position;
    
    // 得分动作提示
    id actionBig = [CCScaleTo actionWithDuration:0.25f scale:0.45];
    id actionAlpha = [CCFadeOut actionWithDuration:1.0f];
    
    // 插入
    [score runAction:[CCSequence actions:actionBig, actionAlpha, nil]];
    [myLayer addChild:score];
    
    // 调用得分方法
    [myLayer sprite:self withScore:10000];
}

- (void) destory
{
    // 判断使用哪种图片名称
    NSString *name = @"littlewood";
    
    switch (self.tag) {
        case ICE_ID:
            name = @"littleice";
            break;
            
        case BIRD_ID:
            name = @"yumao";
            break;
        
        case PIG_ID:
            [self destoryPig];
            [self removeFromParentAndCleanup:YES];
            return;
            
        default:
            break;
    }
    
    // 制作摧毁时的碎片效果
    for (int i = 0; i < 4; i++) {
        // 产生随机数，使用不同数字图片
        int random = arc4random()%3 + 1;
        // 效果范围
        int range  = 5;
        
        // 创建碎片
        CCSprite *temp = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%d.png",name ,random]];
        temp.scale = arc4random()%5/10.0f;
        temp.position = CGPointMake(self.position.x+arc4random()%5*range - 10, self.position.y+arc4random()%5*range-5);
        
        // 创建淡出，旋转，调用runEnd:方法的动作
        id actionAlpha = [CCFadeOut actionWithDuration:0.8];
        id actionRotate = [CCRotateTo actionWithDuration:0.8 angle:arc4random()%180];
        id actionMoveEnd = [CCCallFuncN actionWithTarget:self selector:@selector(runEnd:)];
        
        // 加入动作
        id mut = [CCSpawn actions:actionAlpha, actionRotate, nil];
        [temp runAction:[CCSequence actions:mut, actionMoveEnd, nil]];
        
        // 加入到layer中
        [myLayer addChild:temp];
    }
    
    
    UIImage *image = [UIImage imageNamed:@"smoke.png"];
    CCTexture2D * somkeTexture = [[CCTexture2D alloc]initWithImage:image];
    NSMutableArray *frams = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        [frams addObject:[[CCSpriteFrame alloc]initWithTexture:somkeTexture rect:CGRectMake(0+i*image.size.width/4, 0, image.size.width/4, image.size.height)]];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:frams delay:0.1f];
    id actionMoveEnd = [CCCallFuncN actionWithTarget:self selector:@selector(runEnd:)];
    CCSequence * m = [CCSequence actions:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] , actionMoveEnd,nil];
    [self runAction:m];

    
    
    
    
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:28];
    if (self.tag == ICE_ID)
    {
        [label setString:@"500"];
        [label setColor:ccc3(30, 30, 200)];
        [myLayer sprite:self withScore:500];
    }

    label.position = self.position;
    id action1 = [CCScaleTo actionWithDuration:0.5f scale:0.4];
    id action2 = [CCScaleBy actionWithDuration:0.5 scale:0];
    [label runAction:[CCSequence actions:action1, action2, nil]];
    [myLayer addChild:label];
//    [label release];
}



@end



