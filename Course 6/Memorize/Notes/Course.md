[TOC]

# Course 1
## 计算属性
每次调用都会执行花括号中的内容
```Swift
var body: some View {
    // do something
}
```

## 语法糖
1. Return的省略：当仅有一个方法时，return可省略
2. 尾随闭包：当最后一个参数是{}时，可以将其放在外面
3. 括号的省略：若尾随闭包后没有任何参数，小括号可以省略
```Swift
var body: some View {
    return HStack(content:{ })
}
```
```Swift
var body: some View {
    HStack(){ }
}
```
```Swift
var body: some View {
    HStack{ }
}
```

## 父元素修饰
类似于CSS
1. 对父元素本身进行修饰，比如``padding``
2. 对父元素本身没有修饰，但会对其所有子元素生效，比如``foregroundColor``
```Swift
.padding() // padding在ZStack周围增加了间距
.foregroundColor(Color.orange) // foregroundColor对ZStack没有意义，所以向内传递至ZStack内的所有元素
```

# Course 2
## MVVM
### 什么是MVVM
![MVVM](https://iamxz-net.oss-cn-hangzhou.aliyuncs.com/share/Google%20Chrome2021-03-16%20at%2019.33.33.png)

## 类型
### Struct/Class 结构体/类
#### 共同点
1. stored vars
2. computed vars
3. constant lets
4. function
5. initializers(special function)
#### 不同点
![Difference between Struct and Class](https://iamxz-net.oss-cn-hangzhou.aliyuncs.com/share/Google%20Chrome2021-03-16%20at%2019.49.52.png)

### Generic 泛型
下面代码中的Element就是泛型
```Swift
struct Array<Element> {
    ...
    func append(_element):Element{...}
}
```
调用含有泛型的结构体
```Swift
var a = Array<Int>()
```

### Function 函数
下面代码中的operation的类型就是Function
```Swift
var operation:(Double) -> Double

func square(operand:Double) -> Double{
    return operand*operand
}
operation = square
let result = operation(4) //16 
```
### Class 属性
1. ``private(set) var`` 只读
2. ``private var`` 完全私有，不可读写
3. ``var ``公开

## Course 4
### Optional 本质就是个 enum
```Swift
enum Optional<T> {
    case none
    case some<T>
}
```
注意``var hello: String?`` 中的hello是optional类型，关联的类型是String。而不是说它是String类型，被修改成了可选的String

## Course 6
### Animation
- 显式动画： ``withAnimation()``
- 隐式动画（自动动画）： ``.animation()``

1. 动画发生在``Shape``和``ViewModifier``
2. 隐式动画优先级高于显式动画
3. 只有显式动画能和Transition一同使用。Transition修饰符的意义是给View设置一个进入/退出时的View，如果不和Animation一同使用，Transition没有任何效果
4. 只有已经出现在屏幕上的元素发生变化时，才会出现动画效果。如果希望给进入/退出调用动画，需要使用Transition。如果不适用于Transition，可以尝试使用opacity将元素隐藏，

### Transition 和 Animation
``.transition()``作用于``ZStack``等时，并不向内分发，只对父元素生效。但作用于``Group``和``ForEach``时，向内分发，对其内部子元素生效
``.animation()``作用于任何ViewContainer都向内分发，对其内部子元素生效

### AnimatableModifier
``Animation``会自动监控内部的每一个变化，并施加动画效果。

如果不想给每一个变化都施加动画，可以使用``AnimatableModifier``协议，这一协议相当于“自定义动画”。``AnimatableModifier``中只有声明在``animatableData``中的变量变化时，才会有动画效果
