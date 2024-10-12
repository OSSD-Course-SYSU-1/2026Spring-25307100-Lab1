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
            Text(item.toString())
              .width('100%')
              .height(160)
              .backgroundColor(0xAFEEEE)
              .textAlign(TextAlign.Center)
              .fontSize(30)
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
        .displayArrow({ // 设置导航点箭头样式
          showBackground: true,
          isSidebarMiddle: true,
          backgroundSize: 24,
          backgroundColor: Color.White,
          arrowSize: 18,
          arrowColor: Color.Blue
        }, false)
        .curve(Curve.Linear)
        .onChange((index: number) => {
          console.info(index.toString())
        })
        .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
          console.info("index: " + index)
          console.info("current offset: " + extraInfo.currentOffset)
        })

      }.size({ width: '100%', height: '100%' })
    }
  }
}