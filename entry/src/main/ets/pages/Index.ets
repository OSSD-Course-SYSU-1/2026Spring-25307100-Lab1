import {getSwiperList,getHotMovie} from "../common/api/home"
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ErrorResponse } from '../common/bean/ApiTypes';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
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

  // 组件生命周期
  aboutToAppear() {
    console.info('MyComponent aboutToAppear');
  }

  // 组件生命周期
  aboutToDisappear() {
    console.info('MyComponent aboutToDisappear');
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('test')
          .onClick(() => {
            console.info('button click');
            getSwiperList().then((res) => {
              hilog.debug(0x0000,"request",res.data.message)
              hilog.debug(0x0000,"request","res.data.code:%{public}d",res.data.code)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].id)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].imageUrl)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].title)
            }).catch((err:ErrorResponse) => {
              hilog.debug(0x0000,"request","err.data.code:%d",err.code)
              hilog.debug(0x0000,"request",err.message)
            });

            getHotMovie({start:0,count:1,city:"郑州"}).then((res) => {
              hilog.debug(0x0000,"request",res.data.message)
              hilog.debug(0x0000,"request","res.data.code:%{public}d",res.data.code)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].id)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].gener)
              hilog.debug(0x0000,"request","res.data.data[0]:%{public}s",res.data.data[0].title)
            }).catch((err:ErrorResponse) => {
              hilog.debug(0x0000,"request","err.data.code:%d",err.code)
              hilog.debug(0x0000,"request",err.message)
            });
          })
      }
      .height('100%')
      .width('100%')
    }
  }
}