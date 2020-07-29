# sonar

## 启动
```
docker-compose up -d
```

## 登录
账号密码默认为: admin/admin

## 问题
1.  max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
解决：
```
sysctl -w vm.max_map_count=262144
```
查看结果：
```
sysctl -a|grep vm.max_map_count
```
显示：
```
vm.max_map_count = 262144
```
2. 汉化
进入 Administration > Marketplace，在搜索框中输入chinese，出现一个Chinese Pack，点击右侧的install按钮，安装成功后，会提示重启 SonarQube server 。

## 与maven集成
```
 <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-checkstyle-plugin</artifactId>
    <version>${maven-checkstyle-plugin.version}</version>
    <configuration>
        <configLocation>config/checkstyle/checkstyle_ci.xml</configLocation>
        <suppressionsLocation>config/checkstyle/checkstyle-suppressions.xml</suppressionsLocation>
        <includeTestSourceDirectory>true</includeTestSourceDirectory>
        <consoleOutput>true</consoleOutput>
        <failsOnError>true</failsOnError>
        <failOnViolation>true</failOnViolation>
        <violationSeverity>warning</violationSeverity>
    </configuration>
    <executions>
        <execution>
            <id>validate</id>
            <phase>validate</phase>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

* 执行`mvn checkstyle:checkstyle` 检查是否满足checkstyle格式，检测结果在 target/checkstyle-result.xml 中
* 执行`mvn jxr:jxr`命令可以查看有错的对应代码