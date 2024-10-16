import {getSwiperList,getHotMovie} from "../../common/api/home"
import { BaseResponse,ErrorResp } from '../../common/bean/ApiTypes';
import { Log } from '../../utils/logutil'

class MySwiperData implements IDataSource {
  private list: number[] = []

  constructor(list: number[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): number {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

@Component
export default struct ZhiHu{
  @State message: string = 'Hello World';
  private swiperController: SwiperController = new SwiperController()
  private data: MySwiperData = new MySwiperData([])

  pageStack: NavPathStack = new NavPathStack()

  // 组件生命周期
  aboutToAppear() {
    Log.info('ZhiHu aboutToAppear');
    getSwiperList().then((res) => {
      Log.debug(res.data.message)
      Log.debug("request","res.data.code:%{public}d",res.data.code)
      Log.debug("request","res.data.data[0]:%{public}s",res.data.data[0].id)
      Log.debug("request","res.data.data[0]:%{public}s",res.data.data[0].imageUrl)
      Log.debug("request","res.data.data[0]:%{public}s",res.data.data[0].title)
    }).catch((err:BaseResponse<ErrorResp>) => {
      Log.debug("request","err.data.code:%d",err.data.code)
      Log.debug("request",err.data.message)
    });
    let list: number[] = []
    for (let i = 1; i <= 10; i++) {
      list.push(i);
    }
    this.data = new MySwiperData(list)
  }

  // 组件生命周期
  aboutToDisappear() {
    Log.info('ZhiHu aboutToDisappear');
  }

  build() {
    Navigation(this.pageStack){
      Row() {
        Column({ space: 0 }) {
          // 标题栏
          Text("日报")
            .size({ width: '100%', height: 50 })
            .backgroundColor("#28bff1")
            .fontColor("#ffffff")
            .textAlign(TextAlign.Center)
            .fontSize("18fp")

          // 内容项
            Swiper(this.swiperController) {
              LazyForEach(this.data, (item: string) => {
                Stack({ alignContent: Alignment.Center }) {
                  Text(item.toString())
                    .width('100%')
                    .height(160)
                    .backgroundColor(0xAFEEEE)
                    .textAlign(TextAlign.Center)
                    .fontSize(30)
                    .zIndex(1)
                    .onClick(() => {
                      //this.pageStack.pushPathByName("PageOne", item)
                      this.pageStack.pushDestinationByName("PageOne", item).catch((e:Error)=>{
                        // 跳转失败，会返回错误码及错误信息
                        console.log(`catch exception: ${JSON.stringify(e)}`)
                      }).then(()=>{
                        // 跳转成功
                      });
                    })

                  // 显示轮播图标题
                  Text("标题aaaaaaaaaaaaaaaaaa啊啊啊啊啊啊啊啊")
                    .padding(5)
                    .margin({ top:60 })
                    .width('100%').height(50)
                    .textAlign(TextAlign.Center)
                    .maxLines(2)
                    .textOverflow({overflow:TextOverflow.Clip})
                    .fontSize(20)
                    .fontColor(Color.White)
                    .opacity(100) // 设置标题的透明度 不透明度设为100%，表示完全不透明
                    .backgroundColor('#808080AA') // 背景颜色设为透明
                    .zIndex(2)

                }
              }, (item: string) => item)
            }
            .cachedCount(2)
            .index(1)
            .autoPlay(true)
            .interval(4000)
            .loop(true)
            .indicatorInteractive(true)
            .duration(1000)
            .itemSpace(0)
            .curve(Curve.Linear)
            .onChange((index: number) => {
              console.info(index.toString())
            })
            .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
              console.info("index: " + index)
              console.info("current offset: " + extraInfo.currentOffset)
            })
            .height(160) // 设置高度

        }.size({ width: '100%', height: '100%' })
      }
    }
    .mode(NavigationMode.Stack)
    .width('100%').height('100%')

  }
}