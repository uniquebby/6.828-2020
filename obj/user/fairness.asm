
obj/user/fairness.debug：     文件格式 elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 e6 0a 00 00       	call   800b26 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 d1 22 80 00       	push   $0x8022d1
  80005d:	e8 34 01 00 00       	call   800196 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 71 0d 00 00       	call   800de7 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 e9 0c 00 00       	call   800d74 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 c0 22 80 00       	push   $0x8022c0
  800097:	e8 fa 00 00 00       	call   800196 <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 75 0a 00 00       	call   800b26 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ed:	e8 72 0f 00 00       	call   801064 <close_all>
	sys_env_destroy(0);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	e8 e9 09 00 00       	call   800ae5 <sys_env_destroy>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	53                   	push   %ebx
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010b:	8b 13                	mov    (%ebx),%edx
  80010d:	8d 42 01             	lea    0x1(%edx),%eax
  800110:	89 03                	mov    %eax,(%ebx)
  800112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800115:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800119:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011e:	74 09                	je     800129 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800120:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800127:	c9                   	leave  
  800128:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	68 ff 00 00 00       	push   $0xff
  800131:	8d 43 08             	lea    0x8(%ebx),%eax
  800134:	50                   	push   %eax
  800135:	e8 6e 09 00 00       	call   800aa8 <sys_cputs>
		b->idx = 0;
  80013a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	eb db                	jmp    800120 <putch+0x1f>

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016e:	50                   	push   %eax
  80016f:	68 01 01 80 00       	push   $0x800101
  800174:	e8 19 01 00 00       	call   800292 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800182:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 1a 09 00 00       	call   800aa8 <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	50                   	push   %eax
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	e8 9d ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 1c             	sub    $0x1c,%esp
  8001b3:	89 c7                	mov    %eax,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001d4:	89 d0                	mov    %edx,%eax
  8001d6:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001dc:	73 15                	jae    8001f3 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001de:	83 eb 01             	sub    $0x1,%ebx
  8001e1:	85 db                	test   %ebx,%ebx
  8001e3:	7e 43                	jle    800228 <printnum+0x7e>
			putch(padc, putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	56                   	push   %esi
  8001e9:	ff 75 18             	pushl  0x18(%ebp)
  8001ec:	ff d7                	call   *%edi
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	eb eb                	jmp    8001de <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ff:	53                   	push   %ebx
  800200:	ff 75 10             	pushl  0x10(%ebp)
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	ff 75 e4             	pushl  -0x1c(%ebp)
  800209:	ff 75 e0             	pushl  -0x20(%ebp)
  80020c:	ff 75 dc             	pushl  -0x24(%ebp)
  80020f:	ff 75 d8             	pushl  -0x28(%ebp)
  800212:	e8 59 1e 00 00       	call   802070 <__udivdi3>
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	52                   	push   %edx
  80021b:	50                   	push   %eax
  80021c:	89 f2                	mov    %esi,%edx
  80021e:	89 f8                	mov    %edi,%eax
  800220:	e8 85 ff ff ff       	call   8001aa <printnum>
  800225:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	83 ec 04             	sub    $0x4,%esp
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	ff 75 dc             	pushl  -0x24(%ebp)
  800238:	ff 75 d8             	pushl  -0x28(%ebp)
  80023b:	e8 40 1f 00 00       	call   802180 <__umoddi3>
  800240:	83 c4 14             	add    $0x14,%esp
  800243:	0f be 80 f2 22 80 00 	movsbl 0x8022f2(%eax),%eax
  80024a:	50                   	push   %eax
  80024b:	ff d7                	call   *%edi
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800253:	5b                   	pop    %ebx
  800254:	5e                   	pop    %esi
  800255:	5f                   	pop    %edi
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    

00800258 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800262:	8b 10                	mov    (%eax),%edx
  800264:	3b 50 04             	cmp    0x4(%eax),%edx
  800267:	73 0a                	jae    800273 <sprintputch+0x1b>
		*b->buf++ = ch;
  800269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026c:	89 08                	mov    %ecx,(%eax)
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	88 02                	mov    %al,(%edx)
}
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    

00800275 <printfmt>:
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027e:	50                   	push   %eax
  80027f:	ff 75 10             	pushl  0x10(%ebp)
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	e8 05 00 00 00       	call   800292 <vprintfmt>
}
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <vprintfmt>:
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	57                   	push   %edi
  800296:	56                   	push   %esi
  800297:	53                   	push   %ebx
  800298:	83 ec 3c             	sub    $0x3c,%esp
  80029b:	8b 75 08             	mov    0x8(%ebp),%esi
  80029e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a4:	eb 0a                	jmp    8002b0 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	53                   	push   %ebx
  8002aa:	50                   	push   %eax
  8002ab:	ff d6                	call   *%esi
  8002ad:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002b0:	83 c7 01             	add    $0x1,%edi
  8002b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002b7:	83 f8 25             	cmp    $0x25,%eax
  8002ba:	74 0c                	je     8002c8 <vprintfmt+0x36>
			if (ch == '\0')
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	75 e6                	jne    8002a6 <vprintfmt+0x14>
}
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    
		padc = ' ';
  8002c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e6:	8d 47 01             	lea    0x1(%edi),%eax
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	0f b6 17             	movzbl (%edi),%edx
  8002ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f2:	3c 55                	cmp    $0x55,%al
  8002f4:	0f 87 ba 03 00 00    	ja     8006b4 <vprintfmt+0x422>
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  800304:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800307:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80030b:	eb d9                	jmp    8002e6 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800310:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800314:	eb d0                	jmp    8002e6 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800316:	0f b6 d2             	movzbl %dl,%edx
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800324:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800327:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800331:	83 f9 09             	cmp    $0x9,%ecx
  800334:	77 55                	ja     80038b <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800336:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800339:	eb e9                	jmp    800324 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80033b:	8b 45 14             	mov    0x14(%ebp),%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800343:	8b 45 14             	mov    0x14(%ebp),%eax
  800346:	8d 40 04             	lea    0x4(%eax),%eax
  800349:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80034f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800353:	79 91                	jns    8002e6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800355:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800362:	eb 82                	jmp    8002e6 <vprintfmt+0x54>
  800364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800367:	85 c0                	test   %eax,%eax
  800369:	ba 00 00 00 00       	mov    $0x0,%edx
  80036e:	0f 49 d0             	cmovns %eax,%edx
  800371:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800377:	e9 6a ff ff ff       	jmp    8002e6 <vprintfmt+0x54>
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80037f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800386:	e9 5b ff ff ff       	jmp    8002e6 <vprintfmt+0x54>
  80038b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800391:	eb bc                	jmp    80034f <vprintfmt+0xbd>
			lflag++;
  800393:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800399:	e9 48 ff ff ff       	jmp    8002e6 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 78 04             	lea    0x4(%eax),%edi
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	53                   	push   %ebx
  8003a8:	ff 30                	pushl  (%eax)
  8003aa:	ff d6                	call   *%esi
			break;
  8003ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b2:	e9 9c 02 00 00       	jmp    800653 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8d 78 04             	lea    0x4(%eax),%edi
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	99                   	cltd   
  8003c0:	31 d0                	xor    %edx,%eax
  8003c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c4:	83 f8 0f             	cmp    $0xf,%eax
  8003c7:	7f 23                	jg     8003ec <vprintfmt+0x15a>
  8003c9:	8b 14 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%edx
  8003d0:	85 d2                	test   %edx,%edx
  8003d2:	74 18                	je     8003ec <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003d4:	52                   	push   %edx
  8003d5:	68 16 27 80 00       	push   $0x802716
  8003da:	53                   	push   %ebx
  8003db:	56                   	push   %esi
  8003dc:	e8 94 fe ff ff       	call   800275 <printfmt>
  8003e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e7:	e9 67 02 00 00       	jmp    800653 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003ec:	50                   	push   %eax
  8003ed:	68 0a 23 80 00       	push   $0x80230a
  8003f2:	53                   	push   %ebx
  8003f3:	56                   	push   %esi
  8003f4:	e8 7c fe ff ff       	call   800275 <printfmt>
  8003f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ff:	e9 4f 02 00 00       	jmp    800653 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	83 c0 04             	add    $0x4,%eax
  80040a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800412:	85 d2                	test   %edx,%edx
  800414:	b8 03 23 80 00       	mov    $0x802303,%eax
  800419:	0f 45 c2             	cmovne %edx,%eax
  80041c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80041f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800423:	7e 06                	jle    80042b <vprintfmt+0x199>
  800425:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800429:	75 0d                	jne    800438 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80042e:	89 c7                	mov    %eax,%edi
  800430:	03 45 e0             	add    -0x20(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	eb 3f                	jmp    800477 <vprintfmt+0x1e5>
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 d8             	pushl  -0x28(%ebp)
  80043e:	50                   	push   %eax
  80043f:	e8 0d 03 00 00       	call   800751 <strnlen>
  800444:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800447:	29 c2                	sub    %eax,%edx
  800449:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80044c:	83 c4 10             	add    $0x10,%esp
  80044f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800451:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800455:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800458:	85 ff                	test   %edi,%edi
  80045a:	7e 58                	jle    8004b4 <vprintfmt+0x222>
					putch(padc, putdat);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	53                   	push   %ebx
  800460:	ff 75 e0             	pushl  -0x20(%ebp)
  800463:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800465:	83 ef 01             	sub    $0x1,%edi
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb eb                	jmp    800458 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	53                   	push   %ebx
  800471:	52                   	push   %edx
  800472:	ff d6                	call   *%esi
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047c:	83 c7 01             	add    $0x1,%edi
  80047f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800483:	0f be d0             	movsbl %al,%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 45                	je     8004cf <vprintfmt+0x23d>
  80048a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048e:	78 06                	js     800496 <vprintfmt+0x204>
  800490:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800494:	78 35                	js     8004cb <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800496:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80049a:	74 d1                	je     80046d <vprintfmt+0x1db>
  80049c:	0f be c0             	movsbl %al,%eax
  80049f:	83 e8 20             	sub    $0x20,%eax
  8004a2:	83 f8 5e             	cmp    $0x5e,%eax
  8004a5:	76 c6                	jbe    80046d <vprintfmt+0x1db>
					putch('?', putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	6a 3f                	push   $0x3f
  8004ad:	ff d6                	call   *%esi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	eb c3                	jmp    800477 <vprintfmt+0x1e5>
  8004b4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	0f 49 c2             	cmovns %edx,%eax
  8004c1:	29 c2                	sub    %eax,%edx
  8004c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c6:	e9 60 ff ff ff       	jmp    80042b <vprintfmt+0x199>
  8004cb:	89 cf                	mov    %ecx,%edi
  8004cd:	eb 02                	jmp    8004d1 <vprintfmt+0x23f>
  8004cf:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004d1:	85 ff                	test   %edi,%edi
  8004d3:	7e 10                	jle    8004e5 <vprintfmt+0x253>
				putch(' ', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	6a 20                	push   $0x20
  8004db:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004dd:	83 ef 01             	sub    $0x1,%edi
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	eb ec                	jmp    8004d1 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004eb:	e9 63 01 00 00       	jmp    800653 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004f0:	83 f9 01             	cmp    $0x1,%ecx
  8004f3:	7f 1b                	jg     800510 <vprintfmt+0x27e>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	74 63                	je     80055c <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	99                   	cltd   
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb 17                	jmp    800527 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 50 04             	mov    0x4(%eax),%edx
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 40 08             	lea    0x8(%eax),%eax
  800524:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800532:	85 c9                	test   %ecx,%ecx
  800534:	0f 89 ff 00 00 00    	jns    800639 <vprintfmt+0x3a7>
				putch('-', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 2d                	push   $0x2d
  800540:	ff d6                	call   *%esi
				num = -(long long) num;
  800542:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800545:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800548:	f7 da                	neg    %edx
  80054a:	83 d1 00             	adc    $0x0,%ecx
  80054d:	f7 d9                	neg    %ecx
  80054f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800552:	b8 0a 00 00 00       	mov    $0xa,%eax
  800557:	e9 dd 00 00 00       	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	99                   	cltd   
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 04             	lea    0x4(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	eb b4                	jmp    800527 <vprintfmt+0x295>
	if (lflag >= 2)
  800573:	83 f9 01             	cmp    $0x1,%ecx
  800576:	7f 1e                	jg     800596 <vprintfmt+0x304>
	else if (lflag)
  800578:	85 c9                	test   %ecx,%ecx
  80057a:	74 32                	je     8005ae <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800591:	e9 a3 00 00 00       	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8b 48 04             	mov    0x4(%eax),%ecx
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 8b 00 00 00       	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c3:	eb 74                	jmp    800639 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7f 1b                	jg     8005e5 <vprintfmt+0x353>
	else if (lflag)
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	74 2c                	je     8005fa <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
  8005e3:	eb 54                	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 10                	mov    (%eax),%edx
  8005ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ed:	8d 40 08             	lea    0x8(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f8:	eb 3f                	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060a:	b8 08 00 00 00       	mov    $0x8,%eax
  80060f:	eb 28                	jmp    800639 <vprintfmt+0x3a7>
			putch('0', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 30                	push   $0x30
  800617:	ff d6                	call   *%esi
			putch('x', putdat);
  800619:	83 c4 08             	add    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 78                	push   $0x78
  80061f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800634:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800640:	57                   	push   %edi
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	50                   	push   %eax
  800645:	51                   	push   %ecx
  800646:	52                   	push   %edx
  800647:	89 da                	mov    %ebx,%edx
  800649:	89 f0                	mov    %esi,%eax
  80064b:	e8 5a fb ff ff       	call   8001aa <printnum>
			break;
  800650:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	e9 55 fc ff ff       	jmp    8002b0 <vprintfmt+0x1e>
	if (lflag >= 2)
  80065b:	83 f9 01             	cmp    $0x1,%ecx
  80065e:	7f 1b                	jg     80067b <vprintfmt+0x3e9>
	else if (lflag)
  800660:	85 c9                	test   %ecx,%ecx
  800662:	74 2c                	je     800690 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 10                	mov    (%eax),%edx
  800669:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800674:	b8 10 00 00 00       	mov    $0x10,%eax
  800679:	eb be                	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	8b 48 04             	mov    0x4(%eax),%ecx
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800689:	b8 10 00 00 00       	mov    $0x10,%eax
  80068e:	eb a9                	jmp    800639 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a5:	eb 92                	jmp    800639 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 25                	push   $0x25
  8006ad:	ff d6                	call   *%esi
			break;
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	eb 9f                	jmp    800653 <vprintfmt+0x3c1>
			putch('%', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 25                	push   $0x25
  8006ba:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 f8                	mov    %edi,%eax
  8006c1:	eb 03                	jmp    8006c6 <vprintfmt+0x434>
  8006c3:	83 e8 01             	sub    $0x1,%eax
  8006c6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ca:	75 f7                	jne    8006c3 <vprintfmt+0x431>
  8006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cf:	eb 82                	jmp    800653 <vprintfmt+0x3c1>

008006d1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	83 ec 18             	sub    $0x18,%esp
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	74 26                	je     800718 <vsnprintf+0x47>
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	7e 22                	jle    800718 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f6:	ff 75 14             	pushl  0x14(%ebp)
  8006f9:	ff 75 10             	pushl  0x10(%ebp)
  8006fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ff:	50                   	push   %eax
  800700:	68 58 02 80 00       	push   $0x800258
  800705:	e8 88 fb ff ff       	call   800292 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800713:	83 c4 10             	add    $0x10,%esp
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    
		return -E_INVAL;
  800718:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071d:	eb f7                	jmp    800716 <vsnprintf+0x45>

0080071f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800725:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800728:	50                   	push   %eax
  800729:	ff 75 10             	pushl  0x10(%ebp)
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	ff 75 08             	pushl  0x8(%ebp)
  800732:	e8 9a ff ff ff       	call   8006d1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
  80073c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80073f:	b8 00 00 00 00       	mov    $0x0,%eax
  800744:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800748:	74 05                	je     80074f <strlen+0x16>
		n++;
  80074a:	83 c0 01             	add    $0x1,%eax
  80074d:	eb f5                	jmp    800744 <strlen+0xb>
	return n;
}
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800757:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80075a:	ba 00 00 00 00       	mov    $0x0,%edx
  80075f:	39 c2                	cmp    %eax,%edx
  800761:	74 0d                	je     800770 <strnlen+0x1f>
  800763:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800767:	74 05                	je     80076e <strnlen+0x1d>
		n++;
  800769:	83 c2 01             	add    $0x1,%edx
  80076c:	eb f1                	jmp    80075f <strnlen+0xe>
  80076e:	89 d0                	mov    %edx,%eax
	return n;
}
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	53                   	push   %ebx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80077c:	ba 00 00 00 00       	mov    $0x0,%edx
  800781:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800785:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800788:	83 c2 01             	add    $0x1,%edx
  80078b:	84 c9                	test   %cl,%cl
  80078d:	75 f2                	jne    800781 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80078f:	5b                   	pop    %ebx
  800790:	5d                   	pop    %ebp
  800791:	c3                   	ret    

00800792 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	53                   	push   %ebx
  800796:	83 ec 10             	sub    $0x10,%esp
  800799:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80079c:	53                   	push   %ebx
  80079d:	e8 97 ff ff ff       	call   800739 <strlen>
  8007a2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	01 d8                	add    %ebx,%eax
  8007aa:	50                   	push   %eax
  8007ab:	e8 c2 ff ff ff       	call   800772 <strcpy>
	return dst;
}
  8007b0:	89 d8                	mov    %ebx,%eax
  8007b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	56                   	push   %esi
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c2:	89 c6                	mov    %eax,%esi
  8007c4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	39 f2                	cmp    %esi,%edx
  8007cb:	74 11                	je     8007de <strncpy+0x27>
		*dst++ = *src;
  8007cd:	83 c2 01             	add    $0x1,%edx
  8007d0:	0f b6 19             	movzbl (%ecx),%ebx
  8007d3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d6:	80 fb 01             	cmp    $0x1,%bl
  8007d9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007dc:	eb eb                	jmp    8007c9 <strncpy+0x12>
	}
	return ret;
}
  8007de:	5b                   	pop    %ebx
  8007df:	5e                   	pop    %esi
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	74 21                	je     800817 <strlcpy+0x35>
  8007f6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007fa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007fc:	39 c2                	cmp    %eax,%edx
  8007fe:	74 14                	je     800814 <strlcpy+0x32>
  800800:	0f b6 19             	movzbl (%ecx),%ebx
  800803:	84 db                	test   %bl,%bl
  800805:	74 0b                	je     800812 <strlcpy+0x30>
			*dst++ = *src++;
  800807:	83 c1 01             	add    $0x1,%ecx
  80080a:	83 c2 01             	add    $0x1,%edx
  80080d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800810:	eb ea                	jmp    8007fc <strlcpy+0x1a>
  800812:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800814:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800817:	29 f0                	sub    %esi,%eax
}
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800826:	0f b6 01             	movzbl (%ecx),%eax
  800829:	84 c0                	test   %al,%al
  80082b:	74 0c                	je     800839 <strcmp+0x1c>
  80082d:	3a 02                	cmp    (%edx),%al
  80082f:	75 08                	jne    800839 <strcmp+0x1c>
		p++, q++;
  800831:	83 c1 01             	add    $0x1,%ecx
  800834:	83 c2 01             	add    $0x1,%edx
  800837:	eb ed                	jmp    800826 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800839:	0f b6 c0             	movzbl %al,%eax
  80083c:	0f b6 12             	movzbl (%edx),%edx
  80083f:	29 d0                	sub    %edx,%eax
}
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	53                   	push   %ebx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084d:	89 c3                	mov    %eax,%ebx
  80084f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800852:	eb 06                	jmp    80085a <strncmp+0x17>
		n--, p++, q++;
  800854:	83 c0 01             	add    $0x1,%eax
  800857:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80085a:	39 d8                	cmp    %ebx,%eax
  80085c:	74 16                	je     800874 <strncmp+0x31>
  80085e:	0f b6 08             	movzbl (%eax),%ecx
  800861:	84 c9                	test   %cl,%cl
  800863:	74 04                	je     800869 <strncmp+0x26>
  800865:	3a 0a                	cmp    (%edx),%cl
  800867:	74 eb                	je     800854 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800869:	0f b6 00             	movzbl (%eax),%eax
  80086c:	0f b6 12             	movzbl (%edx),%edx
  80086f:	29 d0                	sub    %edx,%eax
}
  800871:	5b                   	pop    %ebx
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    
		return 0;
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
  800879:	eb f6                	jmp    800871 <strncmp+0x2e>

0080087b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800885:	0f b6 10             	movzbl (%eax),%edx
  800888:	84 d2                	test   %dl,%dl
  80088a:	74 09                	je     800895 <strchr+0x1a>
		if (*s == c)
  80088c:	38 ca                	cmp    %cl,%dl
  80088e:	74 0a                	je     80089a <strchr+0x1f>
	for (; *s; s++)
  800890:	83 c0 01             	add    $0x1,%eax
  800893:	eb f0                	jmp    800885 <strchr+0xa>
			return (char *) s;
	return 0;
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008a9:	38 ca                	cmp    %cl,%dl
  8008ab:	74 09                	je     8008b6 <strfind+0x1a>
  8008ad:	84 d2                	test   %dl,%dl
  8008af:	74 05                	je     8008b6 <strfind+0x1a>
	for (; *s; s++)
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	eb f0                	jmp    8008a6 <strfind+0xa>
			break;
	return (char *) s;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	57                   	push   %edi
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
  8008be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008c4:	85 c9                	test   %ecx,%ecx
  8008c6:	74 31                	je     8008f9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008c8:	89 f8                	mov    %edi,%eax
  8008ca:	09 c8                	or     %ecx,%eax
  8008cc:	a8 03                	test   $0x3,%al
  8008ce:	75 23                	jne    8008f3 <memset+0x3b>
		c &= 0xFF;
  8008d0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008d4:	89 d3                	mov    %edx,%ebx
  8008d6:	c1 e3 08             	shl    $0x8,%ebx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	c1 e0 18             	shl    $0x18,%eax
  8008de:	89 d6                	mov    %edx,%esi
  8008e0:	c1 e6 10             	shl    $0x10,%esi
  8008e3:	09 f0                	or     %esi,%eax
  8008e5:	09 c2                	or     %eax,%edx
  8008e7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008e9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008ec:	89 d0                	mov    %edx,%eax
  8008ee:	fc                   	cld    
  8008ef:	f3 ab                	rep stos %eax,%es:(%edi)
  8008f1:	eb 06                	jmp    8008f9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	fc                   	cld    
  8008f7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008f9:	89 f8                	mov    %edi,%eax
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5f                   	pop    %edi
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 75 0c             	mov    0xc(%ebp),%esi
  80090b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80090e:	39 c6                	cmp    %eax,%esi
  800910:	73 32                	jae    800944 <memmove+0x44>
  800912:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800915:	39 c2                	cmp    %eax,%edx
  800917:	76 2b                	jbe    800944 <memmove+0x44>
		s += n;
		d += n;
  800919:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091c:	89 fe                	mov    %edi,%esi
  80091e:	09 ce                	or     %ecx,%esi
  800920:	09 d6                	or     %edx,%esi
  800922:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800928:	75 0e                	jne    800938 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80092a:	83 ef 04             	sub    $0x4,%edi
  80092d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800930:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800933:	fd                   	std    
  800934:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800936:	eb 09                	jmp    800941 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800938:	83 ef 01             	sub    $0x1,%edi
  80093b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80093e:	fd                   	std    
  80093f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800941:	fc                   	cld    
  800942:	eb 1a                	jmp    80095e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800944:	89 c2                	mov    %eax,%edx
  800946:	09 ca                	or     %ecx,%edx
  800948:	09 f2                	or     %esi,%edx
  80094a:	f6 c2 03             	test   $0x3,%dl
  80094d:	75 0a                	jne    800959 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80094f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800952:	89 c7                	mov    %eax,%edi
  800954:	fc                   	cld    
  800955:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800957:	eb 05                	jmp    80095e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800959:	89 c7                	mov    %eax,%edi
  80095b:	fc                   	cld    
  80095c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800968:	ff 75 10             	pushl  0x10(%ebp)
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	ff 75 08             	pushl  0x8(%ebp)
  800971:	e8 8a ff ff ff       	call   800900 <memmove>
}
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
  800983:	89 c6                	mov    %eax,%esi
  800985:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800988:	39 f0                	cmp    %esi,%eax
  80098a:	74 1c                	je     8009a8 <memcmp+0x30>
		if (*s1 != *s2)
  80098c:	0f b6 08             	movzbl (%eax),%ecx
  80098f:	0f b6 1a             	movzbl (%edx),%ebx
  800992:	38 d9                	cmp    %bl,%cl
  800994:	75 08                	jne    80099e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	83 c2 01             	add    $0x1,%edx
  80099c:	eb ea                	jmp    800988 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80099e:	0f b6 c1             	movzbl %cl,%eax
  8009a1:	0f b6 db             	movzbl %bl,%ebx
  8009a4:	29 d8                	sub    %ebx,%eax
  8009a6:	eb 05                	jmp    8009ad <memcmp+0x35>
	}

	return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ba:	89 c2                	mov    %eax,%edx
  8009bc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009bf:	39 d0                	cmp    %edx,%eax
  8009c1:	73 09                	jae    8009cc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c3:	38 08                	cmp    %cl,(%eax)
  8009c5:	74 05                	je     8009cc <memfind+0x1b>
	for (; s < ends; s++)
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	eb f3                	jmp    8009bf <memfind+0xe>
			break;
	return (void *) s;
}
  8009cc:	5d                   	pop    %ebp
  8009cd:	c3                   	ret    

008009ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	57                   	push   %edi
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009da:	eb 03                	jmp    8009df <strtol+0x11>
		s++;
  8009dc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009df:	0f b6 01             	movzbl (%ecx),%eax
  8009e2:	3c 20                	cmp    $0x20,%al
  8009e4:	74 f6                	je     8009dc <strtol+0xe>
  8009e6:	3c 09                	cmp    $0x9,%al
  8009e8:	74 f2                	je     8009dc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009ea:	3c 2b                	cmp    $0x2b,%al
  8009ec:	74 2a                	je     800a18 <strtol+0x4a>
	int neg = 0;
  8009ee:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009f3:	3c 2d                	cmp    $0x2d,%al
  8009f5:	74 2b                	je     800a22 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009fd:	75 0f                	jne    800a0e <strtol+0x40>
  8009ff:	80 39 30             	cmpb   $0x30,(%ecx)
  800a02:	74 28                	je     800a2c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a0b:	0f 44 d8             	cmove  %eax,%ebx
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a13:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a16:	eb 50                	jmp    800a68 <strtol+0x9a>
		s++;
  800a18:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a20:	eb d5                	jmp    8009f7 <strtol+0x29>
		s++, neg = 1;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	bf 01 00 00 00       	mov    $0x1,%edi
  800a2a:	eb cb                	jmp    8009f7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a2c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a30:	74 0e                	je     800a40 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	75 d8                	jne    800a0e <strtol+0x40>
		s++, base = 8;
  800a36:	83 c1 01             	add    $0x1,%ecx
  800a39:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a3e:	eb ce                	jmp    800a0e <strtol+0x40>
		s += 2, base = 16;
  800a40:	83 c1 02             	add    $0x2,%ecx
  800a43:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a48:	eb c4                	jmp    800a0e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a4a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a4d:	89 f3                	mov    %esi,%ebx
  800a4f:	80 fb 19             	cmp    $0x19,%bl
  800a52:	77 29                	ja     800a7d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a54:	0f be d2             	movsbl %dl,%edx
  800a57:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a5d:	7d 30                	jge    800a8f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a5f:	83 c1 01             	add    $0x1,%ecx
  800a62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a68:	0f b6 11             	movzbl (%ecx),%edx
  800a6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a6e:	89 f3                	mov    %esi,%ebx
  800a70:	80 fb 09             	cmp    $0x9,%bl
  800a73:	77 d5                	ja     800a4a <strtol+0x7c>
			dig = *s - '0';
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 30             	sub    $0x30,%edx
  800a7b:	eb dd                	jmp    800a5a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a7d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a80:	89 f3                	mov    %esi,%ebx
  800a82:	80 fb 19             	cmp    $0x19,%bl
  800a85:	77 08                	ja     800a8f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a87:	0f be d2             	movsbl %dl,%edx
  800a8a:	83 ea 37             	sub    $0x37,%edx
  800a8d:	eb cb                	jmp    800a5a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a93:	74 05                	je     800a9a <strtol+0xcc>
		*endptr = (char *) s;
  800a95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a98:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a9a:	89 c2                	mov    %eax,%edx
  800a9c:	f7 da                	neg    %edx
  800a9e:	85 ff                	test   %edi,%edi
  800aa0:	0f 45 c2             	cmovne %edx,%eax
}
  800aa3:	5b                   	pop    %ebx
  800aa4:	5e                   	pop    %esi
  800aa5:	5f                   	pop    %edi
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	57                   	push   %edi
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab9:	89 c3                	mov    %eax,%ebx
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	89 c6                	mov    %eax,%esi
  800abf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800acc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ad6:	89 d1                	mov    %edx,%ecx
  800ad8:	89 d3                	mov    %edx,%ebx
  800ada:	89 d7                	mov    %edx,%edi
  800adc:	89 d6                	mov    %edx,%esi
  800ade:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800aee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af3:	8b 55 08             	mov    0x8(%ebp),%edx
  800af6:	b8 03 00 00 00       	mov    $0x3,%eax
  800afb:	89 cb                	mov    %ecx,%ebx
  800afd:	89 cf                	mov    %ecx,%edi
  800aff:	89 ce                	mov    %ecx,%esi
  800b01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b03:	85 c0                	test   %eax,%eax
  800b05:	7f 08                	jg     800b0f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5f                   	pop    %edi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b0f:	83 ec 0c             	sub    $0xc,%esp
  800b12:	50                   	push   %eax
  800b13:	6a 03                	push   $0x3
  800b15:	68 ff 25 80 00       	push   $0x8025ff
  800b1a:	6a 23                	push   $0x23
  800b1c:	68 1c 26 80 00       	push   $0x80261c
  800b21:	e8 c9 14 00 00       	call   801fef <_panic>

00800b26 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	b8 02 00 00 00       	mov    $0x2,%eax
  800b36:	89 d1                	mov    %edx,%ecx
  800b38:	89 d3                	mov    %edx,%ebx
  800b3a:	89 d7                	mov    %edx,%edi
  800b3c:	89 d6                	mov    %edx,%esi
  800b3e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <sys_yield>:

void
sys_yield(void)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b55:	89 d1                	mov    %edx,%ecx
  800b57:	89 d3                	mov    %edx,%ebx
  800b59:	89 d7                	mov    %edx,%edi
  800b5b:	89 d6                	mov    %edx,%esi
  800b5d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
  800b6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b6d:	be 00 00 00 00       	mov    $0x0,%esi
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	b8 04 00 00 00       	mov    $0x4,%eax
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b80:	89 f7                	mov    %esi,%edi
  800b82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b84:	85 c0                	test   %eax,%eax
  800b86:	7f 08                	jg     800b90 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	50                   	push   %eax
  800b94:	6a 04                	push   $0x4
  800b96:	68 ff 25 80 00       	push   $0x8025ff
  800b9b:	6a 23                	push   $0x23
  800b9d:	68 1c 26 80 00       	push   $0x80261c
  800ba2:	e8 48 14 00 00       	call   801fef <_panic>

00800ba7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb6:	b8 05 00 00 00       	mov    $0x5,%eax
  800bbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800bc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc6:	85 c0                	test   %eax,%eax
  800bc8:	7f 08                	jg     800bd2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	50                   	push   %eax
  800bd6:	6a 05                	push   $0x5
  800bd8:	68 ff 25 80 00       	push   $0x8025ff
  800bdd:	6a 23                	push   $0x23
  800bdf:	68 1c 26 80 00       	push   $0x80261c
  800be4:	e8 06 14 00 00       	call   801fef <_panic>

00800be9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800c02:	89 df                	mov    %ebx,%edi
  800c04:	89 de                	mov    %ebx,%esi
  800c06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	7f 08                	jg     800c14 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c14:	83 ec 0c             	sub    $0xc,%esp
  800c17:	50                   	push   %eax
  800c18:	6a 06                	push   $0x6
  800c1a:	68 ff 25 80 00       	push   $0x8025ff
  800c1f:	6a 23                	push   $0x23
  800c21:	68 1c 26 80 00       	push   $0x80261c
  800c26:	e8 c4 13 00 00       	call   801fef <_panic>

00800c2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c44:	89 df                	mov    %ebx,%edi
  800c46:	89 de                	mov    %ebx,%esi
  800c48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7f 08                	jg     800c56 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	6a 08                	push   $0x8
  800c5c:	68 ff 25 80 00       	push   $0x8025ff
  800c61:	6a 23                	push   $0x23
  800c63:	68 1c 26 80 00       	push   $0x80261c
  800c68:	e8 82 13 00 00       	call   801fef <_panic>

00800c6d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	b8 09 00 00 00       	mov    $0x9,%eax
  800c86:	89 df                	mov    %ebx,%edi
  800c88:	89 de                	mov    %ebx,%esi
  800c8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7f 08                	jg     800c98 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 09                	push   $0x9
  800c9e:	68 ff 25 80 00       	push   $0x8025ff
  800ca3:	6a 23                	push   $0x23
  800ca5:	68 1c 26 80 00       	push   $0x80261c
  800caa:	e8 40 13 00 00       	call   801fef <_panic>

00800caf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc8:	89 df                	mov    %ebx,%edi
  800cca:	89 de                	mov    %ebx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 0a                	push   $0xa
  800ce0:	68 ff 25 80 00       	push   $0x8025ff
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 1c 26 80 00       	push   $0x80261c
  800cec:	e8 fe 12 00 00       	call   801fef <_panic>

00800cf1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d02:	be 00 00 00 00       	mov    $0x0,%esi
  800d07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
  800d1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d2a:	89 cb                	mov    %ecx,%ebx
  800d2c:	89 cf                	mov    %ecx,%edi
  800d2e:	89 ce                	mov    %ecx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 0d                	push   $0xd
  800d44:	68 ff 25 80 00       	push   $0x8025ff
  800d49:	6a 23                	push   $0x23
  800d4b:	68 1c 26 80 00       	push   $0x80261c
  800d50:	e8 9a 12 00 00       	call   801fef <_panic>

00800d55 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	8b 75 08             	mov    0x8(%ebp),%esi
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  800d82:	85 c0                	test   %eax,%eax
  800d84:	74 4f                	je     800dd5 <ipc_recv+0x61>
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	e8 85 ff ff ff       	call   800d14 <sys_ipc_recv>
  800d8f:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  800d92:	85 f6                	test   %esi,%esi
  800d94:	74 14                	je     800daa <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  800d96:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	75 09                	jne    800da8 <ipc_recv+0x34>
  800d9f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800da5:	8b 52 74             	mov    0x74(%edx),%edx
  800da8:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  800daa:	85 db                	test   %ebx,%ebx
  800dac:	74 14                	je     800dc2 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	85 c0                	test   %eax,%eax
  800db5:	75 09                	jne    800dc0 <ipc_recv+0x4c>
  800db7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800dbd:	8b 52 78             	mov    0x78(%edx),%edx
  800dc0:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	75 08                	jne    800dce <ipc_recv+0x5a>
  800dc6:	a1 08 40 80 00       	mov    0x804008,%eax
  800dcb:	8b 40 70             	mov    0x70(%eax),%eax
}
  800dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	68 00 00 c0 ee       	push   $0xeec00000
  800ddd:	e8 32 ff ff ff       	call   800d14 <sys_ipc_recv>
  800de2:	83 c4 10             	add    $0x10,%esp
  800de5:	eb ab                	jmp    800d92 <ipc_recv+0x1e>

00800de7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800df3:	8b 75 10             	mov    0x10(%ebp),%esi
  800df6:	eb 20                	jmp    800e18 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  800df8:	6a 00                	push   $0x0
  800dfa:	68 00 00 c0 ee       	push   $0xeec00000
  800dff:	ff 75 0c             	pushl  0xc(%ebp)
  800e02:	57                   	push   %edi
  800e03:	e8 e9 fe ff ff       	call   800cf1 <sys_ipc_try_send>
  800e08:	89 c3                	mov    %eax,%ebx
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	eb 1f                	jmp    800e2e <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  800e0f:	e8 31 fd ff ff       	call   800b45 <sys_yield>
	while(retval != 0) {
  800e14:	85 db                	test   %ebx,%ebx
  800e16:	74 33                	je     800e4b <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  800e18:	85 f6                	test   %esi,%esi
  800e1a:	74 dc                	je     800df8 <ipc_send+0x11>
  800e1c:	ff 75 14             	pushl  0x14(%ebp)
  800e1f:	56                   	push   %esi
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	57                   	push   %edi
  800e24:	e8 c8 fe ff ff       	call   800cf1 <sys_ipc_try_send>
  800e29:	89 c3                	mov    %eax,%ebx
  800e2b:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  800e2e:	83 fb f9             	cmp    $0xfffffff9,%ebx
  800e31:	74 dc                	je     800e0f <ipc_send+0x28>
  800e33:	85 db                	test   %ebx,%ebx
  800e35:	74 d8                	je     800e0f <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  800e37:	83 ec 04             	sub    $0x4,%esp
  800e3a:	68 2c 26 80 00       	push   $0x80262c
  800e3f:	6a 35                	push   $0x35
  800e41:	68 5c 26 80 00       	push   $0x80265c
  800e46:	e8 a4 11 00 00       	call   801fef <_panic>
	}
}
  800e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800e5e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800e61:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800e67:	8b 52 50             	mov    0x50(%edx),%edx
  800e6a:	39 ca                	cmp    %ecx,%edx
  800e6c:	74 11                	je     800e7f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800e6e:	83 c0 01             	add    $0x1,%eax
  800e71:	3d 00 04 00 00       	cmp    $0x400,%eax
  800e76:	75 e6                	jne    800e5e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800e78:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7d:	eb 0b                	jmp    800e8a <ipc_find_env+0x37>
			return envs[i].env_id;
  800e7f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e82:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e87:	8b 40 48             	mov    0x48(%eax),%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	05 00 00 00 30       	add    $0x30000000,%eax
  800e97:	c1 e8 0c             	shr    $0xc,%eax
}
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	c1 ea 16             	shr    $0x16,%edx
  800ec0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ec7:	f6 c2 01             	test   $0x1,%dl
  800eca:	74 2d                	je     800ef9 <fd_alloc+0x46>
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	c1 ea 0c             	shr    $0xc,%edx
  800ed1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ed8:	f6 c2 01             	test   $0x1,%dl
  800edb:	74 1c                	je     800ef9 <fd_alloc+0x46>
  800edd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ee2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ee7:	75 d2                	jne    800ebb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ef2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ef7:	eb 0a                	jmp    800f03 <fd_alloc+0x50>
			*fd_store = fd;
  800ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efc:	89 01                	mov    %eax,(%ecx)
			return 0;
  800efe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f0b:	83 f8 1f             	cmp    $0x1f,%eax
  800f0e:	77 30                	ja     800f40 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f10:	c1 e0 0c             	shl    $0xc,%eax
  800f13:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f18:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f1e:	f6 c2 01             	test   $0x1,%dl
  800f21:	74 24                	je     800f47 <fd_lookup+0x42>
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	c1 ea 0c             	shr    $0xc,%edx
  800f28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f2f:	f6 c2 01             	test   $0x1,%dl
  800f32:	74 1a                	je     800f4e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f37:	89 02                	mov    %eax,(%edx)
	return 0;
  800f39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    
		return -E_INVAL;
  800f40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f45:	eb f7                	jmp    800f3e <fd_lookup+0x39>
		return -E_INVAL;
  800f47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4c:	eb f0                	jmp    800f3e <fd_lookup+0x39>
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f53:	eb e9                	jmp    800f3e <fd_lookup+0x39>

00800f55 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 08             	sub    $0x8,%esp
  800f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f63:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f68:	39 08                	cmp    %ecx,(%eax)
  800f6a:	74 38                	je     800fa4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f6c:	83 c2 01             	add    $0x1,%edx
  800f6f:	8b 04 95 e4 26 80 00 	mov    0x8026e4(,%edx,4),%eax
  800f76:	85 c0                	test   %eax,%eax
  800f78:	75 ee                	jne    800f68 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f7a:	a1 08 40 80 00       	mov    0x804008,%eax
  800f7f:	8b 40 48             	mov    0x48(%eax),%eax
  800f82:	83 ec 04             	sub    $0x4,%esp
  800f85:	51                   	push   %ecx
  800f86:	50                   	push   %eax
  800f87:	68 68 26 80 00       	push   $0x802668
  800f8c:	e8 05 f2 ff ff       	call   800196 <cprintf>
	*dev = 0;
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    
			*dev = devtab[i];
  800fa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fae:	eb f2                	jmp    800fa2 <dev_lookup+0x4d>

00800fb0 <fd_close>:
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 24             	sub    $0x24,%esp
  800fb9:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fbf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fc9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fcc:	50                   	push   %eax
  800fcd:	e8 33 ff ff ff       	call   800f05 <fd_lookup>
  800fd2:	89 c3                	mov    %eax,%ebx
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	78 05                	js     800fe0 <fd_close+0x30>
	    || fd != fd2)
  800fdb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fde:	74 16                	je     800ff6 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fe0:	89 f8                	mov    %edi,%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe9:	0f 44 d8             	cmove  %eax,%ebx
}
  800fec:	89 d8                	mov    %ebx,%eax
  800fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ffc:	50                   	push   %eax
  800ffd:	ff 36                	pushl  (%esi)
  800fff:	e8 51 ff ff ff       	call   800f55 <dev_lookup>
  801004:	89 c3                	mov    %eax,%ebx
  801006:	83 c4 10             	add    $0x10,%esp
  801009:	85 c0                	test   %eax,%eax
  80100b:	78 1a                	js     801027 <fd_close+0x77>
		if (dev->dev_close)
  80100d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801010:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801013:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801018:	85 c0                	test   %eax,%eax
  80101a:	74 0b                	je     801027 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	56                   	push   %esi
  801020:	ff d0                	call   *%eax
  801022:	89 c3                	mov    %eax,%ebx
  801024:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	56                   	push   %esi
  80102b:	6a 00                	push   $0x0
  80102d:	e8 b7 fb ff ff       	call   800be9 <sys_page_unmap>
	return r;
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb b5                	jmp    800fec <fd_close+0x3c>

00801037 <close>:

int
close(int fdnum)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80103d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801040:	50                   	push   %eax
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 bc fe ff ff       	call   800f05 <fd_lookup>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	79 02                	jns    801052 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    
		return fd_close(fd, 1);
  801052:	83 ec 08             	sub    $0x8,%esp
  801055:	6a 01                	push   $0x1
  801057:	ff 75 f4             	pushl  -0xc(%ebp)
  80105a:	e8 51 ff ff ff       	call   800fb0 <fd_close>
  80105f:	83 c4 10             	add    $0x10,%esp
  801062:	eb ec                	jmp    801050 <close+0x19>

00801064 <close_all>:

void
close_all(void)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	53                   	push   %ebx
  801068:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80106b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	53                   	push   %ebx
  801074:	e8 be ff ff ff       	call   801037 <close>
	for (i = 0; i < MAXFD; i++)
  801079:	83 c3 01             	add    $0x1,%ebx
  80107c:	83 c4 10             	add    $0x10,%esp
  80107f:	83 fb 20             	cmp    $0x20,%ebx
  801082:	75 ec                	jne    801070 <close_all+0xc>
}
  801084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	57                   	push   %edi
  80108d:	56                   	push   %esi
  80108e:	53                   	push   %ebx
  80108f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801092:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801095:	50                   	push   %eax
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 67 fe ff ff       	call   800f05 <fd_lookup>
  80109e:	89 c3                	mov    %eax,%ebx
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	0f 88 81 00 00 00    	js     80112c <dup+0xa3>
		return r;
	close(newfdnum);
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	e8 81 ff ff ff       	call   801037 <close>

	newfd = INDEX2FD(newfdnum);
  8010b6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010b9:	c1 e6 0c             	shl    $0xc,%esi
  8010bc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010c2:	83 c4 04             	add    $0x4,%esp
  8010c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c8:	e8 cf fd ff ff       	call   800e9c <fd2data>
  8010cd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010cf:	89 34 24             	mov    %esi,(%esp)
  8010d2:	e8 c5 fd ff ff       	call   800e9c <fd2data>
  8010d7:	83 c4 10             	add    $0x10,%esp
  8010da:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010dc:	89 d8                	mov    %ebx,%eax
  8010de:	c1 e8 16             	shr    $0x16,%eax
  8010e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010e8:	a8 01                	test   $0x1,%al
  8010ea:	74 11                	je     8010fd <dup+0x74>
  8010ec:	89 d8                	mov    %ebx,%eax
  8010ee:	c1 e8 0c             	shr    $0xc,%eax
  8010f1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010f8:	f6 c2 01             	test   $0x1,%dl
  8010fb:	75 39                	jne    801136 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	c1 e8 0c             	shr    $0xc,%eax
  801105:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	25 07 0e 00 00       	and    $0xe07,%eax
  801114:	50                   	push   %eax
  801115:	56                   	push   %esi
  801116:	6a 00                	push   $0x0
  801118:	52                   	push   %edx
  801119:	6a 00                	push   $0x0
  80111b:	e8 87 fa ff ff       	call   800ba7 <sys_page_map>
  801120:	89 c3                	mov    %eax,%ebx
  801122:	83 c4 20             	add    $0x20,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	78 31                	js     80115a <dup+0xd1>
		goto err;

	return newfdnum;
  801129:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80112c:	89 d8                	mov    %ebx,%eax
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801136:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	25 07 0e 00 00       	and    $0xe07,%eax
  801145:	50                   	push   %eax
  801146:	57                   	push   %edi
  801147:	6a 00                	push   $0x0
  801149:	53                   	push   %ebx
  80114a:	6a 00                	push   $0x0
  80114c:	e8 56 fa ff ff       	call   800ba7 <sys_page_map>
  801151:	89 c3                	mov    %eax,%ebx
  801153:	83 c4 20             	add    $0x20,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	79 a3                	jns    8010fd <dup+0x74>
	sys_page_unmap(0, newfd);
  80115a:	83 ec 08             	sub    $0x8,%esp
  80115d:	56                   	push   %esi
  80115e:	6a 00                	push   $0x0
  801160:	e8 84 fa ff ff       	call   800be9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801165:	83 c4 08             	add    $0x8,%esp
  801168:	57                   	push   %edi
  801169:	6a 00                	push   $0x0
  80116b:	e8 79 fa ff ff       	call   800be9 <sys_page_unmap>
	return r;
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	eb b7                	jmp    80112c <dup+0xa3>

00801175 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	53                   	push   %ebx
  801179:	83 ec 1c             	sub    $0x1c,%esp
  80117c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80117f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	53                   	push   %ebx
  801184:	e8 7c fd ff ff       	call   800f05 <fd_lookup>
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	85 c0                	test   %eax,%eax
  80118e:	78 3f                	js     8011cf <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119a:	ff 30                	pushl  (%eax)
  80119c:	e8 b4 fd ff ff       	call   800f55 <dev_lookup>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	78 27                	js     8011cf <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011ab:	8b 42 08             	mov    0x8(%edx),%eax
  8011ae:	83 e0 03             	and    $0x3,%eax
  8011b1:	83 f8 01             	cmp    $0x1,%eax
  8011b4:	74 1e                	je     8011d4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b9:	8b 40 08             	mov    0x8(%eax),%eax
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 35                	je     8011f5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011c0:	83 ec 04             	sub    $0x4,%esp
  8011c3:	ff 75 10             	pushl  0x10(%ebp)
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	52                   	push   %edx
  8011ca:	ff d0                	call   *%eax
  8011cc:	83 c4 10             	add    $0x10,%esp
}
  8011cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d4:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d9:	8b 40 48             	mov    0x48(%eax),%eax
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	53                   	push   %ebx
  8011e0:	50                   	push   %eax
  8011e1:	68 a9 26 80 00       	push   $0x8026a9
  8011e6:	e8 ab ef ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb da                	jmp    8011cf <read+0x5a>
		return -E_NOT_SUPP;
  8011f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fa:	eb d3                	jmp    8011cf <read+0x5a>

008011fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	8b 7d 08             	mov    0x8(%ebp),%edi
  801208:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80120b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801210:	39 f3                	cmp    %esi,%ebx
  801212:	73 23                	jae    801237 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	89 f0                	mov    %esi,%eax
  801219:	29 d8                	sub    %ebx,%eax
  80121b:	50                   	push   %eax
  80121c:	89 d8                	mov    %ebx,%eax
  80121e:	03 45 0c             	add    0xc(%ebp),%eax
  801221:	50                   	push   %eax
  801222:	57                   	push   %edi
  801223:	e8 4d ff ff ff       	call   801175 <read>
		if (m < 0)
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 06                	js     801235 <readn+0x39>
			return m;
		if (m == 0)
  80122f:	74 06                	je     801237 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801231:	01 c3                	add    %eax,%ebx
  801233:	eb db                	jmp    801210 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801235:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801237:	89 d8                	mov    %ebx,%eax
  801239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123c:	5b                   	pop    %ebx
  80123d:	5e                   	pop    %esi
  80123e:	5f                   	pop    %edi
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    

00801241 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	53                   	push   %ebx
  801245:	83 ec 1c             	sub    $0x1c,%esp
  801248:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124e:	50                   	push   %eax
  80124f:	53                   	push   %ebx
  801250:	e8 b0 fc ff ff       	call   800f05 <fd_lookup>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 3a                	js     801296 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801262:	50                   	push   %eax
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801266:	ff 30                	pushl  (%eax)
  801268:	e8 e8 fc ff ff       	call   800f55 <dev_lookup>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 22                	js     801296 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801277:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80127b:	74 1e                	je     80129b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	8b 52 0c             	mov    0xc(%edx),%edx
  801283:	85 d2                	test   %edx,%edx
  801285:	74 35                	je     8012bc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	ff 75 10             	pushl  0x10(%ebp)
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	50                   	push   %eax
  801291:	ff d2                	call   *%edx
  801293:	83 c4 10             	add    $0x10,%esp
}
  801296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801299:	c9                   	leave  
  80129a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80129b:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a0:	8b 40 48             	mov    0x48(%eax),%eax
  8012a3:	83 ec 04             	sub    $0x4,%esp
  8012a6:	53                   	push   %ebx
  8012a7:	50                   	push   %eax
  8012a8:	68 c5 26 80 00       	push   $0x8026c5
  8012ad:	e8 e4 ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ba:	eb da                	jmp    801296 <write+0x55>
		return -E_NOT_SUPP;
  8012bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c1:	eb d3                	jmp    801296 <write+0x55>

008012c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 30 fc ff ff       	call   800f05 <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 0e                	js     8012ea <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 1c             	sub    $0x1c,%esp
  8012f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f9:	50                   	push   %eax
  8012fa:	53                   	push   %ebx
  8012fb:	e8 05 fc ff ff       	call   800f05 <fd_lookup>
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 37                	js     80133e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801311:	ff 30                	pushl  (%eax)
  801313:	e8 3d fc ff ff       	call   800f55 <dev_lookup>
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 1f                	js     80133e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801322:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801326:	74 1b                	je     801343 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132b:	8b 52 18             	mov    0x18(%edx),%edx
  80132e:	85 d2                	test   %edx,%edx
  801330:	74 32                	je     801364 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	ff 75 0c             	pushl  0xc(%ebp)
  801338:	50                   	push   %eax
  801339:	ff d2                	call   *%edx
  80133b:	83 c4 10             	add    $0x10,%esp
}
  80133e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801341:	c9                   	leave  
  801342:	c3                   	ret    
			thisenv->env_id, fdnum);
  801343:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801348:	8b 40 48             	mov    0x48(%eax),%eax
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	53                   	push   %ebx
  80134f:	50                   	push   %eax
  801350:	68 88 26 80 00       	push   $0x802688
  801355:	e8 3c ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801362:	eb da                	jmp    80133e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801364:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801369:	eb d3                	jmp    80133e <ftruncate+0x52>

0080136b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	53                   	push   %ebx
  80136f:	83 ec 1c             	sub    $0x1c,%esp
  801372:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801375:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 84 fb ff ff       	call   800f05 <fd_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 4b                	js     8013d3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801392:	ff 30                	pushl  (%eax)
  801394:	e8 bc fb ff ff       	call   800f55 <dev_lookup>
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 33                	js     8013d3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013a7:	74 2f                	je     8013d8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013b3:	00 00 00 
	stat->st_isdir = 0;
  8013b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013bd:	00 00 00 
	stat->st_dev = dev;
  8013c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013c6:	83 ec 08             	sub    $0x8,%esp
  8013c9:	53                   	push   %ebx
  8013ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8013cd:	ff 50 14             	call   *0x14(%eax)
  8013d0:	83 c4 10             	add    $0x10,%esp
}
  8013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    
		return -E_NOT_SUPP;
  8013d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013dd:	eb f4                	jmp    8013d3 <fstat+0x68>

008013df <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	6a 00                	push   $0x0
  8013e9:	ff 75 08             	pushl  0x8(%ebp)
  8013ec:	e8 2f 02 00 00       	call   801620 <open>
  8013f1:	89 c3                	mov    %eax,%ebx
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 1b                	js     801415 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013fa:	83 ec 08             	sub    $0x8,%esp
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	50                   	push   %eax
  801401:	e8 65 ff ff ff       	call   80136b <fstat>
  801406:	89 c6                	mov    %eax,%esi
	close(fd);
  801408:	89 1c 24             	mov    %ebx,(%esp)
  80140b:	e8 27 fc ff ff       	call   801037 <close>
	return r;
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	89 f3                	mov    %esi,%ebx
}
  801415:	89 d8                	mov    %ebx,%eax
  801417:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80141a:	5b                   	pop    %ebx
  80141b:	5e                   	pop    %esi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    

0080141e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	89 c6                	mov    %eax,%esi
  801425:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801427:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80142e:	74 27                	je     801457 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801430:	6a 07                	push   $0x7
  801432:	68 00 50 80 00       	push   $0x805000
  801437:	56                   	push   %esi
  801438:	ff 35 00 40 80 00    	pushl  0x804000
  80143e:	e8 a4 f9 ff ff       	call   800de7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801443:	83 c4 0c             	add    $0xc,%esp
  801446:	6a 00                	push   $0x0
  801448:	53                   	push   %ebx
  801449:	6a 00                	push   $0x0
  80144b:	e8 24 f9 ff ff       	call   800d74 <ipc_recv>
}
  801450:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801453:	5b                   	pop    %ebx
  801454:	5e                   	pop    %esi
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	6a 01                	push   $0x1
  80145c:	e8 f2 f9 ff ff       	call   800e53 <ipc_find_env>
  801461:	a3 00 40 80 00       	mov    %eax,0x804000
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	eb c5                	jmp    801430 <fsipc+0x12>

0080146b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8b 40 0c             	mov    0xc(%eax),%eax
  801477:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801484:	ba 00 00 00 00       	mov    $0x0,%edx
  801489:	b8 02 00 00 00       	mov    $0x2,%eax
  80148e:	e8 8b ff ff ff       	call   80141e <fsipc>
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <devfile_flush>:
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ab:	b8 06 00 00 00       	mov    $0x6,%eax
  8014b0:	e8 69 ff ff ff       	call   80141e <fsipc>
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <devfile_stat>:
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	b8 05 00 00 00       	mov    $0x5,%eax
  8014d6:	e8 43 ff ff ff       	call   80141e <fsipc>
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 2c                	js     80150b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	68 00 50 80 00       	push   $0x805000
  8014e7:	53                   	push   %ebx
  8014e8:	e8 85 f2 ff ff       	call   800772 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014ed:	a1 80 50 80 00       	mov    0x805080,%eax
  8014f2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014f8:	a1 84 50 80 00       	mov    0x805084,%eax
  8014fd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <devfile_write>:
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80151a:	85 db                	test   %ebx,%ebx
  80151c:	75 07                	jne    801525 <devfile_write+0x15>
	return n_all;
  80151e:	89 d8                	mov    %ebx,%eax
}
  801520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801523:	c9                   	leave  
  801524:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8b 40 0c             	mov    0xc(%eax),%eax
  80152b:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801530:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	53                   	push   %ebx
  80153a:	ff 75 0c             	pushl  0xc(%ebp)
  80153d:	68 08 50 80 00       	push   $0x805008
  801542:	e8 b9 f3 ff ff       	call   800900 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801547:	ba 00 00 00 00       	mov    $0x0,%edx
  80154c:	b8 04 00 00 00       	mov    $0x4,%eax
  801551:	e8 c8 fe ff ff       	call   80141e <fsipc>
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 c3                	js     801520 <devfile_write+0x10>
	  assert(r <= n_left);
  80155d:	39 d8                	cmp    %ebx,%eax
  80155f:	77 0b                	ja     80156c <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801561:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801566:	7f 1d                	jg     801585 <devfile_write+0x75>
    n_all += r;
  801568:	89 c3                	mov    %eax,%ebx
  80156a:	eb b2                	jmp    80151e <devfile_write+0xe>
	  assert(r <= n_left);
  80156c:	68 f8 26 80 00       	push   $0x8026f8
  801571:	68 04 27 80 00       	push   $0x802704
  801576:	68 9f 00 00 00       	push   $0x9f
  80157b:	68 19 27 80 00       	push   $0x802719
  801580:	e8 6a 0a 00 00       	call   801fef <_panic>
	  assert(r <= PGSIZE);
  801585:	68 24 27 80 00       	push   $0x802724
  80158a:	68 04 27 80 00       	push   $0x802704
  80158f:	68 a0 00 00 00       	push   $0xa0
  801594:	68 19 27 80 00       	push   $0x802719
  801599:	e8 51 0a 00 00       	call   801fef <_panic>

0080159e <devfile_read>:
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c1:	e8 58 fe ff ff       	call   80141e <fsipc>
  8015c6:	89 c3                	mov    %eax,%ebx
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 1f                	js     8015eb <devfile_read+0x4d>
	assert(r <= n);
  8015cc:	39 f0                	cmp    %esi,%eax
  8015ce:	77 24                	ja     8015f4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015d0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015d5:	7f 33                	jg     80160a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	50                   	push   %eax
  8015db:	68 00 50 80 00       	push   $0x805000
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	e8 18 f3 ff ff       	call   800900 <memmove>
	return r;
  8015e8:	83 c4 10             	add    $0x10,%esp
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    
	assert(r <= n);
  8015f4:	68 30 27 80 00       	push   $0x802730
  8015f9:	68 04 27 80 00       	push   $0x802704
  8015fe:	6a 7c                	push   $0x7c
  801600:	68 19 27 80 00       	push   $0x802719
  801605:	e8 e5 09 00 00       	call   801fef <_panic>
	assert(r <= PGSIZE);
  80160a:	68 24 27 80 00       	push   $0x802724
  80160f:	68 04 27 80 00       	push   $0x802704
  801614:	6a 7d                	push   $0x7d
  801616:	68 19 27 80 00       	push   $0x802719
  80161b:	e8 cf 09 00 00       	call   801fef <_panic>

00801620 <open>:
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	56                   	push   %esi
  801624:	53                   	push   %ebx
  801625:	83 ec 1c             	sub    $0x1c,%esp
  801628:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80162b:	56                   	push   %esi
  80162c:	e8 08 f1 ff ff       	call   800739 <strlen>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801639:	7f 6c                	jg     8016a7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80163b:	83 ec 0c             	sub    $0xc,%esp
  80163e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801641:	50                   	push   %eax
  801642:	e8 6c f8 ff ff       	call   800eb3 <fd_alloc>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 3c                	js     80168c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	56                   	push   %esi
  801654:	68 00 50 80 00       	push   $0x805000
  801659:	e8 14 f1 ff ff       	call   800772 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801669:	b8 01 00 00 00       	mov    $0x1,%eax
  80166e:	e8 ab fd ff ff       	call   80141e <fsipc>
  801673:	89 c3                	mov    %eax,%ebx
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 19                	js     801695 <open+0x75>
	return fd2num(fd);
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	ff 75 f4             	pushl  -0xc(%ebp)
  801682:	e8 05 f8 ff ff       	call   800e8c <fd2num>
  801687:	89 c3                	mov    %eax,%ebx
  801689:	83 c4 10             	add    $0x10,%esp
}
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    
		fd_close(fd, 0);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 f4             	pushl  -0xc(%ebp)
  80169d:	e8 0e f9 ff ff       	call   800fb0 <fd_close>
		return r;
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	eb e5                	jmp    80168c <open+0x6c>
		return -E_BAD_PATH;
  8016a7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016ac:	eb de                	jmp    80168c <open+0x6c>

008016ae <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8016be:	e8 5b fd ff ff       	call   80141e <fsipc>
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	56                   	push   %esi
  8016c9:	53                   	push   %ebx
  8016ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	e8 c4 f7 ff ff       	call   800e9c <fd2data>
  8016d8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016da:	83 c4 08             	add    $0x8,%esp
  8016dd:	68 37 27 80 00       	push   $0x802737
  8016e2:	53                   	push   %ebx
  8016e3:	e8 8a f0 ff ff       	call   800772 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016e8:	8b 46 04             	mov    0x4(%esi),%eax
  8016eb:	2b 06                	sub    (%esi),%eax
  8016ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fa:	00 00 00 
	stat->st_dev = &devpipe;
  8016fd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801704:	30 80 00 
	return 0;
}
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    

00801713 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	53                   	push   %ebx
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80171d:	53                   	push   %ebx
  80171e:	6a 00                	push   $0x0
  801720:	e8 c4 f4 ff ff       	call   800be9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 6f f7 ff ff       	call   800e9c <fd2data>
  80172d:	83 c4 08             	add    $0x8,%esp
  801730:	50                   	push   %eax
  801731:	6a 00                	push   $0x0
  801733:	e8 b1 f4 ff ff       	call   800be9 <sys_page_unmap>
}
  801738:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <_pipeisclosed>:
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	57                   	push   %edi
  801741:	56                   	push   %esi
  801742:	53                   	push   %ebx
  801743:	83 ec 1c             	sub    $0x1c,%esp
  801746:	89 c7                	mov    %eax,%edi
  801748:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80174a:	a1 08 40 80 00       	mov    0x804008,%eax
  80174f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801752:	83 ec 0c             	sub    $0xc,%esp
  801755:	57                   	push   %edi
  801756:	e8 da 08 00 00       	call   802035 <pageref>
  80175b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80175e:	89 34 24             	mov    %esi,(%esp)
  801761:	e8 cf 08 00 00       	call   802035 <pageref>
		nn = thisenv->env_runs;
  801766:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80176c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	39 cb                	cmp    %ecx,%ebx
  801774:	74 1b                	je     801791 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801776:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801779:	75 cf                	jne    80174a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80177b:	8b 42 58             	mov    0x58(%edx),%eax
  80177e:	6a 01                	push   $0x1
  801780:	50                   	push   %eax
  801781:	53                   	push   %ebx
  801782:	68 3e 27 80 00       	push   $0x80273e
  801787:	e8 0a ea ff ff       	call   800196 <cprintf>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	eb b9                	jmp    80174a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801791:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801794:	0f 94 c0             	sete   %al
  801797:	0f b6 c0             	movzbl %al,%eax
}
  80179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <devpipe_write>:
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	57                   	push   %edi
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 28             	sub    $0x28,%esp
  8017ab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017ae:	56                   	push   %esi
  8017af:	e8 e8 f6 ff ff       	call   800e9c <fd2data>
  8017b4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8017be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017c1:	74 4f                	je     801812 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017c3:	8b 43 04             	mov    0x4(%ebx),%eax
  8017c6:	8b 0b                	mov    (%ebx),%ecx
  8017c8:	8d 51 20             	lea    0x20(%ecx),%edx
  8017cb:	39 d0                	cmp    %edx,%eax
  8017cd:	72 14                	jb     8017e3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017cf:	89 da                	mov    %ebx,%edx
  8017d1:	89 f0                	mov    %esi,%eax
  8017d3:	e8 65 ff ff ff       	call   80173d <_pipeisclosed>
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	75 3b                	jne    801817 <devpipe_write+0x75>
			sys_yield();
  8017dc:	e8 64 f3 ff ff       	call   800b45 <sys_yield>
  8017e1:	eb e0                	jmp    8017c3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017ea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017ed:	89 c2                	mov    %eax,%edx
  8017ef:	c1 fa 1f             	sar    $0x1f,%edx
  8017f2:	89 d1                	mov    %edx,%ecx
  8017f4:	c1 e9 1b             	shr    $0x1b,%ecx
  8017f7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017fa:	83 e2 1f             	and    $0x1f,%edx
  8017fd:	29 ca                	sub    %ecx,%edx
  8017ff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801803:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801807:	83 c0 01             	add    $0x1,%eax
  80180a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80180d:	83 c7 01             	add    $0x1,%edi
  801810:	eb ac                	jmp    8017be <devpipe_write+0x1c>
	return i;
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	eb 05                	jmp    80181c <devpipe_write+0x7a>
				return 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5f                   	pop    %edi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <devpipe_read>:
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	57                   	push   %edi
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
  80182a:	83 ec 18             	sub    $0x18,%esp
  80182d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801830:	57                   	push   %edi
  801831:	e8 66 f6 ff ff       	call   800e9c <fd2data>
  801836:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	be 00 00 00 00       	mov    $0x0,%esi
  801840:	3b 75 10             	cmp    0x10(%ebp),%esi
  801843:	75 14                	jne    801859 <devpipe_read+0x35>
	return i;
  801845:	8b 45 10             	mov    0x10(%ebp),%eax
  801848:	eb 02                	jmp    80184c <devpipe_read+0x28>
				return i;
  80184a:	89 f0                	mov    %esi,%eax
}
  80184c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5f                   	pop    %edi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    
			sys_yield();
  801854:	e8 ec f2 ff ff       	call   800b45 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801859:	8b 03                	mov    (%ebx),%eax
  80185b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80185e:	75 18                	jne    801878 <devpipe_read+0x54>
			if (i > 0)
  801860:	85 f6                	test   %esi,%esi
  801862:	75 e6                	jne    80184a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801864:	89 da                	mov    %ebx,%edx
  801866:	89 f8                	mov    %edi,%eax
  801868:	e8 d0 fe ff ff       	call   80173d <_pipeisclosed>
  80186d:	85 c0                	test   %eax,%eax
  80186f:	74 e3                	je     801854 <devpipe_read+0x30>
				return 0;
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
  801876:	eb d4                	jmp    80184c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801878:	99                   	cltd   
  801879:	c1 ea 1b             	shr    $0x1b,%edx
  80187c:	01 d0                	add    %edx,%eax
  80187e:	83 e0 1f             	and    $0x1f,%eax
  801881:	29 d0                	sub    %edx,%eax
  801883:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801888:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80188e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801891:	83 c6 01             	add    $0x1,%esi
  801894:	eb aa                	jmp    801840 <devpipe_read+0x1c>

00801896 <pipe>:
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80189e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	e8 0c f6 ff ff       	call   800eb3 <fd_alloc>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	0f 88 23 01 00 00    	js     8019d7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 07 04 00 00       	push   $0x407
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	6a 00                	push   $0x0
  8018c1:	e8 9e f2 ff ff       	call   800b64 <sys_page_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	0f 88 04 01 00 00    	js     8019d7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	e8 d4 f5 ff ff       	call   800eb3 <fd_alloc>
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	0f 88 db 00 00 00    	js     8019c7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 07 04 00 00       	push   $0x407
  8018f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f7:	6a 00                	push   $0x0
  8018f9:	e8 66 f2 ff ff       	call   800b64 <sys_page_alloc>
  8018fe:	89 c3                	mov    %eax,%ebx
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	85 c0                	test   %eax,%eax
  801905:	0f 88 bc 00 00 00    	js     8019c7 <pipe+0x131>
	va = fd2data(fd0);
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	ff 75 f4             	pushl  -0xc(%ebp)
  801911:	e8 86 f5 ff ff       	call   800e9c <fd2data>
  801916:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801918:	83 c4 0c             	add    $0xc,%esp
  80191b:	68 07 04 00 00       	push   $0x407
  801920:	50                   	push   %eax
  801921:	6a 00                	push   $0x0
  801923:	e8 3c f2 ff ff       	call   800b64 <sys_page_alloc>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	0f 88 82 00 00 00    	js     8019b7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801935:	83 ec 0c             	sub    $0xc,%esp
  801938:	ff 75 f0             	pushl  -0x10(%ebp)
  80193b:	e8 5c f5 ff ff       	call   800e9c <fd2data>
  801940:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801947:	50                   	push   %eax
  801948:	6a 00                	push   $0x0
  80194a:	56                   	push   %esi
  80194b:	6a 00                	push   $0x0
  80194d:	e8 55 f2 ff ff       	call   800ba7 <sys_page_map>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 20             	add    $0x20,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 4e                	js     8019a9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80195b:	a1 20 30 80 00       	mov    0x803020,%eax
  801960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801963:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801968:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80196f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801972:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801977:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	ff 75 f4             	pushl  -0xc(%ebp)
  801984:	e8 03 f5 ff ff       	call   800e8c <fd2num>
  801989:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80198c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80198e:	83 c4 04             	add    $0x4,%esp
  801991:	ff 75 f0             	pushl  -0x10(%ebp)
  801994:	e8 f3 f4 ff ff       	call   800e8c <fd2num>
  801999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80199c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a7:	eb 2e                	jmp    8019d7 <pipe+0x141>
	sys_page_unmap(0, va);
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	56                   	push   %esi
  8019ad:	6a 00                	push   $0x0
  8019af:	e8 35 f2 ff ff       	call   800be9 <sys_page_unmap>
  8019b4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8019bd:	6a 00                	push   $0x0
  8019bf:	e8 25 f2 ff ff       	call   800be9 <sys_page_unmap>
  8019c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cd:	6a 00                	push   $0x0
  8019cf:	e8 15 f2 ff ff       	call   800be9 <sys_page_unmap>
  8019d4:	83 c4 10             	add    $0x10,%esp
}
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <pipeisclosed>:
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e9:	50                   	push   %eax
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	e8 13 f5 ff ff       	call   800f05 <fd_lookup>
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 18                	js     801a11 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ff:	e8 98 f4 ff ff       	call   800e9c <fd2data>
	return _pipeisclosed(fd, p);
  801a04:	89 c2                	mov    %eax,%edx
  801a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a09:	e8 2f fd ff ff       	call   80173d <_pipeisclosed>
  801a0e:	83 c4 10             	add    $0x10,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a19:	68 56 27 80 00       	push   $0x802756
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	e8 4c ed ff ff       	call   800772 <strcpy>
	return 0;
}
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <devsock_close>:
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	53                   	push   %ebx
  801a31:	83 ec 10             	sub    $0x10,%esp
  801a34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a37:	53                   	push   %ebx
  801a38:	e8 f8 05 00 00       	call   802035 <pageref>
  801a3d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a45:	83 f8 01             	cmp    $0x1,%eax
  801a48:	74 07                	je     801a51 <devsock_close+0x24>
}
  801a4a:	89 d0                	mov    %edx,%eax
  801a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a51:	83 ec 0c             	sub    $0xc,%esp
  801a54:	ff 73 0c             	pushl  0xc(%ebx)
  801a57:	e8 b9 02 00 00       	call   801d15 <nsipc_close>
  801a5c:	89 c2                	mov    %eax,%edx
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	eb e7                	jmp    801a4a <devsock_close+0x1d>

00801a63 <devsock_write>:
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 10             	pushl  0x10(%ebp)
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	ff 70 0c             	pushl  0xc(%eax)
  801a77:	e8 76 03 00 00       	call   801df2 <nsipc_send>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <devsock_read>:
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	ff 70 0c             	pushl  0xc(%eax)
  801a92:	e8 ef 02 00 00       	call   801d86 <nsipc_recv>
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <fd2sockid>:
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	e8 5c f4 ff ff       	call   800f05 <fd_lookup>
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 10                	js     801ac0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ab9:	39 08                	cmp    %ecx,(%eax)
  801abb:	75 05                	jne    801ac2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801abd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    
		return -E_NOT_SUPP;
  801ac2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac7:	eb f7                	jmp    801ac0 <fd2sockid+0x27>

00801ac9 <alloc_sockfd>:
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
  801ace:	83 ec 1c             	sub    $0x1c,%esp
  801ad1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ad3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad6:	50                   	push   %eax
  801ad7:	e8 d7 f3 ff ff       	call   800eb3 <fd_alloc>
  801adc:	89 c3                	mov    %eax,%ebx
  801ade:	83 c4 10             	add    $0x10,%esp
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 43                	js     801b28 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	68 07 04 00 00       	push   $0x407
  801aed:	ff 75 f4             	pushl  -0xc(%ebp)
  801af0:	6a 00                	push   $0x0
  801af2:	e8 6d f0 ff ff       	call   800b64 <sys_page_alloc>
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 28                	js     801b28 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b09:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b15:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	50                   	push   %eax
  801b1c:	e8 6b f3 ff ff       	call   800e8c <fd2num>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	eb 0c                	jmp    801b34 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	56                   	push   %esi
  801b2c:	e8 e4 01 00 00       	call   801d15 <nsipc_close>
		return r;
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    

00801b3d <accept>:
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	e8 4e ff ff ff       	call   801a99 <fd2sockid>
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 1b                	js     801b6a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	50                   	push   %eax
  801b59:	e8 0e 01 00 00       	call   801c6c <nsipc_accept>
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 05                	js     801b6a <accept+0x2d>
	return alloc_sockfd(r);
  801b65:	e8 5f ff ff ff       	call   801ac9 <alloc_sockfd>
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <bind>:
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	e8 1f ff ff ff       	call   801a99 <fd2sockid>
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 12                	js     801b90 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	ff 75 10             	pushl  0x10(%ebp)
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	50                   	push   %eax
  801b88:	e8 31 01 00 00       	call   801cbe <nsipc_bind>
  801b8d:	83 c4 10             	add    $0x10,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <shutdown>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	e8 f9 fe ff ff       	call   801a99 <fd2sockid>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 0f                	js     801bb3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	50                   	push   %eax
  801bab:	e8 43 01 00 00       	call   801cf3 <nsipc_shutdown>
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <connect>:
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	e8 d6 fe ff ff       	call   801a99 <fd2sockid>
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 12                	js     801bd9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	ff 75 10             	pushl  0x10(%ebp)
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	e8 59 01 00 00       	call   801d2f <nsipc_connect>
  801bd6:	83 c4 10             	add    $0x10,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <listen>:
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	e8 b0 fe ff ff       	call   801a99 <fd2sockid>
  801be9:	85 c0                	test   %eax,%eax
  801beb:	78 0f                	js     801bfc <listen+0x21>
	return nsipc_listen(r, backlog);
  801bed:	83 ec 08             	sub    $0x8,%esp
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	50                   	push   %eax
  801bf4:	e8 6b 01 00 00       	call   801d64 <nsipc_listen>
  801bf9:	83 c4 10             	add    $0x10,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <socket>:

int
socket(int domain, int type, int protocol)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	e8 3e 02 00 00       	call   801e50 <nsipc_socket>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 05                	js     801c1e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c19:	e8 ab fe ff ff       	call   801ac9 <alloc_sockfd>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c29:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c30:	74 26                	je     801c58 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c32:	6a 07                	push   $0x7
  801c34:	68 00 60 80 00       	push   $0x806000
  801c39:	53                   	push   %ebx
  801c3a:	ff 35 04 40 80 00    	pushl  0x804004
  801c40:	e8 a2 f1 ff ff       	call   800de7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c45:	83 c4 0c             	add    $0xc,%esp
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	e8 21 f1 ff ff       	call   800d74 <ipc_recv>
}
  801c53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	6a 02                	push   $0x2
  801c5d:	e8 f1 f1 ff ff       	call   800e53 <ipc_find_env>
  801c62:	a3 04 40 80 00       	mov    %eax,0x804004
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	eb c6                	jmp    801c32 <nsipc+0x12>

00801c6c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c7c:	8b 06                	mov    (%esi),%eax
  801c7e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c83:	b8 01 00 00 00       	mov    $0x1,%eax
  801c88:	e8 93 ff ff ff       	call   801c20 <nsipc>
  801c8d:	89 c3                	mov    %eax,%ebx
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	79 09                	jns    801c9c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c93:	89 d8                	mov    %ebx,%eax
  801c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	ff 35 10 60 80 00    	pushl  0x806010
  801ca5:	68 00 60 80 00       	push   $0x806000
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	e8 4e ec ff ff       	call   800900 <memmove>
		*addrlen = ret->ret_addrlen;
  801cb2:	a1 10 60 80 00       	mov    0x806010,%eax
  801cb7:	89 06                	mov    %eax,(%esi)
  801cb9:	83 c4 10             	add    $0x10,%esp
	return r;
  801cbc:	eb d5                	jmp    801c93 <nsipc_accept+0x27>

00801cbe <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cd0:	53                   	push   %ebx
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	68 04 60 80 00       	push   $0x806004
  801cd9:	e8 22 ec ff ff       	call   800900 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cde:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ce4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ce9:	e8 32 ff ff ff       	call   801c20 <nsipc>
}
  801cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d09:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0e:	e8 0d ff ff ff       	call   801c20 <nsipc>
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <nsipc_close>:

int
nsipc_close(int s)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d23:	b8 04 00 00 00       	mov    $0x4,%eax
  801d28:	e8 f3 fe ff ff       	call   801c20 <nsipc>
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	53                   	push   %ebx
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d41:	53                   	push   %ebx
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	68 04 60 80 00       	push   $0x806004
  801d4a:	e8 b1 eb ff ff       	call   800900 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d4f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d55:	b8 05 00 00 00       	mov    $0x5,%eax
  801d5a:	e8 c1 fe ff ff       	call   801c20 <nsipc>
}
  801d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d75:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d7a:	b8 06 00 00 00       	mov    $0x6,%eax
  801d7f:	e8 9c fe ff ff       	call   801c20 <nsipc>
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	56                   	push   %esi
  801d8a:	53                   	push   %ebx
  801d8b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d96:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801da4:	b8 07 00 00 00       	mov    $0x7,%eax
  801da9:	e8 72 fe ff ff       	call   801c20 <nsipc>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 1f                	js     801dd3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801db4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801db9:	7f 21                	jg     801ddc <nsipc_recv+0x56>
  801dbb:	39 c6                	cmp    %eax,%esi
  801dbd:	7c 1d                	jl     801ddc <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	50                   	push   %eax
  801dc3:	68 00 60 80 00       	push   $0x806000
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	e8 30 eb ff ff       	call   800900 <memmove>
  801dd0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dd3:	89 d8                	mov    %ebx,%eax
  801dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ddc:	68 62 27 80 00       	push   $0x802762
  801de1:	68 04 27 80 00       	push   $0x802704
  801de6:	6a 62                	push   $0x62
  801de8:	68 77 27 80 00       	push   $0x802777
  801ded:	e8 fd 01 00 00       	call   801fef <_panic>

00801df2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	53                   	push   %ebx
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e04:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e0a:	7f 2e                	jg     801e3a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e0c:	83 ec 04             	sub    $0x4,%esp
  801e0f:	53                   	push   %ebx
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	68 0c 60 80 00       	push   $0x80600c
  801e18:	e8 e3 ea ff ff       	call   800900 <memmove>
	nsipcbuf.send.req_size = size;
  801e1d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e23:	8b 45 14             	mov    0x14(%ebp),%eax
  801e26:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e2b:	b8 08 00 00 00       	mov    $0x8,%eax
  801e30:	e8 eb fd ff ff       	call   801c20 <nsipc>
}
  801e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    
	assert(size < 1600);
  801e3a:	68 83 27 80 00       	push   $0x802783
  801e3f:	68 04 27 80 00       	push   $0x802704
  801e44:	6a 6d                	push   $0x6d
  801e46:	68 77 27 80 00       	push   $0x802777
  801e4b:	e8 9f 01 00 00       	call   801fef <_panic>

00801e50 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e61:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e66:	8b 45 10             	mov    0x10(%ebp),%eax
  801e69:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e6e:	b8 09 00 00 00       	mov    $0x9,%eax
  801e73:	e8 a8 fd ff ff       	call   801c20 <nsipc>
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7f:	c3                   	ret    

00801e80 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e86:	68 8f 27 80 00       	push   $0x80278f
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	e8 df e8 ff ff       	call   800772 <strcpy>
	return 0;
}
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <devcons_write>:
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	57                   	push   %edi
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
  801ea0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ea6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801eb1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb4:	73 31                	jae    801ee7 <devcons_write+0x4d>
		m = n - tot;
  801eb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eb9:	29 f3                	sub    %esi,%ebx
  801ebb:	83 fb 7f             	cmp    $0x7f,%ebx
  801ebe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ec3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	53                   	push   %ebx
  801eca:	89 f0                	mov    %esi,%eax
  801ecc:	03 45 0c             	add    0xc(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	57                   	push   %edi
  801ed1:	e8 2a ea ff ff       	call   800900 <memmove>
		sys_cputs(buf, m);
  801ed6:	83 c4 08             	add    $0x8,%esp
  801ed9:	53                   	push   %ebx
  801eda:	57                   	push   %edi
  801edb:	e8 c8 eb ff ff       	call   800aa8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ee0:	01 de                	add    %ebx,%esi
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	eb ca                	jmp    801eb1 <devcons_write+0x17>
}
  801ee7:	89 f0                	mov    %esi,%eax
  801ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eec:	5b                   	pop    %ebx
  801eed:	5e                   	pop    %esi
  801eee:	5f                   	pop    %edi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <devcons_read>:
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f00:	74 21                	je     801f23 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801f02:	e8 bf eb ff ff       	call   800ac6 <sys_cgetc>
  801f07:	85 c0                	test   %eax,%eax
  801f09:	75 07                	jne    801f12 <devcons_read+0x21>
		sys_yield();
  801f0b:	e8 35 ec ff ff       	call   800b45 <sys_yield>
  801f10:	eb f0                	jmp    801f02 <devcons_read+0x11>
	if (c < 0)
  801f12:	78 0f                	js     801f23 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f14:	83 f8 04             	cmp    $0x4,%eax
  801f17:	74 0c                	je     801f25 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1c:	88 02                	mov    %al,(%edx)
	return 1;
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    
		return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2a:	eb f7                	jmp    801f23 <devcons_read+0x32>

00801f2c <cputchar>:
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f38:	6a 01                	push   $0x1
  801f3a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f3d:	50                   	push   %eax
  801f3e:	e8 65 eb ff ff       	call   800aa8 <sys_cputs>
}
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <getchar>:
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f4e:	6a 01                	push   $0x1
  801f50:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f53:	50                   	push   %eax
  801f54:	6a 00                	push   $0x0
  801f56:	e8 1a f2 ff ff       	call   801175 <read>
	if (r < 0)
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 06                	js     801f68 <getchar+0x20>
	if (r < 1)
  801f62:	74 06                	je     801f6a <getchar+0x22>
	return c;
  801f64:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    
		return -E_EOF;
  801f6a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f6f:	eb f7                	jmp    801f68 <getchar+0x20>

00801f71 <iscons>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7a:	50                   	push   %eax
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	e8 82 ef ff ff       	call   800f05 <fd_lookup>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 11                	js     801f9b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f93:	39 10                	cmp    %edx,(%eax)
  801f95:	0f 94 c0             	sete   %al
  801f98:	0f b6 c0             	movzbl %al,%eax
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <opencons>:
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	e8 07 ef ff ff       	call   800eb3 <fd_alloc>
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	78 3a                	js     801fed <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	68 07 04 00 00       	push   $0x407
  801fbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 9f eb ff ff       	call   800b64 <sys_page_alloc>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 21                	js     801fed <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fd5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	50                   	push   %eax
  801fe5:	e8 a2 ee ff ff       	call   800e8c <fd2num>
  801fea:	83 c4 10             	add    $0x10,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ff4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ff7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ffd:	e8 24 eb ff ff       	call   800b26 <sys_getenvid>
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	56                   	push   %esi
  80200c:	50                   	push   %eax
  80200d:	68 9c 27 80 00       	push   $0x80279c
  802012:	e8 7f e1 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802017:	83 c4 18             	add    $0x18,%esp
  80201a:	53                   	push   %ebx
  80201b:	ff 75 10             	pushl  0x10(%ebp)
  80201e:	e8 22 e1 ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  802023:	c7 04 24 4f 27 80 00 	movl   $0x80274f,(%esp)
  80202a:	e8 67 e1 ff ff       	call   800196 <cprintf>
  80202f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802032:	cc                   	int3   
  802033:	eb fd                	jmp    802032 <_panic+0x43>

00802035 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80203b:	89 d0                	mov    %edx,%eax
  80203d:	c1 e8 16             	shr    $0x16,%eax
  802040:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80204c:	f6 c1 01             	test   $0x1,%cl
  80204f:	74 1d                	je     80206e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802051:	c1 ea 0c             	shr    $0xc,%edx
  802054:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80205b:	f6 c2 01             	test   $0x1,%dl
  80205e:	74 0e                	je     80206e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802060:	c1 ea 0c             	shr    $0xc,%edx
  802063:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80206a:	ef 
  80206b:	0f b7 c0             	movzwl %ax,%eax
}
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    

00802070 <__udivdi3>:
  802070:	f3 0f 1e fb          	endbr32 
  802074:	55                   	push   %ebp
  802075:	57                   	push   %edi
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	83 ec 1c             	sub    $0x1c,%esp
  80207b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80207f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802083:	8b 74 24 34          	mov    0x34(%esp),%esi
  802087:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80208b:	85 d2                	test   %edx,%edx
  80208d:	75 49                	jne    8020d8 <__udivdi3+0x68>
  80208f:	39 f3                	cmp    %esi,%ebx
  802091:	76 15                	jbe    8020a8 <__udivdi3+0x38>
  802093:	31 ff                	xor    %edi,%edi
  802095:	89 e8                	mov    %ebp,%eax
  802097:	89 f2                	mov    %esi,%edx
  802099:	f7 f3                	div    %ebx
  80209b:	89 fa                	mov    %edi,%edx
  80209d:	83 c4 1c             	add    $0x1c,%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5f                   	pop    %edi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	89 d9                	mov    %ebx,%ecx
  8020aa:	85 db                	test   %ebx,%ebx
  8020ac:	75 0b                	jne    8020b9 <__udivdi3+0x49>
  8020ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	f7 f3                	div    %ebx
  8020b7:	89 c1                	mov    %eax,%ecx
  8020b9:	31 d2                	xor    %edx,%edx
  8020bb:	89 f0                	mov    %esi,%eax
  8020bd:	f7 f1                	div    %ecx
  8020bf:	89 c6                	mov    %eax,%esi
  8020c1:	89 e8                	mov    %ebp,%eax
  8020c3:	89 f7                	mov    %esi,%edi
  8020c5:	f7 f1                	div    %ecx
  8020c7:	89 fa                	mov    %edi,%edx
  8020c9:	83 c4 1c             	add    $0x1c,%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5e                   	pop    %esi
  8020ce:	5f                   	pop    %edi
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    
  8020d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020d8:	39 f2                	cmp    %esi,%edx
  8020da:	77 1c                	ja     8020f8 <__udivdi3+0x88>
  8020dc:	0f bd fa             	bsr    %edx,%edi
  8020df:	83 f7 1f             	xor    $0x1f,%edi
  8020e2:	75 2c                	jne    802110 <__udivdi3+0xa0>
  8020e4:	39 f2                	cmp    %esi,%edx
  8020e6:	72 06                	jb     8020ee <__udivdi3+0x7e>
  8020e8:	31 c0                	xor    %eax,%eax
  8020ea:	39 eb                	cmp    %ebp,%ebx
  8020ec:	77 ad                	ja     80209b <__udivdi3+0x2b>
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	eb a6                	jmp    80209b <__udivdi3+0x2b>
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	31 ff                	xor    %edi,%edi
  8020fa:	31 c0                	xor    %eax,%eax
  8020fc:	89 fa                	mov    %edi,%edx
  8020fe:	83 c4 1c             	add    $0x1c,%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5f                   	pop    %edi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    
  802106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80210d:	8d 76 00             	lea    0x0(%esi),%esi
  802110:	89 f9                	mov    %edi,%ecx
  802112:	b8 20 00 00 00       	mov    $0x20,%eax
  802117:	29 f8                	sub    %edi,%eax
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	89 da                	mov    %ebx,%edx
  802123:	d3 ea                	shr    %cl,%edx
  802125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802129:	09 d1                	or     %edx,%ecx
  80212b:	89 f2                	mov    %esi,%edx
  80212d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802131:	89 f9                	mov    %edi,%ecx
  802133:	d3 e3                	shl    %cl,%ebx
  802135:	89 c1                	mov    %eax,%ecx
  802137:	d3 ea                	shr    %cl,%edx
  802139:	89 f9                	mov    %edi,%ecx
  80213b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80213f:	89 eb                	mov    %ebp,%ebx
  802141:	d3 e6                	shl    %cl,%esi
  802143:	89 c1                	mov    %eax,%ecx
  802145:	d3 eb                	shr    %cl,%ebx
  802147:	09 de                	or     %ebx,%esi
  802149:	89 f0                	mov    %esi,%eax
  80214b:	f7 74 24 08          	divl   0x8(%esp)
  80214f:	89 d6                	mov    %edx,%esi
  802151:	89 c3                	mov    %eax,%ebx
  802153:	f7 64 24 0c          	mull   0xc(%esp)
  802157:	39 d6                	cmp    %edx,%esi
  802159:	72 15                	jb     802170 <__udivdi3+0x100>
  80215b:	89 f9                	mov    %edi,%ecx
  80215d:	d3 e5                	shl    %cl,%ebp
  80215f:	39 c5                	cmp    %eax,%ebp
  802161:	73 04                	jae    802167 <__udivdi3+0xf7>
  802163:	39 d6                	cmp    %edx,%esi
  802165:	74 09                	je     802170 <__udivdi3+0x100>
  802167:	89 d8                	mov    %ebx,%eax
  802169:	31 ff                	xor    %edi,%edi
  80216b:	e9 2b ff ff ff       	jmp    80209b <__udivdi3+0x2b>
  802170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802173:	31 ff                	xor    %edi,%edi
  802175:	e9 21 ff ff ff       	jmp    80209b <__udivdi3+0x2b>
  80217a:	66 90                	xchg   %ax,%ax
  80217c:	66 90                	xchg   %ax,%ax
  80217e:	66 90                	xchg   %ax,%ax

00802180 <__umoddi3>:
  802180:	f3 0f 1e fb          	endbr32 
  802184:	55                   	push   %ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 1c             	sub    $0x1c,%esp
  80218b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80218f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802193:	8b 74 24 30          	mov    0x30(%esp),%esi
  802197:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80219b:	89 da                	mov    %ebx,%edx
  80219d:	85 c0                	test   %eax,%eax
  80219f:	75 3f                	jne    8021e0 <__umoddi3+0x60>
  8021a1:	39 df                	cmp    %ebx,%edi
  8021a3:	76 13                	jbe    8021b8 <__umoddi3+0x38>
  8021a5:	89 f0                	mov    %esi,%eax
  8021a7:	f7 f7                	div    %edi
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	83 c4 1c             	add    $0x1c,%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5f                   	pop    %edi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	89 fd                	mov    %edi,%ebp
  8021ba:	85 ff                	test   %edi,%edi
  8021bc:	75 0b                	jne    8021c9 <__umoddi3+0x49>
  8021be:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c3:	31 d2                	xor    %edx,%edx
  8021c5:	f7 f7                	div    %edi
  8021c7:	89 c5                	mov    %eax,%ebp
  8021c9:	89 d8                	mov    %ebx,%eax
  8021cb:	31 d2                	xor    %edx,%edx
  8021cd:	f7 f5                	div    %ebp
  8021cf:	89 f0                	mov    %esi,%eax
  8021d1:	f7 f5                	div    %ebp
  8021d3:	89 d0                	mov    %edx,%eax
  8021d5:	eb d4                	jmp    8021ab <__umoddi3+0x2b>
  8021d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	89 f1                	mov    %esi,%ecx
  8021e2:	39 d8                	cmp    %ebx,%eax
  8021e4:	76 0a                	jbe    8021f0 <__umoddi3+0x70>
  8021e6:	89 f0                	mov    %esi,%eax
  8021e8:	83 c4 1c             	add    $0x1c,%esp
  8021eb:	5b                   	pop    %ebx
  8021ec:	5e                   	pop    %esi
  8021ed:	5f                   	pop    %edi
  8021ee:	5d                   	pop    %ebp
  8021ef:	c3                   	ret    
  8021f0:	0f bd e8             	bsr    %eax,%ebp
  8021f3:	83 f5 1f             	xor    $0x1f,%ebp
  8021f6:	75 20                	jne    802218 <__umoddi3+0x98>
  8021f8:	39 d8                	cmp    %ebx,%eax
  8021fa:	0f 82 b0 00 00 00    	jb     8022b0 <__umoddi3+0x130>
  802200:	39 f7                	cmp    %esi,%edi
  802202:	0f 86 a8 00 00 00    	jbe    8022b0 <__umoddi3+0x130>
  802208:	89 c8                	mov    %ecx,%eax
  80220a:	83 c4 1c             	add    $0x1c,%esp
  80220d:	5b                   	pop    %ebx
  80220e:	5e                   	pop    %esi
  80220f:	5f                   	pop    %edi
  802210:	5d                   	pop    %ebp
  802211:	c3                   	ret    
  802212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802218:	89 e9                	mov    %ebp,%ecx
  80221a:	ba 20 00 00 00       	mov    $0x20,%edx
  80221f:	29 ea                	sub    %ebp,%edx
  802221:	d3 e0                	shl    %cl,%eax
  802223:	89 44 24 08          	mov    %eax,0x8(%esp)
  802227:	89 d1                	mov    %edx,%ecx
  802229:	89 f8                	mov    %edi,%eax
  80222b:	d3 e8                	shr    %cl,%eax
  80222d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802231:	89 54 24 04          	mov    %edx,0x4(%esp)
  802235:	8b 54 24 04          	mov    0x4(%esp),%edx
  802239:	09 c1                	or     %eax,%ecx
  80223b:	89 d8                	mov    %ebx,%eax
  80223d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802241:	89 e9                	mov    %ebp,%ecx
  802243:	d3 e7                	shl    %cl,%edi
  802245:	89 d1                	mov    %edx,%ecx
  802247:	d3 e8                	shr    %cl,%eax
  802249:	89 e9                	mov    %ebp,%ecx
  80224b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80224f:	d3 e3                	shl    %cl,%ebx
  802251:	89 c7                	mov    %eax,%edi
  802253:	89 d1                	mov    %edx,%ecx
  802255:	89 f0                	mov    %esi,%eax
  802257:	d3 e8                	shr    %cl,%eax
  802259:	89 e9                	mov    %ebp,%ecx
  80225b:	89 fa                	mov    %edi,%edx
  80225d:	d3 e6                	shl    %cl,%esi
  80225f:	09 d8                	or     %ebx,%eax
  802261:	f7 74 24 08          	divl   0x8(%esp)
  802265:	89 d1                	mov    %edx,%ecx
  802267:	89 f3                	mov    %esi,%ebx
  802269:	f7 64 24 0c          	mull   0xc(%esp)
  80226d:	89 c6                	mov    %eax,%esi
  80226f:	89 d7                	mov    %edx,%edi
  802271:	39 d1                	cmp    %edx,%ecx
  802273:	72 06                	jb     80227b <__umoddi3+0xfb>
  802275:	75 10                	jne    802287 <__umoddi3+0x107>
  802277:	39 c3                	cmp    %eax,%ebx
  802279:	73 0c                	jae    802287 <__umoddi3+0x107>
  80227b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80227f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802283:	89 d7                	mov    %edx,%edi
  802285:	89 c6                	mov    %eax,%esi
  802287:	89 ca                	mov    %ecx,%edx
  802289:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80228e:	29 f3                	sub    %esi,%ebx
  802290:	19 fa                	sbb    %edi,%edx
  802292:	89 d0                	mov    %edx,%eax
  802294:	d3 e0                	shl    %cl,%eax
  802296:	89 e9                	mov    %ebp,%ecx
  802298:	d3 eb                	shr    %cl,%ebx
  80229a:	d3 ea                	shr    %cl,%edx
  80229c:	09 d8                	or     %ebx,%eax
  80229e:	83 c4 1c             	add    $0x1c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	89 da                	mov    %ebx,%edx
  8022b2:	29 fe                	sub    %edi,%esi
  8022b4:	19 c2                	sbb    %eax,%edx
  8022b6:	89 f1                	mov    %esi,%ecx
  8022b8:	89 c8                	mov    %ecx,%eax
  8022ba:	e9 4b ff ff ff       	jmp    80220a <__umoddi3+0x8a>
