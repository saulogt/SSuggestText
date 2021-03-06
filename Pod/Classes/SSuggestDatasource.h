//
//  SSuggestDatasource.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 24/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSuggestText;

@protocol SSuggestDatasource <NSObject>

-(NSInteger) countInSuggestText: (SSuggestText*) suggestText;
-(NSString*) suggestText:(SSuggestText*) suggestText textAtIndexPath: (NSIndexPath*) indexPath;

@end