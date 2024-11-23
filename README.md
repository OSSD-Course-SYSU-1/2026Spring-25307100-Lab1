# harmonyos NEXT 仿知乎日报项目实战

## 简介
本软件使用坚果派 @nutpi/request网络库,harmonyos NEXT原生开发，实现了仿知乎日报的功能，包括首页、主题、新闻详情等。 

![首页](doc/首页.png)
   
## nutpi/request网络库介绍

request网络库是远场服务通信rcp模块儿化封装。网络通信是最常用的功能，之前有os.http包，但HarmonyOS远场服务通信服务(RCP)是华为主推的，更强大和高效。 然而，原始的远场通信（RCP）使用方式较为繁琐，让人感到不够便捷。作为一位前期从事小程序开发的开发者，我深受小程序网络访问的简单性和便利性的吸引。因此，在HarmonyOS中打造一个最简单好用的网络访问组件。)地址：https://ohpm.openharmony.cn/#/cn/detail/@nutpi%2Frequest
详细实现原理，参见博文：[HarmonyOS NEXT应用开发实战：十二、远场通信RCP简单好用的模块化封装](https://blog.csdn.net/yyz_1987/article/details/143881288)

## 下载安装
```shell
ohpm  install @nutpi/request
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

1. 引入依赖
 ```
import HttpRequest, { HttpRequestConfig, HttpResponse } from '@nutpi/request';
 ```

2. 再次简单封装
utils/http.ts文件:
```typescript
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
```

3. 使用举例
```typescript
import httpClient, { setRequestConfig } from '../../utils/http';
import { BaseResponse,ZhiNewsRespData,ZhiDetailRespData } from '../bean/ApiTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = httpClient;

// 获取知乎列表页api接口
export const getZhiHuNews = (date:string): Promise<BaseResponse<ZhiNewsRespData>> => http.get('/zhihunews/'+date);

// 获取知乎详情页api接口
export const getZhiHuDetail = (id:string): Promise<BaseResponse<ZhiDetailRespData>> => http.get('/zhihudetail/'+id);

```
这一改动使得接口调用变得极其简单，清晰易读，减少了出错的可能性。一行代码即可写完一个接口，清晰直观。以上的四行代码，写完了四个接口，极大提高了开发效率。

当然，接口的请求包和响应包格式需要定义，这必不可少。以下是bean/ApiTypes.ts的接口类型定义:

```typescript
type AnyObject = Record<string | number | symbol, any>
export interface BaseResponse<T>{
  statusCode: number;
  errMsg:string;
  header?: AnyObject;
  data:T;
}

export interface ErrorResp {
  code: number;
  message: string;
  data: [];
}

// 轮播图响应数据
export interface SwiperItem{
  id:string;
  imageUrl:string;
  title:string;
  url:string;
  description:string;
}
export interface SwiperData {
  code: number;
  message: string;
  data: Array<SwiperItem>;
}

// 热门影视请求数据
export interface HotMovieReq {
  start: number;
  count: number;
  city:string;
}
// 热门影视响应数据
interface MovieItem{
  id:string;
  cover:string;
  title:string;
  gener:string;
  rate:number;
}
export interface MovieRespData {
  code: number;
  message: string;
  data: Array<MovieItem>;
  count: number;
  start: number;
  total: number;
  title: string;
}

//==============================知乎日报
export type ZhiNewsItem ={
  id:string;
  image:string;
  title:string;
  url:string;
  hint:string;
  date: string;
}
export interface ZhiNewsRespData {
  code: number;
  message: string;
  stories: Array<ZhiNewsItem>;
  top_stories: Array<ZhiNewsItem>;
  date: string;
}

type ZhiDetailItem={
  types:string;
  value:string;
}
export interface ZhiDetailRespData {
  code: number;
  message: string;
  content: Array<ZhiDetailItem>;
  title: string;
  author: string;
  bio: string;
  avatar: string;
  image: string;
  more: string;

}

```

## 总结
通过对HarmonyOS中远场通信RCP的模块化封装，我们不仅优化了网络请求的流程，还提升了代码的可读性和可维护性。希望这篇文章能够帮助你在HarmonyOS应用开发中更高效地使用网络组件，享受更便捷的开发体验。

开源地址： https://gitee.com/yyz116/request

作者：[猫哥](blog.csdn.net/qq8864)，转载请注明出处。

团队：坚果派 团队介绍：坚果派由坚果等人创建，团队拥有12个华为HDE带领热爱HarmonyOS/OpenHarmony的开发者，以及若干其他领域的三十余位万粉博主运营。专注于分享HarmonyOS/OpenHarmony、ArkUI-X、元服务、仓颉。团队成员聚集在北京，上海，南京，深圳，广州，宁夏等地，目前已开发鸿蒙原生应用，三方库60+，欢迎交流。
