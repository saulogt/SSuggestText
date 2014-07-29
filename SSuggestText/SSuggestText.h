//
//  SSuggestText.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 23/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SSuggestDelegate.h"
#import "SSuggestDatasource.h"

@interface SSuggestText : UITextField<NSObject>

@property (nonatomic, weak) NSObject<SSuggestDelegate>* suggestDelegate;
@property (nonatomic, weak) NSObject<SSuggestDatasource>* dataSource;

@property (nonatomic) BOOL acceptMultipleTags;

@end
