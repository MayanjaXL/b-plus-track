//
//  MXLDataRetriever+JSON.m
//  B+Track
//
//  Created by Fitti Weissglas on 17/06/2014.
//  Copyright (c) 2014 MXL. All rights reserved.
//

#import "MXLJson.h"
#import "MXLSession.h"
#import "mxlAppDelegate.h"
#import "MXLDataRetriever.h"
#import "MXLKPIs.h"
#import "mxlEntity.h"
#import "NSString+Encode.h"
#import "MXLWeek.h"
#import "mxlFacility.h"
#import "MXLWeeklyReport.h"

@interface MXLDataRetriever(JSon)
+ (NSMutableArray*) jsonGetEntities:(NSString*)level;

@end

@implementation MXLJson

NSString * const urlGetEntities2 = @"http://meta-beta.net/services/BPlusWS/getEntities?level=%@&response=application/json";
NSString * const urlGetWeeks2 = @"http://meta-beta.net/services/BPlusWS/getWeeks?max=%i&response=application/json";
NSString * const urlGetKPIs2 = @"http://meta-beta.net/services/BPlusWS/getKPI?entity=%@&weekno=%@&response=application/json";
NSString * const urlGetFacilities2 = @"http://meta-beta.net/services/BPlusWS/getFacilities?entity=%@&response=application/json";
NSString * const urlGetFacilitiesReported2 = @"http://meta-beta.net/services/BPlusWS/getFRStatus?entity=%@&weekno=%@&reported=%@&response=application/json";
NSString * const urlGetStockOut = @"http://meta-beta.net/services/BPlusWS/getReports?entity=%@&weekno=%@&option=stockouts&response=application/json";
NSString * const urlGetWeeklyReports = @"http://meta-beta.net/services/BPlusWS/getReports?entity=%@&weekno=%@&option=reports&response=application/json";



/*NSString * const urlGetEntities = @"http://192.168.1.196:8080/axis2/services/BPlusWS/getEntities?level=%@&response=application/json";
 NSString * const urlGetWeeks = @"http://192.168.1.196:8080/axis2/services/BPlusWS/getWeeks?max=%i&response=application/json";
 NSString * const urlGetKPIs = @"http://192.168.1.196:8080/axis2/services/BPlusWS/getKPI?entity=%@&weekno=%@&response=application/json";*/


#pragma mark JSon Data Retrieval

/* jsonGetEntities
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) jsonGetEntities:(NSString*)level {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetEntities2, level];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonEntities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSMutableArray* entities = [NSMutableArray new];
    for(NSDictionary *item in jsonEntities) {
        [entities addObject: ([[MXLEntity alloc] initWithName:[item objectForKey:@"entity"] type:level level:level])];
    }
    
    return entities;
}

/* jsonGetWeeksWithMax
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) jsonGetWeeksWithMax:(int)max {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetWeeks2, max];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonWeeks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSMutableArray* weeks = [NSMutableArray new];
    for(NSDictionary *item in jsonWeeks) {
        [weeks addObject:[[MXLWeek alloc] initWithWeekNo:[item objectForKey:@"weekno"]
                                               startDate:[item objectForKey:@"startdate"]
                                                 endDate:[item objectForKey:@"enddate"]]];
    }
    return weeks;
}

/* jsonGetKPIsForEntity
 _____________________________________________________________________________________________________________________________ */

+ (MXLKPIs*) jsonGetKPIsForEntity:(NSString*) entity weekno:(NSString*) weekno {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetKPIs2, [entity encodeString:NSUTF8StringEncoding], [weekno encodeString:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonWeeks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    MXLKPIs* kpis = [MXLKPIs new];
    kpis.lastRefreshed = [NSDate date];
    
    for(NSDictionary *item in jsonWeeks) {
        [kpis setKPIsWithDictionary:item];
    }
    return kpis;
}

/* jsonGetFaciltiessForEntity
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) jsonGetFaciltiessForEntity:(NSString*) entity weekno:(NSString*) weekno requestType:(FacilityRequestType) requestType  {
    
    NSString* requestURL;
    
    switch (requestType) {
        case AllFacilities: {
            requestURL = [NSString stringWithFormat:urlGetFacilities2, [entity encodeString:NSUTF8StringEncoding]];
            break;
        }
        case NotReported: {
            requestURL = [NSString stringWithFormat:urlGetFacilitiesReported2, [entity encodeString:NSUTF8StringEncoding], weekno, @"0"];
            break;
        }
        case Reported: {
            requestURL = [NSString stringWithFormat:urlGetFacilitiesReported2, [entity encodeString:NSUTF8StringEncoding], weekno, @"1"];
            break;
        }
        case ARVStockout: {
            requestURL = [NSString stringWithFormat:urlGetFacilitiesReported2, [entity encodeString:NSUTF8StringEncoding], weekno, @"1"];
            break;
        }
        case TestkitStockout: {
            requestURL = [NSString stringWithFormat:urlGetFacilitiesReported2, [entity encodeString:NSUTF8StringEncoding], weekno, @"1"];
            break;
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonFacilities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSMutableArray* facilities = [NSMutableArray new];
    for(NSDictionary *item in jsonFacilities) {
        MXLFacility* facility = [MXLFacility new];
        [facility setValuesForKeysWithDictionary:item];
        [facilities addObject:facility];
    }
    
    return facilities;
}

/* jsonGetStockOutsForEntity
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) jsonGetStockOutsForEntity:(NSString*) entity weekno:(NSString*) weekno {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetStockOut, [entity encodeString:NSUTF8StringEncoding], [weekno encodeString:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonWeeklyReports = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    MXLKPIs* kpis = [MXLKPIs new];
    kpis.lastRefreshed = [NSDate date];
    
    NSMutableArray* reports = [NSMutableArray new];
    for(NSDictionary *item in jsonWeeklyReports) {
        MXLWeeklyReport* report = [MXLWeeklyReport new];
        [report setValuesForKeysWithDictionary:item];
        [reports addObject:report];
    }
    
    return reports;
}

/* jsonGetWeeklyReportsForEntity
 _____________________________________________________________________________________________________________________________ */

+ (NSMutableArray*) jsonGetWeeklyReportsForEntity:(NSString*) entity weekno:(NSString*) weekno {
    
    NSString* requestURL = [NSString stringWithFormat:urlGetWeeklyReports, [entity encodeString:NSUTF8StringEncoding], [weekno encodeString:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&jsonParsingError];
    NSString* returnString2 = [json objectForKey:@"return"];
    NSData *data = [returnString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonWeeklyReports = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    MXLKPIs* kpis = [MXLKPIs new];
    kpis.lastRefreshed = [NSDate date];
    
    NSMutableArray* reports = [NSMutableArray new];
    for(NSDictionary *item in jsonWeeklyReports) {
        MXLWeeklyReport* report = [MXLWeeklyReport new];
        [report setValuesForKeysWithDictionary:item];
        [reports addObject:report];
    }
    
    return reports;
}


@end