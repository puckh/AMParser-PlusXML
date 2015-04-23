//
//  XRRun.m
//  AMParser
//
//  Created by Zhou, Yuan on 1/10/14.
//  Copyright (c) 2014 Zhou, Yuan. All rights reserved.
//

#import "XRRun.h"
#import "MyProcess.h"
#import "MyTimestamp.h"

#define targetProcess @"DoorReader"

@implementation XRRun 
    

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        startTime = [[decoder decodeObject] doubleValue];
        endTime   = [[decoder decodeObject] doubleValue];
        runNumber = [[decoder decodeObject] unsignedIntegerValue];

        trackSegments = [decoder decodeObject];
        
        // Totally not sure about these
        envVals = [[decoder decodeObject] boolValue];
        execname = [[decoder decodeObject] boolValue];
        terminateTaskAtStop = [[decoder decodeObject] boolValue];
        pid = [decoder decodeObject][@"_pid"];
        launchControlProperties = [[decoder decodeObject] boolValue];
        args = [[decoder decodeObject] boolValue];
    }
    return self;
}

- (void)dealloc
{
}


@end

@implementation XRActivityInstrumentRun


- (NSString *)formattedSample:(NSUInteger)index
{
    NSDictionary *data = sampleData[index];
    NSMutableString *result = [NSMutableString string];
    double relativeTimestamp = [data[@"XRActivityClientTraceRelativeTimestamp"] doubleValue];
    double seconds = relativeTimestamp / 1000.0 / 1000.0 / 1000.0;
    NSTimeInterval timestamp = startTime + seconds;
    [result appendFormat:@"Process: %@ ", targetProcess];
    
    NSArray *processData = data[@"Processes"];
    
    
    
//    NSLog(@"outer");
//    
//    NSArray* nameArr = [NSArray arrayWithObjects: @"pid1", @"cpu1", nil];
//    NSArray* nameArr2 = [NSArray arrayWithObjects: @"pid1", @"cpu1", nil];
    
    //NSString *a1 = @"aa";
    //NSString *a2 = @"bb";
    //NSString *a3 = @"cc";
    
    //NSMutableArray *theArray = [NSMutableArray arrayWithObjects:nil];
//    
//    [theArray addObject:nameArr];
//    [theArray addObject:nameArr2];
    
    //[self incrementCounter:@"root":@"child"];
    //[self incrementCounter:theArray];

    MyProcess *someProcess;
    
    for (NSDictionary *process in processData) {
        
        
            double myPID = [process[@"PID"] doubleValue];
            NSString *strPID = [NSString stringWithFormat: @"%f", myPID];
            
            double myCPUUsage = [process[@"CPUUsage"] doubleValue];
            NSString *strCPUUsage = [NSString stringWithFormat: @"%f", myCPUUsage];
        
            NSString *strCommand = process[@"Command"];
       
        
            someProcess = [[MyProcess alloc] init];
            someProcess.pid = strPID;
            someProcess.cpu = strCPUUsage;
            someProcess.pname = strCommand;
        
            [timeArray addObject:someProcess];
        
        int countthis2 = [timeArray count];
        //NSLog(@"tmep array tot: %i", countthis2);
        
            //>>     NSArray* pidDataArray = [NSArray arrayWithObjects: @"pid1", @"cpu1", nil];
            
            //>>    [theArray addObject:pidDataArray];
            
            //        if ([process[@"Command"] isEqualToString:targetProcess]) {
            //            double cpuUsage = [process[@"CPUUsage"] doubleValue];
            //            double residentSize = [process[@"ResidentSize"] doubleValue] / 1024;
            //            double virtualSize = [process[@"VirtualSize"] doubleValue] / 1024;
            //            [result appendFormat:@"CPU Usage: %.2f%% ", cpuUsage];
            //            [result appendFormat:@"Res Size: %.2f KiB ", residentSize];
            //            [result appendFormat:@"Virt Size: %.2f KiB ", virtualSize];
            //            break;
            //        }
        
    }
    
    
     //NSString *intervalString = [NSString stringWithFormat:@"%f", timestamp];
    
     MyTimestamp *someMyTimestamp;
    
    someMyTimestamp = [[MyTimestamp alloc] init];
    someMyTimestamp.timeArray = timeArray;
    someMyTimestamp.timestamp = [NSString stringWithFormat:@"%.0f", timestamp*1000];;
    

    [completeArray addObject:someMyTimestamp];
    
    //clearing timeArray
    timeArray = [NSMutableArray arrayWithObjects:nil];
    
    
    //int countthis2 = [completeArray count];
    //NSLog(@"complete array total: %i", countthis2);
    
    
    //>>[completeArray addObject:[NSMutableArray arrayWithArray:theArray]];
    
    [result appendFormat:@"Timestamp: %@ ", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]]];
   
    
    //NSLog(@"BBBBBBB:%@",intervalString);
    //>>return result;
    return @"";
}

//======================

//- (void)incrementCounter:   (NSString *)pid : (NSString *)cpuUsage
- (void)incrementCounter:   (NSMutableArray *)theArray
{
    NSXMLDocument   *xmlDoc;
    NSError         *error;
    NSURL           *url;
    NSXMLElement    *root;
    id              item;
    NSData          *data;
    NSArray         *children;
    int             counter;
    NSString        *pathname;
    
    int countthis = [theArray count];
    
    NSLog(@"this count: %i", countthis);
    
    for (id obj in theArray) {
    
        NSArray* nameArr = obj;
        NSString *first = [nameArr objectAtIndex:0];
        NSString *second = [nameArr objectAtIndex:1];
        
        NSLog(@" :::::::::::::::: first:%@", first);
        NSLog(@" :::::::::::::::: second:%@", second);

        
    }
    
    pathname = [@"~/theData.xml" stringByExpandingTildeInPath];
    url = [NSURL fileURLWithPath:pathname];
    
    xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:&error];
    if(xmlDoc)
    {
        root = [xmlDoc rootElement];
    }
    else
    {
        root = [NSXMLNode elementWithName:@"root"];
        xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    }
    
    // fetch value:
    children = [root nodesForXPath:@"counter" error:&error];
    item = [children count] ? [children objectAtIndex:0] : NULL;
    
    // modify value:
    counter = item ? [[item stringValue] intValue] : 0;
    counter++;
    if(NULL == item)
    {
        item = [NSXMLNode elementWithName:@"counter" stringValue:@"0"];
        [root insertChild:item atIndex:0];
    }
    [item setStringValue:[[NSNumber numberWithInt:counter] stringValue]];
    
    // write:
    data = [xmlDoc XMLData];
    [data writeToURL:url atomically:YES];
}

//======================
- (NSString *)description
{
    NSString *start = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
    NSString *end = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
    NSMutableString *result = [NSMutableString stringWithFormat:@"Run %u, starting at %@, running until %@\n", (unsigned int)runNumber, start, end];
    
    //>>theArray = [NSMutableArray arrayWithObjects:nil];
    timeArray = [NSMutableArray arrayWithObjects:nil];
    completeArray = [NSMutableArray arrayWithObjects:nil];
    
    for(NSUInteger i=0; i<[sampleData count]; i++)
    {
        //[result appendFormat:@"Sample %u: %@\n", (unsigned int)i, [self formattedSample:i]];
        [self formattedSample:i];
    }
    //=============
    
    NSLog(@"TIME TIME:%@",startTimestamp);
    
    //int countthis1 = [timeArray count];
    //NSLog(@"the array total: %i", countthis1);
    
    int arrayCount = [completeArray count];
    //NSLog(@"complete array total: %i", arrayCount);
    
 
    
    //NSLog(@"start:%Lf",startTime);
    
    long double difference = endTime - startTime;
    //NSLog(@"difference:%Lf",difference);
    //201878
    long double split = difference / (arrayCount);
    //NSLog(@"split:%Lf",split);
    
  
    
    //Create xml string
    NSMutableString *xmlString = [[NSMutableString alloc] init];
    
    //Add all the data to the string
    float timestampCounter = 1;

    
    [xmlString appendFormat:@"\n<instrument>"];
    
    
    for (id listObj in completeArray) {
    
        long double currentTime;
        
        MyTimestamp *someTimestamp = (MyTimestamp *)listObj;
        
        
        
        
  
     //>>       currentTime = startTime + (split * timestampCounter);
          //  NSLog(@"%Lf + %Lf = %Lf",startTime,(split * timestampCounter), currentTime);

     //>>      NSLog([NSString stringWithFormat:@"%.0Lf",currentTime]);
     //>>      NSString *strCurrentTime = [NSString stringWithFormat:@"%.0Lf",currentTime];
          //  NSLog(@"===");
     //>>       timestampCounter++;
        
        
        
        NSMutableArray *outerObj = (NSMutableArray *)someTimestamp.timeArray;
        [xmlString appendFormat:@"\n<slice time ='%@'>",someTimestamp.timestamp];
        
        
    
        for (id innerObj in outerObj)
        {
            MyProcess *someProcess = (MyProcess *)innerObj;
           
           //[xmlString appendFormat:@"\n\t<process pid='%@'>", someProcess.pid];
           [xmlString appendFormat:@"\n\t<process>"];
           [xmlString appendFormat:@"\n\t\t<processId>%@</processId>", someProcess.pid];
           [xmlString appendFormat:@"\n\t\t<processName>%@</processName>", someProcess.pname];
           [xmlString appendFormat:@"\n\t\t<cpuUsage>%@</cpuUsage>", someProcess.cpu];
           [xmlString appendFormat:@"\n\t</process>"];
           
        
           //[xmlString appendFormat:@"</someTime>"];
        }
        [xmlString appendFormat:@"\n</slice>"];
    }
    
    [xmlString appendFormat:@"\n</instrument>"];
    
    //Create a variable to represent the filepath of the outputted file
    //This is taken from some code which saves to an iPhone app's documents directory, it might not be ideal
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"instrument.xml"];
    NSLog(@"path:%@", finalPath);
    
    //Actually write the information
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:finalPath contents:data attributes:nil];
    
    //============
    return result;
}



- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder]))
    {
        sampleData = [decoder decodeObject];
        [decoder decodeObject];
    }
    return self;
}

- (void)dealloc
{
}

@end
