//
//  BottomTBvc.h
//  测试推拉View
//
//  Created by andy  on 15/6/17.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomTBvc;
@protocol BottomTBvcDelegate <NSObject>

@optional
-(void)bottomTBvc:(BottomTBvc *)bottomVc DidScroolTo:(CGFloat)contentY;
@end
@interface BottomTBvc : UIViewController
@property(weak,nonatomic)id<BottomTBvcDelegate>delegate;
@end
