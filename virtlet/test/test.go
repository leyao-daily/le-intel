package main

import (
	"fmt"
	"strconv"
	"strings"
)

type pciInfos struct {
        pciHostDomain    uint
        pciHostBus       uint
        pciHostSlot      uint
        pciHostFunction  uint
}

func getPciInfo(deviceId string) {
	tmp := strings.Split(deviceId, ":")
	fmt.Println(tmp)
	xx := strings.Split(tmp[2], ".")
	fmt.Println(xx)
        pciHostDomain, err := strconv.ParseUint(tmp[0], 16, 0)
	if err == nil {
	}
	fmt.Println(uint(pciHostDomain))
}

func main() {
	var p *pciInfos
	p = &pciInfos {
		1,1,1,1,
	}
	fmt.Println(p)
}
