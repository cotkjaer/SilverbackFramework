//
//  EKEventStore.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 25/08/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation
import EventKit

public extension EKEventStore
{
    //MARK: Access
    
    private func asyncDoWhenAccessIsGrantedToEntityType(
        entityType: EKEntityType,
        completionHandler: () -> (),
        errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler
        )
    {
        requestAccessToEntityType(entityType, completion: { (granted, error) -> () in
            
            if granted
            {
                // Ensure that call-back is done on main queue
                dispatch_async(dispatch_get_main_queue(),
                    {
                        completionHandler()
                })
            }
            else
            {
                // Ensure that call-back is done on main queue
                dispatch_async(dispatch_get_main_queue(),
                    {
                        if let theError = error
                        {
                            errorHandler?(theError)
                        }
                        else
                        {
                            errorHandler?(NSError(domain: "EKEventStore", code: 1234, description: "Permission was not granted for \(entityType)"))
                        }
                })
            }
        })
    }
    
    //MARK: Calendars
    
    public func fetchCalendarsForEntityType(entityType: EKEntityType, completionHandler: ([EKCalendar]) -> (), errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        asyncDoWhenAccessIsGrantedToEntityType(entityType,
            completionHandler: {
                completionHandler(self.calendarsForEntityType(entityType))
            })
            { (error) -> () in
                errorHandler?(NSError(domain: "EKEventStore", code: 1235, description: "Could not fetch calendars for EntityType \(entityType)", reason: "Access Denied", underlyingError: error))
        }
    }
    
    public func fetchEventCalendars(completionHandler: ([EKCalendar]) -> (), errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        fetchCalendarsForEntityType(EKEntityType.Event, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    public func fetchReminderCalendars(completionHandler: ([EKCalendar]) -> (), errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        fetchCalendarsForEntityType(EKEntityType.Reminder, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    //MARK: - Events
    
    //MARK: Fetch
    
    public func doFetchEventsInCalendar(eventCalendar: EKCalendar, firstDate: NSDate?, lastDate: NSDate?) -> [EKEvent]?
    {
        let from = firstDate ?? NSDate() - 1.year
        
        let to = lastDate ?? NSDate() + 3.year
        
        let calendars = [eventCalendar]
        
        let predicate = predicateForEventsWithStartDate(from, endDate: to, calendars: calendars)
        
        return eventsMatchingPredicate(predicate)
    }
    
    public func asyncFetchEventsInCalendar(calendar: EKCalendar, firstDate: NSDate?, lastDate: NSDate?,  completionHandler: ((events: [EKEvent]) -> ())? = nil,
        errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        asyncDoWhenAccessIsGrantedToEntityType(EKEntityType.Event,
            completionHandler:
            {
                if let events = self.doFetchEventsInCalendar(calendar, firstDate: firstDate, lastDate: lastDate)
                {
                    completionHandler?(events: events)
                }
                else
                {
                    completionHandler?(events: [])
                }
            },
            errorHandler: { (error) -> () in
                errorHandler?(NSError(domain: "EKEventStore", code: 1236, description: "Could not fetch events in calendar \(calendar)", reason: "Access Denied", underlyingError: error)) })
    }
    
    //MARK: Create
    public func asyncCreateAllDayEventInCalendar(
        calendar: EKCalendar,
        title: String,
        availability: EKEventAvailability = .Free,
        date: NSDate,
        notes: String,
        completionHandler: ((event: EKEvent) -> ())? = nil,
        errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        asyncCreateEventInCalendar(calendar, title: title, availability: availability, allDay: true, startDate: date, endDate: date, notes: notes, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    public func createEventInCalendar(
        calendar: EKCalendar,
        title: String,
        availability: EKEventAvailability = .Free,
        allDay: Bool,
        startDate: NSDate,
        endDate: NSDate,
        notes: String) -> EKEvent
    {
        let event = EKEvent(eventStore: self)
        event.title = title
        event.availability = availability
        event.allDay = allDay
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.calendar = calendar
        event.alarms = nil
        
        return event
    }
    
    public func asyncCreateEventInCalendar(
        calendar: EKCalendar,
        title: String,
        availability: EKEventAvailability = .Free,
        allDay: Bool,
        startDate: NSDate,
        endDate: NSDate,
        notes: String,
        completionHandler: ((event: EKEvent) -> ())? = nil,
        errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        let event =  createEventInCalendar(calendar, title: title, availability: availability, allDay: allDay, startDate: startDate, endDate: endDate, notes: notes)
        
        do
        {
            try saveEvent(event, span: .ThisEvent)
            
            completionHandler?(event: event)
        }
        catch let e as NSError
        {
            errorHandler?(e)
        }
    }
    
    //MARK: Remove
    
    public func asyncRemoveEventWithIdentifier(eventIdentifier: String, completionHandler: ((removed: Bool) -> ()) = { (removed) -> () in }, errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        asyncDoWhenAccessIsGrantedToEntityType(EKEntityType.Event,
            completionHandler: {
                if let event = self.eventWithIdentifier(eventIdentifier)
                {
                    do
                    {
                        try self.removeEvent(event, span: .FutureEvents, commit: true)
                        completionHandler(removed: true)
                    }
                    catch let error as NSError
                    {
                        errorHandler?(NSError(domain: "Event Kit", code: 1201, description: "Could not remove event \(event.title) in calendar \(event.calendar.title)", underlyingError: error))
                        
                        completionHandler(removed: false)
                    }
                    catch
                    {
                        errorHandler?(NSError(domain: "Event Kit", code: 1201, description: "Could not remove event \(event.title) in calendar \(event.calendar.title)"))
                        completionHandler(removed: false)
                    }
                }
            }, errorHandler: errorHandler)
    }
    
    //MARK: Save
    
    public func asyncSaveEvent(event: EKEvent,
        completionHandler: ((saved: Bool) -> ()) = { (removed) -> () in },
        errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler
        )
    {
        asyncDoWhenAccessIsGrantedToEntityType(.Event,
            completionHandler:
            {
                do
                {
                    try self.saveEvent(event, span: .FutureEvents, commit: true)
                    
                    completionHandler(saved: true)
                }
                catch let e as NSError
                {
                    errorHandler?(NSError(domain: "Event Kit", code: 1201, description: "Could not save event \(event.title) in calendar \(event.calendar.title)", underlyingError: e))
                    
                    completionHandler(saved: false)
                }
                catch
                {
                    errorHandler?(NSError(domain: "Event Kit", code: 1201, description: "Could not save event \(event.title) in calendar \(event.calendar.title)"))
                    completionHandler(saved: false)
                }
                
            }, errorHandler: errorHandler)
    }
    
    //MARK: Alarms
    
    public func asyncRemoveAllAlarmsFromEvent(event: EKEvent, completionHandler: ((saved: Bool) -> ()) = { _ in }, errorHandler:((NSError) -> ())? = NSError.defaultAsyncErrorHandler)
    {
        if let alarms = event.alarms
        {
            debugPrint("removing \(alarms.count) alarms")
            
            for alarm in alarms
            {
                event.removeAlarm(alarm)
                debugPrint("removed alarm: \(alarm)")
            }
            
            self.asyncSaveEvent(event, completionHandler: completionHandler, errorHandler: errorHandler)
        }
        else
        {
            completionHandler(saved: false)
        }
    }
    
}

extension EKCalendarType: CustomDebugStringConvertible
{
    public var debugDescription : String
        {
            switch self
            {
            case .Local: return "Local"
            case .CalDAV: return "CalDAV"
            case .Exchange: return "Exchange"
            case .Birthday: return "Birthday"
            case .Subscription: return "Subscription"
            }
    }
}

//extension EKCalendarType : Equatable { }
//
//public func == (lhs: EKCalendarType, rhs: EKCalendarType) -> Bool
//{
//    return lhs.rawValue == rhs.rawValue
//}
