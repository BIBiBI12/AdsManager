//
//  IMBidResponse.h
//  UnifiedSDK
//
//  Created by Albert Zhu on 4/18/19.
//  Copyright © 2019 InMobi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMBidResponse : NSObject

@property (nonatomic, strong) NSString* placement;
@property (nonatomic, strong) NSString* buyer;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, strong) NSString* keyword;
@property (nonatomic, strong) NSString* higherGranularityKeyword;

- (instancetype)initWithPlacement:(NSString*)plc andTransaction:(NSDictionary*)transactionInfo;
- (void)populateKeywordsFrom:(NSString*)bidKey;
- (NSString*)keywordPrice;
- (NSString*)higherGranularityKeywordPrice;

@end

NS_ASSUME_NONNULL_END
