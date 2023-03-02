+++
title = "六大设计原则"
date = "2023-02-28"
+++

# Design Principles

### 一、单一职责原则

> 一个类应该只有一个发生变化的原因。



#### 模拟场景

一个视频网站有对用户分类的场景

访客用户只能观看480P视频，且有广告
普通会员只能观看720P视频，且有广告
VIP用户可以看1080P视频，且无广告



#### 违背原则

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



#### 改进方案

```java
public interface IVideoUserService{`
  // 清晰度 1080P、720P、480P
  void definition();
  
  // 广告播放方式，有广告、无广告
  void advertisement();
}
```



### 二、开闭原则

> 对象、类、模块和函数对扩展应该是开放的，但是对于修改是封闭的。



#### 模拟场景

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



#### 违背原则

直接修改pai值

```java
private final static double pai = 3.141592653D;
public double circular(double r){
    return pai * r * r;
  }
```



#### 改进方案

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



#### 模拟场景

实现储蓄卡和信用卡



#### 违背原则

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



#### 改进方案

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



#### 模拟场景

模拟学生、老师、校长的关系。

老师需要知道具体学生的成绩，而校长只关心某个班级的总成绩。



#### 违背原则

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



#### 改进代码

```java
public class Student{
  private double grade;
}

public class Teacher{
  private List<Student> studentList;
  
  public double classTotalScore(){
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



### 五、接口隔离原则

> 客户端不应该被破依赖于它不是用的方法。
> 一个类对另一个类的依赖应该是建立在最小的接口上的。
>
> 要求尽量将臃肿庞大的接口拆分成更小的和更具体的接口。



#### 模拟场景

王者荣耀有不同的技能特性，每个英雄的技能都属于其中



#### 违背原则

```java
public interface ISkill{
  // 射箭
  void doArchery();
  // 隐身
  void doInvisible();
  // 沉默
  void doSilent();
  // 眩晕
  void doVertigo();
}

public class HeroHouYi implements ISkill{
  @Override
  public void doArchery(){
    // do archery
  }
  @Override
  public void doVertigo(){
    // do vertigo
  }
  @Override
  public void doSilent(){
    // do nothing
  }
	@Override
  public void doInvisible(){
    // do nothing
  }
}
```



#### 改进方案

```java
public interface ISkillArchery{
  void doArchery();
}
public interface ISkillInvisible{
  void doInvisible();
}
public interface ISkillSilent{
  void doSilent();
}
public interface ISkillVertigo{
  void doVertigo();
}

public class HeroHouYi implement ISkillArchery,ISkillVertigo{
  @Override
  public void doArchery(){
    // do archery
  }
  
  @Override
  public void doVertigo(){
    // do vertigo
  }
}
```



### 六、依赖倒置原则

> 高层模块不应该依赖于底层模块，二者都应该依赖于抽象。
> 抽象不应该依赖于细节，细节应该依赖于抽象。



#### 模拟场景

权重抽奖、随机抽奖



#### 违背原则

```java
public class BetUser{
  private String userName;
  private int userWeight;
}

public class DrawControl{
  public List<BetUser> doDrawRandom(List<BetUser> list,int count){
    // do something
  }
  
  public List<BetUser> doDrawWeight(List<BetUser> list,int count){
  	// do something
  }
}
```

当业务需要扩展到的时候，只能在DrawControl中新增接口，且代码会暴增，难以维护。



#### 改进方案

**获取抽奖用户接口**

```java
public interface IDraw{
  // 获取抽奖用户接口
  List<BetUser> prize(List<BetUser> list, int count);
}
```



**抽奖具体实现类**

```java
// 随机抽奖
public class DrawRandom implements IDraw{
  @Override
  public List<BetUser> prize(List<BetUser> list, int count){
    // do something
  }
}

// 权重抽奖
public class DrawWeight implements IDraw{
  @Override
  public List<BetUser> prize(List<BetUser> list, int count){
    // do something
  }
}
```



**抽奖服务**

```java
// 创建抽奖服务
public class DrawControl{
  private IDraw draw;
  public List<BetUser> doDraw(IDraw draw, List<BetUser> betUserList, int count){
    return draw.prize(betUserList, count);
  }
}
```

