/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const SHORT_LENGTH = 1;
const MARK_MONDAY = 1;
const MARK_TUESDAY = 2;
const MARK_WEDNESDAY = 3;
const MARK_THURSDAY = 4;
const MARK_FRIDAY = 5;
const MARK_SATURDAY = 6;
const MARK_SUNDAY = 0;

/**
 * Manage methods related to time.
 */
export default class DateManager {

    /**
     * Get current date and time.
     *
     * @return {string} current date and time.
     */
    getCurrentDate() {
        let result = {};
        let date = new Date();
        let month = this.getMonth(date);
        let day = this.getDay(date);
        let time = date.toTimeString().substring(0, 5);
        let weekDay = this.getWeekDay(date);
        result.time = time;
        result.date = month + globalThis.$globalT('strings.month') + day + globalThis.$globalT('strings.day') + weekDay;
        return JSON.stringify(result);
    }

    /**
     * Get Month.
     *
     * @param {object} date - Object of Date.
     * @return {string} The month of date.
     */
    getMonth(date) {
        let month = (date.getMonth() + 1).toString();
        if (month.length == SHORT_LENGTH) {
            month = "0" + month;
        }
        return month;
    }

    /**
     * Get Day.
     *
     * @param {object} date - Object of Date.
     * @return {string} The day of date.
     */
    getDay(date) {
        let day = (date.getDate()).toString();
        if (day.length == SHORT_LENGTH) {
            day = "0" + day;
        }
        return day;
    }

    /**
     * Get WeekDay.
     *
     * @param {object} date - Object of Date.
     * @return {string} The weekday of date.
     */
    getWeekDay(date) {
        let weekDay = date.getDay();
        switch (weekDay) {
            case MARK_MONDAY:
                weekDay = globalThis.$globalT('strings.monday');
                break;
            case MARK_TUESDAY:
                weekDay = globalThis.$globalT('strings.tuesday');
                break;
            case MARK_WEDNESDAY:
                weekDay = globalThis.$globalT('strings.wednesday');
                break;
            case MARK_THURSDAY:
                weekDay = globalThis.$globalT('strings.thursday');
                break;
            case MARK_FRIDAY:
                weekDay = globalThis.$globalT('strings.friday');
                break;
            case MARK_SATURDAY:
                weekDay = globalThis.$globalT('strings.saturday');
                break;
            case MARK_SUNDAY:
                weekDay = globalThis.$globalT('strings.sunday');
                break;
            default:
                break;
        }
        return weekDay
    }
}