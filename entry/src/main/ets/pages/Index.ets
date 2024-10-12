import Home from "../pages/home/Home"
import ZhiHu from "../pages/zhihu/Zhihu"
import Mine from "../pages/mine/Mine"

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageShow() {
    console.info('Index onPageShow');
  }
  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageHide() {
    console.info('Index onPageHide');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onBackPress() {
    console.info('Index onBackPress');
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.controller
      }) {
        TabContent() {
          Home()
        }.tabBar(this.TabBuilder('首页', 0, $r('app.media.icon_sort'), $r('app.media.icon_sort_default')))

        TabContent() {
          ZhiHu()
        }.tabBar(this.TabBuilder('日报', 1, $r('app.media.search_select'), $r('app.media.search_defaut')))

        TabContent() {
           Mine()
        }.tabBar(this.TabBuilder('我的', 2, $r('app.media.user_selected'), $r('app.media.user')))
      }.scrollable(false) // 禁止滑动切换
    }
    .width('100%')
    .height('100%')
  }

  // 自定义导航页签的样式
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#28bff1' : '#8a8a8a')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.controller.changeIndex(this.currentIndex)
    })
  }
}