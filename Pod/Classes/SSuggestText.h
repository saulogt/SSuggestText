//
//  STAppDelegate.h
//  SSuggestText
//
//  Created by CocoaPods on 08/17/2014.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SSuggestTag.h"

@interface SSuggestText : UITextView <UITextViewDelegate>

@property (nonatomic) UIColor        *nameTagColor;
@property (nonatomic) UIColor        *nameTagLineColor;
@property (nonatomic) UIImage        *nameTagImage;

//This array contains all tags currently selected in the component
//The inner element type is SSuggestTag
@property (nonatomic) NSMutableArray *tagList;

//This is an array with all possible tags that can appear on the suggest popover
//You can set an array of SSuggestTag or an array o NSDictionary with the format: @{@"tagId": "1", @"tagDesc": @"Tag description"}
@property (nonatomic) NSArray        *possibleTags;

//This option will enable more tha only one tag per component
@property (nonatomic) BOOL enableMultipleTags;

//This option will allow a tag creation by typing
@property (nonatomic) BOOL enableTagCreation;

// Add new tag to the selected ones
- (void) addTag:(SSuggestTag*)tag;

/*
 remove text and attributes and tagList
 */
- (void) clearAll;

//Helper function that adds a possible tag in the database individually skiping duplicated objects
-(void)addPossibleTagsObject:(SSuggestTag*)possibleTag;


#pragma mark - internal usage

-(BOOL) shouldChangeTextInRange:(NSRange) editRange replacementText: (NSString*) text;


@end
