package utils

import (
	"encoding/binary"
	"encoding/json"
	"hash/crc32"
	"os"

	"github.com/jkstack/anet"
)

// WriteMessage 输出msg消息给smartagent
func WriteMessage(msg anet.Msg) {
	data, _ := json.Marshal(msg)
	buf := make([]byte, len(data)+8)
	binary.BigEndian.PutUint32(buf, uint32(len(data)))
	binary.BigEndian.PutUint32(buf[4:], crc32.ChecksumIEEE(data))
	copy(buf[8:], data)
	os.Stdout.Write(buf)
}
