    //
//  ViewLog.m
//  Span Task
//
//  Created by Andrew Battles on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewLog.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@implementation ViewLog

@synthesize delegate;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"names"] autorelease];
    cell.textLabel.text = [users objectAtIndex:[indexPath indexAtPosition:1]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [users count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath indexAtPosition:1];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentEmail:[users objectAtIndex:index]];
        [users release];
    }];
    
}

- (IBAction)emailLogPressed:(id)sender {
    NSString *directory = [self getDocumentsDirectory];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    users = [[NSMutableArray alloc] init];
    for(int i = 0; i < [files count]; i++){
        if ([files[i] rangeOfString:@"-log.txt"].location != NSNotFound) {
            [users addObject:[files[i] substringToIndex:[files[i] rangeOfString:@"-log.txt"].location]];
        }
    }
    UITableViewController * tableView = [[[UITableViewController alloc] init] autorelease];
    tableView.modalPresentationStyle = UIModalPresentationFormSheet;
    tableView.tableView.dataSource = self;
    tableView.tableView.delegate = self;
    [self presentViewController:tableView animated:NO completion:nil];
    
}
-(void)presentEmail:(NSString *)subject{
    
	NSLog(@"Sending email");
	expTag = subject;
	
	
    NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
		
	//NSString *audioPath = [directory stringByAppendingString:@"/audio1.caf"];
	
	//Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	// Set subject line
	[picker setSubject:@"Adult Learning Lab iPad Log File"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"AdultLearningLab.ipad@gmail.com"]; 
	[picker setToRecipients:toRecipients];
	
	// Attach log to the email
	NSData *myData = [NSData dataWithContentsOfFile:filePath];
	[picker addAttachmentData:myData mimeType:@"text/plain" fileName:logFileName];
	
	
	int i;
	NSData *audioData;
	NSString *audioName;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	if(![fileManager fileExistsAtPath:filePath]) {
		NSLog(@"Sound file does not exist. Creating...");
	}
    
	// Attach PRAC audio data to email
	for (i=1; i<4; i++) {
		audioName = [NSString stringWithFormat:@"%@-PR-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
        if([fileManager fileExistsAtPath:filePath]) {
            [picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
        }
	}
	
	// Attach CT audio data to email
	for (i=1; i<22; i++) {
		audioName = [NSString stringWithFormat:@"%@-CT-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
        if([fileManager fileExistsAtPath:filePath]) {
            [picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
        }
	}
	
	// Attach RI audio data to email
	for (i=1; i<22; i++) {
		audioName = [NSString stringWithFormat:@"%@-RI-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
        if([fileManager fileExistsAtPath:filePath]) {
            [picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
        }
	}
	
	
	
	// Fill out the email body text
	NSString *emailBody = @"Log file attached.";
	[picker setMessageBody:emailBody isHTML:NO];
	if (picker != nil) {
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}

    filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@_record.csv",expTag]];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if([fileManager fileExistsAtPath:filePath]) {
        [picker addAttachmentData:data mimeType:@"csv" fileName:@"record.csv"];
}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Compose cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Compose saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Compose sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Compose failed");
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clearLogPressed:(id)sender {
	
	
	UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete all subject data?!?!" 
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
											   otherButtonTitles:@"Clear Log",nil]; 
	
	[checkAlert show];
	[checkAlert release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        //NSLog(@"cancel");
    }
    else if (buttonIndex == 1)
    {
        NSString *directory = [self getDocumentsDirectory];
        NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
        for(int i = 0; i < [files count]; i++){
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory,files[i]];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
		[self displayLogContents];
    }
}

- (void)backToMenuPressed {
	
	NSLog(@"BACK TO MENU Pressed");
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:NO];
	//[self release];
	[[self delegate] endLog];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Log";
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											  initWithTitle:@"Back To Menu" 
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(backToMenuPressed)] autorelease];
	
	[self displayLogContents];
    [super viewDidLoad];
}

- (void)displayLogContents {
	
	expTag = [[self delegate] getTag];
	tagView.text = expTag;
	
	
	NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
	
	NSLog(@"filePath: %@",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if(![fileManager fileExistsAtPath:filePath]) {
		logView.text = @"Log Deleted";
	}
	
	else {
		NSLog(@"Displaying log file");
		NSString *textFromFile = [NSString stringWithContentsOfFile:filePath
														   encoding:NSUTF8StringEncoding 
															  error:nil];
		logView.text = textFromFile; 
	}
	[fileManager release];
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	//NSLog(@"%@",[paths objectAtIndex:0]);
	
	return [paths objectAtIndex:0];  
}  


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"MEMORY WARN VIEWLOG");
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	NSLog(@"View to unload");
	[self.navigationController popViewControllerAnimated:NO];
	NSLog(@"popped");
	[self release];
	NSLog(@"released");
    [super viewDidUnload];
	NSLog(@"unloaded");
		
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"ViewLog: Dealloc");
	//[expTag release];
	
    [super dealloc];
}



@end
