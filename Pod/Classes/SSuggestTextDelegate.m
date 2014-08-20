//
//  SSuggestTextDelegate.m
//  Pods
//
//  Created by Saulo G Tauil on 20/08/14.
//
//

#import "SSuggestTextDelegate.h"
#import "SSuggestText.h"

@implementation SSuggestTextDelegate



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSAssert([textView isKindOfClass:[SSuggestText class]], @"textView is invalid");
    return [(SSuggestText*)textView shouldChangeTextInRange:range replacementText:text];
}

//text changed
- (void)textViewDidChange:(UITextView *)textView
{
    NSAssert([textView isKindOfClass:[SSuggestText class]], @"textView is invalid");
    [(SSuggestText*)textView textViewDidChange:textView];
}


@end
