
obj/user/divzero.debug：     文件格式 elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 80 22 80 00       	push   $0x802280
  800056:	e8 fa 00 00 00       	call   800155 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 75 0a 00 00       	call   800ae5 <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 5a 0e 00 00       	call   800f0b <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 e9 09 00 00       	call   800aa4 <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 04             	sub    $0x4,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 13                	mov    (%ebx),%edx
  8000cc:	8d 42 01             	lea    0x1(%edx),%eax
  8000cf:	89 03                	mov    %eax,(%ebx)
  8000d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	74 09                	je     8000e8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f3:	50                   	push   %eax
  8000f4:	e8 6e 09 00 00       	call   800a67 <sys_cputs>
		b->idx = 0;
  8000f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	eb db                	jmp    8000df <putch+0x1f>

00800104 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800114:	00 00 00 
	b.cnt = 0;
  800117:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	68 c0 00 80 00       	push   $0x8000c0
  800133:	e8 19 01 00 00       	call   800251 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800138:	83 c4 08             	add    $0x8,%esp
  80013b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800141:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	e8 1a 09 00 00       	call   800a67 <sys_cputs>

	return b.cnt;
}
  80014d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015e:	50                   	push   %eax
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 9d ff ff ff       	call   800104 <vcprintf>
	va_end(ap);

	return cnt;
}
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
  80016f:	83 ec 1c             	sub    $0x1c,%esp
  800172:	89 c7                	mov    %eax,%edi
  800174:	89 d6                	mov    %edx,%esi
  800176:	8b 45 08             	mov    0x8(%ebp),%eax
  800179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800182:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800190:	3b 45 10             	cmp    0x10(%ebp),%eax
  800193:	89 d0                	mov    %edx,%eax
  800195:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800198:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80019b:	73 15                	jae    8001b2 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80019d:	83 eb 01             	sub    $0x1,%ebx
  8001a0:	85 db                	test   %ebx,%ebx
  8001a2:	7e 43                	jle    8001e7 <printnum+0x7e>
			putch(padc, putdat);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	56                   	push   %esi
  8001a8:	ff 75 18             	pushl  0x18(%ebp)
  8001ab:	ff d7                	call   *%edi
  8001ad:	83 c4 10             	add    $0x10,%esp
  8001b0:	eb eb                	jmp    80019d <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	ff 75 18             	pushl  0x18(%ebp)
  8001b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001bb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001be:	53                   	push   %ebx
  8001bf:	ff 75 10             	pushl  0x10(%ebp)
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d1:	e8 5a 1e 00 00       	call   802030 <__udivdi3>
  8001d6:	83 c4 18             	add    $0x18,%esp
  8001d9:	52                   	push   %edx
  8001da:	50                   	push   %eax
  8001db:	89 f2                	mov    %esi,%edx
  8001dd:	89 f8                	mov    %edi,%eax
  8001df:	e8 85 ff ff ff       	call   800169 <printnum>
  8001e4:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	56                   	push   %esi
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fa:	e8 41 1f 00 00       	call   802140 <__umoddi3>
  8001ff:	83 c4 14             	add    $0x14,%esp
  800202:	0f be 80 98 22 80 00 	movsbl 0x802298(%eax),%eax
  800209:	50                   	push   %eax
  80020a:	ff d7                	call   *%edi
}
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800212:	5b                   	pop    %ebx
  800213:	5e                   	pop    %esi
  800214:	5f                   	pop    %edi
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    

00800217 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800221:	8b 10                	mov    (%eax),%edx
  800223:	3b 50 04             	cmp    0x4(%eax),%edx
  800226:	73 0a                	jae    800232 <sprintputch+0x1b>
		*b->buf++ = ch;
  800228:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022b:	89 08                	mov    %ecx,(%eax)
  80022d:	8b 45 08             	mov    0x8(%ebp),%eax
  800230:	88 02                	mov    %al,(%edx)
}
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    

00800234 <printfmt>:
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023d:	50                   	push   %eax
  80023e:	ff 75 10             	pushl  0x10(%ebp)
  800241:	ff 75 0c             	pushl  0xc(%ebp)
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	e8 05 00 00 00       	call   800251 <vprintfmt>
}
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <vprintfmt>:
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 3c             	sub    $0x3c,%esp
  80025a:	8b 75 08             	mov    0x8(%ebp),%esi
  80025d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800260:	8b 7d 10             	mov    0x10(%ebp),%edi
  800263:	eb 0a                	jmp    80026f <vprintfmt+0x1e>
			putch(ch, putdat);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	53                   	push   %ebx
  800269:	50                   	push   %eax
  80026a:	ff d6                	call   *%esi
  80026c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80026f:	83 c7 01             	add    $0x1,%edi
  800272:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800276:	83 f8 25             	cmp    $0x25,%eax
  800279:	74 0c                	je     800287 <vprintfmt+0x36>
			if (ch == '\0')
  80027b:	85 c0                	test   %eax,%eax
  80027d:	75 e6                	jne    800265 <vprintfmt+0x14>
}
  80027f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800282:	5b                   	pop    %ebx
  800283:	5e                   	pop    %esi
  800284:	5f                   	pop    %edi
  800285:	5d                   	pop    %ebp
  800286:	c3                   	ret    
		padc = ' ';
  800287:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80028b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800292:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800299:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	8d 47 01             	lea    0x1(%edi),%eax
  8002a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ab:	0f b6 17             	movzbl (%edi),%edx
  8002ae:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b1:	3c 55                	cmp    $0x55,%al
  8002b3:	0f 87 ba 03 00 00    	ja     800673 <vprintfmt+0x422>
  8002b9:	0f b6 c0             	movzbl %al,%eax
  8002bc:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  8002c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ca:	eb d9                	jmp    8002a5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002cf:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d3:	eb d0                	jmp    8002a5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002d5:	0f b6 d2             	movzbl %dl,%edx
  8002d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002db:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ea:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ed:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f0:	83 f9 09             	cmp    $0x9,%ecx
  8002f3:	77 55                	ja     80034a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002f5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f8:	eb e9                	jmp    8002e3 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fd:	8b 00                	mov    (%eax),%eax
  8002ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800302:	8b 45 14             	mov    0x14(%ebp),%eax
  800305:	8d 40 04             	lea    0x4(%eax),%eax
  800308:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800312:	79 91                	jns    8002a5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800321:	eb 82                	jmp    8002a5 <vprintfmt+0x54>
  800323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	0f 49 d0             	cmovns %eax,%edx
  800330:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800336:	e9 6a ff ff ff       	jmp    8002a5 <vprintfmt+0x54>
  80033b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800345:	e9 5b ff ff ff       	jmp    8002a5 <vprintfmt+0x54>
  80034a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800350:	eb bc                	jmp    80030e <vprintfmt+0xbd>
			lflag++;
  800352:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800358:	e9 48 ff ff ff       	jmp    8002a5 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80035d:	8b 45 14             	mov    0x14(%ebp),%eax
  800360:	8d 78 04             	lea    0x4(%eax),%edi
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	53                   	push   %ebx
  800367:	ff 30                	pushl  (%eax)
  800369:	ff d6                	call   *%esi
			break;
  80036b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800371:	e9 9c 02 00 00       	jmp    800612 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800376:	8b 45 14             	mov    0x14(%ebp),%eax
  800379:	8d 78 04             	lea    0x4(%eax),%edi
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	99                   	cltd   
  80037f:	31 d0                	xor    %edx,%eax
  800381:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800383:	83 f8 0f             	cmp    $0xf,%eax
  800386:	7f 23                	jg     8003ab <vprintfmt+0x15a>
  800388:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80038f:	85 d2                	test   %edx,%edx
  800391:	74 18                	je     8003ab <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800393:	52                   	push   %edx
  800394:	68 7a 26 80 00       	push   $0x80267a
  800399:	53                   	push   %ebx
  80039a:	56                   	push   %esi
  80039b:	e8 94 fe ff ff       	call   800234 <printfmt>
  8003a0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a6:	e9 67 02 00 00       	jmp    800612 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003ab:	50                   	push   %eax
  8003ac:	68 b0 22 80 00       	push   $0x8022b0
  8003b1:	53                   	push   %ebx
  8003b2:	56                   	push   %esi
  8003b3:	e8 7c fe ff ff       	call   800234 <printfmt>
  8003b8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003be:	e9 4f 02 00 00       	jmp    800612 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	83 c0 04             	add    $0x4,%eax
  8003c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	b8 a9 22 80 00       	mov    $0x8022a9,%eax
  8003d8:	0f 45 c2             	cmovne %edx,%eax
  8003db:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e2:	7e 06                	jle    8003ea <vprintfmt+0x199>
  8003e4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e8:	75 0d                	jne    8003f7 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ed:	89 c7                	mov    %eax,%edi
  8003ef:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f5:	eb 3f                	jmp    800436 <vprintfmt+0x1e5>
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fd:	50                   	push   %eax
  8003fe:	e8 0d 03 00 00       	call   800710 <strnlen>
  800403:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800406:	29 c2                	sub    %eax,%edx
  800408:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80040b:	83 c4 10             	add    $0x10,%esp
  80040e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800410:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800414:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800417:	85 ff                	test   %edi,%edi
  800419:	7e 58                	jle    800473 <vprintfmt+0x222>
					putch(padc, putdat);
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	ff 75 e0             	pushl  -0x20(%ebp)
  800422:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800424:	83 ef 01             	sub    $0x1,%edi
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	eb eb                	jmp    800417 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	53                   	push   %ebx
  800430:	52                   	push   %edx
  800431:	ff d6                	call   *%esi
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800439:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80043b:	83 c7 01             	add    $0x1,%edi
  80043e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800442:	0f be d0             	movsbl %al,%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 45                	je     80048e <vprintfmt+0x23d>
  800449:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80044d:	78 06                	js     800455 <vprintfmt+0x204>
  80044f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800453:	78 35                	js     80048a <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800455:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800459:	74 d1                	je     80042c <vprintfmt+0x1db>
  80045b:	0f be c0             	movsbl %al,%eax
  80045e:	83 e8 20             	sub    $0x20,%eax
  800461:	83 f8 5e             	cmp    $0x5e,%eax
  800464:	76 c6                	jbe    80042c <vprintfmt+0x1db>
					putch('?', putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	53                   	push   %ebx
  80046a:	6a 3f                	push   $0x3f
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	eb c3                	jmp    800436 <vprintfmt+0x1e5>
  800473:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800476:	85 d2                	test   %edx,%edx
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	0f 49 c2             	cmovns %edx,%eax
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800485:	e9 60 ff ff ff       	jmp    8003ea <vprintfmt+0x199>
  80048a:	89 cf                	mov    %ecx,%edi
  80048c:	eb 02                	jmp    800490 <vprintfmt+0x23f>
  80048e:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800490:	85 ff                	test   %edi,%edi
  800492:	7e 10                	jle    8004a4 <vprintfmt+0x253>
				putch(' ', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	6a 20                	push   $0x20
  80049a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80049c:	83 ef 01             	sub    $0x1,%edi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	eb ec                	jmp    800490 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004aa:	e9 63 01 00 00       	jmp    800612 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004af:	83 f9 01             	cmp    $0x1,%ecx
  8004b2:	7f 1b                	jg     8004cf <vprintfmt+0x27e>
	else if (lflag)
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	74 63                	je     80051b <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	99                   	cltd   
  8004c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	eb 17                	jmp    8004e6 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8b 50 04             	mov    0x4(%eax),%edx
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 40 08             	lea    0x8(%eax),%eax
  8004e3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ec:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004f1:	85 c9                	test   %ecx,%ecx
  8004f3:	0f 89 ff 00 00 00    	jns    8005f8 <vprintfmt+0x3a7>
				putch('-', putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	6a 2d                	push   $0x2d
  8004ff:	ff d6                	call   *%esi
				num = -(long long) num;
  800501:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800504:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800507:	f7 da                	neg    %edx
  800509:	83 d1 00             	adc    $0x0,%ecx
  80050c:	f7 d9                	neg    %ecx
  80050e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800511:	b8 0a 00 00 00       	mov    $0xa,%eax
  800516:	e9 dd 00 00 00       	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800523:	99                   	cltd   
  800524:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 40 04             	lea    0x4(%eax),%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
  800530:	eb b4                	jmp    8004e6 <vprintfmt+0x295>
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7f 1e                	jg     800555 <vprintfmt+0x304>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	74 32                	je     80056d <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 10                	mov    (%eax),%edx
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	8d 40 04             	lea    0x4(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 a3 00 00 00       	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 10                	mov    (%eax),%edx
  80055a:	8b 48 04             	mov    0x4(%eax),%ecx
  80055d:	8d 40 08             	lea    0x8(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	b8 0a 00 00 00       	mov    $0xa,%eax
  800568:	e9 8b 00 00 00       	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 10                	mov    (%eax),%edx
  800572:	b9 00 00 00 00       	mov    $0x0,%ecx
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800582:	eb 74                	jmp    8005f8 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7f 1b                	jg     8005a4 <vprintfmt+0x353>
	else if (lflag)
  800589:	85 c9                	test   %ecx,%ecx
  80058b:	74 2c                	je     8005b9 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	b9 00 00 00 00       	mov    $0x0,%ecx
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059d:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a2:	eb 54                	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ac:	8d 40 08             	lea    0x8(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b7:	eb 3f                	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8b 10                	mov    (%eax),%edx
  8005be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c3:	8d 40 04             	lea    0x4(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c9:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ce:	eb 28                	jmp    8005f8 <vprintfmt+0x3a7>
			putch('0', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 30                	push   $0x30
  8005d6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d8:	83 c4 08             	add    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 78                	push   $0x78
  8005de:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ea:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ff:	57                   	push   %edi
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	50                   	push   %eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	89 da                	mov    %ebx,%edx
  800608:	89 f0                	mov    %esi,%eax
  80060a:	e8 5a fb ff ff       	call   800169 <printnum>
			break;
  80060f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800615:	e9 55 fc ff ff       	jmp    80026f <vprintfmt+0x1e>
	if (lflag >= 2)
  80061a:	83 f9 01             	cmp    $0x1,%ecx
  80061d:	7f 1b                	jg     80063a <vprintfmt+0x3e9>
	else if (lflag)
  80061f:	85 c9                	test   %ecx,%ecx
  800621:	74 2c                	je     80064f <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8b 10                	mov    (%eax),%edx
  800628:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800633:	b8 10 00 00 00       	mov    $0x10,%eax
  800638:	eb be                	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	8b 48 04             	mov    0x4(%eax),%ecx
  800642:	8d 40 08             	lea    0x8(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
  80064d:	eb a9                	jmp    8005f8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	b9 00 00 00 00       	mov    $0x0,%ecx
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065f:	b8 10 00 00 00       	mov    $0x10,%eax
  800664:	eb 92                	jmp    8005f8 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 25                	push   $0x25
  80066c:	ff d6                	call   *%esi
			break;
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb 9f                	jmp    800612 <vprintfmt+0x3c1>
			putch('%', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 25                	push   $0x25
  800679:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	89 f8                	mov    %edi,%eax
  800680:	eb 03                	jmp    800685 <vprintfmt+0x434>
  800682:	83 e8 01             	sub    $0x1,%eax
  800685:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800689:	75 f7                	jne    800682 <vprintfmt+0x431>
  80068b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068e:	eb 82                	jmp    800612 <vprintfmt+0x3c1>

00800690 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
  800693:	83 ec 18             	sub    $0x18,%esp
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80069c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80069f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006a3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ad:	85 c0                	test   %eax,%eax
  8006af:	74 26                	je     8006d7 <vsnprintf+0x47>
  8006b1:	85 d2                	test   %edx,%edx
  8006b3:	7e 22                	jle    8006d7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006b5:	ff 75 14             	pushl  0x14(%ebp)
  8006b8:	ff 75 10             	pushl  0x10(%ebp)
  8006bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006be:	50                   	push   %eax
  8006bf:	68 17 02 80 00       	push   $0x800217
  8006c4:	e8 88 fb ff ff       	call   800251 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006cc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d2:	83 c4 10             	add    $0x10,%esp
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    
		return -E_INVAL;
  8006d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006dc:	eb f7                	jmp    8006d5 <vsnprintf+0x45>

008006de <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006de:	55                   	push   %ebp
  8006df:	89 e5                	mov    %esp,%ebp
  8006e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 10             	pushl  0x10(%ebp)
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	e8 9a ff ff ff       	call   800690 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006f6:	c9                   	leave  
  8006f7:	c3                   	ret    

008006f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800703:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800707:	74 05                	je     80070e <strlen+0x16>
		n++;
  800709:	83 c0 01             	add    $0x1,%eax
  80070c:	eb f5                	jmp    800703 <strlen+0xb>
	return n;
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	39 c2                	cmp    %eax,%edx
  800720:	74 0d                	je     80072f <strnlen+0x1f>
  800722:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800726:	74 05                	je     80072d <strnlen+0x1d>
		n++;
  800728:	83 c2 01             	add    $0x1,%edx
  80072b:	eb f1                	jmp    80071e <strnlen+0xe>
  80072d:	89 d0                	mov    %edx,%eax
	return n;
}
  80072f:	5d                   	pop    %ebp
  800730:	c3                   	ret    

00800731 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	53                   	push   %ebx
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80073b:	ba 00 00 00 00       	mov    $0x0,%edx
  800740:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800744:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800747:	83 c2 01             	add    $0x1,%edx
  80074a:	84 c9                	test   %cl,%cl
  80074c:	75 f2                	jne    800740 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80074e:	5b                   	pop    %ebx
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	53                   	push   %ebx
  800755:	83 ec 10             	sub    $0x10,%esp
  800758:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80075b:	53                   	push   %ebx
  80075c:	e8 97 ff ff ff       	call   8006f8 <strlen>
  800761:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	01 d8                	add    %ebx,%eax
  800769:	50                   	push   %eax
  80076a:	e8 c2 ff ff ff       	call   800731 <strcpy>
	return dst;
}
  80076f:	89 d8                	mov    %ebx,%eax
  800771:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800774:	c9                   	leave  
  800775:	c3                   	ret    

00800776 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	56                   	push   %esi
  80077a:	53                   	push   %ebx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800781:	89 c6                	mov    %eax,%esi
  800783:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800786:	89 c2                	mov    %eax,%edx
  800788:	39 f2                	cmp    %esi,%edx
  80078a:	74 11                	je     80079d <strncpy+0x27>
		*dst++ = *src;
  80078c:	83 c2 01             	add    $0x1,%edx
  80078f:	0f b6 19             	movzbl (%ecx),%ebx
  800792:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800795:	80 fb 01             	cmp    $0x1,%bl
  800798:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80079b:	eb eb                	jmp    800788 <strncpy+0x12>
	}
	return ret;
}
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	56                   	push   %esi
  8007a5:	53                   	push   %ebx
  8007a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ac:	8b 55 10             	mov    0x10(%ebp),%edx
  8007af:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007b1:	85 d2                	test   %edx,%edx
  8007b3:	74 21                	je     8007d6 <strlcpy+0x35>
  8007b5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007b9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 14                	je     8007d3 <strlcpy+0x32>
  8007bf:	0f b6 19             	movzbl (%ecx),%ebx
  8007c2:	84 db                	test   %bl,%bl
  8007c4:	74 0b                	je     8007d1 <strlcpy+0x30>
			*dst++ = *src++;
  8007c6:	83 c1 01             	add    $0x1,%ecx
  8007c9:	83 c2 01             	add    $0x1,%edx
  8007cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007cf:	eb ea                	jmp    8007bb <strlcpy+0x1a>
  8007d1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007d6:	29 f0                	sub    %esi,%eax
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5e                   	pop    %esi
  8007da:	5d                   	pop    %ebp
  8007db:	c3                   	ret    

008007dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007e5:	0f b6 01             	movzbl (%ecx),%eax
  8007e8:	84 c0                	test   %al,%al
  8007ea:	74 0c                	je     8007f8 <strcmp+0x1c>
  8007ec:	3a 02                	cmp    (%edx),%al
  8007ee:	75 08                	jne    8007f8 <strcmp+0x1c>
		p++, q++;
  8007f0:	83 c1 01             	add    $0x1,%ecx
  8007f3:	83 c2 01             	add    $0x1,%edx
  8007f6:	eb ed                	jmp    8007e5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007f8:	0f b6 c0             	movzbl %al,%eax
  8007fb:	0f b6 12             	movzbl (%edx),%edx
  8007fe:	29 d0                	sub    %edx,%eax
}
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080c:	89 c3                	mov    %eax,%ebx
  80080e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800811:	eb 06                	jmp    800819 <strncmp+0x17>
		n--, p++, q++;
  800813:	83 c0 01             	add    $0x1,%eax
  800816:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800819:	39 d8                	cmp    %ebx,%eax
  80081b:	74 16                	je     800833 <strncmp+0x31>
  80081d:	0f b6 08             	movzbl (%eax),%ecx
  800820:	84 c9                	test   %cl,%cl
  800822:	74 04                	je     800828 <strncmp+0x26>
  800824:	3a 0a                	cmp    (%edx),%cl
  800826:	74 eb                	je     800813 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800828:	0f b6 00             	movzbl (%eax),%eax
  80082b:	0f b6 12             	movzbl (%edx),%edx
  80082e:	29 d0                	sub    %edx,%eax
}
  800830:	5b                   	pop    %ebx
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    
		return 0;
  800833:	b8 00 00 00 00       	mov    $0x0,%eax
  800838:	eb f6                	jmp    800830 <strncmp+0x2e>

0080083a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800844:	0f b6 10             	movzbl (%eax),%edx
  800847:	84 d2                	test   %dl,%dl
  800849:	74 09                	je     800854 <strchr+0x1a>
		if (*s == c)
  80084b:	38 ca                	cmp    %cl,%dl
  80084d:	74 0a                	je     800859 <strchr+0x1f>
	for (; *s; s++)
  80084f:	83 c0 01             	add    $0x1,%eax
  800852:	eb f0                	jmp    800844 <strchr+0xa>
			return (char *) s;
	return 0;
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800865:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800868:	38 ca                	cmp    %cl,%dl
  80086a:	74 09                	je     800875 <strfind+0x1a>
  80086c:	84 d2                	test   %dl,%dl
  80086e:	74 05                	je     800875 <strfind+0x1a>
	for (; *s; s++)
  800870:	83 c0 01             	add    $0x1,%eax
  800873:	eb f0                	jmp    800865 <strfind+0xa>
			break;
	return (char *) s;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	57                   	push   %edi
  80087b:	56                   	push   %esi
  80087c:	53                   	push   %ebx
  80087d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800880:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800883:	85 c9                	test   %ecx,%ecx
  800885:	74 31                	je     8008b8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800887:	89 f8                	mov    %edi,%eax
  800889:	09 c8                	or     %ecx,%eax
  80088b:	a8 03                	test   $0x3,%al
  80088d:	75 23                	jne    8008b2 <memset+0x3b>
		c &= 0xFF;
  80088f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800893:	89 d3                	mov    %edx,%ebx
  800895:	c1 e3 08             	shl    $0x8,%ebx
  800898:	89 d0                	mov    %edx,%eax
  80089a:	c1 e0 18             	shl    $0x18,%eax
  80089d:	89 d6                	mov    %edx,%esi
  80089f:	c1 e6 10             	shl    $0x10,%esi
  8008a2:	09 f0                	or     %esi,%eax
  8008a4:	09 c2                	or     %eax,%edx
  8008a6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008a8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	fc                   	cld    
  8008ae:	f3 ab                	rep stos %eax,%es:(%edi)
  8008b0:	eb 06                	jmp    8008b8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	fc                   	cld    
  8008b6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008b8:	89 f8                	mov    %edi,%eax
  8008ba:	5b                   	pop    %ebx
  8008bb:	5e                   	pop    %esi
  8008bc:	5f                   	pop    %edi
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	57                   	push   %edi
  8008c3:	56                   	push   %esi
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008cd:	39 c6                	cmp    %eax,%esi
  8008cf:	73 32                	jae    800903 <memmove+0x44>
  8008d1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	76 2b                	jbe    800903 <memmove+0x44>
		s += n;
		d += n;
  8008d8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008db:	89 fe                	mov    %edi,%esi
  8008dd:	09 ce                	or     %ecx,%esi
  8008df:	09 d6                	or     %edx,%esi
  8008e1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e7:	75 0e                	jne    8008f7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008e9:	83 ef 04             	sub    $0x4,%edi
  8008ec:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008ef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008f2:	fd                   	std    
  8008f3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008f5:	eb 09                	jmp    800900 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008f7:	83 ef 01             	sub    $0x1,%edi
  8008fa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008fd:	fd                   	std    
  8008fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800900:	fc                   	cld    
  800901:	eb 1a                	jmp    80091d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800903:	89 c2                	mov    %eax,%edx
  800905:	09 ca                	or     %ecx,%edx
  800907:	09 f2                	or     %esi,%edx
  800909:	f6 c2 03             	test   $0x3,%dl
  80090c:	75 0a                	jne    800918 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80090e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800911:	89 c7                	mov    %eax,%edi
  800913:	fc                   	cld    
  800914:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800916:	eb 05                	jmp    80091d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800918:	89 c7                	mov    %eax,%edi
  80091a:	fc                   	cld    
  80091b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80091d:	5e                   	pop    %esi
  80091e:	5f                   	pop    %edi
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800927:	ff 75 10             	pushl  0x10(%ebp)
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	ff 75 08             	pushl  0x8(%ebp)
  800930:	e8 8a ff ff ff       	call   8008bf <memmove>
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	56                   	push   %esi
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800942:	89 c6                	mov    %eax,%esi
  800944:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800947:	39 f0                	cmp    %esi,%eax
  800949:	74 1c                	je     800967 <memcmp+0x30>
		if (*s1 != *s2)
  80094b:	0f b6 08             	movzbl (%eax),%ecx
  80094e:	0f b6 1a             	movzbl (%edx),%ebx
  800951:	38 d9                	cmp    %bl,%cl
  800953:	75 08                	jne    80095d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	eb ea                	jmp    800947 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80095d:	0f b6 c1             	movzbl %cl,%eax
  800960:	0f b6 db             	movzbl %bl,%ebx
  800963:	29 d8                	sub    %ebx,%eax
  800965:	eb 05                	jmp    80096c <memcmp+0x35>
	}

	return 0;
  800967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096c:	5b                   	pop    %ebx
  80096d:	5e                   	pop    %esi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800979:	89 c2                	mov    %eax,%edx
  80097b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80097e:	39 d0                	cmp    %edx,%eax
  800980:	73 09                	jae    80098b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800982:	38 08                	cmp    %cl,(%eax)
  800984:	74 05                	je     80098b <memfind+0x1b>
	for (; s < ends; s++)
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	eb f3                	jmp    80097e <memfind+0xe>
			break;
	return (void *) s;
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800996:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800999:	eb 03                	jmp    80099e <strtol+0x11>
		s++;
  80099b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80099e:	0f b6 01             	movzbl (%ecx),%eax
  8009a1:	3c 20                	cmp    $0x20,%al
  8009a3:	74 f6                	je     80099b <strtol+0xe>
  8009a5:	3c 09                	cmp    $0x9,%al
  8009a7:	74 f2                	je     80099b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009a9:	3c 2b                	cmp    $0x2b,%al
  8009ab:	74 2a                	je     8009d7 <strtol+0x4a>
	int neg = 0;
  8009ad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009b2:	3c 2d                	cmp    $0x2d,%al
  8009b4:	74 2b                	je     8009e1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009b6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009bc:	75 0f                	jne    8009cd <strtol+0x40>
  8009be:	80 39 30             	cmpb   $0x30,(%ecx)
  8009c1:	74 28                	je     8009eb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009c3:	85 db                	test   %ebx,%ebx
  8009c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ca:	0f 44 d8             	cmove  %eax,%ebx
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009d5:	eb 50                	jmp    800a27 <strtol+0x9a>
		s++;
  8009d7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009da:	bf 00 00 00 00       	mov    $0x0,%edi
  8009df:	eb d5                	jmp    8009b6 <strtol+0x29>
		s++, neg = 1;
  8009e1:	83 c1 01             	add    $0x1,%ecx
  8009e4:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e9:	eb cb                	jmp    8009b6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009eb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009ef:	74 0e                	je     8009ff <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8009f1:	85 db                	test   %ebx,%ebx
  8009f3:	75 d8                	jne    8009cd <strtol+0x40>
		s++, base = 8;
  8009f5:	83 c1 01             	add    $0x1,%ecx
  8009f8:	bb 08 00 00 00       	mov    $0x8,%ebx
  8009fd:	eb ce                	jmp    8009cd <strtol+0x40>
		s += 2, base = 16;
  8009ff:	83 c1 02             	add    $0x2,%ecx
  800a02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a07:	eb c4                	jmp    8009cd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a09:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a0c:	89 f3                	mov    %esi,%ebx
  800a0e:	80 fb 19             	cmp    $0x19,%bl
  800a11:	77 29                	ja     800a3c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a13:	0f be d2             	movsbl %dl,%edx
  800a16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a1c:	7d 30                	jge    800a4e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a1e:	83 c1 01             	add    $0x1,%ecx
  800a21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a27:	0f b6 11             	movzbl (%ecx),%edx
  800a2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a2d:	89 f3                	mov    %esi,%ebx
  800a2f:	80 fb 09             	cmp    $0x9,%bl
  800a32:	77 d5                	ja     800a09 <strtol+0x7c>
			dig = *s - '0';
  800a34:	0f be d2             	movsbl %dl,%edx
  800a37:	83 ea 30             	sub    $0x30,%edx
  800a3a:	eb dd                	jmp    800a19 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a3f:	89 f3                	mov    %esi,%ebx
  800a41:	80 fb 19             	cmp    $0x19,%bl
  800a44:	77 08                	ja     800a4e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a46:	0f be d2             	movsbl %dl,%edx
  800a49:	83 ea 37             	sub    $0x37,%edx
  800a4c:	eb cb                	jmp    800a19 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a52:	74 05                	je     800a59 <strtol+0xcc>
		*endptr = (char *) s;
  800a54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a59:	89 c2                	mov    %eax,%edx
  800a5b:	f7 da                	neg    %edx
  800a5d:	85 ff                	test   %edi,%edi
  800a5f:	0f 45 c2             	cmovne %edx,%eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5f                   	pop    %edi
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	57                   	push   %edi
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	8b 55 08             	mov    0x8(%ebp),%edx
  800a75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a78:	89 c3                	mov    %eax,%ebx
  800a7a:	89 c7                	mov    %eax,%edi
  800a7c:	89 c6                	mov    %eax,%esi
  800a7e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5f                   	pop    %edi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a90:	b8 01 00 00 00       	mov    $0x1,%eax
  800a95:	89 d1                	mov    %edx,%ecx
  800a97:	89 d3                	mov    %edx,%ebx
  800a99:	89 d7                	mov    %edx,%edi
  800a9b:	89 d6                	mov    %edx,%esi
  800a9d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5f                   	pop    %edi
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	57                   	push   %edi
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800aad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab5:	b8 03 00 00 00       	mov    $0x3,%eax
  800aba:	89 cb                	mov    %ecx,%ebx
  800abc:	89 cf                	mov    %ecx,%edi
  800abe:	89 ce                	mov    %ecx,%esi
  800ac0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ac2:	85 c0                	test   %eax,%eax
  800ac4:	7f 08                	jg     800ace <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ac9:	5b                   	pop    %ebx
  800aca:	5e                   	pop    %esi
  800acb:	5f                   	pop    %edi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ace:	83 ec 0c             	sub    $0xc,%esp
  800ad1:	50                   	push   %eax
  800ad2:	6a 03                	push   $0x3
  800ad4:	68 9f 25 80 00       	push   $0x80259f
  800ad9:	6a 23                	push   $0x23
  800adb:	68 bc 25 80 00       	push   $0x8025bc
  800ae0:	e8 b1 13 00 00       	call   801e96 <_panic>

00800ae5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	b8 02 00 00 00       	mov    $0x2,%eax
  800af5:	89 d1                	mov    %edx,%ecx
  800af7:	89 d3                	mov    %edx,%ebx
  800af9:	89 d7                	mov    %edx,%edi
  800afb:	89 d6                	mov    %edx,%esi
  800afd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <sys_yield>:

void
sys_yield(void)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	89 d3                	mov    %edx,%ebx
  800b18:	89 d7                	mov    %edx,%edi
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b2c:	be 00 00 00 00       	mov    $0x0,%esi
  800b31:	8b 55 08             	mov    0x8(%ebp),%edx
  800b34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b37:	b8 04 00 00 00       	mov    $0x4,%eax
  800b3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b3f:	89 f7                	mov    %esi,%edi
  800b41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b43:	85 c0                	test   %eax,%eax
  800b45:	7f 08                	jg     800b4f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	50                   	push   %eax
  800b53:	6a 04                	push   $0x4
  800b55:	68 9f 25 80 00       	push   $0x80259f
  800b5a:	6a 23                	push   $0x23
  800b5c:	68 bc 25 80 00       	push   $0x8025bc
  800b61:	e8 30 13 00 00       	call   801e96 <_panic>

00800b66 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b75:	b8 05 00 00 00       	mov    $0x5,%eax
  800b7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b7d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b80:	8b 75 18             	mov    0x18(%ebp),%esi
  800b83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b85:	85 c0                	test   %eax,%eax
  800b87:	7f 08                	jg     800b91 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b91:	83 ec 0c             	sub    $0xc,%esp
  800b94:	50                   	push   %eax
  800b95:	6a 05                	push   $0x5
  800b97:	68 9f 25 80 00       	push   $0x80259f
  800b9c:	6a 23                	push   $0x23
  800b9e:	68 bc 25 80 00       	push   $0x8025bc
  800ba3:	e8 ee 12 00 00       	call   801e96 <_panic>

00800ba8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	57                   	push   %edi
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbc:	b8 06 00 00 00       	mov    $0x6,%eax
  800bc1:	89 df                	mov    %ebx,%edi
  800bc3:	89 de                	mov    %ebx,%esi
  800bc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	7f 08                	jg     800bd3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	50                   	push   %eax
  800bd7:	6a 06                	push   $0x6
  800bd9:	68 9f 25 80 00       	push   $0x80259f
  800bde:	6a 23                	push   $0x23
  800be0:	68 bc 25 80 00       	push   $0x8025bc
  800be5:	e8 ac 12 00 00       	call   801e96 <_panic>

00800bea <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	57                   	push   %edi
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
  800bf0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfe:	b8 08 00 00 00       	mov    $0x8,%eax
  800c03:	89 df                	mov    %ebx,%edi
  800c05:	89 de                	mov    %ebx,%esi
  800c07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	7f 08                	jg     800c15 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 08                	push   $0x8
  800c1b:	68 9f 25 80 00       	push   $0x80259f
  800c20:	6a 23                	push   $0x23
  800c22:	68 bc 25 80 00       	push   $0x8025bc
  800c27:	e8 6a 12 00 00       	call   801e96 <_panic>

00800c2c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	b8 09 00 00 00       	mov    $0x9,%eax
  800c45:	89 df                	mov    %ebx,%edi
  800c47:	89 de                	mov    %ebx,%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 09                	push   $0x9
  800c5d:	68 9f 25 80 00       	push   $0x80259f
  800c62:	6a 23                	push   $0x23
  800c64:	68 bc 25 80 00       	push   $0x8025bc
  800c69:	e8 28 12 00 00       	call   801e96 <_panic>

00800c6e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 0a                	push   $0xa
  800c9f:	68 9f 25 80 00       	push   $0x80259f
  800ca4:	6a 23                	push   $0x23
  800ca6:	68 bc 25 80 00       	push   $0x8025bc
  800cab:	e8 e6 11 00 00       	call   801e96 <_panic>

00800cb0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc1:	be 00 00 00 00       	mov    $0x0,%esi
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ce9:	89 cb                	mov    %ecx,%ebx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	89 ce                	mov    %ecx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 0d                	push   $0xd
  800d03:	68 9f 25 80 00       	push   $0x80259f
  800d08:	6a 23                	push   $0x23
  800d0a:	68 bc 25 80 00       	push   $0x8025bc
  800d0f:	e8 82 11 00 00       	call   801e96 <_panic>

00800d14 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	05 00 00 00 30       	add    $0x30000000,%eax
  800d3e:	c1 e8 0c             	shr    $0xc,%eax
}
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d53:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d62:	89 c2                	mov    %eax,%edx
  800d64:	c1 ea 16             	shr    $0x16,%edx
  800d67:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d6e:	f6 c2 01             	test   $0x1,%dl
  800d71:	74 2d                	je     800da0 <fd_alloc+0x46>
  800d73:	89 c2                	mov    %eax,%edx
  800d75:	c1 ea 0c             	shr    $0xc,%edx
  800d78:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d7f:	f6 c2 01             	test   $0x1,%dl
  800d82:	74 1c                	je     800da0 <fd_alloc+0x46>
  800d84:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d89:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d8e:	75 d2                	jne    800d62 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d99:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d9e:	eb 0a                	jmp    800daa <fd_alloc+0x50>
			*fd_store = fd;
  800da0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800db2:	83 f8 1f             	cmp    $0x1f,%eax
  800db5:	77 30                	ja     800de7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800db7:	c1 e0 0c             	shl    $0xc,%eax
  800dba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dbf:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800dc5:	f6 c2 01             	test   $0x1,%dl
  800dc8:	74 24                	je     800dee <fd_lookup+0x42>
  800dca:	89 c2                	mov    %eax,%edx
  800dcc:	c1 ea 0c             	shr    $0xc,%edx
  800dcf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd6:	f6 c2 01             	test   $0x1,%dl
  800dd9:	74 1a                	je     800df5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dde:	89 02                	mov    %eax,(%edx)
	return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    
		return -E_INVAL;
  800de7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dec:	eb f7                	jmp    800de5 <fd_lookup+0x39>
		return -E_INVAL;
  800dee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df3:	eb f0                	jmp    800de5 <fd_lookup+0x39>
  800df5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfa:	eb e9                	jmp    800de5 <fd_lookup+0x39>

00800dfc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800e05:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e0f:	39 08                	cmp    %ecx,(%eax)
  800e11:	74 38                	je     800e4b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e13:	83 c2 01             	add    $0x1,%edx
  800e16:	8b 04 95 48 26 80 00 	mov    0x802648(,%edx,4),%eax
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 ee                	jne    800e0f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e21:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800e26:	8b 40 48             	mov    0x48(%eax),%eax
  800e29:	83 ec 04             	sub    $0x4,%esp
  800e2c:	51                   	push   %ecx
  800e2d:	50                   	push   %eax
  800e2e:	68 cc 25 80 00       	push   $0x8025cc
  800e33:	e8 1d f3 ff ff       	call   800155 <cprintf>
	*dev = 0;
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    
			*dev = devtab[i];
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e50:	b8 00 00 00 00       	mov    $0x0,%eax
  800e55:	eb f2                	jmp    800e49 <dev_lookup+0x4d>

00800e57 <fd_close>:
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 24             	sub    $0x24,%esp
  800e60:	8b 75 08             	mov    0x8(%ebp),%esi
  800e63:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e69:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e70:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e73:	50                   	push   %eax
  800e74:	e8 33 ff ff ff       	call   800dac <fd_lookup>
  800e79:	89 c3                	mov    %eax,%ebx
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	78 05                	js     800e87 <fd_close+0x30>
	    || fd != fd2)
  800e82:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e85:	74 16                	je     800e9d <fd_close+0x46>
		return (must_exist ? r : 0);
  800e87:	89 f8                	mov    %edi,%eax
  800e89:	84 c0                	test   %al,%al
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e90:	0f 44 d8             	cmove  %eax,%ebx
}
  800e93:	89 d8                	mov    %ebx,%eax
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ea3:	50                   	push   %eax
  800ea4:	ff 36                	pushl  (%esi)
  800ea6:	e8 51 ff ff ff       	call   800dfc <dev_lookup>
  800eab:	89 c3                	mov    %eax,%ebx
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	78 1a                	js     800ece <fd_close+0x77>
		if (dev->dev_close)
  800eb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eb7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800eba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	74 0b                	je     800ece <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	56                   	push   %esi
  800ec7:	ff d0                	call   *%eax
  800ec9:	89 c3                	mov    %eax,%ebx
  800ecb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ece:	83 ec 08             	sub    $0x8,%esp
  800ed1:	56                   	push   %esi
  800ed2:	6a 00                	push   $0x0
  800ed4:	e8 cf fc ff ff       	call   800ba8 <sys_page_unmap>
	return r;
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	eb b5                	jmp    800e93 <fd_close+0x3c>

00800ede <close>:

int
close(int fdnum)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ee7:	50                   	push   %eax
  800ee8:	ff 75 08             	pushl  0x8(%ebp)
  800eeb:	e8 bc fe ff ff       	call   800dac <fd_lookup>
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	79 02                	jns    800ef9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    
		return fd_close(fd, 1);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	6a 01                	push   $0x1
  800efe:	ff 75 f4             	pushl  -0xc(%ebp)
  800f01:	e8 51 ff ff ff       	call   800e57 <fd_close>
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	eb ec                	jmp    800ef7 <close+0x19>

00800f0b <close_all>:

void
close_all(void)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	53                   	push   %ebx
  800f1b:	e8 be ff ff ff       	call   800ede <close>
	for (i = 0; i < MAXFD; i++)
  800f20:	83 c3 01             	add    $0x1,%ebx
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	83 fb 20             	cmp    $0x20,%ebx
  800f29:	75 ec                	jne    800f17 <close_all+0xc>
}
  800f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f3c:	50                   	push   %eax
  800f3d:	ff 75 08             	pushl  0x8(%ebp)
  800f40:	e8 67 fe ff ff       	call   800dac <fd_lookup>
  800f45:	89 c3                	mov    %eax,%ebx
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	0f 88 81 00 00 00    	js     800fd3 <dup+0xa3>
		return r;
	close(newfdnum);
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	e8 81 ff ff ff       	call   800ede <close>

	newfd = INDEX2FD(newfdnum);
  800f5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f60:	c1 e6 0c             	shl    $0xc,%esi
  800f63:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f69:	83 c4 04             	add    $0x4,%esp
  800f6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f6f:	e8 cf fd ff ff       	call   800d43 <fd2data>
  800f74:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f76:	89 34 24             	mov    %esi,(%esp)
  800f79:	e8 c5 fd ff ff       	call   800d43 <fd2data>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f83:	89 d8                	mov    %ebx,%eax
  800f85:	c1 e8 16             	shr    $0x16,%eax
  800f88:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f8f:	a8 01                	test   $0x1,%al
  800f91:	74 11                	je     800fa4 <dup+0x74>
  800f93:	89 d8                	mov    %ebx,%eax
  800f95:	c1 e8 0c             	shr    $0xc,%eax
  800f98:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f9f:	f6 c2 01             	test   $0x1,%dl
  800fa2:	75 39                	jne    800fdd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fa7:	89 d0                	mov    %edx,%eax
  800fa9:	c1 e8 0c             	shr    $0xc,%eax
  800fac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	25 07 0e 00 00       	and    $0xe07,%eax
  800fbb:	50                   	push   %eax
  800fbc:	56                   	push   %esi
  800fbd:	6a 00                	push   $0x0
  800fbf:	52                   	push   %edx
  800fc0:	6a 00                	push   $0x0
  800fc2:	e8 9f fb ff ff       	call   800b66 <sys_page_map>
  800fc7:	89 c3                	mov    %eax,%ebx
  800fc9:	83 c4 20             	add    $0x20,%esp
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	78 31                	js     801001 <dup+0xd1>
		goto err;

	return newfdnum;
  800fd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fd3:	89 d8                	mov    %ebx,%eax
  800fd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fdd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe4:	83 ec 0c             	sub    $0xc,%esp
  800fe7:	25 07 0e 00 00       	and    $0xe07,%eax
  800fec:	50                   	push   %eax
  800fed:	57                   	push   %edi
  800fee:	6a 00                	push   $0x0
  800ff0:	53                   	push   %ebx
  800ff1:	6a 00                	push   $0x0
  800ff3:	e8 6e fb ff ff       	call   800b66 <sys_page_map>
  800ff8:	89 c3                	mov    %eax,%ebx
  800ffa:	83 c4 20             	add    $0x20,%esp
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	79 a3                	jns    800fa4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	56                   	push   %esi
  801005:	6a 00                	push   $0x0
  801007:	e8 9c fb ff ff       	call   800ba8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80100c:	83 c4 08             	add    $0x8,%esp
  80100f:	57                   	push   %edi
  801010:	6a 00                	push   $0x0
  801012:	e8 91 fb ff ff       	call   800ba8 <sys_page_unmap>
	return r;
  801017:	83 c4 10             	add    $0x10,%esp
  80101a:	eb b7                	jmp    800fd3 <dup+0xa3>

0080101c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	53                   	push   %ebx
  801020:	83 ec 1c             	sub    $0x1c,%esp
  801023:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801026:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801029:	50                   	push   %eax
  80102a:	53                   	push   %ebx
  80102b:	e8 7c fd ff ff       	call   800dac <fd_lookup>
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	78 3f                	js     801076 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80103d:	50                   	push   %eax
  80103e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801041:	ff 30                	pushl  (%eax)
  801043:	e8 b4 fd ff ff       	call   800dfc <dev_lookup>
  801048:	83 c4 10             	add    $0x10,%esp
  80104b:	85 c0                	test   %eax,%eax
  80104d:	78 27                	js     801076 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80104f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801052:	8b 42 08             	mov    0x8(%edx),%eax
  801055:	83 e0 03             	and    $0x3,%eax
  801058:	83 f8 01             	cmp    $0x1,%eax
  80105b:	74 1e                	je     80107b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801060:	8b 40 08             	mov    0x8(%eax),%eax
  801063:	85 c0                	test   %eax,%eax
  801065:	74 35                	je     80109c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801067:	83 ec 04             	sub    $0x4,%esp
  80106a:	ff 75 10             	pushl  0x10(%ebp)
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	52                   	push   %edx
  801071:	ff d0                	call   *%eax
  801073:	83 c4 10             	add    $0x10,%esp
}
  801076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801079:	c9                   	leave  
  80107a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80107b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801080:	8b 40 48             	mov    0x48(%eax),%eax
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	53                   	push   %ebx
  801087:	50                   	push   %eax
  801088:	68 0d 26 80 00       	push   $0x80260d
  80108d:	e8 c3 f0 ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109a:	eb da                	jmp    801076 <read+0x5a>
		return -E_NOT_SUPP;
  80109c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010a1:	eb d3                	jmp    801076 <read+0x5a>

008010a3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 0c             	sub    $0xc,%esp
  8010ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b7:	39 f3                	cmp    %esi,%ebx
  8010b9:	73 23                	jae    8010de <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	89 f0                	mov    %esi,%eax
  8010c0:	29 d8                	sub    %ebx,%eax
  8010c2:	50                   	push   %eax
  8010c3:	89 d8                	mov    %ebx,%eax
  8010c5:	03 45 0c             	add    0xc(%ebp),%eax
  8010c8:	50                   	push   %eax
  8010c9:	57                   	push   %edi
  8010ca:	e8 4d ff ff ff       	call   80101c <read>
		if (m < 0)
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	78 06                	js     8010dc <readn+0x39>
			return m;
		if (m == 0)
  8010d6:	74 06                	je     8010de <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8010d8:	01 c3                	add    %eax,%ebx
  8010da:	eb db                	jmp    8010b7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010dc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010de:	89 d8                	mov    %ebx,%eax
  8010e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5f                   	pop    %edi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	53                   	push   %ebx
  8010ec:	83 ec 1c             	sub    $0x1c,%esp
  8010ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f5:	50                   	push   %eax
  8010f6:	53                   	push   %ebx
  8010f7:	e8 b0 fc ff ff       	call   800dac <fd_lookup>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 3a                	js     80113d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801109:	50                   	push   %eax
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	ff 30                	pushl  (%eax)
  80110f:	e8 e8 fc ff ff       	call   800dfc <dev_lookup>
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	78 22                	js     80113d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80111b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801122:	74 1e                	je     801142 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801127:	8b 52 0c             	mov    0xc(%edx),%edx
  80112a:	85 d2                	test   %edx,%edx
  80112c:	74 35                	je     801163 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	ff 75 10             	pushl  0x10(%ebp)
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	50                   	push   %eax
  801138:	ff d2                	call   *%edx
  80113a:	83 c4 10             	add    $0x10,%esp
}
  80113d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801140:	c9                   	leave  
  801141:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801142:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801147:	8b 40 48             	mov    0x48(%eax),%eax
  80114a:	83 ec 04             	sub    $0x4,%esp
  80114d:	53                   	push   %ebx
  80114e:	50                   	push   %eax
  80114f:	68 29 26 80 00       	push   $0x802629
  801154:	e8 fc ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801161:	eb da                	jmp    80113d <write+0x55>
		return -E_NOT_SUPP;
  801163:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801168:	eb d3                	jmp    80113d <write+0x55>

0080116a <seek>:

int
seek(int fdnum, off_t offset)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	ff 75 08             	pushl  0x8(%ebp)
  801177:	e8 30 fc ff ff       	call   800dac <fd_lookup>
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 0e                	js     801191 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801183:	8b 55 0c             	mov    0xc(%ebp),%edx
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	53                   	push   %ebx
  801197:	83 ec 1c             	sub    $0x1c,%esp
  80119a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80119d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a0:	50                   	push   %eax
  8011a1:	53                   	push   %ebx
  8011a2:	e8 05 fc ff ff       	call   800dac <fd_lookup>
  8011a7:	83 c4 10             	add    $0x10,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	78 37                	js     8011e5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b4:	50                   	push   %eax
  8011b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b8:	ff 30                	pushl  (%eax)
  8011ba:	e8 3d fc ff ff       	call   800dfc <dev_lookup>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	78 1f                	js     8011e5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011cd:	74 1b                	je     8011ea <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d2:	8b 52 18             	mov    0x18(%edx),%edx
  8011d5:	85 d2                	test   %edx,%edx
  8011d7:	74 32                	je     80120b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	50                   	push   %eax
  8011e0:	ff d2                	call   *%edx
  8011e2:	83 c4 10             	add    $0x10,%esp
}
  8011e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011ea:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011ef:	8b 40 48             	mov    0x48(%eax),%eax
  8011f2:	83 ec 04             	sub    $0x4,%esp
  8011f5:	53                   	push   %ebx
  8011f6:	50                   	push   %eax
  8011f7:	68 ec 25 80 00       	push   $0x8025ec
  8011fc:	e8 54 ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801209:	eb da                	jmp    8011e5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80120b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801210:	eb d3                	jmp    8011e5 <ftruncate+0x52>

00801212 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	53                   	push   %ebx
  801216:	83 ec 1c             	sub    $0x1c,%esp
  801219:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	ff 75 08             	pushl  0x8(%ebp)
  801223:	e8 84 fb ff ff       	call   800dac <fd_lookup>
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 4b                	js     80127a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801235:	50                   	push   %eax
  801236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801239:	ff 30                	pushl  (%eax)
  80123b:	e8 bc fb ff ff       	call   800dfc <dev_lookup>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	78 33                	js     80127a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80124e:	74 2f                	je     80127f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801250:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801253:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80125a:	00 00 00 
	stat->st_isdir = 0;
  80125d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801264:	00 00 00 
	stat->st_dev = dev;
  801267:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	53                   	push   %ebx
  801271:	ff 75 f0             	pushl  -0x10(%ebp)
  801274:	ff 50 14             	call   *0x14(%eax)
  801277:	83 c4 10             	add    $0x10,%esp
}
  80127a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    
		return -E_NOT_SUPP;
  80127f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801284:	eb f4                	jmp    80127a <fstat+0x68>

00801286 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	56                   	push   %esi
  80128a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	6a 00                	push   $0x0
  801290:	ff 75 08             	pushl  0x8(%ebp)
  801293:	e8 2f 02 00 00       	call   8014c7 <open>
  801298:	89 c3                	mov    %eax,%ebx
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	85 c0                	test   %eax,%eax
  80129f:	78 1b                	js     8012bc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	e8 65 ff ff ff       	call   801212 <fstat>
  8012ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8012af:	89 1c 24             	mov    %ebx,(%esp)
  8012b2:	e8 27 fc ff ff       	call   800ede <close>
	return r;
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	89 f3                	mov    %esi,%ebx
}
  8012bc:	89 d8                	mov    %ebx,%eax
  8012be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c1:	5b                   	pop    %ebx
  8012c2:	5e                   	pop    %esi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
  8012ca:	89 c6                	mov    %eax,%esi
  8012cc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012ce:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012d5:	74 27                	je     8012fe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012d7:	6a 07                	push   $0x7
  8012d9:	68 00 50 80 00       	push   $0x805000
  8012de:	56                   	push   %esi
  8012df:	ff 35 00 40 80 00    	pushl  0x804000
  8012e5:	e8 65 0c 00 00       	call   801f4f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012ea:	83 c4 0c             	add    $0xc,%esp
  8012ed:	6a 00                	push   $0x0
  8012ef:	53                   	push   %ebx
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 e5 0b 00 00       	call   801edc <ipc_recv>
}
  8012f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 01                	push   $0x1
  801303:	e8 b3 0c 00 00       	call   801fbb <ipc_find_env>
  801308:	a3 00 40 80 00       	mov    %eax,0x804000
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	eb c5                	jmp    8012d7 <fsipc+0x12>

00801312 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8b 40 0c             	mov    0xc(%eax),%eax
  80131e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80132b:	ba 00 00 00 00       	mov    $0x0,%edx
  801330:	b8 02 00 00 00       	mov    $0x2,%eax
  801335:	e8 8b ff ff ff       	call   8012c5 <fsipc>
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <devfile_flush>:
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8b 40 0c             	mov    0xc(%eax),%eax
  801348:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80134d:	ba 00 00 00 00       	mov    $0x0,%edx
  801352:	b8 06 00 00 00       	mov    $0x6,%eax
  801357:	e8 69 ff ff ff       	call   8012c5 <fsipc>
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <devfile_stat>:
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	53                   	push   %ebx
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 40 0c             	mov    0xc(%eax),%eax
  80136e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	b8 05 00 00 00       	mov    $0x5,%eax
  80137d:	e8 43 ff ff ff       	call   8012c5 <fsipc>
  801382:	85 c0                	test   %eax,%eax
  801384:	78 2c                	js     8013b2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	68 00 50 80 00       	push   $0x805000
  80138e:	53                   	push   %ebx
  80138f:	e8 9d f3 ff ff       	call   800731 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801394:	a1 80 50 80 00       	mov    0x805080,%eax
  801399:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80139f:	a1 84 50 80 00       	mov    0x805084,%eax
  8013a4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <devfile_write>:
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8013c1:	85 db                	test   %ebx,%ebx
  8013c3:	75 07                	jne    8013cc <devfile_write+0x15>
	return n_all;
  8013c5:	89 d8                	mov    %ebx,%eax
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8013d2:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8013d7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	53                   	push   %ebx
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	68 08 50 80 00       	push   $0x805008
  8013e9:	e8 d1 f4 ff ff       	call   8008bf <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8013f8:	e8 c8 fe ff ff       	call   8012c5 <fsipc>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 c3                	js     8013c7 <devfile_write+0x10>
	  assert(r <= n_left);
  801404:	39 d8                	cmp    %ebx,%eax
  801406:	77 0b                	ja     801413 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801408:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80140d:	7f 1d                	jg     80142c <devfile_write+0x75>
    n_all += r;
  80140f:	89 c3                	mov    %eax,%ebx
  801411:	eb b2                	jmp    8013c5 <devfile_write+0xe>
	  assert(r <= n_left);
  801413:	68 5c 26 80 00       	push   $0x80265c
  801418:	68 68 26 80 00       	push   $0x802668
  80141d:	68 9f 00 00 00       	push   $0x9f
  801422:	68 7d 26 80 00       	push   $0x80267d
  801427:	e8 6a 0a 00 00       	call   801e96 <_panic>
	  assert(r <= PGSIZE);
  80142c:	68 88 26 80 00       	push   $0x802688
  801431:	68 68 26 80 00       	push   $0x802668
  801436:	68 a0 00 00 00       	push   $0xa0
  80143b:	68 7d 26 80 00       	push   $0x80267d
  801440:	e8 51 0a 00 00       	call   801e96 <_panic>

00801445 <devfile_read>:
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
  80144a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8b 40 0c             	mov    0xc(%eax),%eax
  801453:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801458:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80145e:	ba 00 00 00 00       	mov    $0x0,%edx
  801463:	b8 03 00 00 00       	mov    $0x3,%eax
  801468:	e8 58 fe ff ff       	call   8012c5 <fsipc>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 1f                	js     801492 <devfile_read+0x4d>
	assert(r <= n);
  801473:	39 f0                	cmp    %esi,%eax
  801475:	77 24                	ja     80149b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801477:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80147c:	7f 33                	jg     8014b1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	50                   	push   %eax
  801482:	68 00 50 80 00       	push   $0x805000
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 30 f4 ff ff       	call   8008bf <memmove>
	return r;
  80148f:	83 c4 10             	add    $0x10,%esp
}
  801492:	89 d8                	mov    %ebx,%eax
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    
	assert(r <= n);
  80149b:	68 94 26 80 00       	push   $0x802694
  8014a0:	68 68 26 80 00       	push   $0x802668
  8014a5:	6a 7c                	push   $0x7c
  8014a7:	68 7d 26 80 00       	push   $0x80267d
  8014ac:	e8 e5 09 00 00       	call   801e96 <_panic>
	assert(r <= PGSIZE);
  8014b1:	68 88 26 80 00       	push   $0x802688
  8014b6:	68 68 26 80 00       	push   $0x802668
  8014bb:	6a 7d                	push   $0x7d
  8014bd:	68 7d 26 80 00       	push   $0x80267d
  8014c2:	e8 cf 09 00 00       	call   801e96 <_panic>

008014c7 <open>:
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
  8014cc:	83 ec 1c             	sub    $0x1c,%esp
  8014cf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014d2:	56                   	push   %esi
  8014d3:	e8 20 f2 ff ff       	call   8006f8 <strlen>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014e0:	7f 6c                	jg     80154e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	e8 6c f8 ff ff       	call   800d5a <fd_alloc>
  8014ee:	89 c3                	mov    %eax,%ebx
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 3c                	js     801533 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	56                   	push   %esi
  8014fb:	68 00 50 80 00       	push   $0x805000
  801500:	e8 2c f2 ff ff       	call   800731 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80150d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801510:	b8 01 00 00 00       	mov    $0x1,%eax
  801515:	e8 ab fd ff ff       	call   8012c5 <fsipc>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 19                	js     80153c <open+0x75>
	return fd2num(fd);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 f4             	pushl  -0xc(%ebp)
  801529:	e8 05 f8 ff ff       	call   800d33 <fd2num>
  80152e:	89 c3                	mov    %eax,%ebx
  801530:	83 c4 10             	add    $0x10,%esp
}
  801533:	89 d8                	mov    %ebx,%eax
  801535:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    
		fd_close(fd, 0);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	6a 00                	push   $0x0
  801541:	ff 75 f4             	pushl  -0xc(%ebp)
  801544:	e8 0e f9 ff ff       	call   800e57 <fd_close>
		return r;
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb e5                	jmp    801533 <open+0x6c>
		return -E_BAD_PATH;
  80154e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801553:	eb de                	jmp    801533 <open+0x6c>

00801555 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	b8 08 00 00 00       	mov    $0x8,%eax
  801565:	e8 5b fd ff ff       	call   8012c5 <fsipc>
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	e8 c4 f7 ff ff       	call   800d43 <fd2data>
  80157f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801581:	83 c4 08             	add    $0x8,%esp
  801584:	68 9b 26 80 00       	push   $0x80269b
  801589:	53                   	push   %ebx
  80158a:	e8 a2 f1 ff ff       	call   800731 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80158f:	8b 46 04             	mov    0x4(%esi),%eax
  801592:	2b 06                	sub    (%esi),%eax
  801594:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80159a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a1:	00 00 00 
	stat->st_dev = &devpipe;
  8015a4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015ab:	30 80 00 
	return 0;
}
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015c4:	53                   	push   %ebx
  8015c5:	6a 00                	push   $0x0
  8015c7:	e8 dc f5 ff ff       	call   800ba8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015cc:	89 1c 24             	mov    %ebx,(%esp)
  8015cf:	e8 6f f7 ff ff       	call   800d43 <fd2data>
  8015d4:	83 c4 08             	add    $0x8,%esp
  8015d7:	50                   	push   %eax
  8015d8:	6a 00                	push   $0x0
  8015da:	e8 c9 f5 ff ff       	call   800ba8 <sys_page_unmap>
}
  8015df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <_pipeisclosed>:
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	57                   	push   %edi
  8015e8:	56                   	push   %esi
  8015e9:	53                   	push   %ebx
  8015ea:	83 ec 1c             	sub    $0x1c,%esp
  8015ed:	89 c7                	mov    %eax,%edi
  8015ef:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015f1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	57                   	push   %edi
  8015fd:	e8 f2 09 00 00       	call   801ff4 <pageref>
  801602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801605:	89 34 24             	mov    %esi,(%esp)
  801608:	e8 e7 09 00 00       	call   801ff4 <pageref>
		nn = thisenv->env_runs;
  80160d:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801613:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	39 cb                	cmp    %ecx,%ebx
  80161b:	74 1b                	je     801638 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80161d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801620:	75 cf                	jne    8015f1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801622:	8b 42 58             	mov    0x58(%edx),%eax
  801625:	6a 01                	push   $0x1
  801627:	50                   	push   %eax
  801628:	53                   	push   %ebx
  801629:	68 a2 26 80 00       	push   $0x8026a2
  80162e:	e8 22 eb ff ff       	call   800155 <cprintf>
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	eb b9                	jmp    8015f1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801638:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80163b:	0f 94 c0             	sete   %al
  80163e:	0f b6 c0             	movzbl %al,%eax
}
  801641:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801644:	5b                   	pop    %ebx
  801645:	5e                   	pop    %esi
  801646:	5f                   	pop    %edi
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <devpipe_write>:
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	57                   	push   %edi
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	83 ec 28             	sub    $0x28,%esp
  801652:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801655:	56                   	push   %esi
  801656:	e8 e8 f6 ff ff       	call   800d43 <fd2data>
  80165b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	bf 00 00 00 00       	mov    $0x0,%edi
  801665:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801668:	74 4f                	je     8016b9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80166a:	8b 43 04             	mov    0x4(%ebx),%eax
  80166d:	8b 0b                	mov    (%ebx),%ecx
  80166f:	8d 51 20             	lea    0x20(%ecx),%edx
  801672:	39 d0                	cmp    %edx,%eax
  801674:	72 14                	jb     80168a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801676:	89 da                	mov    %ebx,%edx
  801678:	89 f0                	mov    %esi,%eax
  80167a:	e8 65 ff ff ff       	call   8015e4 <_pipeisclosed>
  80167f:	85 c0                	test   %eax,%eax
  801681:	75 3b                	jne    8016be <devpipe_write+0x75>
			sys_yield();
  801683:	e8 7c f4 ff ff       	call   800b04 <sys_yield>
  801688:	eb e0                	jmp    80166a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80168a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801691:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801694:	89 c2                	mov    %eax,%edx
  801696:	c1 fa 1f             	sar    $0x1f,%edx
  801699:	89 d1                	mov    %edx,%ecx
  80169b:	c1 e9 1b             	shr    $0x1b,%ecx
  80169e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016a1:	83 e2 1f             	and    $0x1f,%edx
  8016a4:	29 ca                	sub    %ecx,%edx
  8016a6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016ae:	83 c0 01             	add    $0x1,%eax
  8016b1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016b4:	83 c7 01             	add    $0x1,%edi
  8016b7:	eb ac                	jmp    801665 <devpipe_write+0x1c>
	return i;
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	eb 05                	jmp    8016c3 <devpipe_write+0x7a>
				return 0;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c6:	5b                   	pop    %ebx
  8016c7:	5e                   	pop    %esi
  8016c8:	5f                   	pop    %edi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <devpipe_read>:
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	57                   	push   %edi
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 18             	sub    $0x18,%esp
  8016d4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016d7:	57                   	push   %edi
  8016d8:	e8 66 f6 ff ff       	call   800d43 <fd2data>
  8016dd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	be 00 00 00 00       	mov    $0x0,%esi
  8016e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016ea:	75 14                	jne    801700 <devpipe_read+0x35>
	return i;
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	eb 02                	jmp    8016f3 <devpipe_read+0x28>
				return i;
  8016f1:	89 f0                	mov    %esi,%eax
}
  8016f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5f                   	pop    %edi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    
			sys_yield();
  8016fb:	e8 04 f4 ff ff       	call   800b04 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801700:	8b 03                	mov    (%ebx),%eax
  801702:	3b 43 04             	cmp    0x4(%ebx),%eax
  801705:	75 18                	jne    80171f <devpipe_read+0x54>
			if (i > 0)
  801707:	85 f6                	test   %esi,%esi
  801709:	75 e6                	jne    8016f1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80170b:	89 da                	mov    %ebx,%edx
  80170d:	89 f8                	mov    %edi,%eax
  80170f:	e8 d0 fe ff ff       	call   8015e4 <_pipeisclosed>
  801714:	85 c0                	test   %eax,%eax
  801716:	74 e3                	je     8016fb <devpipe_read+0x30>
				return 0;
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
  80171d:	eb d4                	jmp    8016f3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80171f:	99                   	cltd   
  801720:	c1 ea 1b             	shr    $0x1b,%edx
  801723:	01 d0                	add    %edx,%eax
  801725:	83 e0 1f             	and    $0x1f,%eax
  801728:	29 d0                	sub    %edx,%eax
  80172a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80172f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801732:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801735:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801738:	83 c6 01             	add    $0x1,%esi
  80173b:	eb aa                	jmp    8016e7 <devpipe_read+0x1c>

0080173d <pipe>:
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801748:	50                   	push   %eax
  801749:	e8 0c f6 ff ff       	call   800d5a <fd_alloc>
  80174e:	89 c3                	mov    %eax,%ebx
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	0f 88 23 01 00 00    	js     80187e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 07 04 00 00       	push   $0x407
  801763:	ff 75 f4             	pushl  -0xc(%ebp)
  801766:	6a 00                	push   $0x0
  801768:	e8 b6 f3 ff ff       	call   800b23 <sys_page_alloc>
  80176d:	89 c3                	mov    %eax,%ebx
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	0f 88 04 01 00 00    	js     80187e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801780:	50                   	push   %eax
  801781:	e8 d4 f5 ff ff       	call   800d5a <fd_alloc>
  801786:	89 c3                	mov    %eax,%ebx
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	0f 88 db 00 00 00    	js     80186e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 07 04 00 00       	push   $0x407
  80179b:	ff 75 f0             	pushl  -0x10(%ebp)
  80179e:	6a 00                	push   $0x0
  8017a0:	e8 7e f3 ff ff       	call   800b23 <sys_page_alloc>
  8017a5:	89 c3                	mov    %eax,%ebx
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	0f 88 bc 00 00 00    	js     80186e <pipe+0x131>
	va = fd2data(fd0);
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b8:	e8 86 f5 ff ff       	call   800d43 <fd2data>
  8017bd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017bf:	83 c4 0c             	add    $0xc,%esp
  8017c2:	68 07 04 00 00       	push   $0x407
  8017c7:	50                   	push   %eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	e8 54 f3 ff ff       	call   800b23 <sys_page_alloc>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	0f 88 82 00 00 00    	js     80185e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017dc:	83 ec 0c             	sub    $0xc,%esp
  8017df:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e2:	e8 5c f5 ff ff       	call   800d43 <fd2data>
  8017e7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017ee:	50                   	push   %eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	56                   	push   %esi
  8017f2:	6a 00                	push   $0x0
  8017f4:	e8 6d f3 ff ff       	call   800b66 <sys_page_map>
  8017f9:	89 c3                	mov    %eax,%ebx
  8017fb:	83 c4 20             	add    $0x20,%esp
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 4e                	js     801850 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801802:	a1 20 30 80 00       	mov    0x803020,%eax
  801807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80180c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801816:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801819:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	ff 75 f4             	pushl  -0xc(%ebp)
  80182b:	e8 03 f5 ff ff       	call   800d33 <fd2num>
  801830:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801833:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801835:	83 c4 04             	add    $0x4,%esp
  801838:	ff 75 f0             	pushl  -0x10(%ebp)
  80183b:	e8 f3 f4 ff ff       	call   800d33 <fd2num>
  801840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801843:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184e:	eb 2e                	jmp    80187e <pipe+0x141>
	sys_page_unmap(0, va);
  801850:	83 ec 08             	sub    $0x8,%esp
  801853:	56                   	push   %esi
  801854:	6a 00                	push   $0x0
  801856:	e8 4d f3 ff ff       	call   800ba8 <sys_page_unmap>
  80185b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	ff 75 f0             	pushl  -0x10(%ebp)
  801864:	6a 00                	push   $0x0
  801866:	e8 3d f3 ff ff       	call   800ba8 <sys_page_unmap>
  80186b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 f4             	pushl  -0xc(%ebp)
  801874:	6a 00                	push   $0x0
  801876:	e8 2d f3 ff ff       	call   800ba8 <sys_page_unmap>
  80187b:	83 c4 10             	add    $0x10,%esp
}
  80187e:	89 d8                	mov    %ebx,%eax
  801880:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <pipeisclosed>:
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801890:	50                   	push   %eax
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	e8 13 f5 ff ff       	call   800dac <fd_lookup>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 18                	js     8018b8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a6:	e8 98 f4 ff ff       	call   800d43 <fd2data>
	return _pipeisclosed(fd, p);
  8018ab:	89 c2                	mov    %eax,%edx
  8018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b0:	e8 2f fd ff ff       	call   8015e4 <_pipeisclosed>
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018c0:	68 ba 26 80 00       	push   $0x8026ba
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	e8 64 ee ff ff       	call   800731 <strcpy>
	return 0;
}
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <devsock_close>:
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 10             	sub    $0x10,%esp
  8018db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018de:	53                   	push   %ebx
  8018df:	e8 10 07 00 00       	call   801ff4 <pageref>
  8018e4:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018ec:	83 f8 01             	cmp    $0x1,%eax
  8018ef:	74 07                	je     8018f8 <devsock_close+0x24>
}
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	ff 73 0c             	pushl  0xc(%ebx)
  8018fe:	e8 b9 02 00 00       	call   801bbc <nsipc_close>
  801903:	89 c2                	mov    %eax,%edx
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	eb e7                	jmp    8018f1 <devsock_close+0x1d>

0080190a <devsock_write>:
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801910:	6a 00                	push   $0x0
  801912:	ff 75 10             	pushl  0x10(%ebp)
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	ff 70 0c             	pushl  0xc(%eax)
  80191e:	e8 76 03 00 00       	call   801c99 <nsipc_send>
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <devsock_read>:
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 10             	pushl  0x10(%ebp)
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	ff 70 0c             	pushl  0xc(%eax)
  801939:	e8 ef 02 00 00       	call   801c2d <nsipc_recv>
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <fd2sockid>:
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801946:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	e8 5c f4 ff ff       	call   800dac <fd_lookup>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	85 c0                	test   %eax,%eax
  801955:	78 10                	js     801967 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195a:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801960:	39 08                	cmp    %ecx,(%eax)
  801962:	75 05                	jne    801969 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801964:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    
		return -E_NOT_SUPP;
  801969:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80196e:	eb f7                	jmp    801967 <fd2sockid+0x27>

00801970 <alloc_sockfd>:
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	83 ec 1c             	sub    $0x1c,%esp
  801978:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80197a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	e8 d7 f3 ff ff       	call   800d5a <fd_alloc>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 43                	js     8019cf <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 07 04 00 00       	push   $0x407
  801994:	ff 75 f4             	pushl  -0xc(%ebp)
  801997:	6a 00                	push   $0x0
  801999:	e8 85 f1 ff ff       	call   800b23 <sys_page_alloc>
  80199e:	89 c3                	mov    %eax,%ebx
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 28                	js     8019cf <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019aa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019b0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019bc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019bf:	83 ec 0c             	sub    $0xc,%esp
  8019c2:	50                   	push   %eax
  8019c3:	e8 6b f3 ff ff       	call   800d33 <fd2num>
  8019c8:	89 c3                	mov    %eax,%ebx
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	eb 0c                	jmp    8019db <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	56                   	push   %esi
  8019d3:	e8 e4 01 00 00       	call   801bbc <nsipc_close>
		return r;
  8019d8:	83 c4 10             	add    $0x10,%esp
}
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <accept>:
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	e8 4e ff ff ff       	call   801940 <fd2sockid>
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 1b                	js     801a11 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	ff 75 10             	pushl  0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	e8 0e 01 00 00       	call   801b13 <nsipc_accept>
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 05                	js     801a11 <accept+0x2d>
	return alloc_sockfd(r);
  801a0c:	e8 5f ff ff ff       	call   801970 <alloc_sockfd>
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <bind>:
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	e8 1f ff ff ff       	call   801940 <fd2sockid>
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 12                	js     801a37 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	ff 75 10             	pushl  0x10(%ebp)
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	50                   	push   %eax
  801a2f:	e8 31 01 00 00       	call   801b65 <nsipc_bind>
  801a34:	83 c4 10             	add    $0x10,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <shutdown>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	e8 f9 fe ff ff       	call   801940 <fd2sockid>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 0f                	js     801a5a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	50                   	push   %eax
  801a52:	e8 43 01 00 00       	call   801b9a <nsipc_shutdown>
  801a57:	83 c4 10             	add    $0x10,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <connect>:
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	e8 d6 fe ff ff       	call   801940 <fd2sockid>
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 12                	js     801a80 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	ff 75 10             	pushl  0x10(%ebp)
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	e8 59 01 00 00       	call   801bd6 <nsipc_connect>
  801a7d:	83 c4 10             	add    $0x10,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <listen>:
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	e8 b0 fe ff ff       	call   801940 <fd2sockid>
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 0f                	js     801aa3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	50                   	push   %eax
  801a9b:	e8 6b 01 00 00       	call   801c0b <nsipc_listen>
  801aa0:	83 c4 10             	add    $0x10,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 3e 02 00 00       	call   801cf7 <nsipc_socket>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 05                	js     801ac5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ac0:	e8 ab fe ff ff       	call   801970 <alloc_sockfd>
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ad0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ad7:	74 26                	je     801aff <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ad9:	6a 07                	push   $0x7
  801adb:	68 00 60 80 00       	push   $0x806000
  801ae0:	53                   	push   %ebx
  801ae1:	ff 35 04 40 80 00    	pushl  0x804004
  801ae7:	e8 63 04 00 00       	call   801f4f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aec:	83 c4 0c             	add    $0xc,%esp
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	e8 e2 03 00 00       	call   801edc <ipc_recv>
}
  801afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aff:	83 ec 0c             	sub    $0xc,%esp
  801b02:	6a 02                	push   $0x2
  801b04:	e8 b2 04 00 00       	call   801fbb <ipc_find_env>
  801b09:	a3 04 40 80 00       	mov    %eax,0x804004
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	eb c6                	jmp    801ad9 <nsipc+0x12>

00801b13 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b23:	8b 06                	mov    (%esi),%eax
  801b25:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2f:	e8 93 ff ff ff       	call   801ac7 <nsipc>
  801b34:	89 c3                	mov    %eax,%ebx
  801b36:	85 c0                	test   %eax,%eax
  801b38:	79 09                	jns    801b43 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b3a:	89 d8                	mov    %ebx,%eax
  801b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	ff 35 10 60 80 00    	pushl  0x806010
  801b4c:	68 00 60 80 00       	push   $0x806000
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	e8 66 ed ff ff       	call   8008bf <memmove>
		*addrlen = ret->ret_addrlen;
  801b59:	a1 10 60 80 00       	mov    0x806010,%eax
  801b5e:	89 06                	mov    %eax,(%esi)
  801b60:	83 c4 10             	add    $0x10,%esp
	return r;
  801b63:	eb d5                	jmp    801b3a <nsipc_accept+0x27>

00801b65 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b77:	53                   	push   %ebx
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	68 04 60 80 00       	push   $0x806004
  801b80:	e8 3a ed ff ff       	call   8008bf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b85:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b8b:	b8 02 00 00 00       	mov    $0x2,%eax
  801b90:	e8 32 ff ff ff       	call   801ac7 <nsipc>
}
  801b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb5:	e8 0d ff ff ff       	call   801ac7 <nsipc>
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <nsipc_close>:

int
nsipc_close(int s)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bca:	b8 04 00 00 00       	mov    $0x4,%eax
  801bcf:	e8 f3 fe ff ff       	call   801ac7 <nsipc>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 08             	sub    $0x8,%esp
  801bdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801be8:	53                   	push   %ebx
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	68 04 60 80 00       	push   $0x806004
  801bf1:	e8 c9 ec ff ff       	call   8008bf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bf6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bfc:	b8 05 00 00 00       	mov    $0x5,%eax
  801c01:	e8 c1 fe ff ff       	call   801ac7 <nsipc>
}
  801c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c21:	b8 06 00 00 00       	mov    $0x6,%eax
  801c26:	e8 9c fe ff ff       	call   801ac7 <nsipc>
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
  801c32:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c3d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c43:	8b 45 14             	mov    0x14(%ebp),%eax
  801c46:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c4b:	b8 07 00 00 00       	mov    $0x7,%eax
  801c50:	e8 72 fe ff ff       	call   801ac7 <nsipc>
  801c55:	89 c3                	mov    %eax,%ebx
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 1f                	js     801c7a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c5b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c60:	7f 21                	jg     801c83 <nsipc_recv+0x56>
  801c62:	39 c6                	cmp    %eax,%esi
  801c64:	7c 1d                	jl     801c83 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	50                   	push   %eax
  801c6a:	68 00 60 80 00       	push   $0x806000
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	e8 48 ec ff ff       	call   8008bf <memmove>
  801c77:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c7a:	89 d8                	mov    %ebx,%eax
  801c7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c83:	68 c6 26 80 00       	push   $0x8026c6
  801c88:	68 68 26 80 00       	push   $0x802668
  801c8d:	6a 62                	push   $0x62
  801c8f:	68 db 26 80 00       	push   $0x8026db
  801c94:	e8 fd 01 00 00       	call   801e96 <_panic>

00801c99 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cab:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cb1:	7f 2e                	jg     801ce1 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	53                   	push   %ebx
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	68 0c 60 80 00       	push   $0x80600c
  801cbf:	e8 fb eb ff ff       	call   8008bf <memmove>
	nsipcbuf.send.req_size = size;
  801cc4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801cd7:	e8 eb fd ff ff       	call   801ac7 <nsipc>
}
  801cdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    
	assert(size < 1600);
  801ce1:	68 e7 26 80 00       	push   $0x8026e7
  801ce6:	68 68 26 80 00       	push   $0x802668
  801ceb:	6a 6d                	push   $0x6d
  801ced:	68 db 26 80 00       	push   $0x8026db
  801cf2:	e8 9f 01 00 00       	call   801e96 <_panic>

00801cf7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d10:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d15:	b8 09 00 00 00       	mov    $0x9,%eax
  801d1a:	e8 a8 fd ff ff       	call   801ac7 <nsipc>
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
  801d26:	c3                   	ret    

00801d27 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d2d:	68 f3 26 80 00       	push   $0x8026f3
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	e8 f7 e9 ff ff       	call   800731 <strcpy>
	return 0;
}
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <devcons_write>:
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	57                   	push   %edi
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d4d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d52:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d58:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d5b:	73 31                	jae    801d8e <devcons_write+0x4d>
		m = n - tot;
  801d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d60:	29 f3                	sub    %esi,%ebx
  801d62:	83 fb 7f             	cmp    $0x7f,%ebx
  801d65:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d6a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	53                   	push   %ebx
  801d71:	89 f0                	mov    %esi,%eax
  801d73:	03 45 0c             	add    0xc(%ebp),%eax
  801d76:	50                   	push   %eax
  801d77:	57                   	push   %edi
  801d78:	e8 42 eb ff ff       	call   8008bf <memmove>
		sys_cputs(buf, m);
  801d7d:	83 c4 08             	add    $0x8,%esp
  801d80:	53                   	push   %ebx
  801d81:	57                   	push   %edi
  801d82:	e8 e0 ec ff ff       	call   800a67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d87:	01 de                	add    %ebx,%esi
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	eb ca                	jmp    801d58 <devcons_write+0x17>
}
  801d8e:	89 f0                	mov    %esi,%eax
  801d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <devcons_read>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801da7:	74 21                	je     801dca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801da9:	e8 d7 ec ff ff       	call   800a85 <sys_cgetc>
  801dae:	85 c0                	test   %eax,%eax
  801db0:	75 07                	jne    801db9 <devcons_read+0x21>
		sys_yield();
  801db2:	e8 4d ed ff ff       	call   800b04 <sys_yield>
  801db7:	eb f0                	jmp    801da9 <devcons_read+0x11>
	if (c < 0)
  801db9:	78 0f                	js     801dca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801dbb:	83 f8 04             	cmp    $0x4,%eax
  801dbe:	74 0c                	je     801dcc <devcons_read+0x34>
	*(char*)vbuf = c;
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	88 02                	mov    %al,(%edx)
	return 1;
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    
		return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	eb f7                	jmp    801dca <devcons_read+0x32>

00801dd3 <cputchar>:
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ddf:	6a 01                	push   $0x1
  801de1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de4:	50                   	push   %eax
  801de5:	e8 7d ec ff ff       	call   800a67 <sys_cputs>
}
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <getchar>:
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801df5:	6a 01                	push   $0x1
  801df7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dfa:	50                   	push   %eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 1a f2 ff ff       	call   80101c <read>
	if (r < 0)
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 06                	js     801e0f <getchar+0x20>
	if (r < 1)
  801e09:	74 06                	je     801e11 <getchar+0x22>
	return c;
  801e0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    
		return -E_EOF;
  801e11:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e16:	eb f7                	jmp    801e0f <getchar+0x20>

00801e18 <iscons>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e21:	50                   	push   %eax
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	e8 82 ef ff ff       	call   800dac <fd_lookup>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 11                	js     801e42 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e3a:	39 10                	cmp    %edx,(%eax)
  801e3c:	0f 94 c0             	sete   %al
  801e3f:	0f b6 c0             	movzbl %al,%eax
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <opencons>:
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4d:	50                   	push   %eax
  801e4e:	e8 07 ef ff ff       	call   800d5a <fd_alloc>
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 3a                	js     801e94 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e5a:	83 ec 04             	sub    $0x4,%esp
  801e5d:	68 07 04 00 00       	push   $0x407
  801e62:	ff 75 f4             	pushl  -0xc(%ebp)
  801e65:	6a 00                	push   $0x0
  801e67:	e8 b7 ec ff ff       	call   800b23 <sys_page_alloc>
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 21                	js     801e94 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e7c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	50                   	push   %eax
  801e8c:	e8 a2 ee ff ff       	call   800d33 <fd2num>
  801e91:	83 c4 10             	add    $0x10,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e9b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ea4:	e8 3c ec ff ff       	call   800ae5 <sys_getenvid>
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	56                   	push   %esi
  801eb3:	50                   	push   %eax
  801eb4:	68 00 27 80 00       	push   $0x802700
  801eb9:	e8 97 e2 ff ff       	call   800155 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ebe:	83 c4 18             	add    $0x18,%esp
  801ec1:	53                   	push   %ebx
  801ec2:	ff 75 10             	pushl  0x10(%ebp)
  801ec5:	e8 3a e2 ff ff       	call   800104 <vcprintf>
	cprintf("\n");
  801eca:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  801ed1:	e8 7f e2 ff ff       	call   800155 <cprintf>
  801ed6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ed9:	cc                   	int3   
  801eda:	eb fd                	jmp    801ed9 <_panic+0x43>

00801edc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	56                   	push   %esi
  801ee0:	53                   	push   %ebx
  801ee1:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801eea:	85 c0                	test   %eax,%eax
  801eec:	74 4f                	je     801f3d <ipc_recv+0x61>
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	50                   	push   %eax
  801ef2:	e8 dc ed ff ff       	call   800cd3 <sys_ipc_recv>
  801ef7:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801efa:	85 f6                	test   %esi,%esi
  801efc:	74 14                	je     801f12 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801efe:	ba 00 00 00 00       	mov    $0x0,%edx
  801f03:	85 c0                	test   %eax,%eax
  801f05:	75 09                	jne    801f10 <ipc_recv+0x34>
  801f07:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801f0d:	8b 52 74             	mov    0x74(%edx),%edx
  801f10:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f12:	85 db                	test   %ebx,%ebx
  801f14:	74 14                	je     801f2a <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f16:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	75 09                	jne    801f28 <ipc_recv+0x4c>
  801f1f:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801f25:	8b 52 78             	mov    0x78(%edx),%edx
  801f28:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 08                	jne    801f36 <ipc_recv+0x5a>
  801f2e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801f33:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	68 00 00 c0 ee       	push   $0xeec00000
  801f45:	e8 89 ed ff ff       	call   800cd3 <sys_ipc_recv>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	eb ab                	jmp    801efa <ipc_recv+0x1e>

00801f4f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	57                   	push   %edi
  801f53:	56                   	push   %esi
  801f54:	53                   	push   %ebx
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f5b:	8b 75 10             	mov    0x10(%ebp),%esi
  801f5e:	eb 20                	jmp    801f80 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f60:	6a 00                	push   $0x0
  801f62:	68 00 00 c0 ee       	push   $0xeec00000
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	57                   	push   %edi
  801f6b:	e8 40 ed ff ff       	call   800cb0 <sys_ipc_try_send>
  801f70:	89 c3                	mov    %eax,%ebx
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	eb 1f                	jmp    801f96 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f77:	e8 88 eb ff ff       	call   800b04 <sys_yield>
	while(retval != 0) {
  801f7c:	85 db                	test   %ebx,%ebx
  801f7e:	74 33                	je     801fb3 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f80:	85 f6                	test   %esi,%esi
  801f82:	74 dc                	je     801f60 <ipc_send+0x11>
  801f84:	ff 75 14             	pushl  0x14(%ebp)
  801f87:	56                   	push   %esi
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	57                   	push   %edi
  801f8c:	e8 1f ed ff ff       	call   800cb0 <sys_ipc_try_send>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f96:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f99:	74 dc                	je     801f77 <ipc_send+0x28>
  801f9b:	85 db                	test   %ebx,%ebx
  801f9d:	74 d8                	je     801f77 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	68 24 27 80 00       	push   $0x802724
  801fa7:	6a 35                	push   $0x35
  801fa9:	68 54 27 80 00       	push   $0x802754
  801fae:	e8 e3 fe ff ff       	call   801e96 <_panic>
	}
}
  801fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb6:	5b                   	pop    %ebx
  801fb7:	5e                   	pop    %esi
  801fb8:	5f                   	pop    %edi
  801fb9:	5d                   	pop    %ebp
  801fba:	c3                   	ret    

00801fbb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fc6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fc9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fcf:	8b 52 50             	mov    0x50(%edx),%edx
  801fd2:	39 ca                	cmp    %ecx,%edx
  801fd4:	74 11                	je     801fe7 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fd6:	83 c0 01             	add    $0x1,%eax
  801fd9:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fde:	75 e6                	jne    801fc6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe5:	eb 0b                	jmp    801ff2 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fe7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fef:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ffa:	89 d0                	mov    %edx,%eax
  801ffc:	c1 e8 16             	shr    $0x16,%eax
  801fff:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80200b:	f6 c1 01             	test   $0x1,%cl
  80200e:	74 1d                	je     80202d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802010:	c1 ea 0c             	shr    $0xc,%edx
  802013:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80201a:	f6 c2 01             	test   $0x1,%dl
  80201d:	74 0e                	je     80202d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80201f:	c1 ea 0c             	shr    $0xc,%edx
  802022:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802029:	ef 
  80202a:	0f b7 c0             	movzwl %ax,%eax
}
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    
  80202f:	90                   	nop

00802030 <__udivdi3>:
  802030:	f3 0f 1e fb          	endbr32 
  802034:	55                   	push   %ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	83 ec 1c             	sub    $0x1c,%esp
  80203b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80203f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802043:	8b 74 24 34          	mov    0x34(%esp),%esi
  802047:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80204b:	85 d2                	test   %edx,%edx
  80204d:	75 49                	jne    802098 <__udivdi3+0x68>
  80204f:	39 f3                	cmp    %esi,%ebx
  802051:	76 15                	jbe    802068 <__udivdi3+0x38>
  802053:	31 ff                	xor    %edi,%edi
  802055:	89 e8                	mov    %ebp,%eax
  802057:	89 f2                	mov    %esi,%edx
  802059:	f7 f3                	div    %ebx
  80205b:	89 fa                	mov    %edi,%edx
  80205d:	83 c4 1c             	add    $0x1c,%esp
  802060:	5b                   	pop    %ebx
  802061:	5e                   	pop    %esi
  802062:	5f                   	pop    %edi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    
  802065:	8d 76 00             	lea    0x0(%esi),%esi
  802068:	89 d9                	mov    %ebx,%ecx
  80206a:	85 db                	test   %ebx,%ebx
  80206c:	75 0b                	jne    802079 <__udivdi3+0x49>
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	f7 f3                	div    %ebx
  802077:	89 c1                	mov    %eax,%ecx
  802079:	31 d2                	xor    %edx,%edx
  80207b:	89 f0                	mov    %esi,%eax
  80207d:	f7 f1                	div    %ecx
  80207f:	89 c6                	mov    %eax,%esi
  802081:	89 e8                	mov    %ebp,%eax
  802083:	89 f7                	mov    %esi,%edi
  802085:	f7 f1                	div    %ecx
  802087:	89 fa                	mov    %edi,%edx
  802089:	83 c4 1c             	add    $0x1c,%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5f                   	pop    %edi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
  802091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802098:	39 f2                	cmp    %esi,%edx
  80209a:	77 1c                	ja     8020b8 <__udivdi3+0x88>
  80209c:	0f bd fa             	bsr    %edx,%edi
  80209f:	83 f7 1f             	xor    $0x1f,%edi
  8020a2:	75 2c                	jne    8020d0 <__udivdi3+0xa0>
  8020a4:	39 f2                	cmp    %esi,%edx
  8020a6:	72 06                	jb     8020ae <__udivdi3+0x7e>
  8020a8:	31 c0                	xor    %eax,%eax
  8020aa:	39 eb                	cmp    %ebp,%ebx
  8020ac:	77 ad                	ja     80205b <__udivdi3+0x2b>
  8020ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b3:	eb a6                	jmp    80205b <__udivdi3+0x2b>
  8020b5:	8d 76 00             	lea    0x0(%esi),%esi
  8020b8:	31 ff                	xor    %edi,%edi
  8020ba:	31 c0                	xor    %eax,%eax
  8020bc:	89 fa                	mov    %edi,%edx
  8020be:	83 c4 1c             	add    $0x1c,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    
  8020c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020cd:	8d 76 00             	lea    0x0(%esi),%esi
  8020d0:	89 f9                	mov    %edi,%ecx
  8020d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020d7:	29 f8                	sub    %edi,%eax
  8020d9:	d3 e2                	shl    %cl,%edx
  8020db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020df:	89 c1                	mov    %eax,%ecx
  8020e1:	89 da                	mov    %ebx,%edx
  8020e3:	d3 ea                	shr    %cl,%edx
  8020e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020e9:	09 d1                	or     %edx,%ecx
  8020eb:	89 f2                	mov    %esi,%edx
  8020ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f1:	89 f9                	mov    %edi,%ecx
  8020f3:	d3 e3                	shl    %cl,%ebx
  8020f5:	89 c1                	mov    %eax,%ecx
  8020f7:	d3 ea                	shr    %cl,%edx
  8020f9:	89 f9                	mov    %edi,%ecx
  8020fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ff:	89 eb                	mov    %ebp,%ebx
  802101:	d3 e6                	shl    %cl,%esi
  802103:	89 c1                	mov    %eax,%ecx
  802105:	d3 eb                	shr    %cl,%ebx
  802107:	09 de                	or     %ebx,%esi
  802109:	89 f0                	mov    %esi,%eax
  80210b:	f7 74 24 08          	divl   0x8(%esp)
  80210f:	89 d6                	mov    %edx,%esi
  802111:	89 c3                	mov    %eax,%ebx
  802113:	f7 64 24 0c          	mull   0xc(%esp)
  802117:	39 d6                	cmp    %edx,%esi
  802119:	72 15                	jb     802130 <__udivdi3+0x100>
  80211b:	89 f9                	mov    %edi,%ecx
  80211d:	d3 e5                	shl    %cl,%ebp
  80211f:	39 c5                	cmp    %eax,%ebp
  802121:	73 04                	jae    802127 <__udivdi3+0xf7>
  802123:	39 d6                	cmp    %edx,%esi
  802125:	74 09                	je     802130 <__udivdi3+0x100>
  802127:	89 d8                	mov    %ebx,%eax
  802129:	31 ff                	xor    %edi,%edi
  80212b:	e9 2b ff ff ff       	jmp    80205b <__udivdi3+0x2b>
  802130:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802133:	31 ff                	xor    %edi,%edi
  802135:	e9 21 ff ff ff       	jmp    80205b <__udivdi3+0x2b>
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <__umoddi3>:
  802140:	f3 0f 1e fb          	endbr32 
  802144:	55                   	push   %ebp
  802145:	57                   	push   %edi
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	83 ec 1c             	sub    $0x1c,%esp
  80214b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80214f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802153:	8b 74 24 30          	mov    0x30(%esp),%esi
  802157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80215b:	89 da                	mov    %ebx,%edx
  80215d:	85 c0                	test   %eax,%eax
  80215f:	75 3f                	jne    8021a0 <__umoddi3+0x60>
  802161:	39 df                	cmp    %ebx,%edi
  802163:	76 13                	jbe    802178 <__umoddi3+0x38>
  802165:	89 f0                	mov    %esi,%eax
  802167:	f7 f7                	div    %edi
  802169:	89 d0                	mov    %edx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	89 fd                	mov    %edi,%ebp
  80217a:	85 ff                	test   %edi,%edi
  80217c:	75 0b                	jne    802189 <__umoddi3+0x49>
  80217e:	b8 01 00 00 00       	mov    $0x1,%eax
  802183:	31 d2                	xor    %edx,%edx
  802185:	f7 f7                	div    %edi
  802187:	89 c5                	mov    %eax,%ebp
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	31 d2                	xor    %edx,%edx
  80218d:	f7 f5                	div    %ebp
  80218f:	89 f0                	mov    %esi,%eax
  802191:	f7 f5                	div    %ebp
  802193:	89 d0                	mov    %edx,%eax
  802195:	eb d4                	jmp    80216b <__umoddi3+0x2b>
  802197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	89 f1                	mov    %esi,%ecx
  8021a2:	39 d8                	cmp    %ebx,%eax
  8021a4:	76 0a                	jbe    8021b0 <__umoddi3+0x70>
  8021a6:	89 f0                	mov    %esi,%eax
  8021a8:	83 c4 1c             	add    $0x1c,%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5e                   	pop    %esi
  8021ad:	5f                   	pop    %edi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    
  8021b0:	0f bd e8             	bsr    %eax,%ebp
  8021b3:	83 f5 1f             	xor    $0x1f,%ebp
  8021b6:	75 20                	jne    8021d8 <__umoddi3+0x98>
  8021b8:	39 d8                	cmp    %ebx,%eax
  8021ba:	0f 82 b0 00 00 00    	jb     802270 <__umoddi3+0x130>
  8021c0:	39 f7                	cmp    %esi,%edi
  8021c2:	0f 86 a8 00 00 00    	jbe    802270 <__umoddi3+0x130>
  8021c8:	89 c8                	mov    %ecx,%eax
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	89 e9                	mov    %ebp,%ecx
  8021da:	ba 20 00 00 00       	mov    $0x20,%edx
  8021df:	29 ea                	sub    %ebp,%edx
  8021e1:	d3 e0                	shl    %cl,%eax
  8021e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e7:	89 d1                	mov    %edx,%ecx
  8021e9:	89 f8                	mov    %edi,%eax
  8021eb:	d3 e8                	shr    %cl,%eax
  8021ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021f9:	09 c1                	or     %eax,%ecx
  8021fb:	89 d8                	mov    %ebx,%eax
  8021fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802201:	89 e9                	mov    %ebp,%ecx
  802203:	d3 e7                	shl    %cl,%edi
  802205:	89 d1                	mov    %edx,%ecx
  802207:	d3 e8                	shr    %cl,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80220f:	d3 e3                	shl    %cl,%ebx
  802211:	89 c7                	mov    %eax,%edi
  802213:	89 d1                	mov    %edx,%ecx
  802215:	89 f0                	mov    %esi,%eax
  802217:	d3 e8                	shr    %cl,%eax
  802219:	89 e9                	mov    %ebp,%ecx
  80221b:	89 fa                	mov    %edi,%edx
  80221d:	d3 e6                	shl    %cl,%esi
  80221f:	09 d8                	or     %ebx,%eax
  802221:	f7 74 24 08          	divl   0x8(%esp)
  802225:	89 d1                	mov    %edx,%ecx
  802227:	89 f3                	mov    %esi,%ebx
  802229:	f7 64 24 0c          	mull   0xc(%esp)
  80222d:	89 c6                	mov    %eax,%esi
  80222f:	89 d7                	mov    %edx,%edi
  802231:	39 d1                	cmp    %edx,%ecx
  802233:	72 06                	jb     80223b <__umoddi3+0xfb>
  802235:	75 10                	jne    802247 <__umoddi3+0x107>
  802237:	39 c3                	cmp    %eax,%ebx
  802239:	73 0c                	jae    802247 <__umoddi3+0x107>
  80223b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80223f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802243:	89 d7                	mov    %edx,%edi
  802245:	89 c6                	mov    %eax,%esi
  802247:	89 ca                	mov    %ecx,%edx
  802249:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80224e:	29 f3                	sub    %esi,%ebx
  802250:	19 fa                	sbb    %edi,%edx
  802252:	89 d0                	mov    %edx,%eax
  802254:	d3 e0                	shl    %cl,%eax
  802256:	89 e9                	mov    %ebp,%ecx
  802258:	d3 eb                	shr    %cl,%ebx
  80225a:	d3 ea                	shr    %cl,%edx
  80225c:	09 d8                	or     %ebx,%eax
  80225e:	83 c4 1c             	add    $0x1c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    
  802266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80226d:	8d 76 00             	lea    0x0(%esi),%esi
  802270:	89 da                	mov    %ebx,%edx
  802272:	29 fe                	sub    %edi,%esi
  802274:	19 c2                	sbb    %eax,%edx
  802276:	89 f1                	mov    %esi,%ecx
  802278:	89 c8                	mov    %ecx,%eax
  80227a:	e9 4b ff ff ff       	jmp    8021ca <__umoddi3+0x8a>
