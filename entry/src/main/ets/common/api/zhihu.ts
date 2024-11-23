import httpClient, { setRequestConfig } from '../../utils/http';
import { BaseResponse,ZhiNewsRespData,ZhiDetailRespData } from '../bean/ApiTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = httpClient;

// 获取知乎列表页api接口
export const getZhiHuNews = (date:string): Promise<BaseResponse<ZhiNewsRespData>> => http.get('/zhihunews/'+date);

// 获取知乎详情页api接口
export const getZhiHuDetail = (id:string): Promise<BaseResponse<ZhiDetailRespData>> => http.get('/zhihudetail/'+id);