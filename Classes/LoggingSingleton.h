//
//  LoggingSingleton.h
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13.
//
//

#import <Foundation/Foundation.h>

@interface LoggingSingleton : NSObject
{}
@property (nonatomic, retain) NSString *stringWriteBuffer;
@property (nonatomic, retain) NSString *currentLocation; //for storing current state


+ (LoggingSingleton *)sharedSingleton;

- (void)storeTrialDataWithsentenceNumber:(NSInteger)sentenceNumber readingTime:(NSTimeInterval)readingTime delay:(NSInteger)delay;


- (void)writeBufferToFile;

+ (NSString*)getSubjectName;
@end
