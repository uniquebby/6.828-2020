
obj/user/hello.debug：     文件格式 elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 80 22 80 00       	push   $0x802280
  80003e:	e8 10 01 00 00       	call   800153 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 08 40 80 00       	mov    0x804008,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 8e 22 80 00       	push   $0x80228e
  800054:	e8 fa 00 00 00       	call   800153 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 75 0a 00 00       	call   800ae3 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000aa:	e8 5a 0e 00 00       	call   800f09 <close_all>
	sys_env_destroy(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 e9 09 00 00       	call   800aa2 <sys_env_destroy>
}
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 6e 09 00 00       	call   800a65 <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x1f>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012b:	50                   	push   %eax
  80012c:	68 be 00 80 00       	push   $0x8000be
  800131:	e8 19 01 00 00       	call   80024f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	e8 1a 09 00 00       	call   800a65 <sys_cputs>

	return b.cnt;
}
  80014b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800159:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015c:	50                   	push   %eax
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 9d ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 1c             	sub    $0x1c,%esp
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800183:	bb 00 00 00 00       	mov    $0x0,%ebx
  800188:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80018e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800191:	89 d0                	mov    %edx,%eax
  800193:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800196:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800199:	73 15                	jae    8001b0 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80019b:	83 eb 01             	sub    $0x1,%ebx
  80019e:	85 db                	test   %ebx,%ebx
  8001a0:	7e 43                	jle    8001e5 <printnum+0x7e>
			putch(padc, putdat);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	56                   	push   %esi
  8001a6:	ff 75 18             	pushl  0x18(%ebp)
  8001a9:	ff d7                	call   *%edi
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb eb                	jmp    80019b <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	ff 75 18             	pushl  0x18(%ebp)
  8001b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8001b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001bc:	53                   	push   %ebx
  8001bd:	ff 75 10             	pushl  0x10(%ebp)
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cf:	e8 5c 1e 00 00       	call   802030 <__udivdi3>
  8001d4:	83 c4 18             	add    $0x18,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	89 f2                	mov    %esi,%edx
  8001db:	89 f8                	mov    %edi,%eax
  8001dd:	e8 85 ff ff ff       	call   800167 <printnum>
  8001e2:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	56                   	push   %esi
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f8:	e8 43 1f 00 00       	call   802140 <__umoddi3>
  8001fd:	83 c4 14             	add    $0x14,%esp
  800200:	0f be 80 af 22 80 00 	movsbl 0x8022af(%eax),%eax
  800207:	50                   	push   %eax
  800208:	ff d7                	call   *%edi
}
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800210:	5b                   	pop    %ebx
  800211:	5e                   	pop    %esi
  800212:	5f                   	pop    %edi
  800213:	5d                   	pop    %ebp
  800214:	c3                   	ret    

00800215 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80021f:	8b 10                	mov    (%eax),%edx
  800221:	3b 50 04             	cmp    0x4(%eax),%edx
  800224:	73 0a                	jae    800230 <sprintputch+0x1b>
		*b->buf++ = ch;
  800226:	8d 4a 01             	lea    0x1(%edx),%ecx
  800229:	89 08                	mov    %ecx,(%eax)
  80022b:	8b 45 08             	mov    0x8(%ebp),%eax
  80022e:	88 02                	mov    %al,(%edx)
}
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    

00800232 <printfmt>:
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800238:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023b:	50                   	push   %eax
  80023c:	ff 75 10             	pushl  0x10(%ebp)
  80023f:	ff 75 0c             	pushl  0xc(%ebp)
  800242:	ff 75 08             	pushl  0x8(%ebp)
  800245:	e8 05 00 00 00       	call   80024f <vprintfmt>
}
  80024a:	83 c4 10             	add    $0x10,%esp
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <vprintfmt>:
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	57                   	push   %edi
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
  800255:	83 ec 3c             	sub    $0x3c,%esp
  800258:	8b 75 08             	mov    0x8(%ebp),%esi
  80025b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80025e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800261:	eb 0a                	jmp    80026d <vprintfmt+0x1e>
			putch(ch, putdat);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	53                   	push   %ebx
  800267:	50                   	push   %eax
  800268:	ff d6                	call   *%esi
  80026a:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80026d:	83 c7 01             	add    $0x1,%edi
  800270:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800274:	83 f8 25             	cmp    $0x25,%eax
  800277:	74 0c                	je     800285 <vprintfmt+0x36>
			if (ch == '\0')
  800279:	85 c0                	test   %eax,%eax
  80027b:	75 e6                	jne    800263 <vprintfmt+0x14>
}
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
		padc = ' ';
  800285:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800289:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800290:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800297:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a3:	8d 47 01             	lea    0x1(%edi),%eax
  8002a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002a9:	0f b6 17             	movzbl (%edi),%edx
  8002ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002af:	3c 55                	cmp    $0x55,%al
  8002b1:	0f 87 ba 03 00 00    	ja     800671 <vprintfmt+0x422>
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	ff 24 85 00 24 80 00 	jmp    *0x802400(,%eax,4)
  8002c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002c8:	eb d9                	jmp    8002a3 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002cd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d1:	eb d0                	jmp    8002a3 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8002d3:	0f b6 d2             	movzbl %dl,%edx
  8002d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002e8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002eb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ee:	83 f9 09             	cmp    $0x9,%ecx
  8002f1:	77 55                	ja     800348 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8002f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f6:	eb e9                	jmp    8002e1 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8002f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800300:	8b 45 14             	mov    0x14(%ebp),%eax
  800303:	8d 40 04             	lea    0x4(%eax),%eax
  800306:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800310:	79 91                	jns    8002a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800312:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800315:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800318:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80031f:	eb 82                	jmp    8002a3 <vprintfmt+0x54>
  800321:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800324:	85 c0                	test   %eax,%eax
  800326:	ba 00 00 00 00       	mov    $0x0,%edx
  80032b:	0f 49 d0             	cmovns %eax,%edx
  80032e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800334:	e9 6a ff ff ff       	jmp    8002a3 <vprintfmt+0x54>
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800343:	e9 5b ff ff ff       	jmp    8002a3 <vprintfmt+0x54>
  800348:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034e:	eb bc                	jmp    80030c <vprintfmt+0xbd>
			lflag++;
  800350:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800356:	e9 48 ff ff ff       	jmp    8002a3 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8d 78 04             	lea    0x4(%eax),%edi
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	53                   	push   %ebx
  800365:	ff 30                	pushl  (%eax)
  800367:	ff d6                	call   *%esi
			break;
  800369:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80036f:	e9 9c 02 00 00       	jmp    800610 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800374:	8b 45 14             	mov    0x14(%ebp),%eax
  800377:	8d 78 04             	lea    0x4(%eax),%edi
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	99                   	cltd   
  80037d:	31 d0                	xor    %edx,%eax
  80037f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800381:	83 f8 0f             	cmp    $0xf,%eax
  800384:	7f 23                	jg     8003a9 <vprintfmt+0x15a>
  800386:	8b 14 85 60 25 80 00 	mov    0x802560(,%eax,4),%edx
  80038d:	85 d2                	test   %edx,%edx
  80038f:	74 18                	je     8003a9 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800391:	52                   	push   %edx
  800392:	68 9a 26 80 00       	push   $0x80269a
  800397:	53                   	push   %ebx
  800398:	56                   	push   %esi
  800399:	e8 94 fe ff ff       	call   800232 <printfmt>
  80039e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a4:	e9 67 02 00 00       	jmp    800610 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003a9:	50                   	push   %eax
  8003aa:	68 c7 22 80 00       	push   $0x8022c7
  8003af:	53                   	push   %ebx
  8003b0:	56                   	push   %esi
  8003b1:	e8 7c fe ff ff       	call   800232 <printfmt>
  8003b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003bc:	e9 4f 02 00 00       	jmp    800610 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	83 c0 04             	add    $0x4,%eax
  8003c7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003cf:	85 d2                	test   %edx,%edx
  8003d1:	b8 c0 22 80 00       	mov    $0x8022c0,%eax
  8003d6:	0f 45 c2             	cmovne %edx,%eax
  8003d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e0:	7e 06                	jle    8003e8 <vprintfmt+0x199>
  8003e2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e6:	75 0d                	jne    8003f5 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003eb:	89 c7                	mov    %eax,%edi
  8003ed:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f3:	eb 3f                	jmp    800434 <vprintfmt+0x1e5>
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fb:	50                   	push   %eax
  8003fc:	e8 0d 03 00 00       	call   80070e <strnlen>
  800401:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800404:	29 c2                	sub    %eax,%edx
  800406:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80040e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800412:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	85 ff                	test   %edi,%edi
  800417:	7e 58                	jle    800471 <vprintfmt+0x222>
					putch(padc, putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 75 e0             	pushl  -0x20(%ebp)
  800420:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800422:	83 ef 01             	sub    $0x1,%edi
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	eb eb                	jmp    800415 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	53                   	push   %ebx
  80042e:	52                   	push   %edx
  80042f:	ff d6                	call   *%esi
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800437:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800439:	83 c7 01             	add    $0x1,%edi
  80043c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800440:	0f be d0             	movsbl %al,%edx
  800443:	85 d2                	test   %edx,%edx
  800445:	74 45                	je     80048c <vprintfmt+0x23d>
  800447:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80044b:	78 06                	js     800453 <vprintfmt+0x204>
  80044d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800451:	78 35                	js     800488 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800453:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800457:	74 d1                	je     80042a <vprintfmt+0x1db>
  800459:	0f be c0             	movsbl %al,%eax
  80045c:	83 e8 20             	sub    $0x20,%eax
  80045f:	83 f8 5e             	cmp    $0x5e,%eax
  800462:	76 c6                	jbe    80042a <vprintfmt+0x1db>
					putch('?', putdat);
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	53                   	push   %ebx
  800468:	6a 3f                	push   $0x3f
  80046a:	ff d6                	call   *%esi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	eb c3                	jmp    800434 <vprintfmt+0x1e5>
  800471:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800474:	85 d2                	test   %edx,%edx
  800476:	b8 00 00 00 00       	mov    $0x0,%eax
  80047b:	0f 49 c2             	cmovns %edx,%eax
  80047e:	29 c2                	sub    %eax,%edx
  800480:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800483:	e9 60 ff ff ff       	jmp    8003e8 <vprintfmt+0x199>
  800488:	89 cf                	mov    %ecx,%edi
  80048a:	eb 02                	jmp    80048e <vprintfmt+0x23f>
  80048c:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80048e:	85 ff                	test   %edi,%edi
  800490:	7e 10                	jle    8004a2 <vprintfmt+0x253>
				putch(' ', putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	6a 20                	push   $0x20
  800498:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80049a:	83 ef 01             	sub    $0x1,%edi
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	eb ec                	jmp    80048e <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a8:	e9 63 01 00 00       	jmp    800610 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004ad:	83 f9 01             	cmp    $0x1,%ecx
  8004b0:	7f 1b                	jg     8004cd <vprintfmt+0x27e>
	else if (lflag)
  8004b2:	85 c9                	test   %ecx,%ecx
  8004b4:	74 63                	je     800519 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004be:	99                   	cltd   
  8004bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 40 04             	lea    0x4(%eax),%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cb:	eb 17                	jmp    8004e4 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ea:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	0f 89 ff 00 00 00    	jns    8005f6 <vprintfmt+0x3a7>
				putch('-', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	6a 2d                	push   $0x2d
  8004fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800502:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800505:	f7 da                	neg    %edx
  800507:	83 d1 00             	adc    $0x0,%ecx
  80050a:	f7 d9                	neg    %ecx
  80050c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80050f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800514:	e9 dd 00 00 00       	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	99                   	cltd   
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 04             	lea    0x4(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
  80052e:	eb b4                	jmp    8004e4 <vprintfmt+0x295>
	if (lflag >= 2)
  800530:	83 f9 01             	cmp    $0x1,%ecx
  800533:	7f 1e                	jg     800553 <vprintfmt+0x304>
	else if (lflag)
  800535:	85 c9                	test   %ecx,%ecx
  800537:	74 32                	je     80056b <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 10                	mov    (%eax),%edx
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800543:	8d 40 04             	lea    0x4(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800549:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054e:	e9 a3 00 00 00       	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	8b 48 04             	mov    0x4(%eax),%ecx
  80055b:	8d 40 08             	lea    0x8(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
  800566:	e9 8b 00 00 00       	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8b 10                	mov    (%eax),%edx
  800570:	b9 00 00 00 00       	mov    $0x0,%ecx
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800580:	eb 74                	jmp    8005f6 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800582:	83 f9 01             	cmp    $0x1,%ecx
  800585:	7f 1b                	jg     8005a2 <vprintfmt+0x353>
	else if (lflag)
  800587:	85 c9                	test   %ecx,%ecx
  800589:	74 2c                	je     8005b7 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	b9 00 00 00 00       	mov    $0x0,%ecx
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059b:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a0:	eb 54                	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8005aa:	8d 40 08             	lea    0x8(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b5:	eb 3f                	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005cc:	eb 28                	jmp    8005f6 <vprintfmt+0x3a7>
			putch('0', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 30                	push   $0x30
  8005d4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d6:	83 c4 08             	add    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 78                	push   $0x78
  8005dc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005eb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005fd:	57                   	push   %edi
  8005fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800601:	50                   	push   %eax
  800602:	51                   	push   %ecx
  800603:	52                   	push   %edx
  800604:	89 da                	mov    %ebx,%edx
  800606:	89 f0                	mov    %esi,%eax
  800608:	e8 5a fb ff ff       	call   800167 <printnum>
			break;
  80060d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800613:	e9 55 fc ff ff       	jmp    80026d <vprintfmt+0x1e>
	if (lflag >= 2)
  800618:	83 f9 01             	cmp    $0x1,%ecx
  80061b:	7f 1b                	jg     800638 <vprintfmt+0x3e9>
	else if (lflag)
  80061d:	85 c9                	test   %ecx,%ecx
  80061f:	74 2c                	je     80064d <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800631:	b8 10 00 00 00       	mov    $0x10,%eax
  800636:	eb be                	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 10                	mov    (%eax),%edx
  80063d:	8b 48 04             	mov    0x4(%eax),%ecx
  800640:	8d 40 08             	lea    0x8(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800646:	b8 10 00 00 00       	mov    $0x10,%eax
  80064b:	eb a9                	jmp    8005f6 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	b9 00 00 00 00       	mov    $0x0,%ecx
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065d:	b8 10 00 00 00       	mov    $0x10,%eax
  800662:	eb 92                	jmp    8005f6 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	53                   	push   %ebx
  800668:	6a 25                	push   $0x25
  80066a:	ff d6                	call   *%esi
			break;
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	eb 9f                	jmp    800610 <vprintfmt+0x3c1>
			putch('%', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 25                	push   $0x25
  800677:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 f8                	mov    %edi,%eax
  80067e:	eb 03                	jmp    800683 <vprintfmt+0x434>
  800680:	83 e8 01             	sub    $0x1,%eax
  800683:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800687:	75 f7                	jne    800680 <vprintfmt+0x431>
  800689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068c:	eb 82                	jmp    800610 <vprintfmt+0x3c1>

0080068e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 18             	sub    $0x18,%esp
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80069a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80069d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006a1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	74 26                	je     8006d5 <vsnprintf+0x47>
  8006af:	85 d2                	test   %edx,%edx
  8006b1:	7e 22                	jle    8006d5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006b3:	ff 75 14             	pushl  0x14(%ebp)
  8006b6:	ff 75 10             	pushl  0x10(%ebp)
  8006b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006bc:	50                   	push   %eax
  8006bd:	68 15 02 80 00       	push   $0x800215
  8006c2:	e8 88 fb ff ff       	call   80024f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    
		return -E_INVAL;
  8006d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006da:	eb f7                	jmp    8006d3 <vsnprintf+0x45>

008006dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006e5:	50                   	push   %eax
  8006e6:	ff 75 10             	pushl  0x10(%ebp)
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	ff 75 08             	pushl  0x8(%ebp)
  8006ef:	e8 9a ff ff ff       	call   80068e <vsnprintf>
	va_end(ap);

	return rc;
}
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800701:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800705:	74 05                	je     80070c <strlen+0x16>
		n++;
  800707:	83 c0 01             	add    $0x1,%eax
  80070a:	eb f5                	jmp    800701 <strlen+0xb>
	return n;
}
  80070c:	5d                   	pop    %ebp
  80070d:	c3                   	ret    

0080070e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	39 c2                	cmp    %eax,%edx
  80071e:	74 0d                	je     80072d <strnlen+0x1f>
  800720:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800724:	74 05                	je     80072b <strnlen+0x1d>
		n++;
  800726:	83 c2 01             	add    $0x1,%edx
  800729:	eb f1                	jmp    80071c <strnlen+0xe>
  80072b:	89 d0                	mov    %edx,%eax
	return n;
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	53                   	push   %ebx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
  80073e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800742:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800745:	83 c2 01             	add    $0x1,%edx
  800748:	84 c9                	test   %cl,%cl
  80074a:	75 f2                	jne    80073e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80074c:	5b                   	pop    %ebx
  80074d:	5d                   	pop    %ebp
  80074e:	c3                   	ret    

0080074f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	53                   	push   %ebx
  800753:	83 ec 10             	sub    $0x10,%esp
  800756:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800759:	53                   	push   %ebx
  80075a:	e8 97 ff ff ff       	call   8006f6 <strlen>
  80075f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	01 d8                	add    %ebx,%eax
  800767:	50                   	push   %eax
  800768:	e8 c2 ff ff ff       	call   80072f <strcpy>
	return dst;
}
  80076d:	89 d8                	mov    %ebx,%eax
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	56                   	push   %esi
  800778:	53                   	push   %ebx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80077f:	89 c6                	mov    %eax,%esi
  800781:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800784:	89 c2                	mov    %eax,%edx
  800786:	39 f2                	cmp    %esi,%edx
  800788:	74 11                	je     80079b <strncpy+0x27>
		*dst++ = *src;
  80078a:	83 c2 01             	add    $0x1,%edx
  80078d:	0f b6 19             	movzbl (%ecx),%ebx
  800790:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800793:	80 fb 01             	cmp    $0x1,%bl
  800796:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800799:	eb eb                	jmp    800786 <strncpy+0x12>
	}
	return ret;
}
  80079b:	5b                   	pop    %ebx
  80079c:	5e                   	pop    %esi
  80079d:	5d                   	pop    %ebp
  80079e:	c3                   	ret    

0080079f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	56                   	push   %esi
  8007a3:	53                   	push   %ebx
  8007a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007aa:	8b 55 10             	mov    0x10(%ebp),%edx
  8007ad:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007af:	85 d2                	test   %edx,%edx
  8007b1:	74 21                	je     8007d4 <strlcpy+0x35>
  8007b3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007b7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007b9:	39 c2                	cmp    %eax,%edx
  8007bb:	74 14                	je     8007d1 <strlcpy+0x32>
  8007bd:	0f b6 19             	movzbl (%ecx),%ebx
  8007c0:	84 db                	test   %bl,%bl
  8007c2:	74 0b                	je     8007cf <strlcpy+0x30>
			*dst++ = *src++;
  8007c4:	83 c1 01             	add    $0x1,%ecx
  8007c7:	83 c2 01             	add    $0x1,%edx
  8007ca:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007cd:	eb ea                	jmp    8007b9 <strlcpy+0x1a>
  8007cf:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007d1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007d4:	29 f0                	sub    %esi,%eax
}
  8007d6:	5b                   	pop    %ebx
  8007d7:	5e                   	pop    %esi
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007e3:	0f b6 01             	movzbl (%ecx),%eax
  8007e6:	84 c0                	test   %al,%al
  8007e8:	74 0c                	je     8007f6 <strcmp+0x1c>
  8007ea:	3a 02                	cmp    (%edx),%al
  8007ec:	75 08                	jne    8007f6 <strcmp+0x1c>
		p++, q++;
  8007ee:	83 c1 01             	add    $0x1,%ecx
  8007f1:	83 c2 01             	add    $0x1,%edx
  8007f4:	eb ed                	jmp    8007e3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007f6:	0f b6 c0             	movzbl %al,%eax
  8007f9:	0f b6 12             	movzbl (%edx),%edx
  8007fc:	29 d0                	sub    %edx,%eax
}
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080a:	89 c3                	mov    %eax,%ebx
  80080c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80080f:	eb 06                	jmp    800817 <strncmp+0x17>
		n--, p++, q++;
  800811:	83 c0 01             	add    $0x1,%eax
  800814:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800817:	39 d8                	cmp    %ebx,%eax
  800819:	74 16                	je     800831 <strncmp+0x31>
  80081b:	0f b6 08             	movzbl (%eax),%ecx
  80081e:	84 c9                	test   %cl,%cl
  800820:	74 04                	je     800826 <strncmp+0x26>
  800822:	3a 0a                	cmp    (%edx),%cl
  800824:	74 eb                	je     800811 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800826:	0f b6 00             	movzbl (%eax),%eax
  800829:	0f b6 12             	movzbl (%edx),%edx
  80082c:	29 d0                	sub    %edx,%eax
}
  80082e:	5b                   	pop    %ebx
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    
		return 0;
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	eb f6                	jmp    80082e <strncmp+0x2e>

00800838 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800842:	0f b6 10             	movzbl (%eax),%edx
  800845:	84 d2                	test   %dl,%dl
  800847:	74 09                	je     800852 <strchr+0x1a>
		if (*s == c)
  800849:	38 ca                	cmp    %cl,%dl
  80084b:	74 0a                	je     800857 <strchr+0x1f>
	for (; *s; s++)
  80084d:	83 c0 01             	add    $0x1,%eax
  800850:	eb f0                	jmp    800842 <strchr+0xa>
			return (char *) s;
	return 0;
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800863:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800866:	38 ca                	cmp    %cl,%dl
  800868:	74 09                	je     800873 <strfind+0x1a>
  80086a:	84 d2                	test   %dl,%dl
  80086c:	74 05                	je     800873 <strfind+0x1a>
	for (; *s; s++)
  80086e:	83 c0 01             	add    $0x1,%eax
  800871:	eb f0                	jmp    800863 <strfind+0xa>
			break;
	return (char *) s;
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	57                   	push   %edi
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80087e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800881:	85 c9                	test   %ecx,%ecx
  800883:	74 31                	je     8008b6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800885:	89 f8                	mov    %edi,%eax
  800887:	09 c8                	or     %ecx,%eax
  800889:	a8 03                	test   $0x3,%al
  80088b:	75 23                	jne    8008b0 <memset+0x3b>
		c &= 0xFF;
  80088d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800891:	89 d3                	mov    %edx,%ebx
  800893:	c1 e3 08             	shl    $0x8,%ebx
  800896:	89 d0                	mov    %edx,%eax
  800898:	c1 e0 18             	shl    $0x18,%eax
  80089b:	89 d6                	mov    %edx,%esi
  80089d:	c1 e6 10             	shl    $0x10,%esi
  8008a0:	09 f0                	or     %esi,%eax
  8008a2:	09 c2                	or     %eax,%edx
  8008a4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008a6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008a9:	89 d0                	mov    %edx,%eax
  8008ab:	fc                   	cld    
  8008ac:	f3 ab                	rep stos %eax,%es:(%edi)
  8008ae:	eb 06                	jmp    8008b6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	fc                   	cld    
  8008b4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008b6:	89 f8                	mov    %edi,%eax
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5f                   	pop    %edi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008cb:	39 c6                	cmp    %eax,%esi
  8008cd:	73 32                	jae    800901 <memmove+0x44>
  8008cf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008d2:	39 c2                	cmp    %eax,%edx
  8008d4:	76 2b                	jbe    800901 <memmove+0x44>
		s += n;
		d += n;
  8008d6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d9:	89 fe                	mov    %edi,%esi
  8008db:	09 ce                	or     %ecx,%esi
  8008dd:	09 d6                	or     %edx,%esi
  8008df:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e5:	75 0e                	jne    8008f5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008e7:	83 ef 04             	sub    $0x4,%edi
  8008ea:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008ed:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008f0:	fd                   	std    
  8008f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008f3:	eb 09                	jmp    8008fe <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008f5:	83 ef 01             	sub    $0x1,%edi
  8008f8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008fb:	fd                   	std    
  8008fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008fe:	fc                   	cld    
  8008ff:	eb 1a                	jmp    80091b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800901:	89 c2                	mov    %eax,%edx
  800903:	09 ca                	or     %ecx,%edx
  800905:	09 f2                	or     %esi,%edx
  800907:	f6 c2 03             	test   $0x3,%dl
  80090a:	75 0a                	jne    800916 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80090c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80090f:	89 c7                	mov    %eax,%edi
  800911:	fc                   	cld    
  800912:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800914:	eb 05                	jmp    80091b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800916:	89 c7                	mov    %eax,%edi
  800918:	fc                   	cld    
  800919:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80091b:	5e                   	pop    %esi
  80091c:	5f                   	pop    %edi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800925:	ff 75 10             	pushl  0x10(%ebp)
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 8a ff ff ff       	call   8008bd <memmove>
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 c6                	mov    %eax,%esi
  800942:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800945:	39 f0                	cmp    %esi,%eax
  800947:	74 1c                	je     800965 <memcmp+0x30>
		if (*s1 != *s2)
  800949:	0f b6 08             	movzbl (%eax),%ecx
  80094c:	0f b6 1a             	movzbl (%edx),%ebx
  80094f:	38 d9                	cmp    %bl,%cl
  800951:	75 08                	jne    80095b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	eb ea                	jmp    800945 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80095b:	0f b6 c1             	movzbl %cl,%eax
  80095e:	0f b6 db             	movzbl %bl,%ebx
  800961:	29 d8                	sub    %ebx,%eax
  800963:	eb 05                	jmp    80096a <memcmp+0x35>
	}

	return 0;
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800977:	89 c2                	mov    %eax,%edx
  800979:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80097c:	39 d0                	cmp    %edx,%eax
  80097e:	73 09                	jae    800989 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800980:	38 08                	cmp    %cl,(%eax)
  800982:	74 05                	je     800989 <memfind+0x1b>
	for (; s < ends; s++)
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	eb f3                	jmp    80097c <memfind+0xe>
			break;
	return (void *) s;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	57                   	push   %edi
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800994:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800997:	eb 03                	jmp    80099c <strtol+0x11>
		s++;
  800999:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80099c:	0f b6 01             	movzbl (%ecx),%eax
  80099f:	3c 20                	cmp    $0x20,%al
  8009a1:	74 f6                	je     800999 <strtol+0xe>
  8009a3:	3c 09                	cmp    $0x9,%al
  8009a5:	74 f2                	je     800999 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009a7:	3c 2b                	cmp    $0x2b,%al
  8009a9:	74 2a                	je     8009d5 <strtol+0x4a>
	int neg = 0;
  8009ab:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009b0:	3c 2d                	cmp    $0x2d,%al
  8009b2:	74 2b                	je     8009df <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009b4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009ba:	75 0f                	jne    8009cb <strtol+0x40>
  8009bc:	80 39 30             	cmpb   $0x30,(%ecx)
  8009bf:	74 28                	je     8009e9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009c8:	0f 44 d8             	cmove  %eax,%ebx
  8009cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009d3:	eb 50                	jmp    800a25 <strtol+0x9a>
		s++;
  8009d5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009dd:	eb d5                	jmp    8009b4 <strtol+0x29>
		s++, neg = 1;
  8009df:	83 c1 01             	add    $0x1,%ecx
  8009e2:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e7:	eb cb                	jmp    8009b4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009e9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009ed:	74 0e                	je     8009fd <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	75 d8                	jne    8009cb <strtol+0x40>
		s++, base = 8;
  8009f3:	83 c1 01             	add    $0x1,%ecx
  8009f6:	bb 08 00 00 00       	mov    $0x8,%ebx
  8009fb:	eb ce                	jmp    8009cb <strtol+0x40>
		s += 2, base = 16;
  8009fd:	83 c1 02             	add    $0x2,%ecx
  800a00:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a05:	eb c4                	jmp    8009cb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a07:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a0a:	89 f3                	mov    %esi,%ebx
  800a0c:	80 fb 19             	cmp    $0x19,%bl
  800a0f:	77 29                	ja     800a3a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a11:	0f be d2             	movsbl %dl,%edx
  800a14:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a17:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a1a:	7d 30                	jge    800a4c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a1c:	83 c1 01             	add    $0x1,%ecx
  800a1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a25:	0f b6 11             	movzbl (%ecx),%edx
  800a28:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a2b:	89 f3                	mov    %esi,%ebx
  800a2d:	80 fb 09             	cmp    $0x9,%bl
  800a30:	77 d5                	ja     800a07 <strtol+0x7c>
			dig = *s - '0';
  800a32:	0f be d2             	movsbl %dl,%edx
  800a35:	83 ea 30             	sub    $0x30,%edx
  800a38:	eb dd                	jmp    800a17 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a3a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a3d:	89 f3                	mov    %esi,%ebx
  800a3f:	80 fb 19             	cmp    $0x19,%bl
  800a42:	77 08                	ja     800a4c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a44:	0f be d2             	movsbl %dl,%edx
  800a47:	83 ea 37             	sub    $0x37,%edx
  800a4a:	eb cb                	jmp    800a17 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a50:	74 05                	je     800a57 <strtol+0xcc>
		*endptr = (char *) s;
  800a52:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a55:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a57:	89 c2                	mov    %eax,%edx
  800a59:	f7 da                	neg    %edx
  800a5b:	85 ff                	test   %edi,%edi
  800a5d:	0f 45 c2             	cmovne %edx,%eax
}
  800a60:	5b                   	pop    %ebx
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	57                   	push   %edi
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a70:	8b 55 08             	mov    0x8(%ebp),%edx
  800a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a76:	89 c3                	mov    %eax,%ebx
  800a78:	89 c7                	mov    %eax,%edi
  800a7a:	89 c6                	mov    %eax,%esi
  800a7c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a7e:	5b                   	pop    %ebx
  800a7f:	5e                   	pop    %esi
  800a80:	5f                   	pop    %edi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	57                   	push   %edi
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a89:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800a93:	89 d1                	mov    %edx,%ecx
  800a95:	89 d3                	mov    %edx,%ebx
  800a97:	89 d7                	mov    %edx,%edi
  800a99:	89 d6                	mov    %edx,%esi
  800a9b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800a9d:	5b                   	pop    %ebx
  800a9e:	5e                   	pop    %esi
  800a9f:	5f                   	pop    %edi
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    

00800aa2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	57                   	push   %edi
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800aab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab8:	89 cb                	mov    %ecx,%ebx
  800aba:	89 cf                	mov    %ecx,%edi
  800abc:	89 ce                	mov    %ecx,%esi
  800abe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ac0:	85 c0                	test   %eax,%eax
  800ac2:	7f 08                	jg     800acc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ac7:	5b                   	pop    %ebx
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800acc:	83 ec 0c             	sub    $0xc,%esp
  800acf:	50                   	push   %eax
  800ad0:	6a 03                	push   $0x3
  800ad2:	68 bf 25 80 00       	push   $0x8025bf
  800ad7:	6a 23                	push   $0x23
  800ad9:	68 dc 25 80 00       	push   $0x8025dc
  800ade:	e8 b1 13 00 00       	call   801e94 <_panic>

00800ae3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	b8 02 00 00 00       	mov    $0x2,%eax
  800af3:	89 d1                	mov    %edx,%ecx
  800af5:	89 d3                	mov    %edx,%ebx
  800af7:	89 d7                	mov    %edx,%edi
  800af9:	89 d6                	mov    %edx,%esi
  800afb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5f                   	pop    %edi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <sys_yield>:

void
sys_yield(void)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b08:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b12:	89 d1                	mov    %edx,%ecx
  800b14:	89 d3                	mov    %edx,%ebx
  800b16:	89 d7                	mov    %edx,%edi
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5f                   	pop    %edi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	57                   	push   %edi
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
  800b27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b2a:	be 00 00 00 00       	mov    $0x0,%esi
  800b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b35:	b8 04 00 00 00       	mov    $0x4,%eax
  800b3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b3d:	89 f7                	mov    %esi,%edi
  800b3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b41:	85 c0                	test   %eax,%eax
  800b43:	7f 08                	jg     800b4d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5f                   	pop    %edi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b4d:	83 ec 0c             	sub    $0xc,%esp
  800b50:	50                   	push   %eax
  800b51:	6a 04                	push   $0x4
  800b53:	68 bf 25 80 00       	push   $0x8025bf
  800b58:	6a 23                	push   $0x23
  800b5a:	68 dc 25 80 00       	push   $0x8025dc
  800b5f:	e8 30 13 00 00       	call   801e94 <_panic>

00800b64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
  800b6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b73:	b8 05 00 00 00       	mov    $0x5,%eax
  800b78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b7e:	8b 75 18             	mov    0x18(%ebp),%esi
  800b81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b83:	85 c0                	test   %eax,%eax
  800b85:	7f 08                	jg     800b8f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b8f:	83 ec 0c             	sub    $0xc,%esp
  800b92:	50                   	push   %eax
  800b93:	6a 05                	push   $0x5
  800b95:	68 bf 25 80 00       	push   $0x8025bf
  800b9a:	6a 23                	push   $0x23
  800b9c:	68 dc 25 80 00       	push   $0x8025dc
  800ba1:	e8 ee 12 00 00       	call   801e94 <_panic>

00800ba6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
  800bac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800baf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bba:	b8 06 00 00 00       	mov    $0x6,%eax
  800bbf:	89 df                	mov    %ebx,%edi
  800bc1:	89 de                	mov    %ebx,%esi
  800bc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc5:	85 c0                	test   %eax,%eax
  800bc7:	7f 08                	jg     800bd1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	50                   	push   %eax
  800bd5:	6a 06                	push   $0x6
  800bd7:	68 bf 25 80 00       	push   $0x8025bf
  800bdc:	6a 23                	push   $0x23
  800bde:	68 dc 25 80 00       	push   $0x8025dc
  800be3:	e8 ac 12 00 00       	call   801e94 <_panic>

00800be8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfc:	b8 08 00 00 00       	mov    $0x8,%eax
  800c01:	89 df                	mov    %ebx,%edi
  800c03:	89 de                	mov    %ebx,%esi
  800c05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c07:	85 c0                	test   %eax,%eax
  800c09:	7f 08                	jg     800c13 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	6a 08                	push   $0x8
  800c19:	68 bf 25 80 00       	push   $0x8025bf
  800c1e:	6a 23                	push   $0x23
  800c20:	68 dc 25 80 00       	push   $0x8025dc
  800c25:	e8 6a 12 00 00       	call   801e94 <_panic>

00800c2a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800c43:	89 df                	mov    %ebx,%edi
  800c45:	89 de                	mov    %ebx,%esi
  800c47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c49:	85 c0                	test   %eax,%eax
  800c4b:	7f 08                	jg     800c55 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c55:	83 ec 0c             	sub    $0xc,%esp
  800c58:	50                   	push   %eax
  800c59:	6a 09                	push   $0x9
  800c5b:	68 bf 25 80 00       	push   $0x8025bf
  800c60:	6a 23                	push   $0x23
  800c62:	68 dc 25 80 00       	push   $0x8025dc
  800c67:	e8 28 12 00 00       	call   801e94 <_panic>

00800c6c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c85:	89 df                	mov    %ebx,%edi
  800c87:	89 de                	mov    %ebx,%esi
  800c89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8b:	85 c0                	test   %eax,%eax
  800c8d:	7f 08                	jg     800c97 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800c8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c97:	83 ec 0c             	sub    $0xc,%esp
  800c9a:	50                   	push   %eax
  800c9b:	6a 0a                	push   $0xa
  800c9d:	68 bf 25 80 00       	push   $0x8025bf
  800ca2:	6a 23                	push   $0x23
  800ca4:	68 dc 25 80 00       	push   $0x8025dc
  800ca9:	e8 e6 11 00 00       	call   801e94 <_panic>

00800cae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	57                   	push   %edi
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cbf:	be 00 00 00 00       	mov    $0x0,%esi
  800cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cca:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ce7:	89 cb                	mov    %ecx,%ebx
  800ce9:	89 cf                	mov    %ecx,%edi
  800ceb:	89 ce                	mov    %ecx,%esi
  800ced:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	7f 08                	jg     800cfb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	6a 0d                	push   $0xd
  800d01:	68 bf 25 80 00       	push   $0x8025bf
  800d06:	6a 23                	push   $0x23
  800d08:	68 dc 25 80 00       	push   $0x8025dc
  800d0d:	e8 82 11 00 00       	call   801e94 <_panic>

00800d12 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d22:	89 d1                	mov    %edx,%ecx
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	89 d7                	mov    %edx,%edi
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	05 00 00 00 30       	add    $0x30000000,%eax
  800d3c:	c1 e8 0c             	shr    $0xc,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d51:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d60:	89 c2                	mov    %eax,%edx
  800d62:	c1 ea 16             	shr    $0x16,%edx
  800d65:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d6c:	f6 c2 01             	test   $0x1,%dl
  800d6f:	74 2d                	je     800d9e <fd_alloc+0x46>
  800d71:	89 c2                	mov    %eax,%edx
  800d73:	c1 ea 0c             	shr    $0xc,%edx
  800d76:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d7d:	f6 c2 01             	test   $0x1,%dl
  800d80:	74 1c                	je     800d9e <fd_alloc+0x46>
  800d82:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d87:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d8c:	75 d2                	jne    800d60 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d97:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d9c:	eb 0a                	jmp    800da8 <fd_alloc+0x50>
			*fd_store = fd;
  800d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800db0:	83 f8 1f             	cmp    $0x1f,%eax
  800db3:	77 30                	ja     800de5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800db5:	c1 e0 0c             	shl    $0xc,%eax
  800db8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dbd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800dc3:	f6 c2 01             	test   $0x1,%dl
  800dc6:	74 24                	je     800dec <fd_lookup+0x42>
  800dc8:	89 c2                	mov    %eax,%edx
  800dca:	c1 ea 0c             	shr    $0xc,%edx
  800dcd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd4:	f6 c2 01             	test   $0x1,%dl
  800dd7:	74 1a                	je     800df3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	89 02                	mov    %eax,(%edx)
	return 0;
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		return -E_INVAL;
  800de5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dea:	eb f7                	jmp    800de3 <fd_lookup+0x39>
		return -E_INVAL;
  800dec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df1:	eb f0                	jmp    800de3 <fd_lookup+0x39>
  800df3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df8:	eb e9                	jmp    800de3 <fd_lookup+0x39>

00800dfa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800e03:	ba 00 00 00 00       	mov    $0x0,%edx
  800e08:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e0d:	39 08                	cmp    %ecx,(%eax)
  800e0f:	74 38                	je     800e49 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e11:	83 c2 01             	add    $0x1,%edx
  800e14:	8b 04 95 68 26 80 00 	mov    0x802668(,%edx,4),%eax
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	75 ee                	jne    800e0d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e1f:	a1 08 40 80 00       	mov    0x804008,%eax
  800e24:	8b 40 48             	mov    0x48(%eax),%eax
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	51                   	push   %ecx
  800e2b:	50                   	push   %eax
  800e2c:	68 ec 25 80 00       	push   $0x8025ec
  800e31:	e8 1d f3 ff ff       	call   800153 <cprintf>
	*dev = 0;
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    
			*dev = devtab[i];
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e53:	eb f2                	jmp    800e47 <dev_lookup+0x4d>

00800e55 <fd_close>:
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 24             	sub    $0x24,%esp
  800e5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800e61:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e67:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e68:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e6e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e71:	50                   	push   %eax
  800e72:	e8 33 ff ff ff       	call   800daa <fd_lookup>
  800e77:	89 c3                	mov    %eax,%ebx
  800e79:	83 c4 10             	add    $0x10,%esp
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	78 05                	js     800e85 <fd_close+0x30>
	    || fd != fd2)
  800e80:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e83:	74 16                	je     800e9b <fd_close+0x46>
		return (must_exist ? r : 0);
  800e85:	89 f8                	mov    %edi,%eax
  800e87:	84 c0                	test   %al,%al
  800e89:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8e:	0f 44 d8             	cmove  %eax,%ebx
}
  800e91:	89 d8                	mov    %ebx,%eax
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ea1:	50                   	push   %eax
  800ea2:	ff 36                	pushl  (%esi)
  800ea4:	e8 51 ff ff ff       	call   800dfa <dev_lookup>
  800ea9:	89 c3                	mov    %eax,%ebx
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 1a                	js     800ecc <fd_close+0x77>
		if (dev->dev_close)
  800eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eb5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	74 0b                	je     800ecc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	56                   	push   %esi
  800ec5:	ff d0                	call   *%eax
  800ec7:	89 c3                	mov    %eax,%ebx
  800ec9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	56                   	push   %esi
  800ed0:	6a 00                	push   $0x0
  800ed2:	e8 cf fc ff ff       	call   800ba6 <sys_page_unmap>
	return r;
  800ed7:	83 c4 10             	add    $0x10,%esp
  800eda:	eb b5                	jmp    800e91 <fd_close+0x3c>

00800edc <close>:

int
close(int fdnum)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ee2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ee5:	50                   	push   %eax
  800ee6:	ff 75 08             	pushl  0x8(%ebp)
  800ee9:	e8 bc fe ff ff       	call   800daa <fd_lookup>
  800eee:	83 c4 10             	add    $0x10,%esp
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	79 02                	jns    800ef7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    
		return fd_close(fd, 1);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	6a 01                	push   $0x1
  800efc:	ff 75 f4             	pushl  -0xc(%ebp)
  800eff:	e8 51 ff ff ff       	call   800e55 <fd_close>
  800f04:	83 c4 10             	add    $0x10,%esp
  800f07:	eb ec                	jmp    800ef5 <close+0x19>

00800f09 <close_all>:

void
close_all(void)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	53                   	push   %ebx
  800f19:	e8 be ff ff ff       	call   800edc <close>
	for (i = 0; i < MAXFD; i++)
  800f1e:	83 c3 01             	add    $0x1,%ebx
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	83 fb 20             	cmp    $0x20,%ebx
  800f27:	75 ec                	jne    800f15 <close_all+0xc>
}
  800f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f37:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f3a:	50                   	push   %eax
  800f3b:	ff 75 08             	pushl  0x8(%ebp)
  800f3e:	e8 67 fe ff ff       	call   800daa <fd_lookup>
  800f43:	89 c3                	mov    %eax,%ebx
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	0f 88 81 00 00 00    	js     800fd1 <dup+0xa3>
		return r;
	close(newfdnum);
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	e8 81 ff ff ff       	call   800edc <close>

	newfd = INDEX2FD(newfdnum);
  800f5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f5e:	c1 e6 0c             	shl    $0xc,%esi
  800f61:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f67:	83 c4 04             	add    $0x4,%esp
  800f6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f6d:	e8 cf fd ff ff       	call   800d41 <fd2data>
  800f72:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f74:	89 34 24             	mov    %esi,(%esp)
  800f77:	e8 c5 fd ff ff       	call   800d41 <fd2data>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f81:	89 d8                	mov    %ebx,%eax
  800f83:	c1 e8 16             	shr    $0x16,%eax
  800f86:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f8d:	a8 01                	test   $0x1,%al
  800f8f:	74 11                	je     800fa2 <dup+0x74>
  800f91:	89 d8                	mov    %ebx,%eax
  800f93:	c1 e8 0c             	shr    $0xc,%eax
  800f96:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f9d:	f6 c2 01             	test   $0x1,%dl
  800fa0:	75 39                	jne    800fdb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fa5:	89 d0                	mov    %edx,%eax
  800fa7:	c1 e8 0c             	shr    $0xc,%eax
  800faa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	25 07 0e 00 00       	and    $0xe07,%eax
  800fb9:	50                   	push   %eax
  800fba:	56                   	push   %esi
  800fbb:	6a 00                	push   $0x0
  800fbd:	52                   	push   %edx
  800fbe:	6a 00                	push   $0x0
  800fc0:	e8 9f fb ff ff       	call   800b64 <sys_page_map>
  800fc5:	89 c3                	mov    %eax,%ebx
  800fc7:	83 c4 20             	add    $0x20,%esp
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	78 31                	js     800fff <dup+0xd1>
		goto err;

	return newfdnum;
  800fce:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fd1:	89 d8                	mov    %ebx,%eax
  800fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fdb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe2:	83 ec 0c             	sub    $0xc,%esp
  800fe5:	25 07 0e 00 00       	and    $0xe07,%eax
  800fea:	50                   	push   %eax
  800feb:	57                   	push   %edi
  800fec:	6a 00                	push   $0x0
  800fee:	53                   	push   %ebx
  800fef:	6a 00                	push   $0x0
  800ff1:	e8 6e fb ff ff       	call   800b64 <sys_page_map>
  800ff6:	89 c3                	mov    %eax,%ebx
  800ff8:	83 c4 20             	add    $0x20,%esp
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	79 a3                	jns    800fa2 <dup+0x74>
	sys_page_unmap(0, newfd);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	56                   	push   %esi
  801003:	6a 00                	push   $0x0
  801005:	e8 9c fb ff ff       	call   800ba6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80100a:	83 c4 08             	add    $0x8,%esp
  80100d:	57                   	push   %edi
  80100e:	6a 00                	push   $0x0
  801010:	e8 91 fb ff ff       	call   800ba6 <sys_page_unmap>
	return r;
  801015:	83 c4 10             	add    $0x10,%esp
  801018:	eb b7                	jmp    800fd1 <dup+0xa3>

0080101a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	53                   	push   %ebx
  80101e:	83 ec 1c             	sub    $0x1c,%esp
  801021:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801024:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801027:	50                   	push   %eax
  801028:	53                   	push   %ebx
  801029:	e8 7c fd ff ff       	call   800daa <fd_lookup>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	78 3f                	js     801074 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80103b:	50                   	push   %eax
  80103c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103f:	ff 30                	pushl  (%eax)
  801041:	e8 b4 fd ff ff       	call   800dfa <dev_lookup>
  801046:	83 c4 10             	add    $0x10,%esp
  801049:	85 c0                	test   %eax,%eax
  80104b:	78 27                	js     801074 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80104d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801050:	8b 42 08             	mov    0x8(%edx),%eax
  801053:	83 e0 03             	and    $0x3,%eax
  801056:	83 f8 01             	cmp    $0x1,%eax
  801059:	74 1e                	je     801079 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80105b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105e:	8b 40 08             	mov    0x8(%eax),%eax
  801061:	85 c0                	test   %eax,%eax
  801063:	74 35                	je     80109a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	ff 75 10             	pushl  0x10(%ebp)
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	52                   	push   %edx
  80106f:	ff d0                	call   *%eax
  801071:	83 c4 10             	add    $0x10,%esp
}
  801074:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801077:	c9                   	leave  
  801078:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801079:	a1 08 40 80 00       	mov    0x804008,%eax
  80107e:	8b 40 48             	mov    0x48(%eax),%eax
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	53                   	push   %ebx
  801085:	50                   	push   %eax
  801086:	68 2d 26 80 00       	push   $0x80262d
  80108b:	e8 c3 f0 ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801098:	eb da                	jmp    801074 <read+0x5a>
		return -E_NOT_SUPP;
  80109a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80109f:	eb d3                	jmp    801074 <read+0x5a>

008010a1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010ad:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b5:	39 f3                	cmp    %esi,%ebx
  8010b7:	73 23                	jae    8010dc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	89 f0                	mov    %esi,%eax
  8010be:	29 d8                	sub    %ebx,%eax
  8010c0:	50                   	push   %eax
  8010c1:	89 d8                	mov    %ebx,%eax
  8010c3:	03 45 0c             	add    0xc(%ebp),%eax
  8010c6:	50                   	push   %eax
  8010c7:	57                   	push   %edi
  8010c8:	e8 4d ff ff ff       	call   80101a <read>
		if (m < 0)
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 06                	js     8010da <readn+0x39>
			return m;
		if (m == 0)
  8010d4:	74 06                	je     8010dc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8010d6:	01 c3                	add    %eax,%ebx
  8010d8:	eb db                	jmp    8010b5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010da:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010dc:	89 d8                	mov    %ebx,%eax
  8010de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e1:	5b                   	pop    %ebx
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 1c             	sub    $0x1c,%esp
  8010ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	53                   	push   %ebx
  8010f5:	e8 b0 fc ff ff       	call   800daa <fd_lookup>
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 3a                	js     80113b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801107:	50                   	push   %eax
  801108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110b:	ff 30                	pushl  (%eax)
  80110d:	e8 e8 fc ff ff       	call   800dfa <dev_lookup>
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	78 22                	js     80113b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801120:	74 1e                	je     801140 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801125:	8b 52 0c             	mov    0xc(%edx),%edx
  801128:	85 d2                	test   %edx,%edx
  80112a:	74 35                	je     801161 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	ff 75 10             	pushl  0x10(%ebp)
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	50                   	push   %eax
  801136:	ff d2                	call   *%edx
  801138:	83 c4 10             	add    $0x10,%esp
}
  80113b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801140:	a1 08 40 80 00       	mov    0x804008,%eax
  801145:	8b 40 48             	mov    0x48(%eax),%eax
  801148:	83 ec 04             	sub    $0x4,%esp
  80114b:	53                   	push   %ebx
  80114c:	50                   	push   %eax
  80114d:	68 49 26 80 00       	push   $0x802649
  801152:	e8 fc ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115f:	eb da                	jmp    80113b <write+0x55>
		return -E_NOT_SUPP;
  801161:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801166:	eb d3                	jmp    80113b <write+0x55>

00801168 <seek>:

int
seek(int fdnum, off_t offset)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80116e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801171:	50                   	push   %eax
  801172:	ff 75 08             	pushl  0x8(%ebp)
  801175:	e8 30 fc ff ff       	call   800daa <fd_lookup>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 0e                	js     80118f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801181:	8b 55 0c             	mov    0xc(%ebp),%edx
  801184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801187:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	53                   	push   %ebx
  801195:	83 ec 1c             	sub    $0x1c,%esp
  801198:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80119b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80119e:	50                   	push   %eax
  80119f:	53                   	push   %ebx
  8011a0:	e8 05 fc ff ff       	call   800daa <fd_lookup>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 37                	js     8011e3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b6:	ff 30                	pushl  (%eax)
  8011b8:	e8 3d fc ff ff       	call   800dfa <dev_lookup>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	78 1f                	js     8011e3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011cb:	74 1b                	je     8011e8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d0:	8b 52 18             	mov    0x18(%edx),%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	74 32                	je     801209 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	50                   	push   %eax
  8011de:	ff d2                	call   *%edx
  8011e0:	83 c4 10             	add    $0x10,%esp
}
  8011e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011e8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011ed:	8b 40 48             	mov    0x48(%eax),%eax
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	53                   	push   %ebx
  8011f4:	50                   	push   %eax
  8011f5:	68 0c 26 80 00       	push   $0x80260c
  8011fa:	e8 54 ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801207:	eb da                	jmp    8011e3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801209:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80120e:	eb d3                	jmp    8011e3 <ftruncate+0x52>

00801210 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	53                   	push   %ebx
  801214:	83 ec 1c             	sub    $0x1c,%esp
  801217:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 08             	pushl  0x8(%ebp)
  801221:	e8 84 fb ff ff       	call   800daa <fd_lookup>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	78 4b                	js     801278 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122d:	83 ec 08             	sub    $0x8,%esp
  801230:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801233:	50                   	push   %eax
  801234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801237:	ff 30                	pushl  (%eax)
  801239:	e8 bc fb ff ff       	call   800dfa <dev_lookup>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 33                	js     801278 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801248:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80124c:	74 2f                	je     80127d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80124e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801251:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801258:	00 00 00 
	stat->st_isdir = 0;
  80125b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801262:	00 00 00 
	stat->st_dev = dev;
  801265:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	53                   	push   %ebx
  80126f:	ff 75 f0             	pushl  -0x10(%ebp)
  801272:	ff 50 14             	call   *0x14(%eax)
  801275:	83 c4 10             	add    $0x10,%esp
}
  801278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    
		return -E_NOT_SUPP;
  80127d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801282:	eb f4                	jmp    801278 <fstat+0x68>

00801284 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	6a 00                	push   $0x0
  80128e:	ff 75 08             	pushl  0x8(%ebp)
  801291:	e8 2f 02 00 00       	call   8014c5 <open>
  801296:	89 c3                	mov    %eax,%ebx
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	78 1b                	js     8012ba <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	50                   	push   %eax
  8012a6:	e8 65 ff ff ff       	call   801210 <fstat>
  8012ab:	89 c6                	mov    %eax,%esi
	close(fd);
  8012ad:	89 1c 24             	mov    %ebx,(%esp)
  8012b0:	e8 27 fc ff ff       	call   800edc <close>
	return r;
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	89 f3                	mov    %esi,%ebx
}
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	56                   	push   %esi
  8012c7:	53                   	push   %ebx
  8012c8:	89 c6                	mov    %eax,%esi
  8012ca:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012cc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012d3:	74 27                	je     8012fc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012d5:	6a 07                	push   $0x7
  8012d7:	68 00 50 80 00       	push   $0x805000
  8012dc:	56                   	push   %esi
  8012dd:	ff 35 00 40 80 00    	pushl  0x804000
  8012e3:	e8 65 0c 00 00       	call   801f4d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012e8:	83 c4 0c             	add    $0xc,%esp
  8012eb:	6a 00                	push   $0x0
  8012ed:	53                   	push   %ebx
  8012ee:	6a 00                	push   $0x0
  8012f0:	e8 e5 0b 00 00       	call   801eda <ipc_recv>
}
  8012f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f8:	5b                   	pop    %ebx
  8012f9:	5e                   	pop    %esi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 01                	push   $0x1
  801301:	e8 b3 0c 00 00       	call   801fb9 <ipc_find_env>
  801306:	a3 00 40 80 00       	mov    %eax,0x804000
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	eb c5                	jmp    8012d5 <fsipc+0x12>

00801310 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8b 40 0c             	mov    0xc(%eax),%eax
  80131c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801329:	ba 00 00 00 00       	mov    $0x0,%edx
  80132e:	b8 02 00 00 00       	mov    $0x2,%eax
  801333:	e8 8b ff ff ff       	call   8012c3 <fsipc>
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <devfile_flush>:
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8b 40 0c             	mov    0xc(%eax),%eax
  801346:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80134b:	ba 00 00 00 00       	mov    $0x0,%edx
  801350:	b8 06 00 00 00       	mov    $0x6,%eax
  801355:	e8 69 ff ff ff       	call   8012c3 <fsipc>
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <devfile_stat>:
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	53                   	push   %ebx
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	8b 40 0c             	mov    0xc(%eax),%eax
  80136c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801371:	ba 00 00 00 00       	mov    $0x0,%edx
  801376:	b8 05 00 00 00       	mov    $0x5,%eax
  80137b:	e8 43 ff ff ff       	call   8012c3 <fsipc>
  801380:	85 c0                	test   %eax,%eax
  801382:	78 2c                	js     8013b0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	68 00 50 80 00       	push   $0x805000
  80138c:	53                   	push   %ebx
  80138d:	e8 9d f3 ff ff       	call   80072f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801392:	a1 80 50 80 00       	mov    0x805080,%eax
  801397:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80139d:	a1 84 50 80 00       	mov    0x805084,%eax
  8013a2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <devfile_write>:
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8013bf:	85 db                	test   %ebx,%ebx
  8013c1:	75 07                	jne    8013ca <devfile_write+0x15>
	return n_all;
  8013c3:	89 d8                	mov    %ebx,%eax
}
  8013c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013d0:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8013d5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	53                   	push   %ebx
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	68 08 50 80 00       	push   $0x805008
  8013e7:	e8 d1 f4 ff ff       	call   8008bd <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8013f6:	e8 c8 fe ff ff       	call   8012c3 <fsipc>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 c3                	js     8013c5 <devfile_write+0x10>
	  assert(r <= n_left);
  801402:	39 d8                	cmp    %ebx,%eax
  801404:	77 0b                	ja     801411 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801406:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80140b:	7f 1d                	jg     80142a <devfile_write+0x75>
    n_all += r;
  80140d:	89 c3                	mov    %eax,%ebx
  80140f:	eb b2                	jmp    8013c3 <devfile_write+0xe>
	  assert(r <= n_left);
  801411:	68 7c 26 80 00       	push   $0x80267c
  801416:	68 88 26 80 00       	push   $0x802688
  80141b:	68 9f 00 00 00       	push   $0x9f
  801420:	68 9d 26 80 00       	push   $0x80269d
  801425:	e8 6a 0a 00 00       	call   801e94 <_panic>
	  assert(r <= PGSIZE);
  80142a:	68 a8 26 80 00       	push   $0x8026a8
  80142f:	68 88 26 80 00       	push   $0x802688
  801434:	68 a0 00 00 00       	push   $0xa0
  801439:	68 9d 26 80 00       	push   $0x80269d
  80143e:	e8 51 0a 00 00       	call   801e94 <_panic>

00801443 <devfile_read>:
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
  801448:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8b 40 0c             	mov    0xc(%eax),%eax
  801451:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801456:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80145c:	ba 00 00 00 00       	mov    $0x0,%edx
  801461:	b8 03 00 00 00       	mov    $0x3,%eax
  801466:	e8 58 fe ff ff       	call   8012c3 <fsipc>
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 1f                	js     801490 <devfile_read+0x4d>
	assert(r <= n);
  801471:	39 f0                	cmp    %esi,%eax
  801473:	77 24                	ja     801499 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801475:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80147a:	7f 33                	jg     8014af <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	50                   	push   %eax
  801480:	68 00 50 80 00       	push   $0x805000
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	e8 30 f4 ff ff       	call   8008bd <memmove>
	return r;
  80148d:	83 c4 10             	add    $0x10,%esp
}
  801490:	89 d8                	mov    %ebx,%eax
  801492:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    
	assert(r <= n);
  801499:	68 b4 26 80 00       	push   $0x8026b4
  80149e:	68 88 26 80 00       	push   $0x802688
  8014a3:	6a 7c                	push   $0x7c
  8014a5:	68 9d 26 80 00       	push   $0x80269d
  8014aa:	e8 e5 09 00 00       	call   801e94 <_panic>
	assert(r <= PGSIZE);
  8014af:	68 a8 26 80 00       	push   $0x8026a8
  8014b4:	68 88 26 80 00       	push   $0x802688
  8014b9:	6a 7d                	push   $0x7d
  8014bb:	68 9d 26 80 00       	push   $0x80269d
  8014c0:	e8 cf 09 00 00       	call   801e94 <_panic>

008014c5 <open>:
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
  8014ca:	83 ec 1c             	sub    $0x1c,%esp
  8014cd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014d0:	56                   	push   %esi
  8014d1:	e8 20 f2 ff ff       	call   8006f6 <strlen>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014de:	7f 6c                	jg     80154c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e6:	50                   	push   %eax
  8014e7:	e8 6c f8 ff ff       	call   800d58 <fd_alloc>
  8014ec:	89 c3                	mov    %eax,%ebx
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 3c                	js     801531 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	56                   	push   %esi
  8014f9:	68 00 50 80 00       	push   $0x805000
  8014fe:	e8 2c f2 ff ff       	call   80072f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80150b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150e:	b8 01 00 00 00       	mov    $0x1,%eax
  801513:	e8 ab fd ff ff       	call   8012c3 <fsipc>
  801518:	89 c3                	mov    %eax,%ebx
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 19                	js     80153a <open+0x75>
	return fd2num(fd);
  801521:	83 ec 0c             	sub    $0xc,%esp
  801524:	ff 75 f4             	pushl  -0xc(%ebp)
  801527:	e8 05 f8 ff ff       	call   800d31 <fd2num>
  80152c:	89 c3                	mov    %eax,%ebx
  80152e:	83 c4 10             	add    $0x10,%esp
}
  801531:	89 d8                	mov    %ebx,%eax
  801533:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801536:	5b                   	pop    %ebx
  801537:	5e                   	pop    %esi
  801538:	5d                   	pop    %ebp
  801539:	c3                   	ret    
		fd_close(fd, 0);
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	6a 00                	push   $0x0
  80153f:	ff 75 f4             	pushl  -0xc(%ebp)
  801542:	e8 0e f9 ff ff       	call   800e55 <fd_close>
		return r;
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	eb e5                	jmp    801531 <open+0x6c>
		return -E_BAD_PATH;
  80154c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801551:	eb de                	jmp    801531 <open+0x6c>

00801553 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801559:	ba 00 00 00 00       	mov    $0x0,%edx
  80155e:	b8 08 00 00 00       	mov    $0x8,%eax
  801563:	e8 5b fd ff ff       	call   8012c3 <fsipc>
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	ff 75 08             	pushl  0x8(%ebp)
  801578:	e8 c4 f7 ff ff       	call   800d41 <fd2data>
  80157d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80157f:	83 c4 08             	add    $0x8,%esp
  801582:	68 bb 26 80 00       	push   $0x8026bb
  801587:	53                   	push   %ebx
  801588:	e8 a2 f1 ff ff       	call   80072f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80158d:	8b 46 04             	mov    0x4(%esi),%eax
  801590:	2b 06                	sub    (%esi),%eax
  801592:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801598:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80159f:	00 00 00 
	stat->st_dev = &devpipe;
  8015a2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015a9:	30 80 00 
	return 0;
}
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b4:	5b                   	pop    %ebx
  8015b5:	5e                   	pop    %esi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	53                   	push   %ebx
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015c2:	53                   	push   %ebx
  8015c3:	6a 00                	push   $0x0
  8015c5:	e8 dc f5 ff ff       	call   800ba6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015ca:	89 1c 24             	mov    %ebx,(%esp)
  8015cd:	e8 6f f7 ff ff       	call   800d41 <fd2data>
  8015d2:	83 c4 08             	add    $0x8,%esp
  8015d5:	50                   	push   %eax
  8015d6:	6a 00                	push   $0x0
  8015d8:	e8 c9 f5 ff ff       	call   800ba6 <sys_page_unmap>
}
  8015dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <_pipeisclosed>:
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	57                   	push   %edi
  8015e6:	56                   	push   %esi
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 1c             	sub    $0x1c,%esp
  8015eb:	89 c7                	mov    %eax,%edi
  8015ed:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8015f4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	57                   	push   %edi
  8015fb:	e8 f2 09 00 00       	call   801ff2 <pageref>
  801600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801603:	89 34 24             	mov    %esi,(%esp)
  801606:	e8 e7 09 00 00       	call   801ff2 <pageref>
		nn = thisenv->env_runs;
  80160b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801611:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	39 cb                	cmp    %ecx,%ebx
  801619:	74 1b                	je     801636 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80161b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80161e:	75 cf                	jne    8015ef <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801620:	8b 42 58             	mov    0x58(%edx),%eax
  801623:	6a 01                	push   $0x1
  801625:	50                   	push   %eax
  801626:	53                   	push   %ebx
  801627:	68 c2 26 80 00       	push   $0x8026c2
  80162c:	e8 22 eb ff ff       	call   800153 <cprintf>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	eb b9                	jmp    8015ef <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801636:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801639:	0f 94 c0             	sete   %al
  80163c:	0f b6 c0             	movzbl %al,%eax
}
  80163f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801642:	5b                   	pop    %ebx
  801643:	5e                   	pop    %esi
  801644:	5f                   	pop    %edi
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    

00801647 <devpipe_write>:
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	57                   	push   %edi
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 28             	sub    $0x28,%esp
  801650:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801653:	56                   	push   %esi
  801654:	e8 e8 f6 ff ff       	call   800d41 <fd2data>
  801659:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	bf 00 00 00 00       	mov    $0x0,%edi
  801663:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801666:	74 4f                	je     8016b7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801668:	8b 43 04             	mov    0x4(%ebx),%eax
  80166b:	8b 0b                	mov    (%ebx),%ecx
  80166d:	8d 51 20             	lea    0x20(%ecx),%edx
  801670:	39 d0                	cmp    %edx,%eax
  801672:	72 14                	jb     801688 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801674:	89 da                	mov    %ebx,%edx
  801676:	89 f0                	mov    %esi,%eax
  801678:	e8 65 ff ff ff       	call   8015e2 <_pipeisclosed>
  80167d:	85 c0                	test   %eax,%eax
  80167f:	75 3b                	jne    8016bc <devpipe_write+0x75>
			sys_yield();
  801681:	e8 7c f4 ff ff       	call   800b02 <sys_yield>
  801686:	eb e0                	jmp    801668 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801688:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80168f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801692:	89 c2                	mov    %eax,%edx
  801694:	c1 fa 1f             	sar    $0x1f,%edx
  801697:	89 d1                	mov    %edx,%ecx
  801699:	c1 e9 1b             	shr    $0x1b,%ecx
  80169c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80169f:	83 e2 1f             	and    $0x1f,%edx
  8016a2:	29 ca                	sub    %ecx,%edx
  8016a4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016ac:	83 c0 01             	add    $0x1,%eax
  8016af:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016b2:	83 c7 01             	add    $0x1,%edi
  8016b5:	eb ac                	jmp    801663 <devpipe_write+0x1c>
	return i;
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	eb 05                	jmp    8016c1 <devpipe_write+0x7a>
				return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5f                   	pop    %edi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <devpipe_read>:
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	57                   	push   %edi
  8016cd:	56                   	push   %esi
  8016ce:	53                   	push   %ebx
  8016cf:	83 ec 18             	sub    $0x18,%esp
  8016d2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016d5:	57                   	push   %edi
  8016d6:	e8 66 f6 ff ff       	call   800d41 <fd2data>
  8016db:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	be 00 00 00 00       	mov    $0x0,%esi
  8016e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016e8:	75 14                	jne    8016fe <devpipe_read+0x35>
	return i;
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	eb 02                	jmp    8016f1 <devpipe_read+0x28>
				return i;
  8016ef:	89 f0                	mov    %esi,%eax
}
  8016f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5f                   	pop    %edi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    
			sys_yield();
  8016f9:	e8 04 f4 ff ff       	call   800b02 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8016fe:	8b 03                	mov    (%ebx),%eax
  801700:	3b 43 04             	cmp    0x4(%ebx),%eax
  801703:	75 18                	jne    80171d <devpipe_read+0x54>
			if (i > 0)
  801705:	85 f6                	test   %esi,%esi
  801707:	75 e6                	jne    8016ef <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801709:	89 da                	mov    %ebx,%edx
  80170b:	89 f8                	mov    %edi,%eax
  80170d:	e8 d0 fe ff ff       	call   8015e2 <_pipeisclosed>
  801712:	85 c0                	test   %eax,%eax
  801714:	74 e3                	je     8016f9 <devpipe_read+0x30>
				return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
  80171b:	eb d4                	jmp    8016f1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80171d:	99                   	cltd   
  80171e:	c1 ea 1b             	shr    $0x1b,%edx
  801721:	01 d0                	add    %edx,%eax
  801723:	83 e0 1f             	and    $0x1f,%eax
  801726:	29 d0                	sub    %edx,%eax
  801728:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80172d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801730:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801733:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801736:	83 c6 01             	add    $0x1,%esi
  801739:	eb aa                	jmp    8016e5 <devpipe_read+0x1c>

0080173b <pipe>:
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801743:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801746:	50                   	push   %eax
  801747:	e8 0c f6 ff ff       	call   800d58 <fd_alloc>
  80174c:	89 c3                	mov    %eax,%ebx
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	0f 88 23 01 00 00    	js     80187c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	68 07 04 00 00       	push   $0x407
  801761:	ff 75 f4             	pushl  -0xc(%ebp)
  801764:	6a 00                	push   $0x0
  801766:	e8 b6 f3 ff ff       	call   800b21 <sys_page_alloc>
  80176b:	89 c3                	mov    %eax,%ebx
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	85 c0                	test   %eax,%eax
  801772:	0f 88 04 01 00 00    	js     80187c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177e:	50                   	push   %eax
  80177f:	e8 d4 f5 ff ff       	call   800d58 <fd_alloc>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	0f 88 db 00 00 00    	js     80186c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 07 04 00 00       	push   $0x407
  801799:	ff 75 f0             	pushl  -0x10(%ebp)
  80179c:	6a 00                	push   $0x0
  80179e:	e8 7e f3 ff ff       	call   800b21 <sys_page_alloc>
  8017a3:	89 c3                	mov    %eax,%ebx
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	0f 88 bc 00 00 00    	js     80186c <pipe+0x131>
	va = fd2data(fd0);
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b6:	e8 86 f5 ff ff       	call   800d41 <fd2data>
  8017bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017bd:	83 c4 0c             	add    $0xc,%esp
  8017c0:	68 07 04 00 00       	push   $0x407
  8017c5:	50                   	push   %eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	e8 54 f3 ff ff       	call   800b21 <sys_page_alloc>
  8017cd:	89 c3                	mov    %eax,%ebx
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	0f 88 82 00 00 00    	js     80185c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017da:	83 ec 0c             	sub    $0xc,%esp
  8017dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e0:	e8 5c f5 ff ff       	call   800d41 <fd2data>
  8017e5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017ec:	50                   	push   %eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	56                   	push   %esi
  8017f0:	6a 00                	push   $0x0
  8017f2:	e8 6d f3 ff ff       	call   800b64 <sys_page_map>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	83 c4 20             	add    $0x20,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 4e                	js     80184e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801800:	a1 20 30 80 00       	mov    0x803020,%eax
  801805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801808:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801817:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	ff 75 f4             	pushl  -0xc(%ebp)
  801829:	e8 03 f5 ff ff       	call   800d31 <fd2num>
  80182e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801831:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801833:	83 c4 04             	add    $0x4,%esp
  801836:	ff 75 f0             	pushl  -0x10(%ebp)
  801839:	e8 f3 f4 ff ff       	call   800d31 <fd2num>
  80183e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801841:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184c:	eb 2e                	jmp    80187c <pipe+0x141>
	sys_page_unmap(0, va);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	56                   	push   %esi
  801852:	6a 00                	push   $0x0
  801854:	e8 4d f3 ff ff       	call   800ba6 <sys_page_unmap>
  801859:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	ff 75 f0             	pushl  -0x10(%ebp)
  801862:	6a 00                	push   $0x0
  801864:	e8 3d f3 ff ff       	call   800ba6 <sys_page_unmap>
  801869:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	ff 75 f4             	pushl  -0xc(%ebp)
  801872:	6a 00                	push   $0x0
  801874:	e8 2d f3 ff ff       	call   800ba6 <sys_page_unmap>
  801879:	83 c4 10             	add    $0x10,%esp
}
  80187c:	89 d8                	mov    %ebx,%eax
  80187e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <pipeisclosed>:
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	50                   	push   %eax
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	e8 13 f5 ff ff       	call   800daa <fd_lookup>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 18                	js     8018b6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a4:	e8 98 f4 ff ff       	call   800d41 <fd2data>
	return _pipeisclosed(fd, p);
  8018a9:	89 c2                	mov    %eax,%edx
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	e8 2f fd ff ff       	call   8015e2 <_pipeisclosed>
  8018b3:	83 c4 10             	add    $0x10,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018be:	68 da 26 80 00       	push   $0x8026da
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	e8 64 ee ff ff       	call   80072f <strcpy>
	return 0;
}
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <devsock_close>:
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	53                   	push   %ebx
  8018d6:	83 ec 10             	sub    $0x10,%esp
  8018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018dc:	53                   	push   %ebx
  8018dd:	e8 10 07 00 00       	call   801ff2 <pageref>
  8018e2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018e5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018ea:	83 f8 01             	cmp    $0x1,%eax
  8018ed:	74 07                	je     8018f6 <devsock_close+0x24>
}
  8018ef:	89 d0                	mov    %edx,%eax
  8018f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	ff 73 0c             	pushl  0xc(%ebx)
  8018fc:	e8 b9 02 00 00       	call   801bba <nsipc_close>
  801901:	89 c2                	mov    %eax,%edx
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	eb e7                	jmp    8018ef <devsock_close+0x1d>

00801908 <devsock_write>:
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 10             	pushl  0x10(%ebp)
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	ff 70 0c             	pushl  0xc(%eax)
  80191c:	e8 76 03 00 00       	call   801c97 <nsipc_send>
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <devsock_read>:
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 10             	pushl  0x10(%ebp)
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	ff 70 0c             	pushl  0xc(%eax)
  801937:	e8 ef 02 00 00       	call   801c2b <nsipc_recv>
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <fd2sockid>:
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801944:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	e8 5c f4 ff ff       	call   800daa <fd_lookup>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 10                	js     801965 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  80195e:	39 08                	cmp    %ecx,(%eax)
  801960:	75 05                	jne    801967 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801962:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    
		return -E_NOT_SUPP;
  801967:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80196c:	eb f7                	jmp    801965 <fd2sockid+0x27>

0080196e <alloc_sockfd>:
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	83 ec 1c             	sub    $0x1c,%esp
  801976:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801978:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197b:	50                   	push   %eax
  80197c:	e8 d7 f3 ff ff       	call   800d58 <fd_alloc>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	85 c0                	test   %eax,%eax
  801988:	78 43                	js     8019cd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80198a:	83 ec 04             	sub    $0x4,%esp
  80198d:	68 07 04 00 00       	push   $0x407
  801992:	ff 75 f4             	pushl  -0xc(%ebp)
  801995:	6a 00                	push   $0x0
  801997:	e8 85 f1 ff ff       	call   800b21 <sys_page_alloc>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 28                	js     8019cd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019ae:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019ba:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	50                   	push   %eax
  8019c1:	e8 6b f3 ff ff       	call   800d31 <fd2num>
  8019c6:	89 c3                	mov    %eax,%ebx
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	eb 0c                	jmp    8019d9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019cd:	83 ec 0c             	sub    $0xc,%esp
  8019d0:	56                   	push   %esi
  8019d1:	e8 e4 01 00 00       	call   801bba <nsipc_close>
		return r;
  8019d6:	83 c4 10             	add    $0x10,%esp
}
  8019d9:	89 d8                	mov    %ebx,%eax
  8019db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <accept>:
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	e8 4e ff ff ff       	call   80193e <fd2sockid>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 1b                	js     801a0f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	ff 75 10             	pushl  0x10(%ebp)
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	50                   	push   %eax
  8019fe:	e8 0e 01 00 00       	call   801b11 <nsipc_accept>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 05                	js     801a0f <accept+0x2d>
	return alloc_sockfd(r);
  801a0a:	e8 5f ff ff ff       	call   80196e <alloc_sockfd>
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <bind>:
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	e8 1f ff ff ff       	call   80193e <fd2sockid>
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 12                	js     801a35 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	ff 75 10             	pushl  0x10(%ebp)
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	50                   	push   %eax
  801a2d:	e8 31 01 00 00       	call   801b63 <nsipc_bind>
  801a32:	83 c4 10             	add    $0x10,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <shutdown>:
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	e8 f9 fe ff ff       	call   80193e <fd2sockid>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 0f                	js     801a58 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a49:	83 ec 08             	sub    $0x8,%esp
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	e8 43 01 00 00       	call   801b98 <nsipc_shutdown>
  801a55:	83 c4 10             	add    $0x10,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <connect>:
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	e8 d6 fe ff ff       	call   80193e <fd2sockid>
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 12                	js     801a7e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	ff 75 10             	pushl  0x10(%ebp)
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	50                   	push   %eax
  801a76:	e8 59 01 00 00       	call   801bd4 <nsipc_connect>
  801a7b:	83 c4 10             	add    $0x10,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <listen>:
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	e8 b0 fe ff ff       	call   80193e <fd2sockid>
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 0f                	js     801aa1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a92:	83 ec 08             	sub    $0x8,%esp
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	50                   	push   %eax
  801a99:	e8 6b 01 00 00       	call   801c09 <nsipc_listen>
  801a9e:	83 c4 10             	add    $0x10,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aa9:	ff 75 10             	pushl  0x10(%ebp)
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	e8 3e 02 00 00       	call   801cf5 <nsipc_socket>
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 05                	js     801ac3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801abe:	e8 ab fe ff ff       	call   80196e <alloc_sockfd>
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	53                   	push   %ebx
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ace:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ad5:	74 26                	je     801afd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ad7:	6a 07                	push   $0x7
  801ad9:	68 00 60 80 00       	push   $0x806000
  801ade:	53                   	push   %ebx
  801adf:	ff 35 04 40 80 00    	pushl  0x804004
  801ae5:	e8 63 04 00 00       	call   801f4d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aea:	83 c4 0c             	add    $0xc,%esp
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	e8 e2 03 00 00       	call   801eda <ipc_recv>
}
  801af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	6a 02                	push   $0x2
  801b02:	e8 b2 04 00 00       	call   801fb9 <ipc_find_env>
  801b07:	a3 04 40 80 00       	mov    %eax,0x804004
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	eb c6                	jmp    801ad7 <nsipc+0x12>

00801b11 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	56                   	push   %esi
  801b15:	53                   	push   %ebx
  801b16:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b21:	8b 06                	mov    (%esi),%eax
  801b23:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b28:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2d:	e8 93 ff ff ff       	call   801ac5 <nsipc>
  801b32:	89 c3                	mov    %eax,%ebx
  801b34:	85 c0                	test   %eax,%eax
  801b36:	79 09                	jns    801b41 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	ff 35 10 60 80 00    	pushl  0x806010
  801b4a:	68 00 60 80 00       	push   $0x806000
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	e8 66 ed ff ff       	call   8008bd <memmove>
		*addrlen = ret->ret_addrlen;
  801b57:	a1 10 60 80 00       	mov    0x806010,%eax
  801b5c:	89 06                	mov    %eax,(%esi)
  801b5e:	83 c4 10             	add    $0x10,%esp
	return r;
  801b61:	eb d5                	jmp    801b38 <nsipc_accept+0x27>

00801b63 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	53                   	push   %ebx
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b75:	53                   	push   %ebx
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	68 04 60 80 00       	push   $0x806004
  801b7e:	e8 3a ed ff ff       	call   8008bd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b89:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8e:	e8 32 ff ff ff       	call   801ac5 <nsipc>
}
  801b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bae:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb3:	e8 0d ff ff ff       	call   801ac5 <nsipc>
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <nsipc_close>:

int
nsipc_close(int s)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bc8:	b8 04 00 00 00       	mov    $0x4,%eax
  801bcd:	e8 f3 fe ff ff       	call   801ac5 <nsipc>
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 08             	sub    $0x8,%esp
  801bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801be6:	53                   	push   %ebx
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	68 04 60 80 00       	push   $0x806004
  801bef:	e8 c9 ec ff ff       	call   8008bd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bf4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bfa:	b8 05 00 00 00       	mov    $0x5,%eax
  801bff:	e8 c1 fe ff ff       	call   801ac5 <nsipc>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c1f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c24:	e8 9c fe ff ff       	call   801ac5 <nsipc>
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	56                   	push   %esi
  801c2f:	53                   	push   %ebx
  801c30:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c3b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c41:	8b 45 14             	mov    0x14(%ebp),%eax
  801c44:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c49:	b8 07 00 00 00       	mov    $0x7,%eax
  801c4e:	e8 72 fe ff ff       	call   801ac5 <nsipc>
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 1f                	js     801c78 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c59:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c5e:	7f 21                	jg     801c81 <nsipc_recv+0x56>
  801c60:	39 c6                	cmp    %eax,%esi
  801c62:	7c 1d                	jl     801c81 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	50                   	push   %eax
  801c68:	68 00 60 80 00       	push   $0x806000
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 48 ec ff ff       	call   8008bd <memmove>
  801c75:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c81:	68 e6 26 80 00       	push   $0x8026e6
  801c86:	68 88 26 80 00       	push   $0x802688
  801c8b:	6a 62                	push   $0x62
  801c8d:	68 fb 26 80 00       	push   $0x8026fb
  801c92:	e8 fd 01 00 00       	call   801e94 <_panic>

00801c97 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ca9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801caf:	7f 2e                	jg     801cdf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	53                   	push   %ebx
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	68 0c 60 80 00       	push   $0x80600c
  801cbd:	e8 fb eb ff ff       	call   8008bd <memmove>
	nsipcbuf.send.req_size = size;
  801cc2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cd0:	b8 08 00 00 00       	mov    $0x8,%eax
  801cd5:	e8 eb fd ff ff       	call   801ac5 <nsipc>
}
  801cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    
	assert(size < 1600);
  801cdf:	68 07 27 80 00       	push   $0x802707
  801ce4:	68 88 26 80 00       	push   $0x802688
  801ce9:	6a 6d                	push   $0x6d
  801ceb:	68 fb 26 80 00       	push   $0x8026fb
  801cf0:	e8 9f 01 00 00       	call   801e94 <_panic>

00801cf5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d06:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d13:	b8 09 00 00 00       	mov    $0x9,%eax
  801d18:	e8 a8 fd ff ff       	call   801ac5 <nsipc>
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	c3                   	ret    

00801d25 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d2b:	68 13 27 80 00       	push   $0x802713
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	e8 f7 e9 ff ff       	call   80072f <strcpy>
	return 0;
}
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devcons_write>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	57                   	push   %edi
  801d43:	56                   	push   %esi
  801d44:	53                   	push   %ebx
  801d45:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d4b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d50:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d56:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d59:	73 31                	jae    801d8c <devcons_write+0x4d>
		m = n - tot;
  801d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d5e:	29 f3                	sub    %esi,%ebx
  801d60:	83 fb 7f             	cmp    $0x7f,%ebx
  801d63:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d68:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	53                   	push   %ebx
  801d6f:	89 f0                	mov    %esi,%eax
  801d71:	03 45 0c             	add    0xc(%ebp),%eax
  801d74:	50                   	push   %eax
  801d75:	57                   	push   %edi
  801d76:	e8 42 eb ff ff       	call   8008bd <memmove>
		sys_cputs(buf, m);
  801d7b:	83 c4 08             	add    $0x8,%esp
  801d7e:	53                   	push   %ebx
  801d7f:	57                   	push   %edi
  801d80:	e8 e0 ec ff ff       	call   800a65 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d85:	01 de                	add    %ebx,%esi
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	eb ca                	jmp    801d56 <devcons_write+0x17>
}
  801d8c:	89 f0                	mov    %esi,%eax
  801d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5f                   	pop    %edi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    

00801d96 <devcons_read>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801da1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801da5:	74 21                	je     801dc8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801da7:	e8 d7 ec ff ff       	call   800a83 <sys_cgetc>
  801dac:	85 c0                	test   %eax,%eax
  801dae:	75 07                	jne    801db7 <devcons_read+0x21>
		sys_yield();
  801db0:	e8 4d ed ff ff       	call   800b02 <sys_yield>
  801db5:	eb f0                	jmp    801da7 <devcons_read+0x11>
	if (c < 0)
  801db7:	78 0f                	js     801dc8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801db9:	83 f8 04             	cmp    $0x4,%eax
  801dbc:	74 0c                	je     801dca <devcons_read+0x34>
	*(char*)vbuf = c;
  801dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc1:	88 02                	mov    %al,(%edx)
	return 1;
  801dc3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    
		return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	eb f7                	jmp    801dc8 <devcons_read+0x32>

00801dd1 <cputchar>:
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ddd:	6a 01                	push   $0x1
  801ddf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de2:	50                   	push   %eax
  801de3:	e8 7d ec ff ff       	call   800a65 <sys_cputs>
}
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <getchar>:
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801df3:	6a 01                	push   $0x1
  801df5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801df8:	50                   	push   %eax
  801df9:	6a 00                	push   $0x0
  801dfb:	e8 1a f2 ff ff       	call   80101a <read>
	if (r < 0)
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 06                	js     801e0d <getchar+0x20>
	if (r < 1)
  801e07:	74 06                	je     801e0f <getchar+0x22>
	return c;
  801e09:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    
		return -E_EOF;
  801e0f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e14:	eb f7                	jmp    801e0d <getchar+0x20>

00801e16 <iscons>:
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1f:	50                   	push   %eax
  801e20:	ff 75 08             	pushl  0x8(%ebp)
  801e23:	e8 82 ef ff ff       	call   800daa <fd_lookup>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	78 11                	js     801e40 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e32:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e38:	39 10                	cmp    %edx,(%eax)
  801e3a:	0f 94 c0             	sete   %al
  801e3d:	0f b6 c0             	movzbl %al,%eax
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <opencons>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4b:	50                   	push   %eax
  801e4c:	e8 07 ef ff ff       	call   800d58 <fd_alloc>
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	85 c0                	test   %eax,%eax
  801e56:	78 3a                	js     801e92 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 07 04 00 00       	push   $0x407
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	6a 00                	push   $0x0
  801e65:	e8 b7 ec ff ff       	call   800b21 <sys_page_alloc>
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	78 21                	js     801e92 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e74:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e7a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	50                   	push   %eax
  801e8a:	e8 a2 ee ff ff       	call   800d31 <fd2num>
  801e8f:	83 c4 10             	add    $0x10,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e99:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ea2:	e8 3c ec ff ff       	call   800ae3 <sys_getenvid>
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	56                   	push   %esi
  801eb1:	50                   	push   %eax
  801eb2:	68 20 27 80 00       	push   $0x802720
  801eb7:	e8 97 e2 ff ff       	call   800153 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ebc:	83 c4 18             	add    $0x18,%esp
  801ebf:	53                   	push   %ebx
  801ec0:	ff 75 10             	pushl  0x10(%ebp)
  801ec3:	e8 3a e2 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801ec8:	c7 04 24 d3 26 80 00 	movl   $0x8026d3,(%esp)
  801ecf:	e8 7f e2 ff ff       	call   800153 <cprintf>
  801ed4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ed7:	cc                   	int3   
  801ed8:	eb fd                	jmp    801ed7 <_panic+0x43>

00801eda <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	56                   	push   %esi
  801ede:	53                   	push   %ebx
  801edf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	74 4f                	je     801f3b <ipc_recv+0x61>
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	50                   	push   %eax
  801ef0:	e8 dc ed ff ff       	call   800cd1 <sys_ipc_recv>
  801ef5:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ef8:	85 f6                	test   %esi,%esi
  801efa:	74 14                	je     801f10 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801efc:	ba 00 00 00 00       	mov    $0x0,%edx
  801f01:	85 c0                	test   %eax,%eax
  801f03:	75 09                	jne    801f0e <ipc_recv+0x34>
  801f05:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0b:	8b 52 74             	mov    0x74(%edx),%edx
  801f0e:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f10:	85 db                	test   %ebx,%ebx
  801f12:	74 14                	je     801f28 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f14:	ba 00 00 00 00       	mov    $0x0,%edx
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	75 09                	jne    801f26 <ipc_recv+0x4c>
  801f1d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f23:	8b 52 78             	mov    0x78(%edx),%edx
  801f26:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	75 08                	jne    801f34 <ipc_recv+0x5a>
  801f2c:	a1 08 40 80 00       	mov    0x804008,%eax
  801f31:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	68 00 00 c0 ee       	push   $0xeec00000
  801f43:	e8 89 ed ff ff       	call   800cd1 <sys_ipc_recv>
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	eb ab                	jmp    801ef8 <ipc_recv+0x1e>

00801f4d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	57                   	push   %edi
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f59:	8b 75 10             	mov    0x10(%ebp),%esi
  801f5c:	eb 20                	jmp    801f7e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f5e:	6a 00                	push   $0x0
  801f60:	68 00 00 c0 ee       	push   $0xeec00000
  801f65:	ff 75 0c             	pushl  0xc(%ebp)
  801f68:	57                   	push   %edi
  801f69:	e8 40 ed ff ff       	call   800cae <sys_ipc_try_send>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	eb 1f                	jmp    801f94 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f75:	e8 88 eb ff ff       	call   800b02 <sys_yield>
	while(retval != 0) {
  801f7a:	85 db                	test   %ebx,%ebx
  801f7c:	74 33                	je     801fb1 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f7e:	85 f6                	test   %esi,%esi
  801f80:	74 dc                	je     801f5e <ipc_send+0x11>
  801f82:	ff 75 14             	pushl  0x14(%ebp)
  801f85:	56                   	push   %esi
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	57                   	push   %edi
  801f8a:	e8 1f ed ff ff       	call   800cae <sys_ipc_try_send>
  801f8f:	89 c3                	mov    %eax,%ebx
  801f91:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f94:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f97:	74 dc                	je     801f75 <ipc_send+0x28>
  801f99:	85 db                	test   %ebx,%ebx
  801f9b:	74 d8                	je     801f75 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 44 27 80 00       	push   $0x802744
  801fa5:	6a 35                	push   $0x35
  801fa7:	68 74 27 80 00       	push   $0x802774
  801fac:	e8 e3 fe ff ff       	call   801e94 <_panic>
	}
}
  801fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	5f                   	pop    %edi
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fc4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fc7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fcd:	8b 52 50             	mov    0x50(%edx),%edx
  801fd0:	39 ca                	cmp    %ecx,%edx
  801fd2:	74 11                	je     801fe5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fd4:	83 c0 01             	add    $0x1,%eax
  801fd7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fdc:	75 e6                	jne    801fc4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	eb 0b                	jmp    801ff0 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fe5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fe8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fed:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ff8:	89 d0                	mov    %edx,%eax
  801ffa:	c1 e8 16             	shr    $0x16,%eax
  801ffd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802009:	f6 c1 01             	test   $0x1,%cl
  80200c:	74 1d                	je     80202b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80200e:	c1 ea 0c             	shr    $0xc,%edx
  802011:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802018:	f6 c2 01             	test   $0x1,%dl
  80201b:	74 0e                	je     80202b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80201d:	c1 ea 0c             	shr    $0xc,%edx
  802020:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802027:	ef 
  802028:	0f b7 c0             	movzwl %ax,%eax
}
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    
  80202d:	66 90                	xchg   %ax,%ax
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
