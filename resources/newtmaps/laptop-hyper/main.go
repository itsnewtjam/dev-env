package main

import (
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"time"
)

const (
	EV_SYN uint16 = 0x00
	EV_KEY uint16 = 0x01
	
	SYN_REPORT uint16 = 0x00
	
	KEY_RELEASED int32 = 0
	KEY_PRESSED int32 = 1
	KEY_REPEAT int32 = 2

	KEY_RCTRL uint16 = 97

	KEY_LMETA uint16 = 125
	KEY_LCTRL uint16 = 29
	KEY_LALT uint16 = 56
	KEY_LSHIFT uint16 = 42
)

type InputEvent struct {
	Time [2]int64
	Type uint16
	Code uint16
	Value int32
}

func main() {
	for {
		var event InputEvent
		err := binary.Read(os.Stdin, binary.LittleEndian, &event)
		if err == io.EOF {
			break
		}
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading event: %v\n", err)
			continue
		}

		if event.Type == EV_KEY && event.Code == KEY_RCTRL {
			if event.Value == KEY_PRESSED {
				sendKeyEvent(makeKeyEvent(KEY_LCTRL, KEY_PRESSED))
				sendKeyEvent(makeKeyEvent(KEY_LALT, KEY_PRESSED))
				sendKeyEvent(makeKeyEvent(KEY_LSHIFT, KEY_PRESSED))
				sendKeyEvent(makeKeyEvent(KEY_LMETA, KEY_PRESSED))
				
				sendKeyEvent(makeSyncEvent())
			} else if event.Value == KEY_RELEASED {
				sendKeyEvent(makeKeyEvent(KEY_LCTRL, KEY_RELEASED))
				sendKeyEvent(makeKeyEvent(KEY_LALT, KEY_RELEASED))
				sendKeyEvent(makeKeyEvent(KEY_LSHIFT, KEY_RELEASED))
				sendKeyEvent(makeKeyEvent(KEY_LMETA, KEY_RELEASED))
				
				sendKeyEvent(makeSyncEvent())
			}
		} else {
			sendKeyEvent(event)
		}
	}
}

func makeKeyEvent(code uint16, value int32) InputEvent {
	now := time.Now()
	sec := now.Unix()
	usec := now.Nanosecond() / 1000
	
	return InputEvent{
		Time: [2]int64{sec, int64(usec)},
		Type: EV_KEY,
		Code: code,
		Value: value,
	}
}

func makeSyncEvent() InputEvent {
	now := time.Now()
	sec := now.Unix()
	usec := now.Nanosecond() / 1000
	
	return InputEvent{
		Time: [2]int64{sec, int64(usec)},
		Type: EV_SYN,
		Code: SYN_REPORT,
		Value: 0,
	}
}

func sendKeyEvent(event InputEvent) {
	err := binary.Write(os.Stdout, binary.LittleEndian, event)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error writing event: %v\n", err)
	}
}
