//
//  ForagingLoggingSingleton.m
//  Foraging
//
//  Created by Thomas Deegan on 5/7/13.
//
//

#import "ForagingLoggingSingleton.h"

@implementation ForagingLoggingSingleton

+ (ForagingLoggingSingleton *)sharedSingleton
{
    return (ForagingLoggingSingleton*)[super sharedSingleton];
}
- (void)storeTrialDataWithLocation:(NSString*)location sentenceNumber:(NSInteger)sentenceNumber diffCode:(NSInteger)diffCode{
    
    NSString* nextLine = [NSString stringWithFormat:@"%@,%d,%@,%@,%d \n",location, sentenceNumber, self.readTime, self.lastDelayTime, diffCode];
    NSLog(@"%@",nextLine);
    self.stringWriteBuffer = [self.stringWriteBuffer stringByAppendingString:nextLine];
}

@end
