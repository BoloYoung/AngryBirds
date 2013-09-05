//
//  SlingShot.m
//  MyBox2dTest
//
//  Created by apple on 13-7-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SlingShot.h"

@implementation SlingShot
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;


// draw函数 是ccnode里面的虚函数
- (void) draw
{
    // 画线
    glLineWidth(4.0f);
    glColor4f(0.2f, 0.1f, 0.0f, 1.0f);  // 设置为红色
//    glColor4
    glDisable(GL_TEXTURE_2D);
    glEnable(GL_LINE_SMOOTH);  // 反锯齿
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);   // 状态机关闭
    glDisableClientState(GL_COLOR_ARRAY);
    
    GLfloat ver[4] = {_startPoint.x, _startPoint.y, _endPoint.x, _endPoint.y};
    glVertexPointer(2, GL_FLOAT, 0, ver);
    glDrawArrays(GL_LINES, 0, 2);
    
//    GLfloat ver2[4] = {_startPoint2.x, _startPoint2.y, _endPoint.x, _endPoint.y};
//    glVertexPointer(2, GL_FLOAT, 0, ver2);
//    glDrawArrays(GL_LINES, 0, 2);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);    // 状态机开启
    glEnable(GL_TEXTURE_2D);
    
    glDisable(GL_LINE_SMOOTH);
}

@end
