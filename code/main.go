package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"runtime"

	"scaffolding/code/logging"
	"scaffolding/code/utils"

	"github.com/jkstack/anet"
)

var (
	pluginName   string = "<pluginName>"
	version      string = "0.0.0"
	gitBranch    string = "<branch>"
	gitHash      string = "<hash>"
	gitReversion string = "0"
	buildTime    string = "0000-00-00 00:00:00"
)

func showVersion() {
	fmt.Printf("插件名称: %s\n程序版本: %s\n代码版本: %s.%s.%s\n时间: %s\ngo版本: %s\n",
		pluginName,
		version,
		gitBranch, gitHash, gitReversion,
		buildTime,
		runtime.Version())
}

func decode(dir string) (*anet.Msg, error) {
	f, err := os.Open(dir)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	var msg anet.Msg
	err = json.NewDecoder(f).Decode(&msg)
	if err != nil {
		return nil, err
	}
	return &msg, nil
}

func main() {
	version := flag.Bool("version", false, "查看版本号")
	args := flag.String("args", "", "参数文件目录")
	_ = flag.String("server", "", "服务器地址")
	_ = flag.Bool("reset", false, "重置插件")
	flag.Parse()

	if *version {
		showVersion()
		return
	}

	if len(*args) == 0 {
		fmt.Println("缺少-args参数")
		os.Exit(1)
	}

	msg, err := decode(*args)
	if err != nil {
		logging.Error("decode: %v", err)
		return
	}
	defer func() {
		if err := recover(); err != nil {
			logging.Error("error: %v", err)
		}
	}()

	if msg.Type == anet.TypeFoo {
		logging.Info("foo message received")
		var ret anet.Msg
		ret.Type = anet.TypeBar
		ret.TaskID = msg.TaskID
		utils.WriteMessage(ret)
	}
}
