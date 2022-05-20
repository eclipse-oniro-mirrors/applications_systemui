/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

const TAG = "SystemUI_Default";
const FILTER_KEYS = [
    new RegExp('hide', "gi")
]

export function filterKey(target: any, propKey: string, descriptor: PropertyDescriptor) {
    const original = descriptor.value;
    descriptor.value = function (...args: string[]) {
        let filterResult = args.map((str) => {
            let tempStr = str
            FILTER_KEYS.forEach((filterKey) => tempStr = tempStr.replace(filterKey, "**"))
            return tempStr
        });
        const result = original.call(this, ...filterResult);
        return result;
    };
}

/**
 * Basic log class
 */
export default class Log {
    /**
     * print info level log
     *
     * @param {string} tag - Page or class tag
     * @param {string} log - Log needs to be printed
     */
    static showInfo(tag: string, log: string) {
        console.info(`${TAG} tag: ${tag} --> ${log}`);
    }

    /**
     * print debug level log
     *
     * @param {string} tag - Page or class tag
     * @param {string} log - Log needs to be printed
     */
    static showDebug(tag: string, log: string) {
        console.debug(`${TAG} tag: ${tag} --> ${log}`);
    }

    /**
     * print error level log
     *
     * @param {string} tag - Page or class tag
     * @param {string} log - Log needs to be printed
     */
    static showError(tag: string, log: string) {
        console.error(`${TAG} tag: ${tag} --> ${log}`);
    }
}
