
obj/user/pingpongs.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 20 11 00 00       	call   801161 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 23 11 00 00       	call   80117b <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 08 40 80 00       	mov    0x804008,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 17 0b 00 00       	call   800b88 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 b0 27 80 00       	push   $0x8027b0
  800080:	e8 73 01 00 00       	call   8001f8 <cprintf>
		if (val == 10)
  800085:	a1 08 40 80 00       	mov    0x804008,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 08 40 80 00       	mov    %eax,0x804008
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 46 11 00 00       	call   8011ee <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 08 40 80 00 0a 	cmpl   $0xa,0x804008
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  8000c2:	e8 c1 0a 00 00       	call   800b88 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 80 27 80 00       	push   $0x802780
  8000d1:	e8 22 01 00 00       	call   8001f8 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 aa 0a 00 00       	call   800b88 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 9a 27 80 00       	push   $0x80279a
  8000e8:	e8 0b 01 00 00       	call   8001f8 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 f3 10 00 00       	call   8011ee <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 75 0a 00 00       	call   800b88 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80014f:	e8 17 13 00 00       	call   80146b <close_all>
	sys_env_destroy(0);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	6a 00                	push   $0x0
  800159:	e8 e9 09 00 00       	call   800b47 <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	53                   	push   %ebx
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016d:	8b 13                	mov    (%ebx),%edx
  80016f:	8d 42 01             	lea    0x1(%edx),%eax
  800172:	89 03                	mov    %eax,(%ebx)
  800174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800177:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	74 09                	je     80018b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800189:	c9                   	leave  
  80018a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 ff 00 00 00       	push   $0xff
  800193:	8d 43 08             	lea    0x8(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 6e 09 00 00       	call   800b0a <sys_cputs>
		b->idx = 0;
  80019c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	eb db                	jmp    800182 <putch+0x1f>

008001a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 63 01 80 00       	push   $0x800163
  8001d6:	e8 19 01 00 00       	call   8002f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 1a 09 00 00       	call   800b0a <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 9d ff ff ff       	call   8001a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800222:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800230:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800233:	3b 45 10             	cmp    0x10(%ebp),%eax
  800236:	89 d0                	mov    %edx,%eax
  800238:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80023b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80023e:	73 15                	jae    800255 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800240:	83 eb 01             	sub    $0x1,%ebx
  800243:	85 db                	test   %ebx,%ebx
  800245:	7e 43                	jle    80028a <printnum+0x7e>
			putch(padc, putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	ff d7                	call   *%edi
  800250:	83 c4 10             	add    $0x10,%esp
  800253:	eb eb                	jmp    800240 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 18             	pushl  0x18(%ebp)
  80025b:	8b 45 14             	mov    0x14(%ebp),%eax
  80025e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800261:	53                   	push   %ebx
  800262:	ff 75 10             	pushl  0x10(%ebp)
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 e0             	pushl  -0x20(%ebp)
  80026e:	ff 75 dc             	pushl  -0x24(%ebp)
  800271:	ff 75 d8             	pushl  -0x28(%ebp)
  800274:	e8 a7 22 00 00       	call   802520 <__udivdi3>
  800279:	83 c4 18             	add    $0x18,%esp
  80027c:	52                   	push   %edx
  80027d:	50                   	push   %eax
  80027e:	89 f2                	mov    %esi,%edx
  800280:	89 f8                	mov    %edi,%eax
  800282:	e8 85 ff ff ff       	call   80020c <printnum>
  800287:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 e4             	pushl  -0x1c(%ebp)
  800294:	ff 75 e0             	pushl  -0x20(%ebp)
  800297:	ff 75 dc             	pushl  -0x24(%ebp)
  80029a:	ff 75 d8             	pushl  -0x28(%ebp)
  80029d:	e8 8e 23 00 00       	call   802630 <__umoddi3>
  8002a2:	83 c4 14             	add    $0x14,%esp
  8002a5:	0f be 80 e0 27 80 00 	movsbl 0x8027e0(%eax),%eax
  8002ac:	50                   	push   %eax
  8002ad:	ff d7                	call   *%edi
}
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c4:	8b 10                	mov    (%eax),%edx
  8002c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c9:	73 0a                	jae    8002d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	88 02                	mov    %al,(%edx)
}
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <printfmt>:
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e0:	50                   	push   %eax
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	ff 75 0c             	pushl  0xc(%ebp)
  8002e7:	ff 75 08             	pushl  0x8(%ebp)
  8002ea:	e8 05 00 00 00       	call   8002f4 <vprintfmt>
}
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <vprintfmt>:
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 3c             	sub    $0x3c,%esp
  8002fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800303:	8b 7d 10             	mov    0x10(%ebp),%edi
  800306:	eb 0a                	jmp    800312 <vprintfmt+0x1e>
			putch(ch, putdat);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	53                   	push   %ebx
  80030c:	50                   	push   %eax
  80030d:	ff d6                	call   *%esi
  80030f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800312:	83 c7 01             	add    $0x1,%edi
  800315:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800319:	83 f8 25             	cmp    $0x25,%eax
  80031c:	74 0c                	je     80032a <vprintfmt+0x36>
			if (ch == '\0')
  80031e:	85 c0                	test   %eax,%eax
  800320:	75 e6                	jne    800308 <vprintfmt+0x14>
}
  800322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800325:	5b                   	pop    %ebx
  800326:	5e                   	pop    %esi
  800327:	5f                   	pop    %edi
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 ba 03 00 00    	ja     800716 <vprintfmt+0x422>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
  800366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800369:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036d:	eb d9                	jmp    800348 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800372:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800376:	eb d0                	jmp    800348 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800378:	0f b6 d2             	movzbl %dl,%edx
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800386:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800389:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800390:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800393:	83 f9 09             	cmp    $0x9,%ecx
  800396:	77 55                	ja     8003ed <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800398:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039b:	eb e9                	jmp    800386 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8d 40 04             	lea    0x4(%eax),%eax
  8003ab:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b5:	79 91                	jns    800348 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c4:	eb 82                	jmp    800348 <vprintfmt+0x54>
  8003c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	0f 49 d0             	cmovns %eax,%edx
  8003d3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d9:	e9 6a ff ff ff       	jmp    800348 <vprintfmt+0x54>
  8003de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e8:	e9 5b ff ff ff       	jmp    800348 <vprintfmt+0x54>
  8003ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f3:	eb bc                	jmp    8003b1 <vprintfmt+0xbd>
			lflag++;
  8003f5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fb:	e9 48 ff ff ff       	jmp    800348 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 78 04             	lea    0x4(%eax),%edi
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	53                   	push   %ebx
  80040a:	ff 30                	pushl  (%eax)
  80040c:	ff d6                	call   *%esi
			break;
  80040e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800414:	e9 9c 02 00 00       	jmp    8006b5 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	99                   	cltd   
  800422:	31 d0                	xor    %edx,%eax
  800424:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800426:	83 f8 0f             	cmp    $0xf,%eax
  800429:	7f 23                	jg     80044e <vprintfmt+0x15a>
  80042b:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  800432:	85 d2                	test   %edx,%edx
  800434:	74 18                	je     80044e <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800436:	52                   	push   %edx
  800437:	68 62 2d 80 00       	push   $0x802d62
  80043c:	53                   	push   %ebx
  80043d:	56                   	push   %esi
  80043e:	e8 94 fe ff ff       	call   8002d7 <printfmt>
  800443:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800446:	89 7d 14             	mov    %edi,0x14(%ebp)
  800449:	e9 67 02 00 00       	jmp    8006b5 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80044e:	50                   	push   %eax
  80044f:	68 f8 27 80 00       	push   $0x8027f8
  800454:	53                   	push   %ebx
  800455:	56                   	push   %esi
  800456:	e8 7c fe ff ff       	call   8002d7 <printfmt>
  80045b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800461:	e9 4f 02 00 00       	jmp    8006b5 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800466:	8b 45 14             	mov    0x14(%ebp),%eax
  800469:	83 c0 04             	add    $0x4,%eax
  80046c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80046f:	8b 45 14             	mov    0x14(%ebp),%eax
  800472:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800474:	85 d2                	test   %edx,%edx
  800476:	b8 f1 27 80 00       	mov    $0x8027f1,%eax
  80047b:	0f 45 c2             	cmovne %edx,%eax
  80047e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800481:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800485:	7e 06                	jle    80048d <vprintfmt+0x199>
  800487:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048b:	75 0d                	jne    80049a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800490:	89 c7                	mov    %eax,%edi
  800492:	03 45 e0             	add    -0x20(%ebp),%eax
  800495:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800498:	eb 3f                	jmp    8004d9 <vprintfmt+0x1e5>
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a0:	50                   	push   %eax
  8004a1:	e8 0d 03 00 00       	call   8007b3 <strnlen>
  8004a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a9:	29 c2                	sub    %eax,%edx
  8004ab:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	85 ff                	test   %edi,%edi
  8004bc:	7e 58                	jle    800516 <vprintfmt+0x222>
					putch(padc, putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	53                   	push   %ebx
  8004c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c7:	83 ef 01             	sub    $0x1,%edi
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	eb eb                	jmp    8004ba <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	52                   	push   %edx
  8004d4:	ff d6                	call   *%esi
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004dc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004de:	83 c7 01             	add    $0x1,%edi
  8004e1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e5:	0f be d0             	movsbl %al,%edx
  8004e8:	85 d2                	test   %edx,%edx
  8004ea:	74 45                	je     800531 <vprintfmt+0x23d>
  8004ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f0:	78 06                	js     8004f8 <vprintfmt+0x204>
  8004f2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f6:	78 35                	js     80052d <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fc:	74 d1                	je     8004cf <vprintfmt+0x1db>
  8004fe:	0f be c0             	movsbl %al,%eax
  800501:	83 e8 20             	sub    $0x20,%eax
  800504:	83 f8 5e             	cmp    $0x5e,%eax
  800507:	76 c6                	jbe    8004cf <vprintfmt+0x1db>
					putch('?', putdat);
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	53                   	push   %ebx
  80050d:	6a 3f                	push   $0x3f
  80050f:	ff d6                	call   *%esi
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb c3                	jmp    8004d9 <vprintfmt+0x1e5>
  800516:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800519:	85 d2                	test   %edx,%edx
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	0f 49 c2             	cmovns %edx,%eax
  800523:	29 c2                	sub    %eax,%edx
  800525:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800528:	e9 60 ff ff ff       	jmp    80048d <vprintfmt+0x199>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 02                	jmp    800533 <vprintfmt+0x23f>
  800531:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800533:	85 ff                	test   %edi,%edi
  800535:	7e 10                	jle    800547 <vprintfmt+0x253>
				putch(' ', putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	6a 20                	push   $0x20
  80053d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053f:	83 ef 01             	sub    $0x1,%edi
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb ec                	jmp    800533 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 63 01 00 00       	jmp    8006b5 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1b                	jg     800572 <vprintfmt+0x27e>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 63                	je     8005be <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	99                   	cltd   
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb 17                	jmp    800589 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 50 04             	mov    0x4(%eax),%edx
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 08             	lea    0x8(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800594:	85 c9                	test   %ecx,%ecx
  800596:	0f 89 ff 00 00 00    	jns    80069b <vprintfmt+0x3a7>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005aa:	f7 da                	neg    %edx
  8005ac:	83 d1 00             	adc    $0x0,%ecx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 dd 00 00 00       	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	99                   	cltd   
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	eb b4                	jmp    800589 <vprintfmt+0x295>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7f 1e                	jg     8005f8 <vprintfmt+0x304>
	else if (lflag)
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	74 32                	je     800610 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f3:	e9 a3 00 00 00       	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060b:	e9 8b 00 00 00       	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	eb 74                	jmp    80069b <vprintfmt+0x3a7>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x353>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800640:	b8 08 00 00 00       	mov    $0x8,%eax
  800645:	eb 54                	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
  80065a:	eb 3f                	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
  800671:	eb 28                	jmp    80069b <vprintfmt+0x3a7>
			putch('0', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 30                	push   $0x30
  800679:	ff d6                	call   *%esi
			putch('x', putdat);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 78                	push   $0x78
  800681:	ff d6                	call   *%esi
			num = (unsigned long long)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006a2:	57                   	push   %edi
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	50                   	push   %eax
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	89 da                	mov    %ebx,%edx
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	e8 5a fb ff ff       	call   80020c <printnum>
			break;
  8006b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b8:	e9 55 fc ff ff       	jmp    800312 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006bd:	83 f9 01             	cmp    $0x1,%ecx
  8006c0:	7f 1b                	jg     8006dd <vprintfmt+0x3e9>
	else if (lflag)
  8006c2:	85 c9                	test   %ecx,%ecx
  8006c4:	74 2c                	je     8006f2 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 10                	mov    (%eax),%edx
  8006cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8006db:	eb be                	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f0:	eb a9                	jmp    80069b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 10                	mov    (%eax),%edx
  8006f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	b8 10 00 00 00       	mov    $0x10,%eax
  800707:	eb 92                	jmp    80069b <vprintfmt+0x3a7>
			putch(ch, putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 25                	push   $0x25
  80070f:	ff d6                	call   *%esi
			break;
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	eb 9f                	jmp    8006b5 <vprintfmt+0x3c1>
			putch('%', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 25                	push   $0x25
  80071c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	89 f8                	mov    %edi,%eax
  800723:	eb 03                	jmp    800728 <vprintfmt+0x434>
  800725:	83 e8 01             	sub    $0x1,%eax
  800728:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80072c:	75 f7                	jne    800725 <vprintfmt+0x431>
  80072e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800731:	eb 82                	jmp    8006b5 <vprintfmt+0x3c1>

00800733 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 18             	sub    $0x18,%esp
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80073f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800742:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800746:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800750:	85 c0                	test   %eax,%eax
  800752:	74 26                	je     80077a <vsnprintf+0x47>
  800754:	85 d2                	test   %edx,%edx
  800756:	7e 22                	jle    80077a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800758:	ff 75 14             	pushl  0x14(%ebp)
  80075b:	ff 75 10             	pushl  0x10(%ebp)
  80075e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800761:	50                   	push   %eax
  800762:	68 ba 02 80 00       	push   $0x8002ba
  800767:	e8 88 fb ff ff       	call   8002f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80076c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80076f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    
		return -E_INVAL;
  80077a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077f:	eb f7                	jmp    800778 <vsnprintf+0x45>

00800781 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80078a:	50                   	push   %eax
  80078b:	ff 75 10             	pushl  0x10(%ebp)
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	ff 75 08             	pushl  0x8(%ebp)
  800794:	e8 9a ff ff ff       	call   800733 <vsnprintf>
	va_end(ap);

	return rc;
}
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007aa:	74 05                	je     8007b1 <strlen+0x16>
		n++;
  8007ac:	83 c0 01             	add    $0x1,%eax
  8007af:	eb f5                	jmp    8007a6 <strlen+0xb>
	return n;
}
  8007b1:	5d                   	pop    %ebp
  8007b2:	c3                   	ret    

008007b3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	39 c2                	cmp    %eax,%edx
  8007c3:	74 0d                	je     8007d2 <strnlen+0x1f>
  8007c5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007c9:	74 05                	je     8007d0 <strnlen+0x1d>
		n++;
  8007cb:	83 c2 01             	add    $0x1,%edx
  8007ce:	eb f1                	jmp    8007c1 <strnlen+0xe>
  8007d0:	89 d0                	mov    %edx,%eax
	return n;
}
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	53                   	push   %ebx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007e7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007ea:	83 c2 01             	add    $0x1,%edx
  8007ed:	84 c9                	test   %cl,%cl
  8007ef:	75 f2                	jne    8007e3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007f1:	5b                   	pop    %ebx
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 10             	sub    $0x10,%esp
  8007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fe:	53                   	push   %ebx
  8007ff:	e8 97 ff ff ff       	call   80079b <strlen>
  800804:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	01 d8                	add    %ebx,%eax
  80080c:	50                   	push   %eax
  80080d:	e8 c2 ff ff ff       	call   8007d4 <strcpy>
	return dst;
}
  800812:	89 d8                	mov    %ebx,%eax
  800814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800817:	c9                   	leave  
  800818:	c3                   	ret    

00800819 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800824:	89 c6                	mov    %eax,%esi
  800826:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800829:	89 c2                	mov    %eax,%edx
  80082b:	39 f2                	cmp    %esi,%edx
  80082d:	74 11                	je     800840 <strncpy+0x27>
		*dst++ = *src;
  80082f:	83 c2 01             	add    $0x1,%edx
  800832:	0f b6 19             	movzbl (%ecx),%ebx
  800835:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800838:	80 fb 01             	cmp    $0x1,%bl
  80083b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80083e:	eb eb                	jmp    80082b <strncpy+0x12>
	}
	return ret;
}
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	56                   	push   %esi
  800848:	53                   	push   %ebx
  800849:	8b 75 08             	mov    0x8(%ebp),%esi
  80084c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084f:	8b 55 10             	mov    0x10(%ebp),%edx
  800852:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800854:	85 d2                	test   %edx,%edx
  800856:	74 21                	je     800879 <strlcpy+0x35>
  800858:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80085c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80085e:	39 c2                	cmp    %eax,%edx
  800860:	74 14                	je     800876 <strlcpy+0x32>
  800862:	0f b6 19             	movzbl (%ecx),%ebx
  800865:	84 db                	test   %bl,%bl
  800867:	74 0b                	je     800874 <strlcpy+0x30>
			*dst++ = *src++;
  800869:	83 c1 01             	add    $0x1,%ecx
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800872:	eb ea                	jmp    80085e <strlcpy+0x1a>
  800874:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800876:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800879:	29 f0                	sub    %esi,%eax
}
  80087b:	5b                   	pop    %ebx
  80087c:	5e                   	pop    %esi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800885:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800888:	0f b6 01             	movzbl (%ecx),%eax
  80088b:	84 c0                	test   %al,%al
  80088d:	74 0c                	je     80089b <strcmp+0x1c>
  80088f:	3a 02                	cmp    (%edx),%al
  800891:	75 08                	jne    80089b <strcmp+0x1c>
		p++, q++;
  800893:	83 c1 01             	add    $0x1,%ecx
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	eb ed                	jmp    800888 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089b:	0f b6 c0             	movzbl %al,%eax
  80089e:	0f b6 12             	movzbl (%edx),%edx
  8008a1:	29 d0                	sub    %edx,%eax
}
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	53                   	push   %ebx
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008af:	89 c3                	mov    %eax,%ebx
  8008b1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b4:	eb 06                	jmp    8008bc <strncmp+0x17>
		n--, p++, q++;
  8008b6:	83 c0 01             	add    $0x1,%eax
  8008b9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 16                	je     8008d6 <strncmp+0x31>
  8008c0:	0f b6 08             	movzbl (%eax),%ecx
  8008c3:	84 c9                	test   %cl,%cl
  8008c5:	74 04                	je     8008cb <strncmp+0x26>
  8008c7:	3a 0a                	cmp    (%edx),%cl
  8008c9:	74 eb                	je     8008b6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cb:	0f b6 00             	movzbl (%eax),%eax
  8008ce:	0f b6 12             	movzbl (%edx),%edx
  8008d1:	29 d0                	sub    %edx,%eax
}
  8008d3:	5b                   	pop    %ebx
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    
		return 0;
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008db:	eb f6                	jmp    8008d3 <strncmp+0x2e>

008008dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
  8008ea:	84 d2                	test   %dl,%dl
  8008ec:	74 09                	je     8008f7 <strchr+0x1a>
		if (*s == c)
  8008ee:	38 ca                	cmp    %cl,%dl
  8008f0:	74 0a                	je     8008fc <strchr+0x1f>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strchr+0xa>
			return (char *) s;
	return 0;
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800908:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090b:	38 ca                	cmp    %cl,%dl
  80090d:	74 09                	je     800918 <strfind+0x1a>
  80090f:	84 d2                	test   %dl,%dl
  800911:	74 05                	je     800918 <strfind+0x1a>
	for (; *s; s++)
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	eb f0                	jmp    800908 <strfind+0xa>
			break;
	return (char *) s;
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	57                   	push   %edi
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 7d 08             	mov    0x8(%ebp),%edi
  800923:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800926:	85 c9                	test   %ecx,%ecx
  800928:	74 31                	je     80095b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092a:	89 f8                	mov    %edi,%eax
  80092c:	09 c8                	or     %ecx,%eax
  80092e:	a8 03                	test   $0x3,%al
  800930:	75 23                	jne    800955 <memset+0x3b>
		c &= 0xFF;
  800932:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800936:	89 d3                	mov    %edx,%ebx
  800938:	c1 e3 08             	shl    $0x8,%ebx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 18             	shl    $0x18,%eax
  800940:	89 d6                	mov    %edx,%esi
  800942:	c1 e6 10             	shl    $0x10,%esi
  800945:	09 f0                	or     %esi,%eax
  800947:	09 c2                	or     %eax,%edx
  800949:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80094e:	89 d0                	mov    %edx,%eax
  800950:	fc                   	cld    
  800951:	f3 ab                	rep stos %eax,%es:(%edi)
  800953:	eb 06                	jmp    80095b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	fc                   	cld    
  800959:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	57                   	push   %edi
  800966:	56                   	push   %esi
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800970:	39 c6                	cmp    %eax,%esi
  800972:	73 32                	jae    8009a6 <memmove+0x44>
  800974:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800977:	39 c2                	cmp    %eax,%edx
  800979:	76 2b                	jbe    8009a6 <memmove+0x44>
		s += n;
		d += n;
  80097b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097e:	89 fe                	mov    %edi,%esi
  800980:	09 ce                	or     %ecx,%esi
  800982:	09 d6                	or     %edx,%esi
  800984:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098a:	75 0e                	jne    80099a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80098c:	83 ef 04             	sub    $0x4,%edi
  80098f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800992:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800995:	fd                   	std    
  800996:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800998:	eb 09                	jmp    8009a3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099a:	83 ef 01             	sub    $0x1,%edi
  80099d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a0:	fd                   	std    
  8009a1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a3:	fc                   	cld    
  8009a4:	eb 1a                	jmp    8009c0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a6:	89 c2                	mov    %eax,%edx
  8009a8:	09 ca                	or     %ecx,%edx
  8009aa:	09 f2                	or     %esi,%edx
  8009ac:	f6 c2 03             	test   $0x3,%dl
  8009af:	75 0a                	jne    8009bb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b4:	89 c7                	mov    %eax,%edi
  8009b6:	fc                   	cld    
  8009b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b9:	eb 05                	jmp    8009c0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009bb:	89 c7                	mov    %eax,%edi
  8009bd:	fc                   	cld    
  8009be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009ca:	ff 75 10             	pushl  0x10(%ebp)
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	ff 75 08             	pushl  0x8(%ebp)
  8009d3:	e8 8a ff ff ff       	call   800962 <memmove>
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	56                   	push   %esi
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	89 c6                	mov    %eax,%esi
  8009e7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ea:	39 f0                	cmp    %esi,%eax
  8009ec:	74 1c                	je     800a0a <memcmp+0x30>
		if (*s1 != *s2)
  8009ee:	0f b6 08             	movzbl (%eax),%ecx
  8009f1:	0f b6 1a             	movzbl (%edx),%ebx
  8009f4:	38 d9                	cmp    %bl,%cl
  8009f6:	75 08                	jne    800a00 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f8:	83 c0 01             	add    $0x1,%eax
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	eb ea                	jmp    8009ea <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a00:	0f b6 c1             	movzbl %cl,%eax
  800a03:	0f b6 db             	movzbl %bl,%ebx
  800a06:	29 d8                	sub    %ebx,%eax
  800a08:	eb 05                	jmp    800a0f <memcmp+0x35>
	}

	return 0;
  800a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a1c:	89 c2                	mov    %eax,%edx
  800a1e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a21:	39 d0                	cmp    %edx,%eax
  800a23:	73 09                	jae    800a2e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a25:	38 08                	cmp    %cl,(%eax)
  800a27:	74 05                	je     800a2e <memfind+0x1b>
	for (; s < ends; s++)
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	eb f3                	jmp    800a21 <memfind+0xe>
			break;
	return (void *) s;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	57                   	push   %edi
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3c:	eb 03                	jmp    800a41 <strtol+0x11>
		s++;
  800a3e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a41:	0f b6 01             	movzbl (%ecx),%eax
  800a44:	3c 20                	cmp    $0x20,%al
  800a46:	74 f6                	je     800a3e <strtol+0xe>
  800a48:	3c 09                	cmp    $0x9,%al
  800a4a:	74 f2                	je     800a3e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a4c:	3c 2b                	cmp    $0x2b,%al
  800a4e:	74 2a                	je     800a7a <strtol+0x4a>
	int neg = 0;
  800a50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a55:	3c 2d                	cmp    $0x2d,%al
  800a57:	74 2b                	je     800a84 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a59:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5f:	75 0f                	jne    800a70 <strtol+0x40>
  800a61:	80 39 30             	cmpb   $0x30,(%ecx)
  800a64:	74 28                	je     800a8e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a66:	85 db                	test   %ebx,%ebx
  800a68:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6d:	0f 44 d8             	cmove  %eax,%ebx
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a78:	eb 50                	jmp    800aca <strtol+0x9a>
		s++;
  800a7a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a82:	eb d5                	jmp    800a59 <strtol+0x29>
		s++, neg = 1;
  800a84:	83 c1 01             	add    $0x1,%ecx
  800a87:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8c:	eb cb                	jmp    800a59 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a92:	74 0e                	je     800aa2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a94:	85 db                	test   %ebx,%ebx
  800a96:	75 d8                	jne    800a70 <strtol+0x40>
		s++, base = 8;
  800a98:	83 c1 01             	add    $0x1,%ecx
  800a9b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa0:	eb ce                	jmp    800a70 <strtol+0x40>
		s += 2, base = 16;
  800aa2:	83 c1 02             	add    $0x2,%ecx
  800aa5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aaa:	eb c4                	jmp    800a70 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aac:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aaf:	89 f3                	mov    %esi,%ebx
  800ab1:	80 fb 19             	cmp    $0x19,%bl
  800ab4:	77 29                	ja     800adf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ab6:	0f be d2             	movsbl %dl,%edx
  800ab9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800abc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abf:	7d 30                	jge    800af1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ac1:	83 c1 01             	add    $0x1,%ecx
  800ac4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aca:	0f b6 11             	movzbl (%ecx),%edx
  800acd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad0:	89 f3                	mov    %esi,%ebx
  800ad2:	80 fb 09             	cmp    $0x9,%bl
  800ad5:	77 d5                	ja     800aac <strtol+0x7c>
			dig = *s - '0';
  800ad7:	0f be d2             	movsbl %dl,%edx
  800ada:	83 ea 30             	sub    $0x30,%edx
  800add:	eb dd                	jmp    800abc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800adf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 19             	cmp    $0x19,%bl
  800ae7:	77 08                	ja     800af1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ae9:	0f be d2             	movsbl %dl,%edx
  800aec:	83 ea 37             	sub    $0x37,%edx
  800aef:	eb cb                	jmp    800abc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af5:	74 05                	je     800afc <strtol+0xcc>
		*endptr = (char *) s;
  800af7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	f7 da                	neg    %edx
  800b00:	85 ff                	test   %edi,%edi
  800b02:	0f 45 c2             	cmovne %edx,%eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	57                   	push   %edi
  800b0e:	56                   	push   %esi
  800b0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	8b 55 08             	mov    0x8(%ebp),%edx
  800b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1b:	89 c3                	mov    %eax,%ebx
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	89 c6                	mov    %eax,%esi
  800b21:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	57                   	push   %edi
  800b2c:	56                   	push   %esi
  800b2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	b8 01 00 00 00       	mov    $0x1,%eax
  800b38:	89 d1                	mov    %edx,%ecx
  800b3a:	89 d3                	mov    %edx,%ebx
  800b3c:	89 d7                	mov    %edx,%edi
  800b3e:	89 d6                	mov    %edx,%esi
  800b40:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	89 cb                	mov    %ecx,%ebx
  800b5f:	89 cf                	mov    %ecx,%edi
  800b61:	89 ce                	mov    %ecx,%esi
  800b63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b65:	85 c0                	test   %eax,%eax
  800b67:	7f 08                	jg     800b71 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b71:	83 ec 0c             	sub    $0xc,%esp
  800b74:	50                   	push   %eax
  800b75:	6a 03                	push   $0x3
  800b77:	68 df 2a 80 00       	push   $0x802adf
  800b7c:	6a 23                	push   $0x23
  800b7e:	68 fc 2a 80 00       	push   $0x802afc
  800b83:	e8 6e 18 00 00       	call   8023f6 <_panic>

00800b88 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 02 00 00 00       	mov    $0x2,%eax
  800b98:	89 d1                	mov    %edx,%ecx
  800b9a:	89 d3                	mov    %edx,%ebx
  800b9c:	89 d7                	mov    %edx,%edi
  800b9e:	89 d6                	mov    %edx,%esi
  800ba0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <sys_yield>:

void
sys_yield(void)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bcf:	be 00 00 00 00       	mov    $0x0,%esi
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bda:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be2:	89 f7                	mov    %esi,%edi
  800be4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	7f 08                	jg     800bf2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	50                   	push   %eax
  800bf6:	6a 04                	push   $0x4
  800bf8:	68 df 2a 80 00       	push   $0x802adf
  800bfd:	6a 23                	push   $0x23
  800bff:	68 fc 2a 80 00       	push   $0x802afc
  800c04:	e8 ed 17 00 00       	call   8023f6 <_panic>

00800c09 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	b8 05 00 00 00       	mov    $0x5,%eax
  800c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c20:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c23:	8b 75 18             	mov    0x18(%ebp),%esi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	50                   	push   %eax
  800c38:	6a 05                	push   $0x5
  800c3a:	68 df 2a 80 00       	push   $0x802adf
  800c3f:	6a 23                	push   $0x23
  800c41:	68 fc 2a 80 00       	push   $0x802afc
  800c46:	e8 ab 17 00 00       	call   8023f6 <_panic>

00800c4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c64:	89 df                	mov    %ebx,%edi
  800c66:	89 de                	mov    %ebx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 06                	push   $0x6
  800c7c:	68 df 2a 80 00       	push   $0x802adf
  800c81:	6a 23                	push   $0x23
  800c83:	68 fc 2a 80 00       	push   $0x802afc
  800c88:	e8 69 17 00 00       	call   8023f6 <_panic>

00800c8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7f 08                	jg     800cb8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb8:	83 ec 0c             	sub    $0xc,%esp
  800cbb:	50                   	push   %eax
  800cbc:	6a 08                	push   $0x8
  800cbe:	68 df 2a 80 00       	push   $0x802adf
  800cc3:	6a 23                	push   $0x23
  800cc5:	68 fc 2a 80 00       	push   $0x802afc
  800cca:	e8 27 17 00 00       	call   8023f6 <_panic>

00800ccf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce8:	89 df                	mov    %ebx,%edi
  800cea:	89 de                	mov    %ebx,%esi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	83 ec 0c             	sub    $0xc,%esp
  800cfd:	50                   	push   %eax
  800cfe:	6a 09                	push   $0x9
  800d00:	68 df 2a 80 00       	push   $0x802adf
  800d05:	6a 23                	push   $0x23
  800d07:	68 fc 2a 80 00       	push   $0x802afc
  800d0c:	e8 e5 16 00 00       	call   8023f6 <_panic>

00800d11 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	89 de                	mov    %ebx,%esi
  800d2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	50                   	push   %eax
  800d40:	6a 0a                	push   $0xa
  800d42:	68 df 2a 80 00       	push   $0x802adf
  800d47:	6a 23                	push   $0x23
  800d49:	68 fc 2a 80 00       	push   $0x802afc
  800d4e:	e8 a3 16 00 00       	call   8023f6 <_panic>

00800d53 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d64:	be 00 00 00 00       	mov    $0x0,%esi
  800d69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d8c:	89 cb                	mov    %ecx,%ebx
  800d8e:	89 cf                	mov    %ecx,%edi
  800d90:	89 ce                	mov    %ecx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 0d                	push   $0xd
  800da6:	68 df 2a 80 00       	push   $0x802adf
  800dab:	6a 23                	push   $0x23
  800dad:	68 fc 2a 80 00       	push   $0x802afc
  800db2:	e8 3f 16 00 00       	call   8023f6 <_panic>

00800db7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc7:	89 d1                	mov    %edx,%ecx
  800dc9:	89 d3                	mov    %edx,%ebx
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800de2:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800de4:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800de7:	89 d9                	mov    %ebx,%ecx
  800de9:	c1 e9 16             	shr    $0x16,%ecx
  800dec:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800df3:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800df8:	f6 c1 01             	test   $0x1,%cl
  800dfb:	74 0c                	je     800e09 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800dfd:	89 d9                	mov    %ebx,%ecx
  800dff:	c1 e9 0c             	shr    $0xc,%ecx
  800e02:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800e09:	f6 c2 02             	test   $0x2,%dl
  800e0c:	0f 84 a3 00 00 00    	je     800eb5 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800e12:	89 da                	mov    %ebx,%edx
  800e14:	c1 ea 0c             	shr    $0xc,%edx
  800e17:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1e:	f6 c6 08             	test   $0x8,%dh
  800e21:	0f 84 b7 00 00 00    	je     800ede <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800e27:	e8 5c fd ff ff       	call   800b88 <sys_getenvid>
  800e2c:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	6a 07                	push   $0x7
  800e33:	68 00 f0 7f 00       	push   $0x7ff000
  800e38:	50                   	push   %eax
  800e39:	e8 88 fd ff ff       	call   800bc6 <sys_page_alloc>
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	0f 88 bc 00 00 00    	js     800f05 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800e49:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e4f:	83 ec 04             	sub    $0x4,%esp
  800e52:	68 00 10 00 00       	push   $0x1000
  800e57:	53                   	push   %ebx
  800e58:	68 00 f0 7f 00       	push   $0x7ff000
  800e5d:	e8 00 fb ff ff       	call   800962 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e62:	83 c4 08             	add    $0x8,%esp
  800e65:	53                   	push   %ebx
  800e66:	56                   	push   %esi
  800e67:	e8 df fd ff ff       	call   800c4b <sys_page_unmap>
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	0f 88 a0 00 00 00    	js     800f17 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	6a 07                	push   $0x7
  800e7c:	53                   	push   %ebx
  800e7d:	56                   	push   %esi
  800e7e:	68 00 f0 7f 00       	push   $0x7ff000
  800e83:	56                   	push   %esi
  800e84:	e8 80 fd ff ff       	call   800c09 <sys_page_map>
  800e89:	83 c4 20             	add    $0x20,%esp
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	0f 88 95 00 00 00    	js     800f29 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	68 00 f0 7f 00       	push   $0x7ff000
  800e9c:	56                   	push   %esi
  800e9d:	e8 a9 fd ff ff       	call   800c4b <sys_page_unmap>
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	0f 88 8e 00 00 00    	js     800f3b <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800eb5:	8b 70 28             	mov    0x28(%eax),%esi
  800eb8:	e8 cb fc ff ff       	call   800b88 <sys_getenvid>
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	50                   	push   %eax
  800ec0:	68 0c 2b 80 00       	push   $0x802b0c
  800ec5:	e8 2e f3 ff ff       	call   8001f8 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800eca:	83 c4 0c             	add    $0xc,%esp
  800ecd:	68 30 2b 80 00       	push   $0x802b30
  800ed2:	6a 27                	push   $0x27
  800ed4:	68 04 2c 80 00       	push   $0x802c04
  800ed9:	e8 18 15 00 00       	call   8023f6 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800ede:	8b 78 28             	mov    0x28(%eax),%edi
  800ee1:	e8 a2 fc ff ff       	call   800b88 <sys_getenvid>
  800ee6:	57                   	push   %edi
  800ee7:	53                   	push   %ebx
  800ee8:	50                   	push   %eax
  800ee9:	68 0c 2b 80 00       	push   $0x802b0c
  800eee:	e8 05 f3 ff ff       	call   8001f8 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800ef3:	56                   	push   %esi
  800ef4:	68 64 2b 80 00       	push   $0x802b64
  800ef9:	6a 2b                	push   $0x2b
  800efb:	68 04 2c 80 00       	push   $0x802c04
  800f00:	e8 f1 14 00 00       	call   8023f6 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800f05:	50                   	push   %eax
  800f06:	68 9c 2b 80 00       	push   $0x802b9c
  800f0b:	6a 39                	push   $0x39
  800f0d:	68 04 2c 80 00       	push   $0x802c04
  800f12:	e8 df 14 00 00       	call   8023f6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f17:	50                   	push   %eax
  800f18:	68 c0 2b 80 00       	push   $0x802bc0
  800f1d:	6a 3e                	push   $0x3e
  800f1f:	68 04 2c 80 00       	push   $0x802c04
  800f24:	e8 cd 14 00 00       	call   8023f6 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800f29:	50                   	push   %eax
  800f2a:	68 0f 2c 80 00       	push   $0x802c0f
  800f2f:	6a 40                	push   $0x40
  800f31:	68 04 2c 80 00       	push   $0x802c04
  800f36:	e8 bb 14 00 00       	call   8023f6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f3b:	50                   	push   %eax
  800f3c:	68 c0 2b 80 00       	push   $0x802bc0
  800f41:	6a 42                	push   $0x42
  800f43:	68 04 2c 80 00       	push   $0x802c04
  800f48:	e8 a9 14 00 00       	call   8023f6 <_panic>

00800f4d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f56:	68 d6 0d 80 00       	push   $0x800dd6
  800f5b:	e8 dc 14 00 00       	call   80243c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f60:	b8 07 00 00 00       	mov    $0x7,%eax
  800f65:	cd 30                	int    $0x30
  800f67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	78 2d                	js     800f9e <fork+0x51>
  800f71:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800f78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7c:	0f 85 a6 00 00 00    	jne    801028 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800f82:	e8 01 fc ff ff       	call   800b88 <sys_getenvid>
  800f87:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f8c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f8f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f94:	a3 0c 40 80 00       	mov    %eax,0x80400c
      return 0;
  800f99:	e9 79 01 00 00       	jmp    801117 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800f9e:	50                   	push   %eax
  800f9f:	68 2d 2c 80 00       	push   $0x802c2d
  800fa4:	68 aa 00 00 00       	push   $0xaa
  800fa9:	68 04 2c 80 00       	push   $0x802c04
  800fae:	e8 43 14 00 00       	call   8023f6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	6a 05                	push   $0x5
  800fb8:	53                   	push   %ebx
  800fb9:	57                   	push   %edi
  800fba:	53                   	push   %ebx
  800fbb:	6a 00                	push   $0x0
  800fbd:	e8 47 fc ff ff       	call   800c09 <sys_page_map>
  800fc2:	83 c4 20             	add    $0x20,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	79 4d                	jns    801016 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  800fc9:	50                   	push   %eax
  800fca:	68 36 2c 80 00       	push   $0x802c36
  800fcf:	6a 61                	push   $0x61
  800fd1:	68 04 2c 80 00       	push   $0x802c04
  800fd6:	e8 1b 14 00 00       	call   8023f6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	68 05 08 00 00       	push   $0x805
  800fe3:	53                   	push   %ebx
  800fe4:	57                   	push   %edi
  800fe5:	53                   	push   %ebx
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 1c fc ff ff       	call   800c09 <sys_page_map>
  800fed:	83 c4 20             	add    $0x20,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	0f 88 b7 00 00 00    	js     8010af <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	68 05 08 00 00       	push   $0x805
  801000:	53                   	push   %ebx
  801001:	6a 00                	push   $0x0
  801003:	53                   	push   %ebx
  801004:	6a 00                	push   $0x0
  801006:	e8 fe fb ff ff       	call   800c09 <sys_page_map>
  80100b:	83 c4 20             	add    $0x20,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	0f 88 ab 00 00 00    	js     8010c1 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801016:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80101c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801022:	0f 84 ab 00 00 00    	je     8010d3 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801028:	89 d8                	mov    %ebx,%eax
  80102a:	c1 e8 16             	shr    $0x16,%eax
  80102d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801034:	a8 01                	test   $0x1,%al
  801036:	74 de                	je     801016 <fork+0xc9>
  801038:	89 d8                	mov    %ebx,%eax
  80103a:	c1 e8 0c             	shr    $0xc,%eax
  80103d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801044:	f6 c2 01             	test   $0x1,%dl
  801047:	74 cd                	je     801016 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801049:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  80104c:	89 c2                	mov    %eax,%edx
  80104e:	c1 ea 16             	shr    $0x16,%edx
  801051:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801058:	f6 c2 01             	test   $0x1,%dl
  80105b:	74 b9                	je     801016 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80105d:	c1 e8 0c             	shr    $0xc,%eax
  801060:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801067:	a8 01                	test   $0x1,%al
  801069:	74 ab                	je     801016 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  80106b:	a9 02 08 00 00       	test   $0x802,%eax
  801070:	0f 84 3d ff ff ff    	je     800fb3 <fork+0x66>
	else if(pte & PTE_SHARE)
  801076:	f6 c4 04             	test   $0x4,%ah
  801079:	0f 84 5c ff ff ff    	je     800fdb <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	25 07 0e 00 00       	and    $0xe07,%eax
  801087:	50                   	push   %eax
  801088:	53                   	push   %ebx
  801089:	57                   	push   %edi
  80108a:	53                   	push   %ebx
  80108b:	6a 00                	push   $0x0
  80108d:	e8 77 fb ff ff       	call   800c09 <sys_page_map>
  801092:	83 c4 20             	add    $0x20,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	0f 89 79 ff ff ff    	jns    801016 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80109d:	50                   	push   %eax
  80109e:	68 36 2c 80 00       	push   $0x802c36
  8010a3:	6a 67                	push   $0x67
  8010a5:	68 04 2c 80 00       	push   $0x802c04
  8010aa:	e8 47 13 00 00       	call   8023f6 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010af:	50                   	push   %eax
  8010b0:	68 36 2c 80 00       	push   $0x802c36
  8010b5:	6a 6d                	push   $0x6d
  8010b7:	68 04 2c 80 00       	push   $0x802c04
  8010bc:	e8 35 13 00 00       	call   8023f6 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010c1:	50                   	push   %eax
  8010c2:	68 36 2c 80 00       	push   $0x802c36
  8010c7:	6a 70                	push   $0x70
  8010c9:	68 04 2c 80 00       	push   $0x802c04
  8010ce:	e8 23 13 00 00       	call   8023f6 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	6a 07                	push   $0x7
  8010d8:	68 00 f0 bf ee       	push   $0xeebff000
  8010dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e0:	e8 e1 fa ff ff       	call   800bc6 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	78 36                	js     801122 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	68 b2 24 80 00       	push   $0x8024b2
  8010f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f7:	e8 15 fc ff ff       	call   800d11 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 34                	js     801137 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	6a 02                	push   $0x2
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	e8 7d fb ff ff       	call   800c8d <sys_env_set_status>
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	78 35                	js     80114c <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  801117:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80111a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5f                   	pop    %edi
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801122:	50                   	push   %eax
  801123:	68 2d 2c 80 00       	push   $0x802c2d
  801128:	68 ba 00 00 00       	push   $0xba
  80112d:	68 04 2c 80 00       	push   $0x802c04
  801132:	e8 bf 12 00 00       	call   8023f6 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801137:	50                   	push   %eax
  801138:	68 e0 2b 80 00       	push   $0x802be0
  80113d:	68 bf 00 00 00       	push   $0xbf
  801142:	68 04 2c 80 00       	push   $0x802c04
  801147:	e8 aa 12 00 00       	call   8023f6 <_panic>
      panic("sys_env_set_status: %e", r);
  80114c:	50                   	push   %eax
  80114d:	68 4a 2c 80 00       	push   $0x802c4a
  801152:	68 c3 00 00 00       	push   $0xc3
  801157:	68 04 2c 80 00       	push   $0x802c04
  80115c:	e8 95 12 00 00       	call   8023f6 <_panic>

00801161 <sfork>:

// Challenge!
int
sfork(void)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801167:	68 61 2c 80 00       	push   $0x802c61
  80116c:	68 cc 00 00 00       	push   $0xcc
  801171:	68 04 2c 80 00       	push   $0x802c04
  801176:	e8 7b 12 00 00       	call   8023f6 <_panic>

0080117b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
  801180:	8b 75 08             	mov    0x8(%ebp),%esi
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801189:	85 c0                	test   %eax,%eax
  80118b:	74 4f                	je     8011dc <ipc_recv+0x61>
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	50                   	push   %eax
  801191:	e8 e0 fb ff ff       	call   800d76 <sys_ipc_recv>
  801196:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801199:	85 f6                	test   %esi,%esi
  80119b:	74 14                	je     8011b1 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80119d:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	75 09                	jne    8011af <ipc_recv+0x34>
  8011a6:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8011ac:	8b 52 74             	mov    0x74(%edx),%edx
  8011af:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8011b1:	85 db                	test   %ebx,%ebx
  8011b3:	74 14                	je     8011c9 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8011b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	75 09                	jne    8011c7 <ipc_recv+0x4c>
  8011be:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8011c4:	8b 52 78             	mov    0x78(%edx),%edx
  8011c7:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	75 08                	jne    8011d5 <ipc_recv+0x5a>
  8011cd:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011d2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	68 00 00 c0 ee       	push   $0xeec00000
  8011e4:	e8 8d fb ff ff       	call   800d76 <sys_ipc_recv>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	eb ab                	jmp    801199 <ipc_recv+0x1e>

008011ee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011fa:	8b 75 10             	mov    0x10(%ebp),%esi
  8011fd:	eb 20                	jmp    80121f <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8011ff:	6a 00                	push   $0x0
  801201:	68 00 00 c0 ee       	push   $0xeec00000
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	57                   	push   %edi
  80120a:	e8 44 fb ff ff       	call   800d53 <sys_ipc_try_send>
  80120f:	89 c3                	mov    %eax,%ebx
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	eb 1f                	jmp    801235 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801216:	e8 8c f9 ff ff       	call   800ba7 <sys_yield>
	while(retval != 0) {
  80121b:	85 db                	test   %ebx,%ebx
  80121d:	74 33                	je     801252 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80121f:	85 f6                	test   %esi,%esi
  801221:	74 dc                	je     8011ff <ipc_send+0x11>
  801223:	ff 75 14             	pushl  0x14(%ebp)
  801226:	56                   	push   %esi
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	57                   	push   %edi
  80122b:	e8 23 fb ff ff       	call   800d53 <sys_ipc_try_send>
  801230:	89 c3                	mov    %eax,%ebx
  801232:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801235:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801238:	74 dc                	je     801216 <ipc_send+0x28>
  80123a:	85 db                	test   %ebx,%ebx
  80123c:	74 d8                	je     801216 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	68 78 2c 80 00       	push   $0x802c78
  801246:	6a 35                	push   $0x35
  801248:	68 a8 2c 80 00       	push   $0x802ca8
  80124d:	e8 a4 11 00 00       	call   8023f6 <_panic>
	}
}
  801252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801265:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801268:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80126e:	8b 52 50             	mov    0x50(%edx),%edx
  801271:	39 ca                	cmp    %ecx,%edx
  801273:	74 11                	je     801286 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801275:	83 c0 01             	add    $0x1,%eax
  801278:	3d 00 04 00 00       	cmp    $0x400,%eax
  80127d:	75 e6                	jne    801265 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	eb 0b                	jmp    801291 <ipc_find_env+0x37>
			return envs[i].env_id;
  801286:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80128e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	05 00 00 00 30       	add    $0x30000000,%eax
  80129e:	c1 e8 0c             	shr    $0xc,%eax
}
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    

008012a3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    

008012ba <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c2:	89 c2                	mov    %eax,%edx
  8012c4:	c1 ea 16             	shr    $0x16,%edx
  8012c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ce:	f6 c2 01             	test   $0x1,%dl
  8012d1:	74 2d                	je     801300 <fd_alloc+0x46>
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	c1 ea 0c             	shr    $0xc,%edx
  8012d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012df:	f6 c2 01             	test   $0x1,%dl
  8012e2:	74 1c                	je     801300 <fd_alloc+0x46>
  8012e4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ee:	75 d2                	jne    8012c2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012f9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012fe:	eb 0a                	jmp    80130a <fd_alloc+0x50>
			*fd_store = fd;
  801300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801303:	89 01                	mov    %eax,(%ecx)
			return 0;
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801312:	83 f8 1f             	cmp    $0x1f,%eax
  801315:	77 30                	ja     801347 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801317:	c1 e0 0c             	shl    $0xc,%eax
  80131a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80131f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801325:	f6 c2 01             	test   $0x1,%dl
  801328:	74 24                	je     80134e <fd_lookup+0x42>
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	c1 ea 0c             	shr    $0xc,%edx
  80132f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801336:	f6 c2 01             	test   $0x1,%dl
  801339:	74 1a                	je     801355 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80133b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133e:	89 02                	mov    %eax,(%edx)
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    
		return -E_INVAL;
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134c:	eb f7                	jmp    801345 <fd_lookup+0x39>
		return -E_INVAL;
  80134e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801353:	eb f0                	jmp    801345 <fd_lookup+0x39>
  801355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135a:	eb e9                	jmp    801345 <fd_lookup+0x39>

0080135c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801365:	ba 00 00 00 00       	mov    $0x0,%edx
  80136a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80136f:	39 08                	cmp    %ecx,(%eax)
  801371:	74 38                	je     8013ab <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801373:	83 c2 01             	add    $0x1,%edx
  801376:	8b 04 95 30 2d 80 00 	mov    0x802d30(,%edx,4),%eax
  80137d:	85 c0                	test   %eax,%eax
  80137f:	75 ee                	jne    80136f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801381:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801386:	8b 40 48             	mov    0x48(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	51                   	push   %ecx
  80138d:	50                   	push   %eax
  80138e:	68 b4 2c 80 00       	push   $0x802cb4
  801393:	e8 60 ee ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    
			*dev = devtab[i];
  8013ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ae:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	eb f2                	jmp    8013a9 <dev_lookup+0x4d>

008013b7 <fd_close>:
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	57                   	push   %edi
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
  8013bd:	83 ec 24             	sub    $0x24,%esp
  8013c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8013c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ca:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013d0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d3:	50                   	push   %eax
  8013d4:	e8 33 ff ff ff       	call   80130c <fd_lookup>
  8013d9:	89 c3                	mov    %eax,%ebx
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 05                	js     8013e7 <fd_close+0x30>
	    || fd != fd2)
  8013e2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013e5:	74 16                	je     8013fd <fd_close+0x46>
		return (must_exist ? r : 0);
  8013e7:	89 f8                	mov    %edi,%eax
  8013e9:	84 c0                	test   %al,%al
  8013eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f0:	0f 44 d8             	cmove  %eax,%ebx
}
  8013f3:	89 d8                	mov    %ebx,%eax
  8013f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f8:	5b                   	pop    %ebx
  8013f9:	5e                   	pop    %esi
  8013fa:	5f                   	pop    %edi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	ff 36                	pushl  (%esi)
  801406:	e8 51 ff ff ff       	call   80135c <dev_lookup>
  80140b:	89 c3                	mov    %eax,%ebx
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 1a                	js     80142e <fd_close+0x77>
		if (dev->dev_close)
  801414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801417:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80141a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 0b                	je     80142e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	56                   	push   %esi
  801427:	ff d0                	call   *%eax
  801429:	89 c3                	mov    %eax,%ebx
  80142b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	56                   	push   %esi
  801432:	6a 00                	push   $0x0
  801434:	e8 12 f8 ff ff       	call   800c4b <sys_page_unmap>
	return r;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	eb b5                	jmp    8013f3 <fd_close+0x3c>

0080143e <close>:

int
close(int fdnum)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 bc fe ff ff       	call   80130c <fd_lookup>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	79 02                	jns    801459 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    
		return fd_close(fd, 1);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	6a 01                	push   $0x1
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	e8 51 ff ff ff       	call   8013b7 <fd_close>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	eb ec                	jmp    801457 <close+0x19>

0080146b <close_all>:

void
close_all(void)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	53                   	push   %ebx
  80146f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801472:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801477:	83 ec 0c             	sub    $0xc,%esp
  80147a:	53                   	push   %ebx
  80147b:	e8 be ff ff ff       	call   80143e <close>
	for (i = 0; i < MAXFD; i++)
  801480:	83 c3 01             	add    $0x1,%ebx
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	83 fb 20             	cmp    $0x20,%ebx
  801489:	75 ec                	jne    801477 <close_all+0xc>
}
  80148b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	57                   	push   %edi
  801494:	56                   	push   %esi
  801495:	53                   	push   %ebx
  801496:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801499:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 08             	pushl  0x8(%ebp)
  8014a0:	e8 67 fe ff ff       	call   80130c <fd_lookup>
  8014a5:	89 c3                	mov    %eax,%ebx
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	0f 88 81 00 00 00    	js     801533 <dup+0xa3>
		return r;
	close(newfdnum);
  8014b2:	83 ec 0c             	sub    $0xc,%esp
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	e8 81 ff ff ff       	call   80143e <close>

	newfd = INDEX2FD(newfdnum);
  8014bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c0:	c1 e6 0c             	shl    $0xc,%esi
  8014c3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014c9:	83 c4 04             	add    $0x4,%esp
  8014cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014cf:	e8 cf fd ff ff       	call   8012a3 <fd2data>
  8014d4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014d6:	89 34 24             	mov    %esi,(%esp)
  8014d9:	e8 c5 fd ff ff       	call   8012a3 <fd2data>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014e3:	89 d8                	mov    %ebx,%eax
  8014e5:	c1 e8 16             	shr    $0x16,%eax
  8014e8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ef:	a8 01                	test   $0x1,%al
  8014f1:	74 11                	je     801504 <dup+0x74>
  8014f3:	89 d8                	mov    %ebx,%eax
  8014f5:	c1 e8 0c             	shr    $0xc,%eax
  8014f8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ff:	f6 c2 01             	test   $0x1,%dl
  801502:	75 39                	jne    80153d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801504:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801507:	89 d0                	mov    %edx,%eax
  801509:	c1 e8 0c             	shr    $0xc,%eax
  80150c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	25 07 0e 00 00       	and    $0xe07,%eax
  80151b:	50                   	push   %eax
  80151c:	56                   	push   %esi
  80151d:	6a 00                	push   $0x0
  80151f:	52                   	push   %edx
  801520:	6a 00                	push   $0x0
  801522:	e8 e2 f6 ff ff       	call   800c09 <sys_page_map>
  801527:	89 c3                	mov    %eax,%ebx
  801529:	83 c4 20             	add    $0x20,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 31                	js     801561 <dup+0xd1>
		goto err;

	return newfdnum;
  801530:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801533:	89 d8                	mov    %ebx,%eax
  801535:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80153d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	25 07 0e 00 00       	and    $0xe07,%eax
  80154c:	50                   	push   %eax
  80154d:	57                   	push   %edi
  80154e:	6a 00                	push   $0x0
  801550:	53                   	push   %ebx
  801551:	6a 00                	push   $0x0
  801553:	e8 b1 f6 ff ff       	call   800c09 <sys_page_map>
  801558:	89 c3                	mov    %eax,%ebx
  80155a:	83 c4 20             	add    $0x20,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	79 a3                	jns    801504 <dup+0x74>
	sys_page_unmap(0, newfd);
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	56                   	push   %esi
  801565:	6a 00                	push   $0x0
  801567:	e8 df f6 ff ff       	call   800c4b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80156c:	83 c4 08             	add    $0x8,%esp
  80156f:	57                   	push   %edi
  801570:	6a 00                	push   $0x0
  801572:	e8 d4 f6 ff ff       	call   800c4b <sys_page_unmap>
	return r;
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	eb b7                	jmp    801533 <dup+0xa3>

0080157c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	53                   	push   %ebx
  801580:	83 ec 1c             	sub    $0x1c,%esp
  801583:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801586:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801589:	50                   	push   %eax
  80158a:	53                   	push   %ebx
  80158b:	e8 7c fd ff ff       	call   80130c <fd_lookup>
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	85 c0                	test   %eax,%eax
  801595:	78 3f                	js     8015d6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159d:	50                   	push   %eax
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	ff 30                	pushl  (%eax)
  8015a3:	e8 b4 fd ff ff       	call   80135c <dev_lookup>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	78 27                	js     8015d6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b2:	8b 42 08             	mov    0x8(%edx),%eax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	83 f8 01             	cmp    $0x1,%eax
  8015bb:	74 1e                	je     8015db <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	8b 40 08             	mov    0x8(%eax),%eax
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	74 35                	je     8015fc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	52                   	push   %edx
  8015d1:	ff d0                	call   *%eax
  8015d3:	83 c4 10             	add    $0x10,%esp
}
  8015d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015db:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015e0:	8b 40 48             	mov    0x48(%eax),%eax
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	53                   	push   %ebx
  8015e7:	50                   	push   %eax
  8015e8:	68 f5 2c 80 00       	push   $0x802cf5
  8015ed:	e8 06 ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fa:	eb da                	jmp    8015d6 <read+0x5a>
		return -E_NOT_SUPP;
  8015fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801601:	eb d3                	jmp    8015d6 <read+0x5a>

00801603 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80160f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801612:	bb 00 00 00 00       	mov    $0x0,%ebx
  801617:	39 f3                	cmp    %esi,%ebx
  801619:	73 23                	jae    80163e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	89 f0                	mov    %esi,%eax
  801620:	29 d8                	sub    %ebx,%eax
  801622:	50                   	push   %eax
  801623:	89 d8                	mov    %ebx,%eax
  801625:	03 45 0c             	add    0xc(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	57                   	push   %edi
  80162a:	e8 4d ff ff ff       	call   80157c <read>
		if (m < 0)
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 06                	js     80163c <readn+0x39>
			return m;
		if (m == 0)
  801636:	74 06                	je     80163e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801638:	01 c3                	add    %eax,%ebx
  80163a:	eb db                	jmp    801617 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80163e:	89 d8                	mov    %ebx,%eax
  801640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801643:	5b                   	pop    %ebx
  801644:	5e                   	pop    %esi
  801645:	5f                   	pop    %edi
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	83 ec 1c             	sub    $0x1c,%esp
  80164f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801652:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	53                   	push   %ebx
  801657:	e8 b0 fc ff ff       	call   80130c <fd_lookup>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 3a                	js     80169d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	ff 30                	pushl  (%eax)
  80166f:	e8 e8 fc ff ff       	call   80135c <dev_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 22                	js     80169d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801682:	74 1e                	je     8016a2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801687:	8b 52 0c             	mov    0xc(%edx),%edx
  80168a:	85 d2                	test   %edx,%edx
  80168c:	74 35                	je     8016c3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	ff 75 10             	pushl  0x10(%ebp)
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	50                   	push   %eax
  801698:	ff d2                	call   *%edx
  80169a:	83 c4 10             	add    $0x10,%esp
}
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016a2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016a7:	8b 40 48             	mov    0x48(%eax),%eax
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	53                   	push   %ebx
  8016ae:	50                   	push   %eax
  8016af:	68 11 2d 80 00       	push   $0x802d11
  8016b4:	e8 3f eb ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c1:	eb da                	jmp    80169d <write+0x55>
		return -E_NOT_SUPP;
  8016c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c8:	eb d3                	jmp    80169d <write+0x55>

008016ca <seek>:

int
seek(int fdnum, off_t offset)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d3:	50                   	push   %eax
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	e8 30 fc ff ff       	call   80130c <fd_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 0e                	js     8016f1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	53                   	push   %ebx
  8016f7:	83 ec 1c             	sub    $0x1c,%esp
  8016fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	53                   	push   %ebx
  801702:	e8 05 fc ff ff       	call   80130c <fd_lookup>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 37                	js     801745 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801714:	50                   	push   %eax
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	ff 30                	pushl  (%eax)
  80171a:	e8 3d fc ff ff       	call   80135c <dev_lookup>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	85 c0                	test   %eax,%eax
  801724:	78 1f                	js     801745 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801729:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80172d:	74 1b                	je     80174a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80172f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801732:	8b 52 18             	mov    0x18(%edx),%edx
  801735:	85 d2                	test   %edx,%edx
  801737:	74 32                	je     80176b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801739:	83 ec 08             	sub    $0x8,%esp
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	50                   	push   %eax
  801740:	ff d2                	call   *%edx
  801742:	83 c4 10             	add    $0x10,%esp
}
  801745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801748:	c9                   	leave  
  801749:	c3                   	ret    
			thisenv->env_id, fdnum);
  80174a:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80174f:	8b 40 48             	mov    0x48(%eax),%eax
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	53                   	push   %ebx
  801756:	50                   	push   %eax
  801757:	68 d4 2c 80 00       	push   $0x802cd4
  80175c:	e8 97 ea ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801769:	eb da                	jmp    801745 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80176b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801770:	eb d3                	jmp    801745 <ftruncate+0x52>

00801772 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	53                   	push   %ebx
  801776:	83 ec 1c             	sub    $0x1c,%esp
  801779:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177f:	50                   	push   %eax
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	e8 84 fb ff ff       	call   80130c <fd_lookup>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 4b                	js     8017da <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	ff 30                	pushl  (%eax)
  80179b:	e8 bc fb ff ff       	call   80135c <dev_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 33                	js     8017da <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ae:	74 2f                	je     8017df <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ba:	00 00 00 
	stat->st_isdir = 0;
  8017bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017c4:	00 00 00 
	stat->st_dev = dev;
  8017c7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	53                   	push   %ebx
  8017d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d4:	ff 50 14             	call   *0x14(%eax)
  8017d7:	83 c4 10             	add    $0x10,%esp
}
  8017da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    
		return -E_NOT_SUPP;
  8017df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e4:	eb f4                	jmp    8017da <fstat+0x68>

008017e6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	e8 2f 02 00 00       	call   801a27 <open>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 1b                	js     80181c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	50                   	push   %eax
  801808:	e8 65 ff ff ff       	call   801772 <fstat>
  80180d:	89 c6                	mov    %eax,%esi
	close(fd);
  80180f:	89 1c 24             	mov    %ebx,(%esp)
  801812:	e8 27 fc ff ff       	call   80143e <close>
	return r;
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	89 f3                	mov    %esi,%ebx
}
  80181c:	89 d8                	mov    %ebx,%eax
  80181e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801821:	5b                   	pop    %ebx
  801822:	5e                   	pop    %esi
  801823:	5d                   	pop    %ebp
  801824:	c3                   	ret    

00801825 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
  80182a:	89 c6                	mov    %eax,%esi
  80182c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80182e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801835:	74 27                	je     80185e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801837:	6a 07                	push   $0x7
  801839:	68 00 50 80 00       	push   $0x805000
  80183e:	56                   	push   %esi
  80183f:	ff 35 00 40 80 00    	pushl  0x804000
  801845:	e8 a4 f9 ff ff       	call   8011ee <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80184a:	83 c4 0c             	add    $0xc,%esp
  80184d:	6a 00                	push   $0x0
  80184f:	53                   	push   %ebx
  801850:	6a 00                	push   $0x0
  801852:	e8 24 f9 ff ff       	call   80117b <ipc_recv>
}
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80185e:	83 ec 0c             	sub    $0xc,%esp
  801861:	6a 01                	push   $0x1
  801863:	e8 f2 f9 ff ff       	call   80125a <ipc_find_env>
  801868:	a3 00 40 80 00       	mov    %eax,0x804000
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	eb c5                	jmp    801837 <fsipc+0x12>

00801872 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8b 40 0c             	mov    0xc(%eax),%eax
  80187e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80188b:	ba 00 00 00 00       	mov    $0x0,%edx
  801890:	b8 02 00 00 00       	mov    $0x2,%eax
  801895:	e8 8b ff ff ff       	call   801825 <fsipc>
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <devfile_flush>:
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	b8 06 00 00 00       	mov    $0x6,%eax
  8018b7:	e8 69 ff ff ff       	call   801825 <fsipc>
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <devfile_stat>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ce:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8018dd:	e8 43 ff ff ff       	call   801825 <fsipc>
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 2c                	js     801912 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	68 00 50 80 00       	push   $0x805000
  8018ee:	53                   	push   %ebx
  8018ef:	e8 e0 ee ff ff       	call   8007d4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018f4:	a1 80 50 80 00       	mov    0x805080,%eax
  8018f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ff:	a1 84 50 80 00       	mov    0x805084,%eax
  801904:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <devfile_write>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	53                   	push   %ebx
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801921:	85 db                	test   %ebx,%ebx
  801923:	75 07                	jne    80192c <devfile_write+0x15>
	return n_all;
  801925:	89 d8                	mov    %ebx,%eax
}
  801927:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
  801932:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801937:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	53                   	push   %ebx
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	68 08 50 80 00       	push   $0x805008
  801949:	e8 14 f0 ff ff       	call   800962 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	b8 04 00 00 00       	mov    $0x4,%eax
  801958:	e8 c8 fe ff ff       	call   801825 <fsipc>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 c3                	js     801927 <devfile_write+0x10>
	  assert(r <= n_left);
  801964:	39 d8                	cmp    %ebx,%eax
  801966:	77 0b                	ja     801973 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801968:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80196d:	7f 1d                	jg     80198c <devfile_write+0x75>
    n_all += r;
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	eb b2                	jmp    801925 <devfile_write+0xe>
	  assert(r <= n_left);
  801973:	68 44 2d 80 00       	push   $0x802d44
  801978:	68 50 2d 80 00       	push   $0x802d50
  80197d:	68 9f 00 00 00       	push   $0x9f
  801982:	68 65 2d 80 00       	push   $0x802d65
  801987:	e8 6a 0a 00 00       	call   8023f6 <_panic>
	  assert(r <= PGSIZE);
  80198c:	68 70 2d 80 00       	push   $0x802d70
  801991:	68 50 2d 80 00       	push   $0x802d50
  801996:	68 a0 00 00 00       	push   $0xa0
  80199b:	68 65 2d 80 00       	push   $0x802d65
  8019a0:	e8 51 0a 00 00       	call   8023f6 <_panic>

008019a5 <devfile_read>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	56                   	push   %esi
  8019a9:	53                   	push   %ebx
  8019aa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019b8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8019c8:	e8 58 fe ff ff       	call   801825 <fsipc>
  8019cd:	89 c3                	mov    %eax,%ebx
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 1f                	js     8019f2 <devfile_read+0x4d>
	assert(r <= n);
  8019d3:	39 f0                	cmp    %esi,%eax
  8019d5:	77 24                	ja     8019fb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019d7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019dc:	7f 33                	jg     801a11 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	50                   	push   %eax
  8019e2:	68 00 50 80 00       	push   $0x805000
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	e8 73 ef ff ff       	call   800962 <memmove>
	return r;
  8019ef:	83 c4 10             	add    $0x10,%esp
}
  8019f2:	89 d8                	mov    %ebx,%eax
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
	assert(r <= n);
  8019fb:	68 7c 2d 80 00       	push   $0x802d7c
  801a00:	68 50 2d 80 00       	push   $0x802d50
  801a05:	6a 7c                	push   $0x7c
  801a07:	68 65 2d 80 00       	push   $0x802d65
  801a0c:	e8 e5 09 00 00       	call   8023f6 <_panic>
	assert(r <= PGSIZE);
  801a11:	68 70 2d 80 00       	push   $0x802d70
  801a16:	68 50 2d 80 00       	push   $0x802d50
  801a1b:	6a 7d                	push   $0x7d
  801a1d:	68 65 2d 80 00       	push   $0x802d65
  801a22:	e8 cf 09 00 00       	call   8023f6 <_panic>

00801a27 <open>:
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 1c             	sub    $0x1c,%esp
  801a2f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a32:	56                   	push   %esi
  801a33:	e8 63 ed ff ff       	call   80079b <strlen>
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a40:	7f 6c                	jg     801aae <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	50                   	push   %eax
  801a49:	e8 6c f8 ff ff       	call   8012ba <fd_alloc>
  801a4e:	89 c3                	mov    %eax,%ebx
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	85 c0                	test   %eax,%eax
  801a55:	78 3c                	js     801a93 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	56                   	push   %esi
  801a5b:	68 00 50 80 00       	push   $0x805000
  801a60:	e8 6f ed ff ff       	call   8007d4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a68:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a70:	b8 01 00 00 00       	mov    $0x1,%eax
  801a75:	e8 ab fd ff ff       	call   801825 <fsipc>
  801a7a:	89 c3                	mov    %eax,%ebx
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 19                	js     801a9c <open+0x75>
	return fd2num(fd);
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	ff 75 f4             	pushl  -0xc(%ebp)
  801a89:	e8 05 f8 ff ff       	call   801293 <fd2num>
  801a8e:	89 c3                	mov    %eax,%ebx
  801a90:	83 c4 10             	add    $0x10,%esp
}
  801a93:	89 d8                	mov    %ebx,%eax
  801a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a98:	5b                   	pop    %ebx
  801a99:	5e                   	pop    %esi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
		fd_close(fd, 0);
  801a9c:	83 ec 08             	sub    $0x8,%esp
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa4:	e8 0e f9 ff ff       	call   8013b7 <fd_close>
		return r;
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	eb e5                	jmp    801a93 <open+0x6c>
		return -E_BAD_PATH;
  801aae:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ab3:	eb de                	jmp    801a93 <open+0x6c>

00801ab5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac5:	e8 5b fd ff ff       	call   801825 <fsipc>
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad4:	83 ec 0c             	sub    $0xc,%esp
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	e8 c4 f7 ff ff       	call   8012a3 <fd2data>
  801adf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ae1:	83 c4 08             	add    $0x8,%esp
  801ae4:	68 83 2d 80 00       	push   $0x802d83
  801ae9:	53                   	push   %ebx
  801aea:	e8 e5 ec ff ff       	call   8007d4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aef:	8b 46 04             	mov    0x4(%esi),%eax
  801af2:	2b 06                	sub    (%esi),%eax
  801af4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801afa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b01:	00 00 00 
	stat->st_dev = &devpipe;
  801b04:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b0b:	30 80 00 
	return 0;
}
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5e                   	pop    %esi
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    

00801b1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 0c             	sub    $0xc,%esp
  801b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b24:	53                   	push   %ebx
  801b25:	6a 00                	push   $0x0
  801b27:	e8 1f f1 ff ff       	call   800c4b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b2c:	89 1c 24             	mov    %ebx,(%esp)
  801b2f:	e8 6f f7 ff ff       	call   8012a3 <fd2data>
  801b34:	83 c4 08             	add    $0x8,%esp
  801b37:	50                   	push   %eax
  801b38:	6a 00                	push   $0x0
  801b3a:	e8 0c f1 ff ff       	call   800c4b <sys_page_unmap>
}
  801b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <_pipeisclosed>:
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 1c             	sub    $0x1c,%esp
  801b4d:	89 c7                	mov    %eax,%edi
  801b4f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b51:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801b56:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	57                   	push   %edi
  801b5d:	e8 77 09 00 00       	call   8024d9 <pageref>
  801b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b65:	89 34 24             	mov    %esi,(%esp)
  801b68:	e8 6c 09 00 00       	call   8024d9 <pageref>
		nn = thisenv->env_runs;
  801b6d:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801b73:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	39 cb                	cmp    %ecx,%ebx
  801b7b:	74 1b                	je     801b98 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b7d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b80:	75 cf                	jne    801b51 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b82:	8b 42 58             	mov    0x58(%edx),%eax
  801b85:	6a 01                	push   $0x1
  801b87:	50                   	push   %eax
  801b88:	53                   	push   %ebx
  801b89:	68 8a 2d 80 00       	push   $0x802d8a
  801b8e:	e8 65 e6 ff ff       	call   8001f8 <cprintf>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	eb b9                	jmp    801b51 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b98:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9b:	0f 94 c0             	sete   %al
  801b9e:	0f b6 c0             	movzbl %al,%eax
}
  801ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5f                   	pop    %edi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <devpipe_write>:
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	57                   	push   %edi
  801bad:	56                   	push   %esi
  801bae:	53                   	push   %ebx
  801baf:	83 ec 28             	sub    $0x28,%esp
  801bb2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bb5:	56                   	push   %esi
  801bb6:	e8 e8 f6 ff ff       	call   8012a3 <fd2data>
  801bbb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bc8:	74 4f                	je     801c19 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bca:	8b 43 04             	mov    0x4(%ebx),%eax
  801bcd:	8b 0b                	mov    (%ebx),%ecx
  801bcf:	8d 51 20             	lea    0x20(%ecx),%edx
  801bd2:	39 d0                	cmp    %edx,%eax
  801bd4:	72 14                	jb     801bea <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bd6:	89 da                	mov    %ebx,%edx
  801bd8:	89 f0                	mov    %esi,%eax
  801bda:	e8 65 ff ff ff       	call   801b44 <_pipeisclosed>
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	75 3b                	jne    801c1e <devpipe_write+0x75>
			sys_yield();
  801be3:	e8 bf ef ff ff       	call   800ba7 <sys_yield>
  801be8:	eb e0                	jmp    801bca <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bed:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bf1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bf4:	89 c2                	mov    %eax,%edx
  801bf6:	c1 fa 1f             	sar    $0x1f,%edx
  801bf9:	89 d1                	mov    %edx,%ecx
  801bfb:	c1 e9 1b             	shr    $0x1b,%ecx
  801bfe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c01:	83 e2 1f             	and    $0x1f,%edx
  801c04:	29 ca                	sub    %ecx,%edx
  801c06:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c0a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c0e:	83 c0 01             	add    $0x1,%eax
  801c11:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c14:	83 c7 01             	add    $0x1,%edi
  801c17:	eb ac                	jmp    801bc5 <devpipe_write+0x1c>
	return i;
  801c19:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1c:	eb 05                	jmp    801c23 <devpipe_write+0x7a>
				return 0;
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <devpipe_read>:
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	57                   	push   %edi
  801c2f:	56                   	push   %esi
  801c30:	53                   	push   %ebx
  801c31:	83 ec 18             	sub    $0x18,%esp
  801c34:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c37:	57                   	push   %edi
  801c38:	e8 66 f6 ff ff       	call   8012a3 <fd2data>
  801c3d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	be 00 00 00 00       	mov    $0x0,%esi
  801c47:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c4a:	75 14                	jne    801c60 <devpipe_read+0x35>
	return i;
  801c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4f:	eb 02                	jmp    801c53 <devpipe_read+0x28>
				return i;
  801c51:	89 f0                	mov    %esi,%eax
}
  801c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5f                   	pop    %edi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    
			sys_yield();
  801c5b:	e8 47 ef ff ff       	call   800ba7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c60:	8b 03                	mov    (%ebx),%eax
  801c62:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c65:	75 18                	jne    801c7f <devpipe_read+0x54>
			if (i > 0)
  801c67:	85 f6                	test   %esi,%esi
  801c69:	75 e6                	jne    801c51 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c6b:	89 da                	mov    %ebx,%edx
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	e8 d0 fe ff ff       	call   801b44 <_pipeisclosed>
  801c74:	85 c0                	test   %eax,%eax
  801c76:	74 e3                	je     801c5b <devpipe_read+0x30>
				return 0;
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7d:	eb d4                	jmp    801c53 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c7f:	99                   	cltd   
  801c80:	c1 ea 1b             	shr    $0x1b,%edx
  801c83:	01 d0                	add    %edx,%eax
  801c85:	83 e0 1f             	and    $0x1f,%eax
  801c88:	29 d0                	sub    %edx,%eax
  801c8a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c92:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c95:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c98:	83 c6 01             	add    $0x1,%esi
  801c9b:	eb aa                	jmp    801c47 <devpipe_read+0x1c>

00801c9d <pipe>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	56                   	push   %esi
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	e8 0c f6 ff ff       	call   8012ba <fd_alloc>
  801cae:	89 c3                	mov    %eax,%ebx
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	0f 88 23 01 00 00    	js     801dde <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 07 04 00 00       	push   $0x407
  801cc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc6:	6a 00                	push   $0x0
  801cc8:	e8 f9 ee ff ff       	call   800bc6 <sys_page_alloc>
  801ccd:	89 c3                	mov    %eax,%ebx
  801ccf:	83 c4 10             	add    $0x10,%esp
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	0f 88 04 01 00 00    	js     801dde <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce0:	50                   	push   %eax
  801ce1:	e8 d4 f5 ff ff       	call   8012ba <fd_alloc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	0f 88 db 00 00 00    	js     801dce <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 07 04 00 00       	push   $0x407
  801cfb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 c1 ee ff ff       	call   800bc6 <sys_page_alloc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	0f 88 bc 00 00 00    	js     801dce <pipe+0x131>
	va = fd2data(fd0);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	ff 75 f4             	pushl  -0xc(%ebp)
  801d18:	e8 86 f5 ff ff       	call   8012a3 <fd2data>
  801d1d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1f:	83 c4 0c             	add    $0xc,%esp
  801d22:	68 07 04 00 00       	push   $0x407
  801d27:	50                   	push   %eax
  801d28:	6a 00                	push   $0x0
  801d2a:	e8 97 ee ff ff       	call   800bc6 <sys_page_alloc>
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	85 c0                	test   %eax,%eax
  801d36:	0f 88 82 00 00 00    	js     801dbe <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801d42:	e8 5c f5 ff ff       	call   8012a3 <fd2data>
  801d47:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d4e:	50                   	push   %eax
  801d4f:	6a 00                	push   $0x0
  801d51:	56                   	push   %esi
  801d52:	6a 00                	push   $0x0
  801d54:	e8 b0 ee ff ff       	call   800c09 <sys_page_map>
  801d59:	89 c3                	mov    %eax,%ebx
  801d5b:	83 c4 20             	add    $0x20,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 4e                	js     801db0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d62:	a1 20 30 80 00       	mov    0x803020,%eax
  801d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d79:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8b:	e8 03 f5 ff ff       	call   801293 <fd2num>
  801d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d93:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d95:	83 c4 04             	add    $0x4,%esp
  801d98:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9b:	e8 f3 f4 ff ff       	call   801293 <fd2num>
  801da0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dae:	eb 2e                	jmp    801dde <pipe+0x141>
	sys_page_unmap(0, va);
  801db0:	83 ec 08             	sub    $0x8,%esp
  801db3:	56                   	push   %esi
  801db4:	6a 00                	push   $0x0
  801db6:	e8 90 ee ff ff       	call   800c4b <sys_page_unmap>
  801dbb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 80 ee ff ff       	call   800c4b <sys_page_unmap>
  801dcb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 70 ee ff ff       	call   800c4b <sys_page_unmap>
  801ddb:	83 c4 10             	add    $0x10,%esp
}
  801dde:	89 d8                	mov    %ebx,%eax
  801de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <pipeisclosed>:
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df0:	50                   	push   %eax
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	e8 13 f5 ff ff       	call   80130c <fd_lookup>
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	78 18                	js     801e18 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f4             	pushl  -0xc(%ebp)
  801e06:	e8 98 f4 ff ff       	call   8012a3 <fd2data>
	return _pipeisclosed(fd, p);
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	e8 2f fd ff ff       	call   801b44 <_pipeisclosed>
  801e15:	83 c4 10             	add    $0x10,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e20:	68 a2 2d 80 00       	push   $0x802da2
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	e8 a7 e9 ff ff       	call   8007d4 <strcpy>
	return 0;
}
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <devsock_close>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	53                   	push   %ebx
  801e38:	83 ec 10             	sub    $0x10,%esp
  801e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e3e:	53                   	push   %ebx
  801e3f:	e8 95 06 00 00       	call   8024d9 <pageref>
  801e44:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e47:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e4c:	83 f8 01             	cmp    $0x1,%eax
  801e4f:	74 07                	je     801e58 <devsock_close+0x24>
}
  801e51:	89 d0                	mov    %edx,%eax
  801e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	ff 73 0c             	pushl  0xc(%ebx)
  801e5e:	e8 b9 02 00 00       	call   80211c <nsipc_close>
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	eb e7                	jmp    801e51 <devsock_close+0x1d>

00801e6a <devsock_write>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 10             	pushl  0x10(%ebp)
  801e75:	ff 75 0c             	pushl  0xc(%ebp)
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	ff 70 0c             	pushl  0xc(%eax)
  801e7e:	e8 76 03 00 00       	call   8021f9 <nsipc_send>
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <devsock_read>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	ff 70 0c             	pushl  0xc(%eax)
  801e99:	e8 ef 02 00 00       	call   80218d <nsipc_recv>
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <fd2sockid>:
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ea6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	e8 5c f4 ff ff       	call   80130c <fd_lookup>
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 10                	js     801ec7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ec0:	39 08                	cmp    %ecx,(%eax)
  801ec2:	75 05                	jne    801ec9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ec4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ec9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ece:	eb f7                	jmp    801ec7 <fd2sockid+0x27>

00801ed0 <alloc_sockfd>:
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 1c             	sub    $0x1c,%esp
  801ed8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801eda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801edd:	50                   	push   %eax
  801ede:	e8 d7 f3 ff ff       	call   8012ba <fd_alloc>
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 43                	js     801f2f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 07 04 00 00       	push   $0x407
  801ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 c8 ec ff ff       	call   800bc6 <sys_page_alloc>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 28                	js     801f2f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f10:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f1c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	50                   	push   %eax
  801f23:	e8 6b f3 ff ff       	call   801293 <fd2num>
  801f28:	89 c3                	mov    %eax,%ebx
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	eb 0c                	jmp    801f3b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	56                   	push   %esi
  801f33:	e8 e4 01 00 00       	call   80211c <nsipc_close>
		return r;
  801f38:	83 c4 10             	add    $0x10,%esp
}
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <accept>:
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	e8 4e ff ff ff       	call   801ea0 <fd2sockid>
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 1b                	js     801f71 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	ff 75 10             	pushl  0x10(%ebp)
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	50                   	push   %eax
  801f60:	e8 0e 01 00 00       	call   802073 <nsipc_accept>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 05                	js     801f71 <accept+0x2d>
	return alloc_sockfd(r);
  801f6c:	e8 5f ff ff ff       	call   801ed0 <alloc_sockfd>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <bind>:
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	e8 1f ff ff ff       	call   801ea0 <fd2sockid>
  801f81:	85 c0                	test   %eax,%eax
  801f83:	78 12                	js     801f97 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	ff 75 10             	pushl  0x10(%ebp)
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	50                   	push   %eax
  801f8f:	e8 31 01 00 00       	call   8020c5 <nsipc_bind>
  801f94:	83 c4 10             	add    $0x10,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <shutdown>:
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	e8 f9 fe ff ff       	call   801ea0 <fd2sockid>
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 0f                	js     801fba <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	ff 75 0c             	pushl  0xc(%ebp)
  801fb1:	50                   	push   %eax
  801fb2:	e8 43 01 00 00       	call   8020fa <nsipc_shutdown>
  801fb7:	83 c4 10             	add    $0x10,%esp
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <connect>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	e8 d6 fe ff ff       	call   801ea0 <fd2sockid>
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 12                	js     801fe0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	ff 75 10             	pushl  0x10(%ebp)
  801fd4:	ff 75 0c             	pushl  0xc(%ebp)
  801fd7:	50                   	push   %eax
  801fd8:	e8 59 01 00 00       	call   802136 <nsipc_connect>
  801fdd:	83 c4 10             	add    $0x10,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <listen>:
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	e8 b0 fe ff ff       	call   801ea0 <fd2sockid>
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 0f                	js     802003 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ff4:	83 ec 08             	sub    $0x8,%esp
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	50                   	push   %eax
  801ffb:	e8 6b 01 00 00       	call   80216b <nsipc_listen>
  802000:	83 c4 10             	add    $0x10,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <socket>:

int
socket(int domain, int type, int protocol)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80200b:	ff 75 10             	pushl  0x10(%ebp)
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	e8 3e 02 00 00       	call   802257 <nsipc_socket>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 05                	js     802025 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802020:	e8 ab fe ff ff       	call   801ed0 <alloc_sockfd>
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	53                   	push   %ebx
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802030:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802037:	74 26                	je     80205f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802039:	6a 07                	push   $0x7
  80203b:	68 00 60 80 00       	push   $0x806000
  802040:	53                   	push   %ebx
  802041:	ff 35 04 40 80 00    	pushl  0x804004
  802047:	e8 a2 f1 ff ff       	call   8011ee <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80204c:	83 c4 0c             	add    $0xc,%esp
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	e8 21 f1 ff ff       	call   80117b <ipc_recv>
}
  80205a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	6a 02                	push   $0x2
  802064:	e8 f1 f1 ff ff       	call   80125a <ipc_find_env>
  802069:	a3 04 40 80 00       	mov    %eax,0x804004
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	eb c6                	jmp    802039 <nsipc+0x12>

00802073 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802083:	8b 06                	mov    (%esi),%eax
  802085:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	e8 93 ff ff ff       	call   802027 <nsipc>
  802094:	89 c3                	mov    %eax,%ebx
  802096:	85 c0                	test   %eax,%eax
  802098:	79 09                	jns    8020a3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80209a:	89 d8                	mov    %ebx,%eax
  80209c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5e                   	pop    %esi
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	ff 35 10 60 80 00    	pushl  0x806010
  8020ac:	68 00 60 80 00       	push   $0x806000
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	e8 a9 e8 ff ff       	call   800962 <memmove>
		*addrlen = ret->ret_addrlen;
  8020b9:	a1 10 60 80 00       	mov    0x806010,%eax
  8020be:	89 06                	mov    %eax,(%esi)
  8020c0:	83 c4 10             	add    $0x10,%esp
	return r;
  8020c3:	eb d5                	jmp    80209a <nsipc_accept+0x27>

008020c5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 08             	sub    $0x8,%esp
  8020cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020d7:	53                   	push   %ebx
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	68 04 60 80 00       	push   $0x806004
  8020e0:	e8 7d e8 ff ff       	call   800962 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020e5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8020eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8020f0:	e8 32 ff ff ff       	call   802027 <nsipc>
}
  8020f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802110:	b8 03 00 00 00       	mov    $0x3,%eax
  802115:	e8 0d ff ff ff       	call   802027 <nsipc>
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <nsipc_close>:

int
nsipc_close(int s)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80212a:	b8 04 00 00 00       	mov    $0x4,%eax
  80212f:	e8 f3 fe ff ff       	call   802027 <nsipc>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	53                   	push   %ebx
  80213a:	83 ec 08             	sub    $0x8,%esp
  80213d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802148:	53                   	push   %ebx
  802149:	ff 75 0c             	pushl  0xc(%ebp)
  80214c:	68 04 60 80 00       	push   $0x806004
  802151:	e8 0c e8 ff ff       	call   800962 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802156:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80215c:	b8 05 00 00 00       	mov    $0x5,%eax
  802161:	e8 c1 fe ff ff       	call   802027 <nsipc>
}
  802166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802181:	b8 06 00 00 00       	mov    $0x6,%eax
  802186:	e8 9c fe ff ff       	call   802027 <nsipc>
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80219d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8021a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ab:	b8 07 00 00 00       	mov    $0x7,%eax
  8021b0:	e8 72 fe ff ff       	call   802027 <nsipc>
  8021b5:	89 c3                	mov    %eax,%ebx
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	78 1f                	js     8021da <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021bb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021c0:	7f 21                	jg     8021e3 <nsipc_recv+0x56>
  8021c2:	39 c6                	cmp    %eax,%esi
  8021c4:	7c 1d                	jl     8021e3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	50                   	push   %eax
  8021ca:	68 00 60 80 00       	push   $0x806000
  8021cf:	ff 75 0c             	pushl  0xc(%ebp)
  8021d2:	e8 8b e7 ff ff       	call   800962 <memmove>
  8021d7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021da:	89 d8                	mov    %ebx,%eax
  8021dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5e                   	pop    %esi
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021e3:	68 ae 2d 80 00       	push   $0x802dae
  8021e8:	68 50 2d 80 00       	push   $0x802d50
  8021ed:	6a 62                	push   $0x62
  8021ef:	68 c3 2d 80 00       	push   $0x802dc3
  8021f4:	e8 fd 01 00 00       	call   8023f6 <_panic>

008021f9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80220b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802211:	7f 2e                	jg     802241 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802213:	83 ec 04             	sub    $0x4,%esp
  802216:	53                   	push   %ebx
  802217:	ff 75 0c             	pushl  0xc(%ebp)
  80221a:	68 0c 60 80 00       	push   $0x80600c
  80221f:	e8 3e e7 ff ff       	call   800962 <memmove>
	nsipcbuf.send.req_size = size;
  802224:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80222a:	8b 45 14             	mov    0x14(%ebp),%eax
  80222d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802232:	b8 08 00 00 00       	mov    $0x8,%eax
  802237:	e8 eb fd ff ff       	call   802027 <nsipc>
}
  80223c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223f:	c9                   	leave  
  802240:	c3                   	ret    
	assert(size < 1600);
  802241:	68 cf 2d 80 00       	push   $0x802dcf
  802246:	68 50 2d 80 00       	push   $0x802d50
  80224b:	6a 6d                	push   $0x6d
  80224d:	68 c3 2d 80 00       	push   $0x802dc3
  802252:	e8 9f 01 00 00       	call   8023f6 <_panic>

00802257 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802265:	8b 45 0c             	mov    0xc(%ebp),%eax
  802268:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80226d:	8b 45 10             	mov    0x10(%ebp),%eax
  802270:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802275:	b8 09 00 00 00       	mov    $0x9,%eax
  80227a:	e8 a8 fd ff ff       	call   802027 <nsipc>
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
  802286:	c3                   	ret    

00802287 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80228d:	68 db 2d 80 00       	push   $0x802ddb
  802292:	ff 75 0c             	pushl  0xc(%ebp)
  802295:	e8 3a e5 ff ff       	call   8007d4 <strcpy>
	return 0;
}
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <devcons_write>:
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	57                   	push   %edi
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
  8022a7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022ad:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022b2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022bb:	73 31                	jae    8022ee <devcons_write+0x4d>
		m = n - tot;
  8022bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022c0:	29 f3                	sub    %esi,%ebx
  8022c2:	83 fb 7f             	cmp    $0x7f,%ebx
  8022c5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022ca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	53                   	push   %ebx
  8022d1:	89 f0                	mov    %esi,%eax
  8022d3:	03 45 0c             	add    0xc(%ebp),%eax
  8022d6:	50                   	push   %eax
  8022d7:	57                   	push   %edi
  8022d8:	e8 85 e6 ff ff       	call   800962 <memmove>
		sys_cputs(buf, m);
  8022dd:	83 c4 08             	add    $0x8,%esp
  8022e0:	53                   	push   %ebx
  8022e1:	57                   	push   %edi
  8022e2:	e8 23 e8 ff ff       	call   800b0a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022e7:	01 de                	add    %ebx,%esi
  8022e9:	83 c4 10             	add    $0x10,%esp
  8022ec:	eb ca                	jmp    8022b8 <devcons_write+0x17>
}
  8022ee:	89 f0                	mov    %esi,%eax
  8022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5f                   	pop    %edi
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    

008022f8 <devcons_read>:
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802303:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802307:	74 21                	je     80232a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802309:	e8 1a e8 ff ff       	call   800b28 <sys_cgetc>
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 07                	jne    802319 <devcons_read+0x21>
		sys_yield();
  802312:	e8 90 e8 ff ff       	call   800ba7 <sys_yield>
  802317:	eb f0                	jmp    802309 <devcons_read+0x11>
	if (c < 0)
  802319:	78 0f                	js     80232a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80231b:	83 f8 04             	cmp    $0x4,%eax
  80231e:	74 0c                	je     80232c <devcons_read+0x34>
	*(char*)vbuf = c;
  802320:	8b 55 0c             	mov    0xc(%ebp),%edx
  802323:	88 02                	mov    %al,(%edx)
	return 1;
  802325:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    
		return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
  802331:	eb f7                	jmp    80232a <devcons_read+0x32>

00802333 <cputchar>:
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80233f:	6a 01                	push   $0x1
  802341:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802344:	50                   	push   %eax
  802345:	e8 c0 e7 ff ff       	call   800b0a <sys_cputs>
}
  80234a:	83 c4 10             	add    $0x10,%esp
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <getchar>:
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802355:	6a 01                	push   $0x1
  802357:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80235a:	50                   	push   %eax
  80235b:	6a 00                	push   $0x0
  80235d:	e8 1a f2 ff ff       	call   80157c <read>
	if (r < 0)
  802362:	83 c4 10             	add    $0x10,%esp
  802365:	85 c0                	test   %eax,%eax
  802367:	78 06                	js     80236f <getchar+0x20>
	if (r < 1)
  802369:	74 06                	je     802371 <getchar+0x22>
	return c;
  80236b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    
		return -E_EOF;
  802371:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802376:	eb f7                	jmp    80236f <getchar+0x20>

00802378 <iscons>:
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802381:	50                   	push   %eax
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	e8 82 ef ff ff       	call   80130c <fd_lookup>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	85 c0                	test   %eax,%eax
  80238f:	78 11                	js     8023a2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80239a:	39 10                	cmp    %edx,(%eax)
  80239c:	0f 94 c0             	sete   %al
  80239f:	0f b6 c0             	movzbl %al,%eax
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <opencons>:
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ad:	50                   	push   %eax
  8023ae:	e8 07 ef ff ff       	call   8012ba <fd_alloc>
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	78 3a                	js     8023f4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 07 04 00 00       	push   $0x407
  8023c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c5:	6a 00                	push   $0x0
  8023c7:	e8 fa e7 ff ff       	call   800bc6 <sys_page_alloc>
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	78 21                	js     8023f4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023e8:	83 ec 0c             	sub    $0xc,%esp
  8023eb:	50                   	push   %eax
  8023ec:	e8 a2 ee ff ff       	call   801293 <fd2num>
  8023f1:	83 c4 10             	add    $0x10,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	56                   	push   %esi
  8023fa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023fe:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802404:	e8 7f e7 ff ff       	call   800b88 <sys_getenvid>
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	ff 75 0c             	pushl  0xc(%ebp)
  80240f:	ff 75 08             	pushl  0x8(%ebp)
  802412:	56                   	push   %esi
  802413:	50                   	push   %eax
  802414:	68 e8 2d 80 00       	push   $0x802de8
  802419:	e8 da dd ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80241e:	83 c4 18             	add    $0x18,%esp
  802421:	53                   	push   %ebx
  802422:	ff 75 10             	pushl  0x10(%ebp)
  802425:	e8 7d dd ff ff       	call   8001a7 <vcprintf>
	cprintf("\n");
  80242a:	c7 04 24 9b 2d 80 00 	movl   $0x802d9b,(%esp)
  802431:	e8 c2 dd ff ff       	call   8001f8 <cprintf>
  802436:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802439:	cc                   	int3   
  80243a:	eb fd                	jmp    802439 <_panic+0x43>

0080243c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802442:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802449:	74 0a                	je     802455 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802455:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80245a:	8b 40 48             	mov    0x48(%eax),%eax
  80245d:	83 ec 04             	sub    $0x4,%esp
  802460:	6a 07                	push   $0x7
  802462:	68 00 f0 bf ee       	push   $0xeebff000
  802467:	50                   	push   %eax
  802468:	e8 59 e7 ff ff       	call   800bc6 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	85 c0                	test   %eax,%eax
  802472:	78 2c                	js     8024a0 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802474:	e8 0f e7 ff ff       	call   800b88 <sys_getenvid>
  802479:	83 ec 08             	sub    $0x8,%esp
  80247c:	68 b2 24 80 00       	push   $0x8024b2
  802481:	50                   	push   %eax
  802482:	e8 8a e8 ff ff       	call   800d11 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802487:	83 c4 10             	add    $0x10,%esp
  80248a:	85 c0                	test   %eax,%eax
  80248c:	79 bd                	jns    80244b <set_pgfault_handler+0xf>
  80248e:	50                   	push   %eax
  80248f:	68 0c 2e 80 00       	push   $0x802e0c
  802494:	6a 23                	push   $0x23
  802496:	68 24 2e 80 00       	push   $0x802e24
  80249b:	e8 56 ff ff ff       	call   8023f6 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8024a0:	50                   	push   %eax
  8024a1:	68 0c 2e 80 00       	push   $0x802e0c
  8024a6:	6a 21                	push   $0x21
  8024a8:	68 24 2e 80 00       	push   $0x802e24
  8024ad:	e8 44 ff ff ff       	call   8023f6 <_panic>

008024b2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024b2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024b3:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024b8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024ba:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8024bd:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8024c1:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8024c4:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8024c8:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8024cc:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8024cf:	83 c4 08             	add    $0x8,%esp
	popal
  8024d2:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024d3:	83 c4 04             	add    $0x4,%esp
	popfl
  8024d6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024d7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8024d8:	c3                   	ret    

008024d9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024df:	89 d0                	mov    %edx,%eax
  8024e1:	c1 e8 16             	shr    $0x16,%eax
  8024e4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024f0:	f6 c1 01             	test   $0x1,%cl
  8024f3:	74 1d                	je     802512 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024f5:	c1 ea 0c             	shr    $0xc,%edx
  8024f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ff:	f6 c2 01             	test   $0x1,%dl
  802502:	74 0e                	je     802512 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802504:	c1 ea 0c             	shr    $0xc,%edx
  802507:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80250e:	ef 
  80250f:	0f b7 c0             	movzwl %ax,%eax
}
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	66 90                	xchg   %ax,%ax
  802516:	66 90                	xchg   %ax,%ax
  802518:	66 90                	xchg   %ax,%ax
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__udivdi3>:
  802520:	f3 0f 1e fb          	endbr32 
  802524:	55                   	push   %ebp
  802525:	57                   	push   %edi
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
  80252b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80252f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802533:	8b 74 24 34          	mov    0x34(%esp),%esi
  802537:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80253b:	85 d2                	test   %edx,%edx
  80253d:	75 49                	jne    802588 <__udivdi3+0x68>
  80253f:	39 f3                	cmp    %esi,%ebx
  802541:	76 15                	jbe    802558 <__udivdi3+0x38>
  802543:	31 ff                	xor    %edi,%edi
  802545:	89 e8                	mov    %ebp,%eax
  802547:	89 f2                	mov    %esi,%edx
  802549:	f7 f3                	div    %ebx
  80254b:	89 fa                	mov    %edi,%edx
  80254d:	83 c4 1c             	add    $0x1c,%esp
  802550:	5b                   	pop    %ebx
  802551:	5e                   	pop    %esi
  802552:	5f                   	pop    %edi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    
  802555:	8d 76 00             	lea    0x0(%esi),%esi
  802558:	89 d9                	mov    %ebx,%ecx
  80255a:	85 db                	test   %ebx,%ebx
  80255c:	75 0b                	jne    802569 <__udivdi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f3                	div    %ebx
  802567:	89 c1                	mov    %eax,%ecx
  802569:	31 d2                	xor    %edx,%edx
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	f7 f1                	div    %ecx
  80256f:	89 c6                	mov    %eax,%esi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f7                	mov    %esi,%edi
  802575:	f7 f1                	div    %ecx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	39 f2                	cmp    %esi,%edx
  80258a:	77 1c                	ja     8025a8 <__udivdi3+0x88>
  80258c:	0f bd fa             	bsr    %edx,%edi
  80258f:	83 f7 1f             	xor    $0x1f,%edi
  802592:	75 2c                	jne    8025c0 <__udivdi3+0xa0>
  802594:	39 f2                	cmp    %esi,%edx
  802596:	72 06                	jb     80259e <__udivdi3+0x7e>
  802598:	31 c0                	xor    %eax,%eax
  80259a:	39 eb                	cmp    %ebp,%ebx
  80259c:	77 ad                	ja     80254b <__udivdi3+0x2b>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	eb a6                	jmp    80254b <__udivdi3+0x2b>
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	31 ff                	xor    %edi,%edi
  8025aa:	31 c0                	xor    %eax,%eax
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	89 f9                	mov    %edi,%ecx
  8025c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025c7:	29 f8                	sub    %edi,%eax
  8025c9:	d3 e2                	shl    %cl,%edx
  8025cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025cf:	89 c1                	mov    %eax,%ecx
  8025d1:	89 da                	mov    %ebx,%edx
  8025d3:	d3 ea                	shr    %cl,%edx
  8025d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d9:	09 d1                	or     %edx,%ecx
  8025db:	89 f2                	mov    %esi,%edx
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 f9                	mov    %edi,%ecx
  8025e3:	d3 e3                	shl    %cl,%ebx
  8025e5:	89 c1                	mov    %eax,%ecx
  8025e7:	d3 ea                	shr    %cl,%edx
  8025e9:	89 f9                	mov    %edi,%ecx
  8025eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025ef:	89 eb                	mov    %ebp,%ebx
  8025f1:	d3 e6                	shl    %cl,%esi
  8025f3:	89 c1                	mov    %eax,%ecx
  8025f5:	d3 eb                	shr    %cl,%ebx
  8025f7:	09 de                	or     %ebx,%esi
  8025f9:	89 f0                	mov    %esi,%eax
  8025fb:	f7 74 24 08          	divl   0x8(%esp)
  8025ff:	89 d6                	mov    %edx,%esi
  802601:	89 c3                	mov    %eax,%ebx
  802603:	f7 64 24 0c          	mull   0xc(%esp)
  802607:	39 d6                	cmp    %edx,%esi
  802609:	72 15                	jb     802620 <__udivdi3+0x100>
  80260b:	89 f9                	mov    %edi,%ecx
  80260d:	d3 e5                	shl    %cl,%ebp
  80260f:	39 c5                	cmp    %eax,%ebp
  802611:	73 04                	jae    802617 <__udivdi3+0xf7>
  802613:	39 d6                	cmp    %edx,%esi
  802615:	74 09                	je     802620 <__udivdi3+0x100>
  802617:	89 d8                	mov    %ebx,%eax
  802619:	31 ff                	xor    %edi,%edi
  80261b:	e9 2b ff ff ff       	jmp    80254b <__udivdi3+0x2b>
  802620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802623:	31 ff                	xor    %edi,%edi
  802625:	e9 21 ff ff ff       	jmp    80254b <__udivdi3+0x2b>
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	f3 0f 1e fb          	endbr32 
  802634:	55                   	push   %ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	83 ec 1c             	sub    $0x1c,%esp
  80263b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80263f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802643:	8b 74 24 30          	mov    0x30(%esp),%esi
  802647:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80264b:	89 da                	mov    %ebx,%edx
  80264d:	85 c0                	test   %eax,%eax
  80264f:	75 3f                	jne    802690 <__umoddi3+0x60>
  802651:	39 df                	cmp    %ebx,%edi
  802653:	76 13                	jbe    802668 <__umoddi3+0x38>
  802655:	89 f0                	mov    %esi,%eax
  802657:	f7 f7                	div    %edi
  802659:	89 d0                	mov    %edx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	83 c4 1c             	add    $0x1c,%esp
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	89 fd                	mov    %edi,%ebp
  80266a:	85 ff                	test   %edi,%edi
  80266c:	75 0b                	jne    802679 <__umoddi3+0x49>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f7                	div    %edi
  802677:	89 c5                	mov    %eax,%ebp
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f5                	div    %ebp
  80267f:	89 f0                	mov    %esi,%eax
  802681:	f7 f5                	div    %ebp
  802683:	89 d0                	mov    %edx,%eax
  802685:	eb d4                	jmp    80265b <__umoddi3+0x2b>
  802687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80268e:	66 90                	xchg   %ax,%ax
  802690:	89 f1                	mov    %esi,%ecx
  802692:	39 d8                	cmp    %ebx,%eax
  802694:	76 0a                	jbe    8026a0 <__umoddi3+0x70>
  802696:	89 f0                	mov    %esi,%eax
  802698:	83 c4 1c             	add    $0x1c,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    
  8026a0:	0f bd e8             	bsr    %eax,%ebp
  8026a3:	83 f5 1f             	xor    $0x1f,%ebp
  8026a6:	75 20                	jne    8026c8 <__umoddi3+0x98>
  8026a8:	39 d8                	cmp    %ebx,%eax
  8026aa:	0f 82 b0 00 00 00    	jb     802760 <__umoddi3+0x130>
  8026b0:	39 f7                	cmp    %esi,%edi
  8026b2:	0f 86 a8 00 00 00    	jbe    802760 <__umoddi3+0x130>
  8026b8:	89 c8                	mov    %ecx,%eax
  8026ba:	83 c4 1c             	add    $0x1c,%esp
  8026bd:	5b                   	pop    %ebx
  8026be:	5e                   	pop    %esi
  8026bf:	5f                   	pop    %edi
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    
  8026c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c8:	89 e9                	mov    %ebp,%ecx
  8026ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8026cf:	29 ea                	sub    %ebp,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d7:	89 d1                	mov    %edx,%ecx
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	d3 e8                	shr    %cl,%eax
  8026dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026e9:	09 c1                	or     %eax,%ecx
  8026eb:	89 d8                	mov    %ebx,%eax
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	d3 e8                	shr    %cl,%eax
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	d3 e3                	shl    %cl,%ebx
  802701:	89 c7                	mov    %eax,%edi
  802703:	89 d1                	mov    %edx,%ecx
  802705:	89 f0                	mov    %esi,%eax
  802707:	d3 e8                	shr    %cl,%eax
  802709:	89 e9                	mov    %ebp,%ecx
  80270b:	89 fa                	mov    %edi,%edx
  80270d:	d3 e6                	shl    %cl,%esi
  80270f:	09 d8                	or     %ebx,%eax
  802711:	f7 74 24 08          	divl   0x8(%esp)
  802715:	89 d1                	mov    %edx,%ecx
  802717:	89 f3                	mov    %esi,%ebx
  802719:	f7 64 24 0c          	mull   0xc(%esp)
  80271d:	89 c6                	mov    %eax,%esi
  80271f:	89 d7                	mov    %edx,%edi
  802721:	39 d1                	cmp    %edx,%ecx
  802723:	72 06                	jb     80272b <__umoddi3+0xfb>
  802725:	75 10                	jne    802737 <__umoddi3+0x107>
  802727:	39 c3                	cmp    %eax,%ebx
  802729:	73 0c                	jae    802737 <__umoddi3+0x107>
  80272b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80272f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802733:	89 d7                	mov    %edx,%edi
  802735:	89 c6                	mov    %eax,%esi
  802737:	89 ca                	mov    %ecx,%edx
  802739:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80273e:	29 f3                	sub    %esi,%ebx
  802740:	19 fa                	sbb    %edi,%edx
  802742:	89 d0                	mov    %edx,%eax
  802744:	d3 e0                	shl    %cl,%eax
  802746:	89 e9                	mov    %ebp,%ecx
  802748:	d3 eb                	shr    %cl,%ebx
  80274a:	d3 ea                	shr    %cl,%edx
  80274c:	09 d8                	or     %ebx,%eax
  80274e:	83 c4 1c             	add    $0x1c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	89 da                	mov    %ebx,%edx
  802762:	29 fe                	sub    %edi,%esi
  802764:	19 c2                	sbb    %eax,%edx
  802766:	89 f1                	mov    %esi,%ecx
  802768:	89 c8                	mov    %ecx,%eax
  80276a:	e9 4b ff ff ff       	jmp    8026ba <__umoddi3+0x8a>
