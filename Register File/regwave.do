onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /regstim/clk
add wave -noupdate /regstim/ReadRegister1
add wave -noupdate /regstim/ReadRegister2
add wave -noupdate /regstim/WriteRegister
add wave -noupdate /regstim/WriteData
add wave -noupdate /regstim/RegWrite
add wave -noupdate /regstim/dut/regs/register
add wave -noupdate /regstim/ReadData1
add wave -noupdate /regstim/ReadData2
add wave -noupdate /regstim/dut/regs/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 300
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {501375 ns}
