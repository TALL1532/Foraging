//
//  LoggingSingleton.m
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13.
//
// This class will be used a way of tracking subject testing as well as outputing the correct data files.


#import "LoggingSingleton.h"
#import "SettingsManager.h"
#import "ExpInterfaceVC.h"

@implementation LoggingSingleton

+(LoggingSingleton *)sharedSingleton {
    static dispatch_once_t pred;
    static LoggingSingleton *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[LoggingSingleton alloc] init];
    });
    return sharedInstance;
}


- (void)storeTrialDataWithsentenceNumber:(NSInteger)sentenceNumber readingTime:(NSTimeInterval)readingTime delay:(NSInteger)delay{
    NSInteger difficultyCode = sentenceNumber /7 + 1;
    NSString* nextLine = [NSString stringWithFormat:@"%@,%d,%f,%d,%d \n", self.currentLocation , sentenceNumber + 1, readingTime, delay, difficultyCode];
    
    NSLog(@"%@",nextLine);
    if (self.stringWriteBuffer == NULL) {
        self.stringWriteBuffer = @"";
    }
    self.stringWriteBuffer = [self.stringWriteBuffer stringByAppendingString:nextLine];
}

-(void)writeBufferToFile{
    NSLog(@"writing buffer to file: %@ \n",self.stringWriteBuffer);
    [self writeToEndOfFile:self.stringWriteBuffer withFilename:[NSString stringWithFormat:@"%@_record.csv",[LoggingSingleton getSubjectName]] ];
    self.stringWriteBuffer = @"";
}
- (void)writeToEndOfFile:(NSString*)string withFilename:(NSString*)filename{
    if(string == nil || [string length] == 0) return;
    // NSFileHandle won't create the file for us, so we need to check to make sure it exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],filename];
    NSLog(@"%@",path);
    if (![fileManager fileExistsAtPath:path]) {
        
        // the file doesn't exist yet, so we can just write out the text using the
        // NSString convenience method
        
        NSError *error = nil;
        BOOL success = [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            // handle the error
            NSLog(@"%@", error);
        }
    }
    else {
        
        // the file already exists, so we should append the text to the end
        
        // get a handle to the file
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        // move to the end of the file
        [fileHandle seekToEndOfFile];
        
        // convert the string to an NSData object
        NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        // write the data to the end of the file
        [fileHandle writeData:textData];
        
        // clean up
        [fileHandle closeFile];
    }
}
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//This number is reset when the subject is reset in the Admin Screen

+ (NSString*)getSubjectName{
    [SettingsManager syncronize];
    return (NSString*)[SettingsManager getObjectWithKey:SUBJECT_NAME orWriteAndReturn:@"default_subject"];
}
@end
