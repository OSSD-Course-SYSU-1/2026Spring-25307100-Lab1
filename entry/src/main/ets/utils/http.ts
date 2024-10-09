import Request, { HttpRequestConfig, HttpResponse } from '@yyz116/h_request'
import { Log } from './logutil';

export const setRequestConfig = () => {
  const httpRequest = new Request();
  httpRequest.setConfig((config:HttpRequestConfig) => {
    config.baseURL = "http://175.178.126.10:8000/api/v1";
    return config;
  });
  // 请求拦截
  httpRequest.interceptors.request.use(
    (config) => {
      Log.debug('请求拦截')
      return config
    },
    (error) => {
      return Promise.reject(error)
    }
  )
  // 响应拦截
  httpRequest.interceptors.response.use(
    (response:HttpResponse) => {
      Log.debug('响应拦截')
      if (response.data.code == 401) {
        // 提示重新登录
        console.log('请登录')
        setTimeout(() => {
          console.log('请请登录')
        }, 1000);
      }
      return response
    },
    (error) => {
      return Promise.reject(error)
    }
  )
  //挂载在ArkTS引擎实例内部的一个全局对象globalThis中，供全局使用
  globalThis.$http = httpRequest;
}
