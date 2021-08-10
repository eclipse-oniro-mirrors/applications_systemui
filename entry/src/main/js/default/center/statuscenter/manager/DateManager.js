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

/**
 * Manage methods related to time.
 */
export default class DateManager {

    /**
     * Obtain current date and time.
     *
     * @param {Object} callback - Callback function.
     */
    getCurrentDate(callback) {
        let result = {};
        let date = new Date();
        let month = this.getMonth(date);
        let day = this.getDay(date);
        let time = date.toTimeString().substring(0, 5);
        let weekDay = this.getWeekDay(date);
        result.time = time;
        result.date = {};
        result.date.month = month;
        result.date.day = day;
        result.date.weekDay = weekDay;
        callback(JSON.stringify(result));
    }

    /**
     * Obtain Month.
     *
     * @param {Object} date - Object of Date.
     * @return {string} The month of date.
     */
    getMonth(date) {
        let month = (date.getMonth() + 1).toString();
        if (month.length === SHORT_LENGTH) {
            month = '0' + month;
        }
        return month;
    }

    /**
     * Obtain Day.
     *
     * @param {Object} date - Object of Date.
     * @return {string} The day of date.
     */
    getDay(date) {
        let day = (date.getDate()).toString();
        if (day.length === SHORT_LENGTH) {
            day = '0' + day;
        }
        return day;
    }

    /**
     * Obtain WeekDay.
     *
     * @param {Object} date - Object of Date.
     * @return {string} The weekday of date.
     */
    getWeekDay(date) {
        let weekDay = date.getDay();
        return weekDay;
    }
}