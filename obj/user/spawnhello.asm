
obj/user/spawnhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 40 80 00       	mov    0x804008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 a0 28 80 00       	push   $0x8028a0
  800047:	e8 6a 01 00 00       	call   8001b6 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 be 28 80 00       	push   $0x8028be
  800056:	68 be 28 80 00       	push   $0x8028be
  80005b:	e8 ef 1a 00 00       	call   801b4f <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 c4 28 80 00       	push   $0x8028c4
  80006f:	6a 09                	push   $0x9
  800071:	68 dc 28 80 00       	push   $0x8028dc
  800076:	e8 60 00 00 00       	call   8000db <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 bb 0a 00 00       	call   800b46 <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 a0 0e 00 00       	call   800f6c <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 2f 0a 00 00       	call   800b05 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e9:	e8 58 0a 00 00       	call   800b46 <sys_getenvid>
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 0c             	pushl  0xc(%ebp)
  8000f4:	ff 75 08             	pushl  0x8(%ebp)
  8000f7:	56                   	push   %esi
  8000f8:	50                   	push   %eax
  8000f9:	68 f8 28 80 00       	push   $0x8028f8
  8000fe:	e8 b3 00 00 00       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800103:	83 c4 18             	add    $0x18,%esp
  800106:	53                   	push   %ebx
  800107:	ff 75 10             	pushl  0x10(%ebp)
  80010a:	e8 56 00 00 00       	call   800165 <vcprintf>
	cprintf("\n");
  80010f:	c7 04 24 16 2e 80 00 	movl   $0x802e16,(%esp)
  800116:	e8 9b 00 00 00       	call   8001b6 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80011e:	cc                   	int3   
  80011f:	eb fd                	jmp    80011e <_panic+0x43>

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	53                   	push   %ebx
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012b:	8b 13                	mov    (%ebx),%edx
  80012d:	8d 42 01             	lea    0x1(%edx),%eax
  800130:	89 03                	mov    %eax,(%ebx)
  800132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800135:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	74 09                	je     800149 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800147:	c9                   	leave  
  800148:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 ff 00 00 00       	push   $0xff
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	e8 6e 09 00 00       	call   800ac8 <sys_cputs>
		b->idx = 0;
  80015a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb db                	jmp    800140 <putch+0x1f>

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 21 01 80 00       	push   $0x800121
  800194:	e8 19 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 1a 09 00 00       	call   800ac8 <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bf:	50                   	push   %eax
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	e8 9d ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	89 c7                	mov    %eax,%edi
  8001d5:	89 d6                	mov    %edx,%esi
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001f4:	89 d0                	mov    %edx,%eax
  8001f6:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001fc:	73 15                	jae    800213 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001fe:	83 eb 01             	sub    $0x1,%ebx
  800201:	85 db                	test   %ebx,%ebx
  800203:	7e 43                	jle    800248 <printnum+0x7e>
			putch(padc, putdat);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	ff 75 18             	pushl  0x18(%ebp)
  80020c:	ff d7                	call   *%edi
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	eb eb                	jmp    8001fe <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 75 18             	pushl  0x18(%ebp)
  800219:	8b 45 14             	mov    0x14(%ebp),%eax
  80021c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80021f:	53                   	push   %ebx
  800220:	ff 75 10             	pushl  0x10(%ebp)
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	ff 75 e4             	pushl  -0x1c(%ebp)
  800229:	ff 75 e0             	pushl  -0x20(%ebp)
  80022c:	ff 75 dc             	pushl  -0x24(%ebp)
  80022f:	ff 75 d8             	pushl  -0x28(%ebp)
  800232:	e8 19 24 00 00       	call   802650 <__udivdi3>
  800237:	83 c4 18             	add    $0x18,%esp
  80023a:	52                   	push   %edx
  80023b:	50                   	push   %eax
  80023c:	89 f2                	mov    %esi,%edx
  80023e:	89 f8                	mov    %edi,%eax
  800240:	e8 85 ff ff ff       	call   8001ca <printnum>
  800245:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	56                   	push   %esi
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	e8 00 25 00 00       	call   802760 <__umoddi3>
  800260:	83 c4 14             	add    $0x14,%esp
  800263:	0f be 80 1b 29 80 00 	movsbl 0x80291b(%eax),%eax
  80026a:	50                   	push   %eax
  80026b:	ff d7                	call   *%edi
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1b>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	pushl  0x10(%ebp)
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 3c             	sub    $0x3c,%esp
  8002bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	eb 0a                	jmp    8002d0 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	53                   	push   %ebx
  8002ca:	50                   	push   %eax
  8002cb:	ff d6                	call   *%esi
  8002cd:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002d0:	83 c7 01             	add    $0x1,%edi
  8002d3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002d7:	83 f8 25             	cmp    $0x25,%eax
  8002da:	74 0c                	je     8002e8 <vprintfmt+0x36>
			if (ch == '\0')
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	75 e6                	jne    8002c6 <vprintfmt+0x14>
}
  8002e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e3:	5b                   	pop    %ebx
  8002e4:	5e                   	pop    %esi
  8002e5:	5f                   	pop    %edi
  8002e6:	5d                   	pop    %ebp
  8002e7:	c3                   	ret    
		padc = ' ';
  8002e8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800301:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800306:	8d 47 01             	lea    0x1(%edi),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030c:	0f b6 17             	movzbl (%edi),%edx
  80030f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800312:	3c 55                	cmp    $0x55,%al
  800314:	0f 87 ba 03 00 00    	ja     8006d4 <vprintfmt+0x422>
  80031a:	0f b6 c0             	movzbl %al,%eax
  80031d:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800327:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032b:	eb d9                	jmp    800306 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800330:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800334:	eb d0                	jmp    800306 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800336:	0f b6 d2             	movzbl %dl,%edx
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800344:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800347:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800351:	83 f9 09             	cmp    $0x9,%ecx
  800354:	77 55                	ja     8003ab <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800356:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800359:	eb e9                	jmp    800344 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8d 40 04             	lea    0x4(%eax),%eax
  800369:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800373:	79 91                	jns    800306 <vprintfmt+0x54>
				width = precision, precision = -1;
  800375:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800382:	eb 82                	jmp    800306 <vprintfmt+0x54>
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	ba 00 00 00 00       	mov    $0x0,%edx
  80038e:	0f 49 d0             	cmovns %eax,%edx
  800391:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800397:	e9 6a ff ff ff       	jmp    800306 <vprintfmt+0x54>
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a6:	e9 5b ff ff ff       	jmp    800306 <vprintfmt+0x54>
  8003ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	eb bc                	jmp    80036f <vprintfmt+0xbd>
			lflag++;
  8003b3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 48 ff ff ff       	jmp    800306 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	53                   	push   %ebx
  8003c8:	ff 30                	pushl  (%eax)
  8003ca:	ff d6                	call   *%esi
			break;
  8003cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d2:	e9 9c 02 00 00       	jmp    800673 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	99                   	cltd   
  8003e0:	31 d0                	xor    %edx,%eax
  8003e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e4:	83 f8 0f             	cmp    $0xf,%eax
  8003e7:	7f 23                	jg     80040c <vprintfmt+0x15a>
  8003e9:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 fa 2c 80 00       	push   $0x802cfa
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 94 fe ff ff       	call   800295 <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 67 02 00 00       	jmp    800673 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 33 29 80 00       	push   $0x802933
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 7c fe ff ff       	call   800295 <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041f:	e9 4f 02 00 00       	jmp    800673 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	83 c0 04             	add    $0x4,%eax
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 2c 29 80 00       	mov    $0x80292c,%eax
  800439:	0f 45 c2             	cmovne %edx,%eax
  80043c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800443:	7e 06                	jle    80044b <vprintfmt+0x199>
  800445:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800449:	75 0d                	jne    800458 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044e:	89 c7                	mov    %eax,%edi
  800450:	03 45 e0             	add    -0x20(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb 3f                	jmp    800497 <vprintfmt+0x1e5>
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 0d 03 00 00       	call   800771 <strnlen>
  800464:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800467:	29 c2                	sub    %eax,%edx
  800469:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800471:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800478:	85 ff                	test   %edi,%edi
  80047a:	7e 58                	jle    8004d4 <vprintfmt+0x222>
					putch(padc, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	ff 75 e0             	pushl  -0x20(%ebp)
  800483:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800485:	83 ef 01             	sub    $0x1,%edi
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	eb eb                	jmp    800478 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	53                   	push   %ebx
  800491:	52                   	push   %edx
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049c:	83 c7 01             	add    $0x1,%edi
  80049f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a3:	0f be d0             	movsbl %al,%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	74 45                	je     8004ef <vprintfmt+0x23d>
  8004aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ae:	78 06                	js     8004b6 <vprintfmt+0x204>
  8004b0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b4:	78 35                	js     8004eb <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ba:	74 d1                	je     80048d <vprintfmt+0x1db>
  8004bc:	0f be c0             	movsbl %al,%eax
  8004bf:	83 e8 20             	sub    $0x20,%eax
  8004c2:	83 f8 5e             	cmp    $0x5e,%eax
  8004c5:	76 c6                	jbe    80048d <vprintfmt+0x1db>
					putch('?', putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	53                   	push   %ebx
  8004cb:	6a 3f                	push   $0x3f
  8004cd:	ff d6                	call   *%esi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	eb c3                	jmp    800497 <vprintfmt+0x1e5>
  8004d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	0f 49 c2             	cmovns %edx,%eax
  8004e1:	29 c2                	sub    %eax,%edx
  8004e3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e6:	e9 60 ff ff ff       	jmp    80044b <vprintfmt+0x199>
  8004eb:	89 cf                	mov    %ecx,%edi
  8004ed:	eb 02                	jmp    8004f1 <vprintfmt+0x23f>
  8004ef:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	7e 10                	jle    800505 <vprintfmt+0x253>
				putch(' ', putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	53                   	push   %ebx
  8004f9:	6a 20                	push   $0x20
  8004fb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fd:	83 ef 01             	sub    $0x1,%edi
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	eb ec                	jmp    8004f1 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 63 01 00 00       	jmp    800673 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800510:	83 f9 01             	cmp    $0x1,%ecx
  800513:	7f 1b                	jg     800530 <vprintfmt+0x27e>
	else if (lflag)
  800515:	85 c9                	test   %ecx,%ecx
  800517:	74 63                	je     80057c <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	99                   	cltd   
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 04             	lea    0x4(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
  80052e:	eb 17                	jmp    800547 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	8b 50 04             	mov    0x4(%eax),%edx
  800536:	8b 00                	mov    (%eax),%eax
  800538:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8d 40 08             	lea    0x8(%eax),%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800547:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800552:	85 c9                	test   %ecx,%ecx
  800554:	0f 89 ff 00 00 00    	jns    800659 <vprintfmt+0x3a7>
				putch('-', putdat);
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	53                   	push   %ebx
  80055e:	6a 2d                	push   $0x2d
  800560:	ff d6                	call   *%esi
				num = -(long long) num;
  800562:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800565:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800568:	f7 da                	neg    %edx
  80056a:	83 d1 00             	adc    $0x0,%ecx
  80056d:	f7 d9                	neg    %ecx
  80056f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
  800577:	e9 dd 00 00 00       	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	99                   	cltd   
  800585:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 40 04             	lea    0x4(%eax),%eax
  80058e:	89 45 14             	mov    %eax,0x14(%ebp)
  800591:	eb b4                	jmp    800547 <vprintfmt+0x295>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1e                	jg     8005b6 <vprintfmt+0x304>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 32                	je     8005ce <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b1:	e9 a3 00 00 00       	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8b 48 04             	mov    0x4(%eax),%ecx
  8005be:	8d 40 08             	lea    0x8(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c9:	e9 8b 00 00 00       	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	eb 74                	jmp    800659 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005e5:	83 f9 01             	cmp    $0x1,%ecx
  8005e8:	7f 1b                	jg     800605 <vprintfmt+0x353>
	else if (lflag)
  8005ea:	85 c9                	test   %ecx,%ecx
  8005ec:	74 2c                	je     80061a <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 10                	mov    (%eax),%edx
  8005f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fe:	b8 08 00 00 00       	mov    $0x8,%eax
  800603:	eb 54                	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 10                	mov    (%eax),%edx
  80060a:	8b 48 04             	mov    0x4(%eax),%ecx
  80060d:	8d 40 08             	lea    0x8(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800613:	b8 08 00 00 00       	mov    $0x8,%eax
  800618:	eb 3f                	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062a:	b8 08 00 00 00       	mov    $0x8,%eax
  80062f:	eb 28                	jmp    800659 <vprintfmt+0x3a7>
			putch('0', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 30                	push   $0x30
  800637:	ff d6                	call   *%esi
			putch('x', putdat);
  800639:	83 c4 08             	add    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 78                	push   $0x78
  80063f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 10                	mov    (%eax),%edx
  800646:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800654:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800660:	57                   	push   %edi
  800661:	ff 75 e0             	pushl  -0x20(%ebp)
  800664:	50                   	push   %eax
  800665:	51                   	push   %ecx
  800666:	52                   	push   %edx
  800667:	89 da                	mov    %ebx,%edx
  800669:	89 f0                	mov    %esi,%eax
  80066b:	e8 5a fb ff ff       	call   8001ca <printnum>
			break;
  800670:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800676:	e9 55 fc ff ff       	jmp    8002d0 <vprintfmt+0x1e>
	if (lflag >= 2)
  80067b:	83 f9 01             	cmp    $0x1,%ecx
  80067e:	7f 1b                	jg     80069b <vprintfmt+0x3e9>
	else if (lflag)
  800680:	85 c9                	test   %ecx,%ecx
  800682:	74 2c                	je     8006b0 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 10                	mov    (%eax),%edx
  800689:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068e:	8d 40 04             	lea    0x4(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800694:	b8 10 00 00 00       	mov    $0x10,%eax
  800699:	eb be                	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a3:	8d 40 08             	lea    0x8(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ae:	eb a9                	jmp    800659 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c5:	eb 92                	jmp    800659 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 25                	push   $0x25
  8006cd:	ff d6                	call   *%esi
			break;
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb 9f                	jmp    800673 <vprintfmt+0x3c1>
			putch('%', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 25                	push   $0x25
  8006da:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	89 f8                	mov    %edi,%eax
  8006e1:	eb 03                	jmp    8006e6 <vprintfmt+0x434>
  8006e3:	83 e8 01             	sub    $0x1,%eax
  8006e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ea:	75 f7                	jne    8006e3 <vprintfmt+0x431>
  8006ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ef:	eb 82                	jmp    800673 <vprintfmt+0x3c1>

008006f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	83 ec 18             	sub    $0x18,%esp
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800700:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800704:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800707:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 26                	je     800738 <vsnprintf+0x47>
  800712:	85 d2                	test   %edx,%edx
  800714:	7e 22                	jle    800738 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800716:	ff 75 14             	pushl  0x14(%ebp)
  800719:	ff 75 10             	pushl  0x10(%ebp)
  80071c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	68 78 02 80 00       	push   $0x800278
  800725:	e8 88 fb ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80072d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800733:	83 c4 10             	add    $0x10,%esp
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    
		return -E_INVAL;
  800738:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073d:	eb f7                	jmp    800736 <vsnprintf+0x45>

0080073f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800748:	50                   	push   %eax
  800749:	ff 75 10             	pushl  0x10(%ebp)
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	ff 75 08             	pushl  0x8(%ebp)
  800752:	e8 9a ff ff ff       	call   8006f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80075f:	b8 00 00 00 00       	mov    $0x0,%eax
  800764:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800768:	74 05                	je     80076f <strlen+0x16>
		n++;
  80076a:	83 c0 01             	add    $0x1,%eax
  80076d:	eb f5                	jmp    800764 <strlen+0xb>
	return n;
}
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800777:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077a:	ba 00 00 00 00       	mov    $0x0,%edx
  80077f:	39 c2                	cmp    %eax,%edx
  800781:	74 0d                	je     800790 <strnlen+0x1f>
  800783:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800787:	74 05                	je     80078e <strnlen+0x1d>
		n++;
  800789:	83 c2 01             	add    $0x1,%edx
  80078c:	eb f1                	jmp    80077f <strnlen+0xe>
  80078e:	89 d0                	mov    %edx,%eax
	return n;
}
  800790:	5d                   	pop    %ebp
  800791:	c3                   	ret    

00800792 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	53                   	push   %ebx
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007a5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007a8:	83 c2 01             	add    $0x1,%edx
  8007ab:	84 c9                	test   %cl,%cl
  8007ad:	75 f2                	jne    8007a1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007af:	5b                   	pop    %ebx
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	53                   	push   %ebx
  8007b6:	83 ec 10             	sub    $0x10,%esp
  8007b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007bc:	53                   	push   %ebx
  8007bd:	e8 97 ff ff ff       	call   800759 <strlen>
  8007c2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	01 d8                	add    %ebx,%eax
  8007ca:	50                   	push   %eax
  8007cb:	e8 c2 ff ff ff       	call   800792 <strcpy>
	return dst;
}
  8007d0:	89 d8                	mov    %ebx,%eax
  8007d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	56                   	push   %esi
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e2:	89 c6                	mov    %eax,%esi
  8007e4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e7:	89 c2                	mov    %eax,%edx
  8007e9:	39 f2                	cmp    %esi,%edx
  8007eb:	74 11                	je     8007fe <strncpy+0x27>
		*dst++ = *src;
  8007ed:	83 c2 01             	add    $0x1,%edx
  8007f0:	0f b6 19             	movzbl (%ecx),%ebx
  8007f3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f6:	80 fb 01             	cmp    $0x1,%bl
  8007f9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007fc:	eb eb                	jmp    8007e9 <strncpy+0x12>
	}
	return ret;
}
  8007fe:	5b                   	pop    %ebx
  8007ff:	5e                   	pop    %esi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	56                   	push   %esi
  800806:	53                   	push   %ebx
  800807:	8b 75 08             	mov    0x8(%ebp),%esi
  80080a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080d:	8b 55 10             	mov    0x10(%ebp),%edx
  800810:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800812:	85 d2                	test   %edx,%edx
  800814:	74 21                	je     800837 <strlcpy+0x35>
  800816:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80081a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80081c:	39 c2                	cmp    %eax,%edx
  80081e:	74 14                	je     800834 <strlcpy+0x32>
  800820:	0f b6 19             	movzbl (%ecx),%ebx
  800823:	84 db                	test   %bl,%bl
  800825:	74 0b                	je     800832 <strlcpy+0x30>
			*dst++ = *src++;
  800827:	83 c1 01             	add    $0x1,%ecx
  80082a:	83 c2 01             	add    $0x1,%edx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800830:	eb ea                	jmp    80081c <strlcpy+0x1a>
  800832:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800834:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800837:	29 f0                	sub    %esi,%eax
}
  800839:	5b                   	pop    %ebx
  80083a:	5e                   	pop    %esi
  80083b:	5d                   	pop    %ebp
  80083c:	c3                   	ret    

0080083d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800846:	0f b6 01             	movzbl (%ecx),%eax
  800849:	84 c0                	test   %al,%al
  80084b:	74 0c                	je     800859 <strcmp+0x1c>
  80084d:	3a 02                	cmp    (%edx),%al
  80084f:	75 08                	jne    800859 <strcmp+0x1c>
		p++, q++;
  800851:	83 c1 01             	add    $0x1,%ecx
  800854:	83 c2 01             	add    $0x1,%edx
  800857:	eb ed                	jmp    800846 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800859:	0f b6 c0             	movzbl %al,%eax
  80085c:	0f b6 12             	movzbl (%edx),%edx
  80085f:	29 d0                	sub    %edx,%eax
}
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	53                   	push   %ebx
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086d:	89 c3                	mov    %eax,%ebx
  80086f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800872:	eb 06                	jmp    80087a <strncmp+0x17>
		n--, p++, q++;
  800874:	83 c0 01             	add    $0x1,%eax
  800877:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80087a:	39 d8                	cmp    %ebx,%eax
  80087c:	74 16                	je     800894 <strncmp+0x31>
  80087e:	0f b6 08             	movzbl (%eax),%ecx
  800881:	84 c9                	test   %cl,%cl
  800883:	74 04                	je     800889 <strncmp+0x26>
  800885:	3a 0a                	cmp    (%edx),%cl
  800887:	74 eb                	je     800874 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800889:	0f b6 00             	movzbl (%eax),%eax
  80088c:	0f b6 12             	movzbl (%edx),%edx
  80088f:	29 d0                	sub    %edx,%eax
}
  800891:	5b                   	pop    %ebx
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    
		return 0;
  800894:	b8 00 00 00 00       	mov    $0x0,%eax
  800899:	eb f6                	jmp    800891 <strncmp+0x2e>

0080089b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a5:	0f b6 10             	movzbl (%eax),%edx
  8008a8:	84 d2                	test   %dl,%dl
  8008aa:	74 09                	je     8008b5 <strchr+0x1a>
		if (*s == c)
  8008ac:	38 ca                	cmp    %cl,%dl
  8008ae:	74 0a                	je     8008ba <strchr+0x1f>
	for (; *s; s++)
  8008b0:	83 c0 01             	add    $0x1,%eax
  8008b3:	eb f0                	jmp    8008a5 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008c9:	38 ca                	cmp    %cl,%dl
  8008cb:	74 09                	je     8008d6 <strfind+0x1a>
  8008cd:	84 d2                	test   %dl,%dl
  8008cf:	74 05                	je     8008d6 <strfind+0x1a>
	for (; *s; s++)
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	eb f0                	jmp    8008c6 <strfind+0xa>
			break;
	return (char *) s;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	57                   	push   %edi
  8008dc:	56                   	push   %esi
  8008dd:	53                   	push   %ebx
  8008de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e4:	85 c9                	test   %ecx,%ecx
  8008e6:	74 31                	je     800919 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e8:	89 f8                	mov    %edi,%eax
  8008ea:	09 c8                	or     %ecx,%eax
  8008ec:	a8 03                	test   $0x3,%al
  8008ee:	75 23                	jne    800913 <memset+0x3b>
		c &= 0xFF;
  8008f0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f4:	89 d3                	mov    %edx,%ebx
  8008f6:	c1 e3 08             	shl    $0x8,%ebx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	c1 e0 18             	shl    $0x18,%eax
  8008fe:	89 d6                	mov    %edx,%esi
  800900:	c1 e6 10             	shl    $0x10,%esi
  800903:	09 f0                	or     %esi,%eax
  800905:	09 c2                	or     %eax,%edx
  800907:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800909:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80090c:	89 d0                	mov    %edx,%eax
  80090e:	fc                   	cld    
  80090f:	f3 ab                	rep stos %eax,%es:(%edi)
  800911:	eb 06                	jmp    800919 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	fc                   	cld    
  800917:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800919:	89 f8                	mov    %edi,%eax
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5f                   	pop    %edi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	57                   	push   %edi
  800924:	56                   	push   %esi
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80092e:	39 c6                	cmp    %eax,%esi
  800930:	73 32                	jae    800964 <memmove+0x44>
  800932:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 2b                	jbe    800964 <memmove+0x44>
		s += n;
		d += n;
  800939:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093c:	89 fe                	mov    %edi,%esi
  80093e:	09 ce                	or     %ecx,%esi
  800940:	09 d6                	or     %edx,%esi
  800942:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800948:	75 0e                	jne    800958 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80094a:	83 ef 04             	sub    $0x4,%edi
  80094d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800950:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800953:	fd                   	std    
  800954:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800956:	eb 09                	jmp    800961 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800958:	83 ef 01             	sub    $0x1,%edi
  80095b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80095e:	fd                   	std    
  80095f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800961:	fc                   	cld    
  800962:	eb 1a                	jmp    80097e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800964:	89 c2                	mov    %eax,%edx
  800966:	09 ca                	or     %ecx,%edx
  800968:	09 f2                	or     %esi,%edx
  80096a:	f6 c2 03             	test   $0x3,%dl
  80096d:	75 0a                	jne    800979 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800972:	89 c7                	mov    %eax,%edi
  800974:	fc                   	cld    
  800975:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800977:	eb 05                	jmp    80097e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800979:	89 c7                	mov    %eax,%edi
  80097b:	fc                   	cld    
  80097c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800988:	ff 75 10             	pushl  0x10(%ebp)
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 8a ff ff ff       	call   800920 <memmove>
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	56                   	push   %esi
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a3:	89 c6                	mov    %eax,%esi
  8009a5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a8:	39 f0                	cmp    %esi,%eax
  8009aa:	74 1c                	je     8009c8 <memcmp+0x30>
		if (*s1 != *s2)
  8009ac:	0f b6 08             	movzbl (%eax),%ecx
  8009af:	0f b6 1a             	movzbl (%edx),%ebx
  8009b2:	38 d9                	cmp    %bl,%cl
  8009b4:	75 08                	jne    8009be <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	83 c2 01             	add    $0x1,%edx
  8009bc:	eb ea                	jmp    8009a8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009be:	0f b6 c1             	movzbl %cl,%eax
  8009c1:	0f b6 db             	movzbl %bl,%ebx
  8009c4:	29 d8                	sub    %ebx,%eax
  8009c6:	eb 05                	jmp    8009cd <memcmp+0x35>
	}

	return 0;
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009da:	89 c2                	mov    %eax,%edx
  8009dc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009df:	39 d0                	cmp    %edx,%eax
  8009e1:	73 09                	jae    8009ec <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e3:	38 08                	cmp    %cl,(%eax)
  8009e5:	74 05                	je     8009ec <memfind+0x1b>
	for (; s < ends; s++)
  8009e7:	83 c0 01             	add    $0x1,%eax
  8009ea:	eb f3                	jmp    8009df <memfind+0xe>
			break;
	return (void *) s;
}
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	57                   	push   %edi
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009fa:	eb 03                	jmp    8009ff <strtol+0x11>
		s++;
  8009fc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009ff:	0f b6 01             	movzbl (%ecx),%eax
  800a02:	3c 20                	cmp    $0x20,%al
  800a04:	74 f6                	je     8009fc <strtol+0xe>
  800a06:	3c 09                	cmp    $0x9,%al
  800a08:	74 f2                	je     8009fc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a0a:	3c 2b                	cmp    $0x2b,%al
  800a0c:	74 2a                	je     800a38 <strtol+0x4a>
	int neg = 0;
  800a0e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a13:	3c 2d                	cmp    $0x2d,%al
  800a15:	74 2b                	je     800a42 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a17:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a1d:	75 0f                	jne    800a2e <strtol+0x40>
  800a1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a22:	74 28                	je     800a4c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a24:	85 db                	test   %ebx,%ebx
  800a26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2b:	0f 44 d8             	cmove  %eax,%ebx
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a36:	eb 50                	jmp    800a88 <strtol+0x9a>
		s++;
  800a38:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a40:	eb d5                	jmp    800a17 <strtol+0x29>
		s++, neg = 1;
  800a42:	83 c1 01             	add    $0x1,%ecx
  800a45:	bf 01 00 00 00       	mov    $0x1,%edi
  800a4a:	eb cb                	jmp    800a17 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a50:	74 0e                	je     800a60 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	75 d8                	jne    800a2e <strtol+0x40>
		s++, base = 8;
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a5e:	eb ce                	jmp    800a2e <strtol+0x40>
		s += 2, base = 16;
  800a60:	83 c1 02             	add    $0x2,%ecx
  800a63:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a68:	eb c4                	jmp    800a2e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a6a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a6d:	89 f3                	mov    %esi,%ebx
  800a6f:	80 fb 19             	cmp    $0x19,%bl
  800a72:	77 29                	ja     800a9d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a74:	0f be d2             	movsbl %dl,%edx
  800a77:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a7a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7d:	7d 30                	jge    800aaf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a7f:	83 c1 01             	add    $0x1,%ecx
  800a82:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a86:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a88:	0f b6 11             	movzbl (%ecx),%edx
  800a8b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8e:	89 f3                	mov    %esi,%ebx
  800a90:	80 fb 09             	cmp    $0x9,%bl
  800a93:	77 d5                	ja     800a6a <strtol+0x7c>
			dig = *s - '0';
  800a95:	0f be d2             	movsbl %dl,%edx
  800a98:	83 ea 30             	sub    $0x30,%edx
  800a9b:	eb dd                	jmp    800a7a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a9d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa0:	89 f3                	mov    %esi,%ebx
  800aa2:	80 fb 19             	cmp    $0x19,%bl
  800aa5:	77 08                	ja     800aaf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800aa7:	0f be d2             	movsbl %dl,%edx
  800aaa:	83 ea 37             	sub    $0x37,%edx
  800aad:	eb cb                	jmp    800a7a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aaf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab3:	74 05                	je     800aba <strtol+0xcc>
		*endptr = (char *) s;
  800ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aba:	89 c2                	mov    %eax,%edx
  800abc:	f7 da                	neg    %edx
  800abe:	85 ff                	test   %edi,%edi
  800ac0:	0f 45 c2             	cmovne %edx,%eax
}
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5f                   	pop    %edi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad9:	89 c3                	mov    %eax,%ebx
  800adb:	89 c7                	mov    %eax,%edi
  800add:	89 c6                	mov    %eax,%esi
  800adf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	57                   	push   %edi
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	b8 01 00 00 00       	mov    $0x1,%eax
  800af6:	89 d1                	mov    %edx,%ecx
  800af8:	89 d3                	mov    %edx,%ebx
  800afa:	89 d7                	mov    %edx,%edi
  800afc:	89 d6                	mov    %edx,%esi
  800afe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b13:	8b 55 08             	mov    0x8(%ebp),%edx
  800b16:	b8 03 00 00 00       	mov    $0x3,%eax
  800b1b:	89 cb                	mov    %ecx,%ebx
  800b1d:	89 cf                	mov    %ecx,%edi
  800b1f:	89 ce                	mov    %ecx,%esi
  800b21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b23:	85 c0                	test   %eax,%eax
  800b25:	7f 08                	jg     800b2f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b2f:	83 ec 0c             	sub    $0xc,%esp
  800b32:	50                   	push   %eax
  800b33:	6a 03                	push   $0x3
  800b35:	68 1f 2c 80 00       	push   $0x802c1f
  800b3a:	6a 23                	push   $0x23
  800b3c:	68 3c 2c 80 00       	push   $0x802c3c
  800b41:	e8 95 f5 ff ff       	call   8000db <_panic>

00800b46 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b51:	b8 02 00 00 00       	mov    $0x2,%eax
  800b56:	89 d1                	mov    %edx,%ecx
  800b58:	89 d3                	mov    %edx,%ebx
  800b5a:	89 d7                	mov    %edx,%edi
  800b5c:	89 d6                	mov    %edx,%esi
  800b5e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <sys_yield>:

void
sys_yield(void)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	57                   	push   %edi
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b75:	89 d1                	mov    %edx,%ecx
  800b77:	89 d3                	mov    %edx,%ebx
  800b79:	89 d7                	mov    %edx,%edi
  800b7b:	89 d6                	mov    %edx,%esi
  800b7d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8d:	be 00 00 00 00       	mov    $0x0,%esi
  800b92:	8b 55 08             	mov    0x8(%ebp),%edx
  800b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b98:	b8 04 00 00 00       	mov    $0x4,%eax
  800b9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba0:	89 f7                	mov    %esi,%edi
  800ba2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	7f 08                	jg     800bb0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb0:	83 ec 0c             	sub    $0xc,%esp
  800bb3:	50                   	push   %eax
  800bb4:	6a 04                	push   $0x4
  800bb6:	68 1f 2c 80 00       	push   $0x802c1f
  800bbb:	6a 23                	push   $0x23
  800bbd:	68 3c 2c 80 00       	push   $0x802c3c
  800bc2:	e8 14 f5 ff ff       	call   8000db <_panic>

00800bc7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	57                   	push   %edi
  800bcb:	56                   	push   %esi
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd6:	b8 05 00 00 00       	mov    $0x5,%eax
  800bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bde:	8b 7d 14             	mov    0x14(%ebp),%edi
  800be1:	8b 75 18             	mov    0x18(%ebp),%esi
  800be4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	7f 08                	jg     800bf2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800bf6:	6a 05                	push   $0x5
  800bf8:	68 1f 2c 80 00       	push   $0x802c1f
  800bfd:	6a 23                	push   $0x23
  800bff:	68 3c 2c 80 00       	push   $0x802c3c
  800c04:	e8 d2 f4 ff ff       	call   8000db <_panic>

00800c09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c17:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c22:	89 df                	mov    %ebx,%edi
  800c24:	89 de                	mov    %ebx,%esi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800c38:	6a 06                	push   $0x6
  800c3a:	68 1f 2c 80 00       	push   $0x802c1f
  800c3f:	6a 23                	push   $0x23
  800c41:	68 3c 2c 80 00       	push   $0x802c3c
  800c46:	e8 90 f4 ff ff       	call   8000db <_panic>

00800c4b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800c5f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c64:	89 df                	mov    %ebx,%edi
  800c66:	89 de                	mov    %ebx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800c7a:	6a 08                	push   $0x8
  800c7c:	68 1f 2c 80 00       	push   $0x802c1f
  800c81:	6a 23                	push   $0x23
  800c83:	68 3c 2c 80 00       	push   $0x802c3c
  800c88:	e8 4e f4 ff ff       	call   8000db <_panic>

00800c8d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800ca1:	b8 09 00 00 00       	mov    $0x9,%eax
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7f 08                	jg     800cb8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800cbc:	6a 09                	push   $0x9
  800cbe:	68 1f 2c 80 00       	push   $0x802c1f
  800cc3:	6a 23                	push   $0x23
  800cc5:	68 3c 2c 80 00       	push   $0x802c3c
  800cca:	e8 0c f4 ff ff       	call   8000db <_panic>

00800ccf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800ce3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce8:	89 df                	mov    %ebx,%edi
  800cea:	89 de                	mov    %ebx,%esi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800cfe:	6a 0a                	push   $0xa
  800d00:	68 1f 2c 80 00       	push   $0x802c1f
  800d05:	6a 23                	push   $0x23
  800d07:	68 3c 2c 80 00       	push   $0x802c3c
  800d0c:	e8 ca f3 ff ff       	call   8000db <_panic>

00800d11 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d22:	be 00 00 00 00       	mov    $0x0,%esi
  800d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d4a:	89 cb                	mov    %ecx,%ebx
  800d4c:	89 cf                	mov    %ecx,%edi
  800d4e:	89 ce                	mov    %ecx,%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 0d                	push   $0xd
  800d64:	68 1f 2c 80 00       	push   $0x802c1f
  800d69:	6a 23                	push   $0x23
  800d6b:	68 3c 2c 80 00       	push   $0x802c3c
  800d70:	e8 66 f3 ff ff       	call   8000db <_panic>

00800d75 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	05 00 00 00 30       	add    $0x30000000,%eax
  800d9f:	c1 e8 0c             	shr    $0xc,%eax
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800daf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dc3:	89 c2                	mov    %eax,%edx
  800dc5:	c1 ea 16             	shr    $0x16,%edx
  800dc8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dcf:	f6 c2 01             	test   $0x1,%dl
  800dd2:	74 2d                	je     800e01 <fd_alloc+0x46>
  800dd4:	89 c2                	mov    %eax,%edx
  800dd6:	c1 ea 0c             	shr    $0xc,%edx
  800dd9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800de0:	f6 c2 01             	test   $0x1,%dl
  800de3:	74 1c                	je     800e01 <fd_alloc+0x46>
  800de5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dea:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800def:	75 d2                	jne    800dc3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800dfa:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dff:	eb 0a                	jmp    800e0b <fd_alloc+0x50>
			*fd_store = fd;
  800e01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e04:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e13:	83 f8 1f             	cmp    $0x1f,%eax
  800e16:	77 30                	ja     800e48 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e18:	c1 e0 0c             	shl    $0xc,%eax
  800e1b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e20:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e26:	f6 c2 01             	test   $0x1,%dl
  800e29:	74 24                	je     800e4f <fd_lookup+0x42>
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	c1 ea 0c             	shr    $0xc,%edx
  800e30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e37:	f6 c2 01             	test   $0x1,%dl
  800e3a:	74 1a                	je     800e56 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	89 02                	mov    %eax,(%edx)
	return 0;
  800e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		return -E_INVAL;
  800e48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4d:	eb f7                	jmp    800e46 <fd_lookup+0x39>
		return -E_INVAL;
  800e4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e54:	eb f0                	jmp    800e46 <fd_lookup+0x39>
  800e56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e5b:	eb e9                	jmp    800e46 <fd_lookup+0x39>

00800e5d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800e66:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e70:	39 08                	cmp    %ecx,(%eax)
  800e72:	74 38                	je     800eac <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e74:	83 c2 01             	add    $0x1,%edx
  800e77:	8b 04 95 c8 2c 80 00 	mov    0x802cc8(,%edx,4),%eax
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	75 ee                	jne    800e70 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e82:	a1 08 40 80 00       	mov    0x804008,%eax
  800e87:	8b 40 48             	mov    0x48(%eax),%eax
  800e8a:	83 ec 04             	sub    $0x4,%esp
  800e8d:	51                   	push   %ecx
  800e8e:	50                   	push   %eax
  800e8f:	68 4c 2c 80 00       	push   $0x802c4c
  800e94:	e8 1d f3 ff ff       	call   8001b6 <cprintf>
	*dev = 0;
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    
			*dev = devtab[i];
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb6:	eb f2                	jmp    800eaa <dev_lookup+0x4d>

00800eb8 <fd_close>:
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 24             	sub    $0x24,%esp
  800ec1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ec4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ec7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eca:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ecb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ed1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ed4:	50                   	push   %eax
  800ed5:	e8 33 ff ff ff       	call   800e0d <fd_lookup>
  800eda:	89 c3                	mov    %eax,%ebx
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 05                	js     800ee8 <fd_close+0x30>
	    || fd != fd2)
  800ee3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ee6:	74 16                	je     800efe <fd_close+0x46>
		return (must_exist ? r : 0);
  800ee8:	89 f8                	mov    %edi,%eax
  800eea:	84 c0                	test   %al,%al
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef1:	0f 44 d8             	cmove  %eax,%ebx
}
  800ef4:	89 d8                	mov    %ebx,%eax
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f04:	50                   	push   %eax
  800f05:	ff 36                	pushl  (%esi)
  800f07:	e8 51 ff ff ff       	call   800e5d <dev_lookup>
  800f0c:	89 c3                	mov    %eax,%ebx
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	85 c0                	test   %eax,%eax
  800f13:	78 1a                	js     800f2f <fd_close+0x77>
		if (dev->dev_close)
  800f15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f18:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f1b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	74 0b                	je     800f2f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	56                   	push   %esi
  800f28:	ff d0                	call   *%eax
  800f2a:	89 c3                	mov    %eax,%ebx
  800f2c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	56                   	push   %esi
  800f33:	6a 00                	push   $0x0
  800f35:	e8 cf fc ff ff       	call   800c09 <sys_page_unmap>
	return r;
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	eb b5                	jmp    800ef4 <fd_close+0x3c>

00800f3f <close>:

int
close(int fdnum)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f48:	50                   	push   %eax
  800f49:	ff 75 08             	pushl  0x8(%ebp)
  800f4c:	e8 bc fe ff ff       	call   800e0d <fd_lookup>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	79 02                	jns    800f5a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    
		return fd_close(fd, 1);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	6a 01                	push   $0x1
  800f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f62:	e8 51 ff ff ff       	call   800eb8 <fd_close>
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb ec                	jmp    800f58 <close+0x19>

00800f6c <close_all>:

void
close_all(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	53                   	push   %ebx
  800f7c:	e8 be ff ff ff       	call   800f3f <close>
	for (i = 0; i < MAXFD; i++)
  800f81:	83 c3 01             	add    $0x1,%ebx
  800f84:	83 c4 10             	add    $0x10,%esp
  800f87:	83 fb 20             	cmp    $0x20,%ebx
  800f8a:	75 ec                	jne    800f78 <close_all+0xc>
}
  800f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f9d:	50                   	push   %eax
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 67 fe ff ff       	call   800e0d <fd_lookup>
  800fa6:	89 c3                	mov    %eax,%ebx
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	0f 88 81 00 00 00    	js     801034 <dup+0xa3>
		return r;
	close(newfdnum);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	e8 81 ff ff ff       	call   800f3f <close>

	newfd = INDEX2FD(newfdnum);
  800fbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fc1:	c1 e6 0c             	shl    $0xc,%esi
  800fc4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fca:	83 c4 04             	add    $0x4,%esp
  800fcd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd0:	e8 cf fd ff ff       	call   800da4 <fd2data>
  800fd5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fd7:	89 34 24             	mov    %esi,(%esp)
  800fda:	e8 c5 fd ff ff       	call   800da4 <fd2data>
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fe4:	89 d8                	mov    %ebx,%eax
  800fe6:	c1 e8 16             	shr    $0x16,%eax
  800fe9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ff0:	a8 01                	test   $0x1,%al
  800ff2:	74 11                	je     801005 <dup+0x74>
  800ff4:	89 d8                	mov    %ebx,%eax
  800ff6:	c1 e8 0c             	shr    $0xc,%eax
  800ff9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801000:	f6 c2 01             	test   $0x1,%dl
  801003:	75 39                	jne    80103e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801005:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801008:	89 d0                	mov    %edx,%eax
  80100a:	c1 e8 0c             	shr    $0xc,%eax
  80100d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	25 07 0e 00 00       	and    $0xe07,%eax
  80101c:	50                   	push   %eax
  80101d:	56                   	push   %esi
  80101e:	6a 00                	push   $0x0
  801020:	52                   	push   %edx
  801021:	6a 00                	push   $0x0
  801023:	e8 9f fb ff ff       	call   800bc7 <sys_page_map>
  801028:	89 c3                	mov    %eax,%ebx
  80102a:	83 c4 20             	add    $0x20,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 31                	js     801062 <dup+0xd1>
		goto err;

	return newfdnum;
  801031:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801034:	89 d8                	mov    %ebx,%eax
  801036:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80103e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801045:	83 ec 0c             	sub    $0xc,%esp
  801048:	25 07 0e 00 00       	and    $0xe07,%eax
  80104d:	50                   	push   %eax
  80104e:	57                   	push   %edi
  80104f:	6a 00                	push   $0x0
  801051:	53                   	push   %ebx
  801052:	6a 00                	push   $0x0
  801054:	e8 6e fb ff ff       	call   800bc7 <sys_page_map>
  801059:	89 c3                	mov    %eax,%ebx
  80105b:	83 c4 20             	add    $0x20,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	79 a3                	jns    801005 <dup+0x74>
	sys_page_unmap(0, newfd);
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	e8 9c fb ff ff       	call   800c09 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80106d:	83 c4 08             	add    $0x8,%esp
  801070:	57                   	push   %edi
  801071:	6a 00                	push   $0x0
  801073:	e8 91 fb ff ff       	call   800c09 <sys_page_unmap>
	return r;
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	eb b7                	jmp    801034 <dup+0xa3>

0080107d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	53                   	push   %ebx
  801081:	83 ec 1c             	sub    $0x1c,%esp
  801084:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801087:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80108a:	50                   	push   %eax
  80108b:	53                   	push   %ebx
  80108c:	e8 7c fd ff ff       	call   800e0d <fd_lookup>
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	78 3f                	js     8010d7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801098:	83 ec 08             	sub    $0x8,%esp
  80109b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80109e:	50                   	push   %eax
  80109f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a2:	ff 30                	pushl  (%eax)
  8010a4:	e8 b4 fd ff ff       	call   800e5d <dev_lookup>
  8010a9:	83 c4 10             	add    $0x10,%esp
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	78 27                	js     8010d7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010b3:	8b 42 08             	mov    0x8(%edx),%eax
  8010b6:	83 e0 03             	and    $0x3,%eax
  8010b9:	83 f8 01             	cmp    $0x1,%eax
  8010bc:	74 1e                	je     8010dc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c1:	8b 40 08             	mov    0x8(%eax),%eax
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	74 35                	je     8010fd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	ff 75 10             	pushl  0x10(%ebp)
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	52                   	push   %edx
  8010d2:	ff d0                	call   *%eax
  8010d4:	83 c4 10             	add    $0x10,%esp
}
  8010d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8010e1:	8b 40 48             	mov    0x48(%eax),%eax
  8010e4:	83 ec 04             	sub    $0x4,%esp
  8010e7:	53                   	push   %ebx
  8010e8:	50                   	push   %eax
  8010e9:	68 8d 2c 80 00       	push   $0x802c8d
  8010ee:	e8 c3 f0 ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fb:	eb da                	jmp    8010d7 <read+0x5a>
		return -E_NOT_SUPP;
  8010fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801102:	eb d3                	jmp    8010d7 <read+0x5a>

00801104 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	57                   	push   %edi
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801110:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801113:	bb 00 00 00 00       	mov    $0x0,%ebx
  801118:	39 f3                	cmp    %esi,%ebx
  80111a:	73 23                	jae    80113f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	89 f0                	mov    %esi,%eax
  801121:	29 d8                	sub    %ebx,%eax
  801123:	50                   	push   %eax
  801124:	89 d8                	mov    %ebx,%eax
  801126:	03 45 0c             	add    0xc(%ebp),%eax
  801129:	50                   	push   %eax
  80112a:	57                   	push   %edi
  80112b:	e8 4d ff ff ff       	call   80107d <read>
		if (m < 0)
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 06                	js     80113d <readn+0x39>
			return m;
		if (m == 0)
  801137:	74 06                	je     80113f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801139:	01 c3                	add    %eax,%ebx
  80113b:	eb db                	jmp    801118 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80113d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80113f:	89 d8                	mov    %ebx,%eax
  801141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	53                   	push   %ebx
  80114d:	83 ec 1c             	sub    $0x1c,%esp
  801150:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801153:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	53                   	push   %ebx
  801158:	e8 b0 fc ff ff       	call   800e0d <fd_lookup>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 3a                	js     80119e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116a:	50                   	push   %eax
  80116b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116e:	ff 30                	pushl  (%eax)
  801170:	e8 e8 fc ff ff       	call   800e5d <dev_lookup>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 22                	js     80119e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80117c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801183:	74 1e                	je     8011a3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801188:	8b 52 0c             	mov    0xc(%edx),%edx
  80118b:	85 d2                	test   %edx,%edx
  80118d:	74 35                	je     8011c4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80118f:	83 ec 04             	sub    $0x4,%esp
  801192:	ff 75 10             	pushl  0x10(%ebp)
  801195:	ff 75 0c             	pushl  0xc(%ebp)
  801198:	50                   	push   %eax
  801199:	ff d2                	call   *%edx
  80119b:	83 c4 10             	add    $0x10,%esp
}
  80119e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8011a8:	8b 40 48             	mov    0x48(%eax),%eax
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	53                   	push   %ebx
  8011af:	50                   	push   %eax
  8011b0:	68 a9 2c 80 00       	push   $0x802ca9
  8011b5:	e8 fc ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c2:	eb da                	jmp    80119e <write+0x55>
		return -E_NOT_SUPP;
  8011c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c9:	eb d3                	jmp    80119e <write+0x55>

008011cb <seek>:

int
seek(int fdnum, off_t offset)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d4:	50                   	push   %eax
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 30 fc ff ff       	call   800e0d <fd_lookup>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 0e                	js     8011f2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ea:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	53                   	push   %ebx
  8011f8:	83 ec 1c             	sub    $0x1c,%esp
  8011fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801201:	50                   	push   %eax
  801202:	53                   	push   %ebx
  801203:	e8 05 fc ff ff       	call   800e0d <fd_lookup>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	78 37                	js     801246 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801219:	ff 30                	pushl  (%eax)
  80121b:	e8 3d fc ff ff       	call   800e5d <dev_lookup>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	78 1f                	js     801246 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80122e:	74 1b                	je     80124b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801233:	8b 52 18             	mov    0x18(%edx),%edx
  801236:	85 d2                	test   %edx,%edx
  801238:	74 32                	je     80126c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80123a:	83 ec 08             	sub    $0x8,%esp
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	50                   	push   %eax
  801241:	ff d2                	call   *%edx
  801243:	83 c4 10             	add    $0x10,%esp
}
  801246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801249:	c9                   	leave  
  80124a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80124b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801250:	8b 40 48             	mov    0x48(%eax),%eax
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	53                   	push   %ebx
  801257:	50                   	push   %eax
  801258:	68 6c 2c 80 00       	push   $0x802c6c
  80125d:	e8 54 ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126a:	eb da                	jmp    801246 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80126c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801271:	eb d3                	jmp    801246 <ftruncate+0x52>

00801273 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	53                   	push   %ebx
  801277:	83 ec 1c             	sub    $0x1c,%esp
  80127a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 84 fb ff ff       	call   800e0d <fd_lookup>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 4b                	js     8012db <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801290:	83 ec 08             	sub    $0x8,%esp
  801293:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801296:	50                   	push   %eax
  801297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129a:	ff 30                	pushl  (%eax)
  80129c:	e8 bc fb ff ff       	call   800e5d <dev_lookup>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 33                	js     8012db <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ab:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012af:	74 2f                	je     8012e0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012b1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012b4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012bb:	00 00 00 
	stat->st_isdir = 0;
  8012be:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012c5:	00 00 00 
	stat->st_dev = dev;
  8012c8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	53                   	push   %ebx
  8012d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8012d5:	ff 50 14             	call   *0x14(%eax)
  8012d8:	83 c4 10             	add    $0x10,%esp
}
  8012db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    
		return -E_NOT_SUPP;
  8012e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e5:	eb f4                	jmp    8012db <fstat+0x68>

008012e7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	56                   	push   %esi
  8012eb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	6a 00                	push   $0x0
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	e8 2f 02 00 00       	call   801528 <open>
  8012f9:	89 c3                	mov    %eax,%ebx
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 1b                	js     80131d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	50                   	push   %eax
  801309:	e8 65 ff ff ff       	call   801273 <fstat>
  80130e:	89 c6                	mov    %eax,%esi
	close(fd);
  801310:	89 1c 24             	mov    %ebx,(%esp)
  801313:	e8 27 fc ff ff       	call   800f3f <close>
	return r;
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	89 f3                	mov    %esi,%ebx
}
  80131d:	89 d8                	mov    %ebx,%eax
  80131f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801322:	5b                   	pop    %ebx
  801323:	5e                   	pop    %esi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	89 c6                	mov    %eax,%esi
  80132d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80132f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801336:	74 27                	je     80135f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801338:	6a 07                	push   $0x7
  80133a:	68 00 50 80 00       	push   $0x805000
  80133f:	56                   	push   %esi
  801340:	ff 35 00 40 80 00    	pushl  0x804000
  801346:	e8 1e 12 00 00       	call   802569 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80134b:	83 c4 0c             	add    $0xc,%esp
  80134e:	6a 00                	push   $0x0
  801350:	53                   	push   %ebx
  801351:	6a 00                	push   $0x0
  801353:	e8 9e 11 00 00       	call   8024f6 <ipc_recv>
}
  801358:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5e                   	pop    %esi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80135f:	83 ec 0c             	sub    $0xc,%esp
  801362:	6a 01                	push   $0x1
  801364:	e8 6c 12 00 00       	call   8025d5 <ipc_find_env>
  801369:	a3 00 40 80 00       	mov    %eax,0x804000
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	eb c5                	jmp    801338 <fsipc+0x12>

00801373 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 40 0c             	mov    0xc(%eax),%eax
  80137f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80138c:	ba 00 00 00 00       	mov    $0x0,%edx
  801391:	b8 02 00 00 00       	mov    $0x2,%eax
  801396:	e8 8b ff ff ff       	call   801326 <fsipc>
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <devfile_flush>:
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	b8 06 00 00 00       	mov    $0x6,%eax
  8013b8:	e8 69 ff ff ff       	call   801326 <fsipc>
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <devfile_stat>:
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	53                   	push   %ebx
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8013cf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8013de:	e8 43 ff ff ff       	call   801326 <fsipc>
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 2c                	js     801413 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	68 00 50 80 00       	push   $0x805000
  8013ef:	53                   	push   %ebx
  8013f0:	e8 9d f3 ff ff       	call   800792 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013f5:	a1 80 50 80 00       	mov    0x805080,%eax
  8013fa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801400:	a1 84 50 80 00       	mov    0x805084,%eax
  801405:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <devfile_write>:
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801422:	85 db                	test   %ebx,%ebx
  801424:	75 07                	jne    80142d <devfile_write+0x15>
	return n_all;
  801426:	89 d8                	mov    %ebx,%eax
}
  801428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8b 40 0c             	mov    0xc(%eax),%eax
  801433:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801438:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	53                   	push   %ebx
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	68 08 50 80 00       	push   $0x805008
  80144a:	e8 d1 f4 ff ff       	call   800920 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 04 00 00 00       	mov    $0x4,%eax
  801459:	e8 c8 fe ff ff       	call   801326 <fsipc>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	85 c0                	test   %eax,%eax
  801463:	78 c3                	js     801428 <devfile_write+0x10>
	  assert(r <= n_left);
  801465:	39 d8                	cmp    %ebx,%eax
  801467:	77 0b                	ja     801474 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801469:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80146e:	7f 1d                	jg     80148d <devfile_write+0x75>
    n_all += r;
  801470:	89 c3                	mov    %eax,%ebx
  801472:	eb b2                	jmp    801426 <devfile_write+0xe>
	  assert(r <= n_left);
  801474:	68 dc 2c 80 00       	push   $0x802cdc
  801479:	68 e8 2c 80 00       	push   $0x802ce8
  80147e:	68 9f 00 00 00       	push   $0x9f
  801483:	68 fd 2c 80 00       	push   $0x802cfd
  801488:	e8 4e ec ff ff       	call   8000db <_panic>
	  assert(r <= PGSIZE);
  80148d:	68 08 2d 80 00       	push   $0x802d08
  801492:	68 e8 2c 80 00       	push   $0x802ce8
  801497:	68 a0 00 00 00       	push   $0xa0
  80149c:	68 fd 2c 80 00       	push   $0x802cfd
  8014a1:	e8 35 ec ff ff       	call   8000db <_panic>

008014a6 <devfile_read>:
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
  8014ab:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014b9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8014c9:	e8 58 fe ff ff       	call   801326 <fsipc>
  8014ce:	89 c3                	mov    %eax,%ebx
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 1f                	js     8014f3 <devfile_read+0x4d>
	assert(r <= n);
  8014d4:	39 f0                	cmp    %esi,%eax
  8014d6:	77 24                	ja     8014fc <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014dd:	7f 33                	jg     801512 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	50                   	push   %eax
  8014e3:	68 00 50 80 00       	push   $0x805000
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	e8 30 f4 ff ff       	call   800920 <memmove>
	return r;
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	89 d8                	mov    %ebx,%eax
  8014f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f8:	5b                   	pop    %ebx
  8014f9:	5e                   	pop    %esi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    
	assert(r <= n);
  8014fc:	68 14 2d 80 00       	push   $0x802d14
  801501:	68 e8 2c 80 00       	push   $0x802ce8
  801506:	6a 7c                	push   $0x7c
  801508:	68 fd 2c 80 00       	push   $0x802cfd
  80150d:	e8 c9 eb ff ff       	call   8000db <_panic>
	assert(r <= PGSIZE);
  801512:	68 08 2d 80 00       	push   $0x802d08
  801517:	68 e8 2c 80 00       	push   $0x802ce8
  80151c:	6a 7d                	push   $0x7d
  80151e:	68 fd 2c 80 00       	push   $0x802cfd
  801523:	e8 b3 eb ff ff       	call   8000db <_panic>

00801528 <open>:
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
  80152d:	83 ec 1c             	sub    $0x1c,%esp
  801530:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801533:	56                   	push   %esi
  801534:	e8 20 f2 ff ff       	call   800759 <strlen>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801541:	7f 6c                	jg     8015af <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	e8 6c f8 ff ff       	call   800dbb <fd_alloc>
  80154f:	89 c3                	mov    %eax,%ebx
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 3c                	js     801594 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	56                   	push   %esi
  80155c:	68 00 50 80 00       	push   $0x805000
  801561:	e8 2c f2 ff ff       	call   800792 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80156e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801571:	b8 01 00 00 00       	mov    $0x1,%eax
  801576:	e8 ab fd ff ff       	call   801326 <fsipc>
  80157b:	89 c3                	mov    %eax,%ebx
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 19                	js     80159d <open+0x75>
	return fd2num(fd);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	ff 75 f4             	pushl  -0xc(%ebp)
  80158a:	e8 05 f8 ff ff       	call   800d94 <fd2num>
  80158f:	89 c3                	mov    %eax,%ebx
  801591:	83 c4 10             	add    $0x10,%esp
}
  801594:	89 d8                	mov    %ebx,%eax
  801596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
		fd_close(fd, 0);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	6a 00                	push   $0x0
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	e8 0e f9 ff ff       	call   800eb8 <fd_close>
		return r;
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	eb e5                	jmp    801594 <open+0x6c>
		return -E_BAD_PATH;
  8015af:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015b4:	eb de                	jmp    801594 <open+0x6c>

008015b6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8015c6:	e8 5b fd ff ff       	call   801326 <fsipc>
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	57                   	push   %edi
  8015d1:	56                   	push   %esi
  8015d2:	53                   	push   %ebx
  8015d3:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  8015d9:	e8 68 f5 ff ff       	call   800b46 <sys_getenvid>
  8015de:	83 ec 08             	sub    $0x8,%esp
  8015e1:	50                   	push   %eax
  8015e2:	68 1b 2d 80 00       	push   $0x802d1b
  8015e7:	e8 ca eb ff ff       	call   8001b6 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8015ec:	83 c4 08             	add    $0x8,%esp
  8015ef:	6a 00                	push   $0x0
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	e8 2f ff ff ff       	call   801528 <open>
  8015f9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	0f 88 fb 04 00 00    	js     801b05 <spawn+0x538>
  80160a:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 00 02 00 00       	push   $0x200
  801614:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	52                   	push   %edx
  80161c:	e8 e3 fa ff ff       	call   801104 <readn>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	3d 00 02 00 00       	cmp    $0x200,%eax
  801629:	75 71                	jne    80169c <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  80162b:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801632:	45 4c 46 
  801635:	75 65                	jne    80169c <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801637:	b8 07 00 00 00       	mov    $0x7,%eax
  80163c:	cd 30                	int    $0x30
  80163e:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801644:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80164a:	89 c6                	mov    %eax,%esi
  80164c:	85 c0                	test   %eax,%eax
  80164e:	0f 88 a5 04 00 00    	js     801af9 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	50                   	push   %eax
  801658:	68 4f 2d 80 00       	push   $0x802d4f
  80165d:	e8 54 eb ff ff       	call   8001b6 <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801662:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801668:	6b f6 7c             	imul   $0x7c,%esi,%esi
  80166b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801671:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801677:	b9 11 00 00 00       	mov    $0x11,%ecx
  80167c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80167e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801684:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  80168a:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80168d:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801692:	be 00 00 00 00       	mov    $0x0,%esi
  801697:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80169a:	eb 4b                	jmp    8016e7 <spawn+0x11a>
		close(fd);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8016a5:	e8 95 f8 ff ff       	call   800f3f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8016aa:	83 c4 0c             	add    $0xc,%esp
  8016ad:	68 7f 45 4c 46       	push   $0x464c457f
  8016b2:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8016b8:	68 35 2d 80 00       	push   $0x802d35
  8016bd:	e8 f4 ea ff ff       	call   8001b6 <cprintf>
		return -E_NOT_EXEC;
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8016cc:	ff ff ff 
  8016cf:	e9 31 04 00 00       	jmp    801b05 <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	50                   	push   %eax
  8016d8:	e8 7c f0 ff ff       	call   800759 <strlen>
  8016dd:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8016e1:	83 c3 01             	add    $0x1,%ebx
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8016ee:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	75 df                	jne    8016d4 <spawn+0x107>
  8016f5:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8016fb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801701:	bf 00 10 40 00       	mov    $0x401000,%edi
  801706:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801708:	89 fa                	mov    %edi,%edx
  80170a:	83 e2 fc             	and    $0xfffffffc,%edx
  80170d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801714:	29 c2                	sub    %eax,%edx
  801716:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80171c:	8d 42 f8             	lea    -0x8(%edx),%eax
  80171f:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801724:	0f 86 fe 03 00 00    	jbe    801b28 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	6a 07                	push   $0x7
  80172f:	68 00 00 40 00       	push   $0x400000
  801734:	6a 00                	push   $0x0
  801736:	e8 49 f4 ff ff       	call   800b84 <sys_page_alloc>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	0f 88 e7 03 00 00    	js     801b2d <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801746:	be 00 00 00 00       	mov    $0x0,%esi
  80174b:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801751:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801754:	eb 30                	jmp    801786 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801756:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80175c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801762:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801765:	83 ec 08             	sub    $0x8,%esp
  801768:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80176b:	57                   	push   %edi
  80176c:	e8 21 f0 ff ff       	call   800792 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801771:	83 c4 04             	add    $0x4,%esp
  801774:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801777:	e8 dd ef ff ff       	call   800759 <strlen>
  80177c:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801780:	83 c6 01             	add    $0x1,%esi
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80178c:	7f c8                	jg     801756 <spawn+0x189>
	}
	argv_store[argc] = 0;
  80178e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801794:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80179a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8017a1:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8017a7:	0f 85 86 00 00 00    	jne    801833 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8017ad:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8017b3:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8017b9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8017bc:	89 c8                	mov    %ecx,%eax
  8017be:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  8017c4:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8017c7:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8017cc:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8017d2:	83 ec 0c             	sub    $0xc,%esp
  8017d5:	6a 07                	push   $0x7
  8017d7:	68 00 d0 bf ee       	push   $0xeebfd000
  8017dc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8017e2:	68 00 00 40 00       	push   $0x400000
  8017e7:	6a 00                	push   $0x0
  8017e9:	e8 d9 f3 ff ff       	call   800bc7 <sys_page_map>
  8017ee:	89 c3                	mov    %eax,%ebx
  8017f0:	83 c4 20             	add    $0x20,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	0f 88 3a 03 00 00    	js     801b35 <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	68 00 00 40 00       	push   $0x400000
  801803:	6a 00                	push   $0x0
  801805:	e8 ff f3 ff ff       	call   800c09 <sys_page_unmap>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	0f 88 1e 03 00 00    	js     801b35 <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801817:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80181d:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801824:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80182b:	00 00 00 
  80182e:	e9 4f 01 00 00       	jmp    801982 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801833:	68 d8 2d 80 00       	push   $0x802dd8
  801838:	68 e8 2c 80 00       	push   $0x802ce8
  80183d:	68 f4 00 00 00       	push   $0xf4
  801842:	68 68 2d 80 00       	push   $0x802d68
  801847:	e8 8f e8 ff ff       	call   8000db <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	6a 07                	push   $0x7
  801851:	68 00 00 40 00       	push   $0x400000
  801856:	6a 00                	push   $0x0
  801858:	e8 27 f3 ff ff       	call   800b84 <sys_page_alloc>
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	0f 88 ab 02 00 00    	js     801b13 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801871:	01 f0                	add    %esi,%eax
  801873:	50                   	push   %eax
  801874:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80187a:	e8 4c f9 ff ff       	call   8011cb <seek>
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	0f 88 90 02 00 00    	js     801b1a <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801893:	29 f0                	sub    %esi,%eax
  801895:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80189a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80189f:	0f 47 c1             	cmova  %ecx,%eax
  8018a2:	50                   	push   %eax
  8018a3:	68 00 00 40 00       	push   $0x400000
  8018a8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8018ae:	e8 51 f8 ff ff       	call   801104 <readn>
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	0f 88 63 02 00 00    	js     801b21 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8018c7:	53                   	push   %ebx
  8018c8:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8018ce:	68 00 00 40 00       	push   $0x400000
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 ed f2 ff ff       	call   800bc7 <sys_page_map>
  8018da:	83 c4 20             	add    $0x20,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 7c                	js     80195d <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	68 00 00 40 00       	push   $0x400000
  8018e9:	6a 00                	push   $0x0
  8018eb:	e8 19 f3 ff ff       	call   800c09 <sys_page_unmap>
  8018f0:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8018f3:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8018f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018ff:	89 fe                	mov    %edi,%esi
  801901:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801907:	76 69                	jbe    801972 <spawn+0x3a5>
		if (i >= filesz) {
  801909:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80190f:	0f 87 37 ff ff ff    	ja     80184c <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80191e:	53                   	push   %ebx
  80191f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801925:	e8 5a f2 ff ff       	call   800b84 <sys_page_alloc>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	79 c2                	jns    8018f3 <spawn+0x326>
  801931:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80193c:	e8 c4 f1 ff ff       	call   800b05 <sys_env_destroy>
	close(fd);
  801941:	83 c4 04             	add    $0x4,%esp
  801944:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80194a:	e8 f0 f5 ff ff       	call   800f3f <close>
	return r;
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801958:	e9 a8 01 00 00       	jmp    801b05 <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  80195d:	50                   	push   %eax
  80195e:	68 74 2d 80 00       	push   $0x802d74
  801963:	68 27 01 00 00       	push   $0x127
  801968:	68 68 2d 80 00       	push   $0x802d68
  80196d:	e8 69 e7 ff ff       	call   8000db <_panic>
  801972:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801978:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80197f:	83 c6 20             	add    $0x20,%esi
  801982:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801989:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  80198f:	7e 6d                	jle    8019fe <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801991:	83 3e 01             	cmpl   $0x1,(%esi)
  801994:	75 e2                	jne    801978 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801996:	8b 46 18             	mov    0x18(%esi),%eax
  801999:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80199c:	83 f8 01             	cmp    $0x1,%eax
  80199f:	19 c0                	sbb    %eax,%eax
  8019a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8019a4:	83 c0 07             	add    $0x7,%eax
  8019a7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8019ad:	8b 4e 04             	mov    0x4(%esi),%ecx
  8019b0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8019b6:	8b 56 10             	mov    0x10(%esi),%edx
  8019b9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8019bf:	8b 7e 14             	mov    0x14(%esi),%edi
  8019c2:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8019c8:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8019cb:	89 d8                	mov    %ebx,%eax
  8019cd:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019d2:	74 1a                	je     8019ee <spawn+0x421>
		va -= i;
  8019d4:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8019d6:	01 c7                	add    %eax,%edi
  8019d8:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8019de:	01 c2                	add    %eax,%edx
  8019e0:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8019e6:	29 c1                	sub    %eax,%ecx
  8019e8:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8019ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f3:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8019f9:	e9 01 ff ff ff       	jmp    8018ff <spawn+0x332>
	close(fd);
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a07:	e8 33 f5 ff ff       	call   800f3f <close>
  801a0c:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801a0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a14:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801a1a:	eb 0d                	jmp    801a29 <spawn+0x45c>
  801a1c:	83 c3 01             	add    $0x1,%ebx
  801a1f:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801a25:	77 5d                	ja     801a84 <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  801a27:	74 f3                	je     801a1c <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  801a29:	89 da                	mov    %ebx,%edx
  801a2b:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  801a2e:	89 d0                	mov    %edx,%eax
  801a30:	c1 e8 16             	shr    $0x16,%eax
  801a33:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a3a:	a8 01                	test   $0x1,%al
  801a3c:	74 de                	je     801a1c <spawn+0x44f>
		pte_t pte = uvpt[i];
  801a3e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  801a45:	89 c1                	mov    %eax,%ecx
  801a47:	81 e1 01 04 00 00    	and    $0x401,%ecx
  801a4d:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  801a53:	75 c7                	jne    801a1c <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	25 07 0e 00 00       	and    $0xe07,%eax
  801a5d:	50                   	push   %eax
  801a5e:	52                   	push   %edx
  801a5f:	56                   	push   %esi
  801a60:	52                   	push   %edx
  801a61:	6a 00                	push   $0x0
  801a63:	e8 5f f1 ff ff       	call   800bc7 <sys_page_map>
  801a68:	83 c4 20             	add    $0x20,%esp
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	79 ad                	jns    801a1c <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  801a6f:	50                   	push   %eax
  801a70:	68 91 2d 80 00       	push   $0x802d91
  801a75:	68 42 01 00 00       	push   $0x142
  801a7a:	68 68 2d 80 00       	push   $0x802d68
  801a7f:	e8 57 e6 ff ff       	call   8000db <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801a84:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801a8b:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801a97:	50                   	push   %eax
  801a98:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a9e:	e8 ea f1 ff ff       	call   800c8d <sys_env_set_trapframe>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 25                	js     801acf <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	6a 02                	push   $0x2
  801aaf:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ab5:	e8 91 f1 ff ff       	call   800c4b <sys_env_set_status>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 23                	js     801ae4 <spawn+0x517>
	return child;
  801ac1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ac7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801acd:	eb 36                	jmp    801b05 <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  801acf:	50                   	push   %eax
  801ad0:	68 a5 2d 80 00       	push   $0x802da5
  801ad5:	68 88 00 00 00       	push   $0x88
  801ada:	68 68 2d 80 00       	push   $0x802d68
  801adf:	e8 f7 e5 ff ff       	call   8000db <_panic>
		panic("sys_env_set_status: %e", r);
  801ae4:	50                   	push   %eax
  801ae5:	68 bf 2d 80 00       	push   $0x802dbf
  801aea:	68 8b 00 00 00       	push   $0x8b
  801aef:	68 68 2d 80 00       	push   $0x802d68
  801af4:	e8 e2 e5 ff ff       	call   8000db <_panic>
		return r;
  801af9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801aff:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801b05:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5f                   	pop    %edi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
  801b13:	89 c7                	mov    %eax,%edi
  801b15:	e9 19 fe ff ff       	jmp    801933 <spawn+0x366>
  801b1a:	89 c7                	mov    %eax,%edi
  801b1c:	e9 12 fe ff ff       	jmp    801933 <spawn+0x366>
  801b21:	89 c7                	mov    %eax,%edi
  801b23:	e9 0b fe ff ff       	jmp    801933 <spawn+0x366>
		return -E_NO_MEM;
  801b28:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801b2d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b33:	eb d0                	jmp    801b05 <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	68 00 00 40 00       	push   $0x400000
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 c5 f0 ff ff       	call   800c09 <sys_page_unmap>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801b4d:	eb b6                	jmp    801b05 <spawn+0x538>

00801b4f <spawnl>:
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	57                   	push   %edi
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
  801b55:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801b58:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801b60:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b63:	83 3a 00             	cmpl   $0x0,(%edx)
  801b66:	74 07                	je     801b6f <spawnl+0x20>
		argc++;
  801b68:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801b6b:	89 ca                	mov    %ecx,%edx
  801b6d:	eb f1                	jmp    801b60 <spawnl+0x11>
	const char *argv[argc+2];
  801b6f:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801b76:	83 e2 f0             	and    $0xfffffff0,%edx
  801b79:	29 d4                	sub    %edx,%esp
  801b7b:	8d 54 24 03          	lea    0x3(%esp),%edx
  801b7f:	c1 ea 02             	shr    $0x2,%edx
  801b82:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801b89:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801b8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b8e:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801b95:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801b9c:	00 
	va_start(vl, arg0);
  801b9d:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ba0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba7:	eb 0b                	jmp    801bb4 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801ba9:	83 c0 01             	add    $0x1,%eax
  801bac:	8b 39                	mov    (%ecx),%edi
  801bae:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801bb1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801bb4:	39 d0                	cmp    %edx,%eax
  801bb6:	75 f1                	jne    801ba9 <spawnl+0x5a>
	return spawn(prog, argv);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	56                   	push   %esi
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	e8 09 fa ff ff       	call   8015cd <spawn>
}
  801bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
  801bd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	e8 c5 f1 ff ff       	call   800da4 <fd2data>
  801bdf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801be1:	83 c4 08             	add    $0x8,%esp
  801be4:	68 fe 2d 80 00       	push   $0x802dfe
  801be9:	53                   	push   %ebx
  801bea:	e8 a3 eb ff ff       	call   800792 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bef:	8b 46 04             	mov    0x4(%esi),%eax
  801bf2:	2b 06                	sub    (%esi),%eax
  801bf4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bfa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c01:	00 00 00 
	stat->st_dev = &devpipe;
  801c04:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c0b:	30 80 00 
	return 0;
}
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c24:	53                   	push   %ebx
  801c25:	6a 00                	push   $0x0
  801c27:	e8 dd ef ff ff       	call   800c09 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c2c:	89 1c 24             	mov    %ebx,(%esp)
  801c2f:	e8 70 f1 ff ff       	call   800da4 <fd2data>
  801c34:	83 c4 08             	add    $0x8,%esp
  801c37:	50                   	push   %eax
  801c38:	6a 00                	push   $0x0
  801c3a:	e8 ca ef ff ff       	call   800c09 <sys_page_unmap>
}
  801c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <_pipeisclosed>:
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	57                   	push   %edi
  801c48:	56                   	push   %esi
  801c49:	53                   	push   %ebx
  801c4a:	83 ec 1c             	sub    $0x1c,%esp
  801c4d:	89 c7                	mov    %eax,%edi
  801c4f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c51:	a1 08 40 80 00       	mov    0x804008,%eax
  801c56:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	57                   	push   %edi
  801c5d:	e8 ac 09 00 00       	call   80260e <pageref>
  801c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c65:	89 34 24             	mov    %esi,(%esp)
  801c68:	e8 a1 09 00 00       	call   80260e <pageref>
		nn = thisenv->env_runs;
  801c6d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c73:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	39 cb                	cmp    %ecx,%ebx
  801c7b:	74 1b                	je     801c98 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c7d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c80:	75 cf                	jne    801c51 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c82:	8b 42 58             	mov    0x58(%edx),%eax
  801c85:	6a 01                	push   $0x1
  801c87:	50                   	push   %eax
  801c88:	53                   	push   %ebx
  801c89:	68 05 2e 80 00       	push   $0x802e05
  801c8e:	e8 23 e5 ff ff       	call   8001b6 <cprintf>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	eb b9                	jmp    801c51 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c98:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c9b:	0f 94 c0             	sete   %al
  801c9e:	0f b6 c0             	movzbl %al,%eax
}
  801ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <devpipe_write>:
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	57                   	push   %edi
  801cad:	56                   	push   %esi
  801cae:	53                   	push   %ebx
  801caf:	83 ec 28             	sub    $0x28,%esp
  801cb2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cb5:	56                   	push   %esi
  801cb6:	e8 e9 f0 ff ff       	call   800da4 <fd2data>
  801cbb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cc8:	74 4f                	je     801d19 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cca:	8b 43 04             	mov    0x4(%ebx),%eax
  801ccd:	8b 0b                	mov    (%ebx),%ecx
  801ccf:	8d 51 20             	lea    0x20(%ecx),%edx
  801cd2:	39 d0                	cmp    %edx,%eax
  801cd4:	72 14                	jb     801cea <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801cd6:	89 da                	mov    %ebx,%edx
  801cd8:	89 f0                	mov    %esi,%eax
  801cda:	e8 65 ff ff ff       	call   801c44 <_pipeisclosed>
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	75 3b                	jne    801d1e <devpipe_write+0x75>
			sys_yield();
  801ce3:	e8 7d ee ff ff       	call   800b65 <sys_yield>
  801ce8:	eb e0                	jmp    801cca <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ced:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cf1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cf4:	89 c2                	mov    %eax,%edx
  801cf6:	c1 fa 1f             	sar    $0x1f,%edx
  801cf9:	89 d1                	mov    %edx,%ecx
  801cfb:	c1 e9 1b             	shr    $0x1b,%ecx
  801cfe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d01:	83 e2 1f             	and    $0x1f,%edx
  801d04:	29 ca                	sub    %ecx,%edx
  801d06:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d0a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d0e:	83 c0 01             	add    $0x1,%eax
  801d11:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d14:	83 c7 01             	add    $0x1,%edi
  801d17:	eb ac                	jmp    801cc5 <devpipe_write+0x1c>
	return i;
  801d19:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1c:	eb 05                	jmp    801d23 <devpipe_write+0x7a>
				return 0;
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5f                   	pop    %edi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <devpipe_read>:
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 18             	sub    $0x18,%esp
  801d34:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d37:	57                   	push   %edi
  801d38:	e8 67 f0 ff ff       	call   800da4 <fd2data>
  801d3d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	be 00 00 00 00       	mov    $0x0,%esi
  801d47:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d4a:	75 14                	jne    801d60 <devpipe_read+0x35>
	return i;
  801d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4f:	eb 02                	jmp    801d53 <devpipe_read+0x28>
				return i;
  801d51:	89 f0                	mov    %esi,%eax
}
  801d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5f                   	pop    %edi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    
			sys_yield();
  801d5b:	e8 05 ee ff ff       	call   800b65 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d60:	8b 03                	mov    (%ebx),%eax
  801d62:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d65:	75 18                	jne    801d7f <devpipe_read+0x54>
			if (i > 0)
  801d67:	85 f6                	test   %esi,%esi
  801d69:	75 e6                	jne    801d51 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d6b:	89 da                	mov    %ebx,%edx
  801d6d:	89 f8                	mov    %edi,%eax
  801d6f:	e8 d0 fe ff ff       	call   801c44 <_pipeisclosed>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 e3                	je     801d5b <devpipe_read+0x30>
				return 0;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	eb d4                	jmp    801d53 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d7f:	99                   	cltd   
  801d80:	c1 ea 1b             	shr    $0x1b,%edx
  801d83:	01 d0                	add    %edx,%eax
  801d85:	83 e0 1f             	and    $0x1f,%eax
  801d88:	29 d0                	sub    %edx,%eax
  801d8a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d92:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d95:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d98:	83 c6 01             	add    $0x1,%esi
  801d9b:	eb aa                	jmp    801d47 <devpipe_read+0x1c>

00801d9d <pipe>:
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da8:	50                   	push   %eax
  801da9:	e8 0d f0 ff ff       	call   800dbb <fd_alloc>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	85 c0                	test   %eax,%eax
  801db5:	0f 88 23 01 00 00    	js     801ede <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	68 07 04 00 00       	push   $0x407
  801dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc6:	6a 00                	push   $0x0
  801dc8:	e8 b7 ed ff ff       	call   800b84 <sys_page_alloc>
  801dcd:	89 c3                	mov    %eax,%ebx
  801dcf:	83 c4 10             	add    $0x10,%esp
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	0f 88 04 01 00 00    	js     801ede <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801de0:	50                   	push   %eax
  801de1:	e8 d5 ef ff ff       	call   800dbb <fd_alloc>
  801de6:	89 c3                	mov    %eax,%ebx
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	0f 88 db 00 00 00    	js     801ece <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	68 07 04 00 00       	push   $0x407
  801dfb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfe:	6a 00                	push   $0x0
  801e00:	e8 7f ed ff ff       	call   800b84 <sys_page_alloc>
  801e05:	89 c3                	mov    %eax,%ebx
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	0f 88 bc 00 00 00    	js     801ece <pipe+0x131>
	va = fd2data(fd0);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 f4             	pushl  -0xc(%ebp)
  801e18:	e8 87 ef ff ff       	call   800da4 <fd2data>
  801e1d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1f:	83 c4 0c             	add    $0xc,%esp
  801e22:	68 07 04 00 00       	push   $0x407
  801e27:	50                   	push   %eax
  801e28:	6a 00                	push   $0x0
  801e2a:	e8 55 ed ff ff       	call   800b84 <sys_page_alloc>
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 88 82 00 00 00    	js     801ebe <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e42:	e8 5d ef ff ff       	call   800da4 <fd2data>
  801e47:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e4e:	50                   	push   %eax
  801e4f:	6a 00                	push   $0x0
  801e51:	56                   	push   %esi
  801e52:	6a 00                	push   $0x0
  801e54:	e8 6e ed ff ff       	call   800bc7 <sys_page_map>
  801e59:	89 c3                	mov    %eax,%ebx
  801e5b:	83 c4 20             	add    $0x20,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 4e                	js     801eb0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e62:	a1 20 30 80 00       	mov    0x803020,%eax
  801e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e79:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8b:	e8 04 ef ff ff       	call   800d94 <fd2num>
  801e90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e93:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e95:	83 c4 04             	add    $0x4,%esp
  801e98:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9b:	e8 f4 ee ff ff       	call   800d94 <fd2num>
  801ea0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eae:	eb 2e                	jmp    801ede <pipe+0x141>
	sys_page_unmap(0, va);
  801eb0:	83 ec 08             	sub    $0x8,%esp
  801eb3:	56                   	push   %esi
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 4e ed ff ff       	call   800c09 <sys_page_unmap>
  801ebb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec4:	6a 00                	push   $0x0
  801ec6:	e8 3e ed ff ff       	call   800c09 <sys_page_unmap>
  801ecb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ece:	83 ec 08             	sub    $0x8,%esp
  801ed1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed4:	6a 00                	push   $0x0
  801ed6:	e8 2e ed ff ff       	call   800c09 <sys_page_unmap>
  801edb:	83 c4 10             	add    $0x10,%esp
}
  801ede:	89 d8                	mov    %ebx,%eax
  801ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    

00801ee7 <pipeisclosed>:
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef0:	50                   	push   %eax
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	e8 14 ef ff ff       	call   800e0d <fd_lookup>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	85 c0                	test   %eax,%eax
  801efe:	78 18                	js     801f18 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	ff 75 f4             	pushl  -0xc(%ebp)
  801f06:	e8 99 ee ff ff       	call   800da4 <fd2data>
	return _pipeisclosed(fd, p);
  801f0b:	89 c2                	mov    %eax,%edx
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	e8 2f fd ff ff       	call   801c44 <_pipeisclosed>
  801f15:	83 c4 10             	add    $0x10,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f20:	68 1d 2e 80 00       	push   $0x802e1d
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	e8 65 e8 ff ff       	call   800792 <strcpy>
	return 0;
}
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <devsock_close>:
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	53                   	push   %ebx
  801f38:	83 ec 10             	sub    $0x10,%esp
  801f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f3e:	53                   	push   %ebx
  801f3f:	e8 ca 06 00 00       	call   80260e <pageref>
  801f44:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f47:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f4c:	83 f8 01             	cmp    $0x1,%eax
  801f4f:	74 07                	je     801f58 <devsock_close+0x24>
}
  801f51:	89 d0                	mov    %edx,%eax
  801f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	ff 73 0c             	pushl  0xc(%ebx)
  801f5e:	e8 b9 02 00 00       	call   80221c <nsipc_close>
  801f63:	89 c2                	mov    %eax,%edx
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	eb e7                	jmp    801f51 <devsock_close+0x1d>

00801f6a <devsock_write>:
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f70:	6a 00                	push   $0x0
  801f72:	ff 75 10             	pushl  0x10(%ebp)
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	ff 70 0c             	pushl  0xc(%eax)
  801f7e:	e8 76 03 00 00       	call   8022f9 <nsipc_send>
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <devsock_read>:
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	ff 75 10             	pushl  0x10(%ebp)
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	ff 70 0c             	pushl  0xc(%eax)
  801f99:	e8 ef 02 00 00       	call   80228d <nsipc_recv>
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <fd2sockid>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fa6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fa9:	52                   	push   %edx
  801faa:	50                   	push   %eax
  801fab:	e8 5d ee ff ff       	call   800e0d <fd_lookup>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 10                	js     801fc7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801fc0:	39 08                	cmp    %ecx,(%eax)
  801fc2:	75 05                	jne    801fc9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fc4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    
		return -E_NOT_SUPP;
  801fc9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fce:	eb f7                	jmp    801fc7 <fd2sockid+0x27>

00801fd0 <alloc_sockfd>:
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	56                   	push   %esi
  801fd4:	53                   	push   %ebx
  801fd5:	83 ec 1c             	sub    $0x1c,%esp
  801fd8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdd:	50                   	push   %eax
  801fde:	e8 d8 ed ff ff       	call   800dbb <fd_alloc>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 43                	js     80202f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 07 04 00 00       	push   $0x407
  801ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 86 eb ff ff       	call   800b84 <sys_page_alloc>
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	78 28                	js     80202f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802010:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80201c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	50                   	push   %eax
  802023:	e8 6c ed ff ff       	call   800d94 <fd2num>
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	eb 0c                	jmp    80203b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	56                   	push   %esi
  802033:	e8 e4 01 00 00       	call   80221c <nsipc_close>
		return r;
  802038:	83 c4 10             	add    $0x10,%esp
}
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <accept>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	e8 4e ff ff ff       	call   801fa0 <fd2sockid>
  802052:	85 c0                	test   %eax,%eax
  802054:	78 1b                	js     802071 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	ff 75 10             	pushl  0x10(%ebp)
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	e8 0e 01 00 00       	call   802173 <nsipc_accept>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 05                	js     802071 <accept+0x2d>
	return alloc_sockfd(r);
  80206c:	e8 5f ff ff ff       	call   801fd0 <alloc_sockfd>
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <bind>:
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	e8 1f ff ff ff       	call   801fa0 <fd2sockid>
  802081:	85 c0                	test   %eax,%eax
  802083:	78 12                	js     802097 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	ff 75 10             	pushl  0x10(%ebp)
  80208b:	ff 75 0c             	pushl  0xc(%ebp)
  80208e:	50                   	push   %eax
  80208f:	e8 31 01 00 00       	call   8021c5 <nsipc_bind>
  802094:	83 c4 10             	add    $0x10,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <shutdown>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	e8 f9 fe ff ff       	call   801fa0 <fd2sockid>
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	78 0f                	js     8020ba <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020ab:	83 ec 08             	sub    $0x8,%esp
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	50                   	push   %eax
  8020b2:	e8 43 01 00 00       	call   8021fa <nsipc_shutdown>
  8020b7:	83 c4 10             	add    $0x10,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <connect>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	e8 d6 fe ff ff       	call   801fa0 <fd2sockid>
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	78 12                	js     8020e0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	ff 75 10             	pushl  0x10(%ebp)
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	50                   	push   %eax
  8020d8:	e8 59 01 00 00       	call   802236 <nsipc_connect>
  8020dd:	83 c4 10             	add    $0x10,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <listen>:
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	e8 b0 fe ff ff       	call   801fa0 <fd2sockid>
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	78 0f                	js     802103 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020f4:	83 ec 08             	sub    $0x8,%esp
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	50                   	push   %eax
  8020fb:	e8 6b 01 00 00       	call   80226b <nsipc_listen>
  802100:	83 c4 10             	add    $0x10,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <socket>:

int
socket(int domain, int type, int protocol)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80210b:	ff 75 10             	pushl  0x10(%ebp)
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 3e 02 00 00       	call   802357 <nsipc_socket>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 05                	js     802125 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802120:	e8 ab fe ff ff       	call   801fd0 <alloc_sockfd>
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	53                   	push   %ebx
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802130:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802137:	74 26                	je     80215f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802139:	6a 07                	push   $0x7
  80213b:	68 00 60 80 00       	push   $0x806000
  802140:	53                   	push   %ebx
  802141:	ff 35 04 40 80 00    	pushl  0x804004
  802147:	e8 1d 04 00 00       	call   802569 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80214c:	83 c4 0c             	add    $0xc,%esp
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	e8 9c 03 00 00       	call   8024f6 <ipc_recv>
}
  80215a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	6a 02                	push   $0x2
  802164:	e8 6c 04 00 00       	call   8025d5 <ipc_find_env>
  802169:	a3 04 40 80 00       	mov    %eax,0x804004
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	eb c6                	jmp    802139 <nsipc+0x12>

00802173 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802183:	8b 06                	mov    (%esi),%eax
  802185:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80218a:	b8 01 00 00 00       	mov    $0x1,%eax
  80218f:	e8 93 ff ff ff       	call   802127 <nsipc>
  802194:	89 c3                	mov    %eax,%ebx
  802196:	85 c0                	test   %eax,%eax
  802198:	79 09                	jns    8021a3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80219a:	89 d8                	mov    %ebx,%eax
  80219c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	ff 35 10 60 80 00    	pushl  0x806010
  8021ac:	68 00 60 80 00       	push   $0x806000
  8021b1:	ff 75 0c             	pushl  0xc(%ebp)
  8021b4:	e8 67 e7 ff ff       	call   800920 <memmove>
		*addrlen = ret->ret_addrlen;
  8021b9:	a1 10 60 80 00       	mov    0x806010,%eax
  8021be:	89 06                	mov    %eax,(%esi)
  8021c0:	83 c4 10             	add    $0x10,%esp
	return r;
  8021c3:	eb d5                	jmp    80219a <nsipc_accept+0x27>

008021c5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 08             	sub    $0x8,%esp
  8021cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021d7:	53                   	push   %ebx
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	68 04 60 80 00       	push   $0x806004
  8021e0:	e8 3b e7 ff ff       	call   800920 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021e5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8021eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8021f0:	e8 32 ff ff ff       	call   802127 <nsipc>
}
  8021f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802210:	b8 03 00 00 00       	mov    $0x3,%eax
  802215:	e8 0d ff ff ff       	call   802127 <nsipc>
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <nsipc_close>:

int
nsipc_close(int s)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80222a:	b8 04 00 00 00       	mov    $0x4,%eax
  80222f:	e8 f3 fe ff ff       	call   802127 <nsipc>
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	53                   	push   %ebx
  80223a:	83 ec 08             	sub    $0x8,%esp
  80223d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802248:	53                   	push   %ebx
  802249:	ff 75 0c             	pushl  0xc(%ebp)
  80224c:	68 04 60 80 00       	push   $0x806004
  802251:	e8 ca e6 ff ff       	call   800920 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802256:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80225c:	b8 05 00 00 00       	mov    $0x5,%eax
  802261:	e8 c1 fe ff ff       	call   802127 <nsipc>
}
  802266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802281:	b8 06 00 00 00       	mov    $0x6,%eax
  802286:	e8 9c fe ff ff       	call   802127 <nsipc>
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
  802292:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80229d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ab:	b8 07 00 00 00       	mov    $0x7,%eax
  8022b0:	e8 72 fe ff ff       	call   802127 <nsipc>
  8022b5:	89 c3                	mov    %eax,%ebx
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 1f                	js     8022da <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022bb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022c0:	7f 21                	jg     8022e3 <nsipc_recv+0x56>
  8022c2:	39 c6                	cmp    %eax,%esi
  8022c4:	7c 1d                	jl     8022e3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	50                   	push   %eax
  8022ca:	68 00 60 80 00       	push   $0x806000
  8022cf:	ff 75 0c             	pushl  0xc(%ebp)
  8022d2:	e8 49 e6 ff ff       	call   800920 <memmove>
  8022d7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022da:	89 d8                	mov    %ebx,%eax
  8022dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022e3:	68 29 2e 80 00       	push   $0x802e29
  8022e8:	68 e8 2c 80 00       	push   $0x802ce8
  8022ed:	6a 62                	push   $0x62
  8022ef:	68 3e 2e 80 00       	push   $0x802e3e
  8022f4:	e8 e2 dd ff ff       	call   8000db <_panic>

008022f9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	53                   	push   %ebx
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80230b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802311:	7f 2e                	jg     802341 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	53                   	push   %ebx
  802317:	ff 75 0c             	pushl  0xc(%ebp)
  80231a:	68 0c 60 80 00       	push   $0x80600c
  80231f:	e8 fc e5 ff ff       	call   800920 <memmove>
	nsipcbuf.send.req_size = size;
  802324:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80232a:	8b 45 14             	mov    0x14(%ebp),%eax
  80232d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802332:	b8 08 00 00 00       	mov    $0x8,%eax
  802337:	e8 eb fd ff ff       	call   802127 <nsipc>
}
  80233c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233f:	c9                   	leave  
  802340:	c3                   	ret    
	assert(size < 1600);
  802341:	68 4a 2e 80 00       	push   $0x802e4a
  802346:	68 e8 2c 80 00       	push   $0x802ce8
  80234b:	6a 6d                	push   $0x6d
  80234d:	68 3e 2e 80 00       	push   $0x802e3e
  802352:	e8 84 dd ff ff       	call   8000db <_panic>

00802357 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802365:	8b 45 0c             	mov    0xc(%ebp),%eax
  802368:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80236d:	8b 45 10             	mov    0x10(%ebp),%eax
  802370:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802375:	b8 09 00 00 00       	mov    $0x9,%eax
  80237a:	e8 a8 fd ff ff       	call   802127 <nsipc>
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	c3                   	ret    

00802387 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80238d:	68 56 2e 80 00       	push   $0x802e56
  802392:	ff 75 0c             	pushl  0xc(%ebp)
  802395:	e8 f8 e3 ff ff       	call   800792 <strcpy>
	return 0;
}
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <devcons_write>:
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	57                   	push   %edi
  8023a5:	56                   	push   %esi
  8023a6:	53                   	push   %ebx
  8023a7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023ad:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023b2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023bb:	73 31                	jae    8023ee <devcons_write+0x4d>
		m = n - tot;
  8023bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023c0:	29 f3                	sub    %esi,%ebx
  8023c2:	83 fb 7f             	cmp    $0x7f,%ebx
  8023c5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	53                   	push   %ebx
  8023d1:	89 f0                	mov    %esi,%eax
  8023d3:	03 45 0c             	add    0xc(%ebp),%eax
  8023d6:	50                   	push   %eax
  8023d7:	57                   	push   %edi
  8023d8:	e8 43 e5 ff ff       	call   800920 <memmove>
		sys_cputs(buf, m);
  8023dd:	83 c4 08             	add    $0x8,%esp
  8023e0:	53                   	push   %ebx
  8023e1:	57                   	push   %edi
  8023e2:	e8 e1 e6 ff ff       	call   800ac8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023e7:	01 de                	add    %ebx,%esi
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	eb ca                	jmp    8023b8 <devcons_write+0x17>
}
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5f                   	pop    %edi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    

008023f8 <devcons_read>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 08             	sub    $0x8,%esp
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802407:	74 21                	je     80242a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802409:	e8 d8 e6 ff ff       	call   800ae6 <sys_cgetc>
  80240e:	85 c0                	test   %eax,%eax
  802410:	75 07                	jne    802419 <devcons_read+0x21>
		sys_yield();
  802412:	e8 4e e7 ff ff       	call   800b65 <sys_yield>
  802417:	eb f0                	jmp    802409 <devcons_read+0x11>
	if (c < 0)
  802419:	78 0f                	js     80242a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80241b:	83 f8 04             	cmp    $0x4,%eax
  80241e:	74 0c                	je     80242c <devcons_read+0x34>
	*(char*)vbuf = c;
  802420:	8b 55 0c             	mov    0xc(%ebp),%edx
  802423:	88 02                	mov    %al,(%edx)
	return 1;
  802425:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    
		return 0;
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
  802431:	eb f7                	jmp    80242a <devcons_read+0x32>

00802433 <cputchar>:
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80243f:	6a 01                	push   $0x1
  802441:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802444:	50                   	push   %eax
  802445:	e8 7e e6 ff ff       	call   800ac8 <sys_cputs>
}
  80244a:	83 c4 10             	add    $0x10,%esp
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <getchar>:
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802455:	6a 01                	push   $0x1
  802457:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80245a:	50                   	push   %eax
  80245b:	6a 00                	push   $0x0
  80245d:	e8 1b ec ff ff       	call   80107d <read>
	if (r < 0)
  802462:	83 c4 10             	add    $0x10,%esp
  802465:	85 c0                	test   %eax,%eax
  802467:	78 06                	js     80246f <getchar+0x20>
	if (r < 1)
  802469:	74 06                	je     802471 <getchar+0x22>
	return c;
  80246b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    
		return -E_EOF;
  802471:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802476:	eb f7                	jmp    80246f <getchar+0x20>

00802478 <iscons>:
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80247e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802481:	50                   	push   %eax
  802482:	ff 75 08             	pushl  0x8(%ebp)
  802485:	e8 83 e9 ff ff       	call   800e0d <fd_lookup>
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	85 c0                	test   %eax,%eax
  80248f:	78 11                	js     8024a2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80249a:	39 10                	cmp    %edx,(%eax)
  80249c:	0f 94 c0             	sete   %al
  80249f:	0f b6 c0             	movzbl %al,%eax
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <opencons>:
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ad:	50                   	push   %eax
  8024ae:	e8 08 e9 ff ff       	call   800dbb <fd_alloc>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	78 3a                	js     8024f4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	68 07 04 00 00       	push   $0x407
  8024c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c5:	6a 00                	push   $0x0
  8024c7:	e8 b8 e6 ff ff       	call   800b84 <sys_page_alloc>
  8024cc:	83 c4 10             	add    $0x10,%esp
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 21                	js     8024f4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024e8:	83 ec 0c             	sub    $0xc,%esp
  8024eb:	50                   	push   %eax
  8024ec:	e8 a3 e8 ff ff       	call   800d94 <fd2num>
  8024f1:	83 c4 10             	add    $0x10,%esp
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	56                   	push   %esi
  8024fa:	53                   	push   %ebx
  8024fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8024fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802501:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802504:	85 c0                	test   %eax,%eax
  802506:	74 4f                	je     802557 <ipc_recv+0x61>
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	50                   	push   %eax
  80250c:	e8 23 e8 ff ff       	call   800d34 <sys_ipc_recv>
  802511:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802514:	85 f6                	test   %esi,%esi
  802516:	74 14                	je     80252c <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802518:	ba 00 00 00 00       	mov    $0x0,%edx
  80251d:	85 c0                	test   %eax,%eax
  80251f:	75 09                	jne    80252a <ipc_recv+0x34>
  802521:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802527:	8b 52 74             	mov    0x74(%edx),%edx
  80252a:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80252c:	85 db                	test   %ebx,%ebx
  80252e:	74 14                	je     802544 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802530:	ba 00 00 00 00       	mov    $0x0,%edx
  802535:	85 c0                	test   %eax,%eax
  802537:	75 09                	jne    802542 <ipc_recv+0x4c>
  802539:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80253f:	8b 52 78             	mov    0x78(%edx),%edx
  802542:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802544:	85 c0                	test   %eax,%eax
  802546:	75 08                	jne    802550 <ipc_recv+0x5a>
  802548:	a1 08 40 80 00       	mov    0x804008,%eax
  80254d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802550:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802553:	5b                   	pop    %ebx
  802554:	5e                   	pop    %esi
  802555:	5d                   	pop    %ebp
  802556:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802557:	83 ec 0c             	sub    $0xc,%esp
  80255a:	68 00 00 c0 ee       	push   $0xeec00000
  80255f:	e8 d0 e7 ff ff       	call   800d34 <sys_ipc_recv>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	eb ab                	jmp    802514 <ipc_recv+0x1e>

00802569 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	57                   	push   %edi
  80256d:	56                   	push   %esi
  80256e:	53                   	push   %ebx
  80256f:	83 ec 0c             	sub    $0xc,%esp
  802572:	8b 7d 08             	mov    0x8(%ebp),%edi
  802575:	8b 75 10             	mov    0x10(%ebp),%esi
  802578:	eb 20                	jmp    80259a <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80257a:	6a 00                	push   $0x0
  80257c:	68 00 00 c0 ee       	push   $0xeec00000
  802581:	ff 75 0c             	pushl  0xc(%ebp)
  802584:	57                   	push   %edi
  802585:	e8 87 e7 ff ff       	call   800d11 <sys_ipc_try_send>
  80258a:	89 c3                	mov    %eax,%ebx
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	eb 1f                	jmp    8025b0 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802591:	e8 cf e5 ff ff       	call   800b65 <sys_yield>
	while(retval != 0) {
  802596:	85 db                	test   %ebx,%ebx
  802598:	74 33                	je     8025cd <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80259a:	85 f6                	test   %esi,%esi
  80259c:	74 dc                	je     80257a <ipc_send+0x11>
  80259e:	ff 75 14             	pushl  0x14(%ebp)
  8025a1:	56                   	push   %esi
  8025a2:	ff 75 0c             	pushl  0xc(%ebp)
  8025a5:	57                   	push   %edi
  8025a6:	e8 66 e7 ff ff       	call   800d11 <sys_ipc_try_send>
  8025ab:	89 c3                	mov    %eax,%ebx
  8025ad:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8025b0:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8025b3:	74 dc                	je     802591 <ipc_send+0x28>
  8025b5:	85 db                	test   %ebx,%ebx
  8025b7:	74 d8                	je     802591 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	68 64 2e 80 00       	push   $0x802e64
  8025c1:	6a 35                	push   $0x35
  8025c3:	68 94 2e 80 00       	push   $0x802e94
  8025c8:	e8 0e db ff ff       	call   8000db <_panic>
	}
}
  8025cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5f                   	pop    %edi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    

008025d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025e0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025e3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025e9:	8b 52 50             	mov    0x50(%edx),%edx
  8025ec:	39 ca                	cmp    %ecx,%edx
  8025ee:	74 11                	je     802601 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025f0:	83 c0 01             	add    $0x1,%eax
  8025f3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025f8:	75 e6                	jne    8025e0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ff:	eb 0b                	jmp    80260c <ipc_find_env+0x37>
			return envs[i].env_id;
  802601:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802604:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802609:	8b 40 48             	mov    0x48(%eax),%eax
}
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    

0080260e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802614:	89 d0                	mov    %edx,%eax
  802616:	c1 e8 16             	shr    $0x16,%eax
  802619:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802625:	f6 c1 01             	test   $0x1,%cl
  802628:	74 1d                	je     802647 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80262a:	c1 ea 0c             	shr    $0xc,%edx
  80262d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802634:	f6 c2 01             	test   $0x1,%dl
  802637:	74 0e                	je     802647 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802639:	c1 ea 0c             	shr    $0xc,%edx
  80263c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802643:	ef 
  802644:	0f b7 c0             	movzwl %ax,%eax
}
  802647:	5d                   	pop    %ebp
  802648:	c3                   	ret    
  802649:	66 90                	xchg   %ax,%ax
  80264b:	66 90                	xchg   %ax,%ax
  80264d:	66 90                	xchg   %ax,%ax
  80264f:	90                   	nop

00802650 <__udivdi3>:
  802650:	f3 0f 1e fb          	endbr32 
  802654:	55                   	push   %ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 1c             	sub    $0x1c,%esp
  80265b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802663:	8b 74 24 34          	mov    0x34(%esp),%esi
  802667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80266b:	85 d2                	test   %edx,%edx
  80266d:	75 49                	jne    8026b8 <__udivdi3+0x68>
  80266f:	39 f3                	cmp    %esi,%ebx
  802671:	76 15                	jbe    802688 <__udivdi3+0x38>
  802673:	31 ff                	xor    %edi,%edi
  802675:	89 e8                	mov    %ebp,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	f7 f3                	div    %ebx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	89 d9                	mov    %ebx,%ecx
  80268a:	85 db                	test   %ebx,%ebx
  80268c:	75 0b                	jne    802699 <__udivdi3+0x49>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f3                	div    %ebx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	31 d2                	xor    %edx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	f7 f1                	div    %ecx
  80269f:	89 c6                	mov    %eax,%esi
  8026a1:	89 e8                	mov    %ebp,%eax
  8026a3:	89 f7                	mov    %esi,%edi
  8026a5:	f7 f1                	div    %ecx
  8026a7:	89 fa                	mov    %edi,%edx
  8026a9:	83 c4 1c             	add    $0x1c,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
  8026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	39 f2                	cmp    %esi,%edx
  8026ba:	77 1c                	ja     8026d8 <__udivdi3+0x88>
  8026bc:	0f bd fa             	bsr    %edx,%edi
  8026bf:	83 f7 1f             	xor    $0x1f,%edi
  8026c2:	75 2c                	jne    8026f0 <__udivdi3+0xa0>
  8026c4:	39 f2                	cmp    %esi,%edx
  8026c6:	72 06                	jb     8026ce <__udivdi3+0x7e>
  8026c8:	31 c0                	xor    %eax,%eax
  8026ca:	39 eb                	cmp    %ebp,%ebx
  8026cc:	77 ad                	ja     80267b <__udivdi3+0x2b>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb a6                	jmp    80267b <__udivdi3+0x2b>
  8026d5:	8d 76 00             	lea    0x0(%esi),%esi
  8026d8:	31 ff                	xor    %edi,%edi
  8026da:	31 c0                	xor    %eax,%eax
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 2b ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 21 ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	f3 0f 1e fb          	endbr32 
  802764:	55                   	push   %ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 1c             	sub    $0x1c,%esp
  80276b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80276f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802773:	8b 74 24 30          	mov    0x30(%esp),%esi
  802777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277b:	89 da                	mov    %ebx,%edx
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 3f                	jne    8027c0 <__umoddi3+0x60>
  802781:	39 df                	cmp    %ebx,%edi
  802783:	76 13                	jbe    802798 <__umoddi3+0x38>
  802785:	89 f0                	mov    %esi,%eax
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	89 fd                	mov    %edi,%ebp
  80279a:	85 ff                	test   %edi,%edi
  80279c:	75 0b                	jne    8027a9 <__umoddi3+0x49>
  80279e:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f7                	div    %edi
  8027a7:	89 c5                	mov    %eax,%ebp
  8027a9:	89 d8                	mov    %ebx,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f5                	div    %ebp
  8027af:	89 f0                	mov    %esi,%eax
  8027b1:	f7 f5                	div    %ebp
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	eb d4                	jmp    80278b <__umoddi3+0x2b>
  8027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	89 f1                	mov    %esi,%ecx
  8027c2:	39 d8                	cmp    %ebx,%eax
  8027c4:	76 0a                	jbe    8027d0 <__umoddi3+0x70>
  8027c6:	89 f0                	mov    %esi,%eax
  8027c8:	83 c4 1c             	add    $0x1c,%esp
  8027cb:	5b                   	pop    %ebx
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	0f bd e8             	bsr    %eax,%ebp
  8027d3:	83 f5 1f             	xor    $0x1f,%ebp
  8027d6:	75 20                	jne    8027f8 <__umoddi3+0x98>
  8027d8:	39 d8                	cmp    %ebx,%eax
  8027da:	0f 82 b0 00 00 00    	jb     802890 <__umoddi3+0x130>
  8027e0:	39 f7                	cmp    %esi,%edi
  8027e2:	0f 86 a8 00 00 00    	jbe    802890 <__umoddi3+0x130>
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	83 c4 1c             	add    $0x1c,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ff:	29 ea                	sub    %ebp,%edx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 44 24 08          	mov    %eax,0x8(%esp)
  802807:	89 d1                	mov    %edx,%ecx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	d3 e8                	shr    %cl,%eax
  80280d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802811:	89 54 24 04          	mov    %edx,0x4(%esp)
  802815:	8b 54 24 04          	mov    0x4(%esp),%edx
  802819:	09 c1                	or     %eax,%ecx
  80281b:	89 d8                	mov    %ebx,%eax
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e7                	shl    %cl,%edi
  802825:	89 d1                	mov    %edx,%ecx
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80282f:	d3 e3                	shl    %cl,%ebx
  802831:	89 c7                	mov    %eax,%edi
  802833:	89 d1                	mov    %edx,%ecx
  802835:	89 f0                	mov    %esi,%eax
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 fa                	mov    %edi,%edx
  80283d:	d3 e6                	shl    %cl,%esi
  80283f:	09 d8                	or     %ebx,%eax
  802841:	f7 74 24 08          	divl   0x8(%esp)
  802845:	89 d1                	mov    %edx,%ecx
  802847:	89 f3                	mov    %esi,%ebx
  802849:	f7 64 24 0c          	mull   0xc(%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d7                	mov    %edx,%edi
  802851:	39 d1                	cmp    %edx,%ecx
  802853:	72 06                	jb     80285b <__umoddi3+0xfb>
  802855:	75 10                	jne    802867 <__umoddi3+0x107>
  802857:	39 c3                	cmp    %eax,%ebx
  802859:	73 0c                	jae    802867 <__umoddi3+0x107>
  80285b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80285f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802863:	89 d7                	mov    %edx,%edi
  802865:	89 c6                	mov    %eax,%esi
  802867:	89 ca                	mov    %ecx,%edx
  802869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286e:	29 f3                	sub    %esi,%ebx
  802870:	19 fa                	sbb    %edi,%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	d3 e0                	shl    %cl,%eax
  802876:	89 e9                	mov    %ebp,%ecx
  802878:	d3 eb                	shr    %cl,%ebx
  80287a:	d3 ea                	shr    %cl,%edx
  80287c:	09 d8                	or     %ebx,%eax
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	89 da                	mov    %ebx,%edx
  802892:	29 fe                	sub    %edi,%esi
  802894:	19 c2                	sbb    %eax,%edx
  802896:	89 f1                	mov    %esi,%ecx
  802898:	89 c8                	mov    %ecx,%eax
  80289a:	e9 4b ff ff ff       	jmp    8027ea <__umoddi3+0x8a>
