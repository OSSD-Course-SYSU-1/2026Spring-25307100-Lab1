import Home from "../pages/home/Home"
import ZhiHu from "../pages/zhihu/Zhihu"
import Mine from "../pages/mine/Mine"
import ThemeManager from "../utils/ThemeManager"
import { ThemeIconButton } from "../components/ThemeToggle"
import { BreakpointConstants } from "../utils/BreakpointSystem"


@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State isDarkMode: boolean = ThemeManager.isDarkMode()
  @StorageProp(BreakpointConstants.CURRENT_BREAKPOINT_KEY) currentBreakpoint: string = BreakpointConstants.BREAKPOINT_NAMES[0]
  @StorageProp(BreakpointConstants.WINDOW_WIDTH_KEY) windowWidth: number = 360
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

  aboutToAppear() {
    // 监听主题变化
    ThemeManager.addThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  aboutToDisappear() {
    // 清理监听器
    ThemeManager.removeThemeChangeListener((theme: string) => {
      this.isDarkMode = theme === 'dark';
    });
  }

  // 判断是否为大屏设备
  private isLargeScreen(): boolean {
    return this.currentBreakpoint === BreakpointConstants.BREAKPOINT_NAMES[2] || 
           this.currentBreakpoint === BreakpointConstants.BREAKPOINT_NAMES[3]; // lg 或 xl
  }

  // 获取导航模式
  private getNavigationMode(): NavigationMode {
    return this.isLargeScreen() ? NavigationMode.Split : NavigationMode.Stack;
  }

  // 小屏布局：底部标签栏
  @Builder
  buildSmallScreenLayout() {
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
      }
      .scrollable(false) // 禁止滑动切换
    }
    .width('100%')
    .height('100%')
  }

  // 大屏布局：侧边栏 + 内容区
  @Builder
  buildLargeScreenLayout() {
    Row() {
      // 侧边栏导航
      Column() {
        // 导航标题
        Text('导航')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeManager.getTextPrimaryColor())
          .margin({ top: 20, bottom: 20, left: 16 })
          .alignSelf(ItemAlign.Start)
        
        // 导航项
        Column({ space: 8 }) {
          this.buildSidebarItem('首页', 0, $r('app.media.icon_sort'))
          this.buildSidebarItem('日报', 1, $r('app.media.search_select'))
          this.buildSidebarItem('我的', 2, $r('app.media.user_selected'))
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .width(240)
      .height('100%')
      .backgroundColor(ThemeManager.getCardBackgroundColor())
      .border({ width: { right: 1 }, color: ThemeManager.getDividerColor() })

      // 内容区域
      Column() {
        if (this.currentIndex === 0) {
          Home()
        } else if (this.currentIndex === 1) {
          ZhiHu()
        } else {
          Mine()
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  // 侧边栏导航项构建器
  @Builder
  buildSidebarItem(title: string, index: number, icon: Resource) {
    Row({ space: 12 }) {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? ThemeManager.getPrimaryColor() : ThemeManager.getTextSecondaryColor())
      
      Text(title)
        .fontSize(16)
        .fontColor(this.currentIndex === index ? ThemeManager.getPrimaryColor() : ThemeManager.getTextSecondaryColor())
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .width('100%')
    .height(48)
    .padding({ left: 12, right: 12 })
    .backgroundColor(this.currentIndex === index ? 
      ThemeManager.getPrimaryColor().concat('10') : 'transparent')
    .borderRadius(8)
    .onClick(() => {
      this.currentIndex = index;
    })
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('知乎日报')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeManager.getTextPrimaryColor())
          .layoutWeight(1)
          .margin({ left: 16 })
        
        // 主题切换按钮
        ThemeIconButton({ isDarkMode: $isDarkMode })
          .margin({ right: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor(ThemeManager.getTabBarBackgroundColor())
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      // 主内容区域 - 根据屏幕尺寸选择布局
      if (this.isLargeScreen()) {
        // 大屏布局：侧边栏 + 内容区
        this.buildLargeScreenLayout()
      } else {
        // 小屏布局：底部标签栏
        this.buildSmallScreenLayout()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeManager.getBackgroundColor())
  }

  // 自定义导航页签的样式
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
        .fillColor(this.currentIndex === targetIndex ? ThemeManager.getPrimaryColor() : ThemeManager.getTextSecondaryColor())
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? ThemeManager.getPrimaryColor() : ThemeManager.getTextSecondaryColor())
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