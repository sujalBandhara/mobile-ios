//
//  CollapseClickIcon.m
//  CollapseClick
//
//  Created by Ben Gordon on 3/17/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickArrow.h"

@implementation CollapseClickArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor colorWithRed:139 green:131 blue:134 alpha:1];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = [UIColor colorWithRed:139 green:131 blue:134 alpha:1];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [arrow moveToPoint:CGPointMake(self.frame.size.width, 0)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height/2)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    //[arrow addLineToPoint:CGPointMake(0, 0)];
    //[arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    //[arrow fill];
    
    //[ [UIColor colorWithRed:139/255 green:131/255 blue:134/255 alpha:1] setStroke];
    //[[UIColor lightGrayColor] setStroke];
    [[UIColor colorWithRed:139.0/255.0 green:131.0/255.0 blue:134.0/255.0 alpha:1] setStroke];
    [self.arrowColor setFill];

    [arrow stroke];
}


@end
