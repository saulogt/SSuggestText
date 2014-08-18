//
//  SSuggestDelegate.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 24/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSuggestDelegate<NSObject>

-(void) tagSelected : (NSIndexPath*) indexPath displayString: (NSString*) displayString;

@end
