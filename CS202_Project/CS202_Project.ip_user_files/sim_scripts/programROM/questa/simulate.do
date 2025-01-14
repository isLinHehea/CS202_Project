onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib programROM_opt

do {wave.do}

view wave
view structure
view signals

do {programROM.udo}

run -all

quit -force
