import { getZhiHuDetail } from '../../../common/api/zhihu';
import { BaseResponse,ErrorResp,ZhiDetailRespData } from '../../../common/bean/ApiTypes';
import { Log } from '../../../utils/logutil';


@Builder
export function  DetailPageBuilder() {
  DetailPage()
}

@Entry
@Component
struct DetailPage {
  @State message: string = 'Hello World';
  pageStack: NavPathStack = new NavPathStack()
  private pathInfo: NavPathInfo | null = null;
  private detailData:ZhiDetailRespData | null = null;
  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageShow() {
    console.info('Detail onPageShow');
    getZhiHuDetail("9773231").then((res) => {
      Log.debug(res.data.message)
      Log.debug("request","res.data.code:%{public}d",res.data.code)
      this.detailData = res.data
    }).catch((err:BaseResponse<ErrorResp>) => {
      Log.debug("request","err.data.code:%d",err.data.code)
      Log.debug("request",err.data.message)
    });
  }
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

      Column({ space: 0 }) {
        Image(this.detailData?.image).width('100%').height(180)
        // 内容项
        Text(this.detailData?.title).width('100%').height('100%').textAlign(TextAlign.Center).fontSize("25fp")
      }

    }
      .title("日报详情")
      .width('100%')
      .height('100%')
     .onReady(ctx => {
       this.pageStack = ctx.pathStack
       //从上个页面拿参数
       this.pageStack.getParamByName("PageOne")
       this.pathInfo = ctx.pathInfo
       let par = ctx.pathInfo.param as string
       Log.debug("par:%s",par)
       Log.info('current page config info is ' + JSON.stringify(ctx.getConfigInRouteMap()));
     })

  }
}