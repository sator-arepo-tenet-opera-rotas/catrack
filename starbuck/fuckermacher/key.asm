global _start
_start:
pop esp
js 0x36
xor [eax+edi*2+0x43],ebx
xor [eax+edi*2+0x35],bl
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x32],bl
xor eax,0x3237785c
pop esp
js 0x52
cmp [eax+edi*2+0x37],ebx
cmp [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x32],bl
aaa
pop esp
js 0x5d
xor ebx,[eax+edi*2+0x37]
cmp [eax+edi*2+0x32],ebx
xor ebx,[eax+edi*2+0x36]
cmp [eax+edi*2+0x37],bl
xor bl,[eax+edi*2+0x37]
xor [eax+edi*2+0x32],bl
xor [eax+edi*2+0x37],bl
xor al,0x5c
js 0x81
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x8a
xor bl,[eax+edi*2+0x37]
xor ebx,[eax+edi*2+0x32]
xor eax,0x3836785c
pop esp
js 0x95
aaa
pop esp
js 0x9e
xor ebx,[eax+edi*2+0x37]
xor bl,[eax+edi*2+0x37]
ss pop esp
js 0xa9
cmp [eax+edi*2+0x32],bl
xor [eax+edi*2+0x32],bl
xor eax,0x3837785c
pop esp
js 0xb5
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x32],bl
aaa
pop esp
js 0xc6
xor ebx,[eax+edi*2+0x32]
aaa
pop esp
js 0xc9
xor bl,[eax+edi*2+0x36]
cmp [eax+edi*2+0x37],bl
xor al,0x5c
js 0xd5
xor bl,[eax+edi*2+0x32]
xor ebx,[eax+edi*2+0x32]
xor eax,0x3836785c
pop esp
js 0xe5
xor bl,[eax+edi*2+0x32]
xor ebx,[eax+edi*2+0x37]
xor [eax+edi*2+0x37],ebx
xor bl,[eax+edi*2+0x36]
cmp [eax+edi*2+0x37],bl
cmp [eax+edi*2+0x37],ebx
xor ebx,[eax+edi*2+0x32]
xor ebx,[eax+edi*2+0x32]
xor ebx,[eax+edi*2+0x36]
cmp [eax+edi*2+0x32],bl
xor eax,0x3432785c
pop esp
js 0x115
aaa
pop esp
js 0x11e
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x37],bl
xor al,0x5c
js 0x125
xor [eax+edi*2+0x37],bl
aaa
pop esp
js 0x12d
aaa
pop esp
js 0x135
cmp [eax+edi*2+0x37],bl
xor [eax+edi*2+0x37],ebx
xor [eax+edi*2+0x37],bl
ss pop esp
js 0x141
xor eax,0x3836785c
pop esp
js 0x14e
cmp [eax+edi*2+0x37],bl
xor [eax+edi*2+0x32],bl
xor eax,0x3737785c
pop esp
js 0x15d
cmp [eax+edi*2+0x37],bl
xor ebx,[eax+edi*2+0x32]
xor bl,[eax+edi*2+0x32]
xor al,0x5c
js 0x169
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x17a
ss pop esp
js 0x17e
xor bl,[eax+edi*2+0x32]
aaa
pop esp
js 0x185
cmp [eax+edi*2+0x37],bl
xor eax,0x3232785c
pop esp
js 0x192
cmp [eax+edi*2+0x32],bl
xor bl,[eax+edi*2+0x36]
cmp [eax+edi*2+0x37],bl
xor [eax+edi*2+0x32],ebx
xor ebx,[eax+edi*2+0x37]
cmp [eax+edi*2+0x32],bl
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x32],bl
xor ebx,[eax+edi*2+0x37]
aaa
pop esp
js 0x1b5
aaa
pop esp
js 0x1be
cmp [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x37],bl
xor al,0x5c
js 0x1ca
cmp [eax+edi*2+0x37],bl
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x1d5
cmp [eax+edi*2+0x32],bl
xor bl,[eax+edi*2+0x37]
xor al,0x5c
js 0x1e2
xor [eax+edi*2+0x32],bl
xor al,0x5c
js 0x1e9
cmp [eax+edi*2+0x37],bl
xor [eax+edi*2+0x37],ebx
xor [eax+edi*2+0x32],bl
xor eax,0x3332785c
pop esp
js 0x1fd
cmp [eax+edi*2+0x32],bl
aaa
pop esp
js 0x206
xor eax,0x3332785c
pop esp
js 0x20e
xor ebx,[eax+edi*2+0x36]
cmp [eax+edi*2+0x32],bl
xor ebx,[eax+edi*2+0x37]
cmp [eax+edi*2+0x32],ebx
xor eax,0x3432785c
pop esp
js 0x225
cmp [eax+edi*2+0x32],bl
xor al,0x5c
js 0x229
xor bl,[eax+edi*2+0x32]
aaa
pop esp
js 0x231
xor al,0x5c
js 0x239
cmp [eax+edi*2+0x32],bl
xor ebx,[eax+edi*2+0x32]
xor al,0x5c
js 0x246
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x24d
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x251
xor ebx,[eax+edi*2+0x37]
cmp [eax+edi*2+0x37],bl
xor ebx,[eax+edi*2+0x36]
cmp [eax+edi*2+0x37],bl
xor eax,0x3537785c
pop esp
js 0x269
aaa
pop esp
js 0x26d
aaa
pop esp
js 0x275
cmp [eax+edi*2+0x37],bl
cmp [eax+edi*2+0x37],ebx
cmp [eax+edi*2+0x37],ebx
aaa
pop esp
js 0x281
xor [eax+edi*2+0x36],bl
cmp [eax+edi*2+0x37],bl
xor [eax+edi*2+0x32],bl
xor [eax+edi*2+0x37],bl
xor ebx,[eax+edi*2+0x32]
aaa
pop esp
js 0x29d
cmp [eax+edi*2+0x37],bl
aaa
pop esp
js 0x2a1
aaa
pop esp
js 0x2a5
aaa
pop esp
js 0x2a9
aaa
pop esp
js 0x2b1
cmp [eax+edi*2+0x37],bl
xor eax,0x3432785c
pop esp
js 0x2b9
xor bl,[eax+edi*2+0x32]
xor ebx,[eax+edi*2+0x35]
xor al,0x5c
js 0x2c8
inc ebp
pop esp
js 0x2cf
inc edx
pop esp
js 0x2e1
inc ebp
pop esp
js 0x2d7
inc edx
pop esp
js 0x2e7
aaa
pop esp
js 0x2ed
inc ebx
pop esp
js 0x2ed
cmp [eax+edi*2+0x38],ebx
xor [eax+edi*2+0x30],bl
xor [eax+edi*2+0x30],bl
xor [eax+edi*2+0x30],bl
xor [eax+edi*2+0x42],bl
inc edx
pop esp
js 0x2f7
xor [eax+edi*2+0x30],ebx
xor [eax+edi*2+0x30],bl
xor [eax+edi*2+0x30],bl
xor [eax+edi*2+0x33],bl
xor [eax+edi*2+0x43],ebx
xor [eax+edi*2+0x35],bl
xor [eax+edi*2+0x41],bl
inc ebx
pop esp
js 0x316
xor ebx,[eax+edi*2+0x43]
xor ebx,[eax+edi*2+0x41]
inc ecx
pop esp
js 0x334
xor bl,[eax+edi*2+0x46]
inc ecx
pop esp
js 0x32c
xor al,0x5c
js 0x330
inc ebp
pop esp
js 0x342
inc ebx
or cl,[edx]
