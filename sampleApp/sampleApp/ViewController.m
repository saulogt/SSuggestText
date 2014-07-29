//
//  ViewController.m
//  sampleApp
//
//  Created by Saulo G Tauil on 23/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "ViewController.h"
#import "../../SSuggestText/SSuggestText.h"

@interface ViewController ()<SSuggestDatasource>

@property (weak, nonatomic) IBOutlet SSuggestText *suggestTest;

@property (nonatomic) NSArray* val;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    id test = [[SSuggestText alloc]init];
    NSLog(@"%@", [[test class] description] );
    // Do any additional setup after loading the view, typically from a nib.
    self.suggestTest.dataSource = self;
    
   //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)count
{
    return self.val.count;
}

-(NSString *)textAtIndexPath:(NSIndexPath *)indexPath
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
