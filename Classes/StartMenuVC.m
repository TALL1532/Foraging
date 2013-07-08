    //
//  StartMenuVC.m
//  SentenceForaging
//
//  Created by Andrew Battles on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartMenuVC.h"


@implementation StartMenuVC

@synthesize delegate;												//---comm

- (IBAction)startButtonPressed:(id)sender {
    
	[self logIt:@"----- START pressed"];
	
	int recordingDelayLow = [[self delegate] getDelayLow:setNumber];
	int recordingDelayHigh = [[self delegate] getDelayHigh:setNumber];
	
	if(recordingDelayLow == recordingDelayHigh) {
		[self logIt:[NSString stringWithFormat:@"----- Sentence delay fixed at %d seconds",recordingDelayLow]];
	}
	else {
		[self logIt:[NSString stringWithFormat:@"----- Sentence delay random between %d and %d seconds",
					 recordingDelayLow,recordingDelayHigh]];
	}
	
	//initialize sentence grid
	sgvc = [[SentenceViewController alloc] init];
	
	[sgvc setDelegate:self];										//---comm
	[self presentViewController:sgvc animated:NO completion:nil];
	//[self.navigationController pushViewController:sgvc animated:NO];
	
}

- (void)setSetNumber:(int)setNum { //called by ExpInterfaceVC
	setNumber = setNum;
	NSLog(@"setNumber: %d",setNumber);
	
	NSString *instructionsPath;
	NSString *instructions;
    instructions = @"done.";
    if(setNum == 0){
        instructionsPath = [[NSBundle mainBundle] pathForResource:@"instructions" ofType:@"txt"];
        instructions = [NSString stringWithContentsOfFile:instructionsPath
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    }else if(setNum == 1){
        instructions = @"Next set: Connecticut";

    }else if(setNum == 2){
        instructions = @"Next set: Rhode Island";

    }
	
	int fontSize;
	if (setNum == 4) {
		fontSize = 72;
		[startButton setEnabled:NO];
		[startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	}
	else {
		[startButton setEnabled:YES];
		fontSize = [[self delegate] getFontSize];
		[startButton setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0]
						  forState:UIControlStateNormal];
		[self logIt:[NSString stringWithFormat:@"----- Font size: %d",fontSize]];
		
	}
	
	//set the text
	instructionView.text = instructions;
	
	//set the size of the font in the instruction view
	instructionView.font = [UIFont systemFontOfSize:fontSize];
	
	
}



//////////// LOG FUNCTIONS /////////////////////////////////////////////////

- (void) logIt:(NSString *)whatToLog {
	
	[[self delegate] logIt:whatToLog];
	
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
}  


//////////// DELEGATE FUNCTIONS /////////////////////////////////////////////

- (int)getSetNum {
	return setNumber;
}

- (int)getOrder {
	return CTfirstOrder;
}

- (int)getInputMode {
	int mode = [[self delegate] getInputMode];
	return mode;
}

- (int)getTlogInputMode {
	int mode = [[self delegate] getTlogInputMode];
	return mode;
}
	

- (NSString *)getTag {
	NSString *tag = [[self delegate] getTag];
	return tag;
}

- (int)getDelayLow:(int)setNum {
	int delay = [[self delegate] getDelayLow:setNumber];
	NSLog(@"delayLow for set %d: %d",setNumber,delay);
	return delay;
}

- (int)getDelayHigh:(int)setNum {
	int delay = [[self delegate] getDelayHigh:setNumber];
	NSLog(@"delayHigh for set %d: %d",setNumber,delay);
	return delay;
}

- (int)getFontSize {
	int fontSize = [[self delegate] getFontSize];
	return fontSize;
}

- (int)getTotalWait {
	return [[self delegate] getTotalWait];
}
- (int)getNextSet:(int)setNum {
    return [delegate getNextSet:setNum];
}

//////////// SPECIAL FUNCTIONS /////////////////////////////////////////////


- (void)puzzleInterrupted {
	//NSLog(@"puzzleInterrupted SMVC");
	
	//pass the interruption down the chain
	//[self logIt:@"----- Program closed"];
	[self puzzleEnded];
	//[sgvc puzzleInterrupted];
}

- (void)puzzleEnded {
	//NSLog(@"puzzle ended SMVC");
	//[sgvc puzzleQuit];
	[sgvc release];
	NSLog(@"sgvc released");
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //NSLog(@"ViewDidLoad SMVC");
	
	self.navigationItem.title = @"Start Menu";
	
	[self logIt:@"----- Start Menu appeared"];
	
	[super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow portrait only
    return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"MEMORY WARN STARTMENUVC");
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"StartMenuVC: dealloc");
    [super dealloc];
}


@end
