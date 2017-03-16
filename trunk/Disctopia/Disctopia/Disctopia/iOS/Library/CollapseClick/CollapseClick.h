//
//  CollapseClick.h
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClickCell.h"

#define kCCPad 0

  //////////////
 // Delegate //
//////////////
@protocol CollapseClickDelegate
@required
-(NSInteger)numberOfCellsForCollapseClick;
-(NSString *)titleForCollapseClickAtIndex:(NSInteger)index;
-(UIView *)viewForCollapseClickContentViewAtIndex:(NSInteger)index;

@optional
-(UIColor *)colorForCollapseClickTitleViewAtIndex:(NSInteger)index;
-(UIColor *)colorForTitleLabelAtIndex:(NSInteger)index;
-(UIColor *)colorForTitleArrowAtIndex:(NSInteger)index;
-(void)didClickCollapseClickCellAtIndex:(NSInteger)index isNowOpen:(BOOL)open;

@end




  ///////////////
 // Interface //
///////////////
@interface CollapseClick : UIScrollView <UIScrollViewDelegate>  {
    __weak id <CollapseClickDelegate> CollapseClickDelegate;
}

// Delegate
@property (weak) id <CollapseClickDelegate> CollapseClickDelegate;

// Properties
@property (nonatomic, retain) NSMutableArray *isClickedArray;
@property (nonatomic, retain) NSMutableArray *dataArray;

// Methods
-(void)reloadCollapseClick;
-(CollapseClickCell *)collapseClickCellForIndex:(NSInteger)index;
-(void)scrollToCollapseClickCellAtIndex:(NSInteger)index animated:(BOOL)animated;
-(UIView *)contentViewForCellAtIndex:(NSInteger)index;
-(void)openCollapseClickCellAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)closeCollapseClickCellAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)openCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated;
-(void)closeCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated;

@end
