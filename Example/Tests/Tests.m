//
//  SSuggestTextTests.m
//  SSuggestTextTests
//
//  Created by saulogt on 08/17/2014.
//  Copyright (c) 2014 saulogt. All rights reserved.
//

#import <Expecta.h>
#import <Specta.h>
#import <SSuggestText.h>

#import "STViewController.h"
#import "PhotoScreenViewController.h"


SpecBegin(InitialSpecs)



describe(@"STViewController", ^{

    __block PhotoScreenViewController *_vc;
    
    beforeEach(^{
        UIWindow* window = [[UIApplication sharedApplication].delegate window];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        _vc = [mainStoryboard instantiateInitialViewController];
        
        UIView *view = _vc.view;
        expect(view).toNot.beNil();
        
        [window setRootViewController:_vc];
    });
    
    it(@"will check if vc exists", ^{
        
        expect(_vc).toNot.beNil();
        expect(_vc.view).toNot.beNil();
        
    });
    
    it(@"will send keys and check value", ^{
        
        SSuggestText* suggestText = _vc.tag1;
        
        expect(suggestText).toNot.beNil();
        /*
        id<UITextViewDelegate> delegate = suggestText.delegate;
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"a"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"b"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"c"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"d"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"e"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"f"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"g"];
        [delegate textView: suggestText shouldChangeTextInRange: NSMakeRange(0,0) replacementText: @"h"];
        */
        //expect(0).toNot.beGreaterThanOrEqualTo(0);

    });

//    it(@"can read", ^{
//        expect(@"number").to.equal(@"string");
//    });
    
//    it(@"will wait and fail", ^AsyncBlock {
//        
//    });
});

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^AsyncBlock {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            done();
        });
    });
    
});

SpecEnd
