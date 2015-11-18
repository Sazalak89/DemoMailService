#import "WSFrameWork.h"
#import "MailInfoWSConstant.h"

@implementation WSFrameWork

@synthesize sDomainName;
@synthesize sURL;
@synthesize sVersion;
@synthesize isSync;
@synthesize dicParams;
@synthesize arrParams;
@synthesize WSType;
@synthesize WSDatatype;
@synthesize beforeSend;
@synthesize onSuccess;
@synthesize onArrSuccess;
@synthesize onError;
@synthesize onComplete;
@synthesize iTimeOutInterval;
@synthesize dicFilesParams;
@synthesize isLogging;
@synthesize dicFilesParamsName;
@synthesize sContentType;

#pragma mark - init Methods
-(id)init{
	[self setUp];
	return [super init];
}
-(id)initWithURLAndParams:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams{
	self.sURL=_sURL;
	self.dicParams=_dicParams;
	return [self init];
}
-(id)initWithURLAndParams:(NSString *)_sURL arrParams:(NSMutableArray *)_arrParams{
	self.sURL=_sURL;
	self.arrParams=_arrParams;
	return [self init];
}
-(id)initWithURLParamsAndFiles:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams dicFilesParams:(NSDictionary *)_dicFilesParams dicFilesParamsName:(NSDictionary *)_dicFilesParamsName{
	self.sURL=_sURL;
	self.dicParams=_dicParams;
	self.dicFilesParams=_dicFilesParams;
	self.dicFilesParamsName=_dicFilesParamsName;
	return [self init];
}
#pragma mark - Send/Handle Request
/*!
 @method send
 @abstract To send Request to server
 */
-(void)send{
	self.beforeSend();

	NSString * sUrl = [NSString stringWithFormat:@"%@%@",self.sDomainName, self.sURL]; //Conconate Domain name asn WS url
    
    if (self.sVersion) {
        NSMutableDictionary *dicMutableParams=[[NSMutableDictionary alloc] initWithDictionary:self.dicParams];
       // [dicMutableParams setValue:sVersion forKey:@"version"];
        self.dicParams=dicMutableParams;
    }
    
    //Generate Http request with Post data
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:self.iTimeOutInterval];
	if(self.WSType == kPOST){
		if(isLogging){
			NSLog(@"WS URL :::: %@",sUrl);
		}
		[request setURL:[NSURL URLWithString:sUrl]];
		[request setHTTPMethod:@"POST"];
		NSString *sBoundary = @"---------------------------14737809831466499882746641449";
		
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",sBoundary];
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
		
		//Set boby to request
		NSMutableData *body = [NSMutableData data];
		if([[self.dicParams allKeys] count]>0){
			for(NSString * sParam in [self.dicParams allKeys])
			{
				[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];   
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",sParam, [self.dicParams valueForKey:sParam]] dataUsingEncoding:NSUTF8StringEncoding]]; 
			}
		}
		
		if(self.dicFilesParams != nil && [[self.dicFilesParams allKeys] count]>0){
			for (NSString *sParams in [self.dicFilesParams allKeys]) {
				[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
				
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"%@\"\r\n",sParams, [self.dicFilesParamsName	objectForKey:sParams]] dataUsingEncoding:NSUTF8StringEncoding]];
				
				[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",self.sContentType] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[NSData dataWithData:[self.dicFilesParams	objectForKey:sParams]]];
				[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		 
		//Setting the body of the post to the reqeust
		[request setHTTPBody:body];
		
	}else {
		NSMutableString *sParams = [NSMutableString string];
		// Generating Query string from Parameters Dic
		for (NSString* key in [dicParams allKeys]){
			if ([sParams length]>0)
				[sParams appendString:@"&"];
			[sParams appendFormat:@"%@=%@", key, [dicParams objectForKey:key]];
		}
		
		//sUrl = [NSString stringWithFormat:@"%@?%@",sUrl,sParams];
		
		if(isLogging){
			NSLog(@"WS URL :::: %@",sUrl);
		}
		[request setURL:[NSURL URLWithString:sUrl]];
		[request setHTTPMethod:@"GET"];
	}
	
	//Send requsest to server and retrieve response
	if (isSync) {
		if (self.isLogging) {
			NSLog(@"WSType :::: Scyn Request Sent");
		}

		NSURLResponse *responce = nil;
		NSData *dataReturn;
		NSError *errConnection = nil;
		
		dataReturn = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&errConnection];
		
		[self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
		
	}else {
		if (self.isLogging) {
			NSLog(@"WSType :::: Ascyn Request Sent");
		}
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *dataReturn, NSError *errConnection) {
			[self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
		}];
	}
}

/*!
 @method getResponceForPath
 @abstract To get Responce for path given path should be separate with "/" e.g. [wsObj getResponceForPath:dic path:@"root/info/id/text"]
 */
-(NSDictionary *)getResponceForPath:(NSDictionary *)dicResponce path:(NSString *)path{
	NSArray *arrPath = [path componentsSeparatedByString:@"/"];
	NSDictionary *dicReturn=dicResponce;
	for (NSString *pathComponent in arrPath) {
		@try {
			if([dicReturn objectForKey:pathComponent]!=nil && [dicReturn count]>0){
				dicReturn=[dicReturn objectForKey:pathComponent];
			}else {
				NSLog(@"Key not found :::: %@",pathComponent);
			}
		}
		@catch (NSException * e) {
			NSLog(@"Key not found :::: %@",pathComponent);
		}
	}
	return dicReturn;
}

#pragma mark - Private Methods
-(void)setUp{
	self.WSType = kPOST;
	self.WSDatatype = kJSON;
	self.isSync = FALSE;
    self.sDomainName = WS_DOMAIN;
	self.beforeSend = ^{};
	self.onComplete = ^{};
	self.onSuccess = ^(NSDictionary	*dicResponce){};
	self.onArrSuccess = ^(NSMutableArray	*arrResponce){};
	self.onError = ^(NSError *err){
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//		[errAlert show];
//		[errAlert release];
	//	HIDE_AI;
	};
	self.iTimeOutInterval = 180;
	self.isLogging=FALSE;
	self.sContentType = @"application/octet-stream";
    
    self.sVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
}
/*!
 @method convertResponce
 @abstract To convert Responce String from Specifide Format JSON/XML to NSDictionary
 */
-(NSDictionary *)convertResponce:(NSString *)sResponce{
	NSDictionary *dicResponce=nil;
	switch (self.WSDatatype) {
		case kJSON:
			dicResponce=[self convertResponceJSON:sResponce];
			break;
		case kXML:
			dicResponce=[self convertResponceXML:sResponce];
			break;
		default:
			break;
	}
	return dicResponce;
}


/*!
 @method convertArrResponce
 @abstract To convert Responce String from Specifide Format JSON/XML to NSMutableArray
 */
-(NSMutableArray *)convertArrResponce:(NSString *)sResponce{
	NSMutableArray *arrResponce=nil;
	switch (self.WSDatatype) {
		case kJSON:
			arrResponce=[self convertArrResponceJSON:sResponce];
			break;
		case kXML:
			arrResponce=[self convertArrResponceXML:sResponce];
			break;
		default:
			break;
	}
	return arrResponce;
}



/*!
 @method convertResponceJSON
 @abstract To convert Responce String from Specifide Format JSON to NSDictionary
 */
-(NSDictionary *)convertResponceJSON:(NSString *)sResponce{
	SBJSON *jsonParser = [[SBJSON alloc]init];
	NSDictionary *receivedData = [jsonParser objectWithString:sResponce error:nil];
	[jsonParser release];
	return receivedData;
}
/*!
 @method convertResponceJSON
 @abstract To convert Responce String from Specifide Format JSON to NSMutableArray
 */
-(NSMutableArray *)convertArrResponceJSON:(NSString *)sResponce{
	SBJSON *jsonParser = [[SBJSON alloc]init];
	NSMutableArray *receivedData = [jsonParser objectWithString:sResponce error:nil];
	[jsonParser release];
	return receivedData;
}


/*!
 @method convertResponceXML
 @abstract To convert Responce String from Specifide Format XML to NSDictionary
 */
-(NSDictionary *)convertResponceXML:(NSString *)sResponce{
	NSError *errXMLParsing = nil;
	NSDictionary *dicResponce = [XMLReader dictionaryForXMLString:sResponce error:&errXMLParsing];
	if(errXMLParsing != nil){
		if (self.isLogging) {
			NSLog(@"Error :::: %@ Error Code :::: %i",[errXMLParsing localizedDescription],[errXMLParsing code]);
		}
		return nil;
	}
	return dicResponce;
}

/*!
 @method convertArrResponceXML
 @abstract To convert Responce String from Specifide Format XML to NSMutableArray
 */
-(NSMutableArray *)convertArrResponceXML:(NSString *)sResponce{
	NSError *errXMLParsing = nil;
	NSDictionary *dicResponce = [XMLReader dictionaryForXMLString:sResponce error:&errXMLParsing];
	NSMutableArray *arrResponce = [[NSMutableArray alloc] initWithArray:[[dicResponce valueForKey:@"id"] valueForKey:@"name"]];
	if(errXMLParsing != nil){
		if (self.isLogging) {
			NSLog(@"Error :::: %@ Error Code :::: %i",[errXMLParsing localizedDescription],[errXMLParsing code]);
		}
		return nil;
	}
	return arrResponce;
}


/*!
 @method handleResponce
 @abstract To handle responce
 */
-(void)handleResponce:(NSURLResponse *)responce dataReturn:(NSData *)dataReturn errConnection:(NSError *)errConnection{
	if(errConnection != nil){
		if (self.isLogging) {
			NSLog(@"Error :::: %@ Error Code :::: %i",[errConnection localizedDescription],[errConnection code]);
		}
		self.onError(errConnection);
	}else {
		NSString *sResponce = [[NSString alloc] initWithData:dataReturn encoding:NSUTF8StringEncoding];
		if (self.isLogging) {
			NSLog(@"Response Received :::: %@",sResponce);
		}
		
	if(self.WSType == kPOST){
		NSDictionary *dicResponce = [self convertResponce:sResponce];
		self.onSuccess(dicResponce);
		[sResponce release];
		self.onComplete();
	}
	else if(self.WSType == kGET){
		NSMutableArray *arrResponce = [self convertArrResponce:sResponce];
		self.onArrSuccess(arrResponce);
		[sResponce release];
		self.onComplete();
	}
	}
}
- (void)dealloc
{
	[self.onComplete release];
	[self.onSuccess release];
	[self.onError release];
	[self.beforeSend release];
	[super dealloc];
}
@end
