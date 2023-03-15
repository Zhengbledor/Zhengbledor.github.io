+++
title = "Kotlin编程实战-阅读记录-第二部分"
date = "2023-03-15"
+++
# Kotlin编程实战-第二部分

## 第二部分 面向对象的Kotlin

## 第7章 对象和类

Kotlin不需要类， 当顶级函数足够时，你可以使用它们。

### 7.1 对象和单例

* 带有对象表达式的匿名对象

  ```kotlin
  fun drawCircle(){
    val circle = object {
      val x = 10
      val y = 20
      val radius = 30
    }
  }
  ```
  在最基本的形式中，对象表达式是后跟一个块{}的关键字 object。

  匿名对象有以下几个限制

  * 匿名对象的内部类型不能作为函数或方法的返回类型。
  * 匿名对象的内部类型不能作用函数或方法的参数类型。
  * 如果他们作为属性存储在类中，他们将被视为Any类型，他们的任何属性或方法都将无法直接访问。

  **只需稍加修改，匿名对象就可以用作接口的实现者。**
  ```kotlin
  fun createRunnable():Runnable{
  val runnable = object: Runnable{
    override fun run(){....}
  }
  return runnable
  }
  ```
  如果通过匿名内部类实现的接口是单一抽象方法接口（只有一个需要实现的方法），那么我们可以直接提供实现，而不需要指定方法 名，如下所示:
  ```kotlin
  fun createRunnable():Runnable = Runnable{...}
  ```
  除了使用单一抽象方法实现语法外，在上面的示例中，通过删除块体和return关键字，将createRunnable()函数转换为简洁的单表达 式函数。
  
* 带有对象声明的单例

  如果在object关键字和块{}之间放置一个名称，那么Kotlin将认为定义是语句或声明，而不是表达式。

  使用一个对象表达式来创建一 个匿名内部类的实例，使用一个对象声明来创建一个单例——一个只有单个实例的类。

  ```kotlin
  object Util{
    fun numberOfProcessors() = Runtime.getRuntime().availableProcessors()
  }
  ```

  

* 顶级函数和单例

  如果一组函数是高级的、通用的和广泛使用的，那么就把它们直接放在一个包中。

  另一方面，如果一些函数之间的关系比其他函数更为密切，那么就把它们放在一个单例中。

  此外，如果一组函数需要依赖于状态，你可以将此状态与那些相关的函数一起放在一个单例中，尽管类对此可能是一个更好的选择。

### 7.2 创建类

当调用car.yearOfMake的时候，你实际上调用的是car.getYearOfMake()——编译器会遵循旧的JavaBean约定。

Kotlin会自动帮你所有的属性添加get和set方法

* 控制对属性的修改

  ```kotlin
  class Car{
    var color = Colors.white
    	set(value){
        if(value.isBlank()){
          throw RuntimeException("ss")
        }
        fileId = value
      }
  }
  ```

* 访问修饰符

  ```kotlin
  private var level = 1000
  
  var fuelLevel = 100
  	private set
  ```

  在kotlin中，类的属性和方法默认是public，可能的访问修饰符有public、private、protected和internal。

  前两个与Java中的含义相同。protected修饰符允许派生类的方法访问该属性。internal修饰符允许同一模块中的任何代码访问属性或方法，其中模块定义为一 起编译的所有源代码文件。

  internal修饰符没有直接的字节码表示。它由Kotlin编译器使用一些命名约定来处理，而不会带来任何运行时开销。

  对getter的访问权限与对属性的访问权限相同。如果你愿意，可以为setter提供不同的访问权限。让我们修改对fuelLevel的访问修饰符，使其只能从类中访问。

* 初始化代码

  一个类可以有零个或多个init块。这些块作为主构造函数执行的 一部分来执行。init块的执行顺序是自上而下的。在init块中，只能 访问已经在块上面定义的属性。因为在主构造函数中声明的属性和参 数在整个类中都是可见的，所以类中的任何init块都可以使用它们。 但是要使用在类中定义的属性，必须在该属性的定义之后编写init 块。

  ```kotlin
  class Car{
    var color = "1"
    init{
      color = "2"
    }
  }
  ```

* 二级构造函数

  如果不编写主构造函数，那么Kotlin将创建一个无参数的默认构 造函数。如果主构造函数对所有参数都有默认实参，那么除了主构造 函数之外，Kotlin还会创建一个无实参的构造函数。在任何情况下， 你都可以创建多个构造函数，称为二级构造函数。

  ```kotlin
  class Person{
    constructor(first: String, last: String){
      ..
    }
  }
  ```

### 7.3 伴生对象和类成员

```kotlin
class MachineOperator{
  companion object{
    var checkedIn = 0
    fun minimumBreak() = "abc"
  }
}

fun test(){
  MechineOperator.checkedIn;
  
}
```

在类中，使用这些关键字定义的伴生对象是嵌套的。在伴生对象中属性checkedIn成为MachineOperator的类级别属性。同样，方法minimumBreak不属于任何实例，它是类的一部分。

**可以使用class.Companion来获取类的同伴**

```kotlin
val ref = MachineOperator.Companion
```

当然可以给伴生同伴加上名字

```kotlin
companion object MachineOperatorFactory{
  ..
}


val ref = MachineOperator.MachineOperatorFactory
```

可以使用伴生对象来作为工厂，创建所属类的对象

```kotlin
companion object{
  fun create(){
    return MachineOperator()
  }
}


val ref = MachineOperator.create()
```

**伴生中的方法不是类的静态方法**

当你引用一个伴生对象的成员时，Kotlin编译器会负责将调用路 由到适当的单例实例。静态方法应该使用@JvmStatic注释

### 7.5 数据类

```kotlin
data class Task(val id:Int, val name: String)
```

类主体{}中定义的任何属性(如果存在)，将不会在生成的 equals()、hashCode()和toString()方法中使用。同样，也不会为它 们生成componentN()方法。

对于数据类，Kotlin生成一个copy()方法，该方法创建一个新对 象，并将接收端对象的所有属性复制到结果对象中。类似于protocol的copyWith。copy()函数只对基元和引用执 行了浅拷贝。方法不会深度复制内部引用的对象。



## 第8章、类层次结构和继承

### 8.1 创建接口和抽象类

创建接口

```kotlin
interface Remote{
  fun up()
  fun down()
  fun doubleUp(){
    up()
    up()
  }
}
```

在接口中实现的方法——也就是Kotlin类型的默认方法



创建抽象类

```kotlin
abstract class Musician(val name: String){
  abstract fun instrumentType(): String
}

class Cellist(name String): Musician(name){
 override fun instrumentType() = "name"
}
```

抽象类和接口的主要区别是：

* 在接口中定义的属性没有幕后字段，它们必须依赖抽象方法来从实现类中获得属性。另外抽象类的属性可以使用幕后字段。
* 你可以实现多个接口，但最多可以从一个类扩展。

### 8.2 嵌套类和内部类

在Kotlin中，一个类可以嵌套在另一个类中。Kotlin嵌套类不能访问嵌套外部类的私有成员。但是如果用inner关键字标记嵌套类，那么它们就会变成内部类，并且限制也消失了。

```kotlin
class TV{
  private var volume = 0
  val remote: Remote
  		get() = TVRemote()
  
  override fun to String() = "Volume = $volume"
  
  inner class TVRemote: Remote {
    override fun up(){ volume++ }
    override fun down(){ volume-- }
    override fun toString() = "remote ${this@TV.toString()}"
  }
}
```

此外，我们也可以在方法中创 建匿名内部类，而不是在类中创建内部类。

```kotlin
class TV{
  private var volume = 0
  val remote: Remote get() = object: Remote{
    override fun up(){volume++}
    override fun down(){volume--}
  }
}
```

inner关键字不用于匿名内部类。匿名实例实现了Remote接口，当然，它没有名称。除了这些区别之外，这个类与它所替换的TVRemote内部类没有任何不同。

### 8.3 继承

与接口不同，Kotlin中的类默认是final的——也就是说，你不能从它们继承。只能继承标记为open(开放)的类。只有开放类的开放方法可以在派生类中重写，并且必须在派生类中标记为override。重写方法可以标记为finaloverride，以防止子类进一步重写该方法。

```kotlin
open class Vehicle(val year: Int){
  open val km = 0
  fun repaint(newColor: String){
    color = newColor
  }
}

class Car(year: Int): Vehicle(year){
  override km: Int = 0
  
  
  override repaint(newColor: String){
    color = newColors
  }
}
```

### 8.4 Sealed类

在Kotlin中，存在一种极端情况，我们有final类——即未标记为open的类，它们不能有任何派生类。在另一种极端情况，我们有open类和abstract类，不知道哪个类可以继承它们。最好能有一个中间地带，让一个类只作为几个类的基，这几个类是由类的创建者指定的。

```kotlin
sealed class Expr{
    class Num(val value:Int):Expr()
    class Sum(val left:Expr,val right:Expr):Expr()
    data class Data(val value: Int):Expr()
}

fun eval(e:Expr):Int =
        when(e){
            is Expr.Num -> e.value
            is Expr.Sum -> eval(e.left) + eval(e.right)
            is Expr.Data -> e.value
        }
```

这样就不用在when的时候写else了

### 8.5 创建和使用枚举

```kotlin
enum class Suit {CLUBS, DIAMONDS, HEARTS, SPADES}
```


## 第9章 通过委托进行扩展

### 9.1 继承和委托的选择

* 如果你想用一个类的对象来代替另一个类的对象，请使用继承。
* 如果你想让一个类的对象只使用另一个类的对象，请使用委托。

### 9.2 使用委托进行设计

想象有一个应用程序，其模拟公司团队执行软件项目

```kotlin
interface Work{
	fun work()
  fun takeVacation()
}

class JavaProgrammer : Work{
  override fun work() = println("write java")
  override fun takeVacation() = println("code at the beach")
}

class CSharpProgrammer : Work{
  override fun work() = println("write c#")
  override fun takeVacation = println("code at the ranch")
}
```

公司希望为团队配备一名软件开发经理

```kotlin
class Manager
```

**使用委托-纯JAVA工具**

```kotlin
class Manager(val worker: Work){
  fun work() = worker.work()
  fun takeVacation = worker.work()
}
```

**使用委托-Kotlin**

```kotlin
class Manager(): Worker by JavaProgrammer()
```

使用

```kotlin
val doe = Manager()
val deo: JavaProgrammer = Manager() // ERROR: type mismatch
doe.work()
```



### 9.3 给委托传递参数

但是！这里只建立了Manager到JavaProgrammer的委托，没有实现到CSharpProgrammer的委托。

其次，Manager的实例没有访问委托的权限，也就是说，如果要在Manager类中编写一个方法，我们就不能从该方法访问委托。

过将委托绑定到传递给构造函数的参数而不是隐式创建的实例，就可以很容易地修复这些限制。

```kotlin
class Manager(val staff: Worker): Worker by staff{
  fun meeting() = println("call worker to have a meeting $staff")
}
```

### 9.4 处理方法冲突

Kotlin编译器在委托类中为委托中的每个方法创建一个包装类。如果在委托类中有一个方法与委托中的方法具有相同的名称和签名，该怎么办?

```kotlin
class Manager(val staff: Worker): Worker by staff{
  override fun takeVacation() = println("of course")
}
```

看到这一点，Kotlin编译器不会为takeVacation()生成包装类，但会为work()方法生成包装类。

对Manager实例的work()方法的调用被路由到委托，但是对takeVacation()方法的调用由Manager处理——那里没有委托。

### 9.5 Kotlin委托的注意事项

在我们目前创建的示例中，Manager可以将调用委托给JavaProgrammer实例，但是对Manager的引用不能分配给对JavaProgrammer的引用。

即Manager可以用JavaProgrammer但是它不是JavaProgrammer。

```kotlin
val coder: JavaProgrammer = Manager() // ERROR
val employee: Worker = Manager() // Right
```

这意味着Manager是一个或一种Worker。委托的真正目的是让Manager使用一个Worker，但是Kotlin的委托实现带来了一个副作用，即Manager可能被当作Worker来对待。

### 9.6 委托变量和属性

当你读取一个属性或一个局部变量时，Kotlin会在内部调用getValue()函数。同样，当你修改一个属性或一个变量时，它会调用setValue()函数。

通过使用这两种方法来委托对象，你可以拦截调用来读写局部变量和对象属性。

```kotlin
class PoliteString(var content: String){
  operator fun getValue(thjisRef: Any?, property: KProperty<*>) = content.replace("stupid", "s*****")
  operator fun setValue(thisRef: Any?, property: KProperty<*>, value: String){
    content = value
  }
}


var comment = String by PoliteString("You are nice")
println(comment) // You are nice

comment = "this is stupid"
println(comment) // this is s*****
```

使用前面的方法，我们不仅可以委托对局部变量的访问，还可以委托对对象属性的访问。

当定义一个属性时，不分配值，而是指定by并在其后跟着一个委托。

```kotlin
class PoliteString(val dataSource: MutableMap<String, Any>){
  operator fun getValue(thisRef: Any?, property: KProperty<*>){
    (dataSource[property.name] as? String)?.replace("stupid","s*****")
  }
  
  operator fun setValue(thisRef: Any, property: KProperty<*>, value: String){
    dataSource[property.name] = value
  }
}
```

### 9.7 内置的标准委托

Kotlin提供了一些内置的委托，我们可以很容易地从中获益。

* Lazy委托对于延迟创建对象非常有用或者直到真正需要结果时才执行计算。
* observable委托用于观察或监视属性值的变化。
* vetoable委托可用于根据某些规则或业务逻辑拒绝对属性的修改。

#### Lazy

假设有一个函数，它获取一个城市的当前温度

```kotlin
fun getTemp(city: String): Double{
  println("fetch temp $city")
  return 30.0
}
```

正常使用时

```kotlin
val temp = getTemp(city)

if(showTemp && temp>20){
  println("$temp")
}
```

当showTemp为false的时候，其实也会做getTemp的语句，但是实际上这是额外的操作，所以可以对getTemp用lazy，只有真正使用的时候才执行取值。

```kotlin
val temp by lazy {getTemp(city)}

if(showTemp && temp>20){
  println("$temp")
}
```

lazy函数接受一个lambda表达式作为参数，该表达式将执行计算，但仅按需执行，而不是急于或立即执行。

一旦对lambda中的表达式求值，委托将记住结果，以后对该值的请求将接收保存的值。不会重新计算lambda表达式。

#### Observable

```kotlin
var count by observable(0){property, oldValue, newValue->
	println("property: $property old: $oldValue new: $newValue")
}
println("$count") //0
count++	//property: var Observe.count: Kotlin.Int old: 0 new: 1
println("$count") //1
count-- //property: var Observe.count: Kotlin.Int old: 1 new: 0
println("$count")//0
```

#### Vetoable

与使用observable注册的处理程序不同，其返回类型为Unit。

我们使用vetoable注册的处理程序返回布尔结果。返回值为true表示同意接受修改，false表示拒绝。如果拒绝，修改将被丢弃。

```kotlin
var count by vetoable(0){_, oldValue, newValue->
	newValue > oldValue
}
println("$count") //0
count++	//old: 0 new: 1 (true)
println("$count") //1
count-- //old: 1 new: 0 (false)
println("$count")//1
```

