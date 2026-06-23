import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import PreferencesUtils from '../utils/PreferencesUtils';
import ThemeManager from '../utils/ThemeManager';
import BreakpointSystem from '../utils/BreakpointSystem';

// 页面信息接口
interface PageInfo {
  currentPage: string;
  pageParams: Record<string, string | number | boolean | null | undefined>;
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 页面初始化
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 创建首选项数据库
    PreferencesUtils.createPreferences(this.context);
    // 初始化主题管理器
    ThemeManager.init(this.context);
  }

  onDestroy(): void {
    // 系统资源的释放、数据的保存等
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    // 设置WindowStage的事件订阅（获焦/失焦、可见/不可见）
    // 设置UI界面加载
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      
      // 初始化断点系统
      windowStage.getMainWindow((err, windowClass) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to get main window. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        // 注册断点监听
        BreakpointSystem.register(windowClass);
        hilog.info(0x0000, 'testTag', 'Breakpoint system initialized');
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    // 释放UI界面资源
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    
    // 注销断点监听
    BreakpointSystem.unregister();
  }

  onForeground(): void {
    // Ability has brought to foreground
    // 申请系统需要的资源，或者重新申请在onBackground中释放的资源
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    // 释放UI界面不可见时无用的资源，或者在此回调中执行较为耗时的操作
    // 例如状态保存等
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // 自由流转：保存应用状态
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onContinue');
    
    try {
      // 获取当前页面栈信息
      const currentPageInfo = this.getCurrentPageInfo();
      
      // 保存应用状态到wantParam中
      wantParam['currentPage'] = currentPageInfo.currentPage;
      wantParam['pageParams'] = currentPageInfo.pageParams;
      wantParam['timestamp'] = new Date().getTime();
      
      hilog.info(0x0000, 'testTag', 'Save migration data: %{public}s', JSON.stringify(wantParam));
      
      // 返回成功，表示允许迁移
      return AbilityConstant.OnContinueResult.AGREE;
    } catch (err) {
      hilog.error(0x0000, 'testTag', 'Failed to save migration data: %{public}s', JSON.stringify(err) ?? '');
      // 返回拒绝，表示不允许迁移
      return AbilityConstant.OnContinueResult.REJECT;
    }
  }

  // 自由流转：恢复应用状态
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onNewWant');
    
    // 检查是否为迁移请求
    if (want.parameters && want.parameters['ability.params.continuation']) {
      hilog.info(0x0000, 'testTag', 'This is a continuation request');
      
      // 获取迁移数据
      const continuationData = want.parameters['ability.params.continuation'] as Record<string, Object>;
      if (continuationData) {
        hilog.info(0x0000, 'testTag', 'Continuation data: %{public}s', JSON.stringify(continuationData));
        
        // 保存迁移数据到全局状态，供页面恢复使用
        this.saveContinuationData(continuationData);
      }
    }
    
    // 调用父类方法
    super.onNewWant(want, launchParam);
  }

  // 获取当前页面信息
  private getCurrentPageInfo(): PageInfo {
    // 这里需要根据实际应用结构获取当前页面信息
    // 由于知乎日报应用使用Navigation进行页面导航，我们需要获取当前页面路由
    // 这里简化处理，实际应用中需要根据路由栈获取当前页面信息
    return {
      currentPage: 'Index', // 默认首页
      pageParams: {} as Record<string, string | number | boolean | null | undefined>
    };
  }

  // 保存迁移数据到全局状态
  private saveContinuationData(data: Record<string, Object>): void {
    // 使用Preferences保存迁移数据，供页面恢复时使用
    PreferencesUtils.savePreferences('continuation_data', JSON.stringify(data));
    hilog.info(0x0000, 'testTag', 'Continuation data saved to preferences');
  }

  // 窗口阶段恢复（迁移时调用）
  onWindowStageRestore(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageRestore');
    
    // 迁移时不会调用onWindowStageCreate，而是调用onWindowStageRestore
    // 在这里恢复UI状态
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content during restoration.');
      
      // 初始化断点系统
      windowStage.getMainWindow((err, windowClass) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to get main window. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        // 注册断点监听
        BreakpointSystem.register(windowClass);
        hilog.info(0x0000, 'testTag', 'Breakpoint system initialized during restoration');
      });
    });
  }
}
