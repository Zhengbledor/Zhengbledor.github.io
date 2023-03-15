+++
title = "Kotlin编程实战-阅读记录-第四部分"
date = "2023-03-15"
+++
# Kotlin编程实战-第四部分

## 第四部分 优雅且高效的Kotlin

## 第12章 Kotlin的流畅性

### 12.1 重载运算符

```kotlin
operator fun Pair<Int, Int>.plus(other: Pair<Int,Int>) =
	Pair(first + other.first, second + other.second)
```

### 12.2 使用扩展函数和属性进行注入

```kotlin
fun Circle.contains(point:Point) = 
	(point.x - cx)*(point.x - cx) + (point.y -cy)*(point.y-cy) < radius*radius

circle.contains(point1)
```

扩展函数有一些限制。当扩展函数和同名的实例方法之间发生冲突时，实例方法总是获胜。

同时可以通过扩展函数注入运算符

```kotlin
operator fun Circle.contains(point:Point) = 
	(point.x - cx)*(point.x - cx) + (point.y -cy)*(point.y-cy) < radius*radius

point1 in circle
```

可以使用扩展属性去注入属性

```kotlin
val Circle.area: Double
	get() = Kotlin.math.PI * radius *radius
```

如果类有伴生对象时，可以注入静态方法

```kotlin
fun String.Companion.toURL(link: String) = java.net.URL(link)

val url: java.net.URL = String.toURL("sss")
```

#### 12.4 带中缀的函数流畅性

```kotlin
operator infix fun Circle.contains(point: Point) = ..

println(circle contains point)
```

Kotlin为中缀函数提供了一些灵活性，但也有一些限制:中缀方法只能接受一个参数——没有vararg(可变参数)，也没有默认参数。

#### 12.5 带Any对象的流畅性

infix减少了一些混乱，但是当处理Any对象时，Kotlin使代码更简洁，更具表现力。

具体来说，Kotlin有四个重要的方法可以使代码更加流畅:also()、apply()、let()和run()。

| 函数名 |                             定义                             |       参数       |   返回值 | extension |               其他 |
| ------ | :----------------------------------------------------------: | :--------------: | -------: | --------: | -----------------: |
| let    |          fun <T, R> T.let(f: (T) -> R): R = f(this)          |        it        | 闭包返回 |        是 |                    |
| apply  |   fun <T> T.apply(f: T.() -> Unit): T { f(); return this }   | 无，可以使用this |     this |        是 |                    |
| with   | fun <T, R> with(receiver: T, f: T.() -> R): R = receiver.f() | 无，可以使用this | 闭包返回 |        否 | 调用方式与其他不同 |
| run    |           fun <T, R> T.run(f: T.() -> R): R = f()            | 无，可以使用this | 闭包返回 |        是 |                    |

总结

* 所有四个方法都执行传递给他们的lambda
* let和run执行lambda并将lambda的结果返回
* also和apply忽略lambda的结果，而是将本身返回给调用方
* run和apply在调用他们的context对象的上下文this

#### 12.6 隐式接收方

```kotlin
val printIt: String.(Int) -> Unit = {n: Int ->
   println("n is $n, length is $length")
}

// 接收方作为第一个参数，lambda参数紧跟其后
printIt("hello",6)

// 作为扩展函数
"hello".printIt(6)
```

## 第13章 创建内部DSL

### 13.1 DSL的类型和特征

在设计时，你必须在外部DSL和内部DSL之间做出选择。

如果你选择创建一个外部DSL，那么你可以享受到更大的自由，但是你需要负责创建解析器来解析和处理DSL。

你可以在宿主语言的范围内设计一个内部或嵌入式DSL。语言的编译器和工具充当解析器。

### 13.2 用于内部DSL的kotlin

Kotlin是一种非常适合创建内部DSL的语言。静态类型通常会对语言作为内部DSL宿主的能力造成很大的限制。

* 分号可选

* 点和圆括号不与中缀在一起``starts at 14.30`` or ``starts.at(14.30)``

* 使用扩展函数获得特定的域

  尽管Kotlin是静态类型的，但它允许执行编译时函数注入。因此，你可以通过向Int中注入days()这样的函数来为库函数的使用者设计如下代码。

  ```kotlin
  2.days(ago)
  
  // 如果使用infix关键字
  2 days ago
  ```

* 传递lambda不需要圆括号

  ```kotlin
  "Planning".meeting({
    starts.at(14.30)
    ends.by(15.20)
  })
  
  "Planning" metting {
    starts at 14.30
    ends by 15.20
  }
  
  
  // 创建
  class Metting(val title:String){
    var startTime = ""
    var endTime = ""
    val start = this
    val end = this
    private fun convertToString(time: Double) = String.format("$0.2f", time)
    fun at(time: Double){ startTime = convertToString(time) }
    fun by(time: Double){ endTime = convertToString(time) }
  }
  
  infix fun String.metting(block:Metting.()->Unit){
    val metting = Metting(this)
    metting.block()
  }
  ```

* 隐式接收方影响DSL的创建

  Kotlin在设计DSL时最重要的特性之一是能够将隐式接收方传递给lambda表达式

  ```kotlin
  placeOrder{
    an item "pencil"
    an item "eraser"
    complete{
      this with creaditcard number "123-5678-9100"
    }
  }
  ```

## 第14章 编写递归和记忆

