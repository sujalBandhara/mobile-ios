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

#import <UIKit/UIKit.h>


// Out newspaper layout types:
//   +---++-----+-----+
//   |   ||     B     |
//   | A |+-----+-----+
//   |   ||  C  |  D  |
//   +---++-----+-----+
//   +-----+-----++---+
//   |     B     ||   |
//   +-----+-----+| A |
//   |  C  |  D  ||   |
//   +-----+-----++---+
//   +---++-----+-----+
//   |   ||     B     |
//   | A |+-----+-----+
//   |   ||  c  |  d  |
//   +---++-----+-----+
typedef enum MagazineLayoutType_e
{
    MagazineLayoutTypeA,
    MagazineLayoutTypeB,
    MagazineLayoutTypeC,
    MagazineLayoutTypeD,
    MagazineLayoutTypeE,
    MagazineLayoutTypeF,
    MagazineLayoutTypeG,
    MagazineLayoutTypeH,
} MagazineLayoutType;

static const int MagazineLayoutsPerRow = 10L;

@interface MagazineLayout : UICollectionViewLayout

//! this is the number of items in the collection view.
@property int    itemCount;
@property UIView* layoutView;
-(id)initWithNibName:(NSString *)nibName;
@end
