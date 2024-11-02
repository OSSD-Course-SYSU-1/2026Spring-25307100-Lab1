import { getZhiHuDetail } from '../../../common/api/zhihu';
import { BaseResponse,ErrorResp,ZhiDetailRespData,ZhiDetailItem } from '../../../common/bean/ApiTypes';
import { Log } from '../../../utils/logutil';
import { LengthMetrics } from '@kit.ArkUI';


@Builder
export function  DetailPageBuilder() {
  DetailPage()
}

@Component
struct DetailPage {
  @State message: string = 'Hello World';
  pageStack: NavPathStack = new NavPathStack()
  private pathInfo: NavPathInfo | null = null;
  @State detailData:ZhiDetailRespData | null = null;
  private pageId = ''

  // 组件生命周期
  aboutToAppear() {
    Log.info('Detail aboutToAppear');
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
              .fontColor(Color.White)
              .opacity(100)// 设置标题的透明度 不透明度设为100%，表示完全不透明
              .backgroundColor('#808080AA')// 背景颜色设为透明
              .zIndex(2)
          }.height(250) // 设置高度

          Text(`${this.detailData?.author ?? ""} ${this.detailData?.bio ?? ""}`)
            .fontSize(14)
            .fontColor("#999")
            .padding(10).width('100%')


          Column() {
            ForEach(this.detailData?.content, (item: ZhiDetailItem, idx) => {
              if (item.types === 'p') {
                Text(item.value).fontSize(16).padding(10).lineSpacing(LengthMetrics.px(30)).width('100%').alignSelf(ItemAlign.Start)
              } else if (item.types === 'p.strong') {
                Text(item.value).fontSize(16).fontWeight(FontWeight.Bold).padding(10).width('100%').alignSelf(ItemAlign.Start)
              } else if (item.types === 'img') {
                Image(item.value).padding(10)
              }
            })
          }

        }
      }
    }
      .title("日报详情")
      .width('100%')
      .height('100%')
     .onReady(ctx => {
       this.pageStack = ctx.pathStack
       //从上个页面拿参数
       this.pageStack.getParamByName("ZhiPageDetail")
       this.pathInfo = ctx.pathInfo

       interface params {
         id: string;
       }
       let par = ctx.pathInfo.param as params
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
      }).catch((err:BaseResponse<ErrorResp>) => {
        Log.debug("request","err.data.code:%d",err.data.code)
        Log.debug("request",err.data.message)
      });
    })

  }
}