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
@property (nonatomic) NSMutableArray *tagList;
@property (nonatomic) UIImage        *nameTagImage;

@property (nonatomic) NSArray* possibleTags;
// Add new Anotation
// info should include 'SSuggestTagInfoID', 'SSuggestTagInfoName'
//              SSuggestTagInfoID   = Unique Identifier to disturb dobule inserting same info.
//              SSuggestTagInfoName = Appeared name in view.
- (void) addTag:(SSuggestTag*)tag;

/*
 remove text and attributes and tagList
 */
- (void) clearAll;




#pragma mark - internal usage

-(BOOL) shouldChangeTextInRange:(NSRange) editRange replacementText: (NSString*) text;


@end
