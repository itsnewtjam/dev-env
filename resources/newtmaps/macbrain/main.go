// firefox: accelkey 224
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
	EV_REL uint16 = 0x02
	EV_ABS uint16 = 0x03
	EV_MSC uint16 = 0x04
	EV_LED uint16 = 0x11
	
	SYN_REPORT uint16 = 0x00
	
	KEY_RELEASED int32 = 0
	KEY_PRESSED int32 = 1
	KEY_REPEAT int32 = 2

	KEY_LMETA uint16 = 125
	KEY_RMETA uint16 = 126
	KEY_LCTRL uint16 = 29
	KEY_RCTRL uint16 = 97
	KEY_LALT uint16 = 56
	KEY_RALT uint16 = 100
	KEY_LSHIFT uint16 = 42
	KEY_RSHIFT uint16 = 54

	KEY_NUM_ASTERISK uint16 = 55
	
	KEY_P uint16 = 25
	KEY_A uint16 = 30
	KEY_F uint16 = 33
	KEY_L uint16 = 38
	KEY_Z uint16 = 44
	KEY_X uint16 = 45
	KEY_C uint16 = 46
	KEY_V uint16 = 47
	KEY_UP uint16 = 103
	KEY_DOWN uint16 = 108
	KEY_LEFT uint16 = 105
	KEY_RIGHT uint16 = 106
	KEY_HOME uint16 = 102
	KEY_END uint16 = 107

	KEY_NONE uint16 = 0xFFFF
)

type InputEvent struct {
	Time [2]int64
	Type uint16
	Code uint16
	Value int32
}

type ModifierState struct {
	Meta bool
	Ctrl bool
	Alt bool
	Shift bool
}

type KeyCombo struct {
	Key uint16
	Meta bool
	Ctrl bool
	Alt bool
	Shift bool
}

type KeyRemapping struct {
	From KeyCombo
	To KeyCombo
}

func main() {
	remappings := []KeyRemapping{
		// Numpad Asterisk > Hyper
		{From: KeyCombo{Key: KEY_NUM_ASTERISK}, To: KeyCombo{Key: KEY_NONE, Meta: true, Ctrl: true, Alt: true, Shift: true}},
		// Cmd+Z > Ctrl+Z
		{From: KeyCombo{Key: KEY_Z, Meta: true}, To: KeyCombo{Key: KEY_Z, Ctrl: true}},
		// Cmd+Shift+Z > Ctrl+Shift+Z
		{From: KeyCombo{Key: KEY_Z, Meta: true, Shift: true}, To: KeyCombo{Key: KEY_Z, Ctrl: true, Shift: true}},
		// Cmd+X > Ctrl+X
		{From: KeyCombo{Key: KEY_X, Meta: true}, To: KeyCombo{Key: KEY_X, Ctrl: true}},
		// Cmd+C > Ctrl+C
		{From: KeyCombo{Key: KEY_C, Meta: true}, To: KeyCombo{Key: KEY_C, Ctrl: true}},
		// Cmd+V > Ctrl+V
		{From: KeyCombo{Key: KEY_V, Meta: true}, To: KeyCombo{Key: KEY_V, Ctrl: true}},
		// Cmd+Shift+V > Ctrl+Shift+V
		{From: KeyCombo{Key: KEY_V, Meta: true, Shift: true}, To: KeyCombo{Key: KEY_V, Ctrl: true, Shift: true}},
		// Cmd+A > Ctrl+A
		{From: KeyCombo{Key: KEY_A, Meta: true}, To: KeyCombo{Key: KEY_A, Ctrl: true}},
		// Cmd+P > Ctrl+P
		{From: KeyCombo{Key: KEY_P, Meta: true}, To: KeyCombo{Key: KEY_P, Ctrl: true}},
		// Cmd+Left > Home
		{From: KeyCombo{Key: KEY_LEFT, Meta: true}, To: KeyCombo{Key: KEY_HOME}},
		// Cmd+Right > End
		{From: KeyCombo{Key: KEY_RIGHT, Meta: true}, To: KeyCombo{Key: KEY_END}},
		// Opt+Left > Ctrl+Left
		{From: KeyCombo{Key: KEY_LEFT, Alt: true}, To: KeyCombo{Key: KEY_LEFT, Ctrl: true}},
		// Opt+Right > Ctrl+Right
		{From: KeyCombo{Key: KEY_RIGHT, Alt: true}, To: KeyCombo{Key: KEY_RIGHT, Ctrl: true}},
		// Cmd+F > Ctrl+F
		{From: KeyCombo{Key: KEY_F, Meta: true}, To: KeyCombo{Key: KEY_F, Ctrl: true}},
		// Cmd+Up > Ctrl+Home
		{From: KeyCombo{Key: KEY_UP, Meta: true}, To: KeyCombo{Key: KEY_HOME, Ctrl: true}},
		// Cmd+Down > Ctrl+End
		{From: KeyCombo{Key: KEY_DOWN, Meta: true}, To: KeyCombo{Key: KEY_END, Ctrl: true}},
	}

	modState := ModifierState{}
	
	var activeRemappings []KeyCombo
	
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

		if event.Type == EV_KEY {
			switch event.Code {
			case KEY_LMETA:
				fallthrough
			case KEY_RMETA:
				modState.Meta = (event.Value != KEY_RELEASED)
			case KEY_LCTRL:
				fallthrough
			case KEY_RCTRL:
				modState.Ctrl = (event.Value != KEY_RELEASED)
			case KEY_LALT:
				fallthrough
			case KEY_RALT:
				modState.Alt = (event.Value != KEY_RELEASED)
			case KEY_LSHIFT:
				fallthrough
			case KEY_RSHIFT:
				modState.Shift = (event.Value != KEY_RELEASED)
			}
		}

		if event.Type == EV_KEY && event.Value == KEY_PRESSED {
			currentCombo := KeyCombo{
				Key: event.Code,
				Meta: modState.Meta,
				Ctrl: modState.Ctrl,
				Alt: modState.Alt,
				Shift: modState.Shift,
			}
			
			remapped := false
			for _, remap := range remappings {
				if matchesCombo(currentCombo, remap.From) {
					remapped = true
					activeRemappings = append(activeRemappings, currentCombo)
					
					sendModifierChanges(modState, remap.To)
					
					if remap.To.Key != KEY_NONE {
						keyEvent := makeKeyEvent(remap.To.Key, KEY_PRESSED)
						keyEvent.Time = event.Time
						sendKeyEvent(keyEvent)
					}
					
					syncEvent := makeSyncEvent()
					syncEvent.Time = event.Time
					sendKeyEvent(syncEvent)
					
					break
				}
			}
			
			if !remapped {
				sendKeyEvent(event)
			}
		} else if event.Type == EV_KEY && event.Value == KEY_RELEASED {
			remapped := false
			for i, activeCombo := range activeRemappings {
				if activeCombo.Key == event.Code {
					remapped = true
					
					activeRemappings = append(activeRemappings[:i], activeRemappings[i+1:]...)
					
					for _, remap := range remappings {
						if matchesCombo(activeCombo, remap.From) {
							if remap.To.Key != KEY_NONE {
								keyEvent := makeKeyEvent(remap.To.Key, KEY_RELEASED)
								keyEvent.Time = event.Time
								sendKeyEvent(keyEvent)
							}

							resetCombo := KeyCombo{Key: KEY_NONE}
							currentMods := ModifierState{
								Meta: remap.To.Meta,
								Ctrl: remap.To.Ctrl,
								Alt: remap.To.Alt,
								Shift: remap.To.Shift,
							}
							sendModifierChanges(currentMods, resetCombo)
							
							syncEvent := makeSyncEvent()
							syncEvent.Time = event.Time
							sendKeyEvent(syncEvent)
							
							break
						}
					}
					break
				}
			}
			
			if !remapped {
				sendKeyEvent(event)
			}
		} else if event.Type == EV_SYN {
			sendKeyEvent(event)
		} else {
			sendKeyEvent(event)
		}
	}
}

func matchesCombo(combo KeyCombo, pattern KeyCombo) bool {
	return combo.Key == pattern.Key &&
		combo.Meta == pattern.Meta &&
		combo.Ctrl == pattern.Ctrl &&
		combo.Alt == pattern.Alt &&
		combo.Shift == pattern.Shift
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

func sendModifierChanges(current ModifierState, target KeyCombo) {
	if current.Meta && !target.Meta {
		sendKeyEvent(makeKeyEvent(KEY_LMETA, KEY_RELEASED))
	}
	if current.Ctrl && !target.Ctrl {
		sendKeyEvent(makeKeyEvent(KEY_LCTRL, KEY_RELEASED))
	}
	if current.Alt && !target.Alt {
		sendKeyEvent(makeKeyEvent(KEY_LALT, KEY_RELEASED))
	}
	if current.Shift && !target.Shift {
		sendKeyEvent(makeKeyEvent(KEY_LSHIFT, KEY_RELEASED))
	}
	
	if !current.Meta && target.Meta {
		sendKeyEvent(makeKeyEvent(KEY_LMETA, KEY_PRESSED))
	}
	if !current.Ctrl && target.Ctrl {
		sendKeyEvent(makeKeyEvent(KEY_LCTRL, KEY_PRESSED))
	}
	if !current.Alt && target.Alt {
		sendKeyEvent(makeKeyEvent(KEY_LALT, KEY_PRESSED))
	}
	if !current.Shift && target.Shift {
		sendKeyEvent(makeKeyEvent(KEY_LSHIFT, KEY_PRESSED))
	}
	
	sendKeyEvent(makeSyncEvent())
}

func sendKeyEvent(event InputEvent) {
	err := binary.Write(os.Stdout, binary.LittleEndian, event)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error writing event: %v\n", err)
	}
}
