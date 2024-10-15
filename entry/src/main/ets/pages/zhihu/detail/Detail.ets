import { Log } from '../../../utils/logutil';


@Builder
export function  DetailPageBuilder() {
  DetailPage()
}


@Component
export default struct DetailPage {
  @State message: string = 'Hello World';
  pageStack: NavPathStack = new NavPathStack()
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

    }
      .title("日报详情")
      .width('100%')
      .height('100%')
     .onReady(ctx => {
       this.pageStack = ctx.pathStack
       //从上个页面拿参数
       //cxt.pathInfo.param
       Log.info('current page config info is ' + JSON.stringify(ctx.getConfigInRouteMap()));
     })

  }
}