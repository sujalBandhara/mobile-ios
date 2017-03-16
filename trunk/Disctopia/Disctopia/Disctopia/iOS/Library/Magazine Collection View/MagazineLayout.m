//
//   Copyright 2013 Daher Alfawares
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "MagazineLayout.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)
@interface MagazineLayout()

@end
@implementation MagazineLayout

-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibName
{
    self = [super init];
    if (self) {
        [self initializeWithNibName:nibName];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.layoutView = [[[NSBundle mainBundle] loadNibNamed:@"MagazineLayoutNew" owner:self options:nil] objectAtIndex:0];
    [self.layoutView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)initializeWithNibName:(NSString*)nibName
{
    int index = 0;
    if (IS_IPHONE_6P)
    {
        index = 0;
    }
    else
    if (IS_IPHONE_6)
    {
        index = 1;
    }
    else //if (IS_IPHONE_4_OR_LESS)
    {
         index = 2;
    }
    
    self.layoutView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:index];
//    [self.layoutView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.layoutView.superview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.layoutView.superview setNeedsUpdateConstraints];
//    [self.layoutView layoutIfNeeded];
//    [self.layoutView setNeedsLayout];
//    [self.layoutView setNeedsDisplay];
    
}

-(CGSize)collectionViewContentSize
{
    if( self.itemCount == 0 )
        return CGSizeZero;
    
    float w = [self rowWidth];
    float h = [self rowHeight];
    int   x = [self itemCount];
    float c = MagazineLayoutsPerRow;
    
    float width = 100.0;//([UIScreen mainScreen].bounds.size.height / 10.0) + 60.0;
    float height = (h/c)*x + width;//(h/c * ( x + (c/2) - ( x % (int)(c/2) ) ) );
    CGSize contentSize = { w, height };
    return contentSize;
}

-(CGRect)frameForLayoutType:(MagazineLayoutType)type
{
    UIView* cell = [self.layoutView.subviews objectAtIndex:type];
    
    return cell.frame;
}

-(float)rowWidth
{
    return [UIScreen mainScreen].bounds.size.width;//self.layoutView.frame.size.width;
    //return UIScreen.mainScreen().bounds.size.width;
}

-(float)rowHeight
{
    return self.layoutView.frame.size.height ;
}

-(MagazineLayoutType)layoutTypeForIndexPath:(NSIndexPath*)indexPath
{
    return indexPath.row % MagazineLayoutsPerRow;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for( int i=0, size = self.itemCount; i< size; i++ )
    {
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if( CGRectIntersectsRect( attributes.frame, rect) )
            [array addObject:attributes];
    }
    
    return [NSArray arrayWithArray:array];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForLayoutType:[self layoutTypeForIndexPath:indexPath]];
    
    long row = indexPath.row / MagazineLayoutsPerRow;
    frame.origin.y += row * [self rowHeight];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = frame;
    
    return attributes;
}

-(UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}

@end
