//
//  STViewController.m
//  SSuggestText
//
//  Created by saulogt on 08/17/2014.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import "STViewController.h"
#include <SSuggestText/SSuggestText.h>


@interface STViewController ()<SSuggestDatasource>

@property (weak, nonatomic) IBOutlet SSuggestText *suggestText;

@property (nonatomic) NSArray* val;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.suggestText.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)countInSuggestText:(SSuggestText *)suggestText
{
    return self.val.count;
}

-(NSString *)suggestText:(SSuggestText *)suggestText textAtIndexPath:(NSIndexPath *)indexPath
{
    return self.val[indexPath.row];
}

-(NSArray *)val
{
    if (_val == nil)
    {
        _val = @[@"acdf", @"erdfc", @"abcde", @"zzxse", @"ewsd"];
    }
    return _val;
}


@end
