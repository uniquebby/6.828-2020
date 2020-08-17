
obj/user/faultdie.debug：     文件格式 elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 40 23 80 00       	push   $0x802340
  80004a:	e8 26 01 00 00       	call   800175 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 b1 0a 00 00       	call   800b05 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 68 0a 00 00       	call   800ac4 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 e2 0c 00 00       	call   800d53 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 75 0a 00 00       	call   800b05 <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cc:	e8 f7 0e 00 00       	call   800fc8 <close_all>
	sys_env_destroy(0);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 e9 09 00 00       	call   800ac4 <sys_env_destroy>
}
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ea:	8b 13                	mov    (%ebx),%edx
  8000ec:	8d 42 01             	lea    0x1(%edx),%eax
  8000ef:	89 03                	mov    %eax,(%ebx)
  8000f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fd:	74 09                	je     800108 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800106:	c9                   	leave  
  800107:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	68 ff 00 00 00       	push   $0xff
  800110:	8d 43 08             	lea    0x8(%ebx),%eax
  800113:	50                   	push   %eax
  800114:	e8 6e 09 00 00       	call   800a87 <sys_cputs>
		b->idx = 0;
  800119:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	eb db                	jmp    8000ff <putch+0x1f>

00800124 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800134:	00 00 00 
	b.cnt = 0;
  800137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014d:	50                   	push   %eax
  80014e:	68 e0 00 80 00       	push   $0x8000e0
  800153:	e8 19 01 00 00       	call   800271 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800161:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 1a 09 00 00       	call   800a87 <sys_cputs>

	return b.cnt;
}
  80016d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017e:	50                   	push   %eax
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	e8 9d ff ff ff       	call   800124 <vcprintf>
	va_end(ap);

	return cnt;
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    

00800189 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 1c             	sub    $0x1c,%esp
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 d6                	mov    %edx,%esi
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001b3:	89 d0                	mov    %edx,%eax
  8001b5:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001bb:	73 15                	jae    8001d2 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001bd:	83 eb 01             	sub    $0x1,%ebx
  8001c0:	85 db                	test   %ebx,%ebx
  8001c2:	7e 43                	jle    800207 <printnum+0x7e>
			putch(padc, putdat);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	56                   	push   %esi
  8001c8:	ff 75 18             	pushl  0x18(%ebp)
  8001cb:	ff d7                	call   *%edi
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb eb                	jmp    8001bd <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	ff 75 18             	pushl  0x18(%ebp)
  8001d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001de:	53                   	push   %ebx
  8001df:	ff 75 10             	pushl  0x10(%ebp)
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f1:	e8 fa 1e 00 00       	call   8020f0 <__udivdi3>
  8001f6:	83 c4 18             	add    $0x18,%esp
  8001f9:	52                   	push   %edx
  8001fa:	50                   	push   %eax
  8001fb:	89 f2                	mov    %esi,%edx
  8001fd:	89 f8                	mov    %edi,%eax
  8001ff:	e8 85 ff ff ff       	call   800189 <printnum>
  800204:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	56                   	push   %esi
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800211:	ff 75 e0             	pushl  -0x20(%ebp)
  800214:	ff 75 dc             	pushl  -0x24(%ebp)
  800217:	ff 75 d8             	pushl  -0x28(%ebp)
  80021a:	e8 e1 1f 00 00       	call   802200 <__umoddi3>
  80021f:	83 c4 14             	add    $0x14,%esp
  800222:	0f be 80 66 23 80 00 	movsbl 0x802366(%eax),%eax
  800229:	50                   	push   %eax
  80022a:	ff d7                	call   *%edi
}
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5f                   	pop    %edi
  800235:	5d                   	pop    %ebp
  800236:	c3                   	ret    

00800237 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80023d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800241:	8b 10                	mov    (%eax),%edx
  800243:	3b 50 04             	cmp    0x4(%eax),%edx
  800246:	73 0a                	jae    800252 <sprintputch+0x1b>
		*b->buf++ = ch;
  800248:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024b:	89 08                	mov    %ecx,(%eax)
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	88 02                	mov    %al,(%edx)
}
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    

00800254 <printfmt>:
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80025d:	50                   	push   %eax
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	ff 75 0c             	pushl  0xc(%ebp)
  800264:	ff 75 08             	pushl  0x8(%ebp)
  800267:	e8 05 00 00 00       	call   800271 <vprintfmt>
}
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <vprintfmt>:
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 3c             	sub    $0x3c,%esp
  80027a:	8b 75 08             	mov    0x8(%ebp),%esi
  80027d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800280:	8b 7d 10             	mov    0x10(%ebp),%edi
  800283:	eb 0a                	jmp    80028f <vprintfmt+0x1e>
			putch(ch, putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	53                   	push   %ebx
  800289:	50                   	push   %eax
  80028a:	ff d6                	call   *%esi
  80028c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80028f:	83 c7 01             	add    $0x1,%edi
  800292:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800296:	83 f8 25             	cmp    $0x25,%eax
  800299:	74 0c                	je     8002a7 <vprintfmt+0x36>
			if (ch == '\0')
  80029b:	85 c0                	test   %eax,%eax
  80029d:	75 e6                	jne    800285 <vprintfmt+0x14>
}
  80029f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a2:	5b                   	pop    %ebx
  8002a3:	5e                   	pop    %esi
  8002a4:	5f                   	pop    %edi
  8002a5:	5d                   	pop    %ebp
  8002a6:	c3                   	ret    
		padc = ' ';
  8002a7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002ab:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c5:	8d 47 01             	lea    0x1(%edi),%eax
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cb:	0f b6 17             	movzbl (%edi),%edx
  8002ce:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d1:	3c 55                	cmp    $0x55,%al
  8002d3:	0f 87 ba 03 00 00    	ja     800693 <vprintfmt+0x422>
  8002d9:	0f b6 c0             	movzbl %al,%eax
  8002dc:	ff 24 85 a0 24 80 00 	jmp    *0x8024a0(,%eax,4)
  8002e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ea:	eb d9                	jmp    8002c5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002f3:	eb d0                	jmp    8002c5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002f5:	0f b6 d2             	movzbl %dl,%edx
  8002f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800300:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800303:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800306:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80030d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800310:	83 f9 09             	cmp    $0x9,%ecx
  800313:	77 55                	ja     80036a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800315:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800318:	eb e9                	jmp    800303 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80031a:	8b 45 14             	mov    0x14(%ebp),%eax
  80031d:	8b 00                	mov    (%eax),%eax
  80031f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800322:	8b 45 14             	mov    0x14(%ebp),%eax
  800325:	8d 40 04             	lea    0x4(%eax),%eax
  800328:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800332:	79 91                	jns    8002c5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800334:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800337:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800341:	eb 82                	jmp    8002c5 <vprintfmt+0x54>
  800343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800346:	85 c0                	test   %eax,%eax
  800348:	ba 00 00 00 00       	mov    $0x0,%edx
  80034d:	0f 49 d0             	cmovns %eax,%edx
  800350:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800356:	e9 6a ff ff ff       	jmp    8002c5 <vprintfmt+0x54>
  80035b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800365:	e9 5b ff ff ff       	jmp    8002c5 <vprintfmt+0x54>
  80036a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80036d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800370:	eb bc                	jmp    80032e <vprintfmt+0xbd>
			lflag++;
  800372:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800378:	e9 48 ff ff ff       	jmp    8002c5 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80037d:	8b 45 14             	mov    0x14(%ebp),%eax
  800380:	8d 78 04             	lea    0x4(%eax),%edi
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	53                   	push   %ebx
  800387:	ff 30                	pushl  (%eax)
  800389:	ff d6                	call   *%esi
			break;
  80038b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800391:	e9 9c 02 00 00       	jmp    800632 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	8d 78 04             	lea    0x4(%eax),%edi
  80039c:	8b 00                	mov    (%eax),%eax
  80039e:	99                   	cltd   
  80039f:	31 d0                	xor    %edx,%eax
  8003a1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a3:	83 f8 0f             	cmp    $0xf,%eax
  8003a6:	7f 23                	jg     8003cb <vprintfmt+0x15a>
  8003a8:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  8003af:	85 d2                	test   %edx,%edx
  8003b1:	74 18                	je     8003cb <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003b3:	52                   	push   %edx
  8003b4:	68 5e 27 80 00       	push   $0x80275e
  8003b9:	53                   	push   %ebx
  8003ba:	56                   	push   %esi
  8003bb:	e8 94 fe ff ff       	call   800254 <printfmt>
  8003c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c6:	e9 67 02 00 00       	jmp    800632 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003cb:	50                   	push   %eax
  8003cc:	68 7e 23 80 00       	push   $0x80237e
  8003d1:	53                   	push   %ebx
  8003d2:	56                   	push   %esi
  8003d3:	e8 7c fe ff ff       	call   800254 <printfmt>
  8003d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003db:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003de:	e9 4f 02 00 00       	jmp    800632 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e6:	83 c0 04             	add    $0x4,%eax
  8003e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f1:	85 d2                	test   %edx,%edx
  8003f3:	b8 77 23 80 00       	mov    $0x802377,%eax
  8003f8:	0f 45 c2             	cmovne %edx,%eax
  8003fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800402:	7e 06                	jle    80040a <vprintfmt+0x199>
  800404:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800408:	75 0d                	jne    800417 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80040d:	89 c7                	mov    %eax,%edi
  80040f:	03 45 e0             	add    -0x20(%ebp),%eax
  800412:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800415:	eb 3f                	jmp    800456 <vprintfmt+0x1e5>
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	ff 75 d8             	pushl  -0x28(%ebp)
  80041d:	50                   	push   %eax
  80041e:	e8 0d 03 00 00       	call   800730 <strnlen>
  800423:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800426:	29 c2                	sub    %eax,%edx
  800428:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800430:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800437:	85 ff                	test   %edi,%edi
  800439:	7e 58                	jle    800493 <vprintfmt+0x222>
					putch(padc, putdat);
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	53                   	push   %ebx
  80043f:	ff 75 e0             	pushl  -0x20(%ebp)
  800442:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800444:	83 ef 01             	sub    $0x1,%edi
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	eb eb                	jmp    800437 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	53                   	push   %ebx
  800450:	52                   	push   %edx
  800451:	ff d6                	call   *%esi
  800453:	83 c4 10             	add    $0x10,%esp
  800456:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800459:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80045b:	83 c7 01             	add    $0x1,%edi
  80045e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800462:	0f be d0             	movsbl %al,%edx
  800465:	85 d2                	test   %edx,%edx
  800467:	74 45                	je     8004ae <vprintfmt+0x23d>
  800469:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80046d:	78 06                	js     800475 <vprintfmt+0x204>
  80046f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800473:	78 35                	js     8004aa <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800475:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800479:	74 d1                	je     80044c <vprintfmt+0x1db>
  80047b:	0f be c0             	movsbl %al,%eax
  80047e:	83 e8 20             	sub    $0x20,%eax
  800481:	83 f8 5e             	cmp    $0x5e,%eax
  800484:	76 c6                	jbe    80044c <vprintfmt+0x1db>
					putch('?', putdat);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	53                   	push   %ebx
  80048a:	6a 3f                	push   $0x3f
  80048c:	ff d6                	call   *%esi
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	eb c3                	jmp    800456 <vprintfmt+0x1e5>
  800493:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	0f 49 c2             	cmovns %edx,%eax
  8004a0:	29 c2                	sub    %eax,%edx
  8004a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a5:	e9 60 ff ff ff       	jmp    80040a <vprintfmt+0x199>
  8004aa:	89 cf                	mov    %ecx,%edi
  8004ac:	eb 02                	jmp    8004b0 <vprintfmt+0x23f>
  8004ae:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004b0:	85 ff                	test   %edi,%edi
  8004b2:	7e 10                	jle    8004c4 <vprintfmt+0x253>
				putch(' ', putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	53                   	push   %ebx
  8004b8:	6a 20                	push   $0x20
  8004ba:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004bc:	83 ef 01             	sub    $0x1,%edi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	eb ec                	jmp    8004b0 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 63 01 00 00       	jmp    800632 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004cf:	83 f9 01             	cmp    $0x1,%ecx
  8004d2:	7f 1b                	jg     8004ef <vprintfmt+0x27e>
	else if (lflag)
  8004d4:	85 c9                	test   %ecx,%ecx
  8004d6:	74 63                	je     80053b <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e0:	99                   	cltd   
  8004e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ed:	eb 17                	jmp    800506 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 50 04             	mov    0x4(%eax),%edx
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8d 40 08             	lea    0x8(%eax),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800506:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800509:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80050c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800511:	85 c9                	test   %ecx,%ecx
  800513:	0f 89 ff 00 00 00    	jns    800618 <vprintfmt+0x3a7>
				putch('-', putdat);
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	53                   	push   %ebx
  80051d:	6a 2d                	push   $0x2d
  80051f:	ff d6                	call   *%esi
				num = -(long long) num;
  800521:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800524:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800527:	f7 da                	neg    %edx
  800529:	83 d1 00             	adc    $0x0,%ecx
  80052c:	f7 d9                	neg    %ecx
  80052e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800531:	b8 0a 00 00 00       	mov    $0xa,%eax
  800536:	e9 dd 00 00 00       	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	99                   	cltd   
  800544:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	eb b4                	jmp    800506 <vprintfmt+0x295>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1e                	jg     800575 <vprintfmt+0x304>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 32                	je     80058d <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800570:	e9 a3 00 00 00       	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	8b 48 04             	mov    0x4(%eax),%ecx
  80057d:	8d 40 08             	lea    0x8(%eax),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800583:	b8 0a 00 00 00       	mov    $0xa,%eax
  800588:	e9 8b 00 00 00       	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	b9 00 00 00 00       	mov    $0x0,%ecx
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a2:	eb 74                	jmp    800618 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005a4:	83 f9 01             	cmp    $0x1,%ecx
  8005a7:	7f 1b                	jg     8005c4 <vprintfmt+0x353>
	else if (lflag)
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	74 2c                	je     8005d9 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c2:	eb 54                	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 10                	mov    (%eax),%edx
  8005c9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005cc:	8d 40 08             	lea    0x8(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d7:	eb 3f                	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 10                	mov    (%eax),%edx
  8005de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e3:	8d 40 04             	lea    0x4(%eax),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ee:	eb 28                	jmp    800618 <vprintfmt+0x3a7>
			putch('0', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 30                	push   $0x30
  8005f6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f8:	83 c4 08             	add    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	6a 78                	push   $0x78
  8005fe:	ff d6                	call   *%esi
			num = (unsigned long long)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 10                	mov    (%eax),%edx
  800605:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800613:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80061f:	57                   	push   %edi
  800620:	ff 75 e0             	pushl  -0x20(%ebp)
  800623:	50                   	push   %eax
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	89 da                	mov    %ebx,%edx
  800628:	89 f0                	mov    %esi,%eax
  80062a:	e8 5a fb ff ff       	call   800189 <printnum>
			break;
  80062f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800632:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800635:	e9 55 fc ff ff       	jmp    80028f <vprintfmt+0x1e>
	if (lflag >= 2)
  80063a:	83 f9 01             	cmp    $0x1,%ecx
  80063d:	7f 1b                	jg     80065a <vprintfmt+0x3e9>
	else if (lflag)
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	74 2c                	je     80066f <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 10                	mov    (%eax),%edx
  800648:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
  800658:	eb be                	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	8b 48 04             	mov    0x4(%eax),%ecx
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800668:	b8 10 00 00 00       	mov    $0x10,%eax
  80066d:	eb a9                	jmp    800618 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 10                	mov    (%eax),%edx
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067f:	b8 10 00 00 00       	mov    $0x10,%eax
  800684:	eb 92                	jmp    800618 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			break;
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb 9f                	jmp    800632 <vprintfmt+0x3c1>
			putch('%', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	6a 25                	push   $0x25
  800699:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 f8                	mov    %edi,%eax
  8006a0:	eb 03                	jmp    8006a5 <vprintfmt+0x434>
  8006a2:	83 e8 01             	sub    $0x1,%eax
  8006a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006a9:	75 f7                	jne    8006a2 <vprintfmt+0x431>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ae:	eb 82                	jmp    800632 <vprintfmt+0x3c1>

008006b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	74 26                	je     8006f7 <vsnprintf+0x47>
  8006d1:	85 d2                	test   %edx,%edx
  8006d3:	7e 22                	jle    8006f7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d5:	ff 75 14             	pushl  0x14(%ebp)
  8006d8:	ff 75 10             	pushl  0x10(%ebp)
  8006db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006de:	50                   	push   %eax
  8006df:	68 37 02 80 00       	push   $0x800237
  8006e4:	e8 88 fb ff ff       	call   800271 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    
		return -E_INVAL;
  8006f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fc:	eb f7                	jmp    8006f5 <vsnprintf+0x45>

008006fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800704:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800707:	50                   	push   %eax
  800708:	ff 75 10             	pushl  0x10(%ebp)
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	e8 9a ff ff ff       	call   8006b0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80071e:	b8 00 00 00 00       	mov    $0x0,%eax
  800723:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800727:	74 05                	je     80072e <strlen+0x16>
		n++;
  800729:	83 c0 01             	add    $0x1,%eax
  80072c:	eb f5                	jmp    800723 <strlen+0xb>
	return n;
}
  80072e:	5d                   	pop    %ebp
  80072f:	c3                   	ret    

00800730 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800736:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
  80073e:	39 c2                	cmp    %eax,%edx
  800740:	74 0d                	je     80074f <strnlen+0x1f>
  800742:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800746:	74 05                	je     80074d <strnlen+0x1d>
		n++;
  800748:	83 c2 01             	add    $0x1,%edx
  80074b:	eb f1                	jmp    80073e <strnlen+0xe>
  80074d:	89 d0                	mov    %edx,%eax
	return n;
}
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	53                   	push   %ebx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
  800760:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800764:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800767:	83 c2 01             	add    $0x1,%edx
  80076a:	84 c9                	test   %cl,%cl
  80076c:	75 f2                	jne    800760 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80076e:	5b                   	pop    %ebx
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	53                   	push   %ebx
  800775:	83 ec 10             	sub    $0x10,%esp
  800778:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80077b:	53                   	push   %ebx
  80077c:	e8 97 ff ff ff       	call   800718 <strlen>
  800781:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	01 d8                	add    %ebx,%eax
  800789:	50                   	push   %eax
  80078a:	e8 c2 ff ff ff       	call   800751 <strcpy>
	return dst;
}
  80078f:	89 d8                	mov    %ebx,%eax
  800791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	56                   	push   %esi
  80079a:	53                   	push   %ebx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a1:	89 c6                	mov    %eax,%esi
  8007a3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	39 f2                	cmp    %esi,%edx
  8007aa:	74 11                	je     8007bd <strncpy+0x27>
		*dst++ = *src;
  8007ac:	83 c2 01             	add    $0x1,%edx
  8007af:	0f b6 19             	movzbl (%ecx),%ebx
  8007b2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007b5:	80 fb 01             	cmp    $0x1,%bl
  8007b8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007bb:	eb eb                	jmp    8007a8 <strncpy+0x12>
	}
	return ret;
}
  8007bd:	5b                   	pop    %ebx
  8007be:	5e                   	pop    %esi
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8007cf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 21                	je     8007f6 <strlcpy+0x35>
  8007d5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007d9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007db:	39 c2                	cmp    %eax,%edx
  8007dd:	74 14                	je     8007f3 <strlcpy+0x32>
  8007df:	0f b6 19             	movzbl (%ecx),%ebx
  8007e2:	84 db                	test   %bl,%bl
  8007e4:	74 0b                	je     8007f1 <strlcpy+0x30>
			*dst++ = *src++;
  8007e6:	83 c1 01             	add    $0x1,%ecx
  8007e9:	83 c2 01             	add    $0x1,%edx
  8007ec:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ef:	eb ea                	jmp    8007db <strlcpy+0x1a>
  8007f1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f6:	29 f0                	sub    %esi,%eax
}
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800802:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800805:	0f b6 01             	movzbl (%ecx),%eax
  800808:	84 c0                	test   %al,%al
  80080a:	74 0c                	je     800818 <strcmp+0x1c>
  80080c:	3a 02                	cmp    (%edx),%al
  80080e:	75 08                	jne    800818 <strcmp+0x1c>
		p++, q++;
  800810:	83 c1 01             	add    $0x1,%ecx
  800813:	83 c2 01             	add    $0x1,%edx
  800816:	eb ed                	jmp    800805 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800818:	0f b6 c0             	movzbl %al,%eax
  80081b:	0f b6 12             	movzbl (%edx),%edx
  80081e:	29 d0                	sub    %edx,%eax
}
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	53                   	push   %ebx
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082c:	89 c3                	mov    %eax,%ebx
  80082e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800831:	eb 06                	jmp    800839 <strncmp+0x17>
		n--, p++, q++;
  800833:	83 c0 01             	add    $0x1,%eax
  800836:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800839:	39 d8                	cmp    %ebx,%eax
  80083b:	74 16                	je     800853 <strncmp+0x31>
  80083d:	0f b6 08             	movzbl (%eax),%ecx
  800840:	84 c9                	test   %cl,%cl
  800842:	74 04                	je     800848 <strncmp+0x26>
  800844:	3a 0a                	cmp    (%edx),%cl
  800846:	74 eb                	je     800833 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800848:	0f b6 00             	movzbl (%eax),%eax
  80084b:	0f b6 12             	movzbl (%edx),%edx
  80084e:	29 d0                	sub    %edx,%eax
}
  800850:	5b                   	pop    %ebx
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    
		return 0;
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	eb f6                	jmp    800850 <strncmp+0x2e>

0080085a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800864:	0f b6 10             	movzbl (%eax),%edx
  800867:	84 d2                	test   %dl,%dl
  800869:	74 09                	je     800874 <strchr+0x1a>
		if (*s == c)
  80086b:	38 ca                	cmp    %cl,%dl
  80086d:	74 0a                	je     800879 <strchr+0x1f>
	for (; *s; s++)
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	eb f0                	jmp    800864 <strchr+0xa>
			return (char *) s;
	return 0;
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800885:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800888:	38 ca                	cmp    %cl,%dl
  80088a:	74 09                	je     800895 <strfind+0x1a>
  80088c:	84 d2                	test   %dl,%dl
  80088e:	74 05                	je     800895 <strfind+0x1a>
	for (; *s; s++)
  800890:	83 c0 01             	add    $0x1,%eax
  800893:	eb f0                	jmp    800885 <strfind+0xa>
			break;
	return (char *) s;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	57                   	push   %edi
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008a3:	85 c9                	test   %ecx,%ecx
  8008a5:	74 31                	je     8008d8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008a7:	89 f8                	mov    %edi,%eax
  8008a9:	09 c8                	or     %ecx,%eax
  8008ab:	a8 03                	test   $0x3,%al
  8008ad:	75 23                	jne    8008d2 <memset+0x3b>
		c &= 0xFF;
  8008af:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008b3:	89 d3                	mov    %edx,%ebx
  8008b5:	c1 e3 08             	shl    $0x8,%ebx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 18             	shl    $0x18,%eax
  8008bd:	89 d6                	mov    %edx,%esi
  8008bf:	c1 e6 10             	shl    $0x10,%esi
  8008c2:	09 f0                	or     %esi,%eax
  8008c4:	09 c2                	or     %eax,%edx
  8008c6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008c8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008cb:	89 d0                	mov    %edx,%eax
  8008cd:	fc                   	cld    
  8008ce:	f3 ab                	rep stos %eax,%es:(%edi)
  8008d0:	eb 06                	jmp    8008d8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d5:	fc                   	cld    
  8008d6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008d8:	89 f8                	mov    %edi,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008ed:	39 c6                	cmp    %eax,%esi
  8008ef:	73 32                	jae    800923 <memmove+0x44>
  8008f1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008f4:	39 c2                	cmp    %eax,%edx
  8008f6:	76 2b                	jbe    800923 <memmove+0x44>
		s += n;
		d += n;
  8008f8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008fb:	89 fe                	mov    %edi,%esi
  8008fd:	09 ce                	or     %ecx,%esi
  8008ff:	09 d6                	or     %edx,%esi
  800901:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800907:	75 0e                	jne    800917 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800909:	83 ef 04             	sub    $0x4,%edi
  80090c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80090f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800912:	fd                   	std    
  800913:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800915:	eb 09                	jmp    800920 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800917:	83 ef 01             	sub    $0x1,%edi
  80091a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80091d:	fd                   	std    
  80091e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800920:	fc                   	cld    
  800921:	eb 1a                	jmp    80093d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800923:	89 c2                	mov    %eax,%edx
  800925:	09 ca                	or     %ecx,%edx
  800927:	09 f2                	or     %esi,%edx
  800929:	f6 c2 03             	test   $0x3,%dl
  80092c:	75 0a                	jne    800938 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80092e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800931:	89 c7                	mov    %eax,%edi
  800933:	fc                   	cld    
  800934:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800936:	eb 05                	jmp    80093d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800938:	89 c7                	mov    %eax,%edi
  80093a:	fc                   	cld    
  80093b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80093d:	5e                   	pop    %esi
  80093e:	5f                   	pop    %edi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800947:	ff 75 10             	pushl  0x10(%ebp)
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 8a ff ff ff       	call   8008df <memmove>
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	89 c6                	mov    %eax,%esi
  800964:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800967:	39 f0                	cmp    %esi,%eax
  800969:	74 1c                	je     800987 <memcmp+0x30>
		if (*s1 != *s2)
  80096b:	0f b6 08             	movzbl (%eax),%ecx
  80096e:	0f b6 1a             	movzbl (%edx),%ebx
  800971:	38 d9                	cmp    %bl,%cl
  800973:	75 08                	jne    80097d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800975:	83 c0 01             	add    $0x1,%eax
  800978:	83 c2 01             	add    $0x1,%edx
  80097b:	eb ea                	jmp    800967 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80097d:	0f b6 c1             	movzbl %cl,%eax
  800980:	0f b6 db             	movzbl %bl,%ebx
  800983:	29 d8                	sub    %ebx,%eax
  800985:	eb 05                	jmp    80098c <memcmp+0x35>
	}

	return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800999:	89 c2                	mov    %eax,%edx
  80099b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80099e:	39 d0                	cmp    %edx,%eax
  8009a0:	73 09                	jae    8009ab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a2:	38 08                	cmp    %cl,(%eax)
  8009a4:	74 05                	je     8009ab <memfind+0x1b>
	for (; s < ends; s++)
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	eb f3                	jmp    80099e <memfind+0xe>
			break;
	return (void *) s;
}
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	57                   	push   %edi
  8009b1:	56                   	push   %esi
  8009b2:	53                   	push   %ebx
  8009b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009b9:	eb 03                	jmp    8009be <strtol+0x11>
		s++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009be:	0f b6 01             	movzbl (%ecx),%eax
  8009c1:	3c 20                	cmp    $0x20,%al
  8009c3:	74 f6                	je     8009bb <strtol+0xe>
  8009c5:	3c 09                	cmp    $0x9,%al
  8009c7:	74 f2                	je     8009bb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009c9:	3c 2b                	cmp    $0x2b,%al
  8009cb:	74 2a                	je     8009f7 <strtol+0x4a>
	int neg = 0;
  8009cd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009d2:	3c 2d                	cmp    $0x2d,%al
  8009d4:	74 2b                	je     800a01 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009dc:	75 0f                	jne    8009ed <strtol+0x40>
  8009de:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e1:	74 28                	je     800a0b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009e3:	85 db                	test   %ebx,%ebx
  8009e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ea:	0f 44 d8             	cmove  %eax,%ebx
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f5:	eb 50                	jmp    800a47 <strtol+0x9a>
		s++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ff:	eb d5                	jmp    8009d6 <strtol+0x29>
		s++, neg = 1;
  800a01:	83 c1 01             	add    $0x1,%ecx
  800a04:	bf 01 00 00 00       	mov    $0x1,%edi
  800a09:	eb cb                	jmp    8009d6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a0f:	74 0e                	je     800a1f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a11:	85 db                	test   %ebx,%ebx
  800a13:	75 d8                	jne    8009ed <strtol+0x40>
		s++, base = 8;
  800a15:	83 c1 01             	add    $0x1,%ecx
  800a18:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a1d:	eb ce                	jmp    8009ed <strtol+0x40>
		s += 2, base = 16;
  800a1f:	83 c1 02             	add    $0x2,%ecx
  800a22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a27:	eb c4                	jmp    8009ed <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a2c:	89 f3                	mov    %esi,%ebx
  800a2e:	80 fb 19             	cmp    $0x19,%bl
  800a31:	77 29                	ja     800a5c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a33:	0f be d2             	movsbl %dl,%edx
  800a36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a39:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a3c:	7d 30                	jge    800a6e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a3e:	83 c1 01             	add    $0x1,%ecx
  800a41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a47:	0f b6 11             	movzbl (%ecx),%edx
  800a4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a4d:	89 f3                	mov    %esi,%ebx
  800a4f:	80 fb 09             	cmp    $0x9,%bl
  800a52:	77 d5                	ja     800a29 <strtol+0x7c>
			dig = *s - '0';
  800a54:	0f be d2             	movsbl %dl,%edx
  800a57:	83 ea 30             	sub    $0x30,%edx
  800a5a:	eb dd                	jmp    800a39 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a5f:	89 f3                	mov    %esi,%ebx
  800a61:	80 fb 19             	cmp    $0x19,%bl
  800a64:	77 08                	ja     800a6e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a66:	0f be d2             	movsbl %dl,%edx
  800a69:	83 ea 37             	sub    $0x37,%edx
  800a6c:	eb cb                	jmp    800a39 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a72:	74 05                	je     800a79 <strtol+0xcc>
		*endptr = (char *) s;
  800a74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	f7 da                	neg    %edx
  800a7d:	85 ff                	test   %edi,%edi
  800a7f:	0f 45 c2             	cmovne %edx,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 c3                	mov    %eax,%ebx
  800a9a:	89 c7                	mov    %eax,%edi
  800a9c:	89 c6                	mov    %eax,%esi
  800a9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5e                   	pop    %esi
  800aa2:	5f                   	pop    %edi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	57                   	push   %edi
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aab:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	89 d3                	mov    %edx,%ebx
  800ab9:	89 d7                	mov    %edx,%edi
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800acd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	b8 03 00 00 00       	mov    $0x3,%eax
  800ada:	89 cb                	mov    %ecx,%ebx
  800adc:	89 cf                	mov    %ecx,%edi
  800ade:	89 ce                	mov    %ecx,%esi
  800ae0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ae2:	85 c0                	test   %eax,%eax
  800ae4:	7f 08                	jg     800aee <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800aee:	83 ec 0c             	sub    $0xc,%esp
  800af1:	50                   	push   %eax
  800af2:	6a 03                	push   $0x3
  800af4:	68 5f 26 80 00       	push   $0x80265f
  800af9:	6a 23                	push   $0x23
  800afb:	68 7c 26 80 00       	push   $0x80267c
  800b00:	e8 4e 14 00 00       	call   801f53 <_panic>

00800b05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	b8 02 00 00 00       	mov    $0x2,%eax
  800b15:	89 d1                	mov    %edx,%ecx
  800b17:	89 d3                	mov    %edx,%ebx
  800b19:	89 d7                	mov    %edx,%edi
  800b1b:	89 d6                	mov    %edx,%esi
  800b1d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <sys_yield>:

void
sys_yield(void)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b34:	89 d1                	mov    %edx,%ecx
  800b36:	89 d3                	mov    %edx,%ebx
  800b38:	89 d7                	mov    %edx,%edi
  800b3a:	89 d6                	mov    %edx,%esi
  800b3c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b4c:	be 00 00 00 00       	mov    $0x0,%esi
  800b51:	8b 55 08             	mov    0x8(%ebp),%edx
  800b54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b57:	b8 04 00 00 00       	mov    $0x4,%eax
  800b5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b5f:	89 f7                	mov    %esi,%edi
  800b61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b63:	85 c0                	test   %eax,%eax
  800b65:	7f 08                	jg     800b6f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5f                   	pop    %edi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b6f:	83 ec 0c             	sub    $0xc,%esp
  800b72:	50                   	push   %eax
  800b73:	6a 04                	push   $0x4
  800b75:	68 5f 26 80 00       	push   $0x80265f
  800b7a:	6a 23                	push   $0x23
  800b7c:	68 7c 26 80 00       	push   $0x80267c
  800b81:	e8 cd 13 00 00       	call   801f53 <_panic>

00800b86 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b95:	b8 05 00 00 00       	mov    $0x5,%eax
  800b9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b9d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ba0:	8b 75 18             	mov    0x18(%ebp),%esi
  800ba3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	7f 08                	jg     800bb1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb1:	83 ec 0c             	sub    $0xc,%esp
  800bb4:	50                   	push   %eax
  800bb5:	6a 05                	push   $0x5
  800bb7:	68 5f 26 80 00       	push   $0x80265f
  800bbc:	6a 23                	push   $0x23
  800bbe:	68 7c 26 80 00       	push   $0x80267c
  800bc3:	e8 8b 13 00 00       	call   801f53 <_panic>

00800bc8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	b8 06 00 00 00       	mov    $0x6,%eax
  800be1:	89 df                	mov    %ebx,%edi
  800be3:	89 de                	mov    %ebx,%esi
  800be5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be7:	85 c0                	test   %eax,%eax
  800be9:	7f 08                	jg     800bf3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	50                   	push   %eax
  800bf7:	6a 06                	push   $0x6
  800bf9:	68 5f 26 80 00       	push   $0x80265f
  800bfe:	6a 23                	push   $0x23
  800c00:	68 7c 26 80 00       	push   $0x80267c
  800c05:	e8 49 13 00 00       	call   801f53 <_panic>

00800c0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	57                   	push   %edi
  800c0e:	56                   	push   %esi
  800c0f:	53                   	push   %ebx
  800c10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c23:	89 df                	mov    %ebx,%edi
  800c25:	89 de                	mov    %ebx,%esi
  800c27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	7f 08                	jg     800c35 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c35:	83 ec 0c             	sub    $0xc,%esp
  800c38:	50                   	push   %eax
  800c39:	6a 08                	push   $0x8
  800c3b:	68 5f 26 80 00       	push   $0x80265f
  800c40:	6a 23                	push   $0x23
  800c42:	68 7c 26 80 00       	push   $0x80267c
  800c47:	e8 07 13 00 00       	call   801f53 <_panic>

00800c4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	b8 09 00 00 00       	mov    $0x9,%eax
  800c65:	89 df                	mov    %ebx,%edi
  800c67:	89 de                	mov    %ebx,%esi
  800c69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	7f 08                	jg     800c77 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	83 ec 0c             	sub    $0xc,%esp
  800c7a:	50                   	push   %eax
  800c7b:	6a 09                	push   $0x9
  800c7d:	68 5f 26 80 00       	push   $0x80265f
  800c82:	6a 23                	push   $0x23
  800c84:	68 7c 26 80 00       	push   $0x80267c
  800c89:	e8 c5 12 00 00       	call   801f53 <_panic>

00800c8e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca7:	89 df                	mov    %ebx,%edi
  800ca9:	89 de                	mov    %ebx,%esi
  800cab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cad:	85 c0                	test   %eax,%eax
  800caf:	7f 08                	jg     800cb9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	50                   	push   %eax
  800cbd:	6a 0a                	push   $0xa
  800cbf:	68 5f 26 80 00       	push   $0x80265f
  800cc4:	6a 23                	push   $0x23
  800cc6:	68 7c 26 80 00       	push   $0x80267c
  800ccb:	e8 83 12 00 00       	call   801f53 <_panic>

00800cd0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ce1:	be 00 00 00 00       	mov    $0x0,%esi
  800ce6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cec:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d09:	89 cb                	mov    %ecx,%ebx
  800d0b:	89 cf                	mov    %ecx,%edi
  800d0d:	89 ce                	mov    %ecx,%esi
  800d0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 0d                	push   $0xd
  800d23:	68 5f 26 80 00       	push   $0x80265f
  800d28:	6a 23                	push   $0x23
  800d2a:	68 7c 26 80 00       	push   $0x80267c
  800d2f:	e8 1f 12 00 00       	call   801f53 <_panic>

00800d34 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d59:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800d60:	74 0a                	je     800d6c <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800d6c:	a1 08 40 80 00       	mov    0x804008,%eax
  800d71:	8b 40 48             	mov    0x48(%eax),%eax
  800d74:	83 ec 04             	sub    $0x4,%esp
  800d77:	6a 07                	push   $0x7
  800d79:	68 00 f0 bf ee       	push   $0xeebff000
  800d7e:	50                   	push   %eax
  800d7f:	e8 bf fd ff ff       	call   800b43 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	85 c0                	test   %eax,%eax
  800d89:	78 2c                	js     800db7 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800d8b:	e8 75 fd ff ff       	call   800b05 <sys_getenvid>
  800d90:	83 ec 08             	sub    $0x8,%esp
  800d93:	68 c9 0d 80 00       	push   $0x800dc9
  800d98:	50                   	push   %eax
  800d99:	e8 f0 fe ff ff       	call   800c8e <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	85 c0                	test   %eax,%eax
  800da3:	79 bd                	jns    800d62 <set_pgfault_handler+0xf>
  800da5:	50                   	push   %eax
  800da6:	68 8a 26 80 00       	push   $0x80268a
  800dab:	6a 23                	push   $0x23
  800dad:	68 a2 26 80 00       	push   $0x8026a2
  800db2:	e8 9c 11 00 00       	call   801f53 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800db7:	50                   	push   %eax
  800db8:	68 8a 26 80 00       	push   $0x80268a
  800dbd:	6a 21                	push   $0x21
  800dbf:	68 a2 26 80 00       	push   $0x8026a2
  800dc4:	e8 8a 11 00 00       	call   801f53 <_panic>

00800dc9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800dc9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800dca:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800dcf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800dd1:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  800dd4:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  800dd8:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  800ddb:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  800ddf:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  800de3:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800de6:	83 c4 08             	add    $0x8,%esp
	popal
  800de9:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800dea:	83 c4 04             	add    $0x4,%esp
	popfl
  800ded:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800dee:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800def:	c3                   	ret    

00800df0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	05 00 00 00 30       	add    $0x30000000,%eax
  800dfb:	c1 e8 0c             	shr    $0xc,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e10:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e1f:	89 c2                	mov    %eax,%edx
  800e21:	c1 ea 16             	shr    $0x16,%edx
  800e24:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e2b:	f6 c2 01             	test   $0x1,%dl
  800e2e:	74 2d                	je     800e5d <fd_alloc+0x46>
  800e30:	89 c2                	mov    %eax,%edx
  800e32:	c1 ea 0c             	shr    $0xc,%edx
  800e35:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e3c:	f6 c2 01             	test   $0x1,%dl
  800e3f:	74 1c                	je     800e5d <fd_alloc+0x46>
  800e41:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e46:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e4b:	75 d2                	jne    800e1f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e56:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e5b:	eb 0a                	jmp    800e67 <fd_alloc+0x50>
			*fd_store = fd;
  800e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e60:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e6f:	83 f8 1f             	cmp    $0x1f,%eax
  800e72:	77 30                	ja     800ea4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e74:	c1 e0 0c             	shl    $0xc,%eax
  800e77:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e7c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e82:	f6 c2 01             	test   $0x1,%dl
  800e85:	74 24                	je     800eab <fd_lookup+0x42>
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	c1 ea 0c             	shr    $0xc,%edx
  800e8c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e93:	f6 c2 01             	test   $0x1,%dl
  800e96:	74 1a                	je     800eb2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 02                	mov    %eax,(%edx)
	return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		return -E_INVAL;
  800ea4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea9:	eb f7                	jmp    800ea2 <fd_lookup+0x39>
		return -E_INVAL;
  800eab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb0:	eb f0                	jmp    800ea2 <fd_lookup+0x39>
  800eb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb7:	eb e9                	jmp    800ea2 <fd_lookup+0x39>

00800eb9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ec2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ecc:	39 08                	cmp    %ecx,(%eax)
  800ece:	74 38                	je     800f08 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800ed0:	83 c2 01             	add    $0x1,%edx
  800ed3:	8b 04 95 2c 27 80 00 	mov    0x80272c(,%edx,4),%eax
  800eda:	85 c0                	test   %eax,%eax
  800edc:	75 ee                	jne    800ecc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ede:	a1 08 40 80 00       	mov    0x804008,%eax
  800ee3:	8b 40 48             	mov    0x48(%eax),%eax
  800ee6:	83 ec 04             	sub    $0x4,%esp
  800ee9:	51                   	push   %ecx
  800eea:	50                   	push   %eax
  800eeb:	68 b0 26 80 00       	push   $0x8026b0
  800ef0:	e8 80 f2 ff ff       	call   800175 <cprintf>
	*dev = 0;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800efe:	83 c4 10             	add    $0x10,%esp
  800f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    
			*dev = devtab[i];
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	eb f2                	jmp    800f06 <dev_lookup+0x4d>

00800f14 <fd_close>:
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	83 ec 24             	sub    $0x24,%esp
  800f1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800f20:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f26:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f27:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f2d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f30:	50                   	push   %eax
  800f31:	e8 33 ff ff ff       	call   800e69 <fd_lookup>
  800f36:	89 c3                	mov    %eax,%ebx
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	78 05                	js     800f44 <fd_close+0x30>
	    || fd != fd2)
  800f3f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f42:	74 16                	je     800f5a <fd_close+0x46>
		return (must_exist ? r : 0);
  800f44:	89 f8                	mov    %edi,%eax
  800f46:	84 c0                	test   %al,%al
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4d:	0f 44 d8             	cmove  %eax,%ebx
}
  800f50:	89 d8                	mov    %ebx,%eax
  800f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f60:	50                   	push   %eax
  800f61:	ff 36                	pushl  (%esi)
  800f63:	e8 51 ff ff ff       	call   800eb9 <dev_lookup>
  800f68:	89 c3                	mov    %eax,%ebx
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	78 1a                	js     800f8b <fd_close+0x77>
		if (dev->dev_close)
  800f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f74:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f77:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 0b                	je     800f8b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	56                   	push   %esi
  800f84:	ff d0                	call   *%eax
  800f86:	89 c3                	mov    %eax,%ebx
  800f88:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f8b:	83 ec 08             	sub    $0x8,%esp
  800f8e:	56                   	push   %esi
  800f8f:	6a 00                	push   $0x0
  800f91:	e8 32 fc ff ff       	call   800bc8 <sys_page_unmap>
	return r;
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	eb b5                	jmp    800f50 <fd_close+0x3c>

00800f9b <close>:

int
close(int fdnum)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	ff 75 08             	pushl  0x8(%ebp)
  800fa8:	e8 bc fe ff ff       	call   800e69 <fd_lookup>
  800fad:	83 c4 10             	add    $0x10,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	79 02                	jns    800fb6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    
		return fd_close(fd, 1);
  800fb6:	83 ec 08             	sub    $0x8,%esp
  800fb9:	6a 01                	push   $0x1
  800fbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbe:	e8 51 ff ff ff       	call   800f14 <fd_close>
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	eb ec                	jmp    800fb4 <close+0x19>

00800fc8 <close_all>:

void
close_all(void)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	53                   	push   %ebx
  800fcc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	53                   	push   %ebx
  800fd8:	e8 be ff ff ff       	call   800f9b <close>
	for (i = 0; i < MAXFD; i++)
  800fdd:	83 c3 01             	add    $0x1,%ebx
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	83 fb 20             	cmp    $0x20,%ebx
  800fe6:	75 ec                	jne    800fd4 <close_all+0xc>
}
  800fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ff6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	ff 75 08             	pushl  0x8(%ebp)
  800ffd:	e8 67 fe ff ff       	call   800e69 <fd_lookup>
  801002:	89 c3                	mov    %eax,%ebx
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	85 c0                	test   %eax,%eax
  801009:	0f 88 81 00 00 00    	js     801090 <dup+0xa3>
		return r;
	close(newfdnum);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	e8 81 ff ff ff       	call   800f9b <close>

	newfd = INDEX2FD(newfdnum);
  80101a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80101d:	c1 e6 0c             	shl    $0xc,%esi
  801020:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801026:	83 c4 04             	add    $0x4,%esp
  801029:	ff 75 e4             	pushl  -0x1c(%ebp)
  80102c:	e8 cf fd ff ff       	call   800e00 <fd2data>
  801031:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801033:	89 34 24             	mov    %esi,(%esp)
  801036:	e8 c5 fd ff ff       	call   800e00 <fd2data>
  80103b:	83 c4 10             	add    $0x10,%esp
  80103e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801040:	89 d8                	mov    %ebx,%eax
  801042:	c1 e8 16             	shr    $0x16,%eax
  801045:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80104c:	a8 01                	test   $0x1,%al
  80104e:	74 11                	je     801061 <dup+0x74>
  801050:	89 d8                	mov    %ebx,%eax
  801052:	c1 e8 0c             	shr    $0xc,%eax
  801055:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80105c:	f6 c2 01             	test   $0x1,%dl
  80105f:	75 39                	jne    80109a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801064:	89 d0                	mov    %edx,%eax
  801066:	c1 e8 0c             	shr    $0xc,%eax
  801069:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	25 07 0e 00 00       	and    $0xe07,%eax
  801078:	50                   	push   %eax
  801079:	56                   	push   %esi
  80107a:	6a 00                	push   $0x0
  80107c:	52                   	push   %edx
  80107d:	6a 00                	push   $0x0
  80107f:	e8 02 fb ff ff       	call   800b86 <sys_page_map>
  801084:	89 c3                	mov    %eax,%ebx
  801086:	83 c4 20             	add    $0x20,%esp
  801089:	85 c0                	test   %eax,%eax
  80108b:	78 31                	js     8010be <dup+0xd1>
		goto err;

	return newfdnum;
  80108d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801090:	89 d8                	mov    %ebx,%eax
  801092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80109a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a9:	50                   	push   %eax
  8010aa:	57                   	push   %edi
  8010ab:	6a 00                	push   $0x0
  8010ad:	53                   	push   %ebx
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 d1 fa ff ff       	call   800b86 <sys_page_map>
  8010b5:	89 c3                	mov    %eax,%ebx
  8010b7:	83 c4 20             	add    $0x20,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	79 a3                	jns    801061 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	56                   	push   %esi
  8010c2:	6a 00                	push   $0x0
  8010c4:	e8 ff fa ff ff       	call   800bc8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010c9:	83 c4 08             	add    $0x8,%esp
  8010cc:	57                   	push   %edi
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 f4 fa ff ff       	call   800bc8 <sys_page_unmap>
	return r;
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	eb b7                	jmp    801090 <dup+0xa3>

008010d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	53                   	push   %ebx
  8010dd:	83 ec 1c             	sub    $0x1c,%esp
  8010e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	53                   	push   %ebx
  8010e8:	e8 7c fd ff ff       	call   800e69 <fd_lookup>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	78 3f                	js     801133 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010fa:	50                   	push   %eax
  8010fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fe:	ff 30                	pushl  (%eax)
  801100:	e8 b4 fd ff ff       	call   800eb9 <dev_lookup>
  801105:	83 c4 10             	add    $0x10,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	78 27                	js     801133 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80110c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80110f:	8b 42 08             	mov    0x8(%edx),%eax
  801112:	83 e0 03             	and    $0x3,%eax
  801115:	83 f8 01             	cmp    $0x1,%eax
  801118:	74 1e                	je     801138 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80111a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111d:	8b 40 08             	mov    0x8(%eax),%eax
  801120:	85 c0                	test   %eax,%eax
  801122:	74 35                	je     801159 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801124:	83 ec 04             	sub    $0x4,%esp
  801127:	ff 75 10             	pushl  0x10(%ebp)
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	52                   	push   %edx
  80112e:	ff d0                	call   *%eax
  801130:	83 c4 10             	add    $0x10,%esp
}
  801133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801136:	c9                   	leave  
  801137:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801138:	a1 08 40 80 00       	mov    0x804008,%eax
  80113d:	8b 40 48             	mov    0x48(%eax),%eax
  801140:	83 ec 04             	sub    $0x4,%esp
  801143:	53                   	push   %ebx
  801144:	50                   	push   %eax
  801145:	68 f1 26 80 00       	push   $0x8026f1
  80114a:	e8 26 f0 ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801157:	eb da                	jmp    801133 <read+0x5a>
		return -E_NOT_SUPP;
  801159:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80115e:	eb d3                	jmp    801133 <read+0x5a>

00801160 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 0c             	sub    $0xc,%esp
  801169:	8b 7d 08             	mov    0x8(%ebp),%edi
  80116c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	39 f3                	cmp    %esi,%ebx
  801176:	73 23                	jae    80119b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	89 f0                	mov    %esi,%eax
  80117d:	29 d8                	sub    %ebx,%eax
  80117f:	50                   	push   %eax
  801180:	89 d8                	mov    %ebx,%eax
  801182:	03 45 0c             	add    0xc(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	57                   	push   %edi
  801187:	e8 4d ff ff ff       	call   8010d9 <read>
		if (m < 0)
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	85 c0                	test   %eax,%eax
  801191:	78 06                	js     801199 <readn+0x39>
			return m;
		if (m == 0)
  801193:	74 06                	je     80119b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801195:	01 c3                	add    %eax,%ebx
  801197:	eb db                	jmp    801174 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801199:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80119b:	89 d8                	mov    %ebx,%eax
  80119d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a0:	5b                   	pop    %ebx
  8011a1:	5e                   	pop    %esi
  8011a2:	5f                   	pop    %edi
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 1c             	sub    $0x1c,%esp
  8011ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	53                   	push   %ebx
  8011b4:	e8 b0 fc ff ff       	call   800e69 <fd_lookup>
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	78 3a                	js     8011fa <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c0:	83 ec 08             	sub    $0x8,%esp
  8011c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c6:	50                   	push   %eax
  8011c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ca:	ff 30                	pushl  (%eax)
  8011cc:	e8 e8 fc ff ff       	call   800eb9 <dev_lookup>
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 22                	js     8011fa <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011db:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011df:	74 1e                	je     8011ff <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e4:	8b 52 0c             	mov    0xc(%edx),%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	74 35                	je     801220 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	ff 75 10             	pushl  0x10(%ebp)
  8011f1:	ff 75 0c             	pushl  0xc(%ebp)
  8011f4:	50                   	push   %eax
  8011f5:	ff d2                	call   *%edx
  8011f7:	83 c4 10             	add    $0x10,%esp
}
  8011fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011ff:	a1 08 40 80 00       	mov    0x804008,%eax
  801204:	8b 40 48             	mov    0x48(%eax),%eax
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	53                   	push   %ebx
  80120b:	50                   	push   %eax
  80120c:	68 0d 27 80 00       	push   $0x80270d
  801211:	e8 5f ef ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121e:	eb da                	jmp    8011fa <write+0x55>
		return -E_NOT_SUPP;
  801220:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801225:	eb d3                	jmp    8011fa <write+0x55>

00801227 <seek>:

int
seek(int fdnum, off_t offset)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80122d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801230:	50                   	push   %eax
  801231:	ff 75 08             	pushl  0x8(%ebp)
  801234:	e8 30 fc ff ff       	call   800e69 <fd_lookup>
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	78 0e                	js     80124e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801240:	8b 55 0c             	mov    0xc(%ebp),%edx
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	53                   	push   %ebx
  801254:	83 ec 1c             	sub    $0x1c,%esp
  801257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80125a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80125d:	50                   	push   %eax
  80125e:	53                   	push   %ebx
  80125f:	e8 05 fc ff ff       	call   800e69 <fd_lookup>
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	78 37                	js     8012a2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801271:	50                   	push   %eax
  801272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801275:	ff 30                	pushl  (%eax)
  801277:	e8 3d fc ff ff       	call   800eb9 <dev_lookup>
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	78 1f                	js     8012a2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801286:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80128a:	74 1b                	je     8012a7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80128c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128f:	8b 52 18             	mov    0x18(%edx),%edx
  801292:	85 d2                	test   %edx,%edx
  801294:	74 32                	je     8012c8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	50                   	push   %eax
  80129d:	ff d2                	call   *%edx
  80129f:	83 c4 10             	add    $0x10,%esp
}
  8012a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012a7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012ac:	8b 40 48             	mov    0x48(%eax),%eax
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	53                   	push   %ebx
  8012b3:	50                   	push   %eax
  8012b4:	68 d0 26 80 00       	push   $0x8026d0
  8012b9:	e8 b7 ee ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c6:	eb da                	jmp    8012a2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012cd:	eb d3                	jmp    8012a2 <ftruncate+0x52>

008012cf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	53                   	push   %ebx
  8012d3:	83 ec 1c             	sub    $0x1c,%esp
  8012d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012dc:	50                   	push   %eax
  8012dd:	ff 75 08             	pushl  0x8(%ebp)
  8012e0:	e8 84 fb ff ff       	call   800e69 <fd_lookup>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	78 4b                	js     801337 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f2:	50                   	push   %eax
  8012f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f6:	ff 30                	pushl  (%eax)
  8012f8:	e8 bc fb ff ff       	call   800eb9 <dev_lookup>
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	78 33                	js     801337 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801307:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80130b:	74 2f                	je     80133c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80130d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801310:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801317:	00 00 00 
	stat->st_isdir = 0;
  80131a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801321:	00 00 00 
	stat->st_dev = dev;
  801324:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	53                   	push   %ebx
  80132e:	ff 75 f0             	pushl  -0x10(%ebp)
  801331:	ff 50 14             	call   *0x14(%eax)
  801334:	83 c4 10             	add    $0x10,%esp
}
  801337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    
		return -E_NOT_SUPP;
  80133c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801341:	eb f4                	jmp    801337 <fstat+0x68>

00801343 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	56                   	push   %esi
  801347:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	6a 00                	push   $0x0
  80134d:	ff 75 08             	pushl  0x8(%ebp)
  801350:	e8 2f 02 00 00       	call   801584 <open>
  801355:	89 c3                	mov    %eax,%ebx
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 1b                	js     801379 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	50                   	push   %eax
  801365:	e8 65 ff ff ff       	call   8012cf <fstat>
  80136a:	89 c6                	mov    %eax,%esi
	close(fd);
  80136c:	89 1c 24             	mov    %ebx,(%esp)
  80136f:	e8 27 fc ff ff       	call   800f9b <close>
	return r;
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 f3                	mov    %esi,%ebx
}
  801379:	89 d8                	mov    %ebx,%eax
  80137b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    

00801382 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	56                   	push   %esi
  801386:	53                   	push   %ebx
  801387:	89 c6                	mov    %eax,%esi
  801389:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80138b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801392:	74 27                	je     8013bb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801394:	6a 07                	push   $0x7
  801396:	68 00 50 80 00       	push   $0x805000
  80139b:	56                   	push   %esi
  80139c:	ff 35 00 40 80 00    	pushl  0x804000
  8013a2:	e8 65 0c 00 00       	call   80200c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013a7:	83 c4 0c             	add    $0xc,%esp
  8013aa:	6a 00                	push   $0x0
  8013ac:	53                   	push   %ebx
  8013ad:	6a 00                	push   $0x0
  8013af:	e8 e5 0b 00 00       	call   801f99 <ipc_recv>
}
  8013b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	6a 01                	push   $0x1
  8013c0:	e8 b3 0c 00 00       	call   802078 <ipc_find_env>
  8013c5:	a3 00 40 80 00       	mov    %eax,0x804000
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	eb c5                	jmp    801394 <fsipc+0x12>

008013cf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8013f2:	e8 8b ff ff ff       	call   801382 <fsipc>
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <devfile_flush>:
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8b 40 0c             	mov    0xc(%eax),%eax
  801405:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80140a:	ba 00 00 00 00       	mov    $0x0,%edx
  80140f:	b8 06 00 00 00       	mov    $0x6,%eax
  801414:	e8 69 ff ff ff       	call   801382 <fsipc>
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <devfile_stat>:
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	53                   	push   %ebx
  80141f:	83 ec 04             	sub    $0x4,%esp
  801422:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8b 40 0c             	mov    0xc(%eax),%eax
  80142b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801430:	ba 00 00 00 00       	mov    $0x0,%edx
  801435:	b8 05 00 00 00       	mov    $0x5,%eax
  80143a:	e8 43 ff ff ff       	call   801382 <fsipc>
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 2c                	js     80146f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	68 00 50 80 00       	push   $0x805000
  80144b:	53                   	push   %ebx
  80144c:	e8 00 f3 ff ff       	call   800751 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801451:	a1 80 50 80 00       	mov    0x805080,%eax
  801456:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80145c:	a1 84 50 80 00       	mov    0x805084,%eax
  801461:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <devfile_write>:
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	53                   	push   %ebx
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80147e:	85 db                	test   %ebx,%ebx
  801480:	75 07                	jne    801489 <devfile_write+0x15>
	return n_all;
  801482:	89 d8                	mov    %ebx,%eax
}
  801484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801487:	c9                   	leave  
  801488:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8b 40 0c             	mov    0xc(%eax),%eax
  80148f:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801494:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	53                   	push   %ebx
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	68 08 50 80 00       	push   $0x805008
  8014a6:	e8 34 f4 ff ff       	call   8008df <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b0:	b8 04 00 00 00       	mov    $0x4,%eax
  8014b5:	e8 c8 fe ff ff       	call   801382 <fsipc>
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 c3                	js     801484 <devfile_write+0x10>
	  assert(r <= n_left);
  8014c1:	39 d8                	cmp    %ebx,%eax
  8014c3:	77 0b                	ja     8014d0 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8014c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014ca:	7f 1d                	jg     8014e9 <devfile_write+0x75>
    n_all += r;
  8014cc:	89 c3                	mov    %eax,%ebx
  8014ce:	eb b2                	jmp    801482 <devfile_write+0xe>
	  assert(r <= n_left);
  8014d0:	68 40 27 80 00       	push   $0x802740
  8014d5:	68 4c 27 80 00       	push   $0x80274c
  8014da:	68 9f 00 00 00       	push   $0x9f
  8014df:	68 61 27 80 00       	push   $0x802761
  8014e4:	e8 6a 0a 00 00       	call   801f53 <_panic>
	  assert(r <= PGSIZE);
  8014e9:	68 6c 27 80 00       	push   $0x80276c
  8014ee:	68 4c 27 80 00       	push   $0x80274c
  8014f3:	68 a0 00 00 00       	push   $0xa0
  8014f8:	68 61 27 80 00       	push   $0x802761
  8014fd:	e8 51 0a 00 00       	call   801f53 <_panic>

00801502 <devfile_read>:
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	56                   	push   %esi
  801506:	53                   	push   %ebx
  801507:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8b 40 0c             	mov    0xc(%eax),%eax
  801510:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801515:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80151b:	ba 00 00 00 00       	mov    $0x0,%edx
  801520:	b8 03 00 00 00       	mov    $0x3,%eax
  801525:	e8 58 fe ff ff       	call   801382 <fsipc>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 1f                	js     80154f <devfile_read+0x4d>
	assert(r <= n);
  801530:	39 f0                	cmp    %esi,%eax
  801532:	77 24                	ja     801558 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801534:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801539:	7f 33                	jg     80156e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	50                   	push   %eax
  80153f:	68 00 50 80 00       	push   $0x805000
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	e8 93 f3 ff ff       	call   8008df <memmove>
	return r;
  80154c:	83 c4 10             	add    $0x10,%esp
}
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
	assert(r <= n);
  801558:	68 78 27 80 00       	push   $0x802778
  80155d:	68 4c 27 80 00       	push   $0x80274c
  801562:	6a 7c                	push   $0x7c
  801564:	68 61 27 80 00       	push   $0x802761
  801569:	e8 e5 09 00 00       	call   801f53 <_panic>
	assert(r <= PGSIZE);
  80156e:	68 6c 27 80 00       	push   $0x80276c
  801573:	68 4c 27 80 00       	push   $0x80274c
  801578:	6a 7d                	push   $0x7d
  80157a:	68 61 27 80 00       	push   $0x802761
  80157f:	e8 cf 09 00 00       	call   801f53 <_panic>

00801584 <open>:
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	83 ec 1c             	sub    $0x1c,%esp
  80158c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80158f:	56                   	push   %esi
  801590:	e8 83 f1 ff ff       	call   800718 <strlen>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80159d:	7f 6c                	jg     80160b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	e8 6c f8 ff ff       	call   800e17 <fd_alloc>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 3c                	js     8015f0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	56                   	push   %esi
  8015b8:	68 00 50 80 00       	push   $0x805000
  8015bd:	e8 8f f1 ff ff       	call   800751 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d2:	e8 ab fd ff ff       	call   801382 <fsipc>
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 19                	js     8015f9 <open+0x75>
	return fd2num(fd);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e6:	e8 05 f8 ff ff       	call   800df0 <fd2num>
  8015eb:	89 c3                	mov    %eax,%ebx
  8015ed:	83 c4 10             	add    $0x10,%esp
}
  8015f0:	89 d8                	mov    %ebx,%eax
  8015f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    
		fd_close(fd, 0);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	6a 00                	push   $0x0
  8015fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801601:	e8 0e f9 ff ff       	call   800f14 <fd_close>
		return r;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	eb e5                	jmp    8015f0 <open+0x6c>
		return -E_BAD_PATH;
  80160b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801610:	eb de                	jmp    8015f0 <open+0x6c>

00801612 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 08 00 00 00       	mov    $0x8,%eax
  801622:	e8 5b fd ff ff       	call   801382 <fsipc>
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	56                   	push   %esi
  80162d:	53                   	push   %ebx
  80162e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	e8 c4 f7 ff ff       	call   800e00 <fd2data>
  80163c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80163e:	83 c4 08             	add    $0x8,%esp
  801641:	68 7f 27 80 00       	push   $0x80277f
  801646:	53                   	push   %ebx
  801647:	e8 05 f1 ff ff       	call   800751 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80164c:	8b 46 04             	mov    0x4(%esi),%eax
  80164f:	2b 06                	sub    (%esi),%eax
  801651:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801657:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80165e:	00 00 00 
	stat->st_dev = &devpipe;
  801661:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801668:	30 80 00 
	return 0;
}
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	53                   	push   %ebx
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801681:	53                   	push   %ebx
  801682:	6a 00                	push   $0x0
  801684:	e8 3f f5 ff ff       	call   800bc8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801689:	89 1c 24             	mov    %ebx,(%esp)
  80168c:	e8 6f f7 ff ff       	call   800e00 <fd2data>
  801691:	83 c4 08             	add    $0x8,%esp
  801694:	50                   	push   %eax
  801695:	6a 00                	push   $0x0
  801697:	e8 2c f5 ff ff       	call   800bc8 <sys_page_unmap>
}
  80169c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <_pipeisclosed>:
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	57                   	push   %edi
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 1c             	sub    $0x1c,%esp
  8016aa:	89 c7                	mov    %eax,%edi
  8016ac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8016b3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	57                   	push   %edi
  8016ba:	e8 f2 09 00 00       	call   8020b1 <pageref>
  8016bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c2:	89 34 24             	mov    %esi,(%esp)
  8016c5:	e8 e7 09 00 00       	call   8020b1 <pageref>
		nn = thisenv->env_runs;
  8016ca:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016d0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	39 cb                	cmp    %ecx,%ebx
  8016d8:	74 1b                	je     8016f5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016dd:	75 cf                	jne    8016ae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016df:	8b 42 58             	mov    0x58(%edx),%eax
  8016e2:	6a 01                	push   $0x1
  8016e4:	50                   	push   %eax
  8016e5:	53                   	push   %ebx
  8016e6:	68 86 27 80 00       	push   $0x802786
  8016eb:	e8 85 ea ff ff       	call   800175 <cprintf>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	eb b9                	jmp    8016ae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016f8:	0f 94 c0             	sete   %al
  8016fb:	0f b6 c0             	movzbl %al,%eax
}
  8016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <devpipe_write>:
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	57                   	push   %edi
  80170a:	56                   	push   %esi
  80170b:	53                   	push   %ebx
  80170c:	83 ec 28             	sub    $0x28,%esp
  80170f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801712:	56                   	push   %esi
  801713:	e8 e8 f6 ff ff       	call   800e00 <fd2data>
  801718:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	bf 00 00 00 00       	mov    $0x0,%edi
  801722:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801725:	74 4f                	je     801776 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801727:	8b 43 04             	mov    0x4(%ebx),%eax
  80172a:	8b 0b                	mov    (%ebx),%ecx
  80172c:	8d 51 20             	lea    0x20(%ecx),%edx
  80172f:	39 d0                	cmp    %edx,%eax
  801731:	72 14                	jb     801747 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801733:	89 da                	mov    %ebx,%edx
  801735:	89 f0                	mov    %esi,%eax
  801737:	e8 65 ff ff ff       	call   8016a1 <_pipeisclosed>
  80173c:	85 c0                	test   %eax,%eax
  80173e:	75 3b                	jne    80177b <devpipe_write+0x75>
			sys_yield();
  801740:	e8 df f3 ff ff       	call   800b24 <sys_yield>
  801745:	eb e0                	jmp    801727 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801747:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80174e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801751:	89 c2                	mov    %eax,%edx
  801753:	c1 fa 1f             	sar    $0x1f,%edx
  801756:	89 d1                	mov    %edx,%ecx
  801758:	c1 e9 1b             	shr    $0x1b,%ecx
  80175b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80175e:	83 e2 1f             	and    $0x1f,%edx
  801761:	29 ca                	sub    %ecx,%edx
  801763:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801767:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80176b:	83 c0 01             	add    $0x1,%eax
  80176e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801771:	83 c7 01             	add    $0x1,%edi
  801774:	eb ac                	jmp    801722 <devpipe_write+0x1c>
	return i;
  801776:	8b 45 10             	mov    0x10(%ebp),%eax
  801779:	eb 05                	jmp    801780 <devpipe_write+0x7a>
				return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <devpipe_read>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	83 ec 18             	sub    $0x18,%esp
  801791:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801794:	57                   	push   %edi
  801795:	e8 66 f6 ff ff       	call   800e00 <fd2data>
  80179a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	be 00 00 00 00       	mov    $0x0,%esi
  8017a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017a7:	75 14                	jne    8017bd <devpipe_read+0x35>
	return i;
  8017a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ac:	eb 02                	jmp    8017b0 <devpipe_read+0x28>
				return i;
  8017ae:	89 f0                	mov    %esi,%eax
}
  8017b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
			sys_yield();
  8017b8:	e8 67 f3 ff ff       	call   800b24 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017bd:	8b 03                	mov    (%ebx),%eax
  8017bf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017c2:	75 18                	jne    8017dc <devpipe_read+0x54>
			if (i > 0)
  8017c4:	85 f6                	test   %esi,%esi
  8017c6:	75 e6                	jne    8017ae <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8017c8:	89 da                	mov    %ebx,%edx
  8017ca:	89 f8                	mov    %edi,%eax
  8017cc:	e8 d0 fe ff ff       	call   8016a1 <_pipeisclosed>
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	74 e3                	je     8017b8 <devpipe_read+0x30>
				return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	eb d4                	jmp    8017b0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017dc:	99                   	cltd   
  8017dd:	c1 ea 1b             	shr    $0x1b,%edx
  8017e0:	01 d0                	add    %edx,%eax
  8017e2:	83 e0 1f             	and    $0x1f,%eax
  8017e5:	29 d0                	sub    %edx,%eax
  8017e7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ef:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017f2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017f5:	83 c6 01             	add    $0x1,%esi
  8017f8:	eb aa                	jmp    8017a4 <devpipe_read+0x1c>

008017fa <pipe>:
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801802:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801805:	50                   	push   %eax
  801806:	e8 0c f6 ff ff       	call   800e17 <fd_alloc>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	0f 88 23 01 00 00    	js     80193b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	68 07 04 00 00       	push   $0x407
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	6a 00                	push   $0x0
  801825:	e8 19 f3 ff ff       	call   800b43 <sys_page_alloc>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	0f 88 04 01 00 00    	js     80193b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183d:	50                   	push   %eax
  80183e:	e8 d4 f5 ff ff       	call   800e17 <fd_alloc>
  801843:	89 c3                	mov    %eax,%ebx
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	85 c0                	test   %eax,%eax
  80184a:	0f 88 db 00 00 00    	js     80192b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 07 04 00 00       	push   $0x407
  801858:	ff 75 f0             	pushl  -0x10(%ebp)
  80185b:	6a 00                	push   $0x0
  80185d:	e8 e1 f2 ff ff       	call   800b43 <sys_page_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	0f 88 bc 00 00 00    	js     80192b <pipe+0x131>
	va = fd2data(fd0);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 f4             	pushl  -0xc(%ebp)
  801875:	e8 86 f5 ff ff       	call   800e00 <fd2data>
  80187a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80187c:	83 c4 0c             	add    $0xc,%esp
  80187f:	68 07 04 00 00       	push   $0x407
  801884:	50                   	push   %eax
  801885:	6a 00                	push   $0x0
  801887:	e8 b7 f2 ff ff       	call   800b43 <sys_page_alloc>
  80188c:	89 c3                	mov    %eax,%ebx
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	85 c0                	test   %eax,%eax
  801893:	0f 88 82 00 00 00    	js     80191b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	ff 75 f0             	pushl  -0x10(%ebp)
  80189f:	e8 5c f5 ff ff       	call   800e00 <fd2data>
  8018a4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018ab:	50                   	push   %eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	56                   	push   %esi
  8018af:	6a 00                	push   $0x0
  8018b1:	e8 d0 f2 ff ff       	call   800b86 <sys_page_map>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 20             	add    $0x20,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 4e                	js     80190d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8018bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018db:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e8:	e8 03 f5 ff ff       	call   800df0 <fd2num>
  8018ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018f2:	83 c4 04             	add    $0x4,%esp
  8018f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f8:	e8 f3 f4 ff ff       	call   800df0 <fd2num>
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190b:	eb 2e                	jmp    80193b <pipe+0x141>
	sys_page_unmap(0, va);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	56                   	push   %esi
  801911:	6a 00                	push   $0x0
  801913:	e8 b0 f2 ff ff       	call   800bc8 <sys_page_unmap>
  801918:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	ff 75 f0             	pushl  -0x10(%ebp)
  801921:	6a 00                	push   $0x0
  801923:	e8 a0 f2 ff ff       	call   800bc8 <sys_page_unmap>
  801928:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	ff 75 f4             	pushl  -0xc(%ebp)
  801931:	6a 00                	push   $0x0
  801933:	e8 90 f2 ff ff       	call   800bc8 <sys_page_unmap>
  801938:	83 c4 10             	add    $0x10,%esp
}
  80193b:	89 d8                	mov    %ebx,%eax
  80193d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <pipeisclosed>:
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194d:	50                   	push   %eax
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	e8 13 f5 ff ff       	call   800e69 <fd_lookup>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 18                	js     801975 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	ff 75 f4             	pushl  -0xc(%ebp)
  801963:	e8 98 f4 ff ff       	call   800e00 <fd2data>
	return _pipeisclosed(fd, p);
  801968:	89 c2                	mov    %eax,%edx
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	e8 2f fd ff ff       	call   8016a1 <_pipeisclosed>
  801972:	83 c4 10             	add    $0x10,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80197d:	68 9e 27 80 00       	push   $0x80279e
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	e8 c7 ed ff ff       	call   800751 <strcpy>
	return 0;
}
  80198a:	b8 00 00 00 00       	mov    $0x0,%eax
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <devsock_close>:
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	53                   	push   %ebx
  801995:	83 ec 10             	sub    $0x10,%esp
  801998:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80199b:	53                   	push   %ebx
  80199c:	e8 10 07 00 00       	call   8020b1 <pageref>
  8019a1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019a4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019a9:	83 f8 01             	cmp    $0x1,%eax
  8019ac:	74 07                	je     8019b5 <devsock_close+0x24>
}
  8019ae:	89 d0                	mov    %edx,%eax
  8019b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	ff 73 0c             	pushl  0xc(%ebx)
  8019bb:	e8 b9 02 00 00       	call   801c79 <nsipc_close>
  8019c0:	89 c2                	mov    %eax,%edx
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	eb e7                	jmp    8019ae <devsock_close+0x1d>

008019c7 <devsock_write>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	ff 70 0c             	pushl  0xc(%eax)
  8019db:	e8 76 03 00 00       	call   801d56 <nsipc_send>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <devsock_read>:
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	ff 75 10             	pushl  0x10(%ebp)
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	ff 70 0c             	pushl  0xc(%eax)
  8019f6:	e8 ef 02 00 00       	call   801cea <nsipc_recv>
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <fd2sockid>:
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a03:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	e8 5c f4 ff ff       	call   800e69 <fd_lookup>
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 10                	js     801a24 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a1d:	39 08                	cmp    %ecx,(%eax)
  801a1f:	75 05                	jne    801a26 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a21:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    
		return -E_NOT_SUPP;
  801a26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2b:	eb f7                	jmp    801a24 <fd2sockid+0x27>

00801a2d <alloc_sockfd>:
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 1c             	sub    $0x1c,%esp
  801a35:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3a:	50                   	push   %eax
  801a3b:	e8 d7 f3 ff ff       	call   800e17 <fd_alloc>
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 43                	js     801a8c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 07 04 00 00       	push   $0x407
  801a51:	ff 75 f4             	pushl  -0xc(%ebp)
  801a54:	6a 00                	push   $0x0
  801a56:	e8 e8 f0 ff ff       	call   800b43 <sys_page_alloc>
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 28                	js     801a8c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a67:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a79:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a7c:	83 ec 0c             	sub    $0xc,%esp
  801a7f:	50                   	push   %eax
  801a80:	e8 6b f3 ff ff       	call   800df0 <fd2num>
  801a85:	89 c3                	mov    %eax,%ebx
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	eb 0c                	jmp    801a98 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a8c:	83 ec 0c             	sub    $0xc,%esp
  801a8f:	56                   	push   %esi
  801a90:	e8 e4 01 00 00       	call   801c79 <nsipc_close>
		return r;
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <accept>:
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	e8 4e ff ff ff       	call   8019fd <fd2sockid>
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 1b                	js     801ace <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	ff 75 10             	pushl  0x10(%ebp)
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	e8 0e 01 00 00       	call   801bd0 <nsipc_accept>
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	78 05                	js     801ace <accept+0x2d>
	return alloc_sockfd(r);
  801ac9:	e8 5f ff ff ff       	call   801a2d <alloc_sockfd>
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <bind>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	e8 1f ff ff ff       	call   8019fd <fd2sockid>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 12                	js     801af4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	e8 31 01 00 00       	call   801c22 <nsipc_bind>
  801af1:	83 c4 10             	add    $0x10,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <shutdown>:
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	e8 f9 fe ff ff       	call   8019fd <fd2sockid>
  801b04:	85 c0                	test   %eax,%eax
  801b06:	78 0f                	js     801b17 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b08:	83 ec 08             	sub    $0x8,%esp
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	50                   	push   %eax
  801b0f:	e8 43 01 00 00       	call   801c57 <nsipc_shutdown>
  801b14:	83 c4 10             	add    $0x10,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <connect>:
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	e8 d6 fe ff ff       	call   8019fd <fd2sockid>
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 12                	js     801b3d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b2b:	83 ec 04             	sub    $0x4,%esp
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	50                   	push   %eax
  801b35:	e8 59 01 00 00       	call   801c93 <nsipc_connect>
  801b3a:	83 c4 10             	add    $0x10,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <listen>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	e8 b0 fe ff ff       	call   8019fd <fd2sockid>
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 0f                	js     801b60 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b51:	83 ec 08             	sub    $0x8,%esp
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	50                   	push   %eax
  801b58:	e8 6b 01 00 00       	call   801cc8 <nsipc_listen>
  801b5d:	83 c4 10             	add    $0x10,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b68:	ff 75 10             	pushl  0x10(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	e8 3e 02 00 00       	call   801db4 <nsipc_socket>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 05                	js     801b82 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b7d:	e8 ab fe ff ff       	call   801a2d <alloc_sockfd>
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b8d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b94:	74 26                	je     801bbc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b96:	6a 07                	push   $0x7
  801b98:	68 00 60 80 00       	push   $0x806000
  801b9d:	53                   	push   %ebx
  801b9e:	ff 35 04 40 80 00    	pushl  0x804004
  801ba4:	e8 63 04 00 00       	call   80200c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ba9:	83 c4 0c             	add    $0xc,%esp
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	e8 e2 03 00 00       	call   801f99 <ipc_recv>
}
  801bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bbc:	83 ec 0c             	sub    $0xc,%esp
  801bbf:	6a 02                	push   $0x2
  801bc1:	e8 b2 04 00 00       	call   802078 <ipc_find_env>
  801bc6:	a3 04 40 80 00       	mov    %eax,0x804004
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	eb c6                	jmp    801b96 <nsipc+0x12>

00801bd0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801be0:	8b 06                	mov    (%esi),%eax
  801be2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801be7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bec:	e8 93 ff ff ff       	call   801b84 <nsipc>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	79 09                	jns    801c00 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bf7:	89 d8                	mov    %ebx,%eax
  801bf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	ff 35 10 60 80 00    	pushl  0x806010
  801c09:	68 00 60 80 00       	push   $0x806000
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	e8 c9 ec ff ff       	call   8008df <memmove>
		*addrlen = ret->ret_addrlen;
  801c16:	a1 10 60 80 00       	mov    0x806010,%eax
  801c1b:	89 06                	mov    %eax,(%esi)
  801c1d:	83 c4 10             	add    $0x10,%esp
	return r;
  801c20:	eb d5                	jmp    801bf7 <nsipc_accept+0x27>

00801c22 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	53                   	push   %ebx
  801c26:	83 ec 08             	sub    $0x8,%esp
  801c29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c34:	53                   	push   %ebx
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	68 04 60 80 00       	push   $0x806004
  801c3d:	e8 9d ec ff ff       	call   8008df <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c42:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c48:	b8 02 00 00 00       	mov    $0x2,%eax
  801c4d:	e8 32 ff ff ff       	call   801b84 <nsipc>
}
  801c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c68:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c6d:	b8 03 00 00 00       	mov    $0x3,%eax
  801c72:	e8 0d ff ff ff       	call   801b84 <nsipc>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <nsipc_close>:

int
nsipc_close(int s)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c87:	b8 04 00 00 00       	mov    $0x4,%eax
  801c8c:	e8 f3 fe ff ff       	call   801b84 <nsipc>
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	53                   	push   %ebx
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ca5:	53                   	push   %ebx
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	68 04 60 80 00       	push   $0x806004
  801cae:	e8 2c ec ff ff       	call   8008df <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cb3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cb9:	b8 05 00 00 00       	mov    $0x5,%eax
  801cbe:	e8 c1 fe ff ff       	call   801b84 <nsipc>
}
  801cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cde:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce3:	e8 9c fe ff ff       	call   801b84 <nsipc>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	56                   	push   %esi
  801cee:	53                   	push   %ebx
  801cef:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cfa:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d08:	b8 07 00 00 00       	mov    $0x7,%eax
  801d0d:	e8 72 fe ff ff       	call   801b84 <nsipc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 1f                	js     801d37 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d18:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d1d:	7f 21                	jg     801d40 <nsipc_recv+0x56>
  801d1f:	39 c6                	cmp    %eax,%esi
  801d21:	7c 1d                	jl     801d40 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	50                   	push   %eax
  801d27:	68 00 60 80 00       	push   $0x806000
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	e8 ab eb ff ff       	call   8008df <memmove>
  801d34:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5e                   	pop    %esi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d40:	68 aa 27 80 00       	push   $0x8027aa
  801d45:	68 4c 27 80 00       	push   $0x80274c
  801d4a:	6a 62                	push   $0x62
  801d4c:	68 bf 27 80 00       	push   $0x8027bf
  801d51:	e8 fd 01 00 00       	call   801f53 <_panic>

00801d56 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d68:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d6e:	7f 2e                	jg     801d9e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	53                   	push   %ebx
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	68 0c 60 80 00       	push   $0x80600c
  801d7c:	e8 5e eb ff ff       	call   8008df <memmove>
	nsipcbuf.send.req_size = size;
  801d81:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d87:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d8f:	b8 08 00 00 00       	mov    $0x8,%eax
  801d94:	e8 eb fd ff ff       	call   801b84 <nsipc>
}
  801d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    
	assert(size < 1600);
  801d9e:	68 cb 27 80 00       	push   $0x8027cb
  801da3:	68 4c 27 80 00       	push   $0x80274c
  801da8:	6a 6d                	push   $0x6d
  801daa:	68 bf 27 80 00       	push   $0x8027bf
  801daf:	e8 9f 01 00 00       	call   801f53 <_panic>

00801db4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dca:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dd2:	b8 09 00 00 00       	mov    $0x9,%eax
  801dd7:	e8 a8 fd ff ff       	call   801b84 <nsipc>
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	c3                   	ret    

00801de4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dea:	68 d7 27 80 00       	push   $0x8027d7
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	e8 5a e9 ff ff       	call   800751 <strcpy>
	return 0;
}
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <devcons_write>:
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	57                   	push   %edi
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e0a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e0f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e15:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e18:	73 31                	jae    801e4b <devcons_write+0x4d>
		m = n - tot;
  801e1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e1d:	29 f3                	sub    %esi,%ebx
  801e1f:	83 fb 7f             	cmp    $0x7f,%ebx
  801e22:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e27:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	53                   	push   %ebx
  801e2e:	89 f0                	mov    %esi,%eax
  801e30:	03 45 0c             	add    0xc(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	57                   	push   %edi
  801e35:	e8 a5 ea ff ff       	call   8008df <memmove>
		sys_cputs(buf, m);
  801e3a:	83 c4 08             	add    $0x8,%esp
  801e3d:	53                   	push   %ebx
  801e3e:	57                   	push   %edi
  801e3f:	e8 43 ec ff ff       	call   800a87 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e44:	01 de                	add    %ebx,%esi
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	eb ca                	jmp    801e15 <devcons_write+0x17>
}
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5f                   	pop    %edi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    

00801e55 <devcons_read>:
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e64:	74 21                	je     801e87 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801e66:	e8 3a ec ff ff       	call   800aa5 <sys_cgetc>
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	75 07                	jne    801e76 <devcons_read+0x21>
		sys_yield();
  801e6f:	e8 b0 ec ff ff       	call   800b24 <sys_yield>
  801e74:	eb f0                	jmp    801e66 <devcons_read+0x11>
	if (c < 0)
  801e76:	78 0f                	js     801e87 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801e78:	83 f8 04             	cmp    $0x4,%eax
  801e7b:	74 0c                	je     801e89 <devcons_read+0x34>
	*(char*)vbuf = c;
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	88 02                	mov    %al,(%edx)
	return 1;
  801e82:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    
		return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb f7                	jmp    801e87 <devcons_read+0x32>

00801e90 <cputchar>:
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e9c:	6a 01                	push   $0x1
  801e9e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea1:	50                   	push   %eax
  801ea2:	e8 e0 eb ff ff       	call   800a87 <sys_cputs>
}
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <getchar>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801eb2:	6a 01                	push   $0x1
  801eb4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eb7:	50                   	push   %eax
  801eb8:	6a 00                	push   $0x0
  801eba:	e8 1a f2 ff ff       	call   8010d9 <read>
	if (r < 0)
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 06                	js     801ecc <getchar+0x20>
	if (r < 1)
  801ec6:	74 06                	je     801ece <getchar+0x22>
	return c;
  801ec8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    
		return -E_EOF;
  801ece:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ed3:	eb f7                	jmp    801ecc <getchar+0x20>

00801ed5 <iscons>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ede:	50                   	push   %eax
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	e8 82 ef ff ff       	call   800e69 <fd_lookup>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 11                	js     801eff <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801ef7:	39 10                	cmp    %edx,(%eax)
  801ef9:	0f 94 c0             	sete   %al
  801efc:	0f b6 c0             	movzbl %al,%eax
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <opencons>:
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0a:	50                   	push   %eax
  801f0b:	e8 07 ef ff ff       	call   800e17 <fd_alloc>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	85 c0                	test   %eax,%eax
  801f15:	78 3a                	js     801f51 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	68 07 04 00 00       	push   $0x407
  801f1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f22:	6a 00                	push   $0x0
  801f24:	e8 1a ec ff ff       	call   800b43 <sys_page_alloc>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 21                	js     801f51 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f39:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	50                   	push   %eax
  801f49:	e8 a2 ee ff ff       	call   800df0 <fd2num>
  801f4e:	83 c4 10             	add    $0x10,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f58:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f5b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f61:	e8 9f eb ff ff       	call   800b05 <sys_getenvid>
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 0c             	pushl  0xc(%ebp)
  801f6c:	ff 75 08             	pushl  0x8(%ebp)
  801f6f:	56                   	push   %esi
  801f70:	50                   	push   %eax
  801f71:	68 e4 27 80 00       	push   $0x8027e4
  801f76:	e8 fa e1 ff ff       	call   800175 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f7b:	83 c4 18             	add    $0x18,%esp
  801f7e:	53                   	push   %ebx
  801f7f:	ff 75 10             	pushl  0x10(%ebp)
  801f82:	e8 9d e1 ff ff       	call   800124 <vcprintf>
	cprintf("\n");
  801f87:	c7 04 24 97 27 80 00 	movl   $0x802797,(%esp)
  801f8e:	e8 e2 e1 ff ff       	call   800175 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f96:	cc                   	int3   
  801f97:	eb fd                	jmp    801f96 <_panic+0x43>

00801f99 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	74 4f                	je     801ffa <ipc_recv+0x61>
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	50                   	push   %eax
  801faf:	e8 3f ed ff ff       	call   800cf3 <sys_ipc_recv>
  801fb4:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801fb7:	85 f6                	test   %esi,%esi
  801fb9:	74 14                	je     801fcf <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801fbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	75 09                	jne    801fcd <ipc_recv+0x34>
  801fc4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fca:	8b 52 74             	mov    0x74(%edx),%edx
  801fcd:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801fcf:	85 db                	test   %ebx,%ebx
  801fd1:	74 14                	je     801fe7 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	75 09                	jne    801fe5 <ipc_recv+0x4c>
  801fdc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fe2:	8b 52 78             	mov    0x78(%edx),%edx
  801fe5:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	75 08                	jne    801ff3 <ipc_recv+0x5a>
  801feb:	a1 08 40 80 00       	mov    0x804008,%eax
  801ff0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ff3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5e                   	pop    %esi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ffa:	83 ec 0c             	sub    $0xc,%esp
  801ffd:	68 00 00 c0 ee       	push   $0xeec00000
  802002:	e8 ec ec ff ff       	call   800cf3 <sys_ipc_recv>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	eb ab                	jmp    801fb7 <ipc_recv+0x1e>

0080200c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	57                   	push   %edi
  802010:	56                   	push   %esi
  802011:	53                   	push   %ebx
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	8b 7d 08             	mov    0x8(%ebp),%edi
  802018:	8b 75 10             	mov    0x10(%ebp),%esi
  80201b:	eb 20                	jmp    80203d <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80201d:	6a 00                	push   $0x0
  80201f:	68 00 00 c0 ee       	push   $0xeec00000
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	57                   	push   %edi
  802028:	e8 a3 ec ff ff       	call   800cd0 <sys_ipc_try_send>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	eb 1f                	jmp    802053 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802034:	e8 eb ea ff ff       	call   800b24 <sys_yield>
	while(retval != 0) {
  802039:	85 db                	test   %ebx,%ebx
  80203b:	74 33                	je     802070 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80203d:	85 f6                	test   %esi,%esi
  80203f:	74 dc                	je     80201d <ipc_send+0x11>
  802041:	ff 75 14             	pushl  0x14(%ebp)
  802044:	56                   	push   %esi
  802045:	ff 75 0c             	pushl  0xc(%ebp)
  802048:	57                   	push   %edi
  802049:	e8 82 ec ff ff       	call   800cd0 <sys_ipc_try_send>
  80204e:	89 c3                	mov    %eax,%ebx
  802050:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802053:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802056:	74 dc                	je     802034 <ipc_send+0x28>
  802058:	85 db                	test   %ebx,%ebx
  80205a:	74 d8                	je     802034 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	68 08 28 80 00       	push   $0x802808
  802064:	6a 35                	push   $0x35
  802066:	68 38 28 80 00       	push   $0x802838
  80206b:	e8 e3 fe ff ff       	call   801f53 <_panic>
	}
}
  802070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802083:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802086:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80208c:	8b 52 50             	mov    0x50(%edx),%edx
  80208f:	39 ca                	cmp    %ecx,%edx
  802091:	74 11                	je     8020a4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802093:	83 c0 01             	add    $0x1,%eax
  802096:	3d 00 04 00 00       	cmp    $0x400,%eax
  80209b:	75 e6                	jne    802083 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb 0b                	jmp    8020af <ipc_find_env+0x37>
			return envs[i].env_id;
  8020a4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020ac:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    

008020b1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020b7:	89 d0                	mov    %edx,%eax
  8020b9:	c1 e8 16             	shr    $0x16,%eax
  8020bc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020c8:	f6 c1 01             	test   $0x1,%cl
  8020cb:	74 1d                	je     8020ea <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020cd:	c1 ea 0c             	shr    $0xc,%edx
  8020d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020d7:	f6 c2 01             	test   $0x1,%dl
  8020da:	74 0e                	je     8020ea <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020dc:	c1 ea 0c             	shr    $0xc,%edx
  8020df:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020e6:	ef 
  8020e7:	0f b7 c0             	movzwl %ax,%eax
}
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <__udivdi3>:
  8020f0:	f3 0f 1e fb          	endbr32 
  8020f4:	55                   	push   %ebp
  8020f5:	57                   	push   %edi
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
  8020f8:	83 ec 1c             	sub    $0x1c,%esp
  8020fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802103:	8b 74 24 34          	mov    0x34(%esp),%esi
  802107:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80210b:	85 d2                	test   %edx,%edx
  80210d:	75 49                	jne    802158 <__udivdi3+0x68>
  80210f:	39 f3                	cmp    %esi,%ebx
  802111:	76 15                	jbe    802128 <__udivdi3+0x38>
  802113:	31 ff                	xor    %edi,%edi
  802115:	89 e8                	mov    %ebp,%eax
  802117:	89 f2                	mov    %esi,%edx
  802119:	f7 f3                	div    %ebx
  80211b:	89 fa                	mov    %edi,%edx
  80211d:	83 c4 1c             	add    $0x1c,%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5f                   	pop    %edi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
  802125:	8d 76 00             	lea    0x0(%esi),%esi
  802128:	89 d9                	mov    %ebx,%ecx
  80212a:	85 db                	test   %ebx,%ebx
  80212c:	75 0b                	jne    802139 <__udivdi3+0x49>
  80212e:	b8 01 00 00 00       	mov    $0x1,%eax
  802133:	31 d2                	xor    %edx,%edx
  802135:	f7 f3                	div    %ebx
  802137:	89 c1                	mov    %eax,%ecx
  802139:	31 d2                	xor    %edx,%edx
  80213b:	89 f0                	mov    %esi,%eax
  80213d:	f7 f1                	div    %ecx
  80213f:	89 c6                	mov    %eax,%esi
  802141:	89 e8                	mov    %ebp,%eax
  802143:	89 f7                	mov    %esi,%edi
  802145:	f7 f1                	div    %ecx
  802147:	89 fa                	mov    %edi,%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802158:	39 f2                	cmp    %esi,%edx
  80215a:	77 1c                	ja     802178 <__udivdi3+0x88>
  80215c:	0f bd fa             	bsr    %edx,%edi
  80215f:	83 f7 1f             	xor    $0x1f,%edi
  802162:	75 2c                	jne    802190 <__udivdi3+0xa0>
  802164:	39 f2                	cmp    %esi,%edx
  802166:	72 06                	jb     80216e <__udivdi3+0x7e>
  802168:	31 c0                	xor    %eax,%eax
  80216a:	39 eb                	cmp    %ebp,%ebx
  80216c:	77 ad                	ja     80211b <__udivdi3+0x2b>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	eb a6                	jmp    80211b <__udivdi3+0x2b>
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	31 ff                	xor    %edi,%edi
  80217a:	31 c0                	xor    %eax,%eax
  80217c:	89 fa                	mov    %edi,%edx
  80217e:	83 c4 1c             	add    $0x1c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    
  802186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80218d:	8d 76 00             	lea    0x0(%esi),%esi
  802190:	89 f9                	mov    %edi,%ecx
  802192:	b8 20 00 00 00       	mov    $0x20,%eax
  802197:	29 f8                	sub    %edi,%eax
  802199:	d3 e2                	shl    %cl,%edx
  80219b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80219f:	89 c1                	mov    %eax,%ecx
  8021a1:	89 da                	mov    %ebx,%edx
  8021a3:	d3 ea                	shr    %cl,%edx
  8021a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021a9:	09 d1                	or     %edx,%ecx
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f9                	mov    %edi,%ecx
  8021b3:	d3 e3                	shl    %cl,%ebx
  8021b5:	89 c1                	mov    %eax,%ecx
  8021b7:	d3 ea                	shr    %cl,%edx
  8021b9:	89 f9                	mov    %edi,%ecx
  8021bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021bf:	89 eb                	mov    %ebp,%ebx
  8021c1:	d3 e6                	shl    %cl,%esi
  8021c3:	89 c1                	mov    %eax,%ecx
  8021c5:	d3 eb                	shr    %cl,%ebx
  8021c7:	09 de                	or     %ebx,%esi
  8021c9:	89 f0                	mov    %esi,%eax
  8021cb:	f7 74 24 08          	divl   0x8(%esp)
  8021cf:	89 d6                	mov    %edx,%esi
  8021d1:	89 c3                	mov    %eax,%ebx
  8021d3:	f7 64 24 0c          	mull   0xc(%esp)
  8021d7:	39 d6                	cmp    %edx,%esi
  8021d9:	72 15                	jb     8021f0 <__udivdi3+0x100>
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e5                	shl    %cl,%ebp
  8021df:	39 c5                	cmp    %eax,%ebp
  8021e1:	73 04                	jae    8021e7 <__udivdi3+0xf7>
  8021e3:	39 d6                	cmp    %edx,%esi
  8021e5:	74 09                	je     8021f0 <__udivdi3+0x100>
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	31 ff                	xor    %edi,%edi
  8021eb:	e9 2b ff ff ff       	jmp    80211b <__udivdi3+0x2b>
  8021f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	e9 21 ff ff ff       	jmp    80211b <__udivdi3+0x2b>
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80220f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802213:	8b 74 24 30          	mov    0x30(%esp),%esi
  802217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221b:	89 da                	mov    %ebx,%edx
  80221d:	85 c0                	test   %eax,%eax
  80221f:	75 3f                	jne    802260 <__umoddi3+0x60>
  802221:	39 df                	cmp    %ebx,%edi
  802223:	76 13                	jbe    802238 <__umoddi3+0x38>
  802225:	89 f0                	mov    %esi,%eax
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	89 fd                	mov    %edi,%ebp
  80223a:	85 ff                	test   %edi,%edi
  80223c:	75 0b                	jne    802249 <__umoddi3+0x49>
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f7                	div    %edi
  802247:	89 c5                	mov    %eax,%ebp
  802249:	89 d8                	mov    %ebx,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f5                	div    %ebp
  80224f:	89 f0                	mov    %esi,%eax
  802251:	f7 f5                	div    %ebp
  802253:	89 d0                	mov    %edx,%eax
  802255:	eb d4                	jmp    80222b <__umoddi3+0x2b>
  802257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80225e:	66 90                	xchg   %ax,%ax
  802260:	89 f1                	mov    %esi,%ecx
  802262:	39 d8                	cmp    %ebx,%eax
  802264:	76 0a                	jbe    802270 <__umoddi3+0x70>
  802266:	89 f0                	mov    %esi,%eax
  802268:	83 c4 1c             	add    $0x1c,%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5e                   	pop    %esi
  80226d:	5f                   	pop    %edi
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    
  802270:	0f bd e8             	bsr    %eax,%ebp
  802273:	83 f5 1f             	xor    $0x1f,%ebp
  802276:	75 20                	jne    802298 <__umoddi3+0x98>
  802278:	39 d8                	cmp    %ebx,%eax
  80227a:	0f 82 b0 00 00 00    	jb     802330 <__umoddi3+0x130>
  802280:	39 f7                	cmp    %esi,%edi
  802282:	0f 86 a8 00 00 00    	jbe    802330 <__umoddi3+0x130>
  802288:	89 c8                	mov    %ecx,%eax
  80228a:	83 c4 1c             	add    $0x1c,%esp
  80228d:	5b                   	pop    %ebx
  80228e:	5e                   	pop    %esi
  80228f:	5f                   	pop    %edi
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    
  802292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802298:	89 e9                	mov    %ebp,%ecx
  80229a:	ba 20 00 00 00       	mov    $0x20,%edx
  80229f:	29 ea                	sub    %ebp,%edx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a7:	89 d1                	mov    %edx,%ecx
  8022a9:	89 f8                	mov    %edi,%eax
  8022ab:	d3 e8                	shr    %cl,%eax
  8022ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022b9:	09 c1                	or     %eax,%ecx
  8022bb:	89 d8                	mov    %ebx,%eax
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 e9                	mov    %ebp,%ecx
  8022c3:	d3 e7                	shl    %cl,%edi
  8022c5:	89 d1                	mov    %edx,%ecx
  8022c7:	d3 e8                	shr    %cl,%eax
  8022c9:	89 e9                	mov    %ebp,%ecx
  8022cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022cf:	d3 e3                	shl    %cl,%ebx
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	89 d1                	mov    %edx,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	89 fa                	mov    %edi,%edx
  8022dd:	d3 e6                	shl    %cl,%esi
  8022df:	09 d8                	or     %ebx,%eax
  8022e1:	f7 74 24 08          	divl   0x8(%esp)
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	89 f3                	mov    %esi,%ebx
  8022e9:	f7 64 24 0c          	mull   0xc(%esp)
  8022ed:	89 c6                	mov    %eax,%esi
  8022ef:	89 d7                	mov    %edx,%edi
  8022f1:	39 d1                	cmp    %edx,%ecx
  8022f3:	72 06                	jb     8022fb <__umoddi3+0xfb>
  8022f5:	75 10                	jne    802307 <__umoddi3+0x107>
  8022f7:	39 c3                	cmp    %eax,%ebx
  8022f9:	73 0c                	jae    802307 <__umoddi3+0x107>
  8022fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802303:	89 d7                	mov    %edx,%edi
  802305:	89 c6                	mov    %eax,%esi
  802307:	89 ca                	mov    %ecx,%edx
  802309:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230e:	29 f3                	sub    %esi,%ebx
  802310:	19 fa                	sbb    %edi,%edx
  802312:	89 d0                	mov    %edx,%eax
  802314:	d3 e0                	shl    %cl,%eax
  802316:	89 e9                	mov    %ebp,%ecx
  802318:	d3 eb                	shr    %cl,%ebx
  80231a:	d3 ea                	shr    %cl,%edx
  80231c:	09 d8                	or     %ebx,%eax
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	89 da                	mov    %ebx,%edx
  802332:	29 fe                	sub    %edi,%esi
  802334:	19 c2                	sbb    %eax,%edx
  802336:	89 f1                	mov    %esi,%ecx
  802338:	89 c8                	mov    %ecx,%eax
  80233a:	e9 4b ff ff ff       	jmp    80228a <__umoddi3+0x8a>
