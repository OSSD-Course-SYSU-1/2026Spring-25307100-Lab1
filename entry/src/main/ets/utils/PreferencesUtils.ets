/**
 * @author: ArmyQin
 * @date: 2024/11/15 18:09
 * @description:
 * @version:
 */
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@ohos.base';

const TAG = '[PreferencesUtils]';
const PREFERENCES_NAME = 'nutpiPreferences';

let getPreferences: Promise<preferences.Preferences>;

export class PreferencesUtils {

  createPreferences(context:Context) {
    console.info(`xx createPreferences`)
    try {
      let promise = preferences.getPreferences(context, PREFERENCES_NAME);
      getPreferences = promise;
    } catch(err) {
      console.error("xx Failed to get preferences. code =" + err.code + ", message =" + err.message);
    }
  }

  savePreferences(key: string, value: Object) {
    console.info(`xx savePreferences key: ${key} value: ${JSON.stringify(value)}`)
    getPreferences.then(async (preferences: preferences.Preferences) => {
      await preferences.put(key, value);
      preferences.flush();
    }).catch((err: BusinessError) => {
      console.error(TAG, 'xx put the preferences failed, err: ' + err);
    });
  }

  async getPreferences(key: string) {
    console.info(`xx getPreferences key: ${key}`)
    const preferences: preferences.Preferences = await getPreferences;

    let value: Object = new Object();
    await preferences.get(key, null).then((data) => {
      value = data as Object
    }).catch((err: BusinessError) => {
      console.error(TAG, `xx Failed to get the key Cause: ${JSON.stringify(err)}`);
    });
    console.info(`xx getPreferences value: ${JSON.stringify(value)}`)
    return value;
  }

  async deletePreferences(key: string) {
    console.info(`xx deletePreferences Start`)
    const preferences: preferences.Preferences = await getPreferences;
    let deleteValue = preferences.delete(key);
    deleteValue.then(() => {
      console.info(TAG, 'xx Succeeded in deleting the key.');
    }).catch((err: BusinessError) => {
      console.error(TAG, `xx Failed to delete the key. Cause: ${err}`);
    });
  }
}

export default new PreferencesUtils();