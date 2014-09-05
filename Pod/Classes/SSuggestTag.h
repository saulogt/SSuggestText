//
//  SSuggestTag.h
//  Pods
//
//  Created by Saulo G Tauil on 19/08/14.
//
//

#import <Foundation/Foundation.h>

@interface SSuggestTag : NSObject

@property (nonatomic) NSString *tagId;
@property (nonatomic) NSString *tagDesc;


+(SSuggestTag*) tagDataWithDictionary: (NSDictionary*) tagDic;
+(SSuggestTag*) tagDataWithDesc: (NSString*) tagDesc AndId: (NSString*) tagId;



@end

