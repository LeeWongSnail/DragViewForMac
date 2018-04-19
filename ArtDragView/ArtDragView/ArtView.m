//
//  ArtView.m
//  ArtDragView
//
//  Created by LeeWong on 2018/4/19.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "ArtView.h"

@interface ArtView()
@property (nonatomic, strong) NSTrackingArea *trackingArea;
@end

@implementation ArtView

- (instancetype)init
{
    if (self = [super init]) {
//        self.window.movableByWindowBackground = YES;
    }
    return self;
}


- (void)viewWillDraw
{
    NSLog(@"---");
}


//鼠标按住左键进行拖拽
- (void)mouseDragged:(NSEvent *)event{
    //如果是拖动
    if (event.type == NSEventTypeLeftMouseDragged || event.type == NSEventTypeRightMouseDragged) {
        //这里需要改变view的frame
        [self setFrameOrigin:event.locationInWindow];
    }
}

//鼠标按住右键进行拖拽
- (void)rightMouseDragged:(NSEvent *)event{
    NSLog(@"%tu",event.type);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSLog(@"frame：%@ , dirtyRect ： %@",NSStringFromRect([self frame]),NSStringFromRect(dirtyRect));
    //frame：{{100, 100}, {300, 300}} , dirtyRect ： {{0, 0}, {300, 300}}
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:dirtyRect
                                                     options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                         NSTrackingCursorUpdate |
                         NSTrackingActiveWhenFirstResponder |
                         NSTrackingActiveInKeyWindow |
                         NSTrackingActiveInActiveApp |
                         NSTrackingActiveAlways |
                         NSTrackingAssumeInside |
                         NSTrackingInVisibleRect |
                         NSTrackingEnabledDuringMouseDrag
                                                       owner:self
                                                    userInfo:nil];
    
    [self addTrackingArea:self.trackingArea];
    [self becomeFirstResponder];
}

#pragma mark -监听鼠标的其他方法
//
////鼠标进入追踪区域
//- (void)mouseEntered:(NSEvent *)event{
//    //    NSLog(@"mouseEntered ========== ");
//}
//
////mouseEntered 之后调用
//- (void)cursorUpdate:(NSEvent *)event{
//
//    NSLog(@"cursorUpdate ========== ");
//    //更改鼠标光标样式
//    [[NSCursor resizeUpCursor] set];
//
//}
//
////鼠标退出追踪区域
//- (void)mouseExited:(NSEvent *)event{}
//
//
////鼠标左键按下
//- (void)mouseDown:(NSEvent *)event{
//
//    //event.clickCount 不是累计数。双击时调用mouseDown 两次，clickCount 第一次=1，第二次 = 2。
//    if ([event clickCount] > 1) {
//        //双击相关处理
//    }
//
//    NSLog(@"mouseDown ========== clickCount：%ld buttonNumber：%ld",event.clickCount,event.buttonNumber);
//
//    self.layer.backgroundColor = [NSColor redColor].CGColor;
//
//    //获取鼠标点击位置坐标：先获取event发生的window中的坐标，在转换成view视图坐标系的坐标。
//    NSPoint eventLocation = [event locationInWindow];
//    NSPoint center = [self convertPoint:eventLocation fromView:nil];
//
//    //与上面等价
//    NSPoint clickLocation = [self convertPoint:[event locationInWindow]
//                                      fromView:nil];
//
//    NSLog(@"center：%@ , clickLocation：%@",NSStringFromPoint(center),NSStringFromPoint(clickLocation));
//
//    //判断是否按下了Command键
//    if ([event modifierFlags] & NSCommandKeyMask) {
//        [self setFrameRotation:[self frameRotation]+90.0];
//        [self setNeedsDisplay:YES];
//
//        NSLog(@"按下了Command键 ------ ");
//    }
//}
//
////鼠标左键起来
//- (void)mouseUp:(NSEvent *)event{
//    NSLog(@"mouseUp ========== ");
//
//    self.layer.backgroundColor = [NSColor greenColor].CGColor;
//
//}
//
////鼠标右键按下
//- (void)rightMouseDown:(NSEvent *)event{
//    NSLog(@"rightMouseDown ========== ");
//}
//
////鼠标右键起来
//- (void)rightMouseUp:(NSEvent *)event{
//    NSLog(@"rightMouseUp ========== ");
//}
//
////鼠标移动
//- (void)mouseMoved:(NSEvent *)event{
//    //    NSLog(@"mouseMoved ========== ");
//}

@end
