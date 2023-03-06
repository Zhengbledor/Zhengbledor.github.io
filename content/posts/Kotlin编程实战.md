+++
title = "Kotlin编程实战-阅读记录"
date = "2023-03-06"
+++
# Kotlin编程实战

## 第2章 从Java角度了解Kotlin的基本知识

### 2.1 减少输入

* 分号是可选的

* 变量类型规范是可选的

* 类和函数是可选的

  函数可以在类外面执行

  **下面的脚本包含一个不属于任何类的函数和一些不属于任何函数的独立代码。**

  ``kotlin/standalone.kts``

  ```kotlin
  fun nofluff(){
    println("nofluff called")
    
    throw RuntimeException("oops")
  }
  
  println("no in a function, calling nofluff()")
  
  try{
    nofluff()
  }catch(ex: Exception){
    val stackTrace = ex.getStackTrace()
    println(stackTrace[0])
    println(stackTrace[1])
  }
  
  
  
  // 打印结果
  no in a function, calling nofluff()
  nofluff called..
  Standalone.nofluff(...)
  Standalone.<init>(...)
  ```

  Kotlin悄悄将函数nofluff()转换成一个名为Standalone的合成类的方法（通过文件名推断出的名称）

  将独立代码转换为类的构造函数，输出了``<init>``

* try-catch是可选的

### 2.2 合理的警告

### 2.3 选择val而不是var

### 2.4 改进的相等性检查

Java中的equals()，或者Kotlin中的==运算符，是值的比较，称为结构相等。

Java中的==运算符，或者Kotlin中的===，是引用的比较。

### 2.5 字符串模板

``val message = "The factor is $factor"``

### 2.6 原始字符串

```kotlin
// 通过三个双引号来实现原始字符串
val escaped = "The kid asked, \"How's it going, $name?\""
val raw = """The kid asked, "How's it going, $name""""

// 通过三个双引号实现多行字符串
// one （缩进也会同时打印出来）
val memo = """Dear $name,
							How it going.
							I am missing you."""

// two
val memo = """Dear $name,
							|How it going.
							|I am missing you."""
memo.traimMargin()

// three
val memo = """Dear $name,
							~How it going.
							~I am missing you."""
memo.traimMargin("~")
```

### 2.7 更多表达式

## 第3章 使用函数

Java中，类是最小的可重用的部分。Kotlin采用一种非常实用的方法来创建高质量的代码——在合适 的地方，创建小且简单的独立函数，并在必要时将代码放入类的方法 中。

### 3.1 创建函数

* KISS函数

  Kotlin遵循“保持简单和愚蠢”的KISS(Keep it simple, stupid.)原则来定义函数。小函数应该写起来简单，不混乱，没有小 错误。

* 返回类型和类型推断

  在写没有非块体的函数时，可以不声明返回值。

  ```kotlin
  fun greet() = "Hello"
  ```

* 所有的函数都是表达式

  Kotlin使用一种称为Unit的特殊类型，其对应于Java的void类 型。Unit这个名字来自类型理论，它表示一个不包含任何信息的单 例。你可以始终使用Unit来指定不返回任何有用的内容。此外，如果 函数没有返回任何内容，Kotlin将把类型推断为Unit。

* 定义参数

  形式 ``candidate : Type``

  ```kotlin
  fun greet(name: String): String = "Hello $name"
  ```

  在函数或方法中更改参数值的任何努力都将导致编译错误。

* 带有块体的函数

  ```kotlin
  fun max(numbers: IntArray): Int{
    var large = Int.MIN_VALUE
    for(number in numbers){
      large = if(number > large) number else large
    }
    return large
  }
  ```

  需要注意的一点是，不要使用后面跟着块体{}的=。如果显式地指定返回类型，并在其后面加上=，然后是块体，编译器将会报错。

  如果省略了返回类型，但使用了=，然后是一个块体而不是单表达式。

  ```java
  fun notReally()={2}
  ```

  Kotlin不会通过进入代码块来推断返回类型。但是，它将假设整 个块是一个lambda表达式或一个匿名函数

  ```kotlin
  fun f1() = 2
  fun f2() = {2}
  fun f3(factor: Int) = {n:Int -> n * factor }
  
  printfln(f1())  //2
  printfln(f2())  //->Kotlin.Int
  printfln(f2()()) //2
  printfln(f3(2))  //(Kotlin.Int) -> Kotlin.Int
  printfln(f3(2)(3)) //6
  ```

### 3.2 默认参数和命名参数

* 演化带有默认参数的函数

  ```kotlin
  fun greet(name: String, msg: String = "Hello"): String = "$msg $name"
  ```

  具有默认参数的参数放置在常规参数(即没有默认参数的参数)之后。

  默认参数不必是字面量，它可以是表达式。另外，可以使用参数
  左边的参数计算参数的默认参数。

  ```kotlin
  fun greet(name: String, msg: String = "Hi ${name.length}") = "$msg $name"
  ```

* 使用命名参数提高可读性

### 3.3 Vararg和Spread

像println()这样的函数接受可变数量的参数。Kotlin的vararg特 性提供了一种类型安全的方法来创建可以接收可变数量参数的函数。 spread(伸展)运算符用于将集合中的值展开或扩展为离散参数。

* vararg

  在Kotlin中，函数可以接受可变数量的实参。

  ```kotlin
  fun max(vararg numbers: Int):Int{
    var large = Int.MIN_VALUE
    for(number in numbers){
      large = if(number > large) number else large
    }
    return large
  }
  ```

  但是当一个函数同时接受多个参数 时，你可以使用vararg。但是只有一个参数可以注释为vararg。

  ```kotlin
  fun greetMany(msg: String, vararg names: String){
    println("$msg ${names.joinToString(",")}")
  }
  ```

  vararg参数不必是末尾的参数，但是我强烈建议要这样做。

* spread运算符 *

  有时我们可能希望将数组或列表中的值 传递给具有vararg的函数。即使函数可以接受可变数量的参数，也不 能直接发送数组或列表。

  ```kotlin
  val values = intArrayOf(1,2,3)
  println(max(values)) // ERROR!!!
  
  println(max(*values)) // 3
  ```

  通过在参数前面放置一个*，要求Kotlin将该数组中的 值作为vararg参数的离散值来展开。不需要编写冗长的代码，vararg 与spread的结合很和谐。

### 3.4 解耦

```kotlin
fun getFullName() = Triple("A","B","C")

// BAD
val result = getFullName()
val first = result.first;
val middle = result.second;
val last = result.third;

// GOOD
val (first, middle, last) = getFullName()

println("$first $middle $last") //"A B C"
```

getFullName()函数似乎突然返 回了多个值——这是一种错觉。因为Triple类有专 门的方法来帮助进行解构.

假设我们不关心返回对象的某个属性。例如，如果我们不想要中 间的名字，可以使用下划线(_)来跳过它。

```kotlin
val (first, _, last) = getFullName()
```

## 第4章 外部迭代和参数匹配

Kotlin提供了用于命令式编程风格的外部迭代器和用于函数式编 程风格的内部迭代器。对于外部迭代，作为程序员，你可以显式地控 制迭代的顺序。内部迭代负责排序，让程序 员专注于每个迭代的操作或计算，从而减少代码和错误。

### 4.1 迭代与范围

* 范围类

  ```kotlin
  val oneToFive: IntRange = 1..5
  val aToE: CharRange = 'a'..'e'
  val seekHelp: CloaseRange<String> = "hell".."help"
  
  println(seekHelp.contains("helm"))//false
  println(seekHelp.contains("helq"))//true
  ```

* 正向迭代

  ```kotlin
  for(i in 1..5){print("$i")} //12345
  for(ch in 'a'..'e'){print("$ch")}//abcde
  for(word in "hell".."help"){print("$word")}// ERROR!
  ```

  失败的原因是，虽然像IntRange和CharRange这样的类有 iterator()函数/运算符，而它们的基类ClosedRange<T>没有。

* 反向迭代

  ```kotlin
  for(i in 5.downTo(1)){print("$i")}//54321
  for(i in 5 downTo 1){print("$i")}//54321
  ```

* 跳过范围值的内容

  ```kotlin
  for(i in 1 until 5){print("$i")}//1234
  ```

  使用until()创建的迭代不包括最后一个值5，而我们之前使用.. 创建的范围会包括。

  ```kotlin
  for(i in 1 until 10 step 3){print("$i")}//147
  ```

  step()方法将使用..、until、downTo等创建的IntRange或 IntProgression转换为跳过某些值的IntProgression。让我们使用 step()来反向迭代，同时跳过一些值:

  ```kotlin
  for(i in (1..9).filter{ it % 3 == 0 || it % 5 == 0}){
    print("%i")
  }// 3569
  ```

  filter()方法接受一个断言(一个lambda表达式)作为参数。

### 4.2 遍历数组和列表

```kotlin
for(e in array){
  
}

for(index in array.indicaes){
  
}

for((index, e) in array.withIndex()){
  
}
```

### 4.3 when

```kotlin
fun isAlive(alive: Boolean, number:Int) = when{
  number < 2 ->false
  number >3 ->false
  number ==3 ->true
  else -> alive && number == 2
}
```



## 第5章 使用集合

### 5.1 集合的类型

* Pair

  ```kotlin
  "abc" to "cde" // Pair("abc","cde")
  ```

* Triple

* Array

  ``Array<T>``类在Kotlin中表示一个值数组。创建数组的最简单的方法是使用顶级函数arrayOf()。一旦创建了 数组，就可以使用index[]运算符来访问元素。

  对象的类型是 ``Kotlin.Array``，即``Array<T>``，但在JVM上运行时，底层的实际类型是一 个Java字符串数组。

  在创建数组时，不必将值写死，如果愿意，还可以计算值。

  ```kotlin
  println(Array(5){i -> (i+1)*(i+1)}.sum) //55
  ```

* List

  作为创建列表的第一步，Kotlin希望你声明意图——不可变的或 可变的。要创建一个不可变列表，需要使用listOf()，不可变是隐含 的，当有选择的时候，这也是我们的首选。但是如果你真的需要创建 一个可变列表，那么使用mutableListOf()。

* Set

  Set是元素的无序集合。

  可以使用``setOf()``创建``Set<T>``的实例，或 者使用``mutableSetOf()``创建``MutableSet<T>``的实例。你还可以使用`` hashSetOf()``来获取``LinkedHashSet``的类型``java.util.HashSet<T>: linkedSetOf()``的引用和``TreeSet<T>``的``sortedSetOf()``引用。

* Map

  映射保存键–值对的集合。

  你可以使用``mapOf()``创建映射并获取对只读接口``Map<K, V>``的引 用。或者，使用``mutableMapOf()``访问``MutableMap<K, V>``。另外，你可 以使用``hashMapOf()``获得对JDK ``HashMap``的引用，使用``linkedMapOf()``获 得对``LinkedHashMap``的引用，使用``sortedMapOf()``获得对``SortedMap``的引 用。



## 第6章 使用类型安全性解决问题

### 6.1 Any和Nothing

* Any是基类

  Kotlin中所有的类都继承自Any

* Nothing

  在Java等语言中，我们使用void表示方法不返回任何东西。但是 在Kotlin中，使用Unit来告诉我们什么时候函数(也就是表达式)没 有返回任何有用的东西。

  但是也有一些情况，一个函数实际上什么也 没有返回，这就是Nothing类出现的地方。Nothing类没有实例，它表 示一个永远不存在的值或结果。

  当用作方法的返回类型时，这意味着 函数永远不会返回——**函数调用只会导致异常**。

  ```kotlin
  fun computeSqrt(n: Double):Double{
    if(n>=0){
      return Math.sqrt(n)
    }else{
      throw RuntimeException("No negative please")
    }
  }
  ```

  if部分返回一个Double，而else部分抛出一个异常。异常部分由 类型Nothing表示。

  因此，Nothing的唯一目的是能够帮助编译器 验证程序中类型的完整性是健全的。

### 6.2 范型：参数类型的变化和约束

* 类型不变型

  ```kotlin
  open class Fruit
  class Banana : Fruit()
  class Orange : Fruit()
  
  
  // Array<T>是不可变的
  fun receiveFruits(fruits: Array<Fruit>){
    // do sth
  }
  
  val bananas: Array<Banana> = arrayOf()
  receiveFruits(bananas) // ERROR: Type mismatch
  
  
  
  // List<T>是可变的
  val receiveFruitsList(fruits: List<Fruit>){
    // do sth
  }
  
  val bananasList:List<Banana> = ListOf()
  receiveFruitsList(bananasList) //OK
  ```

  如果想要往``Array<Fruit>``传入Banana，则需要做一些改变

  语法``Array<out Fruit>``用于传递Fruit参数类型的协变。 Kotlin将断言没有对允许传入数据的from引用进行任何方法调用。 Kotlin将通过检查被调用方法的签名来确定这一点。

  ``Array<T>``类具有读取和设置类型为T的对象的方法。任何使用`` Array<T>``的函数都可以调用这两种方法中的任何一种。但要使用协 变，我们向Kotlin编译器保证，不会调用任何方法，来对``Array<T>``发 送具有给定参数类型的任何值。

  这种在使用泛型类时使用协变的行为 称为“使用点型变”或“类型预测”。

* 协变

  ```kotlin
  Array<out Fruit>
  ```

* 逆变

  ```kotlin
  Array<in Fruit>
  ```

* 使用where的参数类型约束

  ```kotlin
  fun <T> useAndClose(input: T){
    where T: AutoCloseable,
    			T: Appendable{
            input.append("aa")
            input.close()
          }
  }
  ```

* 星投影

  当你想表达对类型不太了解但又希望类型安全时，请使用星投影。星投影只允许读出，不允许写入。

  ```kotlin
  fun printValues(values: Array<*>){
    for(value in values){
      println(value)
    }
    
    // values[0] = values[1] //ERROR!!
  }
  ```

  这里的星 投影``<*>``，相当于``out T``，但写起来更简洁。

  如果将星投影用于逆变参数(其在“声明点型变”中被定义为``<in T>``)，那么它就相当于``in Nothing``，以强调编写任何内容都会导致编译错误。

### 6.3 具体化的类型参数