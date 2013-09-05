//
//  ParticleManager.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ParticleManager.h"

static ParticleManager *s;

@implementation ParticleManager

+ (id) sharedParticleManager
{
    if (s == nil)
    {
        s = [[ParticleManager alloc] init];
    }
    return s;
}

- (CCParticleSystem *) particleWithType:(ParticleTypes)type
{
    CCParticleSystem *system = nil;
    switch (type) {
        case ParticleTypeSnow:
            {
                system = [CCParticleSun node];
                // 取得雪花效果
                
                CCTexture2D *t = [[CCTextureCache sharedTextureCache] addImage:@"ice1.png"];
                [system setTexture:t];
                // 把图片转化为纹理
                [system setPosition:ccp([[CCDirector sharedDirector] winSize].width/2, [[CCDirector sharedDirector] winSize].height/2 - 30.0f)];
            }
            break;
        case ParticleTypeBirdExplosion:
            {
                system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bird-explosion.plist"];
//                system = [CCParticleExplosion node];
                CCTexture2D *t = [[CCTextureCache sharedTextureCache] addImage:@"bird1.png"];
                [system setTexture:t];
                // 使用bird-explosion.plist作为粒子效果的文件
                [system setPositionType:kCCPositionTypeFree];
//                [system setPositionType:kCCPositionTypeGrouped];
                // 设置粒子效果独立
                [system setAutoRemoveOnFinish:YES];
                // 设置粒子效果完成后自动删除
            }
            break;
            //        default:
//            
//            break;
        default:
            break ;
    }
    return system;
}
@end
