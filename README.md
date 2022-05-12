# scaffolding

smartagent插件脚手架项目

## 使用方式

1. 拉取当前项目

        git clone https://github.com/jkstack/scaffolding.git
2. 删除.git目录

        rm -fr .git
3. 按gitlab的操作手册，初始化git仓库

        git init
        git remote add origin <项目地址>
        git add .
        git commit -m "Initial commit"
        git push -u origin master
4. 修改build脚本和Makefile文件中的PROJ变量
5. 修改manifest.json中的name字段
6. 实现main.go中的msg对象处理函数
7. 修改`CHANGELOG.md`
8. 提交合并请求
9. 合并代码
10. 打包上线

## 基本接口

1. [WriteMessage](code/utils/msg.go): 输出anet.Msg结构的数据到stdout输出的数据将会被agent捕获并转发到server
2. [log输出](code/logging/log.go): 输出log信息到stderr输出的日志将会被agent捕获并记录到对应插件的日志文件
    - logging.Debug: 输出调试信息，为减少调试信息的内容将有1‰的内容将被输出
    - logging.Info: 输出标准日志
    - logging.Error: 输出错误日志，其中会包含出错时的调用堆栈信息
    - logging.Flush: 将缓存中的日志全部输出