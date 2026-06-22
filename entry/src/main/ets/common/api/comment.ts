/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 评论相关API接口
 * @version: 1.0
 */
import httpClient, { setRequestConfig } from '../../utils/http';
import { BaseResponse } from '../bean/ApiTypes';
import { 
  CommentListRespData, 
  AddCommentReq, 
  AddCommentRespData,
  LikeCommentReq,
  LikeCommentRespData,
  CommentPageReq,
  CommentItem
} from '../bean/CommentTypes';

// 调用setRequestConfig函数进行请求配置
setRequestConfig();

const http = httpClient;

/**
 * 获取评论列表
 * @param params 分页参数
 * @returns 评论列表响应
 */
export const getCommentList = (params: CommentPageReq): Promise<BaseResponse<CommentListRespData>> => {
  return http.get('/comments', { params });
};

/**
 * 发表评论
 * @param data 评论数据
 * @returns 评论响应
 */
export const addComment = (data: AddCommentReq): Promise<BaseResponse<AddCommentRespData>> => {
  return http.post('/comments', data);
};

/**
 * 点赞/取消点赞评论
 * @param data 点赞数据
 * @returns 点赞响应
 */
export const likeComment = (data: LikeCommentReq): Promise<BaseResponse<LikeCommentRespData>> => {
  return http.post('/comments/like', data);
};

/**
 * 删除评论
 * @param commentId 评论ID
 * @returns 删除响应
 */
export const deleteComment = (commentId: string): Promise<BaseResponse<{ success: boolean }>> => {
  return http.delete(`/comments/${commentId}`);
};

/**
 * 获取评论详情
 * @param commentId 评论ID
 * @returns 评论详情响应
 */
export const getCommentDetail = (commentId: string): Promise<BaseResponse<CommentItem>> => {
  return http.get(`/comments/${commentId}`);
};

/**
 * 获取评论回复列表
 * @param commentId 评论ID
 * @param params 分页参数
 * @returns 回复列表响应
 */
export const getCommentReplies = (commentId: string, params: Omit<CommentPageReq, 'articleId'>): Promise<BaseResponse<CommentListRespData>> => {
  return http.get(`/comments/${commentId}/replies`, { params });
};