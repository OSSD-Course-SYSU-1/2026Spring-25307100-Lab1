import { getZhiHuDetail } from '../../../common/api/zhihu';
import { getCommentList, addComment, likeComment } from '../../../common/api/comment';
import { BaseResponse,ErrorResp,ZhiDetailRespData,ZhiDetailItem } from '../../../common/bean/ApiTypes';
import { CommentItem, CommentPageReq, AddCommentReq, LikeCommentReq } from '../../../common/bean/CommentTypes';
import { Log } from '../../../utils/logutil';
import { LengthMetrics } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';
import ThemeManager from '../../../utils/ThemeManager';
// import { CommentList } from '../../../components/CommentList';
// import { CommentInput } from '../../../components/CommentInput';

interface DetailParams {
  id: string;
}


@Builder
export function  DetailPageBuilder() {
  DetailPage()
}

@Component
struct DetailPage {
  @State message: string = 'Hello World';
  @State isDarkMode: boolean = ThemeManager.isDarkMode();
  pageStack: NavPathStack = new NavPathStack()
  private pathInfo: NavPathInfo | null = null;
  @State detailData:ZhiDetailRespData | null = null;
  @State comments: CommentItem[] = [];
  @State commentLoading: boolean = false;
  @State showCommentInput: boolean = false;
  @State replyingTo: string = ''; // 回复的用户名
  @State replyingToId: string = ''; // 回复的评论ID
  @State commentInputText: string = ''; // 评论输入内容
  private pageId = ''
  private commentPage: number = 1;
  private commentPageSize: number = 10;
  private hasMoreComments: boolean = true;

  // 组件生命周期
  aboutToAppear() {
    Log.info('Detail aboutToAppear');
    this.setupThemeListener();
    // 获取栈中所有页面name集合
    //this.pageStack.getAllPathName()
    // 获取索引为1的页面参数
    //this.pageStack.getParamByIndex(1)
    // 获取PageOne页面的参数
    //let d:Array<string> = this.pageStack.getParamByName("PageOne")
  }
  // 组件生命周期
  aboutToDisappear() {
    Log.info('Detail aboutToDisappear');
    // 清理主题监听器
    ThemeManager.removeThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  // 在 aboutToAppear 中添加主题监听
  private setupThemeListener() {
    ThemeManager.addThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  /**
   * 加载评论
   */
  private loadComments(): void {
    if (this.commentLoading || !this.pageId || !this.hasMoreComments) {
      return;
    }

    this.commentLoading = true;
    const params: CommentPageReq = {
      articleId: this.pageId,
      page: this.commentPage,
      pageSize: this.commentPageSize
    };

    getCommentList(params).then((res) => {
      if (res.data.code === 200 && res.data.data.comments) {
        const newComments = res.data.data.comments;
        this.comments = this.comments.concat(newComments);
        this.commentPage++;
        this.hasMoreComments = newComments.length >= this.commentPageSize;
      }
      this.commentLoading = false;
    }).catch((err: BusinessError) => {
      Log.error('Detail', `加载评论失败: ${JSON.stringify(err)}`);
      this.commentLoading = false;
    });
  }

  /**
   * 发表评论
   */
  private submitComment(content: string): void {
    if (!this.pageId || !content.trim()) {
      return;
    }

    const commentData: AddCommentReq = {
      articleId: this.pageId,
      content: content.trim(),
      parentId: this.replyingToId ? this.replyingToId : undefined
    };

    addComment(commentData).then((res) => {
      if (res.data.code === 200 && res.data.data) {
        // 添加新评论到列表
        const newComment = res.data.data;
        this.comments = [newComment, ...this.comments];
        this.showCommentInput = false;
        this.replyingTo = '';
        this.replyingToId = '';
      }
    }).catch((err: BusinessError) => {
      Log.error('Detail', `发表评论失败: ${JSON.stringify(err)}`);
    });
  }

  /**
   * 点赞/取消点赞评论
   */
  private handleLikeComment(comment: CommentItem): void {
    const likeData: LikeCommentReq = {
      commentId: comment.id,
      isLike: !comment.isLiked
    };

    likeComment(likeData).then((res) => {
      if (res.data.code === 200 && res.data.data) {
        // 更新评论的点赞状态
        const updatedComments = this.comments.map(c => {
          if (c.id === comment.id) {
            const updatedComment: CommentItem = {
              id: c.id,
              articleId: c.articleId,
              userId: c.userId,
              userName: c.userName,
              userAvatar: c.userAvatar,
              content: c.content,
              createTime: c.createTime,
              likeCount: res.data.data.likeCount,
              replyCount: c.replyCount,
              isLiked: res.data.data.isLiked,
              replies: c.replies,
              parentId: c.parentId
            };
            return updatedComment;
          }
          return c;
        });
        this.comments = updatedComments;
      }
    }).catch((err: BusinessError) => {
      Log.error('Detail', `点赞操作失败: ${JSON.stringify(err)}`);
    });
  }

  /**
   * 回复评论
   */
  private handleReplyComment(comment: CommentItem): void {
    this.replyingTo = comment.userName;
    this.replyingToId = comment.id;
    this.showCommentInput = true;
  }

  /**
   * 加载更多评论
   */
  private loadMoreComments(): void {
    this.loadComments();
  }
  build() {
    NavDestination(){
      Scroll() {
        Column({ space: 0 }) {
          Stack({ alignContent: Alignment.Bottom }) {
            Image(this.detailData?.image).width('100%').height(250).zIndex(1)
            // 显示轮播图标题
            Text(this.detailData?.title)
              .padding(5)
              .margin({ bottom: 10 })
              .width('100%')
              .height(50)
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Clip })
              .fontSize(16)
              .fontColor('#FFFFFF')
              .opacity(100)// 设置标题的透明度 不透明度设为100%，表示完全不透明
              .backgroundColor('#808080AA')// 背景颜色设为透明
              .zIndex(2)
          }.height(250) // 设置高度

          Text(`${this.detailData?.author ?? ""} ${this.detailData?.bio ?? ""}`)
            .fontSize(14)
            .fontColor(ThemeManager.getTextSecondaryColor())
            .padding(10).width('100%')


          Column() {
            ForEach(this.detailData?.content, (item: ZhiDetailItem, idx) => {
              if (item.types === 'p') {
                Text(item.value).fontSize(16).padding(10).lineSpacing(LengthMetrics.px(30)).width('100%').alignSelf(ItemAlign.Start).fontColor(ThemeManager.getTextPrimaryColor())
              } else if (item.types === 'p.strong') {
                Text(item.value).fontSize(16).fontWeight(FontWeight.Bold).padding(10).width('100%').alignSelf(ItemAlign.Start).fontColor(ThemeManager.getTextPrimaryColor())
              } else if (item.types === 'img') {
                Image(item.value).padding(10)
              }
            })
          }

          // 评论标题
          Row() {
            Text('评论')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(ThemeManager.getTextPrimaryColor())
              .layoutWeight(1)
            
            // 评论按钮
            Button('写评论')
              .fontSize(14)
              .fontColor(ThemeManager.getPrimaryColor())
              .backgroundColor(ThemeManager.getCardBackgroundColor())
              .borderColor(ThemeManager.getPrimaryColor())
              .borderWidth(1)
              .borderRadius(20)
              .padding({ left: 16, right: 16, top: 6, bottom: 6 })
              .onClick(() => {
                this.showCommentInput = true;
                this.replyingTo = '';
                this.replyingToId = '';
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 24, bottom: 16 })

          // 评论列表
          Column() {
            // 评论标题
            Text(`评论 (${this.comments.length}条)`)
              .fontSize(18)
              .fontColor(ThemeManager.getTextPrimaryColor())
              .fontWeight(500)
              .width('100%')
              .padding({ left: 16, top: 16, bottom: 8 })
            
            // 评论内容
            if (this.comments.length === 0) {
              Text('暂无评论')
                .fontSize(14)
                .fontColor(ThemeManager.getTextSecondaryColor())
                .padding(20)
                .width('100%')
                .textAlign(TextAlign.Center)
            } else {
              Column({ space: 12 }) {
                ForEach(this.comments, (comment: CommentItem) => {
                  Column({ space: 8 }) {
                    // 用户信息
                    Row({ space: 8 }) {
                      // 用户头像
                      Column() {
                        Text(comment.userName.charAt(0).toUpperCase())
                          .fontSize(14)
                          .fontColor('#FFFFFF')
                          .textAlign(TextAlign.Center)
                      }
                      .width(32)
                      .height(32)
                      .backgroundColor(ThemeManager.getPrimaryColor())
                      .borderRadius(16)
                      .justifyContent(FlexAlign.Center)
                      
                      // 用户名和时间
                      Column({ space: 2 }) {
                        Text(comment.userName)
                          .fontSize(14)
                          .fontColor(ThemeManager.getTextPrimaryColor())
                          .fontWeight(500)
                        
                        Text(comment.createTime)
                          .fontSize(12)
                          .fontColor(ThemeManager.getTextTertiaryColor())
                      }
                      .layoutWeight(1)
                      
                      // 点赞按钮
                      Row({ space: 4 }) {
                        Text('♥')
                          .fontSize(12)
                          .fontColor(comment.isLiked ? '#FF3B30' : ThemeManager.getTextTertiaryColor())
                        
                        Text(comment.likeCount.toString())
                          .fontSize(12)
                          .fontColor(ThemeManager.getTextTertiaryColor())
                      }
                      .onClick(() => {
                        this.handleLikeComment(comment);
                      })
                    }
                    .width('100%')
                    .padding({ left: 16, right: 16, top: 12 })
                    
                    // 评论内容
                    Text(comment.content)
                      .fontSize(14)
                      .fontColor(ThemeManager.getTextPrimaryColor())
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .padding({ left: 16, right: 16, bottom: 12 })
                    
                    // 回复按钮
                    Row() {
                      Text('回复')
                        .fontSize(12)
                        .fontColor(ThemeManager.getPrimaryColor())
                        .onClick(() => {
                          this.handleReplyComment(comment);
                        })
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.End)
                    .padding({ left: 16, right: 16, bottom: 12 })
                    
                    // 分割线
                    Row()
                      .width('100%')
                      .height(1)
                      .backgroundColor(ThemeManager.getDividerColor())
                      .margin({ left: 16, right: 16 })
                  }
                  .width('100%')
                  .backgroundColor(ThemeManager.getCardBackgroundColor())
                  .borderRadius(8)
                  .margin({ left: 16, right: 16, bottom: 8 })
                })
              }
            }
            
            // 加载更多
            if (this.hasMoreComments && this.comments.length > 0) {
              Column() {
                if (this.commentLoading) {
                  Text('加载中...')
                    .fontSize(14)
                    .fontColor(ThemeManager.getTextSecondaryColor())
                    .padding(16)
                } else {
                  Text('点击加载更多')
                    .fontSize(14)
                    .fontColor(ThemeManager.getPrimaryColor())
                    .padding(16)
                    .backgroundColor(ThemeManager.getCardBackgroundColor())
                    .borderRadius(8)
                    .onClick(() => {
                      this.loadMoreComments();
                    })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .padding({ top: 8, bottom: 16 })
            }
          }
          .width('100%')

          // 评论输入框
          if (this.showCommentInput) {
            Column({ space: 12 }) {
              // 回复提示
              if (this.replyingTo) {
                Row() {
                  Text(`回复 ${this.replyingTo}`)
                    .fontSize(14)
                    .fontColor(ThemeManager.getPrimaryColor())
                    .layoutWeight(1)
                  
                  Text('×')
                    .fontSize(16)
                    .fontColor(ThemeManager.getTextTertiaryColor())
                    .onClick(() => {
                      this.showCommentInput = false;
                      this.replyingTo = '';
                      this.replyingToId = '';
                      this.commentInputText = '';
                    })
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 12 })
              }
              
              // 输入区域
              Row({ space: 12 }) {
                // 文本输入框
                TextInput({ text: this.commentInputText, placeholder: this.replyingTo ? `回复 ${this.replyingTo}:` : '说点什么吧...' })
                  .placeholderColor(ThemeManager.getTextTertiaryColor())
                  .placeholderFont({ size: 16 })
                  .fontColor(ThemeManager.getTextPrimaryColor())
                  .caretColor(ThemeManager.getPrimaryColor())
                  .fontSize(16)
                  .height(80)
                  .maxLines(5)
                  .layoutWeight(1)
                  .padding(12)
                  .backgroundColor(ThemeManager.getCardBackgroundColor())
                  .borderRadius(8)
                  .border({ width: 1, color: ThemeManager.getBorderColor() })
                  .onChange((value: string) => {
                    this.commentInputText = value;
                  })
                
                // 提交按钮
                Column() {
                  Text('发送')
                    .fontSize(16)
                    .fontColor('#FFFFFF')
                    .fontWeight(500)
                }
                .width(60)
                .height(60)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor(this.commentInputText.trim().length > 0 ? ThemeManager.getPrimaryColor() : ThemeManager.getTextTertiaryColor())
                .borderRadius(30)
                .onClick(() => {
                  if (this.commentInputText.trim().length > 0) {
                    this.submitComment(this.commentInputText);
                    this.commentInputText = '';
                    this.showCommentInput = false;
                    this.replyingTo = '';
                    this.replyingToId = '';
                  }
                })
                .opacity(this.commentInputText.trim().length > 0 ? 1 : 0.6)
              }
              .width('100%')
              .padding({ left: 16, right: 16, bottom: 12 })
              .alignItems(VerticalAlign.Bottom)
              
              // 字数统计
              Row() {
                Text(`${this.commentInputText.length}/500`)
                  .fontSize(12)
                  .fontColor(this.commentInputText.length > 500 ? '#FF3B30' : ThemeManager.getTextTertiaryColor())
                  .margin({ right: 16 })
              }
              .width('100%')
              .justifyContent(FlexAlign.End)
              .padding({ right: 16, bottom: 12 })
            }
            .width('100%')
            .padding({ top: 8 })
            .backgroundColor(ThemeManager.getBackgroundColor())
            .border({ width: { top: 1 }, color: ThemeManager.getDividerColor() })
          }
        }
        .backgroundColor(ThemeManager.getBackgroundColor())
      }
    }
      .title("日报详情")
      .backgroundColor(ThemeManager.getBackgroundColor())
      .width('100%')
      .height('100%')
     .onReady(ctx => {
       this.pageStack = ctx.pathStack
       //从上个页面拿参数
       this.pageStack.getParamByName("ZhiPageDetail")
       this.pathInfo = ctx.pathInfo

       let par = ctx.pathInfo.param as DetailParams
       Log.debug("par:%s",par.id)
       this.pageId = par.id
       Log.info('current page config info is ' + JSON.stringify(ctx.getConfigInRouteMap()));
     })
    .onShown(()=>{
      console.info('Detail onShown');
      getZhiHuDetail(this.pageId).then((res) => {
        Log.debug(res.data.message)
        Log.debug("request","res.data.code:%{public}d",res.data.code)
        this.detailData = res.data
        // 加载评论
        this.loadComments();
      }).catch((err: BusinessError) => {
        Log.debug("request","err.code:%d",err.code)
        Log.debug("request",err.message)
      });
    })

  }
}