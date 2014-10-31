//
//  PhotoScreenViewController.h
//  SSuggestText
//
//  Created by Saulo G Tauil on 25/08/14.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSuggestText/SSuggestText.h>

@interface PhotoScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet SSuggestText *tag1;
@property (weak, nonatomic) IBOutlet SSuggestText *tag2;
@property (weak, nonatomic) IBOutlet SSuggestText *tag3;
@property (weak, nonatomic) IBOutlet SSuggestText *tag4;

@end
