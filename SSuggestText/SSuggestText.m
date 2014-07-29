//
//  SSuggestText.m
//  SSuggestText
//
//  Created by Saulo G Tauil on 23/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "SSuggestText.h"

@interface SSuggestText()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (readonly,nonatomic) UITableViewController* controller;
@property (nonatomic) UIPopoverController* poc;

@end

@implementation SSuggestText

@synthesize controller = _controller;



- (void)matchStrings:(NSString *)letters {
    if ([self.dataSource count] > 0) {
        /*
        self.matchedStrings = [_stringsArray
                               filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:@"self contains[cd] %@", letters]];
        */
        [self.controller.tableView reloadData];
    }
}

- (void)showPopOverList {
    
    if (NO){// _matchedStrings.count == 0) {
        [_poc dismissPopoverAnimated:YES];
    } else if (!_poc.isPopoverVisible) {
        [_poc presentPopoverFromRect:self.frame
                                  inView:self.superview
                permittedArrowDirections:UIPopoverArrowDirectionUp
                                animated:YES];
    }
}


#pragma mark - getter n setters

-(UITableViewController *)controller
{
    if (_controller == nil)
    {
        _controller = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        _controller.tableView.delegate = self;
        _controller.tableView.dataSource = self;
    }
    return _controller;
}

#pragma mark - setup

-(void) setup{

    self.delegate = self;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.poc =
    [[UIPopoverController alloc] initWithContentViewController:self.controller];
}

#pragma mark - initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


#pragma mark - tableview datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;//] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.dataSource textAtIndexPath: indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.dataSource count]);

}

#pragma mark - textfielddelegate
//
//- (BOOL)shouldChangeTextInRange:(UITextRange *)range
//                replacementText:(NSString *)text {
//    return YES;
//}
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    
    [self matchStrings:text];
    [self showPopOverList];
    
    return YES;
}

@end
