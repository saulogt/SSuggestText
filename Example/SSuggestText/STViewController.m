//
//  STViewController.m
//  SSuggestText
//
//  Created by saulogt on 08/17/2014.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import "STViewController.h"
#include <SSuggestText/SSuggestText.h>


@interface STViewController ()

@property (weak, nonatomic) IBOutlet SSuggestText *suggestText;

@property (nonatomic) NSArray* val;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.suggestText.possibleTags = self.val;
    
    self.suggestText.nameTagImage = [UIImage imageNamed: @"tagImageSample"];
    
   // [self.suggestText addAnnotation:[SSuggestTag tagDataWithDesc: @"AAAAAA" AndId: @"1000"]];

}

- (IBAction)btnClicked:(id)sender {
    NSArray* tags = self.suggestText.annotationList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)val
{
    if (_val == nil)
    {
        _val = @[@{@"id" : @"1", @"desc" :@"acdf"},
                 @{@"id" : @"2", @"desc" :@"erdfc"},
                 @{@"id" : @"3", @"desc" :@"abcde"},
                 @{@"id" : @"4", @"desc" :@"zzxse"},
                 @{@"id" : @"5", @"desc" :@"ewsd"},
                 @{@"id" : @"6", @"desc" :@"obcetdg"},
                 @{@"id" : @"7", @"desc" :@"gg tres"},
                 @{@"id" : @"8", @"desc" :@"abffdretu uuyd"},
                 ];
    }
    return _val;
}


@end
