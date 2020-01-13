

#import "OPReachability.h"
#include <netinet/in.h>
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@implementation OPReachability

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.

	@autoreleasepool {
        
        OPReachability* noteObject = (__bridge OPReachability*) info;
        [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
    }
}



+ (OPReachability*) createReachabilityForInternetConnection
{

	OPReachability *reachObj= [OPReachability sharedManager] ;
	if(reachObj){
		if(reachObj->startedNotifier==NO)
			[reachObj startNotifer];
	}
	return reachObj; 

}

-(id)init{
	
	if(self = [super init])
	{
		
		struct sockaddr_in zeroAddress;
		bzero(&zeroAddress, sizeof(zeroAddress));
		zeroAddress.sin_len = sizeof(zeroAddress);
		zeroAddress.sin_family = AF_INET;
		SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&zeroAddress);
		self->reachabilityRef = reachability;
		
	}
			
	return self;
}


//Single ton ////
static OPReachability *sharedSingleton = nil;
+ (id)sharedManager
{
	@synchronized(self){
		if (sharedSingleton == nil) {
			sharedSingleton = [[super allocWithZone:NULL] init];
		}
	}
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


////////


-(BOOL)startNotifer{
	BOOL retVal = NO;
	SCNetworkReachabilityContext context = {0, (__bridge void*) self, NULL, NULL};
	
//Assigns a client to a target, which receives callbacks
//	when the reachability of the target changes.
	if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)){
		
//		Schedules the specified network target with the specified run loop and mode,so that it continuously checks for the reachability
		if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			retVal = YES;
			self->startedNotifier=YES;
		}
	}
	return retVal;
}

- (void) stopNotifer
{
	if(reachabilityRef!= NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		self->startedNotifier=NO;
	}
}

- (NetworkStatus) currentReachabilityStatus{
	NetworkStatus retVal = NotReachable;
	SCNetworkReachabilityFlags flags;
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
	{
#ifdef DEBUG	
	//	debugLog(@"reachable %d %d %d",flags , kSCNetworkReachabilityFlagsConnectionRequired, kSCNetworkReachabilityFlagsReachable);
#endif		
		if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0 && (flags & kSCNetworkReachabilityFlagsReachable)) {
			retVal = Reachable;
		}
		else {
			retVal = NotReachable;
		}
	}
	return retVal;
}

- (NetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{    
	BOOL retVal = NotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = ReachableViaWiFi;
	}
	return retVal;
}

- (void) dealloc
{
	[self stopNotifer];
	if(reachabilityRef!= NULL)
	{
		CFRelease(reachabilityRef);
	}
}

@end
