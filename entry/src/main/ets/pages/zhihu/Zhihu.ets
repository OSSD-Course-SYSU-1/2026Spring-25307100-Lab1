import {getSwiperList,getHotMovie} from "../../common/api/home"
import { getZhiHuNews } from '../../common/api/zhihu';
import { BaseResponse,ErrorResp,ZhiNewsItem } from '../../common/bean/ApiTypes';
import { Log } from '../../utils/logutil'
import { formatDate } from '../../utils/time';

class MySwiperData implements IDataSource {
  private list: ZhiNewsItem[] = []

  constructor(list: ZhiNewsItem[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): ZhiNewsItem {
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
  private swiperData: MySwiperData = new MySwiperData([])
  private zhiNews:ZhiNewsItem[] = []
  private currentDate= '' // 初始化为今天的日期
  private previousDate= '' // 上一天的日期
  pageStack: NavPathStack = new NavPathStack()

  // 组件生命周期
  aboutToAppear() {
    Log.info('ZhiHu aboutToAppear');
    this.currentDate = formatDate(new Date())
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

    //获取知乎新闻列表
    getZhiHuNews(this.currentDate).then((res) => {
      Log.debug(res.data.message)
      Log.debug("request","res.data.code:%{public}d",res.data.code)
      this.zhiNews = res.data.stories
      this.swiperData = new MySwiperData(res.data.top_stories)

    }).catch((err:BaseResponse<ErrorResp>) => {
      Log.debug("request","err.data.code:%d",err.data.code)
      Log.debug("request",err.data.message)
    });
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
              LazyForEach(this.swiperData, (item: ZhiNewsItem) => {
                Stack({ alignContent: Alignment.Center }) {
                  Image(item.image)
                    .width('100%')
                    .height(160)
                    .backgroundColor(0xAFEEEE)
                    .zIndex(1)
                    .onClick(() => {
                      //this.pageStack.pushPathByName("PageOne", item)
                      this.pageStack.pushDestinationByName("PageOne", { id:"9773231" }).catch((e:Error)=>{
                        // 跳转失败，会返回错误码及错误信息
                        console.log(`catch exception: ${JSON.stringify(e)}`)
                      }).then(()=>{
                        // 跳转成功
                      });
                    })

                  // 显示轮播图标题
                  Text(item.title)
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
              }, (item: ZhiNewsItem) => item.id)
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

          List({ space: 12 }) {
            ForEach(this.zhiNews, (item:ZhiNewsItem) => {
              ListItem() {
                Column({ space: 0 }) {
                  Row() {
                    Column({ space: 0 }) {
                      Text(item.title)
                      Text(item.hint)
                    }.width('70%').padding(10)

                    Image(item.image).height(100).padding(10)

                  }.size({ width: '100%', height: 100 })

                  Divider().strokeWidth(5).color('#F1F3F5')
                }.size({ width: '100%', height: 100 })
              }
            }, (itm:ZhiNewsItem) => itm.id)
          }

        }.size({ width: '100%', height: '100%' })
      }
    }
    .mode(NavigationMode.Stack)
    .width('100%').height('100%')

  }
}