//
//  IQDropDownTextField.m
// https://github.com/hackiftekhar/IQDropDownTextField
// Copyright (c) 2013-15 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "IQDropDownTextField.h"

#ifndef NSFoundationVersionNumber_iOS_5_1
    #define NSTextAlignmentCenter UITextAlignmentCenter
#endif


@interface IQDropDownTextField () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_ItemListsInternal;
}

@property (nonatomic, strong) UIPickerView *pickerViewTextPicker,*pickerViewMonthYear;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) NSDateFormatter *dropDownDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dropDownTimeFormatter;
@property (nonatomic, strong) NSMutableArray * monthsArray,*yearsArray;

- (void)dateChanged:(UIDatePicker *)dPicker;
- (void)timeChanged:(UIDatePicker *)tPicker;

@end

@implementation IQDropDownTextField

@synthesize dropDownMode = _dropDownMode;
@synthesize itemList = _itemList;
@synthesize selectedItem = _selectedItem;
@synthesize isOptionalDropDown = _isOptionalDropDown;
@synthesize datePickerMode = _datePickerMode;
@synthesize minimumDate = _minimumDate;
@synthesize maximumDate = _maximumDate;
@synthesize delegate;

@synthesize pickerViewTextPicker,datePicker, timePicker, dropDownDateFormatter,dropDownTimeFormatter;
@synthesize dateFormatter, timeFormatter;

#pragma mark - Initialization

- (void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    if ([[[self class] appearance] dateFormatter])
    {
        self.dropDownDateFormatter = [[NSDateFormatter alloc] init];
        self.dropDownDateFormatter = [[[self class] appearance] dateFormatter];
    }
    else
    {
        self.dropDownDateFormatter = [[NSDateFormatter alloc] init];
        //        [self.dropDownDateFormatter setDateFormat:@"dd MMM yyyy"];
        [self.dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    self.dropDownTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dropDownTimeFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.dropDownTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.pickerViewTextPicker = [[UIPickerView alloc] init];
    [self.pickerViewTextPicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.pickerViewTextPicker setShowsSelectionIndicator:YES];
    [self.pickerViewTextPicker setDelegate:self];
    [self.pickerViewTextPicker setDataSource:self];
    
    
    self.monthsArray=[[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    self.yearsArray=[[NSMutableArray alloc]init];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    [components month]; //gives you month
    [components day]; //gives you day
    [components year]; // gives you year
    
    for (NSInteger y = [components year] -0; y <= [components year] +30; y++)
    {
        [self.yearsArray addObject:[NSString stringWithFormat:@"%ld",(long)y]];
    }
    
    self.pickerViewMonthYear = [[UIPickerView alloc] init];
    [self.pickerViewMonthYear setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.pickerViewMonthYear setShowsSelectionIndicator:YES];
    [self.pickerViewMonthYear setDelegate:self];
    [self.pickerViewMonthYear setDataSource:self];
    
    self.datePicker = [[UIDatePicker alloc] init];
//    [self.datePicker setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];

    [self.datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.timePicker = [[UIDatePicker alloc] init];
//    [self.timePicker setBackgroundColor:[UIColor whiteColor]];
    [self.timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.timePicker setDatePickerMode:UIDatePickerModeTime];
    [self.timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    
    
}
-(void)setDropDownTypePicker:(NSInteger)DropDownType
{
    if (DropDownType == 0)
    {
        [self setDropDownMode:IQDropDownModeTextPicker];
        [self setIsOptionalDropDown:YES];

        if ([self.text length] > 0)
        {
            [self setSelectedItem:self.text selectedItem2:nil animated:NO];
        }

    }
    else if (DropDownType == 1)
    {
        [self setDropDownMode:IQDropDownModeTimePicker];
    }
    else if (DropDownType == 2)
    {
        //2
        [self setDropDownMode:IQDropDownModeDatePicker];
    }
    else
    {
        [self setDropDownMode:IQDropDownModeMonthYearPicker];

        if ([self.text length] > 0)
        {
            NSArray *arrBirthdate = [self.text componentsSeparatedByString:@","];
            
            if([arrBirthdate count] ==2)
            {
                [self setSelectedItem:arrBirthdate[0] selectedItem2:[arrBirthdate[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] animated:NO];
            }
        }

    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark - UITextField overrides

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.pickerViewMonthYear) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerViewMonthYear) {
        if (component == 0) {
            return self.monthsArray.count;
        }
        else if (component == 1)
        {
            return self.yearsArray.count;
        }
    }
    return _ItemListsInternal.count;
}

#pragma mark UIPickerView delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setAdjustsFontSizeToFitWidth:YES];
    
    if (pickerView == self.pickerViewMonthYear)
    {
        labelText.text = component==0?[self.monthsArray objectAtIndex:row]:[self.yearsArray objectAtIndex:row];
    }
    else
    {
        [labelText setText:[_ItemListsInternal objectAtIndex:row]];

    }
    labelText.backgroundColor = [UIColor clearColor];
    
    if (self.isOptionalDropDown && row == 0)
    {
        labelText.font = [UIFont boldSystemFontOfSize:30.0];
        labelText.textColor = [UIColor lightGrayColor];
    }
    else
    {
        labelText.font = [UIFont boldSystemFontOfSize:18.0];
        labelText.textColor = [UIColor blackColor];
    }
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            [self setSelectedItem:[_ItemListsInternal objectAtIndex:row] selectedItem2:nil animated:NO];
            break;
        case IQDropDownModeDatePicker:
            [self setSelectedItem:[_ItemListsInternal objectAtIndex:row] selectedItem2:nil animated:NO];
            break;
        case IQDropDownModeTimePicker:
            [self setSelectedItem:[_ItemListsInternal objectAtIndex:row] selectedItem2:nil animated:NO];
            break;
        case IQDropDownModeMonthYearPicker:
        {
            if (component == 0)
            {
                if (_selectedItem2 == nil)
                {
                    [self setSelectedItem:[self.monthsArray objectAtIndex:row] selectedItem2:[self.yearsArray objectAtIndex:0] animated:NO];
                }
                else
                {
                    [self setSelectedItem:[self.monthsArray objectAtIndex:row] selectedItem2:_selectedItem2 animated:NO];
                }
            }
            else
            {
                if (_selectedItem == nil)
                {
                    [self setSelectedItem:[self.monthsArray objectAtIndex:0] selectedItem2:[self.yearsArray objectAtIndex:row] animated:NO];
                }
                else
                {
                    [self setSelectedItem:_selectedItem selectedItem2:[self.yearsArray objectAtIndex:row] animated:NO];
                }

            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - UIDatePicker delegate

- (void)dateChanged:(UIDatePicker *)dPicker
{
    [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:dPicker.date]];
}

- (void)timeChanged:(UIDatePicker *)tPicker
{
    [self setSelectedItem:[self.dropDownTimeFormatter stringFromDate:tPicker.date]];
}

#pragma mark - Selected Row

- (NSInteger)selectedRow
{
    if (self.isOptionalDropDown)
    {
        return [self.pickerViewTextPicker selectedRowInComponent:0]-1;
    }
    else
    {
        return [self.pickerViewTextPicker selectedRowInComponent:0];
    }
}

-(void)setSelectedRow:(NSInteger)selectedRow
{
    [self setSelectedRow:selectedRow animated:NO];
}

- (void)setSelectedRow:(NSInteger)row animated:(BOOL)animated
{
    if (row < [_ItemListsInternal count])
    {
        if (self.isOptionalDropDown && row == 0)
        {
            self.text = @"";
        }
        else
        {
            self.text = [_ItemListsInternal objectAtIndex:row];
        }
        
        [self.pickerViewTextPicker selectRow:row inComponent:0 animated:animated];
    }
}
- (void)setSelectedRowForComponent1:(NSInteger)row1 ForComponent2:(NSInteger)row2 animated:(BOOL)animated
{
    if (row1 < [self.monthsArray count])
    {
        if (self.isOptionalDropDown && row1 == 0)
        {
            self.text = @"";
        }
        else
        {
           // self.text = [self.monthsArray objectAtIndex:row1];
        }
        
        [self.pickerViewMonthYear selectRow:row1 inComponent:0 animated:animated];
    }
    if (row2 < [self.yearsArray count])
    {
        if (self.isOptionalDropDown && row2 == 0)
        {
            self.text = @"";
        }
        else
        {
           // self.text = [self.yearsArray objectAtIndex:row2];
        }
        
        [self.pickerViewMonthYear selectRow:row2 inComponent:1 animated:animated];
    }

}

#pragma mark - Setters

- (void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            self.inputView = self.pickerViewTextPicker;
            break;
        case IQDropDownModeDatePicker:
            self.inputView = self.datePicker;
            break;
        case IQDropDownModeTimePicker:
            self.inputView = self.timePicker;
            break;
        case IQDropDownModeMonthYearPicker:
            self.inputView = self.pickerViewMonthYear;
            break;

        default:
            break;
    }
}

- (void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    
    //Refreshing pickerView
    [self setIsOptionalDropDown:_isOptionalDropDown];
    
    if ([self.text length] == 0)
    {
        [self setSelectedRow:0 animated:NO];
    }
}

-(NSDate *)date
{
    switch (self.dropDownMode)
    {
        case IQDropDownModeDatePicker:  return  [self.text length]  ?   self.datePicker.date    :   nil;    break;
        case IQDropDownModeTimePicker:  return  [self.text length]  ?   self.timePicker.date    :   nil;    break;
        default:                        return  nil;                     break;
    }
}

-(void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}
- (void)setSelectedItem:(NSString*)selectedItem animated:(BOOL)animated
{
    
}
- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    switch (_dropDownMode)
    {
        case IQDropDownModeDatePicker:
            [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:date] animated:animated];
            break;
        case IQDropDownModeTimePicker:
            [self setSelectedItem:[self.dropDownTimeFormatter stringFromDate:date] animated:animated];
            break;
        default:
            break;
    }
}

- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter
{
    self.dropDownDateFormatter = userDateFormatter;
    [self.datePicker setLocale:self.dropDownDateFormatter.locale];
}

- (void)setTimeFormatter:(NSDateFormatter *)userTimeFormatter
{
    self.dropDownTimeFormatter = userTimeFormatter;
    [self.timePicker setLocale:self.dropDownTimeFormatter.locale];
}

-(void)setSelectedItem:(NSString *)selectedItem
{
    [self setSelectedItem:selectedItem animated:NO];
}

-(void)setSelectedItem:(NSString *)selectedItem1 selectedItem2:(NSString *)selectedItem2  animated:(BOOL)animated
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            
            if ([_ItemListsInternal containsObject:selectedItem1])
            {
                _selectedItem = selectedItem1;
                
                [self setSelectedRow:[_ItemListsInternal indexOfObject:selectedItem1] animated:animated];
                
                if ([self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
                    [self.delegate textField:self didSelectItem:_selectedItem];
            }
            break;
            
            case IQDropDownModeMonthYearPicker:
            if ([self.monthsArray containsObject:selectedItem1] && [self.yearsArray containsObject:selectedItem2])
            {
                self.text = [NSString stringWithFormat:@"%@, %@",selectedItem1,selectedItem2 ];

                _selectedItem = selectedItem1;
                _selectedItem2 = selectedItem2;
                
                [self setSelectedRowForComponent1:[self.monthsArray indexOfObject:_selectedItem] ForComponent2:[self.yearsArray indexOfObject:_selectedItem2] animated:animated];
                
//                [self setSelectedRow:[_ItemListsInternal indexOfObject:selectedItem1] animated:animated];
//                
//                if ([self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
//                    [self.delegate textField:self didSelectItem:_selectedItem];
            }

            
            break;
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [self.dropDownDateFormatter dateFromString:selectedItem1];
            if (date)
            {
                _selectedItem = selectedItem1;
                self.text = selectedItem1;
                [self.datePicker setDate:date animated:animated];
                
                if ([self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
                    [self.delegate textField:self didSelectItem:_selectedItem];
            }
            else if ([selectedItem1 length])
            {
                NSLog(@"Invalid date or date format:%@",selectedItem1);
            }
            break;
        }
        case IQDropDownModeTimePicker:
        {
            NSDate *date = [self.dropDownTimeFormatter dateFromString:selectedItem1];
            if (date)
            {
                _selectedItem = selectedItem1;
                self.text = selectedItem1;
                [self.timePicker setDate:date animated:animated];
                
                if ([self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
                    [self.delegate textField:self didSelectItem:_selectedItem];
            }
            else if([selectedItem1 length])
            {
                NSLog(@"Invalid time or time format:%@",selectedItem1);
            }
            break;
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        _datePickerMode = datePickerMode;
        [self.datePicker setDatePickerMode:datePickerMode];
        
        switch (datePickerMode) {
            case UIDatePickerModeCountDownTimer:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeDate:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeTime:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
        }
    }
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    self.datePicker.minimumDate = minimumDate;
    self.timePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    self.datePicker.maximumDate = maximumDate;
    self.timePicker.maximumDate = maximumDate;
}

-(void)setIsOptionalDropDown:(BOOL)isOptionalDropDown
{
    _isOptionalDropDown = isOptionalDropDown;
    
    if (_isOptionalDropDown)
    {
        NSArray *array = [NSArray arrayWithObject:@"Select"];
        _ItemListsInternal = [array arrayByAddingObjectsFromArray:_itemList];
    }
    else
    {
        _ItemListsInternal = [_itemList copy];
    }
    
    [self.pickerViewTextPicker reloadAllComponents];
}

#pragma mark - Getter

-(NSDateComponents *)dateComponents
{
    return [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear fromDate:self.date];
}

- (NSInteger)year   {   return [[self dateComponents] year];    }
- (NSInteger)month  {   return [[self dateComponents] month];   }
- (NSInteger)day    {   return [[self dateComponents] day];     }
- (NSInteger)hour   {   return [[self dateComponents] hour];    }
- (NSInteger)minute {   return [[self dateComponents] minute];  }
- (NSInteger)second {   return [[self dateComponents] second];  }

@end
