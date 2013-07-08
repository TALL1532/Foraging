//
//  ForagingLoggingSingleton.h
//  Foraging
//
//  Created by Thomas Deegan on 5/7/13.
//
//

#import <Foundation/Foundation.h>
#import "LoggingSingleton.h"

@interface ForagingLoggingSingleton : LoggingSingleton



+ (ForagingLoggingSingleton *)sharedSingleton;
- (void)storeTrialDataWithLocation:(NSString*)location sentenceNumber:(NSInteger)sentenceNumber diffCode:(NSInteger)diffCode;

@end
