//
//  PanView.m
//  ArtDragView
//
//  Created by LeeWong on 2018/4/19.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "ArtDragView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ArtDragView ()
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,strong) NSPanGestureRecognizer *panGestureRecognizer;
@end

@implementation ArtDragView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        self.panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        self.panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        NSClickGestureRecognizer *singleClick = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clickDragView)];
        singleClick.numberOfClicksRequired = 1;
        [self addGestureRecognizer:singleClick];
        
        self.dragEnable = YES;
        self.isKeepBounds = YES;
        self.topBottomSpacing = 50;
    }
    return self;
}

- (void)viewDidMoveToSuperview
{
    if (self.freeRect.origin.x!=0||self.freeRect.origin.y!=0||self.freeRect.size.height!=0||self.freeRect.size.width!=0) {
        //设置了freeRect--活动范围
    }else{
        //没有设置freeRect--活动范围，则设置默认的活动范围为父视图的frame
        self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};
//        self.freeRect = self.superview.frame;
    }
}


- (void)viewDidEndLiveResize
{
    self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};

}

- (void)panGesture:(NSGestureRecognizer *)pan
{
    if (self.dragEnable==NO) {
        return;
    }
    switch (pan.state) {
        case NSGestureRecognizerStateBegan:{///开始拖动
            if (self.beginDragBlock) {
                self.beginDragBlock(self);
            }
            //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            [self.panGestureRecognizer setTranslation:CGPointZero inView:self];
            //保存触摸起始点位置
            self.startPoint = [pan locationInView:self];
            //该view置于最前
            
//            [self.superview bringSubviewToFront:self];
            break;
        }
        case NSGestureRecognizerStateChanged:{///拖动中
            //计算位移 = 当前位置 - 起始位置
            if (self.endDragBlock) {
                self.duringDragBlock(self);
            }
            CGPoint point = [pan locationInView:self];
            float dx;
            float dy;
            switch (self.dragDirection) {
                case EArtDragDirectionAny:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case EArtDragDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                    dy = 0;
                    break;
                case EArtDragDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }

            //计算移动后的view
            //移动view
            NSPoint origin = self.frame.origin;
            NSPoint newOrigin = CGPointMake(origin.x + dx, origin.y + dy);
            [self setFrameOrigin:newOrigin];
            //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            [self.panGestureRecognizer setTranslation:CGPointZero inView:self];
            break;
        }
        case NSGestureRecognizerStateEnded:{///拖动结束
            [self keepBounds];
            if (self.endDragBlock) {
                self.endDragBlock(self);
            }
            break;
        }
        default:
            break;
    }
}


///点击事件
-(void)clickDragView{
    if (self.clickDragViewBlock) {
        self.clickDragViewBlock(self);
    }
}
- (void)keepBounds{
    //中心点判断
    float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;
    __block CGRect rect = self.frame;
        if (self.isKeepBounds==NO) {//没有黏贴边界的效果
            if (self.frame.origin.x < self.freeRect.origin.x) {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    rect.origin.x = self.freeRect.origin.x;
                } completionHandler:^{
                    self.frame = rect;
                }];
            } else if(self.freeRect.origin.x+self.freeRect.size.width < self.frame.origin.x+self.frame.size.width){
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    rect.origin.x = self.freeRect.origin.x+self.freeRect.size.width-self.frame.size.width;
                } completionHandler:^{
                    self.frame = rect;
                }];
            }
    
            if (self.frame.origin.y < self.freeRect.origin.y) {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    rect.origin.y = self.freeRect.origin.y;
                } completionHandler:^{
                    self.frame = rect;
                }];
            } else if(self.freeRect.origin.y+self.freeRect.size.height< self.frame.origin.y+self.frame.size.height){
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    rect.origin.y = self.freeRect.origin.y+self.freeRect.size.height-self.frame.size.height;
                } completionHandler:^{
                    self.frame = rect;
                }];
            }
            return;
        }
        //自动粘边
        __block BOOL issx = NO;
        CGFloat xfbj = self.topBottomSpacing;
        if (self.frame.origin.y - self.freeRect.origin.y < xfbj) {
            //贴底部
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                context.duration = 0.5;
                rect.origin.y = 0;
            } completionHandler:^{
                self.frame = rect;
                issx = YES;
                [self setHorizantol:issx centerX:centerX rect:self.frame];
            }];
        }else if(CGRectGetMaxY(self.freeRect) -CGRectGetMaxY(self.frame) < xfbj){
            //贴顶部
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                context.duration = 0.5;
                rect.origin.y = self.freeRect.size.height-self.frame.size.height;
            } completionHandler:^{
                self.frame = rect;
                issx = YES;
                [self setHorizantol:issx centerX:centerX rect:self.frame];
            }];
        } else {
            [self setHorizantol:issx centerX:centerX rect:self.frame];
        }
    
}


- (void)setHorizantol:(BOOL)issx centerX:(CGFloat)centerX rect:(NSRect)rect
{
    CGFloat xfbj = self.topBottomSpacing;
    __block NSRect frame = rect;
    if ((!issx && self.frame.origin.x< centerX) || (issx && self.frame.origin.x < xfbj)) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            //贴左边
            context.duration = 0.5;
            frame.origin.x = self.freeRect.origin.x;
        } completionHandler:^{
            self.frame = frame;
        }];
    } else if((!issx && self.frame.origin.x >= centerX) || (issx && CGRectGetMaxX(self.freeRect) -CGRectGetMaxX(self.frame) < xfbj)) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            //贴右边
            context.duration = 0.5;
            frame.origin.x =CGRectGetMaxX(self.freeRect)-self.frame.size.width;
        } completionHandler:^{
            self.frame = frame;
        }];
    }
}
- (void)doAnimation
{
    NSViewAnimation *theAnim;
    NSMutableDictionary *viewDict;
    
    // Create the attributes dictionary for the view.
    viewDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // Set the target object to be the view.
    [viewDict setObject:self forKey:NSViewAnimationTargetKey];
    
    // Set this view to fade out
    [viewDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
    
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:@[viewDict]];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.5];
    
    // Run the animation.
    [theAnim startAnimation];
}

@end
