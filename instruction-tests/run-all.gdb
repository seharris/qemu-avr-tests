target remote localhost:1234
monitor reset
set pagination off
continue
while $pc < end
info registers
set $pc=$pc + 2
continue
end
quit
