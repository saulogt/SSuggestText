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
#import "SSuggestCell.h"
#import "SSuggestTextDelegate.h"


#ifdef DEBUG
#   define NSLogD(...) NSLog(__VA_ARGS__)
#else
#   define NSLogD(...)
#endif
#undef NSLogD
#define NSLogD(...)

@interface SSuggestText()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *tagViews;

@property (readonly,nonatomic) UITableViewController* tableVC;
@property (nonatomic) UIPopoverController* poc;

@property (nonatomic) NSArray* filteredTags;

//@property (nonatomic) NSString* searchText;

@property (nonatomic) SSuggestTextDelegate* textViewDelegate;

@property (nonatomic) NSString* partialSeach;

@property (nonatomic) BOOL hasWindow;

@end

static NSString* const dataKeySuggest = @"suggestDataKey";

@implementation SSuggestText

@synthesize tableVC = _tableVC;
@synthesize possibleTags = _possibleTags;

#pragma mark - popup

- (void)matchStrings:(NSString *)letters {
    if (self.possibleTags.count > 0) {
        
        self.filteredTags = [self.possibleTags
                             filteredArrayUsingPredicate:
                             [NSPredicate predicateWithFormat:@"tagDesc contains[cd] %@", letters]];
        
        [self.tableVC.tableView reloadData];
    }
    
    NSLogD(@"letters: '%@', filteredCount: %d", letters, self.filteredTags.count);
}

- (void)showPopOverList {
    if (!self.hasWindow)
        return;
    
    if (self.filteredTags.count == 0 && !self.enableTagCreation){
        [_poc dismissPopoverAnimated:YES];
    } else if (!_poc.isPopoverVisible) {
        [_poc presentPopoverFromRect:self.frame
                              inView:self.superview
            permittedArrowDirections:UIPopoverArrowDirectionUp
                            animated:YES];
    }
}

-(void)didMoveToWindow
{
    [super didMoveToWindow];
    self.hasWindow = YES;
}

#pragma mark - getter n setters


-(UITableViewController *)tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableVC.tableView.delegate = self;
        _tableVC.tableView.dataSource = self;
        [_tableVC.tableView registerClass:[SSuggestCell class] forCellReuseIdentifier:@"Cell Add"];
        [_tableVC.tableView registerClass:[SSuggestCell class] forCellReuseIdentifier:@"Cell Use"];
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

-(NSArray *)possibleTags
{
    if (_possibleTags == nil)
    {
        _possibleTags = [[NSMutableArray alloc] init];
    }
    return _possibleTags;
}

-(void)setTagList:(NSMutableArray *)tagList
{
    _tagList = tagList;
    
    [self recreateAttributedStringByTags];
    [self setNeedsDisplay];
    
    // Pass Delegate
    /*
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:self];
    */
     
    if (self.suggestDelegate)
        [self.suggestDelegate suggestText: self newTagList: tagList];
}

//
//-(NSString *)searchText
//{
//    if (_searchText == nil)
//    {
//        _searchText = [[NSMutableString alloc] init];
//    }
//    return _searchText;
//}

#pragma mark - setup

-(void) setup{
    
    self.contentMode = UIViewContentModeRedraw;
    self.tagList = [[NSMutableArray alloc] init];
    
    self.delegate = self.textViewDelegate = [[SSuggestTextDelegate alloc] init];
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
    if (indexPath.section == 1){
        static NSString* CellIdentifier = @"Cell Use";
        SSuggestCell* cell = (SSuggestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
        
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
    else if (indexPath.section == 0)
    {
        static NSString* CellIdentifier = @"Cell Add";
        SSuggestCell* cell = (SSuggestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
        
        NSAssert([cell isKindOfClass:[SSuggestCell class]], @"invalid cell type");
        
        if (cell == nil) {
            cell = [[SSuggestCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        }
        
        //SSuggestTag* tagData  = [self.filteredTags objectAtIndex: indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat: @"+\"%@\"", self.partialSeach];
        cell.textLabel.textColor = [UIColor redColor];
        cell.tagData = nil;
        
        return cell;
        
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return self.filteredTags.count;
    else if (section == 0)
        return (self.enableTagCreation && self.partialSeach.length > 2 ? 1 : 0); ///TODO: detect if the text match perfectly with an possible tag
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        SSuggestTag* tagSelected = [self.filteredTags objectAtIndex: indexPath.row];
        
        NSAssert([tagSelected isKindOfClass:[SSuggestTag class]], @"invalid tag type");
        
        [self addTag: tagSelected];
        
        [self.poc dismissPopoverAnimated:YES];
        
    }
    else if(indexPath.section == 0)
    {
        //Request to add a custom tag
        NSString* partial = self.partialSeach;
        
        if (partial.length > 2){
            NSArray* filtered = [self.possibleTags
                                 filteredArrayUsingPredicate:
                                 [NSPredicate predicateWithFormat:@"tagDesc = %@", partial]];
            if (filtered.count == 0)
            {
                CFUUIDRef theUUID = CFUUIDCreate(NULL);
                CFStringRef string = CFUUIDCreateString(NULL, theUUID);
                CFRelease(theUUID);
                NSString* ident = (__bridge NSString *)string;
                
                
                [self addTag:[SSuggestTag tagDataWithDesc: partial AndId:[NSString stringWithFormat: @"Custom:%@", ident]]];
                [self.poc dismissPopoverAnimated:YES];
            }
        }
    }
}

#pragma mark - paint


- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    for (UIView *tagView in self.tagViews) {
        [tagView removeFromSuperview];
    }
    
    if (self.tagList == nil || self.attributedText.length  < 1) return;
    
    // 3. Find and draw
    
    [self.attributedText enumerateAttribute:dataKeySuggest inRange:NSMakeRange(0, self.attributedText.length)
                                    options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        
                                        if ([self tagForId:value]){
                                            //                                            NSLog(@"%d, %d",range.location, range.length);
                                            CFRange cfRange = CFRangeMake(range.location, range.length);
                                            [self calculatingTagRectAndDraw:cfRange];
                                            
                                            
                                        }
                                        
                                    }];
    
}

- (void) calculatingTagRectAndDraw:(CFRange) tagStringRange
{
    /*
     Caclulating Rect and Draw
     */
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UITextView *textView = self;
    
    // 4) Find rect
    CFRange stringRange = tagStringRange;
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

-(void) recreateAttributedStringByTags
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc]
                                        initWithString: @" "
                                        attributes:[self defaultAttributedString]];
    
    
    for (SSuggestTag* tag in self.tagList) {
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:[self defaultAttributedString]];
        [attr setObject: tag.tagId forKey:dataKeySuggest];
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@", tag.tagDesc]
                                                 attributes:attr];
        [nameString appendAttributedString: space];
        
        [attrString appendAttributedString: nameString];
    }
    self.attributedText = attrString;
}

#pragma mark - adding Tag

- (void)addTag:(SSuggestTag *)newtag
{
    // Check aleady imported
    for (SSuggestTag *tag in self.tagList) {
        
        if ([tag.tagId isEqualToString:newtag.tagId])
        {
            
            
            return;
        }
    }
    
    // Add
    if (!self.tagList) self.tagList = [[NSMutableArray alloc] init];
    [self.tagList addObject:newtag];
    
    [self recreateAttributedStringByTags];
    
    //self.searchText = nil;
    
    /*
     // Insert Plain user name text
     NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:[self defaultAttributedString]];
     [attr setObject:newtag.tagId forKey:dataKeySuggest];
     NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"%@", newtag.tagDesc]
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
     */
    
    [self setNeedsDisplay];
    
    // Pass Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:self];
    
    if (self.suggestDelegate != nil)
    {
        [self.suggestDelegate suggestText:self tagSelected:newtag];
    }
}

-(void)addPossibleTagsObject:(SSuggestTag *)possibleTag
{
    NSArray* a = self.possibleTags;
    NSMutableArray* larray = (NSMutableArray*) a;
    NSAssert([larray isKindOfClass:[NSMutableArray class]], @"invalid type");
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"tagId == %@", possibleTag.tagId];
    
    for (id object in larray) {
        if ([pred evaluateWithObject:object]) {
            return; //Do nothing if the id was found
        }
    }
    
    [larray addObject: possibleTag];
    
}

- (NSRange) findTagPosition:(SSuggestTag*)tag
{
    
    __block NSRange stringRange = NSMakeRange(0, 0);
    [self.attributedText enumerateAttribute:dataKeySuggest inRange:NSMakeRange(0, self.attributedText.length-1)
                                    options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        
                                        if ([value isEqualToString:tag.tagId])
                                        {
                                            stringRange = range;
                                            //                                            stringRange = CFRangeMake(range.location, range.location + range.length);
                                        }
                                        
                                    }];
    
    return stringRange;
    
}

- (SSuggestTag *) tagForId:(NSString*)tagId
{
    for (SSuggestTag *tag in self.tagList) {
        
        if ([tag.tagId isEqualToString:tagId])
            return tag;
    }
    
    return nil;
}

-(NSString*) getSearch
{
    
    NSMutableString* search = [[NSMutableString alloc] init];
    NSAttributedString* str = self.attributedText;
    [str enumerateAttributesInRange: NSMakeRange(0, str.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if ([attrs objectForKey:dataKeySuggest] == nil)
        {
            NSString* substring = [str.string substringWithRange: range];
            ;
            if ([[search stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] &&
                [[substring stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]
                )
            {
                //
            }
            else
            {
                [search appendString: substring];
            }
        }
        
    }];
    return [search stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]] ;
}

#pragma mark - UITextviewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
    
    NSLogD(@"textViewDidChange... attributtedString: %@", self.attributedText.string);
    // length = 0, but attributed have id
    if (self.attributedText.string.length == 0)
    {
        [self clearAllAttributedStrings];
    }
    
    ///TODO: determine when it should appear
    
    self.partialSeach = [self getSearch];
    [self matchStrings: self.partialSeach];
    [self showPopOverList];
    
    return;
    
}



- (BOOL) shouldChangeTextInRange:(NSRange)editingRange replacementText:(NSString *)text
{
    
    __block BOOL result = YES;
    
    //NSString* textContent = [self.searchText stringByReplacingCharactersInRange:editingRange withString:text];
    
    if (!self.enableMultipleTags && self.tagList.count > 0)
    {
        //Cannot create tag anymore. limit reached
        if (editingRange.length == 1 && [text isEqualToString:@""]) {
            //It is deleting. Deleting is ok
        }
        else
        {
            return NO;
        }
    }
    
    NSLogD(@"shdChgTxtInRng '%@' text:%@ , loc:%d , len:%d", self.text , text , editingRange.location , editingRange.length);
    
    // ALl clear
    if (editingRange.location == 0 && editingRange.length == self.attributedText.string.length)
    {
        
        
        
        [self clearAll];
        
        
        
        return YES;
    }
    
    // Checking to insert within tag
    if (text.length > 0)
    {
        NSRange rangeOfCheckingEditingInTag = editingRange;
        if (rangeOfCheckingEditingInTag.location + rangeOfCheckingEditingInTag.length <= self.attributedText.length)
        {
            rangeOfCheckingEditingInTag.length = 1;
            rangeOfCheckingEditingInTag.location-=1;
            
            //            NSLog(@"<<<<< ----------- 1");
            
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
            
            if ([attrs objectForKey:dataKeySuggest] && [self tagForId:[attrs objectForKey:dataKeySuggest]])
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
            
            if ([attrs objectForKey:dataKeySuggest] && [self tagForId:[attrs objectForKey:dataKeySuggest]])
            {
                
                NSRange tagRange = [self findTagPosition:[self tagForId:[attrs objectForKey:dataKeySuggest]]];
                
                //                NSLog(@"Deleted tag tag >>>>> id(%@):range(%d,%d)",[attrs objectForKey:dataKeySuggest], tagRange.location, tagRange.length);
                
                self.attributedText = [self attributedStringWithCutOutOfRange:tagRange];
                self.selectedRange = NSMakeRange(tagRange.location, 0);
                
                SSuggestTag* tagToBeRemoved = [self tagForId:[attrs objectForKey:dataKeySuggest]];
                
                [self.tagList removeObject: tagToBeRemoved];
                [self setNeedsDisplay];
                
                if (self.suggestDelegate != nil)
                    [self.suggestDelegate suggestText: self tagDeleted: tagToBeRemoved];
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


- (void) clearAllAttributedStrings
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString removeAttribute: dataKeySuggest range: NSMakeRange(0, self.text.length)];
    [self.tagList removeAllObjects];
    [self setNeedsDisplay];
    //    NSLog(@"cleared attributes!");
}


- (void)clearAll
{
    
    [self clearAllAttributedStrings];
    self.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:[self defaultAttributedString]];
    [self setNeedsDisplay];
    
    if (self.suggestDelegate != nil)
    {
        [self.suggestDelegate suggestTextClearAllTags: self];
    }
}
@end
