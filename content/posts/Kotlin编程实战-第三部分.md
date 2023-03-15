+++
title = "Kotlin编程实战-阅读记录-第三部分"
date = "2023-03-15"
+++
# Kotlin编程实战-第三部分

## 第三部分 函数式Kotlin

## 第10章 使用lambda进行函数式编程

### 10.2 lambda表达式

lambda表达式是没有名称的函数，其返回类型是推断的。

通常一个函数有四个部分:名称、返回类型、参数列表和主体。

lambda只保留函数最重要的部分——参数列表和主体。

```kotlin
{ parameter list -> body }
```

lambda被包裹在{}中。使用连字符箭头(->)把主体与参数列表分开，主体通常是单个语句或表达式，但也可以是多行。但是尽量只使用单行语句。

```kotlin
fun isPrime(n: Int) = n>1 && (2 until n).none{ n % it == 0}
```

如果传递给函数的lambda只接受一个参数，那么我们可以省略参数声明，而使用一个特殊的隐式名称it。

**接受lambda**

现在让我们看看如何创建一个接收lambda的函数。

```kotlin
fun walkTo(action: (Int)->Unit, n: Int) = (1..n).forEach{ action(it) }
```

在Kotlin中，对于参数，我们先指定变量名，然后是类型，比如n: Int。这种格式也用于lambda参数。

**把lambda作为最后一个参数传递**

修改一下上面这个代码参数的顺序

```kotlin
fun walkTo(n: Int, action: (Int)->Unit) = (1..n).forEach{ action(it) }


walkTo(5){print(it)}
```

**使用函数引用**

```kotlin
({x -> someMethod(x)})

// 可以替换为
(::SomeMethod)

// 如果传递到另一个lambda中，可以省略::
(someLambda)

fun walkTo(n: Int,action: (Int)->Unit) = (1..n).forEach{action(it)}
fun walkTo(n: Int,action: (Int)->Unit) = (1..n).forEach(action)

walkTo(5){System.out.print(it)}
walkTo(5,System.out::print)
```

### 10.6 带有lambda的内联函数

你可以使用inline关键字来提高接收lambda的函数的性能。

如果一个函数标记为inline，那么该函数的字节码将在调用位置置为内联，而不是调用该函数。

```kotlin
inline fun invokeTwo(
	n: Int,
  action1: (Int) -> Unit,
  action2: (Int) -> Unit,
): (Int) -> Unit{
  
}
```

同时可以对参数进行指定不要inline

```kotlin
inline fun invokeTwo(
	n: Int,
  action1: (Int) -> Unit,
  noinline action2: (Int) -> Unit,
): (Int) -> Unit{
  
}
```

## 第11章 内部迭代和延迟计算

#### 11.1 内部迭代

内部迭代涉及许多专用的工具，如filter()、map()、flatMap()、reduce()等等。

filter()返回的集合的大小从0到n不等，其中n是原始集合中的元素数。结果是一个子集合也就是说，输出集合中的值是原始集合中的值。

map()返回集合的大小与原始集合的大小相同。传递给map()的lambda应用于原始集合中的每个元素，结果是这些转换后的值的集合。

reduce()的lambda接受两个参数。第一个参数是一个累计值，第二个参数是来自原始集合的一个元素。lambda的结果是新的累计值。reduce()的结果是最后一次调用lambda的结果。



#### 11.3延迟计算序列

简单地说，集合是急切的，而序列是懒惰的。

我们可以使用asSequence()方法将一个集合包装成一个序列，然后应用我们在集合上使用的相同的内部迭代器方法，但这次是在序列上使用。

```kotlin
val nameOfFirstAudlut = people.asSquence()
	.filter(::isAdult)
	.map(::fetchFirstName)
	.first()
```

