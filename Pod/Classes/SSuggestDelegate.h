//
//  SSuggestDelegate.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 24/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSuggestText;
@class SSuggestTag;

@protocol SSuggestDelegate<NSObject>



-(void) suggestText: (SSuggestText*) suggestText tagSelected : (SSuggestTag*) tag;

-(void) suggestText: (SSuggestText*) suggestText tagDeleted : (SSuggestTag*) tag;

-(void) suggestTextClearAllTags:(SSuggestText *)suggestText;

-(void) suggestText: (SSuggestText*) suggestText newTagList: (NSArray*) tagList;



@end
