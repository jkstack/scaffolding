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
5. 实现main.go中的msg对象处理函数
6. 修改`CHANGELOG.md`
7. 提交合并请求
8. 合并代码
9. 打包上线