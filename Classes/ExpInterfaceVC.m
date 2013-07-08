    //
//  ExpInterfaceVC.m
//  Foraging
//
//  Created by Andrew Battles on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpInterfaceVC.h"


@implementation ExpInterfaceVC

////////

- (IBAction)pracButtonPressed:(id)sender {
    
    [self saveExpSettings];
    
	[self logIt:@"----- PRACTICE set chosen"];
	
	//push view to StartMenuVC
	[self.navigationController pushViewController:smvc animated:YES];
	
	//tell StartMenuVC which set we're going to load
	[smvc setSetNumber:1]; //CT first as default
	
	//increment the crash counter if we're doing audio recording (will crash on its own halfway through fifth trial
	if (inputMode == 2) {
		//toCrashCounter++;
	}
}

- (IBAction)connButtonPressed:(id)sender {
    
    [self saveExpSettings];

	[self logIt:@"----- CONNETICUT set chosen"];
	
	//push view to StartMenuVC
	[self.navigationController pushViewController:smvc animated:YES];
	
	//track that task flow will be: Practice, CT, RI
	CTfirst = 1;
	
	//tell StartMenuVC which set we're going to load
	[smvc setSetNumber:0];
    hasStartedCT = false;
}


- (IBAction)riButtonPressed:(id)sender {
    
    [self saveExpSettings];
    
	[self logIt:@"----- RHODE ISLAND set chosen"];
	
	//push view to StartMenuVC
	[self.navigationController pushViewController:smvc animated:YES];
	
	//track that task flow will be: Practice, RI, CT
	CTfirst = 0;
	
	//tell StartMenuVC which set we're going to load
	[smvc setSetNumber:0];
    hasStartedCT = false;
	
}

- (IBAction)fontMinusPressed:(id)sender {
    
	if(fontSize > 24) {
		fontSize = fontSize-6;
		[fontView setFont:[UIFont systemFontOfSize: fontSize]];
	}
	[self saveExpSettings];
	
}

- (IBAction)fontPlusPressed:(id)sender {
    
	if(fontSize < 72) {
		fontSize = fontSize+6;
		[fontView setFont:[UIFont systemFontOfSize: fontSize]];
	}
    [self saveExpSettings];
}

- (IBAction)textModePressed:(id)sender {
    
	inputMode = 1; //text entry
	[textModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[voiceModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	
}

- (IBAction)voiceModePressed:(id)sender {
    
	inputMode = 2; //voice recording
	[textModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[voiceModeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	
}

- (IBAction)tlogTextModePressed:(id)sender {
    
	tlogInputMode = 1; //text entry
	[tlogTextModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[tlogVoiceModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)tlogVoiceModePressed:(id)sender {
    
	tlogInputMode = 2; //voice recording
	[tlogTextModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[tlogVoiceModeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

			/////// showMath only using values from practice set 
- (void)showMath {
	int min;
	int max;
	float avgDelay;
	int remainder;
	NSString *showString;
	
	int totalWait = [self getTotalWait];
	
	int i;
	for (i = 1; i<4; i++) {
		min = [self getDelayLow:i];
		max = [self getDelayHigh:i];
	
		if (min == max) {
			avgDelay = min;
		}
		else {
			avgDelay = (max+min)/2.0;
		}
		if (i == 1) {
			remainder = 30;
		}
		else {
			remainder = totalWait - avgDelay*24;
		}
		showString = [NSString stringWithFormat:@"(play memory: %d seconds)",remainder];

		switch (i) {
			case 1:
				mathIndicator.text = showString;
				[mathIndicator setHidden:NO];
				break;
			case 2:
				mathIndicator2.text = showString;
				[mathIndicator2 setHidden:NO];
				break;
			case 3:
				mathIndicator3.text = showString;
				[mathIndicator3 setHidden:NO];
				break;
			default:
				break;
		}
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	if(textField.tag == 1) { //if the textField that was edited was the cumulative delay field
		[self showMath];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	//NSLog(@"textField shouldChangeCharactersInRange");
	
	if(textField.tag == 1) { //if the textField that was edited was the cumulative delay field
		//[self showMath];
		[self performSelector:@selector(showMath) withObject:nil afterDelay:0.01];
		
		// we have to show math after a delay of not-zero, because we have to wait until after
		// this method returns YES to the text field.
	}
	
	return YES;
	
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	//NSLog(@"textFieldShouldEndEditing");
	[self hideMathIndicators];
	[self saveExpSettings];
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	// if user touches outside of a text box, get rid of keyboard/make inactive
    [tag resignFirstResponder];
	[delay resignFirstResponder];
	[delay2 resignFirstResponder];
	[delay3 resignFirstResponder];
	[delayUpperLimit resignFirstResponder];
	[delayUpperLimit2 resignFirstResponder];
	[delayUpperLimit3 resignFirstResponder];
    [setTimeLimit resignFirstResponder];
	[puzzleWaitTime resignFirstResponder];
	[tag resignFirstResponder];
	
}
/*
- (void)delayFunction { 
	[mathIndicator setHidden:YES];
	[mathIndicator2 setHidden:YES];
	[mathIndicator3 setHidden:YES];
}*/

- (void)hideMathIndicators {
	[mathIndicator setHidden:YES];
	[mathIndicator2 setHidden:YES];
	[mathIndicator3 setHidden:YES];
	
}

//////////// DELEGATE FUNCTIONS /////////////////

- (int)getInputMode {	
	return inputMode;
}

- (int)getTlogInputMode {
	return tlogInputMode;
}

- (NSString *)getTag {
	return tag.text;
	NSLog(@"sent tag: %@",tag.text);
}

- (int)getDelayLow:(int)setNum {
	
	NSString *textVal;
	switch (setNum) {
		case 0:
			textVal = delay.text;
			break;
		case 1:
				textVal = delay2.text;
			
			break;
		case 2:
				textVal = delay3.text;

			break;
		default:
			textVal = @"0";
			break;
	}
	
	int theDelay = [textVal integerValue];
	return theDelay;
}

- (int)getDelayHigh:(int)setNum {
	NSString *textVal;
	switch (setNum) {
		case 0:
			textVal = delayUpperLimit.text;
			break;
		case 1:
				textVal = delayUpperLimit2.text;
			break;
		case 2:
			
				textVal = delayUpperLimit3.text;
			

			break;
		default:
			textVal = @"0";
			break;
	}
	int theDelay = [textVal integerValue];
	return theDelay;
}

- (int)getTotalWait {
	int theWait = [puzzleWaitTime.text integerValue];
	return theWait;
}

- (int)getFontSize {
	
	return fontSize;
	//NSLog(@"sent size: @f",fontSize);
}

- (int)getNextSet:(int)setNum{
    if(setNum == 0){
        if(CTfirst){
            hasStartedCT = YES;
            return 1;
        }
        else{
            hasStartedCT = NO;
            return 2;
        }
    }else if(setNum == 1){
        if(CTfirst){
            return 2;
        }else return 4;
    }else if(setNum == 2){
        if(CTfirst){
            return 4;
        }else return 1;
    }
}
///////// LOG FUNCTIONS /////////////////////////

- (void) logIt:(NSString *)whatToLog {
	
	NSString *expTag = [self getTag];
	NSLog(@"To-Log recieved: %@",whatToLog);
	
	NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
	//NSLog(@"filePath is: %@",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if(![fileManager fileExistsAtPath:filePath]) {
		NSLog(@"Log file does not exist. Creating...");
		[fileManager createFileAtPath:filePath contents:nil attributes:nil];
	}
	else {
		//NSLog(@"Log file already exists");
	}
	
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];  //telling fileHandle what file write to
	
	NSDateFormatter *date_formatter=[[NSDateFormatter alloc]init];
	[date_formatter setDateFormat:@"MM.dd.yyyy - HH:mm:ss.SSS "];
	
	NSString *readDate = [date_formatter stringFromDate:[NSDate date]];
	
	[fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
	
	NSString *stringToWrite = readDate;
	[fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]]; //write date
	
	stringToWrite = whatToLog;
	[fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
	
	[fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]; //add carriage return
	//[fileHandle closeFile];
	
	[fileHandle synchronizeFile]; //adding this makes sure the file is stored!
	
	[fileManager release];
	[date_formatter release];
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
}

- (void)showLogPressed {
	
	//initialize ViewLog
	viewLog = [[ViewLog alloc] initWithNibName:@"ViewLog" bundle:nil];
	[viewLog setDelegate:self];									//---comm
	
	[self.navigationController pushViewController:viewLog animated:NO];
	[viewLog displayLogContents];
}

- (void)endLog {
	[viewLog release];
}

//////// CRASH CONTROL METHODS //////////

- (IBAction)crashPressed:(id)sender {
	//[self crashProgram];  This was removed by Thomas Deegan.  I dont think there ever was an issue with the AVAudio recorder. If there was it is resolved by using the newer ios firmware
}

- (void)crashProgram {
	/********** 
	 -initializing an array with nothing in it, then trying to access an element is not allowed.
	 -this will crash the program, clearing all leaked memory.
	 -crashing the program is important because the AVAudioRecorder method leaks memory (WTF APPLE!?), so 
	 this program will crash on its own right after loading MemoryVC on the fifth trial that uses voice recording
	 **********/
	
	//first, save the front panel variables
	[self saveExpSettings];
	
	crasher = [[NSArray alloc] init];
	NSString *endOfTheWorld = [crasher objectAtIndex:10] ;
	
	//this will never get called, but accessing the "endOfTheWorld" variable gets rid of the unused variable warning
	NSLog(@"%@",endOfTheWorld); 
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	//we're using viewDidAppear to count the number of experiments that have been done
    [self voiceModePressed:nil];
	/*if (toCrashCounter > 2) {
		
		[crashButton setHidden:NO];
		
		NSString *crashMessage = [NSString stringWithFormat:@"You should manually crash the program now to avoid a crash in the middle of your fifth trial. \nCrash now?"];
		
		UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:nil message:crashMessage 
															delegate:self 
												   cancelButtonTitle:@"Cancel" 
												   otherButtonTitles:@"Crash it",nil]; 
		
		[checkAlert show];
		[checkAlert release];
	}*/
	
}



- (void)saveExpSettings {
	NSLog(@"saveExpSettings");
	
    [SettingsManager setObject:tag.text withKey:@"k_subjectName"];
    [SettingsManager setInteger:inputMode withKey:@"k_inputMode"];
    
    [SettingsManager setInteger:[delay.text integerValue] withKey:@"k_practice_delay_text"];
    [SettingsManager setInteger:[delayUpperLimit.text integerValue] withKey:@"k_practice_delay_upper_text"];
    
    [SettingsManager setInteger:[delay2.text integerValue] withKey:@"k_connecticuit_delay_text"];
    [SettingsManager setInteger:[delayUpperLimit2.text integerValue] withKey:@"k_connecticuit_delay_upper_text"];
    
    [SettingsManager setInteger:[delay3.text integerValue] withKey:@"k_ri_delay_text"];
    [SettingsManager setInteger:[delayUpperLimit3.text integerValue] withKey:@"k_ri_delay_upper_text"];
    
    
    [SettingsManager setInteger:[setTimeLimit.text integerValue] withKey:@"k_setTimeLimit"];
    [SettingsManager setInteger:[puzzleWaitTime.text integerValue] withKey:@"k_puzzleTimeLimit"];

    [SettingsManager setInteger:fontSize withKey:@"k_font_size_int"];

	[SettingsManager syncronize];
}

- (void)loadExpSettings {
	NSLog(@"loadExpSettings");

    tag.text = (NSString*)[SettingsManager getObjectWithKey:@"k_subjectName" orWriteAndReturn:@"default_subject"];
    inputMode = [SettingsManager getIntegerWithKey:@"k_inputMode" orWriteAndReturn:2];
    
    delay.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_practice_delay_text" orWriteAndReturn:0]];
    delayUpperLimit.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_practice_delay_upper_text" orWriteAndReturn:1]];
    
    delay2.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_connecticuit_delay_text" orWriteAndReturn:0]];
    delayUpperLimit2.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_connecticuit_delay_upper_text" orWriteAndReturn:1]];
    
    delay3.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_ri_delay_text" orWriteAndReturn:0]];
    delayUpperLimit3.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_ri_delay_upper_text" orWriteAndReturn:1]];
    
    setTimeLimit.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_setTimeLimit" orWriteAndReturn:360]];
    puzzleWaitTime.text = [NSString stringWithFormat:@"%d",[SettingsManager getIntegerWithKey:@"k_puzzleTimeLimit" orWriteAndReturn:30]];

    
    fontSize = [SettingsManager getIntegerWithKey:@"k_font_size_int" orWriteAndReturn:30];
    
		//set recording mode buttons
    if(inputMode == 2) {
        [textModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [voiceModeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } //else its in default, text mode highlight
		
		//set font size
    [fontView setFont:[UIFont systemFontOfSize: fontSize]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	//hide practice button, we're not using it anymore
	[pracButton setHidden:YES];
	
	self.navigationItem.title = @"Experimenter Interface";
	
	//initialize start menu
	smvc = [[StartMenuVC alloc] initWithNibName:@"StartMenuVC" bundle:nil];
	//[smvc initWithNibName:@"StartMenuVC" bundle:nil];
	
	[smvc setDelegate:self];									//---comm
	
	//put "Show Log" button in top right corner
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Show Log" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(showLogPressed)] autorelease];
	
	fontSize = 36;
	
	inputMode = 1;
	[textModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[voiceModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	
	tlogInputMode = 1;
	[tlogTextModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[tlogVoiceModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	
	[mathIndicator setHidden:YES];
	[mathIndicator2 setHidden:YES];
	[mathIndicator3 setHidden:YES];
		
	[crashButton setHidden:YES];
    
    
	
	[self loadExpSettings];
    
    hasStartedCT = NO;
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	NSLog(@"MEMORY WARN EXPINTERFACE");
	//[viewLog release];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"ExpInterfaceVC: dealloc");
	
	[smvc release];
    [super dealloc];
}




@end
