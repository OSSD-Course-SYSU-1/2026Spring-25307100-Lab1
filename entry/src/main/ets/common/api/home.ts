import httpClient, { setRequestConfig } from '../../utils/http';
import { BaseResponse,SwiperData,HotMovieReq,MovieRespData } from '../bean/ApiTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = httpClient;

// 获取轮播图api接口
export const getSwiperList = (): Promise<BaseResponse<SwiperData>> => http.get('/swiperdata');

// 获取热门影视接口
export const getHotMovie = (req:HotMovieReq): Promise<BaseResponse<MovieRespData>> => http.post('/hotmovie',req);

