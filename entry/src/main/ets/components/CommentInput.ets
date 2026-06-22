/**
 * @author: ArmyQin
 * @date: 2026/06/22
 * @description: 评论输入组件
 * @version: 1.0
 */
@Component
export struct CommentInput {
  private onSubmit?: (content: string) => void;
  private onCancel?: () => void;
  private replyTo?: string = '';
  
  setOnSubmit(callback: (content: string) => void): CommentInput {
    this.onSubmit = callback;
    return this;
  }
  
  setOnCancel(callback: () => void): CommentInput {
    this.onCancel = callback;
    return this;
  }
  
  setReplyTo(userName: string): CommentInput {
    this.replyTo = userName;
    return this;
  }
  
  build() {
    Column() {
      Text('评论输入框 (功能开发中)')
        .fontSize(16)
        .fontColor('#000000')
        .padding(16)
    }
    .width('100%')
    .backgroundColor('#F8F9FA')
    .margin({ top: 16 })
  }
}