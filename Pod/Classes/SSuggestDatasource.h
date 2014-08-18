//
//  SSuggestDatasource.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 24/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

@protocol SSuggestDatasource <NSObject>

-(NSInteger) count;
-(NSString*) textAtIndexPath: (NSIndexPath*) indexPath;

@end