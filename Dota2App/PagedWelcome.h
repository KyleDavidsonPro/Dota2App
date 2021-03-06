//
//  PagedWelcome
//  pagingComponent
//
//  Created by Luke  on 13/01/2013.
//  Copyright (c) 2013 Luke . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
#import "PagingDelegate.h"

@interface PagedWelcome : UIViewController <UIScrollViewDelegate,PagingDelegate>
@property (nonatomic,retain) StyledPageControl * pageControl;
@property (nonatomic,retain) UIScrollView * scrollView;
@property (nonatomic,retain) NSArray * views;
@property (nonatomic,retain) NSTimer * pageTimer;
@property BOOL pageControlUsed;
- (void)stopAutoPaging;
- (void)startAutoPaging;
- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation;
- (void)resizeViewsForOrientation:(UIInterfaceOrientation)orientation addingViews:(BOOL)addViews;
- (void)configureView;
@end
