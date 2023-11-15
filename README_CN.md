提供共享状态的能力. 便于多工程依赖处理(DI), 解耦不必要的子项目依赖. 以及多生命周期共享状态

## 功能

1. 多生命周期状态共享: 比如flutter多个page间互相读写信息 或 分属两个项目但需要共享信息
2. 监听特定状态的改变: 比如有一个是否登录的状态, 所有需要关注的都`listen`这个事件
3. 解耦具体的依赖实现: 比如`模块sub A`需要提供拉起某广告的能力, 但开发阶段必须要真的接入或者有多个广告厂商均可供选择, 具体用哪个是调用方`模块S`确定的, 就可以通过`模块sub A`声明接口,`模块S`直接注入实现

## 如何引入

纯`dart 3`项目, 没有多余的依赖, 直接在`pubspec.yaml`加入依赖即可
```yaml
dependencies:
  shared_state: ^${latestVersion}
```

## 如何使用

### 基础使用

赋值与读取

```dart
const key = 'some awesome key';
SharedState().set<String>(key, 'my great value');

final v = SharedState().get<String>(key);
if (v != null) {
  // using my great value
}

// cleanup
SharedState().invalid(key);
```

订阅更新

```dart
const loginStatusKey = 'login_status';

// register event change
SharedState().onKeyChange<bool>(loginStatusKey).listen((event) {
  // got status changed
  if (event == true) {
    // value set to true
  }
  else if (event == false) {
    // value set to false
  }
  else {
    // value was set to null
  }
});

SharedState().set<bool>(loginStatusKey, false);
```

### 依赖注入

```dart
// submodule A
const String incrementorKey = 'Incrementor';

abstract interface class Incrementor { 
  void increment();
  int get value;
}

class IncrementorUsageClass {
  void foo() {
    // fetch implementation from shared state
    final incrementor = SharedState().get<Incrementor>(incrementorKey);
    if (incrementor != null) {
      print('value: ${incrementor.value}');
    }
  }
}

// container/caller module
import 'submodule a';

void main() {
  SharedState().set<Incrementor>(incrementorKey, IncrementorImpl());

  final usageClass = IncrementorUsageClass();
  // call usage class here
  usageClass.foo();
}

class IncrementorImpl implements Incrementor {
  int _v;
  int get value => _v;
  void increment() {
    _v += 1;
  }
}

```

## 更多信息

⚠️注意: 不适用于多个`isolate`共享状态
