//
//  DateTimeUtils.swift
//  SwiftUtils
//
//  Created by Thanh Nguyen on 8/15/16.
//  Copyright © 2016 Thanh Nguyen. All rights reserved.
//----------------------------------------------------------------------
//  Useful DateTime utilities.
//----------------------------------------------------------------------

import Foundation

public class DateTimeUtils {
    /**
     * Gets the current UNIX timestamp in milliseconds as a UInt64.
     * 
     * - Returns: the current UNIX timestamp in milliseconds
     */
    @available(iOS, introduced: 1.0)
    public static func currentUnixTimestampMillisec() -> UInt64 {
        return UInt64(NSDate().timeIntervalSince1970 * 1000)
    }

    /**
     * Gets the current UNIX timestamp in seconds as a UInt64.
     *
     * - Returns: the current UNIX timestamp in seconds
     */
    @available(iOS, introduced: 1.0)
    public static func currentUnixTimestampSecond() -> UInt64 {
        return UInt64(NSDate().timeIntervalSince1970)
    }

    /**
     * Waits until clock moves to the next millisecond.
     *
     * - Parameter currentMillisec: the current timestamp in milliseconds
     *
     * - Returns: the "next" millisecond
     */
    @available(iOS, introduced: 1.0)
    @discardableResult public static func waitTillNextMillisec(_ currentMillisec: UInt64) -> UInt64 {
        var nextMillisec = currentUnixTimestampMillisec()
        while ( nextMillisec <= currentMillisec ) {
            nextMillisec = currentUnixTimestampMillisec()
        }
        return nextMillisec
    }

    /**
     * Waits until clock moves to the next second.
     *
     * - Parameter currentMillisec: the current timestamp in seconds
     *
     * - Returns: the "next" second
     */
    @available(iOS, introduced: 1.0)
    @discardableResult public static func waitTillNextSecond(_ currentSecond: UInt64) -> UInt64 {
        var nextSecond = currentUnixTimestampSecond()
        while ( nextSecond <= currentSecond ) {
            nextSecond = currentUnixTimestampSecond()
        }
        return nextSecond
    }

    @available(iOS, introduced: 1.1)
    static private let FULL_DATE_COMPONENTS: Set<Calendar.Component> = [Calendar.Component.era,
                                Calendar.Component.year,
                                Calendar.Component.month,
                                Calendar.Component.day,
                                Calendar.Component.hour,
                                Calendar.Component.minute,
                                Calendar.Component.second,
                                Calendar.Component.nanosecond,
                                Calendar.Component.weekday,
                                Calendar.Component.weekdayOrdinal,
                                Calendar.Component.weekOfMonth,
                                Calendar.Component.weekOfYear,
                                Calendar.Component.quarter,
                                Calendar.Component.yearForWeekOfYear,
                                Calendar.Component.calendar,
                                Calendar.Component.timeZone]

    /**
     * Resets to start of the second of (nanosecond is set to 0) a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the second of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfSecond(_ date: Date) -> Date {
        var comps = Calendar.current.dateComponents(FULL_DATE_COMPONENTS, from: date)
        comps.setValue(0, for: Calendar.Component.nanosecond)
        return Calendar.current.date(from: comps)!
    }

    /**
     * Resets to start of the minute (second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the minute of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfMinute(_ date: Date) -> Date {
        let d = startOfSecond(date)
        var comps = Calendar.current.dateComponents(FULL_DATE_COMPONENTS, from: d)
        comps.setValue(0, for: Calendar.Component.second)
        return Calendar.current.date(from: comps)!
    }

    /**
     * Resets to start of the hour (minute, second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the hour of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfHour(_ date: Date) -> Date {
        let d = startOfMinute(date)
        var comps = Calendar.current.dateComponents(FULL_DATE_COMPONENTS, from: d)
        comps.setValue(0, for: Calendar.Component.minute)
        return Calendar.current.date(from: comps)!
    }

    /**
     * Resets to start of the day (hour, minute, second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the day of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfDay(_ date: Date) -> Date {
        let d = startOfHour(date)
        var comps = NSCalendar.current.dateComponents(FULL_DATE_COMPONENTS, from: d)
        comps.setValue(0, for: Calendar.Component.hour)
        return NSCalendar.current.date(from: comps)!
    }

    /**
     * Alias of startOfDay()
     */
    @available(iOS, introduced: 1.1)
    public static func startOfDate(_ date: Date) -> Date {
        return startOfDay(date)
    }

    /**
     * Resets to start of the month (day is set to 1; hour, minute, second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the month of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfMonth(_ date: Date) -> Date {
        let d = startOfDay(date)
        var comps = NSCalendar.current.dateComponents(FULL_DATE_COMPONENTS, from: d)
        comps.setValue(1, for: Calendar.Component.day)
        return NSCalendar.current.date(from: comps)!
    }

    /**
     * Resets to start of the year (month and day is set to 1s; hour, minute, second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the year of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfYear(_ date: Date) -> Date {
        let d = startOfMonth(date)
        var comps = NSCalendar.current.dateComponents(FULL_DATE_COMPONENTS, from: d)
        comps.setValue(1, for: Calendar.Component.month)
        return NSCalendar.current.date(from: comps)!
    }


    /**
     * Resets to start of the week (day is set to 'first week day'; hour, minute, second and nanosecond are set to 0s) of a Date object.
     *
     * - Parameter date: the input Date object
     *
     * - Returns: start of the week of the input Date object
     */
    @available(iOS, introduced: 1.1)
    public static func startOfWeek(_ date: Date) -> Date {
        let CAL = NSCalendar.current
        var result = startOfDate(date)
        var weekday = CAL.component(Calendar.Component.weekday, from: result)
        while ( weekday != CAL.firstWeekday ) {
            result = CAL.date(byAdding: Calendar.Component.weekday, value: -1, to: result)!
            weekday = CAL.component(Calendar.Component.weekday, from: result)
        }
        return result
    }
}
