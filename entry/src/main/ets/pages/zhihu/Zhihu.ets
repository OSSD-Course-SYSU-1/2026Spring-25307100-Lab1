import {getSwiperList} from "../../common/api/home"
import { getZhiHuNews } from '../../common/api/zhihu';
import { BaseResponse,ErrorResp,ZhiNewsItem } from '../../common/bean/ApiTypes';
import { Log } from '../../utils/logutil'
import { formatDate2 } from '../../utils/time';
import { promptAction } from "@kit.ArkUI";


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

  @State isRefreshing: boolean = false

  // 判断滚动条是否触底
  @State
  private isEnd: boolean = false;
  // 使用Scroller对象
  scroller: Scroller = new Scroller();

  // 组件生命周期
  aboutToAppear() {
    Log.info('ZhiHu aboutToAppear');
    this.currentDate = formatDate2(new Date())
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
    //this.finished = false
    getZhiHuNews(this.currentDate.replace(/-/g, '')).then((res) => {
      Log.debug(res.data.message)
      Log.debug("request","res.data.code:%{public}d",res.data.code)
      res.data.stories.map((item, index) => {
        item.isShowDivider = false
        if (item.date !== this.previousDate) {
          this.previousDate = item.date;
          item.isShowDivider = true
        }
      });
      this.zhiNews = res.data.stories
      for (const itm of res.data.top_stories) {
        this.swiperData.pushData(itm)
      }
      //this.getMoreNews();

    }).catch((err:BaseResponse<ErrorResp>) => {
      Log.debug("request","err.data.code:%d",err.data.code)
      Log.debug("request",err.data.message)
    });
  }

  // 组件生命周期
  aboutToDisappear() {
    Log.info('ZhiHu aboutToDisappear');
  }

  // 触底之后触发下一页
  getMoreNews():void {
    console.log('getMoreNews:')
    promptAction.showToast({ message: '数据加载中' })
    const date_ = new Date(this.currentDate);
    date_.setDate(date_.getDate() - 1); // 日期减一
    //console.log(date_);
    let currentDate_ = formatDate2(date_);
    console.log('currentDate_:'+currentDate_);
    getZhiHuNews(currentDate_.replace(/-/g, '')).then((result) => {
      console.log("getZhiHuNews,result:");
      // 加载完数据把滚动条移至底部
      this.scroller.scrollEdge(Edge.Bottom);
      console.log(result.data.message);
      this.currentDate = formatDate2(date_);
      if (result.data.stories != null){
        result.data.stories.map((item, index) => {
          item.isShowDivider = false
          if (item.date !== this.previousDate) {
            this.previousDate = item.date;
            item.isShowDivider = true
          }
        })
        this.zhiNews = this.zhiNews.concat(result.data.stories);
      }
    });
  }

  @Builder
  private LoadingCustom() {
    Stack() {
      Row() {
        LoadingProgress().width(30).color("#4095cb")
      }
    }.width('100%')
  }

  build() {
    Navigation(this.pageStack){
        Column({ space: 0 }) {

          // 内容项
          Swiper(this.swiperController) {
            LazyForEach(this.swiperData, (item: ZhiNewsItem) => {
              Stack({ alignContent: Alignment.Center }) {
                Image(item.image)
                  .width('100%')
                  .height(200)
                  .backgroundColor(0xAFEEEE)
                  .zIndex(1)
                  .onClick(() => {
                    //this.pageStack.pushPathByName("PageOne", item)
                    this.pageStack.pushDestinationByName("ZhiPageDetail", { id:item.id }).catch((e:Error)=>{
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
          .height(200) // 设置高度

          Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100,builder: this.LoadingCustom() }) {
            // list组件
            List({ space: 1 }) {
              ForEach(this.zhiNews, (item:ZhiNewsItem,idx) => {
                ListItem() {
                  Column({ space: 0 }) {
                    if(item.isShowDivider && (idx !=0)){
                      Text(item.date).width("90%").alignSelf(ItemAlign.Start)
                        .padding({left:10})
                        .margin({top:-10})
                    }
                    Row() {
                      Column({ space: 15 }) {
                        Text(item.title).fontSize(16).fontWeight(FontWeight.Bold).align(Alignment.Start).width('100%')
                        Text(item.hint).align(Alignment.Start).width('100%')
                      }.justifyContent(FlexAlign.Start).width('70%').padding(5)

                      Image(item.image).objectFit(ImageFit.Cover).borderRadius(5).height(100).padding(2)

                    }.size({ width: '100%', height: 100 })

                  }.size({ width: '100%', height: 120 })
                }.onClick(() => {
                  this.pageStack.pushDestinationByName("ZhiPageDetail", { id:item.id }).catch((e:Error)=>{
                    // 跳转失败，会返回错误码及错误信息
                    console.log(`catch exception: ${JSON.stringify(e)}`)
                  }).then(()=>{
                    // 跳转成功
                  });
                })
              }, (itm:ZhiNewsItem) => itm.id)
            }
            .divider({strokeWidth:2,color:'#F1F3F5'})
            .listDirection(Axis.Vertical)
            .edgeEffect(EdgeEffect.Spring, {alwaysEnabled:true})
            // 当画面能滚动说明没有触底
            .onScrollStart(() => {
              this.isEnd = false
            })
            // 判断当前是否停止滚动
            .onScrollStop(() => {
              // 如果停止滚动并且满足滚动条已经在底部进行数据的加载
              if (this.isEnd) {
                // 加载数据
                this.getMoreNews();
              }
            })
            // 当滚动条触底把 flag 设置成 true
            .onReachEnd(() => {
              this.isEnd = true
              console.log("onReachEnd")
            })
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              console.info('first' + firstIndex)
              console.info('last' + lastIndex)
              //this.getmorePage()
            })


            //.backgroundColor('#ff940a31')
          }
          .onStateChange((refreshStatus: RefreshStatus) => {
            console.info('Refresh onStatueChange state is ' + refreshStatus)
          })
          // 设置触发刷新的下拉偏移量
          .refreshOffset(64)
          // 设置当下拉距离超过refreshOffset时是否触发刷新
          .pullToRefresh(true)
          .onRefreshing(() => {
            setTimeout(() => {
              this.isRefreshing = false
            }, 1000)
            console.log('onRefreshing test')
          })

        }
        //.backgroundColor('#ff94610a')

    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title("知乎日报")
    .hideBackButton(true)
    //.backgroundColor('#ff0a3894')
    .width('100%').height('100%')

  }
}