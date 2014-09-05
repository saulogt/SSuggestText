//
//  PhotoScreenViewController.m
//  SSuggestText
//
//  Created by Saulo G Tauil on 25/08/14.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import "PhotoScreenViewController.h"
#import <SSuggestText.h>

@interface PhotoScreenViewController ()<SSuggestDelegate>

@property (weak, nonatomic) IBOutlet SSuggestText *tag1;
@property (weak, nonatomic) IBOutlet SSuggestText *tag2;
@property (weak, nonatomic) IBOutlet SSuggestText *tag3;
@property (weak, nonatomic) IBOutlet SSuggestText *tag4;


@end

@implementation PhotoScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //id s = self.tag1.possibleTags;

    self.tag1.enableMultipleTags = YES;
    [self.tag1 addPossibleTagsObject:[SSuggestTag tagDataWithDesc:@"Scene 1" AndId:@"1"]];
    [self.tag1 addPossibleTagsObject:[SSuggestTag tagDataWithDesc:@"Scene - Home" AndId:@"2"]];
    [self.tag1 addPossibleTagsObject:[SSuggestTag tagDataWithDesc:@"Shopping" AndId:@"3"]];
    [self.tag1 addPossibleTagsObject:[SSuggestTag tagDataWithDesc:@"Airport" AndId:@"4"]];
    [self.tag1 addPossibleTagsObject:[SSuggestTag tagDataWithDesc:@"Street" AndId:@"5"]];
    
    self.tag2.enableMultipleTags = YES;
    self.tag2.possibleTags = @[@{@"id": @"1", @"desc": @"John"},
                               @{@"id": @"2", @"desc": @"Mike"},
                               @{@"id": @"3", @"desc": @"Jessica Miller"},
                               @{@"id": @"4", @"desc": @"Antony"},
                               @{@"id": @"5", @"desc": @"Fernando"},
                               @{@"id": @"6", @"desc": @"Myself"},
                               @{@"id": @"7", @"desc": @"His Wife"},
                               ];
    
    self.tag3.enableMultipleTags = YES;
    self.tag3.possibleTags = @[@{@"id": @"1", @"desc": @"Clothing 1"},
                               @{@"id": @"2", @"desc": @"Clothing 2"}
                               ];
    
    
    self.tag4.enableMultipleTags = YES;
    self.tag4.enableTagCreation = YES;
    self.tag4.possibleTags = @[@{@"id": @"1", @"desc": @"Party"},
                               @{@"id": @"2", @"desc": @"Restaurant"}
                               ];
    
    
    self.tag1.suggestDelegate = self;
    
}

-(void)suggestText:(SSuggestText *)suggestText tagSelected:(SSuggestTag *)tag
{
    NSLog(@"tagSelected: %@", tag);
}


-(void)suggestText:(SSuggestText *)suggestText tagDeleted:(SSuggestTag *)tag
{
    NSLog(@"tagDeleted: %@", tag);
}

-(void)suggestText:(SSuggestText *)suggestText newTagList:(NSArray *)tagList
{
    NSLog(@"newTagList: %@", tagList);
}

-(void)suggestTextClearAllTags:(SSuggestText *)suggestText
{
    NSLog(@"clearAll");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
