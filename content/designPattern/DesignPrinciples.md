# Design Principles

### 一、单一职责原则

> 一个类应该只有一个发生变化的原因。



**模拟场景**

一个视频网站有对用户分类的场景

访客用户只能观看480P视频，且有广告
普通会员只能观看720P视频，且有广告
VIP用户可以看1080P视频，且无广告



**违背原则**

```java
public class VideoUserSerice{
  public void serveGrade(String usrType){
    if(usrType == "VIP"){
      // 视频1080P，无广告
    }else if(usrType == "普通会员"){
      // 视频720P，有广告
    }else if(usrType == "访客用户"){
      // 视频480P，有广告
    }
  }
}
```



**改进方案**

```java
public interface IVideoUserService{
  // 清晰度 1080P、720P、480P
  void definition();
  
  // 广告播放方式，有广告、无广告
  void advertisement();
}
```



### 二、开闭原则

> 对象、类、模块和函数对扩展应该是开放的，但是对于修改是封闭的。



**模拟场景**

计算三种形状的面积，长方形、三角形、圆形。
但是后续由于pai取值的精度对于某些场景是不足的，需要扩展。

```java
public class CalculationArea{
  private final static double pai = 3.14D;
  public double retangle(double x,double y){
    return x * y;
  }
  
  public double triangle(double x,double y,double z){
    double p = (x+y+z)/2;
    return Math.sqrt(p*(p-x)(p-y)(p-z));
  }
  
  public double circular(double r){
    return pai * r * r;
  }
}
```



**违背原则**

直接修改pai值

```java
private final static double pai = 3.141592653D;
public double circular(double r){
    return pai * r * r;
  }
```



**改进方案**

```java
public class CalculationAreExt extends CalculationArea{
  private final static double pai = 3.141592653D;
  @override
  public double circular(double r){
    return pai * r * r;
  }
}
```



### 三、里氏替换原则

> 如果S是T的子类型，那么所有T类型的对象都可以在不破坏程序的情况下被S类型的对象替换。
>
> 简单来说，子类可以扩展夫类的功能，但不能改变父类原有的功能。
> 当子类继承父类时，除添加新的方法且完成新增功能外，尽量不要重写父类方法。

主要包含四点含义：

* 子类可以实现父类的抽象方法，但不能覆盖父类的非抽象方法。
* 子类可以增加自己特有的方法。
* 当子类的方法重载父类的方法时，方法的前置条件（方法的输入）要比父类更宽松。
* 当子类的方法实现父类的方法（重写、重载、实现）时，方法的后置条件（即方法的输出或返回值）要比父类的方法更加严格或与父类方法相等。



**模拟场景**

实现储蓄卡和信用卡



**违背原则**

```java
public class CashCard{
  // 取钱
  public String withdrawal();
  
  // 存钱
  public String recharge();
  
  // 打印流水
  public String tradeFlow();
}

public class CreditCard extends CashCard{
  @override
  public String withdrawal();
  
  @override
  public String recharge();
}
```

信用卡直接继承了储蓄卡的类并重写了有关取钱和存钱的内容，由于打印流水实现相同则没有重写。



**改进方案**

```java
public abstract class BankCard{
  // 流入钱
  public String positive();
  
  // 流出钱
  public String negative();
  
  // 打印流水
  public String tradeFlow();
}

public class CashCard extends BankCard{
  public String withdrawal(){
    return super.negative();
  }
  
  public String recharge(){
    return super.positive();
  }
}

public class CreditCard extends BankCard{
  public String loan(){
    return super.negative();
  }
  
  public String repayment(){
    return super.positive();
  }
}
```

### 四、迪米特法则

> 一个对象类对于其他对象类来说，知道得越少越好。

**模拟场景**

模拟学生、老师、校长的关系。

老师需要知道具体学生的成绩，而校长只关心某个班级的总成绩。



**违背原则**

```java
public class Student{
  private double grade;
}

public class Teacher{
  private List<Student> studentList;
  
  public List<Student> getStudentList(){
    return studentList;
  }
}

public class Principal{
  private Teacher teacher;
  
  public double classTotalScore(){
    teacher.getStudentList();
    // do more
  }
}
```



**改进代码**

```java
public class Student{
  private double grade;
}

public class Teacher{
  private List<Student> studentList;
  
  public double classTotalScore(){
    teacher.getStudentList();
    // do more
  }
}

public class Principal{
  private Teacher teacher;
  
  public double classTotalScore(){
    teacher.classTotalScore();
  }
}
```

