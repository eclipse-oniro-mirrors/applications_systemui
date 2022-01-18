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


import AccountManager from '@ohos.account.osAccount';
import Log from './Log.ets';

const STORAGE_KEY = 'SwitchUserManager_AppStorage'
const TAG = 'SwitchUserManager'
const SUBSCRIBE_KEY = 'SystemUiAccount'
const USER_CHANGE_EVENT = 'activate'
const INVALID_USER_ID = -1;

interface UserChangeListener {
  userChange: Function
}

export class UserInfo {
  userId: number = INVALID_USER_ID;
  userName: string = '';
  userIcon: string | Resource = '';
  [key: string]: any ;
}

async function getCurrentAccountInfo() {
  let currentAccountInfo = {};
  let accountInfos = await AccountManager.getAccountManager().queryAllCreatedOsAccounts();
  for (let accountInfo of accountInfos) {
    Log.showInfo(TAG, `accountInfo: ${accountInfo.localId}, isActive: ${accountInfo.isActived}`);
    if (accountInfo.isActived) {
      return accountInfo;
    }
  }
  return new UserInfo();
}

function parseAccountInfo(accountInfo): UserInfo {
  return {
    userId: accountInfo.localId,
    userName: accountInfo.localName,
    userIcon: accountInfo.photo
  }
}

export default class SwitchUserManager {
  mUserInfo: UserInfo = new UserInfo();
  mListeners = new Set<UserChangeListener>();

  static getInstance(): SwitchUserManager {
    if (!AppStorage.Has(STORAGE_KEY)) {
      let mamanger = new SwitchUserManager();
      AppStorage.SetOrCreate(STORAGE_KEY, mamanger);
    }
    return AppStorage.Get(STORAGE_KEY);
  }

  constructor() {
    Log.showInfo(TAG, `SwitchUserManager constructor`);
    AccountManager.getAccountManager().on(USER_CHANGE_EVENT, SUBSCRIBE_KEY, this.handleUserChange.bind(this));
  }

  public async getCurrentUserInfo(): Promise<UserInfo> {
    if (this.mUserInfo.userId == INVALID_USER_ID) {
      let accountInfo = await getCurrentAccountInfo();
      this.mUserInfo = parseAccountInfo(accountInfo);
    }
    return this.mUserInfo;
  }

  public registerListener(listener: UserChangeListener) {
    this.mListeners.add(listener)
  }

  public unregisterListener(listener: UserChangeListener) {
    this.mListeners.delete(listener)
  }

  handleUserChange(accountId) {
    AccountManager.getAccountManager().queryOsAccountById(accountId).then((accountInfo) => {
      Log.showInfo(TAG, `userChange, accountInfo: ${JSON.stringify(accountInfo)}`);
      this.mUserInfo = parseAccountInfo(accountInfo)
      this.notifyUserChange();
    })
  }

  notifyUserChange() {
    this.mListeners.forEach((listener) => listener.userChange(this.mUserInfo))
  }
}