type AnyObject = Record<string | number | symbol, any>
export interface BaseResponse<T>{
  status: number;
  statusText:string;
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