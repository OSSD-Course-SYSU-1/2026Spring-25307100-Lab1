import { setRequestConfig } from '../../utils/http';
import { BaseResponse,SwiperData,HotMovieReq,MovieRespData } from '../bean/ApiTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = globalThis.$http;

// 获取知乎列表页api接口
export const getZhiHuNews = (date:string): Promise<BaseResponse<SwiperData>> => http.get('/zhihunews/'+date);