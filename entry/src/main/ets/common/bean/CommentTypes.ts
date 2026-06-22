/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 评论相关数据类型定义
 * @version: 1.0
 */

/**
 * 评论数据项
 */
export interface CommentItem {
  id: string;                    // 评论ID
  articleId: string;            // 文章ID
  userId: string;               // 用户ID
  userName: string;             // 用户名
  userAvatar: string;           // 用户头像
  content: string;              // 评论内容
  createTime: string;           // 创建时间
  likeCount: number;            // 点赞数
  replyCount: number;           // 回复数
  isLiked: boolean;             // 是否已点赞
  replies?: CommentItem[];      // 回复列表
  parentId?: string;            // 父评论ID（用于回复）
}

/**
 * 评论列表响应数据
 */
export interface CommentListRespData {
  code: number;
  message: string;
  data: {
    comments: CommentItem[];
    total: number;
    page: number;
    pageSize: number;
  };
}

/**
 * 发表评论请求数据
 */
export interface AddCommentReq {
  articleId: string;
  content: string;
  parentId?: string;  // 可选，回复时使用
}

/**
 * 发表评论响应数据
 */
export interface AddCommentRespData {
  code: number;
  message: string;
  data: CommentItem;
}

/**
 * 点赞/取消点赞请求数据
 */
export interface LikeCommentReq {
  commentId: string;
  isLike: boolean;  // true:点赞, false:取消点赞
}

/**
 * 点赞/取消点赞响应数据
 */
export interface LikeCommentRespData {
  code: number;
  message: string;
  data: {
    commentId: string;
    likeCount: number;
    isLiked: boolean;
  };
}

/**
 * 评论分页请求参数
 */
export interface CommentPageReq {
  articleId: string;
  page: number;
  pageSize: number;
  parentId?: string;  // 可选，获取子评论时使用
}