//
//  SentenceViewController.h
//  Foraging
//
//  Created by Thomas Deegan on 4/9/13.
//
//

#import <UIKit/UIKit.h>
#import "DisplayAndRecordVC.h"
#import "MemoryVC.h"

@protocol ProcessDataDelegate1 <NSObject>	//---comm
- (void)logIt:(NSString *)stringToLog;		//---comm
- (NSString *)getTag;						//---comm
- (int)getDelayLow:(int)setNum;				//---comm
- (int)getDelayHigh:(int)setNum;			//---comm
- (int)getFontSize;							//---comm
- (int)getInputMode;						//---comm
- (int)getTlogInputMode;					//---comm
- (int)getTotalWait;						//---comm
- (int)getNextSet:(int)setNum;
@end	//---comm
@interface SentenceViewController : UIViewController
{
    NSMutableArray *buttons;
    NSInteger numberOfButtons;
    NSInteger setNumber;//0 practice 1 RI 2 CT
    NSInteger sentenceNumber;
    
    NSInteger cumulativeDelay;
    NSInteger totalTime;
    
    UILabel *totalTimeLabel;
    
    DisplayAndRecordVC *drvc;
	DisplayAndRecordVC *drvcTlog;
	MemoryVC *mvc;
    
    NSArray *sentencesArray;
    NSMutableArray *sentencesDone;
    NSMutableArray *sentenceToButtonIndecies;
    
    BOOL doneWithAllButtons;
    
    
    id <ProcessDataDelegate1> delegate;
    
    IBOutlet UINavigationBar * navBar;
	IBOutlet UINavigationItem * backButton;
    

}
-(void)setUpButtons;
-(IBAction)backPressed:(id)sender;

@property (retain) id <ProcessDataDelegate1> delegate;


@end
