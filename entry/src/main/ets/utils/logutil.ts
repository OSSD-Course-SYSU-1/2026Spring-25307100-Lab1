import hilog from '@ohos.hilog';

export class Log {
  static DOMAIN = 0xD002230;
  static TAG = "[zhiHuDaily]: ";

  static debug(message, ...args) {
    hilog.debug(Log.DOMAIN, Log.TAG, message, args)
  }

  static info(message, ...args) {
    hilog.info(Log.DOMAIN, Log.TAG, message, args)
  }

  static log(message, ...args) {
    hilog.debug(Log.DOMAIN, Log.TAG, message, args)
  }

  static warn(message, ...args) {
    hilog.warn(Log.DOMAIN, Log.TAG, message, args)
  }

  static error(message, ...args) {
    hilog.error(Log.DOMAIN, Log.TAG, message, args)
  }
}