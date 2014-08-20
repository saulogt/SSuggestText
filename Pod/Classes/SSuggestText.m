//
//  STAppDelegate.h
//  SSuggestText
//
//  Created by CocoaPods on 08/17/2014.
//  Copyright (c) 2014 saulogt. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SSuggestText.h"
#import "SupportFiles/SSuggestCell.h"

static NSString* const keyModelId = @"mintACV_id";


@interface TextViewDelegate : NSObject<UITextViewDelegate>

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end


@interface SSuggestText()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *tagViews;

@property (readonly,nonatomic) UITableViewController* tableVC;
@property (nonatomic) UIPopoverController* poc;

@property (nonatomic) NSArray* filteredTags;

@property (nonatomic) NSString* searchText;

-(BOOL) shouldChangeTextInRange:(NSRange) editRange replacementText: (NSString*) text;

@end


@implementation TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    SSuggestText* textV = (SSuggestText*)textView;
    return [textV shouldChangeTextInRange:range replacementText:text];
}


- (void)textViewDidChange:(UITextView *)textView
{
    // Checking User trying to remove MintAnnotationView's annoatation
    SSuggestText* textV = (SSuggestText*)textView;
    [textV textViewDidChange:textView];
    
}


@end



@implementation SSuggestText

TextViewDelegate* textViewDelegate;

@synthesize tableVC = _tableVC;

#pragma mark - popup

- (void)matchStrings:(NSString *)letters {
    if (self.possibleTags.count > 0) {
        
        self.filteredTags = [self.possibleTags
                             filteredArrayUsingPredicate:
                             [NSPredicate predicateWithFormat:@"tagDesc contains[cd] %@", letters]];
        
        [self.tableVC.tableView reloadData];
    }
}

- (void)showPopOverList {
    
    if (self.filteredTags.count == 0){
        [_poc dismissPopoverAnimated:YES];
    } else if (!_poc.isPopoverVisible) {
        [_poc presentPopoverFromRect:self.frame
                              inView:self.superview
            permittedArrowDirections:UIPopoverArrowDirectionUp
                            animated:YES];
    }
}


#pragma mark - getter n setters

-(UITableViewController *)tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableVC.tableView.delegate = self;
        _tableVC.tableView.dataSource = self;
        [_tableVC.tableView registerClass:[SSuggestCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableVC;
}

-(void)setPossibleTags:(NSArray *)possibleTags
{
    NSMutableArray* larray;
    _possibleTags = larray = [[NSMutableArray alloc] init];
    for (id obj in possibleTags) {
        if ([obj isKindOfClass:[SSuggestTag class]]) {
            [larray addObject: obj];
        }
        else
        {
            [larray addObject: [SSuggestTag tagDataWithDictionary: obj]];
        }
    }
}

#pragma mark - setup

-(void) setup{
    
    self.contentMode = UIViewContentModeRedraw;
    self.annotationList = [[NSMutableArray alloc] init];
    
    self.delegate = textViewDelegate = [[TextViewDelegate alloc] init];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.poc =
    [[UIPopoverController alloc] initWithContentViewController:self.tableVC];
    
    
    // Some custom apperances
    self.nameTagImage = [[UIImage imageNamed:@"tagImage"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    self.nameTagColor = [UIColor colorWithRed:0.00 green:0.54 blue:0.50 alpha:1.0];
    
    
}

#pragma mark - initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - tableview delegate & datasource



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    SSuggestCell* cell = (SSuggestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;//] forIndexPath:indexPath];
    
    NSAssert([cell isKindOfClass:[SSuggestCell class]], @"invalid cell type");
    
    if (cell == nil) {
        cell = [[SSuggestCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
    }
    
    SSuggestTag* tagData  = [self.filteredTags objectAtIndex: indexPath.row];
    
    cell.textLabel.text = tagData.tagDesc;
    cell.tagData = tagData;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredTags.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSuggestTag* tagSelected = [self.filteredTags objectAtIndex: indexPath.row];
    
    NSAssert([tagSelected isKindOfClass:[SSuggestTag class]], @"invalid tag type");
    
    [self addAnnotation: tagSelected];
    
    [self.poc dismissPopoverAnimated:YES];
}


#pragma mark - paint


- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    for (UIView *tagView in self.tagViews) {
        [tagView removeFromSuperview];
    }
    
    if (self.annotationList == nil || self.attributedText.length  < 1) return;
    
    // 3. Find and draw
    
    [self.attributedText enumerateAttribute:keyModelId inRange:NSMakeRange(0, self.attributedText.length)
                                    options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        
                                        if ([self annotationForId:value]){
                                            //                                            NSLog(@"%d, %d",range.location, range.length);
                                            CFRange cfRange = CFRangeMake(range.location, range.length);
                                            [self calculatingTagRectAndDraw:cfRange];
                                            
                                            
                                        }
                                        
                                    }];
    
}

- (void) calculatingTagRectAndDraw:(CFRange) annoationStringRange
{
    /*
     Caclulating Rect and Draw
     */
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UITextView *textView = self;
    
    // 4) Find rect
    CFRange stringRange = annoationStringRange;
    UITextPosition *begin = [textView positionFromPosition:textView.beginningOfDocument offset:stringRange.location];
    UITextPosition *end = [textView positionFromPosition:begin offset:stringRange.length];
    UITextRange *textRange = [textView textRangeFromPosition:begin toPosition:end];
    
    // 5) Need 2line?
    CGPoint firstCharPosition = [textView caretRectForPosition:begin].origin;
    CGPoint lastCharPosition = [textView caretRectForPosition:end].origin;
    
    if (firstCharPosition.y < lastCharPosition.y){
        
        // Finf pos of first line
        float secondY = firstCharPosition.y;
        CFRange secondStrRange = CFRangeMake(stringRange.location, 1); // first time is just init, not have mean of value
        NSInteger secondPos = stringRange.location;
        NSInteger cnt = 0;
        
        while (secondY < lastCharPosition.y) {
            
            secondPos++;
            cnt++;
            
            secondStrRange = CFRangeMake(secondPos, stringRange.length - cnt);
            UITextPosition *secondBegin = [textView positionFromPosition:textView.beginningOfDocument offset:secondStrRange.location];
            CGPoint secondPosition = [textView caretRectForPosition:secondBegin].origin;
            secondY = secondPosition.y;
            
        }
        
        // Calculate rect
        UITextPosition *secondBegin = [textView positionFromPosition:textView.beginningOfDocument offset:secondStrRange.location];
        UITextPosition *secondEnd = [textView positionFromPosition:secondBegin offset:secondStrRange.length];
        UITextRange *secondTextRange = [textView textRangeFromPosition:secondBegin toPosition:secondEnd];
        
        // 1st line
        [self drawTag:context Rect:[textView firstRectForRange:textRange]
                 name:[self textInRange:[textView textRangeFromPosition:textRange.start toPosition:secondBegin]]];
        
        // 2nd Line
        [self drawTag:context Rect:[textView firstRectForRange:secondTextRange]
                 name:[self textInRange:secondTextRange]];
    }
    else{
        // Draw rect first line
        [self drawTag:context Rect:[textView firstRectForRange:textRange] name:[self textInRange:textRange]];
    }
}



#pragma mark - Draw Tag graphics

- (void) drawTag: (CGContextRef) context Rect:(CGRect) rect name:(NSString*)nameText
{
    if(self.nameTagImage)
        [self drawTagImageInRect:rect name:nameText];
    else
        [self drawRectangle:context Rect:rect];
}

- (void) drawRectangle: (CGContextRef) context Rect:(CGRect) rect
{
    rect.size.width+=1;
    rect.size.height-=2;
    rect.origin.y+=1;
    
    if (_nameTagColor == nil)
        self.nameTagColor = [UIColor colorWithRed:0.98 green:1.00 blue:0.71 alpha:0.5];
    if (_nameTagLineColor == nil)
        self.nameTagLineColor = [UIColor colorWithRed:1.00 green:0.81 blue:0.35 alpha:0.6];
    
    CGContextSetFillColorWithColor(context, _nameTagColor.CGColor);
    CGContextSetStrokeColorWithColor(context, _nameTagLineColor.CGColor);
    
    // Draw line
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    
    // Fill
    CGContextFillRect(context, rect);
    CGContextStrokeRectWithWidth(context, rect, 0.5);
}

- (void) drawTagImageInRect:(CGRect) rect name:(NSString*)nameText
{
    self.nameTagColor = self.nameTagColor;
    
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagButton.frame = CGRectMake(rect.origin.x,
                                 rect.origin.y+1,
                                 rect.size.width,
                                 rect.size.height);
    
    [tagButton setBackgroundImage:self.nameTagImage forState:UIControlStateNormal];
    [tagButton setTitle:nameText forState:UIControlStateNormal];
    [tagButton setTitleColor:self.nameTagColor forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:self.font.pointSize-4];
    
    if (!self.tagViews)
        self.tagViews = [[NSMutableArray alloc] init];
    
    [self.tagViews addObject:tagButton];
    [self addSubview:tagButton];
}


#pragma mark - Modeling

// --- NEW ---
- (void)addAnnotation:(SSuggestTag *)newAnnoation
{
    // Check aleady imported
    for (SSuggestTag *annotation in self.annotationList) {
        
        if ([annotation.tagId isEqualToString:newAnnoation.tagId])
        {
            //            NSLog(@"MintAnnoationChatView >> addAnoation >> id'%@'is aleady in", newAnnoation.tagId);
            return;
        }
    }
    
    // Add
    if (!self.annotationList) self.annotationList = [[NSMutableArray alloc] init];
    [self.annotationList addObject:newAnnoation];
    
    // Insert Plain user name text
    NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:[self defaultAttributedString]];
    [attr setObject:newAnnoation.tagId forKey:keyModelId];
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]
                                             initWithString:[NSString stringWithFormat:@"%@", newAnnoation.tagDesc]
                                             attributes:attr];
    
    NSMutableAttributedString *spaceStringPefix = nil;
    NSString *tempCommentWriting = self.text;
    
    //    NSLog(@"nameString:%@",nameString);
    
    
    NSInteger cursor = self.selectedRange.location;
    // display name
    
    // Add Last
    //    NSLog(@"self.attributedText.string.length:%d",self.attributedText.string.length);
    if (cursor >= self.attributedText.string.length-1)
    {
        // Add Space
        if (tempCommentWriting.length > 0){
            
            NSString *prevString = [tempCommentWriting substringFromIndex:tempCommentWriting.length-1];
            
            if (![prevString isEqualToString:@"\n"])
            {
                spaceStringPefix = [[NSMutableAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]];
            }
        }
        
        NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        if (spaceStringPefix)
            [conts appendAttributedString:spaceStringPefix];
        [conts appendAttributedString:nameString];
        NSMutableAttributedString *afterBlank = [[NSMutableAttributedString alloc] initWithString:@" "
                                                                                       attributes:[self defaultAttributedString]];
        [conts appendAttributedString:afterBlank];
        
        //        NSLog(@"conts:%@",conts);
        
        self.attributedText = conts;
        //        NSLog(@"\n\nself.attributedText:%@",self.attributedText);
        
    }
    // Insert in text
    else
    {
        self.attributedText = [self attributedStringInsertString:nameString at:cursor];
    }
    
    
    [self setNeedsDisplay];
    
    // Pass Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:self];
}

- (NSRange) findTagPosition:(SSuggestTag*)annoation
{
    
    __block NSRange stringRange = NSMakeRange(0, 0);
    [self.attributedText enumerateAttribute:keyModelId inRange:NSMakeRange(0, self.attributedText.length-1)
                                    options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        
                                        if ([value isEqualToString:annoation.tagId])
                                        {
                                            stringRange = range;
                                            //                                            stringRange = CFRangeMake(range.location, range.location + range.length);
                                        }
                                        
                                    }];
    
    return stringRange;
    
}

- (SSuggestTag *) annotationForId:(NSString*)tagId
{
    for (SSuggestTag *annotation in self.annotationList) {
        
        if ([annotation.tagId isEqualToString:tagId])
            return annotation;
    }
    
    return nil;
}

#pragma mark - UITextviewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
    
    // length = 0, but attributed have id
    if (self.attributedText.string.length == 0)
    {
        [self clearAllAttributedStrings];
    }
    
    return;
    
}

- (BOOL) shouldChangeTextInRange:(NSRange)editingRange replacementText:(NSString *)text
{
    
    __block BOOL result = YES;
    
    
    ///TODO: determine when it should appear
    [self matchStrings:text];
    [self showPopOverList];
    
    // ALl clear
    if (editingRange.location == 0 && editingRange.length == self.attributedText.string.length)
    {
        //        NSLog(@"<<<<<< --- all cleared by keyboard");
        [self clearAll];
        return YES;
    }
    
    // Checking Trying to insert within tag
    if (text.length > 0)
    {
        NSRange rangeOfCheckingEditingInTag = editingRange;
        if (rangeOfCheckingEditingInTag.location + rangeOfCheckingEditingInTag.length <= self.attributedText.length)
        {
            rangeOfCheckingEditingInTag.length = 1;
            rangeOfCheckingEditingInTag.location-=1;
            
            //            NSLog(@"<<<<< ----------- 1");
            
            //
            NSInteger totalLength = rangeOfCheckingEditingInTag.location + rangeOfCheckingEditingInTag.length;
            if (totalLength > self.attributedText.length)
            {
                rangeOfCheckingEditingInTag = NSMakeRange(0, 0);
                //                NSLog(@"<<<<< ----------- 2");
            }
            else if (totalLength < 1)
            {
                rangeOfCheckingEditingInTag = NSMakeRange(0, 0);
                //                NSLog(@"<<<<< -------------3");
            }
        }
        
        
        [self.attributedText enumerateAttributesInRange:rangeOfCheckingEditingInTag options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([attrs objectForKey:keyModelId] && [self annotationForId:[attrs objectForKey:keyModelId]])
            {
                NSLog(@"------- Editing In Tag");
                result = NO;
            }
            
        }];
        
        
        return result;
    }
    // Deleting
    else
    {
        editingRange.location-=1;
        if (editingRange.location == -1)
            editingRange.location = 0;
        
        if (editingRange.length == 0)
        {
            //            NSLog(@"location >>>> 0");
            
            if (self.attributedText.length == 0)
            {
                [self clearAllAttributedStrings];
            }
            
            return YES;
            
        }
        
        [self.attributedText enumerateAttributesInRange:editingRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([attrs objectForKey:keyModelId] && [self annotationForId:[attrs objectForKey:keyModelId]])
            {
                
                NSRange tagRange = [self findTagPosition:[self annotationForId:[attrs objectForKey:keyModelId]]];
                
                //                NSLog(@"Deleted annotation tag >>>>> id(%@):range(%d,%d)",[attrs objectForKey:keyModelId], tagRange.location, tagRange.length);
                
                self.attributedText = [self attributedStringWithCutOutOfRange:tagRange];
                self.selectedRange = NSMakeRange(tagRange.location, 0);
                
                [self.annotationList removeObject:[self annotationForId:[attrs objectForKey:keyModelId]]];
                [self setNeedsDisplay];
            }
            
        }];
        
        return YES;
        
    }
    
}


#pragma mark - AttributedStrings
- (NSAttributedString *) attributedStringWithCutOutOfRange:(NSRange)cuttingRange
{
    /*
     Cut out string of range on full string
     to get head + tail without middle
     */
    
    // Cutting Heads
    NSAttributedString *head = nil;
    if (cuttingRange.location > 0 && cuttingRange.length > 0)
        head = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, cuttingRange.location-1)];
    else
        head = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    
    
    // Cutting Tail
    
    NSAttributedString *tail = nil;
    if (cuttingRange.location + cuttingRange.length <= self.attributedText.string.length)
        tail = [self.attributedText attributedSubstringFromRange:NSMakeRange(cuttingRange.location + cuttingRange.length,
                                                                             self.attributedText.length - 1 - cuttingRange.location - cuttingRange.length)];
    
    NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    if (head)
        [conts appendAttributedString:head];
    if (tail)
        [conts appendAttributedString:tail];
    
    return conts;
}

- (NSAttributedString *) attributedStringInsertString:(NSAttributedString*)insertingStr at:(NSInteger)position
{
    /*
     Insert str within text at position
     with blank
     -> head + blank + insertingStr + blank + tail
     */
    
    // Cutting Heads
    NSAttributedString *head = nil;
    if (position > 0 && self.attributedText.string.length > 0)
        head = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, position)];
    else if (position > 0)
        head = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    
    
    // Cutting Tail
    NSAttributedString *tail = nil;
    if (position + 1 < self.attributedText.string.length)
        tail = [self.attributedText attributedSubstringFromRange:NSMakeRange(position,
                                                                             self.attributedText.length - position)];
    else{
        tail = [[NSMutableAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]];
    }
    
    NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    
    if (head)
    {
        [conts appendAttributedString:head];
        [conts appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]]];
    }
    
    [conts appendAttributedString:insertingStr];
    
    if (tail)
    {
        [conts appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]]];
        [conts appendAttributedString:tail];
    }
    
    return conts;
}

- (NSDictionary*) defaultAttributedString
{
    return @{NSFontAttributeName : self.font};
}



#pragma mark -ETC

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    /*
     Couldn't Cut, Copy, Past
     */
    return NO;
}

- (NSString*) makeStringWithoutTagString
{
    
    NSMutableAttributedString *workingStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    // Finding Replace ranges and annoations
    [workingStr enumerateAttribute:keyModelId inRange:NSMakeRange(0, workingStr.string.length) options:0
                        usingBlock:^(id value, NSRange range, BOOL *stop) {
                            
                            SSuggestTag *annoation = nil;
                            if (value){
                                annoation = [self annotationForId:value];
                            }
                            
                            if (annoation){
                                [workingStr replaceCharactersInRange:range withString:@""];
                                
                            }
                            
                        }];
    
    return workingStr.string;
    
}

- (void) clearAllAttributedStrings
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString removeAttribute: keyModelId range: NSMakeRange(0, self.text.length)];
    [self.annotationList removeAllObjects];
    [self setNeedsDisplay];
    //    NSLog(@"cleared attributes!");
}


- (void)clearAll
{
    [self clearAllAttributedStrings];
    self.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:[self defaultAttributedString]];
    [self setNeedsDisplay];
}
@end
