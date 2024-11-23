import HttpRequest, { HttpRequestConfig, HttpResponse } from '@nutpi/request';
import { Log } from './logutil';

const config:HttpRequestConfig = {
  baseURL: "http://175.178.126.10:8000/api/v1",
  validateStatus: (status) => {
    return status >= 200 && status < 300;
  }
}

export const httpClient = new HttpRequest(config);

export const setRequestConfig = () => {
  // 请求拦截
  httpClient.requestInterceptor.onFulfilled = (config?: HttpRequestConfig) =>{
    // 返回一个符合 HttpRequestConfig 类型的对象
    Log.debug('请求拦截')
    return {

    }
  }

  httpClient.responseInterceptor.onFulfilled = (response?: HttpResponse) =>{
    // 返回一个符合 HttpResponse 类型的对象
    Log.debug('响应拦截')
    return {

    }as HttpResponse
  }
}

export default httpClient;