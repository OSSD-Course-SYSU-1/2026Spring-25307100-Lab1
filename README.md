# harmonyos NEXT 仿知乎日报项目实战

## 简介
   本软件使用@yyz116/h_request网络库,harmonyos NEXT原生开发，实现了仿知乎日报的功能，包括首页、主题、新闻详情等。
## 下载安装
```shell
ohpm  install @yyz116/h_request
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明
1. 引入依赖
 ```
import Request, { HttpRequestConfig, HttpResponse } from '@yyz116/h_request'
 ```
 
2. 使用举例
```ts
 import { setRequestConfig } from '../../utils/http';
import { BaseResponse,SwiperData,HotMovieReq,MovieRespData } from '../bean/ApiTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = globalThis.$http;

// 获取轮播图api接口
export const getSwiperList = (): Promise<BaseResponse<SwiperData>> => http.get('/swiperdata');

// 获取热门影视接口
export const getHotMovie = (req:HotMovieReq): Promise<BaseResponse<MovieRespData>> => http.post('/hotmovie',req);


```
