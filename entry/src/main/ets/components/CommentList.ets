/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 评论列表组件
 * @version: 1.0
 */
import { CommentItem } from '../common/bean/CommentTypes';

@Component
export struct CommentList {
  @State comments: CommentItem[] = [];
  
  setComments(comments: CommentItem[]): CommentList {
    this.comments = comments;
    return this;
  }
  
  setArticleId(articleId: string): CommentList {
    return this;
  }
  
  onReplyClickEvent(callback: (comment: CommentItem) => void): CommentList {
    return this;
  }
  
  onLikeClickEvent(callback: (comment: CommentItem) => void): CommentList {
    return this;
  }
  
  onLoadMoreEvent(callback: () => void): CommentList {
    return this;
  }
  
  build() {
    Column() {
      Text(`评论组件 (${this.comments.length}条)`)
        .fontSize(16)
        .fontColor('#000000')
        .padding(16)
    }
    .width('100%')
    .backgroundColor('#F8F9FA')
    .margin({ top: 16 })
  }
}