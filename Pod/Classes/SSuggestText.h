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
@property (nonatomic) NSMutableArray *annotationList;
@property (nonatomic) UIImage        *nameTagImage;

@property (nonatomic) NSArray* possibleTags;
// Add new Anotation
// info should include 'SSuggestTagInfoID', 'SSuggestTagInfoName'
//              SSuggestTagInfoID   = Unique Identifier to disturb dobule inserting same info.
//              SSuggestTagInfoName = Appeared name in view.
- (void) addAnnotation:(SSuggestTag*)annoatin;

/*
 Make s tring without tag strign
 ex ) hi good mornig.  (removed 'Sally' annotation tag text)
 */
- (NSString*) makeStringWithoutTagString;


/*
 remove text and attributes and annotationList
 */
- (void) clearAll;



@end
