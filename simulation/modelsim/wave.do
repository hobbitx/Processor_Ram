onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system/Clock
add wave -noupdate /system/Reset
add wave -noupdate -divider {Banco de RFs}
add wave -noupdate -childformat {{{/system/proc1/rf/register[7]} -radix unsigned} {{/system/proc1/rf/register[6]} -radix unsigned} {{/system/proc1/rf/register[5]} -radix unsigned} {{/system/proc1/rf/register[4]} -radix unsigned} {{/system/proc1/rf/register[3]} -radix unsigned} {{/system/proc1/rf/register[2]} -radix unsigned} {{/system/proc1/rf/register[1]} -radix unsigned} {{/system/proc1/rf/register[0]} -radix unsigned}} -expand -subitemconfig {{/system/proc1/rf/register[7]} {-height 15 -radix unsigned} {/system/proc1/rf/register[6]} {-height 15 -radix unsigned} {/system/proc1/rf/register[5]} {-height 15 -radix unsigned} {/system/proc1/rf/register[4]} {-height 15 -radix unsigned} {/system/proc1/rf/register[3]} {-height 15 -radix unsigned} {/system/proc1/rf/register[2]} {-height 15 -radix unsigned} {/system/proc1/rf/register[1]} {-height 15 -radix unsigned} {/system/proc1/rf/register[0]} {-height 15 -radix unsigned}} /system/proc1/rf/register
add wave -noupdate -divider {Registradores de pipeline}
add wave -noupdate -expand -group Estagio -radix hexadecimal /system/proc1/estagio_1
add wave -noupdate -expand -group Estagio -radix hexadecimal /system/proc1/estagio_2
add wave -noupdate -expand -group Estagio -radix hexadecimal /system/proc1/estagio_3
add wave -noupdate -expand -group Estagio -radix hexadecimal /system/proc1/estagio_4
add wave -noupdate -divider Cache
add wave -noupdate -radix unsigned /system/mem1/hit
add wave -noupdate -radix unsigned /system/mem1/hit_v0
add wave -noupdate -radix unsigned /system/mem1/hit_v1
add wave -noupdate -radix unsigned /system/mem1/LRU_new
add wave -noupdate -radix unsigned /system/mem1/rw_v0
add wave -noupdate -radix unsigned /system/mem1/rw_v1
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {287 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {854 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 50ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/system/Clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/system/Reset 
WaveCollapseAll -1
wave clipboard restore
