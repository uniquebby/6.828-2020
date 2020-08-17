
obj/user/faultread.debug：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 80 22 80 00       	push   $0x802280
  800044:	e8 fa 00 00 00       	call   800143 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 75 0a 00 00       	call   800ad3 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 5a 0e 00 00       	call   800ef9 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 e9 09 00 00       	call   800a92 <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	53                   	push   %ebx
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b8:	8b 13                	mov    (%ebx),%edx
  8000ba:	8d 42 01             	lea    0x1(%edx),%eax
  8000bd:	89 03                	mov    %eax,(%ebx)
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cb:	74 09                	je     8000d6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000cd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 ff 00 00 00       	push   $0xff
  8000de:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e1:	50                   	push   %eax
  8000e2:	e8 6e 09 00 00       	call   800a55 <sys_cputs>
		b->idx = 0;
  8000e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb db                	jmp    8000cd <putch+0x1f>

008000f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800102:	00 00 00 
	b.cnt = 0;
  800105:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010f:	ff 75 0c             	pushl  0xc(%ebp)
  800112:	ff 75 08             	pushl  0x8(%ebp)
  800115:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011b:	50                   	push   %eax
  80011c:	68 ae 00 80 00       	push   $0x8000ae
  800121:	e8 19 01 00 00       	call   80023f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800126:	83 c4 08             	add    $0x8,%esp
  800129:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800135:	50                   	push   %eax
  800136:	e8 1a 09 00 00       	call   800a55 <sys_cputs>

	return b.cnt;
}
  80013b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800149:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80014c:	50                   	push   %eax
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	e8 9d ff ff ff       	call   8000f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 1c             	sub    $0x1c,%esp
  800160:	89 c7                	mov    %eax,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	8b 45 08             	mov    0x8(%ebp),%eax
  800167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80016d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800173:	bb 00 00 00 00       	mov    $0x0,%ebx
  800178:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80017b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80017e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800181:	89 d0                	mov    %edx,%eax
  800183:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800186:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800189:	73 15                	jae    8001a0 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80018b:	83 eb 01             	sub    $0x1,%ebx
  80018e:	85 db                	test   %ebx,%ebx
  800190:	7e 43                	jle    8001d5 <printnum+0x7e>
			putch(padc, putdat);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	56                   	push   %esi
  800196:	ff 75 18             	pushl  0x18(%ebp)
  800199:	ff d7                	call   *%edi
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	eb eb                	jmp    80018b <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 18             	pushl  0x18(%ebp)
  8001a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ac:	53                   	push   %ebx
  8001ad:	ff 75 10             	pushl  0x10(%ebp)
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bf:	e8 5c 1e 00 00       	call   802020 <__udivdi3>
  8001c4:	83 c4 18             	add    $0x18,%esp
  8001c7:	52                   	push   %edx
  8001c8:	50                   	push   %eax
  8001c9:	89 f2                	mov    %esi,%edx
  8001cb:	89 f8                	mov    %edi,%eax
  8001cd:	e8 85 ff ff ff       	call   800157 <printnum>
  8001d2:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	56                   	push   %esi
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e8:	e8 43 1f 00 00       	call   802130 <__umoddi3>
  8001ed:	83 c4 14             	add    $0x14,%esp
  8001f0:	0f be 80 a8 22 80 00 	movsbl 0x8022a8(%eax),%eax
  8001f7:	50                   	push   %eax
  8001f8:	ff d7                	call   *%edi
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    

00800205 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80020f:	8b 10                	mov    (%eax),%edx
  800211:	3b 50 04             	cmp    0x4(%eax),%edx
  800214:	73 0a                	jae    800220 <sprintputch+0x1b>
		*b->buf++ = ch;
  800216:	8d 4a 01             	lea    0x1(%edx),%ecx
  800219:	89 08                	mov    %ecx,(%eax)
  80021b:	8b 45 08             	mov    0x8(%ebp),%eax
  80021e:	88 02                	mov    %al,(%edx)
}
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    

00800222 <printfmt>:
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800228:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022b:	50                   	push   %eax
  80022c:	ff 75 10             	pushl  0x10(%ebp)
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	e8 05 00 00 00       	call   80023f <vprintfmt>
}
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <vprintfmt>:
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 3c             	sub    $0x3c,%esp
  800248:	8b 75 08             	mov    0x8(%ebp),%esi
  80024b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80024e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800251:	eb 0a                	jmp    80025d <vprintfmt+0x1e>
			putch(ch, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	53                   	push   %ebx
  800257:	50                   	push   %eax
  800258:	ff d6                	call   *%esi
  80025a:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80025d:	83 c7 01             	add    $0x1,%edi
  800260:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800264:	83 f8 25             	cmp    $0x25,%eax
  800267:	74 0c                	je     800275 <vprintfmt+0x36>
			if (ch == '\0')
  800269:	85 c0                	test   %eax,%eax
  80026b:	75 e6                	jne    800253 <vprintfmt+0x14>
}
  80026d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800270:	5b                   	pop    %ebx
  800271:	5e                   	pop    %esi
  800272:	5f                   	pop    %edi
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    
		padc = ' ';
  800275:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800279:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800280:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800287:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80028e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800293:	8d 47 01             	lea    0x1(%edi),%eax
  800296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800299:	0f b6 17             	movzbl (%edi),%edx
  80029c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80029f:	3c 55                	cmp    $0x55,%al
  8002a1:	0f 87 ba 03 00 00    	ja     800661 <vprintfmt+0x422>
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  8002b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002b8:	eb d9                	jmp    800293 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002bd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002c1:	eb d0                	jmp    800293 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002c3:	0f b6 d2             	movzbl %dl,%edx
  8002c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002db:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002de:	83 f9 09             	cmp    $0x9,%ecx
  8002e1:	77 55                	ja     800338 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e6:	eb e9                	jmp    8002d1 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f3:	8d 40 04             	lea    0x4(%eax),%eax
  8002f6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800300:	79 91                	jns    800293 <vprintfmt+0x54>
				width = precision, precision = -1;
  800302:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800308:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80030f:	eb 82                	jmp    800293 <vprintfmt+0x54>
  800311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800314:	85 c0                	test   %eax,%eax
  800316:	ba 00 00 00 00       	mov    $0x0,%edx
  80031b:	0f 49 d0             	cmovns %eax,%edx
  80031e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800324:	e9 6a ff ff ff       	jmp    800293 <vprintfmt+0x54>
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800333:	e9 5b ff ff ff       	jmp    800293 <vprintfmt+0x54>
  800338:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033e:	eb bc                	jmp    8002fc <vprintfmt+0xbd>
			lflag++;
  800340:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800346:	e9 48 ff ff ff       	jmp    800293 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80034b:	8b 45 14             	mov    0x14(%ebp),%eax
  80034e:	8d 78 04             	lea    0x4(%eax),%edi
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	53                   	push   %ebx
  800355:	ff 30                	pushl  (%eax)
  800357:	ff d6                	call   *%esi
			break;
  800359:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80035f:	e9 9c 02 00 00       	jmp    800600 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800364:	8b 45 14             	mov    0x14(%ebp),%eax
  800367:	8d 78 04             	lea    0x4(%eax),%edi
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	99                   	cltd   
  80036d:	31 d0                	xor    %edx,%eax
  80036f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800371:	83 f8 0f             	cmp    $0xf,%eax
  800374:	7f 23                	jg     800399 <vprintfmt+0x15a>
  800376:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80037d:	85 d2                	test   %edx,%edx
  80037f:	74 18                	je     800399 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800381:	52                   	push   %edx
  800382:	68 7a 26 80 00       	push   $0x80267a
  800387:	53                   	push   %ebx
  800388:	56                   	push   %esi
  800389:	e8 94 fe ff ff       	call   800222 <printfmt>
  80038e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800391:	89 7d 14             	mov    %edi,0x14(%ebp)
  800394:	e9 67 02 00 00       	jmp    800600 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800399:	50                   	push   %eax
  80039a:	68 c0 22 80 00       	push   $0x8022c0
  80039f:	53                   	push   %ebx
  8003a0:	56                   	push   %esi
  8003a1:	e8 7c fe ff ff       	call   800222 <printfmt>
  8003a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ac:	e9 4f 02 00 00       	jmp    800600 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	83 c0 04             	add    $0x4,%eax
  8003b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003bf:	85 d2                	test   %edx,%edx
  8003c1:	b8 b9 22 80 00       	mov    $0x8022b9,%eax
  8003c6:	0f 45 c2             	cmovne %edx,%eax
  8003c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d0:	7e 06                	jle    8003d8 <vprintfmt+0x199>
  8003d2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003d6:	75 0d                	jne    8003e5 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003db:	89 c7                	mov    %eax,%edi
  8003dd:	03 45 e0             	add    -0x20(%ebp),%eax
  8003e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e3:	eb 3f                	jmp    800424 <vprintfmt+0x1e5>
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003eb:	50                   	push   %eax
  8003ec:	e8 0d 03 00 00       	call   8006fe <strnlen>
  8003f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f4:	29 c2                	sub    %eax,%edx
  8003f6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8003fe:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800405:	85 ff                	test   %edi,%edi
  800407:	7e 58                	jle    800461 <vprintfmt+0x222>
					putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	53                   	push   %ebx
  80040d:	ff 75 e0             	pushl  -0x20(%ebp)
  800410:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800412:	83 ef 01             	sub    $0x1,%edi
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	eb eb                	jmp    800405 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	53                   	push   %ebx
  80041e:	52                   	push   %edx
  80041f:	ff d6                	call   *%esi
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800427:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800429:	83 c7 01             	add    $0x1,%edi
  80042c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800430:	0f be d0             	movsbl %al,%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 45                	je     80047c <vprintfmt+0x23d>
  800437:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80043b:	78 06                	js     800443 <vprintfmt+0x204>
  80043d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800441:	78 35                	js     800478 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800443:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800447:	74 d1                	je     80041a <vprintfmt+0x1db>
  800449:	0f be c0             	movsbl %al,%eax
  80044c:	83 e8 20             	sub    $0x20,%eax
  80044f:	83 f8 5e             	cmp    $0x5e,%eax
  800452:	76 c6                	jbe    80041a <vprintfmt+0x1db>
					putch('?', putdat);
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	53                   	push   %ebx
  800458:	6a 3f                	push   $0x3f
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	eb c3                	jmp    800424 <vprintfmt+0x1e5>
  800461:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800464:	85 d2                	test   %edx,%edx
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
  80046b:	0f 49 c2             	cmovns %edx,%eax
  80046e:	29 c2                	sub    %eax,%edx
  800470:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800473:	e9 60 ff ff ff       	jmp    8003d8 <vprintfmt+0x199>
  800478:	89 cf                	mov    %ecx,%edi
  80047a:	eb 02                	jmp    80047e <vprintfmt+0x23f>
  80047c:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80047e:	85 ff                	test   %edi,%edi
  800480:	7e 10                	jle    800492 <vprintfmt+0x253>
				putch(' ', putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	6a 20                	push   $0x20
  800488:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80048a:	83 ef 01             	sub    $0x1,%edi
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	eb ec                	jmp    80047e <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 63 01 00 00       	jmp    800600 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80049d:	83 f9 01             	cmp    $0x1,%ecx
  8004a0:	7f 1b                	jg     8004bd <vprintfmt+0x27e>
	else if (lflag)
  8004a2:	85 c9                	test   %ecx,%ecx
  8004a4:	74 63                	je     800509 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	99                   	cltd   
  8004af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 04             	lea    0x4(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	eb 17                	jmp    8004d4 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 50 04             	mov    0x4(%eax),%edx
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 40 08             	lea    0x8(%eax),%eax
  8004d1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004da:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004df:	85 c9                	test   %ecx,%ecx
  8004e1:	0f 89 ff 00 00 00    	jns    8005e6 <vprintfmt+0x3a7>
				putch('-', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 2d                	push   $0x2d
  8004ed:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f5:	f7 da                	neg    %edx
  8004f7:	83 d1 00             	adc    $0x0,%ecx
  8004fa:	f7 d9                	neg    %ecx
  8004fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800504:	e9 dd 00 00 00       	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	99                   	cltd   
  800512:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 40 04             	lea    0x4(%eax),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	eb b4                	jmp    8004d4 <vprintfmt+0x295>
	if (lflag >= 2)
  800520:	83 f9 01             	cmp    $0x1,%ecx
  800523:	7f 1e                	jg     800543 <vprintfmt+0x304>
	else if (lflag)
  800525:	85 c9                	test   %ecx,%ecx
  800527:	74 32                	je     80055b <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 10                	mov    (%eax),%edx
  80052e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800533:	8d 40 04             	lea    0x4(%eax),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800539:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053e:	e9 a3 00 00 00       	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 10                	mov    (%eax),%edx
  800548:	8b 48 04             	mov    0x4(%eax),%ecx
  80054b:	8d 40 08             	lea    0x8(%eax),%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800551:	b8 0a 00 00 00       	mov    $0xa,%eax
  800556:	e9 8b 00 00 00       	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800570:	eb 74                	jmp    8005e6 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800572:	83 f9 01             	cmp    $0x1,%ecx
  800575:	7f 1b                	jg     800592 <vprintfmt+0x353>
	else if (lflag)
  800577:	85 c9                	test   %ecx,%ecx
  800579:	74 2c                	je     8005a7 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 10                	mov    (%eax),%edx
  800580:	b9 00 00 00 00       	mov    $0x0,%ecx
  800585:	8d 40 04             	lea    0x4(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80058b:	b8 08 00 00 00       	mov    $0x8,%eax
  800590:	eb 54                	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 10                	mov    (%eax),%edx
  800597:	8b 48 04             	mov    0x4(%eax),%ecx
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a5:	eb 3f                	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005bc:	eb 28                	jmp    8005e6 <vprintfmt+0x3a7>
			putch('0', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 30                	push   $0x30
  8005c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c6:	83 c4 08             	add    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 78                	push   $0x78
  8005cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005d8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ed:	57                   	push   %edi
  8005ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	89 da                	mov    %ebx,%edx
  8005f6:	89 f0                	mov    %esi,%eax
  8005f8:	e8 5a fb ff ff       	call   800157 <printnum>
			break;
  8005fd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800603:	e9 55 fc ff ff       	jmp    80025d <vprintfmt+0x1e>
	if (lflag >= 2)
  800608:	83 f9 01             	cmp    $0x1,%ecx
  80060b:	7f 1b                	jg     800628 <vprintfmt+0x3e9>
	else if (lflag)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	74 2c                	je     80063d <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 10                	mov    (%eax),%edx
  800616:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061b:	8d 40 04             	lea    0x4(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800621:	b8 10 00 00 00       	mov    $0x10,%eax
  800626:	eb be                	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	8b 48 04             	mov    0x4(%eax),%ecx
  800630:	8d 40 08             	lea    0x8(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800636:	b8 10 00 00 00       	mov    $0x10,%eax
  80063b:	eb a9                	jmp    8005e6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 10                	mov    (%eax),%edx
  800642:	b9 00 00 00 00       	mov    $0x0,%ecx
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064d:	b8 10 00 00 00       	mov    $0x10,%eax
  800652:	eb 92                	jmp    8005e6 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	53                   	push   %ebx
  800658:	6a 25                	push   $0x25
  80065a:	ff d6                	call   *%esi
			break;
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb 9f                	jmp    800600 <vprintfmt+0x3c1>
			putch('%', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 25                	push   $0x25
  800667:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	89 f8                	mov    %edi,%eax
  80066e:	eb 03                	jmp    800673 <vprintfmt+0x434>
  800670:	83 e8 01             	sub    $0x1,%eax
  800673:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800677:	75 f7                	jne    800670 <vprintfmt+0x431>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80067c:	eb 82                	jmp    800600 <vprintfmt+0x3c1>

0080067e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80068a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80068d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800691:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80069b:	85 c0                	test   %eax,%eax
  80069d:	74 26                	je     8006c5 <vsnprintf+0x47>
  80069f:	85 d2                	test   %edx,%edx
  8006a1:	7e 22                	jle    8006c5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006a3:	ff 75 14             	pushl  0x14(%ebp)
  8006a6:	ff 75 10             	pushl  0x10(%ebp)
  8006a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ac:	50                   	push   %eax
  8006ad:	68 05 02 80 00       	push   $0x800205
  8006b2:	e8 88 fb ff ff       	call   80023f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
}
  8006c3:	c9                   	leave  
  8006c4:	c3                   	ret    
		return -E_INVAL;
  8006c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ca:	eb f7                	jmp    8006c3 <vsnprintf+0x45>

008006cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 10             	pushl  0x10(%ebp)
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	e8 9a ff ff ff       	call   80067e <vsnprintf>
	va_end(ap);

	return rc;
}
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    

008006e6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
  8006e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006f5:	74 05                	je     8006fc <strlen+0x16>
		n++;
  8006f7:	83 c0 01             	add    $0x1,%eax
  8006fa:	eb f5                	jmp    8006f1 <strlen+0xb>
	return n;
}
  8006fc:	5d                   	pop    %ebp
  8006fd:	c3                   	ret    

008006fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	39 c2                	cmp    %eax,%edx
  80070e:	74 0d                	je     80071d <strnlen+0x1f>
  800710:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800714:	74 05                	je     80071b <strnlen+0x1d>
		n++;
  800716:	83 c2 01             	add    $0x1,%edx
  800719:	eb f1                	jmp    80070c <strnlen+0xe>
  80071b:	89 d0                	mov    %edx,%eax
	return n;
}
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	53                   	push   %ebx
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800732:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800735:	83 c2 01             	add    $0x1,%edx
  800738:	84 c9                	test   %cl,%cl
  80073a:	75 f2                	jne    80072e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80073c:	5b                   	pop    %ebx
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	53                   	push   %ebx
  800743:	83 ec 10             	sub    $0x10,%esp
  800746:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800749:	53                   	push   %ebx
  80074a:	e8 97 ff ff ff       	call   8006e6 <strlen>
  80074f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	01 d8                	add    %ebx,%eax
  800757:	50                   	push   %eax
  800758:	e8 c2 ff ff ff       	call   80071f <strcpy>
	return dst;
}
  80075d:	89 d8                	mov    %ebx,%eax
  80075f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	56                   	push   %esi
  800768:	53                   	push   %ebx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076f:	89 c6                	mov    %eax,%esi
  800771:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800774:	89 c2                	mov    %eax,%edx
  800776:	39 f2                	cmp    %esi,%edx
  800778:	74 11                	je     80078b <strncpy+0x27>
		*dst++ = *src;
  80077a:	83 c2 01             	add    $0x1,%edx
  80077d:	0f b6 19             	movzbl (%ecx),%ebx
  800780:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800783:	80 fb 01             	cmp    $0x1,%bl
  800786:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800789:	eb eb                	jmp    800776 <strncpy+0x12>
	}
	return ret;
}
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	56                   	push   %esi
  800793:	53                   	push   %ebx
  800794:	8b 75 08             	mov    0x8(%ebp),%esi
  800797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80079a:	8b 55 10             	mov    0x10(%ebp),%edx
  80079d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	74 21                	je     8007c4 <strlcpy+0x35>
  8007a3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007a7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <strlcpy+0x32>
  8007ad:	0f b6 19             	movzbl (%ecx),%ebx
  8007b0:	84 db                	test   %bl,%bl
  8007b2:	74 0b                	je     8007bf <strlcpy+0x30>
			*dst++ = *src++;
  8007b4:	83 c1 01             	add    $0x1,%ecx
  8007b7:	83 c2 01             	add    $0x1,%edx
  8007ba:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007bd:	eb ea                	jmp    8007a9 <strlcpy+0x1a>
  8007bf:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007c1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007c4:	29 f0                	sub    %esi,%eax
}
  8007c6:	5b                   	pop    %ebx
  8007c7:	5e                   	pop    %esi
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007d3:	0f b6 01             	movzbl (%ecx),%eax
  8007d6:	84 c0                	test   %al,%al
  8007d8:	74 0c                	je     8007e6 <strcmp+0x1c>
  8007da:	3a 02                	cmp    (%edx),%al
  8007dc:	75 08                	jne    8007e6 <strcmp+0x1c>
		p++, q++;
  8007de:	83 c1 01             	add    $0x1,%ecx
  8007e1:	83 c2 01             	add    $0x1,%edx
  8007e4:	eb ed                	jmp    8007d3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007e6:	0f b6 c0             	movzbl %al,%eax
  8007e9:	0f b6 12             	movzbl (%edx),%edx
  8007ec:	29 d0                	sub    %edx,%eax
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	53                   	push   %ebx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fa:	89 c3                	mov    %eax,%ebx
  8007fc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007ff:	eb 06                	jmp    800807 <strncmp+0x17>
		n--, p++, q++;
  800801:	83 c0 01             	add    $0x1,%eax
  800804:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800807:	39 d8                	cmp    %ebx,%eax
  800809:	74 16                	je     800821 <strncmp+0x31>
  80080b:	0f b6 08             	movzbl (%eax),%ecx
  80080e:	84 c9                	test   %cl,%cl
  800810:	74 04                	je     800816 <strncmp+0x26>
  800812:	3a 0a                	cmp    (%edx),%cl
  800814:	74 eb                	je     800801 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800816:	0f b6 00             	movzbl (%eax),%eax
  800819:	0f b6 12             	movzbl (%edx),%edx
  80081c:	29 d0                	sub    %edx,%eax
}
  80081e:	5b                   	pop    %ebx
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    
		return 0;
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	eb f6                	jmp    80081e <strncmp+0x2e>

00800828 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800832:	0f b6 10             	movzbl (%eax),%edx
  800835:	84 d2                	test   %dl,%dl
  800837:	74 09                	je     800842 <strchr+0x1a>
		if (*s == c)
  800839:	38 ca                	cmp    %cl,%dl
  80083b:	74 0a                	je     800847 <strchr+0x1f>
	for (; *s; s++)
  80083d:	83 c0 01             	add    $0x1,%eax
  800840:	eb f0                	jmp    800832 <strchr+0xa>
			return (char *) s;
	return 0;
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800853:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800856:	38 ca                	cmp    %cl,%dl
  800858:	74 09                	je     800863 <strfind+0x1a>
  80085a:	84 d2                	test   %dl,%dl
  80085c:	74 05                	je     800863 <strfind+0x1a>
	for (; *s; s++)
  80085e:	83 c0 01             	add    $0x1,%eax
  800861:	eb f0                	jmp    800853 <strfind+0xa>
			break;
	return (char *) s;
}
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	57                   	push   %edi
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80086e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800871:	85 c9                	test   %ecx,%ecx
  800873:	74 31                	je     8008a6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800875:	89 f8                	mov    %edi,%eax
  800877:	09 c8                	or     %ecx,%eax
  800879:	a8 03                	test   $0x3,%al
  80087b:	75 23                	jne    8008a0 <memset+0x3b>
		c &= 0xFF;
  80087d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800881:	89 d3                	mov    %edx,%ebx
  800883:	c1 e3 08             	shl    $0x8,%ebx
  800886:	89 d0                	mov    %edx,%eax
  800888:	c1 e0 18             	shl    $0x18,%eax
  80088b:	89 d6                	mov    %edx,%esi
  80088d:	c1 e6 10             	shl    $0x10,%esi
  800890:	09 f0                	or     %esi,%eax
  800892:	09 c2                	or     %eax,%edx
  800894:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800896:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800899:	89 d0                	mov    %edx,%eax
  80089b:	fc                   	cld    
  80089c:	f3 ab                	rep stos %eax,%es:(%edi)
  80089e:	eb 06                	jmp    8008a6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a3:	fc                   	cld    
  8008a4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008a6:	89 f8                	mov    %edi,%eax
  8008a8:	5b                   	pop    %ebx
  8008a9:	5e                   	pop    %esi
  8008aa:	5f                   	pop    %edi
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	57                   	push   %edi
  8008b1:	56                   	push   %esi
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008bb:	39 c6                	cmp    %eax,%esi
  8008bd:	73 32                	jae    8008f1 <memmove+0x44>
  8008bf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	76 2b                	jbe    8008f1 <memmove+0x44>
		s += n;
		d += n;
  8008c6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008c9:	89 fe                	mov    %edi,%esi
  8008cb:	09 ce                	or     %ecx,%esi
  8008cd:	09 d6                	or     %edx,%esi
  8008cf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008d5:	75 0e                	jne    8008e5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008d7:	83 ef 04             	sub    $0x4,%edi
  8008da:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008dd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008e0:	fd                   	std    
  8008e1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008e3:	eb 09                	jmp    8008ee <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008e5:	83 ef 01             	sub    $0x1,%edi
  8008e8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008eb:	fd                   	std    
  8008ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008ee:	fc                   	cld    
  8008ef:	eb 1a                	jmp    80090b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	09 ca                	or     %ecx,%edx
  8008f5:	09 f2                	or     %esi,%edx
  8008f7:	f6 c2 03             	test   $0x3,%dl
  8008fa:	75 0a                	jne    800906 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8008fc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8008ff:	89 c7                	mov    %eax,%edi
  800901:	fc                   	cld    
  800902:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800904:	eb 05                	jmp    80090b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800906:	89 c7                	mov    %eax,%edi
  800908:	fc                   	cld    
  800909:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80090b:	5e                   	pop    %esi
  80090c:	5f                   	pop    %edi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800915:	ff 75 10             	pushl  0x10(%ebp)
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	ff 75 08             	pushl  0x8(%ebp)
  80091e:	e8 8a ff ff ff       	call   8008ad <memmove>
}
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	56                   	push   %esi
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800930:	89 c6                	mov    %eax,%esi
  800932:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800935:	39 f0                	cmp    %esi,%eax
  800937:	74 1c                	je     800955 <memcmp+0x30>
		if (*s1 != *s2)
  800939:	0f b6 08             	movzbl (%eax),%ecx
  80093c:	0f b6 1a             	movzbl (%edx),%ebx
  80093f:	38 d9                	cmp    %bl,%cl
  800941:	75 08                	jne    80094b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	eb ea                	jmp    800935 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80094b:	0f b6 c1             	movzbl %cl,%eax
  80094e:	0f b6 db             	movzbl %bl,%ebx
  800951:	29 d8                	sub    %ebx,%eax
  800953:	eb 05                	jmp    80095a <memcmp+0x35>
	}

	return 0;
  800955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800967:	89 c2                	mov    %eax,%edx
  800969:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80096c:	39 d0                	cmp    %edx,%eax
  80096e:	73 09                	jae    800979 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800970:	38 08                	cmp    %cl,(%eax)
  800972:	74 05                	je     800979 <memfind+0x1b>
	for (; s < ends; s++)
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	eb f3                	jmp    80096c <memfind+0xe>
			break;
	return (void *) s;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	57                   	push   %edi
  80097f:	56                   	push   %esi
  800980:	53                   	push   %ebx
  800981:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800984:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800987:	eb 03                	jmp    80098c <strtol+0x11>
		s++;
  800989:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80098c:	0f b6 01             	movzbl (%ecx),%eax
  80098f:	3c 20                	cmp    $0x20,%al
  800991:	74 f6                	je     800989 <strtol+0xe>
  800993:	3c 09                	cmp    $0x9,%al
  800995:	74 f2                	je     800989 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800997:	3c 2b                	cmp    $0x2b,%al
  800999:	74 2a                	je     8009c5 <strtol+0x4a>
	int neg = 0;
  80099b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009a0:	3c 2d                	cmp    $0x2d,%al
  8009a2:	74 2b                	je     8009cf <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009a4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009aa:	75 0f                	jne    8009bb <strtol+0x40>
  8009ac:	80 39 30             	cmpb   $0x30,(%ecx)
  8009af:	74 28                	je     8009d9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009b1:	85 db                	test   %ebx,%ebx
  8009b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b8:	0f 44 d8             	cmove  %eax,%ebx
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009c3:	eb 50                	jmp    800a15 <strtol+0x9a>
		s++;
  8009c5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009cd:	eb d5                	jmp    8009a4 <strtol+0x29>
		s++, neg = 1;
  8009cf:	83 c1 01             	add    $0x1,%ecx
  8009d2:	bf 01 00 00 00       	mov    $0x1,%edi
  8009d7:	eb cb                	jmp    8009a4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009dd:	74 0e                	je     8009ed <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8009df:	85 db                	test   %ebx,%ebx
  8009e1:	75 d8                	jne    8009bb <strtol+0x40>
		s++, base = 8;
  8009e3:	83 c1 01             	add    $0x1,%ecx
  8009e6:	bb 08 00 00 00       	mov    $0x8,%ebx
  8009eb:	eb ce                	jmp    8009bb <strtol+0x40>
		s += 2, base = 16;
  8009ed:	83 c1 02             	add    $0x2,%ecx
  8009f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009f5:	eb c4                	jmp    8009bb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8009f7:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009fa:	89 f3                	mov    %esi,%ebx
  8009fc:	80 fb 19             	cmp    $0x19,%bl
  8009ff:	77 29                	ja     800a2a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a01:	0f be d2             	movsbl %dl,%edx
  800a04:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a07:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a0a:	7d 30                	jge    800a3c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a13:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a15:	0f b6 11             	movzbl (%ecx),%edx
  800a18:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a1b:	89 f3                	mov    %esi,%ebx
  800a1d:	80 fb 09             	cmp    $0x9,%bl
  800a20:	77 d5                	ja     8009f7 <strtol+0x7c>
			dig = *s - '0';
  800a22:	0f be d2             	movsbl %dl,%edx
  800a25:	83 ea 30             	sub    $0x30,%edx
  800a28:	eb dd                	jmp    800a07 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a2a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a2d:	89 f3                	mov    %esi,%ebx
  800a2f:	80 fb 19             	cmp    $0x19,%bl
  800a32:	77 08                	ja     800a3c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a34:	0f be d2             	movsbl %dl,%edx
  800a37:	83 ea 37             	sub    $0x37,%edx
  800a3a:	eb cb                	jmp    800a07 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a40:	74 05                	je     800a47 <strtol+0xcc>
		*endptr = (char *) s;
  800a42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a45:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	f7 da                	neg    %edx
  800a4b:	85 ff                	test   %edi,%edi
  800a4d:	0f 45 c2             	cmovne %edx,%eax
}
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	57                   	push   %edi
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a60:	8b 55 08             	mov    0x8(%ebp),%edx
  800a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a66:	89 c3                	mov    %eax,%ebx
  800a68:	89 c7                	mov    %eax,%edi
  800a6a:	89 c6                	mov    %eax,%esi
  800a6c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a6e:	5b                   	pop    %ebx
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a79:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800a83:	89 d1                	mov    %edx,%ecx
  800a85:	89 d3                	mov    %edx,%ebx
  800a87:	89 d7                	mov    %edx,%edi
  800a89:	89 d6                	mov    %edx,%esi
  800a8b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800a8d:	5b                   	pop    %ebx
  800a8e:	5e                   	pop    %esi
  800a8f:	5f                   	pop    %edi
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800a9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa3:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa8:	89 cb                	mov    %ecx,%ebx
  800aaa:	89 cf                	mov    %ecx,%edi
  800aac:	89 ce                	mov    %ecx,%esi
  800aae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	7f 08                	jg     800abc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab7:	5b                   	pop    %ebx
  800ab8:	5e                   	pop    %esi
  800ab9:	5f                   	pop    %edi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800abc:	83 ec 0c             	sub    $0xc,%esp
  800abf:	50                   	push   %eax
  800ac0:	6a 03                	push   $0x3
  800ac2:	68 9f 25 80 00       	push   $0x80259f
  800ac7:	6a 23                	push   $0x23
  800ac9:	68 bc 25 80 00       	push   $0x8025bc
  800ace:	e8 b1 13 00 00       	call   801e84 <_panic>

00800ad3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	57                   	push   %edi
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	b8 02 00 00 00       	mov    $0x2,%eax
  800ae3:	89 d1                	mov    %edx,%ecx
  800ae5:	89 d3                	mov    %edx,%ebx
  800ae7:	89 d7                	mov    %edx,%edi
  800ae9:	89 d6                	mov    %edx,%esi
  800aeb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <sys_yield>:

void
sys_yield(void)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af8:	ba 00 00 00 00       	mov    $0x0,%edx
  800afd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b02:	89 d1                	mov    %edx,%ecx
  800b04:	89 d3                	mov    %edx,%ebx
  800b06:	89 d7                	mov    %edx,%edi
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	57                   	push   %edi
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b1a:	be 00 00 00 00       	mov    $0x0,%esi
  800b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b25:	b8 04 00 00 00       	mov    $0x4,%eax
  800b2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b2d:	89 f7                	mov    %esi,%edi
  800b2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b31:	85 c0                	test   %eax,%eax
  800b33:	7f 08                	jg     800b3d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b3d:	83 ec 0c             	sub    $0xc,%esp
  800b40:	50                   	push   %eax
  800b41:	6a 04                	push   $0x4
  800b43:	68 9f 25 80 00       	push   $0x80259f
  800b48:	6a 23                	push   $0x23
  800b4a:	68 bc 25 80 00       	push   $0x8025bc
  800b4f:	e8 30 13 00 00       	call   801e84 <_panic>

00800b54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b63:	b8 05 00 00 00       	mov    $0x5,%eax
  800b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b6b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b6e:	8b 75 18             	mov    0x18(%ebp),%esi
  800b71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b73:	85 c0                	test   %eax,%eax
  800b75:	7f 08                	jg     800b7f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	50                   	push   %eax
  800b83:	6a 05                	push   $0x5
  800b85:	68 9f 25 80 00       	push   $0x80259f
  800b8a:	6a 23                	push   $0x23
  800b8c:	68 bc 25 80 00       	push   $0x8025bc
  800b91:	e8 ee 12 00 00       	call   801e84 <_panic>

00800b96 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
  800b9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baa:	b8 06 00 00 00       	mov    $0x6,%eax
  800baf:	89 df                	mov    %ebx,%edi
  800bb1:	89 de                	mov    %ebx,%esi
  800bb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	7f 08                	jg     800bc1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	50                   	push   %eax
  800bc5:	6a 06                	push   $0x6
  800bc7:	68 9f 25 80 00       	push   $0x80259f
  800bcc:	6a 23                	push   $0x23
  800bce:	68 bc 25 80 00       	push   $0x8025bc
  800bd3:	e8 ac 12 00 00       	call   801e84 <_panic>

00800bd8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be6:	8b 55 08             	mov    0x8(%ebp),%edx
  800be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bec:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf1:	89 df                	mov    %ebx,%edi
  800bf3:	89 de                	mov    %ebx,%esi
  800bf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf7:	85 c0                	test   %eax,%eax
  800bf9:	7f 08                	jg     800c03 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	50                   	push   %eax
  800c07:	6a 08                	push   $0x8
  800c09:	68 9f 25 80 00       	push   $0x80259f
  800c0e:	6a 23                	push   $0x23
  800c10:	68 bc 25 80 00       	push   $0x8025bc
  800c15:	e8 6a 12 00 00       	call   801e84 <_panic>

00800c1a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	57                   	push   %edi
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2e:	b8 09 00 00 00       	mov    $0x9,%eax
  800c33:	89 df                	mov    %ebx,%edi
  800c35:	89 de                	mov    %ebx,%esi
  800c37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	7f 08                	jg     800c45 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	50                   	push   %eax
  800c49:	6a 09                	push   $0x9
  800c4b:	68 9f 25 80 00       	push   $0x80259f
  800c50:	6a 23                	push   $0x23
  800c52:	68 bc 25 80 00       	push   $0x8025bc
  800c57:	e8 28 12 00 00       	call   801e84 <_panic>

00800c5c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c75:	89 df                	mov    %ebx,%edi
  800c77:	89 de                	mov    %ebx,%esi
  800c79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	7f 08                	jg     800c87 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c87:	83 ec 0c             	sub    $0xc,%esp
  800c8a:	50                   	push   %eax
  800c8b:	6a 0a                	push   $0xa
  800c8d:	68 9f 25 80 00       	push   $0x80259f
  800c92:	6a 23                	push   $0x23
  800c94:	68 bc 25 80 00       	push   $0x8025bc
  800c99:	e8 e6 11 00 00       	call   801e84 <_panic>

00800c9e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	b8 0c 00 00 00       	mov    $0xc,%eax
  800caf:	be 00 00 00 00       	mov    $0x0,%esi
  800cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cba:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cd7:	89 cb                	mov    %ecx,%ebx
  800cd9:	89 cf                	mov    %ecx,%edi
  800cdb:	89 ce                	mov    %ecx,%esi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 0d                	push   $0xd
  800cf1:	68 9f 25 80 00       	push   $0x80259f
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 bc 25 80 00       	push   $0x8025bc
  800cfd:	e8 82 11 00 00       	call   801e84 <_panic>

00800d02 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	89 d7                	mov    %edx,%edi
  800d18:	89 d6                	mov    %edx,%esi
  800d1a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	05 00 00 00 30       	add    $0x30000000,%eax
  800d2c:	c1 e8 0c             	shr    $0xc,%eax
}
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d41:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d50:	89 c2                	mov    %eax,%edx
  800d52:	c1 ea 16             	shr    $0x16,%edx
  800d55:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d5c:	f6 c2 01             	test   $0x1,%dl
  800d5f:	74 2d                	je     800d8e <fd_alloc+0x46>
  800d61:	89 c2                	mov    %eax,%edx
  800d63:	c1 ea 0c             	shr    $0xc,%edx
  800d66:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d6d:	f6 c2 01             	test   $0x1,%dl
  800d70:	74 1c                	je     800d8e <fd_alloc+0x46>
  800d72:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d77:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d7c:	75 d2                	jne    800d50 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d87:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d8c:	eb 0a                	jmp    800d98 <fd_alloc+0x50>
			*fd_store = fd;
  800d8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d91:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800da0:	83 f8 1f             	cmp    $0x1f,%eax
  800da3:	77 30                	ja     800dd5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800da5:	c1 e0 0c             	shl    $0xc,%eax
  800da8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dad:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800db3:	f6 c2 01             	test   $0x1,%dl
  800db6:	74 24                	je     800ddc <fd_lookup+0x42>
  800db8:	89 c2                	mov    %eax,%edx
  800dba:	c1 ea 0c             	shr    $0xc,%edx
  800dbd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dc4:	f6 c2 01             	test   $0x1,%dl
  800dc7:	74 1a                	je     800de3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcc:	89 02                	mov    %eax,(%edx)
	return 0;
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		return -E_INVAL;
  800dd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dda:	eb f7                	jmp    800dd3 <fd_lookup+0x39>
		return -E_INVAL;
  800ddc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de1:	eb f0                	jmp    800dd3 <fd_lookup+0x39>
  800de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de8:	eb e9                	jmp    800dd3 <fd_lookup+0x39>

00800dea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800df3:	ba 00 00 00 00       	mov    $0x0,%edx
  800df8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800dfd:	39 08                	cmp    %ecx,(%eax)
  800dff:	74 38                	je     800e39 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e01:	83 c2 01             	add    $0x1,%edx
  800e04:	8b 04 95 48 26 80 00 	mov    0x802648(,%edx,4),%eax
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	75 ee                	jne    800dfd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e0f:	a1 08 40 80 00       	mov    0x804008,%eax
  800e14:	8b 40 48             	mov    0x48(%eax),%eax
  800e17:	83 ec 04             	sub    $0x4,%esp
  800e1a:	51                   	push   %ecx
  800e1b:	50                   	push   %eax
  800e1c:	68 cc 25 80 00       	push   $0x8025cc
  800e21:	e8 1d f3 ff ff       	call   800143 <cprintf>
	*dev = 0;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    
			*dev = devtab[i];
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e43:	eb f2                	jmp    800e37 <dev_lookup+0x4d>

00800e45 <fd_close>:
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 24             	sub    $0x24,%esp
  800e4e:	8b 75 08             	mov    0x8(%ebp),%esi
  800e51:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e57:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e58:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e5e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e61:	50                   	push   %eax
  800e62:	e8 33 ff ff ff       	call   800d9a <fd_lookup>
  800e67:	89 c3                	mov    %eax,%ebx
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	78 05                	js     800e75 <fd_close+0x30>
	    || fd != fd2)
  800e70:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e73:	74 16                	je     800e8b <fd_close+0x46>
		return (must_exist ? r : 0);
  800e75:	89 f8                	mov    %edi,%eax
  800e77:	84 c0                	test   %al,%al
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7e:	0f 44 d8             	cmove  %eax,%ebx
}
  800e81:	89 d8                	mov    %ebx,%eax
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e91:	50                   	push   %eax
  800e92:	ff 36                	pushl  (%esi)
  800e94:	e8 51 ff ff ff       	call   800dea <dev_lookup>
  800e99:	89 c3                	mov    %eax,%ebx
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	78 1a                	js     800ebc <fd_close+0x77>
		if (dev->dev_close)
  800ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	74 0b                	je     800ebc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	56                   	push   %esi
  800eb5:	ff d0                	call   *%eax
  800eb7:	89 c3                	mov    %eax,%ebx
  800eb9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	56                   	push   %esi
  800ec0:	6a 00                	push   $0x0
  800ec2:	e8 cf fc ff ff       	call   800b96 <sys_page_unmap>
	return r;
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	eb b5                	jmp    800e81 <fd_close+0x3c>

00800ecc <close>:

int
close(int fdnum)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed5:	50                   	push   %eax
  800ed6:	ff 75 08             	pushl  0x8(%ebp)
  800ed9:	e8 bc fe ff ff       	call   800d9a <fd_lookup>
  800ede:	83 c4 10             	add    $0x10,%esp
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	79 02                	jns    800ee7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    
		return fd_close(fd, 1);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	6a 01                	push   $0x1
  800eec:	ff 75 f4             	pushl  -0xc(%ebp)
  800eef:	e8 51 ff ff ff       	call   800e45 <fd_close>
  800ef4:	83 c4 10             	add    $0x10,%esp
  800ef7:	eb ec                	jmp    800ee5 <close+0x19>

00800ef9 <close_all>:

void
close_all(void)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	53                   	push   %ebx
  800efd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	53                   	push   %ebx
  800f09:	e8 be ff ff ff       	call   800ecc <close>
	for (i = 0; i < MAXFD; i++)
  800f0e:	83 c3 01             	add    $0x1,%ebx
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	83 fb 20             	cmp    $0x20,%ebx
  800f17:	75 ec                	jne    800f05 <close_all+0xc>
}
  800f19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f27:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f2a:	50                   	push   %eax
  800f2b:	ff 75 08             	pushl  0x8(%ebp)
  800f2e:	e8 67 fe ff ff       	call   800d9a <fd_lookup>
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	0f 88 81 00 00 00    	js     800fc1 <dup+0xa3>
		return r;
	close(newfdnum);
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	e8 81 ff ff ff       	call   800ecc <close>

	newfd = INDEX2FD(newfdnum);
  800f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f4e:	c1 e6 0c             	shl    $0xc,%esi
  800f51:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f57:	83 c4 04             	add    $0x4,%esp
  800f5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f5d:	e8 cf fd ff ff       	call   800d31 <fd2data>
  800f62:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f64:	89 34 24             	mov    %esi,(%esp)
  800f67:	e8 c5 fd ff ff       	call   800d31 <fd2data>
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f71:	89 d8                	mov    %ebx,%eax
  800f73:	c1 e8 16             	shr    $0x16,%eax
  800f76:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f7d:	a8 01                	test   $0x1,%al
  800f7f:	74 11                	je     800f92 <dup+0x74>
  800f81:	89 d8                	mov    %ebx,%eax
  800f83:	c1 e8 0c             	shr    $0xc,%eax
  800f86:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f8d:	f6 c2 01             	test   $0x1,%dl
  800f90:	75 39                	jne    800fcb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f95:	89 d0                	mov    %edx,%eax
  800f97:	c1 e8 0c             	shr    $0xc,%eax
  800f9a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	25 07 0e 00 00       	and    $0xe07,%eax
  800fa9:	50                   	push   %eax
  800faa:	56                   	push   %esi
  800fab:	6a 00                	push   $0x0
  800fad:	52                   	push   %edx
  800fae:	6a 00                	push   $0x0
  800fb0:	e8 9f fb ff ff       	call   800b54 <sys_page_map>
  800fb5:	89 c3                	mov    %eax,%ebx
  800fb7:	83 c4 20             	add    $0x20,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 31                	js     800fef <dup+0xd1>
		goto err;

	return newfdnum;
  800fbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fc1:	89 d8                	mov    %ebx,%eax
  800fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fcb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	25 07 0e 00 00       	and    $0xe07,%eax
  800fda:	50                   	push   %eax
  800fdb:	57                   	push   %edi
  800fdc:	6a 00                	push   $0x0
  800fde:	53                   	push   %ebx
  800fdf:	6a 00                	push   $0x0
  800fe1:	e8 6e fb ff ff       	call   800b54 <sys_page_map>
  800fe6:	89 c3                	mov    %eax,%ebx
  800fe8:	83 c4 20             	add    $0x20,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	79 a3                	jns    800f92 <dup+0x74>
	sys_page_unmap(0, newfd);
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	56                   	push   %esi
  800ff3:	6a 00                	push   $0x0
  800ff5:	e8 9c fb ff ff       	call   800b96 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ffa:	83 c4 08             	add    $0x8,%esp
  800ffd:	57                   	push   %edi
  800ffe:	6a 00                	push   $0x0
  801000:	e8 91 fb ff ff       	call   800b96 <sys_page_unmap>
	return r;
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	eb b7                	jmp    800fc1 <dup+0xa3>

0080100a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	53                   	push   %ebx
  80100e:	83 ec 1c             	sub    $0x1c,%esp
  801011:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801014:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	53                   	push   %ebx
  801019:	e8 7c fd ff ff       	call   800d9a <fd_lookup>
  80101e:	83 c4 10             	add    $0x10,%esp
  801021:	85 c0                	test   %eax,%eax
  801023:	78 3f                	js     801064 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80102b:	50                   	push   %eax
  80102c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102f:	ff 30                	pushl  (%eax)
  801031:	e8 b4 fd ff ff       	call   800dea <dev_lookup>
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 27                	js     801064 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80103d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801040:	8b 42 08             	mov    0x8(%edx),%eax
  801043:	83 e0 03             	and    $0x3,%eax
  801046:	83 f8 01             	cmp    $0x1,%eax
  801049:	74 1e                	je     801069 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104e:	8b 40 08             	mov    0x8(%eax),%eax
  801051:	85 c0                	test   %eax,%eax
  801053:	74 35                	je     80108a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801055:	83 ec 04             	sub    $0x4,%esp
  801058:	ff 75 10             	pushl  0x10(%ebp)
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	52                   	push   %edx
  80105f:	ff d0                	call   *%eax
  801061:	83 c4 10             	add    $0x10,%esp
}
  801064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801067:	c9                   	leave  
  801068:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801069:	a1 08 40 80 00       	mov    0x804008,%eax
  80106e:	8b 40 48             	mov    0x48(%eax),%eax
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	53                   	push   %ebx
  801075:	50                   	push   %eax
  801076:	68 0d 26 80 00       	push   $0x80260d
  80107b:	e8 c3 f0 ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801088:	eb da                	jmp    801064 <read+0x5a>
		return -E_NOT_SUPP;
  80108a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80108f:	eb d3                	jmp    801064 <read+0x5a>

00801091 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	57                   	push   %edi
  801095:	56                   	push   %esi
  801096:	53                   	push   %ebx
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80109d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a5:	39 f3                	cmp    %esi,%ebx
  8010a7:	73 23                	jae    8010cc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	89 f0                	mov    %esi,%eax
  8010ae:	29 d8                	sub    %ebx,%eax
  8010b0:	50                   	push   %eax
  8010b1:	89 d8                	mov    %ebx,%eax
  8010b3:	03 45 0c             	add    0xc(%ebp),%eax
  8010b6:	50                   	push   %eax
  8010b7:	57                   	push   %edi
  8010b8:	e8 4d ff ff ff       	call   80100a <read>
		if (m < 0)
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 06                	js     8010ca <readn+0x39>
			return m;
		if (m == 0)
  8010c4:	74 06                	je     8010cc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8010c6:	01 c3                	add    %eax,%ebx
  8010c8:	eb db                	jmp    8010a5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010ca:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010cc:	89 d8                	mov    %ebx,%eax
  8010ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	53                   	push   %ebx
  8010da:	83 ec 1c             	sub    $0x1c,%esp
  8010dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010e3:	50                   	push   %eax
  8010e4:	53                   	push   %ebx
  8010e5:	e8 b0 fc ff ff       	call   800d9a <fd_lookup>
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 3a                	js     80112b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f7:	50                   	push   %eax
  8010f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fb:	ff 30                	pushl  (%eax)
  8010fd:	e8 e8 fc ff ff       	call   800dea <dev_lookup>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	78 22                	js     80112b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801110:	74 1e                	je     801130 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801115:	8b 52 0c             	mov    0xc(%edx),%edx
  801118:	85 d2                	test   %edx,%edx
  80111a:	74 35                	je     801151 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	ff 75 10             	pushl  0x10(%ebp)
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	50                   	push   %eax
  801126:	ff d2                	call   *%edx
  801128:	83 c4 10             	add    $0x10,%esp
}
  80112b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801130:	a1 08 40 80 00       	mov    0x804008,%eax
  801135:	8b 40 48             	mov    0x48(%eax),%eax
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	53                   	push   %ebx
  80113c:	50                   	push   %eax
  80113d:	68 29 26 80 00       	push   $0x802629
  801142:	e8 fc ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114f:	eb da                	jmp    80112b <write+0x55>
		return -E_NOT_SUPP;
  801151:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801156:	eb d3                	jmp    80112b <write+0x55>

00801158 <seek>:

int
seek(int fdnum, off_t offset)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	ff 75 08             	pushl  0x8(%ebp)
  801165:	e8 30 fc ff ff       	call   800d9a <fd_lookup>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	78 0e                	js     80117f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801171:	8b 55 0c             	mov    0xc(%ebp),%edx
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117f:	c9                   	leave  
  801180:	c3                   	ret    

00801181 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	53                   	push   %ebx
  801185:	83 ec 1c             	sub    $0x1c,%esp
  801188:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80118b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	53                   	push   %ebx
  801190:	e8 05 fc ff ff       	call   800d9a <fd_lookup>
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 37                	js     8011d3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a6:	ff 30                	pushl  (%eax)
  8011a8:	e8 3d fc ff ff       	call   800dea <dev_lookup>
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 1f                	js     8011d3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011bb:	74 1b                	je     8011d8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 52 18             	mov    0x18(%edx),%edx
  8011c3:	85 d2                	test   %edx,%edx
  8011c5:	74 32                	je     8011f9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	50                   	push   %eax
  8011ce:	ff d2                	call   *%edx
  8011d0:	83 c4 10             	add    $0x10,%esp
}
  8011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011d8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011dd:	8b 40 48             	mov    0x48(%eax),%eax
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	53                   	push   %ebx
  8011e4:	50                   	push   %eax
  8011e5:	68 ec 25 80 00       	push   $0x8025ec
  8011ea:	e8 54 ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb da                	jmp    8011d3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8011f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fe:	eb d3                	jmp    8011d3 <ftruncate+0x52>

00801200 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	83 ec 1c             	sub    $0x1c,%esp
  801207:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80120d:	50                   	push   %eax
  80120e:	ff 75 08             	pushl  0x8(%ebp)
  801211:	e8 84 fb ff ff       	call   800d9a <fd_lookup>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 4b                	js     801268 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801223:	50                   	push   %eax
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801227:	ff 30                	pushl  (%eax)
  801229:	e8 bc fb ff ff       	call   800dea <dev_lookup>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 33                	js     801268 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801238:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80123c:	74 2f                	je     80126d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80123e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801241:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801248:	00 00 00 
	stat->st_isdir = 0;
  80124b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801252:	00 00 00 
	stat->st_dev = dev;
  801255:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	53                   	push   %ebx
  80125f:	ff 75 f0             	pushl  -0x10(%ebp)
  801262:	ff 50 14             	call   *0x14(%eax)
  801265:	83 c4 10             	add    $0x10,%esp
}
  801268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
		return -E_NOT_SUPP;
  80126d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801272:	eb f4                	jmp    801268 <fstat+0x68>

00801274 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	56                   	push   %esi
  801278:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801279:	83 ec 08             	sub    $0x8,%esp
  80127c:	6a 00                	push   $0x0
  80127e:	ff 75 08             	pushl  0x8(%ebp)
  801281:	e8 2f 02 00 00       	call   8014b5 <open>
  801286:	89 c3                	mov    %eax,%ebx
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 1b                	js     8012aa <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 0c             	pushl  0xc(%ebp)
  801295:	50                   	push   %eax
  801296:	e8 65 ff ff ff       	call   801200 <fstat>
  80129b:	89 c6                	mov    %eax,%esi
	close(fd);
  80129d:	89 1c 24             	mov    %ebx,(%esp)
  8012a0:	e8 27 fc ff ff       	call   800ecc <close>
	return r;
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	89 f3                	mov    %esi,%ebx
}
  8012aa:	89 d8                	mov    %ebx,%eax
  8012ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	89 c6                	mov    %eax,%esi
  8012ba:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012bc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012c3:	74 27                	je     8012ec <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012c5:	6a 07                	push   $0x7
  8012c7:	68 00 50 80 00       	push   $0x805000
  8012cc:	56                   	push   %esi
  8012cd:	ff 35 00 40 80 00    	pushl  0x804000
  8012d3:	e8 65 0c 00 00       	call   801f3d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012d8:	83 c4 0c             	add    $0xc,%esp
  8012db:	6a 00                	push   $0x0
  8012dd:	53                   	push   %ebx
  8012de:	6a 00                	push   $0x0
  8012e0:	e8 e5 0b 00 00       	call   801eca <ipc_recv>
}
  8012e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e8:	5b                   	pop    %ebx
  8012e9:	5e                   	pop    %esi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	6a 01                	push   $0x1
  8012f1:	e8 b3 0c 00 00       	call   801fa9 <ipc_find_env>
  8012f6:	a3 00 40 80 00       	mov    %eax,0x804000
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	eb c5                	jmp    8012c5 <fsipc+0x12>

00801300 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8b 40 0c             	mov    0xc(%eax),%eax
  80130c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801319:	ba 00 00 00 00       	mov    $0x0,%edx
  80131e:	b8 02 00 00 00       	mov    $0x2,%eax
  801323:	e8 8b ff ff ff       	call   8012b3 <fsipc>
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <devfile_flush>:
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8b 40 0c             	mov    0xc(%eax),%eax
  801336:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80133b:	ba 00 00 00 00       	mov    $0x0,%edx
  801340:	b8 06 00 00 00       	mov    $0x6,%eax
  801345:	e8 69 ff ff ff       	call   8012b3 <fsipc>
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <devfile_stat>:
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	53                   	push   %ebx
  801350:	83 ec 04             	sub    $0x4,%esp
  801353:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8b 40 0c             	mov    0xc(%eax),%eax
  80135c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801361:	ba 00 00 00 00       	mov    $0x0,%edx
  801366:	b8 05 00 00 00       	mov    $0x5,%eax
  80136b:	e8 43 ff ff ff       	call   8012b3 <fsipc>
  801370:	85 c0                	test   %eax,%eax
  801372:	78 2c                	js     8013a0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801374:	83 ec 08             	sub    $0x8,%esp
  801377:	68 00 50 80 00       	push   $0x805000
  80137c:	53                   	push   %ebx
  80137d:	e8 9d f3 ff ff       	call   80071f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801382:	a1 80 50 80 00       	mov    0x805080,%eax
  801387:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80138d:	a1 84 50 80 00       	mov    0x805084,%eax
  801392:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <devfile_write>:
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8013af:	85 db                	test   %ebx,%ebx
  8013b1:	75 07                	jne    8013ba <devfile_write+0x15>
	return n_all;
  8013b3:	89 d8                	mov    %ebx,%eax
}
  8013b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c0:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8013c5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	53                   	push   %ebx
  8013cf:	ff 75 0c             	pushl  0xc(%ebp)
  8013d2:	68 08 50 80 00       	push   $0x805008
  8013d7:	e8 d1 f4 ff ff       	call   8008ad <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e1:	b8 04 00 00 00       	mov    $0x4,%eax
  8013e6:	e8 c8 fe ff ff       	call   8012b3 <fsipc>
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	78 c3                	js     8013b5 <devfile_write+0x10>
	  assert(r <= n_left);
  8013f2:	39 d8                	cmp    %ebx,%eax
  8013f4:	77 0b                	ja     801401 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8013f6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8013fb:	7f 1d                	jg     80141a <devfile_write+0x75>
    n_all += r;
  8013fd:	89 c3                	mov    %eax,%ebx
  8013ff:	eb b2                	jmp    8013b3 <devfile_write+0xe>
	  assert(r <= n_left);
  801401:	68 5c 26 80 00       	push   $0x80265c
  801406:	68 68 26 80 00       	push   $0x802668
  80140b:	68 9f 00 00 00       	push   $0x9f
  801410:	68 7d 26 80 00       	push   $0x80267d
  801415:	e8 6a 0a 00 00       	call   801e84 <_panic>
	  assert(r <= PGSIZE);
  80141a:	68 88 26 80 00       	push   $0x802688
  80141f:	68 68 26 80 00       	push   $0x802668
  801424:	68 a0 00 00 00       	push   $0xa0
  801429:	68 7d 26 80 00       	push   $0x80267d
  80142e:	e8 51 0a 00 00       	call   801e84 <_panic>

00801433 <devfile_read>:
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	56                   	push   %esi
  801437:	53                   	push   %ebx
  801438:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8b 40 0c             	mov    0xc(%eax),%eax
  801441:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801446:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80144c:	ba 00 00 00 00       	mov    $0x0,%edx
  801451:	b8 03 00 00 00       	mov    $0x3,%eax
  801456:	e8 58 fe ff ff       	call   8012b3 <fsipc>
  80145b:	89 c3                	mov    %eax,%ebx
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 1f                	js     801480 <devfile_read+0x4d>
	assert(r <= n);
  801461:	39 f0                	cmp    %esi,%eax
  801463:	77 24                	ja     801489 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801465:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80146a:	7f 33                	jg     80149f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	50                   	push   %eax
  801470:	68 00 50 80 00       	push   $0x805000
  801475:	ff 75 0c             	pushl  0xc(%ebp)
  801478:	e8 30 f4 ff ff       	call   8008ad <memmove>
	return r;
  80147d:	83 c4 10             	add    $0x10,%esp
}
  801480:	89 d8                	mov    %ebx,%eax
  801482:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801485:	5b                   	pop    %ebx
  801486:	5e                   	pop    %esi
  801487:	5d                   	pop    %ebp
  801488:	c3                   	ret    
	assert(r <= n);
  801489:	68 94 26 80 00       	push   $0x802694
  80148e:	68 68 26 80 00       	push   $0x802668
  801493:	6a 7c                	push   $0x7c
  801495:	68 7d 26 80 00       	push   $0x80267d
  80149a:	e8 e5 09 00 00       	call   801e84 <_panic>
	assert(r <= PGSIZE);
  80149f:	68 88 26 80 00       	push   $0x802688
  8014a4:	68 68 26 80 00       	push   $0x802668
  8014a9:	6a 7d                	push   $0x7d
  8014ab:	68 7d 26 80 00       	push   $0x80267d
  8014b0:	e8 cf 09 00 00       	call   801e84 <_panic>

008014b5 <open>:
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 1c             	sub    $0x1c,%esp
  8014bd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014c0:	56                   	push   %esi
  8014c1:	e8 20 f2 ff ff       	call   8006e6 <strlen>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ce:	7f 6c                	jg     80153c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	e8 6c f8 ff ff       	call   800d48 <fd_alloc>
  8014dc:	89 c3                	mov    %eax,%ebx
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 3c                	js     801521 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	56                   	push   %esi
  8014e9:	68 00 50 80 00       	push   $0x805000
  8014ee:	e8 2c f2 ff ff       	call   80071f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801503:	e8 ab fd ff ff       	call   8012b3 <fsipc>
  801508:	89 c3                	mov    %eax,%ebx
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 19                	js     80152a <open+0x75>
	return fd2num(fd);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	ff 75 f4             	pushl  -0xc(%ebp)
  801517:	e8 05 f8 ff ff       	call   800d21 <fd2num>
  80151c:	89 c3                	mov    %eax,%ebx
  80151e:	83 c4 10             	add    $0x10,%esp
}
  801521:	89 d8                	mov    %ebx,%eax
  801523:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801526:	5b                   	pop    %ebx
  801527:	5e                   	pop    %esi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    
		fd_close(fd, 0);
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	6a 00                	push   $0x0
  80152f:	ff 75 f4             	pushl  -0xc(%ebp)
  801532:	e8 0e f9 ff ff       	call   800e45 <fd_close>
		return r;
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	eb e5                	jmp    801521 <open+0x6c>
		return -E_BAD_PATH;
  80153c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801541:	eb de                	jmp    801521 <open+0x6c>

00801543 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801549:	ba 00 00 00 00       	mov    $0x0,%edx
  80154e:	b8 08 00 00 00       	mov    $0x8,%eax
  801553:	e8 5b fd ff ff       	call   8012b3 <fsipc>
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	e8 c4 f7 ff ff       	call   800d31 <fd2data>
  80156d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80156f:	83 c4 08             	add    $0x8,%esp
  801572:	68 9b 26 80 00       	push   $0x80269b
  801577:	53                   	push   %ebx
  801578:	e8 a2 f1 ff ff       	call   80071f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80157d:	8b 46 04             	mov    0x4(%esi),%eax
  801580:	2b 06                	sub    (%esi),%eax
  801582:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801588:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80158f:	00 00 00 
	stat->st_dev = &devpipe;
  801592:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801599:	30 80 00 
	return 0;
}
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    

008015a8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	53                   	push   %ebx
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015b2:	53                   	push   %ebx
  8015b3:	6a 00                	push   $0x0
  8015b5:	e8 dc f5 ff ff       	call   800b96 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015ba:	89 1c 24             	mov    %ebx,(%esp)
  8015bd:	e8 6f f7 ff ff       	call   800d31 <fd2data>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	50                   	push   %eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	e8 c9 f5 ff ff       	call   800b96 <sys_page_unmap>
}
  8015cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <_pipeisclosed>:
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	57                   	push   %edi
  8015d6:	56                   	push   %esi
  8015d7:	53                   	push   %ebx
  8015d8:	83 ec 1c             	sub    $0x1c,%esp
  8015db:	89 c7                	mov    %eax,%edi
  8015dd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015df:	a1 08 40 80 00       	mov    0x804008,%eax
  8015e4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	57                   	push   %edi
  8015eb:	e8 f2 09 00 00       	call   801fe2 <pageref>
  8015f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015f3:	89 34 24             	mov    %esi,(%esp)
  8015f6:	e8 e7 09 00 00       	call   801fe2 <pageref>
		nn = thisenv->env_runs;
  8015fb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801601:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	39 cb                	cmp    %ecx,%ebx
  801609:	74 1b                	je     801626 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80160b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80160e:	75 cf                	jne    8015df <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801610:	8b 42 58             	mov    0x58(%edx),%eax
  801613:	6a 01                	push   $0x1
  801615:	50                   	push   %eax
  801616:	53                   	push   %ebx
  801617:	68 a2 26 80 00       	push   $0x8026a2
  80161c:	e8 22 eb ff ff       	call   800143 <cprintf>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	eb b9                	jmp    8015df <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801626:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801629:	0f 94 c0             	sete   %al
  80162c:	0f b6 c0             	movzbl %al,%eax
}
  80162f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5f                   	pop    %edi
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <devpipe_write>:
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	57                   	push   %edi
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
  80163d:	83 ec 28             	sub    $0x28,%esp
  801640:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801643:	56                   	push   %esi
  801644:	e8 e8 f6 ff ff       	call   800d31 <fd2data>
  801649:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	bf 00 00 00 00       	mov    $0x0,%edi
  801653:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801656:	74 4f                	je     8016a7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801658:	8b 43 04             	mov    0x4(%ebx),%eax
  80165b:	8b 0b                	mov    (%ebx),%ecx
  80165d:	8d 51 20             	lea    0x20(%ecx),%edx
  801660:	39 d0                	cmp    %edx,%eax
  801662:	72 14                	jb     801678 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801664:	89 da                	mov    %ebx,%edx
  801666:	89 f0                	mov    %esi,%eax
  801668:	e8 65 ff ff ff       	call   8015d2 <_pipeisclosed>
  80166d:	85 c0                	test   %eax,%eax
  80166f:	75 3b                	jne    8016ac <devpipe_write+0x75>
			sys_yield();
  801671:	e8 7c f4 ff ff       	call   800af2 <sys_yield>
  801676:	eb e0                	jmp    801658 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801678:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80167f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801682:	89 c2                	mov    %eax,%edx
  801684:	c1 fa 1f             	sar    $0x1f,%edx
  801687:	89 d1                	mov    %edx,%ecx
  801689:	c1 e9 1b             	shr    $0x1b,%ecx
  80168c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80168f:	83 e2 1f             	and    $0x1f,%edx
  801692:	29 ca                	sub    %ecx,%edx
  801694:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801698:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80169c:	83 c0 01             	add    $0x1,%eax
  80169f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016a2:	83 c7 01             	add    $0x1,%edi
  8016a5:	eb ac                	jmp    801653 <devpipe_write+0x1c>
	return i;
  8016a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016aa:	eb 05                	jmp    8016b1 <devpipe_write+0x7a>
				return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5f                   	pop    %edi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <devpipe_read>:
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	57                   	push   %edi
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
  8016bf:	83 ec 18             	sub    $0x18,%esp
  8016c2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016c5:	57                   	push   %edi
  8016c6:	e8 66 f6 ff ff       	call   800d31 <fd2data>
  8016cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	be 00 00 00 00       	mov    $0x0,%esi
  8016d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016d8:	75 14                	jne    8016ee <devpipe_read+0x35>
	return i;
  8016da:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dd:	eb 02                	jmp    8016e1 <devpipe_read+0x28>
				return i;
  8016df:	89 f0                	mov    %esi,%eax
}
  8016e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5f                   	pop    %edi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    
			sys_yield();
  8016e9:	e8 04 f4 ff ff       	call   800af2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8016ee:	8b 03                	mov    (%ebx),%eax
  8016f0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016f3:	75 18                	jne    80170d <devpipe_read+0x54>
			if (i > 0)
  8016f5:	85 f6                	test   %esi,%esi
  8016f7:	75 e6                	jne    8016df <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8016f9:	89 da                	mov    %ebx,%edx
  8016fb:	89 f8                	mov    %edi,%eax
  8016fd:	e8 d0 fe ff ff       	call   8015d2 <_pipeisclosed>
  801702:	85 c0                	test   %eax,%eax
  801704:	74 e3                	je     8016e9 <devpipe_read+0x30>
				return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	eb d4                	jmp    8016e1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80170d:	99                   	cltd   
  80170e:	c1 ea 1b             	shr    $0x1b,%edx
  801711:	01 d0                	add    %edx,%eax
  801713:	83 e0 1f             	and    $0x1f,%eax
  801716:	29 d0                	sub    %edx,%eax
  801718:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801723:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801726:	83 c6 01             	add    $0x1,%esi
  801729:	eb aa                	jmp    8016d5 <devpipe_read+0x1c>

0080172b <pipe>:
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801733:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801736:	50                   	push   %eax
  801737:	e8 0c f6 ff ff       	call   800d48 <fd_alloc>
  80173c:	89 c3                	mov    %eax,%ebx
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	0f 88 23 01 00 00    	js     80186c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 07 04 00 00       	push   $0x407
  801751:	ff 75 f4             	pushl  -0xc(%ebp)
  801754:	6a 00                	push   $0x0
  801756:	e8 b6 f3 ff ff       	call   800b11 <sys_page_alloc>
  80175b:	89 c3                	mov    %eax,%ebx
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	0f 88 04 01 00 00    	js     80186c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801768:	83 ec 0c             	sub    $0xc,%esp
  80176b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	e8 d4 f5 ff ff       	call   800d48 <fd_alloc>
  801774:	89 c3                	mov    %eax,%ebx
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	0f 88 db 00 00 00    	js     80185c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	68 07 04 00 00       	push   $0x407
  801789:	ff 75 f0             	pushl  -0x10(%ebp)
  80178c:	6a 00                	push   $0x0
  80178e:	e8 7e f3 ff ff       	call   800b11 <sys_page_alloc>
  801793:	89 c3                	mov    %eax,%ebx
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	0f 88 bc 00 00 00    	js     80185c <pipe+0x131>
	va = fd2data(fd0);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a6:	e8 86 f5 ff ff       	call   800d31 <fd2data>
  8017ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ad:	83 c4 0c             	add    $0xc,%esp
  8017b0:	68 07 04 00 00       	push   $0x407
  8017b5:	50                   	push   %eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 54 f3 ff ff       	call   800b11 <sys_page_alloc>
  8017bd:	89 c3                	mov    %eax,%ebx
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	0f 88 82 00 00 00    	js     80184c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d0:	e8 5c f5 ff ff       	call   800d31 <fd2data>
  8017d5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017dc:	50                   	push   %eax
  8017dd:	6a 00                	push   $0x0
  8017df:	56                   	push   %esi
  8017e0:	6a 00                	push   $0x0
  8017e2:	e8 6d f3 ff ff       	call   800b54 <sys_page_map>
  8017e7:	89 c3                	mov    %eax,%ebx
  8017e9:	83 c4 20             	add    $0x20,%esp
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 4e                	js     80183e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8017f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8017f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8017fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801804:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801807:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	ff 75 f4             	pushl  -0xc(%ebp)
  801819:	e8 03 f5 ff ff       	call   800d21 <fd2num>
  80181e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801821:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801823:	83 c4 04             	add    $0x4,%esp
  801826:	ff 75 f0             	pushl  -0x10(%ebp)
  801829:	e8 f3 f4 ff ff       	call   800d21 <fd2num>
  80182e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801831:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183c:	eb 2e                	jmp    80186c <pipe+0x141>
	sys_page_unmap(0, va);
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	56                   	push   %esi
  801842:	6a 00                	push   $0x0
  801844:	e8 4d f3 ff ff       	call   800b96 <sys_page_unmap>
  801849:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	ff 75 f0             	pushl  -0x10(%ebp)
  801852:	6a 00                	push   $0x0
  801854:	e8 3d f3 ff ff       	call   800b96 <sys_page_unmap>
  801859:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	ff 75 f4             	pushl  -0xc(%ebp)
  801862:	6a 00                	push   $0x0
  801864:	e8 2d f3 ff ff       	call   800b96 <sys_page_unmap>
  801869:	83 c4 10             	add    $0x10,%esp
}
  80186c:	89 d8                	mov    %ebx,%eax
  80186e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801871:	5b                   	pop    %ebx
  801872:	5e                   	pop    %esi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <pipeisclosed>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187e:	50                   	push   %eax
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	e8 13 f5 ff ff       	call   800d9a <fd_lookup>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 18                	js     8018a6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80188e:	83 ec 0c             	sub    $0xc,%esp
  801891:	ff 75 f4             	pushl  -0xc(%ebp)
  801894:	e8 98 f4 ff ff       	call   800d31 <fd2data>
	return _pipeisclosed(fd, p);
  801899:	89 c2                	mov    %eax,%edx
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	e8 2f fd ff ff       	call   8015d2 <_pipeisclosed>
  8018a3:	83 c4 10             	add    $0x10,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018ae:	68 ba 26 80 00       	push   $0x8026ba
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	e8 64 ee ff ff       	call   80071f <strcpy>
	return 0;
}
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <devsock_close>:
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 10             	sub    $0x10,%esp
  8018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018cc:	53                   	push   %ebx
  8018cd:	e8 10 07 00 00       	call   801fe2 <pageref>
  8018d2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018d5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018da:	83 f8 01             	cmp    $0x1,%eax
  8018dd:	74 07                	je     8018e6 <devsock_close+0x24>
}
  8018df:	89 d0                	mov    %edx,%eax
  8018e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	ff 73 0c             	pushl  0xc(%ebx)
  8018ec:	e8 b9 02 00 00       	call   801baa <nsipc_close>
  8018f1:	89 c2                	mov    %eax,%edx
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	eb e7                	jmp    8018df <devsock_close+0x1d>

008018f8 <devsock_write>:
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 10             	pushl  0x10(%ebp)
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	ff 70 0c             	pushl  0xc(%eax)
  80190c:	e8 76 03 00 00       	call   801c87 <nsipc_send>
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <devsock_read>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 10             	pushl  0x10(%ebp)
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	ff 70 0c             	pushl  0xc(%eax)
  801927:	e8 ef 02 00 00       	call   801c1b <nsipc_recv>
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <fd2sockid>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801934:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801937:	52                   	push   %edx
  801938:	50                   	push   %eax
  801939:	e8 5c f4 ff ff       	call   800d9a <fd_lookup>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	78 10                	js     801955 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  80194e:	39 08                	cmp    %ecx,(%eax)
  801950:	75 05                	jne    801957 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    
		return -E_NOT_SUPP;
  801957:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80195c:	eb f7                	jmp    801955 <fd2sockid+0x27>

0080195e <alloc_sockfd>:
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	83 ec 1c             	sub    $0x1c,%esp
  801966:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801968:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196b:	50                   	push   %eax
  80196c:	e8 d7 f3 ff ff       	call   800d48 <fd_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	85 c0                	test   %eax,%eax
  801978:	78 43                	js     8019bd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	68 07 04 00 00       	push   $0x407
  801982:	ff 75 f4             	pushl  -0xc(%ebp)
  801985:	6a 00                	push   $0x0
  801987:	e8 85 f1 ff ff       	call   800b11 <sys_page_alloc>
  80198c:	89 c3                	mov    %eax,%ebx
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	85 c0                	test   %eax,%eax
  801993:	78 28                	js     8019bd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801998:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80199e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019aa:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019ad:	83 ec 0c             	sub    $0xc,%esp
  8019b0:	50                   	push   %eax
  8019b1:	e8 6b f3 ff ff       	call   800d21 <fd2num>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	eb 0c                	jmp    8019c9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	56                   	push   %esi
  8019c1:	e8 e4 01 00 00       	call   801baa <nsipc_close>
		return r;
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	89 d8                	mov    %ebx,%eax
  8019cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <accept>:
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	e8 4e ff ff ff       	call   80192e <fd2sockid>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 1b                	js     8019ff <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	e8 0e 01 00 00       	call   801b01 <nsipc_accept>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 05                	js     8019ff <accept+0x2d>
	return alloc_sockfd(r);
  8019fa:	e8 5f ff ff ff       	call   80195e <alloc_sockfd>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <bind>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	e8 1f ff ff ff       	call   80192e <fd2sockid>
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 12                	js     801a25 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	50                   	push   %eax
  801a1d:	e8 31 01 00 00       	call   801b53 <nsipc_bind>
  801a22:	83 c4 10             	add    $0x10,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <shutdown>:
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	e8 f9 fe ff ff       	call   80192e <fd2sockid>
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 0f                	js     801a48 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a39:	83 ec 08             	sub    $0x8,%esp
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	50                   	push   %eax
  801a40:	e8 43 01 00 00       	call   801b88 <nsipc_shutdown>
  801a45:	83 c4 10             	add    $0x10,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <connect>:
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	e8 d6 fe ff ff       	call   80192e <fd2sockid>
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	78 12                	js     801a6e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	ff 75 10             	pushl  0x10(%ebp)
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	e8 59 01 00 00       	call   801bc4 <nsipc_connect>
  801a6b:	83 c4 10             	add    $0x10,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <listen>:
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	e8 b0 fe ff ff       	call   80192e <fd2sockid>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 0f                	js     801a91 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	e8 6b 01 00 00       	call   801bf9 <nsipc_listen>
  801a8e:	83 c4 10             	add    $0x10,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	e8 3e 02 00 00       	call   801ce5 <nsipc_socket>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 05                	js     801ab3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801aae:	e8 ab fe ff ff       	call   80195e <alloc_sockfd>
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801abe:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ac5:	74 26                	je     801aed <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ac7:	6a 07                	push   $0x7
  801ac9:	68 00 60 80 00       	push   $0x806000
  801ace:	53                   	push   %ebx
  801acf:	ff 35 04 40 80 00    	pushl  0x804004
  801ad5:	e8 63 04 00 00       	call   801f3d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ada:	83 c4 0c             	add    $0xc,%esp
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 e2 03 00 00       	call   801eca <ipc_recv>
}
  801ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aed:	83 ec 0c             	sub    $0xc,%esp
  801af0:	6a 02                	push   $0x2
  801af2:	e8 b2 04 00 00       	call   801fa9 <ipc_find_env>
  801af7:	a3 04 40 80 00       	mov    %eax,0x804004
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	eb c6                	jmp    801ac7 <nsipc+0x12>

00801b01 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	56                   	push   %esi
  801b05:	53                   	push   %ebx
  801b06:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b11:	8b 06                	mov    (%esi),%eax
  801b13:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b18:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1d:	e8 93 ff ff ff       	call   801ab5 <nsipc>
  801b22:	89 c3                	mov    %eax,%ebx
  801b24:	85 c0                	test   %eax,%eax
  801b26:	79 09                	jns    801b31 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	ff 35 10 60 80 00    	pushl  0x806010
  801b3a:	68 00 60 80 00       	push   $0x806000
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	e8 66 ed ff ff       	call   8008ad <memmove>
		*addrlen = ret->ret_addrlen;
  801b47:	a1 10 60 80 00       	mov    0x806010,%eax
  801b4c:	89 06                	mov    %eax,(%esi)
  801b4e:	83 c4 10             	add    $0x10,%esp
	return r;
  801b51:	eb d5                	jmp    801b28 <nsipc_accept+0x27>

00801b53 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	53                   	push   %ebx
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b65:	53                   	push   %ebx
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	68 04 60 80 00       	push   $0x806004
  801b6e:	e8 3a ed ff ff       	call   8008ad <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b79:	b8 02 00 00 00       	mov    $0x2,%eax
  801b7e:	e8 32 ff ff ff       	call   801ab5 <nsipc>
}
  801b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba3:	e8 0d ff ff ff       	call   801ab5 <nsipc>
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <nsipc_close>:

int
nsipc_close(int s)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bb8:	b8 04 00 00 00       	mov    $0x4,%eax
  801bbd:	e8 f3 fe ff ff       	call   801ab5 <nsipc>
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bd6:	53                   	push   %ebx
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	68 04 60 80 00       	push   $0x806004
  801bdf:	e8 c9 ec ff ff       	call   8008ad <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801be4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bea:	b8 05 00 00 00       	mov    $0x5,%eax
  801bef:	e8 c1 fe ff ff       	call   801ab5 <nsipc>
}
  801bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c0f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c14:	e8 9c fe ff ff       	call   801ab5 <nsipc>
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c2b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c31:	8b 45 14             	mov    0x14(%ebp),%eax
  801c34:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c39:	b8 07 00 00 00       	mov    $0x7,%eax
  801c3e:	e8 72 fe ff ff       	call   801ab5 <nsipc>
  801c43:	89 c3                	mov    %eax,%ebx
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 1f                	js     801c68 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c49:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c4e:	7f 21                	jg     801c71 <nsipc_recv+0x56>
  801c50:	39 c6                	cmp    %eax,%esi
  801c52:	7c 1d                	jl     801c71 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	50                   	push   %eax
  801c58:	68 00 60 80 00       	push   $0x806000
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	e8 48 ec ff ff       	call   8008ad <memmove>
  801c65:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c71:	68 c6 26 80 00       	push   $0x8026c6
  801c76:	68 68 26 80 00       	push   $0x802668
  801c7b:	6a 62                	push   $0x62
  801c7d:	68 db 26 80 00       	push   $0x8026db
  801c82:	e8 fd 01 00 00       	call   801e84 <_panic>

00801c87 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c99:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c9f:	7f 2e                	jg     801ccf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	53                   	push   %ebx
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	68 0c 60 80 00       	push   $0x80600c
  801cad:	e8 fb eb ff ff       	call   8008ad <memmove>
	nsipcbuf.send.req_size = size;
  801cb2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cc0:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc5:	e8 eb fd ff ff       	call   801ab5 <nsipc>
}
  801cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    
	assert(size < 1600);
  801ccf:	68 e7 26 80 00       	push   $0x8026e7
  801cd4:	68 68 26 80 00       	push   $0x802668
  801cd9:	6a 6d                	push   $0x6d
  801cdb:	68 db 26 80 00       	push   $0x8026db
  801ce0:	e8 9f 01 00 00       	call   801e84 <_panic>

00801ce5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfe:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d03:	b8 09 00 00 00       	mov    $0x9,%eax
  801d08:	e8 a8 fd ff ff       	call   801ab5 <nsipc>
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	c3                   	ret    

00801d15 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d1b:	68 f3 26 80 00       	push   $0x8026f3
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	e8 f7 e9 ff ff       	call   80071f <strcpy>
	return 0;
}
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <devcons_write>:
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	57                   	push   %edi
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d3b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d40:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d49:	73 31                	jae    801d7c <devcons_write+0x4d>
		m = n - tot;
  801d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d4e:	29 f3                	sub    %esi,%ebx
  801d50:	83 fb 7f             	cmp    $0x7f,%ebx
  801d53:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d58:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	53                   	push   %ebx
  801d5f:	89 f0                	mov    %esi,%eax
  801d61:	03 45 0c             	add    0xc(%ebp),%eax
  801d64:	50                   	push   %eax
  801d65:	57                   	push   %edi
  801d66:	e8 42 eb ff ff       	call   8008ad <memmove>
		sys_cputs(buf, m);
  801d6b:	83 c4 08             	add    $0x8,%esp
  801d6e:	53                   	push   %ebx
  801d6f:	57                   	push   %edi
  801d70:	e8 e0 ec ff ff       	call   800a55 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d75:	01 de                	add    %ebx,%esi
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	eb ca                	jmp    801d46 <devcons_write+0x17>
}
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5f                   	pop    %edi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <devcons_read>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d95:	74 21                	je     801db8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801d97:	e8 d7 ec ff ff       	call   800a73 <sys_cgetc>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	75 07                	jne    801da7 <devcons_read+0x21>
		sys_yield();
  801da0:	e8 4d ed ff ff       	call   800af2 <sys_yield>
  801da5:	eb f0                	jmp    801d97 <devcons_read+0x11>
	if (c < 0)
  801da7:	78 0f                	js     801db8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801da9:	83 f8 04             	cmp    $0x4,%eax
  801dac:	74 0c                	je     801dba <devcons_read+0x34>
	*(char*)vbuf = c;
  801dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db1:	88 02                	mov    %al,(%edx)
	return 1;
  801db3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    
		return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	eb f7                	jmp    801db8 <devcons_read+0x32>

00801dc1 <cputchar>:
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dcd:	6a 01                	push   $0x1
  801dcf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dd2:	50                   	push   %eax
  801dd3:	e8 7d ec ff ff       	call   800a55 <sys_cputs>
}
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <getchar>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801de3:	6a 01                	push   $0x1
  801de5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de8:	50                   	push   %eax
  801de9:	6a 00                	push   $0x0
  801deb:	e8 1a f2 ff ff       	call   80100a <read>
	if (r < 0)
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	85 c0                	test   %eax,%eax
  801df5:	78 06                	js     801dfd <getchar+0x20>
	if (r < 1)
  801df7:	74 06                	je     801dff <getchar+0x22>
	return c;
  801df9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    
		return -E_EOF;
  801dff:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e04:	eb f7                	jmp    801dfd <getchar+0x20>

00801e06 <iscons>:
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0f:	50                   	push   %eax
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	e8 82 ef ff ff       	call   800d9a <fd_lookup>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	78 11                	js     801e30 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e28:	39 10                	cmp    %edx,(%eax)
  801e2a:	0f 94 c0             	sete   %al
  801e2d:	0f b6 c0             	movzbl %al,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <opencons>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3b:	50                   	push   %eax
  801e3c:	e8 07 ef ff ff       	call   800d48 <fd_alloc>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	85 c0                	test   %eax,%eax
  801e46:	78 3a                	js     801e82 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 07 04 00 00       	push   $0x407
  801e50:	ff 75 f4             	pushl  -0xc(%ebp)
  801e53:	6a 00                	push   $0x0
  801e55:	e8 b7 ec ff ff       	call   800b11 <sys_page_alloc>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 21                	js     801e82 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e6a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	50                   	push   %eax
  801e7a:	e8 a2 ee ff ff       	call   800d21 <fd2num>
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e89:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e8c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e92:	e8 3c ec ff ff       	call   800ad3 <sys_getenvid>
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	56                   	push   %esi
  801ea1:	50                   	push   %eax
  801ea2:	68 00 27 80 00       	push   $0x802700
  801ea7:	e8 97 e2 ff ff       	call   800143 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	e8 3a e2 ff ff       	call   8000f2 <vcprintf>
	cprintf("\n");
  801eb8:	c7 04 24 9c 22 80 00 	movl   $0x80229c,(%esp)
  801ebf:	e8 7f e2 ff ff       	call   800143 <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ec7:	cc                   	int3   
  801ec8:	eb fd                	jmp    801ec7 <_panic+0x43>

00801eca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
  801ecf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 4f                	je     801f2b <ipc_recv+0x61>
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	50                   	push   %eax
  801ee0:	e8 dc ed ff ff       	call   800cc1 <sys_ipc_recv>
  801ee5:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ee8:	85 f6                	test   %esi,%esi
  801eea:	74 14                	je     801f00 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 09                	jne    801efe <ipc_recv+0x34>
  801ef5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efb:	8b 52 74             	mov    0x74(%edx),%edx
  801efe:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f00:	85 db                	test   %ebx,%ebx
  801f02:	74 14                	je     801f18 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f04:	ba 00 00 00 00       	mov    $0x0,%edx
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 09                	jne    801f16 <ipc_recv+0x4c>
  801f0d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f13:	8b 52 78             	mov    0x78(%edx),%edx
  801f16:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 08                	jne    801f24 <ipc_recv+0x5a>
  801f1c:	a1 08 40 80 00       	mov    0x804008,%eax
  801f21:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 00 00 c0 ee       	push   $0xeec00000
  801f33:	e8 89 ed ff ff       	call   800cc1 <sys_ipc_recv>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	eb ab                	jmp    801ee8 <ipc_recv+0x1e>

00801f3d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	57                   	push   %edi
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f49:	8b 75 10             	mov    0x10(%ebp),%esi
  801f4c:	eb 20                	jmp    801f6e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f4e:	6a 00                	push   $0x0
  801f50:	68 00 00 c0 ee       	push   $0xeec00000
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	57                   	push   %edi
  801f59:	e8 40 ed ff ff       	call   800c9e <sys_ipc_try_send>
  801f5e:	89 c3                	mov    %eax,%ebx
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb 1f                	jmp    801f84 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f65:	e8 88 eb ff ff       	call   800af2 <sys_yield>
	while(retval != 0) {
  801f6a:	85 db                	test   %ebx,%ebx
  801f6c:	74 33                	je     801fa1 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f6e:	85 f6                	test   %esi,%esi
  801f70:	74 dc                	je     801f4e <ipc_send+0x11>
  801f72:	ff 75 14             	pushl  0x14(%ebp)
  801f75:	56                   	push   %esi
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	57                   	push   %edi
  801f7a:	e8 1f ed ff ff       	call   800c9e <sys_ipc_try_send>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f84:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f87:	74 dc                	je     801f65 <ipc_send+0x28>
  801f89:	85 db                	test   %ebx,%ebx
  801f8b:	74 d8                	je     801f65 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 24 27 80 00       	push   $0x802724
  801f95:	6a 35                	push   $0x35
  801f97:	68 54 27 80 00       	push   $0x802754
  801f9c:	e8 e3 fe ff ff       	call   801e84 <_panic>
	}
}
  801fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa4:	5b                   	pop    %ebx
  801fa5:	5e                   	pop    %esi
  801fa6:	5f                   	pop    %edi
  801fa7:	5d                   	pop    %ebp
  801fa8:	c3                   	ret    

00801fa9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fb4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fb7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fbd:	8b 52 50             	mov    0x50(%edx),%edx
  801fc0:	39 ca                	cmp    %ecx,%edx
  801fc2:	74 11                	je     801fd5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fc4:	83 c0 01             	add    $0x1,%eax
  801fc7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fcc:	75 e6                	jne    801fb4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 0b                	jmp    801fe0 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fd5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fdd:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    

00801fe2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	c1 e8 16             	shr    $0x16,%eax
  801fed:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff9:	f6 c1 01             	test   $0x1,%cl
  801ffc:	74 1d                	je     80201b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ffe:	c1 ea 0c             	shr    $0xc,%edx
  802001:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802008:	f6 c2 01             	test   $0x1,%dl
  80200b:	74 0e                	je     80201b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80200d:	c1 ea 0c             	shr    $0xc,%edx
  802010:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802017:	ef 
  802018:	0f b7 c0             	movzwl %ax,%eax
}
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
  80201d:	66 90                	xchg   %ax,%ax
  80201f:	90                   	nop

00802020 <__udivdi3>:
  802020:	f3 0f 1e fb          	endbr32 
  802024:	55                   	push   %ebp
  802025:	57                   	push   %edi
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 1c             	sub    $0x1c,%esp
  80202b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80202f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802033:	8b 74 24 34          	mov    0x34(%esp),%esi
  802037:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80203b:	85 d2                	test   %edx,%edx
  80203d:	75 49                	jne    802088 <__udivdi3+0x68>
  80203f:	39 f3                	cmp    %esi,%ebx
  802041:	76 15                	jbe    802058 <__udivdi3+0x38>
  802043:	31 ff                	xor    %edi,%edi
  802045:	89 e8                	mov    %ebp,%eax
  802047:	89 f2                	mov    %esi,%edx
  802049:	f7 f3                	div    %ebx
  80204b:	89 fa                	mov    %edi,%edx
  80204d:	83 c4 1c             	add    $0x1c,%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    
  802055:	8d 76 00             	lea    0x0(%esi),%esi
  802058:	89 d9                	mov    %ebx,%ecx
  80205a:	85 db                	test   %ebx,%ebx
  80205c:	75 0b                	jne    802069 <__udivdi3+0x49>
  80205e:	b8 01 00 00 00       	mov    $0x1,%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	f7 f3                	div    %ebx
  802067:	89 c1                	mov    %eax,%ecx
  802069:	31 d2                	xor    %edx,%edx
  80206b:	89 f0                	mov    %esi,%eax
  80206d:	f7 f1                	div    %ecx
  80206f:	89 c6                	mov    %eax,%esi
  802071:	89 e8                	mov    %ebp,%eax
  802073:	89 f7                	mov    %esi,%edi
  802075:	f7 f1                	div    %ecx
  802077:	89 fa                	mov    %edi,%edx
  802079:	83 c4 1c             	add    $0x1c,%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5f                   	pop    %edi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
  802081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802088:	39 f2                	cmp    %esi,%edx
  80208a:	77 1c                	ja     8020a8 <__udivdi3+0x88>
  80208c:	0f bd fa             	bsr    %edx,%edi
  80208f:	83 f7 1f             	xor    $0x1f,%edi
  802092:	75 2c                	jne    8020c0 <__udivdi3+0xa0>
  802094:	39 f2                	cmp    %esi,%edx
  802096:	72 06                	jb     80209e <__udivdi3+0x7e>
  802098:	31 c0                	xor    %eax,%eax
  80209a:	39 eb                	cmp    %ebp,%ebx
  80209c:	77 ad                	ja     80204b <__udivdi3+0x2b>
  80209e:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a3:	eb a6                	jmp    80204b <__udivdi3+0x2b>
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	31 ff                	xor    %edi,%edi
  8020aa:	31 c0                	xor    %eax,%eax
  8020ac:	89 fa                	mov    %edi,%edx
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	89 f9                	mov    %edi,%ecx
  8020c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020c7:	29 f8                	sub    %edi,%eax
  8020c9:	d3 e2                	shl    %cl,%edx
  8020cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020cf:	89 c1                	mov    %eax,%ecx
  8020d1:	89 da                	mov    %ebx,%edx
  8020d3:	d3 ea                	shr    %cl,%edx
  8020d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020d9:	09 d1                	or     %edx,%ecx
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e3                	shl    %cl,%ebx
  8020e5:	89 c1                	mov    %eax,%ecx
  8020e7:	d3 ea                	shr    %cl,%edx
  8020e9:	89 f9                	mov    %edi,%ecx
  8020eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ef:	89 eb                	mov    %ebp,%ebx
  8020f1:	d3 e6                	shl    %cl,%esi
  8020f3:	89 c1                	mov    %eax,%ecx
  8020f5:	d3 eb                	shr    %cl,%ebx
  8020f7:	09 de                	or     %ebx,%esi
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	f7 74 24 08          	divl   0x8(%esp)
  8020ff:	89 d6                	mov    %edx,%esi
  802101:	89 c3                	mov    %eax,%ebx
  802103:	f7 64 24 0c          	mull   0xc(%esp)
  802107:	39 d6                	cmp    %edx,%esi
  802109:	72 15                	jb     802120 <__udivdi3+0x100>
  80210b:	89 f9                	mov    %edi,%ecx
  80210d:	d3 e5                	shl    %cl,%ebp
  80210f:	39 c5                	cmp    %eax,%ebp
  802111:	73 04                	jae    802117 <__udivdi3+0xf7>
  802113:	39 d6                	cmp    %edx,%esi
  802115:	74 09                	je     802120 <__udivdi3+0x100>
  802117:	89 d8                	mov    %ebx,%eax
  802119:	31 ff                	xor    %edi,%edi
  80211b:	e9 2b ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  802120:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802123:	31 ff                	xor    %edi,%edi
  802125:	e9 21 ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <__umoddi3>:
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	57                   	push   %edi
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	83 ec 1c             	sub    $0x1c,%esp
  80213b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80213f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802143:	8b 74 24 30          	mov    0x30(%esp),%esi
  802147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80214b:	89 da                	mov    %ebx,%edx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 3f                	jne    802190 <__umoddi3+0x60>
  802151:	39 df                	cmp    %ebx,%edi
  802153:	76 13                	jbe    802168 <__umoddi3+0x38>
  802155:	89 f0                	mov    %esi,%eax
  802157:	f7 f7                	div    %edi
  802159:	89 d0                	mov    %edx,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	89 fd                	mov    %edi,%ebp
  80216a:	85 ff                	test   %edi,%edi
  80216c:	75 0b                	jne    802179 <__umoddi3+0x49>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	31 d2                	xor    %edx,%edx
  802175:	f7 f7                	div    %edi
  802177:	89 c5                	mov    %eax,%ebp
  802179:	89 d8                	mov    %ebx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f5                	div    %ebp
  80217f:	89 f0                	mov    %esi,%eax
  802181:	f7 f5                	div    %ebp
  802183:	89 d0                	mov    %edx,%eax
  802185:	eb d4                	jmp    80215b <__umoddi3+0x2b>
  802187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80218e:	66 90                	xchg   %ax,%ax
  802190:	89 f1                	mov    %esi,%ecx
  802192:	39 d8                	cmp    %ebx,%eax
  802194:	76 0a                	jbe    8021a0 <__umoddi3+0x70>
  802196:	89 f0                	mov    %esi,%eax
  802198:	83 c4 1c             	add    $0x1c,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5f                   	pop    %edi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
  8021a0:	0f bd e8             	bsr    %eax,%ebp
  8021a3:	83 f5 1f             	xor    $0x1f,%ebp
  8021a6:	75 20                	jne    8021c8 <__umoddi3+0x98>
  8021a8:	39 d8                	cmp    %ebx,%eax
  8021aa:	0f 82 b0 00 00 00    	jb     802260 <__umoddi3+0x130>
  8021b0:	39 f7                	cmp    %esi,%edi
  8021b2:	0f 86 a8 00 00 00    	jbe    802260 <__umoddi3+0x130>
  8021b8:	89 c8                	mov    %ecx,%eax
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	89 e9                	mov    %ebp,%ecx
  8021ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8021cf:	29 ea                	sub    %ebp,%edx
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d7:	89 d1                	mov    %edx,%ecx
  8021d9:	89 f8                	mov    %edi,%eax
  8021db:	d3 e8                	shr    %cl,%eax
  8021dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e9:	09 c1                	or     %eax,%ecx
  8021eb:	89 d8                	mov    %ebx,%eax
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 e9                	mov    %ebp,%ecx
  8021f3:	d3 e7                	shl    %cl,%edi
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	d3 e8                	shr    %cl,%eax
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ff:	d3 e3                	shl    %cl,%ebx
  802201:	89 c7                	mov    %eax,%edi
  802203:	89 d1                	mov    %edx,%ecx
  802205:	89 f0                	mov    %esi,%eax
  802207:	d3 e8                	shr    %cl,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	89 fa                	mov    %edi,%edx
  80220d:	d3 e6                	shl    %cl,%esi
  80220f:	09 d8                	or     %ebx,%eax
  802211:	f7 74 24 08          	divl   0x8(%esp)
  802215:	89 d1                	mov    %edx,%ecx
  802217:	89 f3                	mov    %esi,%ebx
  802219:	f7 64 24 0c          	mull   0xc(%esp)
  80221d:	89 c6                	mov    %eax,%esi
  80221f:	89 d7                	mov    %edx,%edi
  802221:	39 d1                	cmp    %edx,%ecx
  802223:	72 06                	jb     80222b <__umoddi3+0xfb>
  802225:	75 10                	jne    802237 <__umoddi3+0x107>
  802227:	39 c3                	cmp    %eax,%ebx
  802229:	73 0c                	jae    802237 <__umoddi3+0x107>
  80222b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80222f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802233:	89 d7                	mov    %edx,%edi
  802235:	89 c6                	mov    %eax,%esi
  802237:	89 ca                	mov    %ecx,%edx
  802239:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80223e:	29 f3                	sub    %esi,%ebx
  802240:	19 fa                	sbb    %edi,%edx
  802242:	89 d0                	mov    %edx,%eax
  802244:	d3 e0                	shl    %cl,%eax
  802246:	89 e9                	mov    %ebp,%ecx
  802248:	d3 eb                	shr    %cl,%ebx
  80224a:	d3 ea                	shr    %cl,%edx
  80224c:	09 d8                	or     %ebx,%eax
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	89 da                	mov    %ebx,%edx
  802262:	29 fe                	sub    %edi,%esi
  802264:	19 c2                	sbb    %eax,%edx
  802266:	89 f1                	mov    %esi,%ecx
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	e9 4b ff ff ff       	jmp    8021ba <__umoddi3+0x8a>
