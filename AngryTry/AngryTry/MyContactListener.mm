//
//  MyContactListener.m
//  AngryTry
//
//  Created by apple on 13-7-30.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyContactListener.h"

MyContactListener::MyContactListener()
{
    ;
}

MyContactListener::MyContactListener(b2World *w, CCLayer *c)
{
    _world = w;
    _layer = c;
}

MyContactListener::~MyContactListener()
{
    ;
}

void MyContactListener::BeginContact(b2Contact *contact)
{
    ;
}

void MyContactListener::EndContact(b2Contact *contact)
{

}

void MyContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold)
{

}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse)
{
    // solver计算完成后调用的函数
    float force = impulse->normalImpulses[0];
    if (force > 2) {
        SpriteBase *spriteA = (SpriteBase *)contact->GetFixtureA()->GetBody()->GetUserData();
        SpriteBase *spriteB = (SpriteBase *)contact->GetFixtureB()->GetBody()->GetUserData();
        if (spriteA && spriteB) {
            if (spriteA.tag == BIRD_ID) {
                Bird *bird = (Bird*)spriteA;
                [bird hitAnimationX:bird.position.x andY:bird.position.y];
            }
            else
            {
                [spriteA setHP:(spriteA.HP - force)];
            }
            if (spriteB.tag == BIRD_ID) {
                Bird *bird = (Bird *)spriteB;
                [bird hitAnimationX:bird.position.x andY:bird.position.y];
            }
            else
            {
                [spriteB setHP:(spriteB.HP - force)];
            }
        }
    }
}