//
//  SSuggestTag.m
//  Pods
//
//  Created by Saulo G Tauil on 19/08/14.
//
//

#import "SSuggestTag.h"

@implementation SSuggestTag

+(SSuggestTag *)tagDataWithDictionary:(NSDictionary *)tagDic
{
    NSAssert([tagDic isKindOfClass:[NSDictionary class]], @"tagdic must be a disctionary");
    
    NSString* tagDesc = [tagDic objectForKey: @"desc"];
    NSString* tagId = [tagDic objectForKey:@"id"];
    
    NSAssert(tagId && tagDesc, @"could not create tag");
    
    if (tagId && tagDesc)
    {
        SSuggestTag* ret = [[SSuggestTag alloc] init];
        ret.tagDesc = tagDesc;
        ret.tagId = tagId;
        
        return ret;
    }
    
    return nil;
}


+(SSuggestTag*) tagDataWithDesc: (NSString*) tagDesc AndId: (NSString*) tagId
{

    SSuggestTag* ret = [[SSuggestTag alloc] init];
    ret.tagDesc = tagDesc;
    ret.tagId = tagId;
    
    return ret;

}

@end
