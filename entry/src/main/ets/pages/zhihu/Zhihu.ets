import {getSwiperList} from "../../common/api/home"
import { getZhiHuNews } from '../../common/api/zhihu';
import { BaseResponse,ErrorResp,ZhiNewsItem } from '../../common/bean/ApiTypes';
import { Log } from '../../utils/logutil'
import { formatDate } from '../../utils/time';

class BasicDataSource<T> implements IDataSource {

  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  totalCount(): number {
    return this.originDataArray.length;
  }

  getData(index: number): T {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.slice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重新重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }
}

class SwiperDataSource<T> extends BasicDataSource<T> {

  private dataArray: T[] = [];

  totalCount(): number {
    return this.dataArray.length;
  }

  getData(index: number): T {
    return this.dataArray[index];
  }

  // 在列表末尾添加数据并通知监听器
  pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  // 重载数据
  reloadData(): void {
    // 不会引起状态变化
    this.dataArray = [];
    // 必须通过DataChangeListener来更新
    this.notifyDataReload();
  }
}

@Component
export default struct ZhiHu{
  @State message: string = 'Hello World';
  private swiperController: SwiperController = new SwiperController()
  private swiperData: SwiperDataSource<ZhiNewsItem> = new SwiperDataSource()
  @State zhiNews:ZhiNewsItem[] = []
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
      for (const itm of res.data.top_stories) {
        this.swiperData.pushData(itm)
      }

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
                    .height(180)
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
            .height(180) // 设置高度

          List({ space: 12 }) {
            ForEach(this.zhiNews, (item:ZhiNewsItem) => {
              ListItem() {
                Column({ space: 0 }) {
                  Row() {
                    Column({ space: 15 }) {
                      Text(item.title).fontSize(16).fontWeight(FontWeight.Bold).align(Alignment.Start).width('100%')
                      Text(item.hint).align(Alignment.Start).width('100%')
                    }.justifyContent(FlexAlign.Start).width('70%').padding(5)

                    Image(item.image).objectFit(ImageFit.Cover).borderRadius(5).height(100).padding(2)

                  }.size({ width: '100%', height: 100 })

                  Divider().strokeWidth(2).color('#F1F3F5')
                }.size({ width: '100%', height: 100 })
              }
            }, (itm:ZhiNewsItem) => itm.id)
          }.size({ width: '100%', height: '100%' })

        }.size({ width: '100%', height: '100%' })
      }
    }
    .mode(NavigationMode.Stack)
    .width('100%').height('100%')

  }
}