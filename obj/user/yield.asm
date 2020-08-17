
obj/user/yield.debug：     文件格式 elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 c0 22 80 00       	push   $0x8022c0
  800048:	e8 42 01 00 00       	call   80018f <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 e4 0a 00 00       	call   800b3e <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 e0 22 80 00       	push   $0x8022e0
  80006c:	e8 1e 01 00 00       	call   80018f <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 0c 23 80 00       	push   $0x80230c
  80008d:	e8 fd 00 00 00       	call   80018f <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 75 0a 00 00       	call   800b1f <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e6:	e8 5a 0e 00 00       	call   800f45 <close_all>
	sys_env_destroy(0);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 e9 09 00 00       	call   800ade <sys_env_destroy>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	c9                   	leave  
  8000f9:	c3                   	ret    

008000fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800104:	8b 13                	mov    (%ebx),%edx
  800106:	8d 42 01             	lea    0x1(%edx),%eax
  800109:	89 03                	mov    %eax,(%ebx)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800112:	3d ff 00 00 00       	cmp    $0xff,%eax
  800117:	74 09                	je     800122 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 6e 09 00 00       	call   800aa1 <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb db                	jmp    800119 <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fa 00 80 00       	push   $0x8000fa
  80016d:	e8 19 01 00 00       	call   80028b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 1a 09 00 00       	call   800aa1 <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ca:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001cd:	89 d0                	mov    %edx,%eax
  8001cf:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001d5:	73 15                	jae    8001ec <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001d7:	83 eb 01             	sub    $0x1,%ebx
  8001da:	85 db                	test   %ebx,%ebx
  8001dc:	7e 43                	jle    800221 <printnum+0x7e>
			putch(padc, putdat);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	56                   	push   %esi
  8001e2:	ff 75 18             	pushl  0x18(%ebp)
  8001e5:	ff d7                	call   *%edi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb eb                	jmp    8001d7 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 18             	pushl  0x18(%ebp)
  8001f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	ff 75 10             	pushl  0x10(%ebp)
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	ff 75 e0             	pushl  -0x20(%ebp)
  800205:	ff 75 dc             	pushl  -0x24(%ebp)
  800208:	ff 75 d8             	pushl  -0x28(%ebp)
  80020b:	e8 60 1e 00 00       	call   802070 <__udivdi3>
  800210:	83 c4 18             	add    $0x18,%esp
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	89 f2                	mov    %esi,%edx
  800217:	89 f8                	mov    %edi,%eax
  800219:	e8 85 ff ff ff       	call   8001a3 <printnum>
  80021e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	56                   	push   %esi
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022b:	ff 75 e0             	pushl  -0x20(%ebp)
  80022e:	ff 75 dc             	pushl  -0x24(%ebp)
  800231:	ff 75 d8             	pushl  -0x28(%ebp)
  800234:	e8 47 1f 00 00       	call   802180 <__umoddi3>
  800239:	83 c4 14             	add    $0x14,%esp
  80023c:	0f be 80 35 23 80 00 	movsbl 0x802335(%eax),%eax
  800243:	50                   	push   %eax
  800244:	ff d7                	call   *%edi
}
  800246:	83 c4 10             	add    $0x10,%esp
  800249:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024c:	5b                   	pop    %ebx
  80024d:	5e                   	pop    %esi
  80024e:	5f                   	pop    %edi
  80024f:	5d                   	pop    %ebp
  800250:	c3                   	ret    

00800251 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800257:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025b:	8b 10                	mov    (%eax),%edx
  80025d:	3b 50 04             	cmp    0x4(%eax),%edx
  800260:	73 0a                	jae    80026c <sprintputch+0x1b>
		*b->buf++ = ch;
  800262:	8d 4a 01             	lea    0x1(%edx),%ecx
  800265:	89 08                	mov    %ecx,(%eax)
  800267:	8b 45 08             	mov    0x8(%ebp),%eax
  80026a:	88 02                	mov    %al,(%edx)
}
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    

0080026e <printfmt>:
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800274:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800277:	50                   	push   %eax
  800278:	ff 75 10             	pushl  0x10(%ebp)
  80027b:	ff 75 0c             	pushl  0xc(%ebp)
  80027e:	ff 75 08             	pushl  0x8(%ebp)
  800281:	e8 05 00 00 00       	call   80028b <vprintfmt>
}
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <vprintfmt>:
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	83 ec 3c             	sub    $0x3c,%esp
  800294:	8b 75 08             	mov    0x8(%ebp),%esi
  800297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029d:	eb 0a                	jmp    8002a9 <vprintfmt+0x1e>
			putch(ch, putdat);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	53                   	push   %ebx
  8002a3:	50                   	push   %eax
  8002a4:	ff d6                	call   *%esi
  8002a6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002a9:	83 c7 01             	add    $0x1,%edi
  8002ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002b0:	83 f8 25             	cmp    $0x25,%eax
  8002b3:	74 0c                	je     8002c1 <vprintfmt+0x36>
			if (ch == '\0')
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	75 e6                	jne    80029f <vprintfmt+0x14>
}
  8002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    
		padc = ' ';
  8002c1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8d 47 01             	lea    0x1(%edi),%eax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e5:	0f b6 17             	movzbl (%edi),%edx
  8002e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002eb:	3c 55                	cmp    $0x55,%al
  8002ed:	0f 87 ba 03 00 00    	ja     8006ad <vprintfmt+0x422>
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800300:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800304:	eb d9                	jmp    8002df <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800309:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80030d:	eb d0                	jmp    8002df <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	0f b6 d2             	movzbl %dl,%edx
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800315:	b8 00 00 00 00       	mov    $0x0,%eax
  80031a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800320:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800324:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800327:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032a:	83 f9 09             	cmp    $0x9,%ecx
  80032d:	77 55                	ja     800384 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80032f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800332:	eb e9                	jmp    80031d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800334:	8b 45 14             	mov    0x14(%ebp),%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8d 40 04             	lea    0x4(%eax),%eax
  800342:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800345:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034c:	79 91                	jns    8002df <vprintfmt+0x54>
				width = precision, precision = -1;
  80034e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035b:	eb 82                	jmp    8002df <vprintfmt+0x54>
  80035d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800360:	85 c0                	test   %eax,%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	0f 49 d0             	cmovns %eax,%edx
  80036a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800370:	e9 6a ff ff ff       	jmp    8002df <vprintfmt+0x54>
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800378:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80037f:	e9 5b ff ff ff       	jmp    8002df <vprintfmt+0x54>
  800384:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800387:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038a:	eb bc                	jmp    800348 <vprintfmt+0xbd>
			lflag++;
  80038c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800392:	e9 48 ff ff ff       	jmp    8002df <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	53                   	push   %ebx
  8003a1:	ff 30                	pushl  (%eax)
  8003a3:	ff d6                	call   *%esi
			break;
  8003a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ab:	e9 9c 02 00 00       	jmp    80064c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	99                   	cltd   
  8003b9:	31 d0                	xor    %edx,%eax
  8003bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bd:	83 f8 0f             	cmp    $0xf,%eax
  8003c0:	7f 23                	jg     8003e5 <vprintfmt+0x15a>
  8003c2:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003cd:	52                   	push   %edx
  8003ce:	68 1a 27 80 00       	push   $0x80271a
  8003d3:	53                   	push   %ebx
  8003d4:	56                   	push   %esi
  8003d5:	e8 94 fe ff ff       	call   80026e <printfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e0:	e9 67 02 00 00       	jmp    80064c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	50                   	push   %eax
  8003e6:	68 4d 23 80 00       	push   $0x80234d
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 7c fe ff ff       	call   80026e <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 4f 02 00 00       	jmp    80064c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80040b:	85 d2                	test   %edx,%edx
  80040d:	b8 46 23 80 00       	mov    $0x802346,%eax
  800412:	0f 45 c2             	cmovne %edx,%eax
  800415:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800418:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041c:	7e 06                	jle    800424 <vprintfmt+0x199>
  80041e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800422:	75 0d                	jne    800431 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800424:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800427:	89 c7                	mov    %eax,%edi
  800429:	03 45 e0             	add    -0x20(%ebp),%eax
  80042c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042f:	eb 3f                	jmp    800470 <vprintfmt+0x1e5>
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	50                   	push   %eax
  800438:	e8 0d 03 00 00       	call   80074a <strnlen>
  80043d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800440:	29 c2                	sub    %eax,%edx
  800442:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80044a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800451:	85 ff                	test   %edi,%edi
  800453:	7e 58                	jle    8004ad <vprintfmt+0x222>
					putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ef 01             	sub    $0x1,%edi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	eb eb                	jmp    800451 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	53                   	push   %ebx
  80046a:	52                   	push   %edx
  80046b:	ff d6                	call   *%esi
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800473:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800475:	83 c7 01             	add    $0x1,%edi
  800478:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047c:	0f be d0             	movsbl %al,%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	74 45                	je     8004c8 <vprintfmt+0x23d>
  800483:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800487:	78 06                	js     80048f <vprintfmt+0x204>
  800489:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048d:	78 35                	js     8004c4 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80048f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800493:	74 d1                	je     800466 <vprintfmt+0x1db>
  800495:	0f be c0             	movsbl %al,%eax
  800498:	83 e8 20             	sub    $0x20,%eax
  80049b:	83 f8 5e             	cmp    $0x5e,%eax
  80049e:	76 c6                	jbe    800466 <vprintfmt+0x1db>
					putch('?', putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	6a 3f                	push   $0x3f
  8004a6:	ff d6                	call   *%esi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	eb c3                	jmp    800470 <vprintfmt+0x1e5>
  8004ad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	0f 49 c2             	cmovns %edx,%eax
  8004ba:	29 c2                	sub    %eax,%edx
  8004bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004bf:	e9 60 ff ff ff       	jmp    800424 <vprintfmt+0x199>
  8004c4:	89 cf                	mov    %ecx,%edi
  8004c6:	eb 02                	jmp    8004ca <vprintfmt+0x23f>
  8004c8:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004ca:	85 ff                	test   %edi,%edi
  8004cc:	7e 10                	jle    8004de <vprintfmt+0x253>
				putch(' ', putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	6a 20                	push   $0x20
  8004d4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d6:	83 ef 01             	sub    $0x1,%edi
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	eb ec                	jmp    8004ca <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e4:	e9 63 01 00 00       	jmp    80064c <vprintfmt+0x3c1>
	if (lflag >= 2)
  8004e9:	83 f9 01             	cmp    $0x1,%ecx
  8004ec:	7f 1b                	jg     800509 <vprintfmt+0x27e>
	else if (lflag)
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	74 63                	je     800555 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	99                   	cltd   
  8004fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 40 04             	lea    0x4(%eax),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
  800507:	eb 17                	jmp    800520 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 50 04             	mov    0x4(%eax),%edx
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800514:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 40 08             	lea    0x8(%eax),%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800520:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800523:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800526:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80052b:	85 c9                	test   %ecx,%ecx
  80052d:	0f 89 ff 00 00 00    	jns    800632 <vprintfmt+0x3a7>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800541:	f7 da                	neg    %edx
  800543:	83 d1 00             	adc    $0x0,%ecx
  800546:	f7 d9                	neg    %ecx
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 dd 00 00 00       	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	99                   	cltd   
  80055e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8d 40 04             	lea    0x4(%eax),%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	eb b4                	jmp    800520 <vprintfmt+0x295>
	if (lflag >= 2)
  80056c:	83 f9 01             	cmp    $0x1,%ecx
  80056f:	7f 1e                	jg     80058f <vprintfmt+0x304>
	else if (lflag)
  800571:	85 c9                	test   %ecx,%ecx
  800573:	74 32                	je     8005a7 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058a:	e9 a3 00 00 00       	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 10                	mov    (%eax),%edx
  800594:	8b 48 04             	mov    0x4(%eax),%ecx
  800597:	8d 40 08             	lea    0x8(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a2:	e9 8b 00 00 00       	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bc:	eb 74                	jmp    800632 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005be:	83 f9 01             	cmp    $0x1,%ecx
  8005c1:	7f 1b                	jg     8005de <vprintfmt+0x353>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	74 2c                	je     8005f3 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 10                	mov    (%eax),%edx
  8005cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005dc:	eb 54                	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e6:	8d 40 08             	lea    0x8(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f1:	eb 3f                	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800603:	b8 08 00 00 00       	mov    $0x8,%eax
  800608:	eb 28                	jmp    800632 <vprintfmt+0x3a7>
			putch('0', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 30                	push   $0x30
  800610:	ff d6                	call   *%esi
			putch('x', putdat);
  800612:	83 c4 08             	add    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 78                	push   $0x78
  800618:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800624:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800639:	57                   	push   %edi
  80063a:	ff 75 e0             	pushl  -0x20(%ebp)
  80063d:	50                   	push   %eax
  80063e:	51                   	push   %ecx
  80063f:	52                   	push   %edx
  800640:	89 da                	mov    %ebx,%edx
  800642:	89 f0                	mov    %esi,%eax
  800644:	e8 5a fb ff ff       	call   8001a3 <printnum>
			break;
  800649:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	e9 55 fc ff ff       	jmp    8002a9 <vprintfmt+0x1e>
	if (lflag >= 2)
  800654:	83 f9 01             	cmp    $0x1,%ecx
  800657:	7f 1b                	jg     800674 <vprintfmt+0x3e9>
	else if (lflag)
  800659:	85 c9                	test   %ecx,%ecx
  80065b:	74 2c                	je     800689 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 10                	mov    (%eax),%edx
  800662:	b9 00 00 00 00       	mov    $0x0,%ecx
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066d:	b8 10 00 00 00       	mov    $0x10,%eax
  800672:	eb be                	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 10                	mov    (%eax),%edx
  800679:	8b 48 04             	mov    0x4(%eax),%ecx
  80067c:	8d 40 08             	lea    0x8(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800682:	b8 10 00 00 00       	mov    $0x10,%eax
  800687:	eb a9                	jmp    800632 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
  80068e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800693:	8d 40 04             	lea    0x4(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800699:	b8 10 00 00 00       	mov    $0x10,%eax
  80069e:	eb 92                	jmp    800632 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 25                	push   $0x25
  8006a6:	ff d6                	call   *%esi
			break;
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	eb 9f                	jmp    80064c <vprintfmt+0x3c1>
			putch('%', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 25                	push   $0x25
  8006b3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	89 f8                	mov    %edi,%eax
  8006ba:	eb 03                	jmp    8006bf <vprintfmt+0x434>
  8006bc:	83 e8 01             	sub    $0x1,%eax
  8006bf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c3:	75 f7                	jne    8006bc <vprintfmt+0x431>
  8006c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c8:	eb 82                	jmp    80064c <vprintfmt+0x3c1>

008006ca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 18             	sub    $0x18,%esp
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006dd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e7:	85 c0                	test   %eax,%eax
  8006e9:	74 26                	je     800711 <vsnprintf+0x47>
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	7e 22                	jle    800711 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ef:	ff 75 14             	pushl  0x14(%ebp)
  8006f2:	ff 75 10             	pushl  0x10(%ebp)
  8006f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	68 51 02 80 00       	push   $0x800251
  8006fe:	e8 88 fb ff ff       	call   80028b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800706:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070c:	83 c4 10             	add    $0x10,%esp
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    
		return -E_INVAL;
  800711:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800716:	eb f7                	jmp    80070f <vsnprintf+0x45>

00800718 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800721:	50                   	push   %eax
  800722:	ff 75 10             	pushl  0x10(%ebp)
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	ff 75 08             	pushl  0x8(%ebp)
  80072b:	e8 9a ff ff ff       	call   8006ca <vsnprintf>
	va_end(ap);

	return rc;
}
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800741:	74 05                	je     800748 <strlen+0x16>
		n++;
  800743:	83 c0 01             	add    $0x1,%eax
  800746:	eb f5                	jmp    80073d <strlen+0xb>
	return n;
}
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	39 c2                	cmp    %eax,%edx
  80075a:	74 0d                	je     800769 <strnlen+0x1f>
  80075c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800760:	74 05                	je     800767 <strnlen+0x1d>
		n++;
  800762:	83 c2 01             	add    $0x1,%edx
  800765:	eb f1                	jmp    800758 <strnlen+0xe>
  800767:	89 d0                	mov    %edx,%eax
	return n;
}
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	53                   	push   %ebx
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80077e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800781:	83 c2 01             	add    $0x1,%edx
  800784:	84 c9                	test   %cl,%cl
  800786:	75 f2                	jne    80077a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800788:	5b                   	pop    %ebx
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	83 ec 10             	sub    $0x10,%esp
  800792:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800795:	53                   	push   %ebx
  800796:	e8 97 ff ff ff       	call   800732 <strlen>
  80079b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	01 d8                	add    %ebx,%eax
  8007a3:	50                   	push   %eax
  8007a4:	e8 c2 ff ff ff       	call   80076b <strcpy>
	return dst;
}
  8007a9:	89 d8                	mov    %ebx,%eax
  8007ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	56                   	push   %esi
  8007b4:	53                   	push   %ebx
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007bb:	89 c6                	mov    %eax,%esi
  8007bd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	39 f2                	cmp    %esi,%edx
  8007c4:	74 11                	je     8007d7 <strncpy+0x27>
		*dst++ = *src;
  8007c6:	83 c2 01             	add    $0x1,%edx
  8007c9:	0f b6 19             	movzbl (%ecx),%ebx
  8007cc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007cf:	80 fb 01             	cmp    $0x1,%bl
  8007d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007d5:	eb eb                	jmp    8007c2 <strncpy+0x12>
	}
	return ret;
}
  8007d7:	5b                   	pop    %ebx
  8007d8:	5e                   	pop    %esi
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	56                   	push   %esi
  8007df:	53                   	push   %ebx
  8007e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	74 21                	je     800810 <strlcpy+0x35>
  8007ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 14                	je     80080d <strlcpy+0x32>
  8007f9:	0f b6 19             	movzbl (%ecx),%ebx
  8007fc:	84 db                	test   %bl,%bl
  8007fe:	74 0b                	je     80080b <strlcpy+0x30>
			*dst++ = *src++;
  800800:	83 c1 01             	add    $0x1,%ecx
  800803:	83 c2 01             	add    $0x1,%edx
  800806:	88 5a ff             	mov    %bl,-0x1(%edx)
  800809:	eb ea                	jmp    8007f5 <strlcpy+0x1a>
  80080b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80080d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800810:	29 f0                	sub    %esi,%eax
}
  800812:	5b                   	pop    %ebx
  800813:	5e                   	pop    %esi
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80081f:	0f b6 01             	movzbl (%ecx),%eax
  800822:	84 c0                	test   %al,%al
  800824:	74 0c                	je     800832 <strcmp+0x1c>
  800826:	3a 02                	cmp    (%edx),%al
  800828:	75 08                	jne    800832 <strcmp+0x1c>
		p++, q++;
  80082a:	83 c1 01             	add    $0x1,%ecx
  80082d:	83 c2 01             	add    $0x1,%edx
  800830:	eb ed                	jmp    80081f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800832:	0f b6 c0             	movzbl %al,%eax
  800835:	0f b6 12             	movzbl (%edx),%edx
  800838:	29 d0                	sub    %edx,%eax
}
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	53                   	push   %ebx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
  800846:	89 c3                	mov    %eax,%ebx
  800848:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80084b:	eb 06                	jmp    800853 <strncmp+0x17>
		n--, p++, q++;
  80084d:	83 c0 01             	add    $0x1,%eax
  800850:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800853:	39 d8                	cmp    %ebx,%eax
  800855:	74 16                	je     80086d <strncmp+0x31>
  800857:	0f b6 08             	movzbl (%eax),%ecx
  80085a:	84 c9                	test   %cl,%cl
  80085c:	74 04                	je     800862 <strncmp+0x26>
  80085e:	3a 0a                	cmp    (%edx),%cl
  800860:	74 eb                	je     80084d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800862:	0f b6 00             	movzbl (%eax),%eax
  800865:	0f b6 12             	movzbl (%edx),%edx
  800868:	29 d0                	sub    %edx,%eax
}
  80086a:	5b                   	pop    %ebx
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    
		return 0;
  80086d:	b8 00 00 00 00       	mov    $0x0,%eax
  800872:	eb f6                	jmp    80086a <strncmp+0x2e>

00800874 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80087e:	0f b6 10             	movzbl (%eax),%edx
  800881:	84 d2                	test   %dl,%dl
  800883:	74 09                	je     80088e <strchr+0x1a>
		if (*s == c)
  800885:	38 ca                	cmp    %cl,%dl
  800887:	74 0a                	je     800893 <strchr+0x1f>
	for (; *s; s++)
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	eb f0                	jmp    80087e <strchr+0xa>
			return (char *) s;
	return 0;
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80089f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008a2:	38 ca                	cmp    %cl,%dl
  8008a4:	74 09                	je     8008af <strfind+0x1a>
  8008a6:	84 d2                	test   %dl,%dl
  8008a8:	74 05                	je     8008af <strfind+0x1a>
	for (; *s; s++)
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	eb f0                	jmp    80089f <strfind+0xa>
			break;
	return (char *) s;
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	57                   	push   %edi
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008bd:	85 c9                	test   %ecx,%ecx
  8008bf:	74 31                	je     8008f2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008c1:	89 f8                	mov    %edi,%eax
  8008c3:	09 c8                	or     %ecx,%eax
  8008c5:	a8 03                	test   $0x3,%al
  8008c7:	75 23                	jne    8008ec <memset+0x3b>
		c &= 0xFF;
  8008c9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008cd:	89 d3                	mov    %edx,%ebx
  8008cf:	c1 e3 08             	shl    $0x8,%ebx
  8008d2:	89 d0                	mov    %edx,%eax
  8008d4:	c1 e0 18             	shl    $0x18,%eax
  8008d7:	89 d6                	mov    %edx,%esi
  8008d9:	c1 e6 10             	shl    $0x10,%esi
  8008dc:	09 f0                	or     %esi,%eax
  8008de:	09 c2                	or     %eax,%edx
  8008e0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008e2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008e5:	89 d0                	mov    %edx,%eax
  8008e7:	fc                   	cld    
  8008e8:	f3 ab                	rep stos %eax,%es:(%edi)
  8008ea:	eb 06                	jmp    8008f2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	fc                   	cld    
  8008f0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008f2:	89 f8                	mov    %edi,%eax
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5f                   	pop    %edi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	57                   	push   %edi
  8008fd:	56                   	push   %esi
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 75 0c             	mov    0xc(%ebp),%esi
  800904:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800907:	39 c6                	cmp    %eax,%esi
  800909:	73 32                	jae    80093d <memmove+0x44>
  80090b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80090e:	39 c2                	cmp    %eax,%edx
  800910:	76 2b                	jbe    80093d <memmove+0x44>
		s += n;
		d += n;
  800912:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800915:	89 fe                	mov    %edi,%esi
  800917:	09 ce                	or     %ecx,%esi
  800919:	09 d6                	or     %edx,%esi
  80091b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800921:	75 0e                	jne    800931 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800923:	83 ef 04             	sub    $0x4,%edi
  800926:	8d 72 fc             	lea    -0x4(%edx),%esi
  800929:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80092c:	fd                   	std    
  80092d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80092f:	eb 09                	jmp    80093a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800931:	83 ef 01             	sub    $0x1,%edi
  800934:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800937:	fd                   	std    
  800938:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80093a:	fc                   	cld    
  80093b:	eb 1a                	jmp    800957 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	09 ca                	or     %ecx,%edx
  800941:	09 f2                	or     %esi,%edx
  800943:	f6 c2 03             	test   $0x3,%dl
  800946:	75 0a                	jne    800952 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800948:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80094b:	89 c7                	mov    %eax,%edi
  80094d:	fc                   	cld    
  80094e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800950:	eb 05                	jmp    800957 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800952:	89 c7                	mov    %eax,%edi
  800954:	fc                   	cld    
  800955:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800961:	ff 75 10             	pushl  0x10(%ebp)
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	e8 8a ff ff ff       	call   8008f9 <memmove>
}
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	56                   	push   %esi
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 c6                	mov    %eax,%esi
  80097e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800981:	39 f0                	cmp    %esi,%eax
  800983:	74 1c                	je     8009a1 <memcmp+0x30>
		if (*s1 != *s2)
  800985:	0f b6 08             	movzbl (%eax),%ecx
  800988:	0f b6 1a             	movzbl (%edx),%ebx
  80098b:	38 d9                	cmp    %bl,%cl
  80098d:	75 08                	jne    800997 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	83 c2 01             	add    $0x1,%edx
  800995:	eb ea                	jmp    800981 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800997:	0f b6 c1             	movzbl %cl,%eax
  80099a:	0f b6 db             	movzbl %bl,%ebx
  80099d:	29 d8                	sub    %ebx,%eax
  80099f:	eb 05                	jmp    8009a6 <memcmp+0x35>
	}

	return 0;
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5e                   	pop    %esi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009b3:	89 c2                	mov    %eax,%edx
  8009b5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009b8:	39 d0                	cmp    %edx,%eax
  8009ba:	73 09                	jae    8009c5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009bc:	38 08                	cmp    %cl,(%eax)
  8009be:	74 05                	je     8009c5 <memfind+0x1b>
	for (; s < ends; s++)
  8009c0:	83 c0 01             	add    $0x1,%eax
  8009c3:	eb f3                	jmp    8009b8 <memfind+0xe>
			break;
	return (void *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009d3:	eb 03                	jmp    8009d8 <strtol+0x11>
		s++;
  8009d5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009d8:	0f b6 01             	movzbl (%ecx),%eax
  8009db:	3c 20                	cmp    $0x20,%al
  8009dd:	74 f6                	je     8009d5 <strtol+0xe>
  8009df:	3c 09                	cmp    $0x9,%al
  8009e1:	74 f2                	je     8009d5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009e3:	3c 2b                	cmp    $0x2b,%al
  8009e5:	74 2a                	je     800a11 <strtol+0x4a>
	int neg = 0;
  8009e7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009ec:	3c 2d                	cmp    $0x2d,%al
  8009ee:	74 2b                	je     800a1b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009f6:	75 0f                	jne    800a07 <strtol+0x40>
  8009f8:	80 39 30             	cmpb   $0x30,(%ecx)
  8009fb:	74 28                	je     800a25 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009fd:	85 db                	test   %ebx,%ebx
  8009ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a04:	0f 44 d8             	cmove  %eax,%ebx
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a0f:	eb 50                	jmp    800a61 <strtol+0x9a>
		s++;
  800a11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a14:	bf 00 00 00 00       	mov    $0x0,%edi
  800a19:	eb d5                	jmp    8009f0 <strtol+0x29>
		s++, neg = 1;
  800a1b:	83 c1 01             	add    $0x1,%ecx
  800a1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a23:	eb cb                	jmp    8009f0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a29:	74 0e                	je     800a39 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	75 d8                	jne    800a07 <strtol+0x40>
		s++, base = 8;
  800a2f:	83 c1 01             	add    $0x1,%ecx
  800a32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a37:	eb ce                	jmp    800a07 <strtol+0x40>
		s += 2, base = 16;
  800a39:	83 c1 02             	add    $0x2,%ecx
  800a3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a41:	eb c4                	jmp    800a07 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a43:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a46:	89 f3                	mov    %esi,%ebx
  800a48:	80 fb 19             	cmp    $0x19,%bl
  800a4b:	77 29                	ja     800a76 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a4d:	0f be d2             	movsbl %dl,%edx
  800a50:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a56:	7d 30                	jge    800a88 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a58:	83 c1 01             	add    $0x1,%ecx
  800a5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a61:	0f b6 11             	movzbl (%ecx),%edx
  800a64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a67:	89 f3                	mov    %esi,%ebx
  800a69:	80 fb 09             	cmp    $0x9,%bl
  800a6c:	77 d5                	ja     800a43 <strtol+0x7c>
			dig = *s - '0';
  800a6e:	0f be d2             	movsbl %dl,%edx
  800a71:	83 ea 30             	sub    $0x30,%edx
  800a74:	eb dd                	jmp    800a53 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a79:	89 f3                	mov    %esi,%ebx
  800a7b:	80 fb 19             	cmp    $0x19,%bl
  800a7e:	77 08                	ja     800a88 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a80:	0f be d2             	movsbl %dl,%edx
  800a83:	83 ea 37             	sub    $0x37,%edx
  800a86:	eb cb                	jmp    800a53 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8c:	74 05                	je     800a93 <strtol+0xcc>
		*endptr = (char *) s;
  800a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a93:	89 c2                	mov    %eax,%edx
  800a95:	f7 da                	neg    %edx
  800a97:	85 ff                	test   %edi,%edi
  800a99:	0f 45 c2             	cmovne %edx,%eax
}
  800a9c:	5b                   	pop    %ebx
  800a9d:	5e                   	pop    %esi
  800a9e:	5f                   	pop    %edi
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	57                   	push   %edi
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	8b 55 08             	mov    0x8(%ebp),%edx
  800aaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab2:	89 c3                	mov    %eax,%ebx
  800ab4:	89 c7                	mov    %eax,%edi
  800ab6:	89 c6                	mov    %eax,%esi
  800ab8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5f                   	pop    %edi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <sys_cgetc>:

int
sys_cgetc(void)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	57                   	push   %edi
  800ac3:	56                   	push   %esi
  800ac4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	b8 01 00 00 00       	mov    $0x1,%eax
  800acf:	89 d1                	mov    %edx,%ecx
  800ad1:	89 d3                	mov    %edx,%ebx
  800ad3:	89 d7                	mov    %edx,%edi
  800ad5:	89 d6                	mov    %edx,%esi
  800ad7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	57                   	push   %edi
  800ae2:	56                   	push   %esi
  800ae3:	53                   	push   %ebx
  800ae4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ae7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aec:	8b 55 08             	mov    0x8(%ebp),%edx
  800aef:	b8 03 00 00 00       	mov    $0x3,%eax
  800af4:	89 cb                	mov    %ecx,%ebx
  800af6:	89 cf                	mov    %ecx,%edi
  800af8:	89 ce                	mov    %ecx,%esi
  800afa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800afc:	85 c0                	test   %eax,%eax
  800afe:	7f 08                	jg     800b08 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	6a 03                	push   $0x3
  800b0e:	68 3f 26 80 00       	push   $0x80263f
  800b13:	6a 23                	push   $0x23
  800b15:	68 5c 26 80 00       	push   $0x80265c
  800b1a:	e8 b1 13 00 00       	call   801ed0 <_panic>

00800b1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	57                   	push   %edi
  800b23:	56                   	push   %esi
  800b24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2f:	89 d1                	mov    %edx,%ecx
  800b31:	89 d3                	mov    %edx,%ebx
  800b33:	89 d7                	mov    %edx,%edi
  800b35:	89 d6                	mov    %edx,%esi
  800b37:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <sys_yield>:

void
sys_yield(void)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b4e:	89 d1                	mov    %edx,%ecx
  800b50:	89 d3                	mov    %edx,%ebx
  800b52:	89 d7                	mov    %edx,%edi
  800b54:	89 d6                	mov    %edx,%esi
  800b56:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5f                   	pop    %edi
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	57                   	push   %edi
  800b61:	56                   	push   %esi
  800b62:	53                   	push   %ebx
  800b63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b66:	be 00 00 00 00       	mov    $0x0,%esi
  800b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b71:	b8 04 00 00 00       	mov    $0x4,%eax
  800b76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b79:	89 f7                	mov    %esi,%edi
  800b7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	7f 08                	jg     800b89 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	50                   	push   %eax
  800b8d:	6a 04                	push   $0x4
  800b8f:	68 3f 26 80 00       	push   $0x80263f
  800b94:	6a 23                	push   $0x23
  800b96:	68 5c 26 80 00       	push   $0x80265c
  800b9b:	e8 30 13 00 00       	call   801ed0 <_panic>

00800ba0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baf:	b8 05 00 00 00       	mov    $0x5,%eax
  800bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bba:	8b 75 18             	mov    0x18(%ebp),%esi
  800bbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	7f 08                	jg     800bcb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	50                   	push   %eax
  800bcf:	6a 05                	push   $0x5
  800bd1:	68 3f 26 80 00       	push   $0x80263f
  800bd6:	6a 23                	push   $0x23
  800bd8:	68 5c 26 80 00       	push   $0x80265c
  800bdd:	e8 ee 12 00 00       	call   801ed0 <_panic>

00800be2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800beb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf6:	b8 06 00 00 00       	mov    $0x6,%eax
  800bfb:	89 df                	mov    %ebx,%edi
  800bfd:	89 de                	mov    %ebx,%esi
  800bff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7f 08                	jg     800c0d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	50                   	push   %eax
  800c11:	6a 06                	push   $0x6
  800c13:	68 3f 26 80 00       	push   $0x80263f
  800c18:	6a 23                	push   $0x23
  800c1a:	68 5c 26 80 00       	push   $0x80265c
  800c1f:	e8 ac 12 00 00       	call   801ed0 <_panic>

00800c24 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c32:	8b 55 08             	mov    0x8(%ebp),%edx
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c38:	b8 08 00 00 00       	mov    $0x8,%eax
  800c3d:	89 df                	mov    %ebx,%edi
  800c3f:	89 de                	mov    %ebx,%esi
  800c41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c43:	85 c0                	test   %eax,%eax
  800c45:	7f 08                	jg     800c4f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	50                   	push   %eax
  800c53:	6a 08                	push   $0x8
  800c55:	68 3f 26 80 00       	push   $0x80263f
  800c5a:	6a 23                	push   $0x23
  800c5c:	68 5c 26 80 00       	push   $0x80265c
  800c61:	e8 6a 12 00 00       	call   801ed0 <_panic>

00800c66 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c7f:	89 df                	mov    %ebx,%edi
  800c81:	89 de                	mov    %ebx,%esi
  800c83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c85:	85 c0                	test   %eax,%eax
  800c87:	7f 08                	jg     800c91 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c91:	83 ec 0c             	sub    $0xc,%esp
  800c94:	50                   	push   %eax
  800c95:	6a 09                	push   $0x9
  800c97:	68 3f 26 80 00       	push   $0x80263f
  800c9c:	6a 23                	push   $0x23
  800c9e:	68 5c 26 80 00       	push   $0x80265c
  800ca3:	e8 28 12 00 00       	call   801ed0 <_panic>

00800ca8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc1:	89 df                	mov    %ebx,%edi
  800cc3:	89 de                	mov    %ebx,%esi
  800cc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7f 08                	jg     800cd3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	50                   	push   %eax
  800cd7:	6a 0a                	push   $0xa
  800cd9:	68 3f 26 80 00       	push   $0x80263f
  800cde:	6a 23                	push   $0x23
  800ce0:	68 5c 26 80 00       	push   $0x80265c
  800ce5:	e8 e6 11 00 00       	call   801ed0 <_panic>

00800cea <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cfb:	be 00 00 00 00       	mov    $0x0,%esi
  800d00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d03:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d06:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d23:	89 cb                	mov    %ecx,%ebx
  800d25:	89 cf                	mov    %ecx,%edi
  800d27:	89 ce                	mov    %ecx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 0d                	push   $0xd
  800d3d:	68 3f 26 80 00       	push   $0x80263f
  800d42:	6a 23                	push   $0x23
  800d44:	68 5c 26 80 00       	push   $0x80265c
  800d49:	e8 82 11 00 00       	call   801ed0 <_panic>

00800d4e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d54:	ba 00 00 00 00       	mov    $0x0,%edx
  800d59:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d5e:	89 d1                	mov    %edx,%ecx
  800d60:	89 d3                	mov    %edx,%ebx
  800d62:	89 d7                	mov    %edx,%edi
  800d64:	89 d6                	mov    %edx,%esi
  800d66:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	05 00 00 00 30       	add    $0x30000000,%eax
  800d78:	c1 e8 0c             	shr    $0xc,%eax
}
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d8d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d9c:	89 c2                	mov    %eax,%edx
  800d9e:	c1 ea 16             	shr    $0x16,%edx
  800da1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800da8:	f6 c2 01             	test   $0x1,%dl
  800dab:	74 2d                	je     800dda <fd_alloc+0x46>
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	c1 ea 0c             	shr    $0xc,%edx
  800db2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800db9:	f6 c2 01             	test   $0x1,%dl
  800dbc:	74 1c                	je     800dda <fd_alloc+0x46>
  800dbe:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dc3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dc8:	75 d2                	jne    800d9c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800dd3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dd8:	eb 0a                	jmp    800de4 <fd_alloc+0x50>
			*fd_store = fd;
  800dda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800dec:	83 f8 1f             	cmp    $0x1f,%eax
  800def:	77 30                	ja     800e21 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800df1:	c1 e0 0c             	shl    $0xc,%eax
  800df4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800df9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800dff:	f6 c2 01             	test   $0x1,%dl
  800e02:	74 24                	je     800e28 <fd_lookup+0x42>
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	c1 ea 0c             	shr    $0xc,%edx
  800e09:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e10:	f6 c2 01             	test   $0x1,%dl
  800e13:	74 1a                	je     800e2f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	89 02                	mov    %eax,(%edx)
	return 0;
  800e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		return -E_INVAL;
  800e21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e26:	eb f7                	jmp    800e1f <fd_lookup+0x39>
		return -E_INVAL;
  800e28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2d:	eb f0                	jmp    800e1f <fd_lookup+0x39>
  800e2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e34:	eb e9                	jmp    800e1f <fd_lookup+0x39>

00800e36 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e49:	39 08                	cmp    %ecx,(%eax)
  800e4b:	74 38                	je     800e85 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800e4d:	83 c2 01             	add    $0x1,%edx
  800e50:	8b 04 95 e8 26 80 00 	mov    0x8026e8(,%edx,4),%eax
  800e57:	85 c0                	test   %eax,%eax
  800e59:	75 ee                	jne    800e49 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e5b:	a1 08 40 80 00       	mov    0x804008,%eax
  800e60:	8b 40 48             	mov    0x48(%eax),%eax
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	51                   	push   %ecx
  800e67:	50                   	push   %eax
  800e68:	68 6c 26 80 00       	push   $0x80266c
  800e6d:	e8 1d f3 ff ff       	call   80018f <cprintf>
	*dev = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    
			*dev = devtab[i];
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8f:	eb f2                	jmp    800e83 <dev_lookup+0x4d>

00800e91 <fd_close>:
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 24             	sub    $0x24,%esp
  800e9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e9d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ea0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ea3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800eaa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ead:	50                   	push   %eax
  800eae:	e8 33 ff ff ff       	call   800de6 <fd_lookup>
  800eb3:	89 c3                	mov    %eax,%ebx
  800eb5:	83 c4 10             	add    $0x10,%esp
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	78 05                	js     800ec1 <fd_close+0x30>
	    || fd != fd2)
  800ebc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ebf:	74 16                	je     800ed7 <fd_close+0x46>
		return (must_exist ? r : 0);
  800ec1:	89 f8                	mov    %edi,%eax
  800ec3:	84 c0                	test   %al,%al
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eca:	0f 44 d8             	cmove  %eax,%ebx
}
  800ecd:	89 d8                	mov    %ebx,%eax
  800ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800edd:	50                   	push   %eax
  800ede:	ff 36                	pushl  (%esi)
  800ee0:	e8 51 ff ff ff       	call   800e36 <dev_lookup>
  800ee5:	89 c3                	mov    %eax,%ebx
  800ee7:	83 c4 10             	add    $0x10,%esp
  800eea:	85 c0                	test   %eax,%eax
  800eec:	78 1a                	js     800f08 <fd_close+0x77>
		if (dev->dev_close)
  800eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	74 0b                	je     800f08 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	56                   	push   %esi
  800f01:	ff d0                	call   *%eax
  800f03:	89 c3                	mov    %eax,%ebx
  800f05:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	56                   	push   %esi
  800f0c:	6a 00                	push   $0x0
  800f0e:	e8 cf fc ff ff       	call   800be2 <sys_page_unmap>
	return r;
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	eb b5                	jmp    800ecd <fd_close+0x3c>

00800f18 <close>:

int
close(int fdnum)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f21:	50                   	push   %eax
  800f22:	ff 75 08             	pushl  0x8(%ebp)
  800f25:	e8 bc fe ff ff       	call   800de6 <fd_lookup>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	79 02                	jns    800f33 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    
		return fd_close(fd, 1);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	6a 01                	push   $0x1
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	e8 51 ff ff ff       	call   800e91 <fd_close>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	eb ec                	jmp    800f31 <close+0x19>

00800f45 <close_all>:

void
close_all(void)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	53                   	push   %ebx
  800f49:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f51:	83 ec 0c             	sub    $0xc,%esp
  800f54:	53                   	push   %ebx
  800f55:	e8 be ff ff ff       	call   800f18 <close>
	for (i = 0; i < MAXFD; i++)
  800f5a:	83 c3 01             	add    $0x1,%ebx
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	83 fb 20             	cmp    $0x20,%ebx
  800f63:	75 ec                	jne    800f51 <close_all+0xc>
}
  800f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f73:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	ff 75 08             	pushl  0x8(%ebp)
  800f7a:	e8 67 fe ff ff       	call   800de6 <fd_lookup>
  800f7f:	89 c3                	mov    %eax,%ebx
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	85 c0                	test   %eax,%eax
  800f86:	0f 88 81 00 00 00    	js     80100d <dup+0xa3>
		return r;
	close(newfdnum);
  800f8c:	83 ec 0c             	sub    $0xc,%esp
  800f8f:	ff 75 0c             	pushl  0xc(%ebp)
  800f92:	e8 81 ff ff ff       	call   800f18 <close>

	newfd = INDEX2FD(newfdnum);
  800f97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f9a:	c1 e6 0c             	shl    $0xc,%esi
  800f9d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fa3:	83 c4 04             	add    $0x4,%esp
  800fa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa9:	e8 cf fd ff ff       	call   800d7d <fd2data>
  800fae:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fb0:	89 34 24             	mov    %esi,(%esp)
  800fb3:	e8 c5 fd ff ff       	call   800d7d <fd2data>
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fbd:	89 d8                	mov    %ebx,%eax
  800fbf:	c1 e8 16             	shr    $0x16,%eax
  800fc2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc9:	a8 01                	test   $0x1,%al
  800fcb:	74 11                	je     800fde <dup+0x74>
  800fcd:	89 d8                	mov    %ebx,%eax
  800fcf:	c1 e8 0c             	shr    $0xc,%eax
  800fd2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fd9:	f6 c2 01             	test   $0x1,%dl
  800fdc:	75 39                	jne    801017 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fe1:	89 d0                	mov    %edx,%eax
  800fe3:	c1 e8 0c             	shr    $0xc,%eax
  800fe6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	25 07 0e 00 00       	and    $0xe07,%eax
  800ff5:	50                   	push   %eax
  800ff6:	56                   	push   %esi
  800ff7:	6a 00                	push   $0x0
  800ff9:	52                   	push   %edx
  800ffa:	6a 00                	push   $0x0
  800ffc:	e8 9f fb ff ff       	call   800ba0 <sys_page_map>
  801001:	89 c3                	mov    %eax,%ebx
  801003:	83 c4 20             	add    $0x20,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	78 31                	js     80103b <dup+0xd1>
		goto err;

	return newfdnum;
  80100a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80100d:	89 d8                	mov    %ebx,%eax
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801017:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	25 07 0e 00 00       	and    $0xe07,%eax
  801026:	50                   	push   %eax
  801027:	57                   	push   %edi
  801028:	6a 00                	push   $0x0
  80102a:	53                   	push   %ebx
  80102b:	6a 00                	push   $0x0
  80102d:	e8 6e fb ff ff       	call   800ba0 <sys_page_map>
  801032:	89 c3                	mov    %eax,%ebx
  801034:	83 c4 20             	add    $0x20,%esp
  801037:	85 c0                	test   %eax,%eax
  801039:	79 a3                	jns    800fde <dup+0x74>
	sys_page_unmap(0, newfd);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	56                   	push   %esi
  80103f:	6a 00                	push   $0x0
  801041:	e8 9c fb ff ff       	call   800be2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801046:	83 c4 08             	add    $0x8,%esp
  801049:	57                   	push   %edi
  80104a:	6a 00                	push   $0x0
  80104c:	e8 91 fb ff ff       	call   800be2 <sys_page_unmap>
	return r;
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	eb b7                	jmp    80100d <dup+0xa3>

00801056 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	53                   	push   %ebx
  80105a:	83 ec 1c             	sub    $0x1c,%esp
  80105d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801060:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801063:	50                   	push   %eax
  801064:	53                   	push   %ebx
  801065:	e8 7c fd ff ff       	call   800de6 <fd_lookup>
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	85 c0                	test   %eax,%eax
  80106f:	78 3f                	js     8010b0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801077:	50                   	push   %eax
  801078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107b:	ff 30                	pushl  (%eax)
  80107d:	e8 b4 fd ff ff       	call   800e36 <dev_lookup>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	85 c0                	test   %eax,%eax
  801087:	78 27                	js     8010b0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801089:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80108c:	8b 42 08             	mov    0x8(%edx),%eax
  80108f:	83 e0 03             	and    $0x3,%eax
  801092:	83 f8 01             	cmp    $0x1,%eax
  801095:	74 1e                	je     8010b5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	8b 40 08             	mov    0x8(%eax),%eax
  80109d:	85 c0                	test   %eax,%eax
  80109f:	74 35                	je     8010d6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010a1:	83 ec 04             	sub    $0x4,%esp
  8010a4:	ff 75 10             	pushl  0x10(%ebp)
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	52                   	push   %edx
  8010ab:	ff d0                	call   *%eax
  8010ad:	83 c4 10             	add    $0x10,%esp
}
  8010b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ba:	8b 40 48             	mov    0x48(%eax),%eax
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	53                   	push   %ebx
  8010c1:	50                   	push   %eax
  8010c2:	68 ad 26 80 00       	push   $0x8026ad
  8010c7:	e8 c3 f0 ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  8010cc:	83 c4 10             	add    $0x10,%esp
  8010cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d4:	eb da                	jmp    8010b0 <read+0x5a>
		return -E_NOT_SUPP;
  8010d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010db:	eb d3                	jmp    8010b0 <read+0x5a>

008010dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	39 f3                	cmp    %esi,%ebx
  8010f3:	73 23                	jae    801118 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	89 f0                	mov    %esi,%eax
  8010fa:	29 d8                	sub    %ebx,%eax
  8010fc:	50                   	push   %eax
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	03 45 0c             	add    0xc(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	57                   	push   %edi
  801104:	e8 4d ff ff ff       	call   801056 <read>
		if (m < 0)
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	78 06                	js     801116 <readn+0x39>
			return m;
		if (m == 0)
  801110:	74 06                	je     801118 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801112:	01 c3                	add    %eax,%ebx
  801114:	eb db                	jmp    8010f1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801116:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801118:	89 d8                	mov    %ebx,%eax
  80111a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5f                   	pop    %edi
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    

00801122 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	53                   	push   %ebx
  801126:	83 ec 1c             	sub    $0x1c,%esp
  801129:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80112c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80112f:	50                   	push   %eax
  801130:	53                   	push   %ebx
  801131:	e8 b0 fc ff ff       	call   800de6 <fd_lookup>
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	78 3a                	js     801177 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801143:	50                   	push   %eax
  801144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801147:	ff 30                	pushl  (%eax)
  801149:	e8 e8 fc ff ff       	call   800e36 <dev_lookup>
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	78 22                	js     801177 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801158:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80115c:	74 1e                	je     80117c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80115e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801161:	8b 52 0c             	mov    0xc(%edx),%edx
  801164:	85 d2                	test   %edx,%edx
  801166:	74 35                	je     80119d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	ff 75 10             	pushl  0x10(%ebp)
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	50                   	push   %eax
  801172:	ff d2                	call   *%edx
  801174:	83 c4 10             	add    $0x10,%esp
}
  801177:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80117c:	a1 08 40 80 00       	mov    0x804008,%eax
  801181:	8b 40 48             	mov    0x48(%eax),%eax
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	53                   	push   %ebx
  801188:	50                   	push   %eax
  801189:	68 c9 26 80 00       	push   $0x8026c9
  80118e:	e8 fc ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119b:	eb da                	jmp    801177 <write+0x55>
		return -E_NOT_SUPP;
  80119d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011a2:	eb d3                	jmp    801177 <write+0x55>

008011a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ad:	50                   	push   %eax
  8011ae:	ff 75 08             	pushl  0x8(%ebp)
  8011b1:	e8 30 fc ff ff       	call   800de6 <fd_lookup>
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 0e                	js     8011cb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	53                   	push   %ebx
  8011d1:	83 ec 1c             	sub    $0x1c,%esp
  8011d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	53                   	push   %ebx
  8011dc:	e8 05 fc ff ff       	call   800de6 <fd_lookup>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 37                	js     80121f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ee:	50                   	push   %eax
  8011ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f2:	ff 30                	pushl  (%eax)
  8011f4:	e8 3d fc ff ff       	call   800e36 <dev_lookup>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 1f                	js     80121f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801203:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801207:	74 1b                	je     801224 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801209:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120c:	8b 52 18             	mov    0x18(%edx),%edx
  80120f:	85 d2                	test   %edx,%edx
  801211:	74 32                	je     801245 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	ff 75 0c             	pushl  0xc(%ebp)
  801219:	50                   	push   %eax
  80121a:	ff d2                	call   *%edx
  80121c:	83 c4 10             	add    $0x10,%esp
}
  80121f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801222:	c9                   	leave  
  801223:	c3                   	ret    
			thisenv->env_id, fdnum);
  801224:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801229:	8b 40 48             	mov    0x48(%eax),%eax
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	53                   	push   %ebx
  801230:	50                   	push   %eax
  801231:	68 8c 26 80 00       	push   $0x80268c
  801236:	e8 54 ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801243:	eb da                	jmp    80121f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801245:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80124a:	eb d3                	jmp    80121f <ftruncate+0x52>

0080124c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	53                   	push   %ebx
  801250:	83 ec 1c             	sub    $0x1c,%esp
  801253:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801256:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	ff 75 08             	pushl  0x8(%ebp)
  80125d:	e8 84 fb ff ff       	call   800de6 <fd_lookup>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	78 4b                	js     8012b4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801269:	83 ec 08             	sub    $0x8,%esp
  80126c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126f:	50                   	push   %eax
  801270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801273:	ff 30                	pushl  (%eax)
  801275:	e8 bc fb ff ff       	call   800e36 <dev_lookup>
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 33                	js     8012b4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801284:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801288:	74 2f                	je     8012b9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80128a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80128d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801294:	00 00 00 
	stat->st_isdir = 0;
  801297:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80129e:	00 00 00 
	stat->st_dev = dev;
  8012a1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	53                   	push   %ebx
  8012ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ae:	ff 50 14             	call   *0x14(%eax)
  8012b1:	83 c4 10             	add    $0x10,%esp
}
  8012b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    
		return -E_NOT_SUPP;
  8012b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012be:	eb f4                	jmp    8012b4 <fstat+0x68>

008012c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	6a 00                	push   $0x0
  8012ca:	ff 75 08             	pushl  0x8(%ebp)
  8012cd:	e8 2f 02 00 00       	call   801501 <open>
  8012d2:	89 c3                	mov    %eax,%ebx
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 1b                	js     8012f6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	50                   	push   %eax
  8012e2:	e8 65 ff ff ff       	call   80124c <fstat>
  8012e7:	89 c6                	mov    %eax,%esi
	close(fd);
  8012e9:	89 1c 24             	mov    %ebx,(%esp)
  8012ec:	e8 27 fc ff ff       	call   800f18 <close>
	return r;
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	89 f3                	mov    %esi,%ebx
}
  8012f6:	89 d8                	mov    %ebx,%eax
  8012f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fb:	5b                   	pop    %ebx
  8012fc:	5e                   	pop    %esi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	89 c6                	mov    %eax,%esi
  801306:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801308:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80130f:	74 27                	je     801338 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801311:	6a 07                	push   $0x7
  801313:	68 00 50 80 00       	push   $0x805000
  801318:	56                   	push   %esi
  801319:	ff 35 00 40 80 00    	pushl  0x804000
  80131f:	e8 65 0c 00 00       	call   801f89 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801324:	83 c4 0c             	add    $0xc,%esp
  801327:	6a 00                	push   $0x0
  801329:	53                   	push   %ebx
  80132a:	6a 00                	push   $0x0
  80132c:	e8 e5 0b 00 00       	call   801f16 <ipc_recv>
}
  801331:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801334:	5b                   	pop    %ebx
  801335:	5e                   	pop    %esi
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801338:	83 ec 0c             	sub    $0xc,%esp
  80133b:	6a 01                	push   $0x1
  80133d:	e8 b3 0c 00 00       	call   801ff5 <ipc_find_env>
  801342:	a3 00 40 80 00       	mov    %eax,0x804000
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	eb c5                	jmp    801311 <fsipc+0x12>

0080134c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8b 40 0c             	mov    0xc(%eax),%eax
  801358:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801365:	ba 00 00 00 00       	mov    $0x0,%edx
  80136a:	b8 02 00 00 00       	mov    $0x2,%eax
  80136f:	e8 8b ff ff ff       	call   8012ff <fsipc>
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <devfile_flush>:
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8b 40 0c             	mov    0xc(%eax),%eax
  801382:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801387:	ba 00 00 00 00       	mov    $0x0,%edx
  80138c:	b8 06 00 00 00       	mov    $0x6,%eax
  801391:	e8 69 ff ff ff       	call   8012ff <fsipc>
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <devfile_stat>:
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	53                   	push   %ebx
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8013b7:	e8 43 ff ff ff       	call   8012ff <fsipc>
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 2c                	js     8013ec <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	68 00 50 80 00       	push   $0x805000
  8013c8:	53                   	push   %ebx
  8013c9:	e8 9d f3 ff ff       	call   80076b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013ce:	a1 80 50 80 00       	mov    0x805080,%eax
  8013d3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013d9:	a1 84 50 80 00       	mov    0x805084,%eax
  8013de:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <devfile_write>:
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8013fb:	85 db                	test   %ebx,%ebx
  8013fd:	75 07                	jne    801406 <devfile_write+0x15>
	return n_all;
  8013ff:	89 d8                	mov    %ebx,%eax
}
  801401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801404:	c9                   	leave  
  801405:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8b 40 0c             	mov    0xc(%eax),%eax
  80140c:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801411:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	53                   	push   %ebx
  80141b:	ff 75 0c             	pushl  0xc(%ebp)
  80141e:	68 08 50 80 00       	push   $0x805008
  801423:	e8 d1 f4 ff ff       	call   8008f9 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801428:	ba 00 00 00 00       	mov    $0x0,%edx
  80142d:	b8 04 00 00 00       	mov    $0x4,%eax
  801432:	e8 c8 fe ff ff       	call   8012ff <fsipc>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 c3                	js     801401 <devfile_write+0x10>
	  assert(r <= n_left);
  80143e:	39 d8                	cmp    %ebx,%eax
  801440:	77 0b                	ja     80144d <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801442:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801447:	7f 1d                	jg     801466 <devfile_write+0x75>
    n_all += r;
  801449:	89 c3                	mov    %eax,%ebx
  80144b:	eb b2                	jmp    8013ff <devfile_write+0xe>
	  assert(r <= n_left);
  80144d:	68 fc 26 80 00       	push   $0x8026fc
  801452:	68 08 27 80 00       	push   $0x802708
  801457:	68 9f 00 00 00       	push   $0x9f
  80145c:	68 1d 27 80 00       	push   $0x80271d
  801461:	e8 6a 0a 00 00       	call   801ed0 <_panic>
	  assert(r <= PGSIZE);
  801466:	68 28 27 80 00       	push   $0x802728
  80146b:	68 08 27 80 00       	push   $0x802708
  801470:	68 a0 00 00 00       	push   $0xa0
  801475:	68 1d 27 80 00       	push   $0x80271d
  80147a:	e8 51 0a 00 00       	call   801ed0 <_panic>

0080147f <devfile_read>:
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	56                   	push   %esi
  801483:	53                   	push   %ebx
  801484:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8b 40 0c             	mov    0xc(%eax),%eax
  80148d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801492:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801498:	ba 00 00 00 00       	mov    $0x0,%edx
  80149d:	b8 03 00 00 00       	mov    $0x3,%eax
  8014a2:	e8 58 fe ff ff       	call   8012ff <fsipc>
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 1f                	js     8014cc <devfile_read+0x4d>
	assert(r <= n);
  8014ad:	39 f0                	cmp    %esi,%eax
  8014af:	77 24                	ja     8014d5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014b1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014b6:	7f 33                	jg     8014eb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	50                   	push   %eax
  8014bc:	68 00 50 80 00       	push   $0x805000
  8014c1:	ff 75 0c             	pushl  0xc(%ebp)
  8014c4:	e8 30 f4 ff ff       	call   8008f9 <memmove>
	return r;
  8014c9:	83 c4 10             	add    $0x10,%esp
}
  8014cc:	89 d8                	mov    %ebx,%eax
  8014ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    
	assert(r <= n);
  8014d5:	68 34 27 80 00       	push   $0x802734
  8014da:	68 08 27 80 00       	push   $0x802708
  8014df:	6a 7c                	push   $0x7c
  8014e1:	68 1d 27 80 00       	push   $0x80271d
  8014e6:	e8 e5 09 00 00       	call   801ed0 <_panic>
	assert(r <= PGSIZE);
  8014eb:	68 28 27 80 00       	push   $0x802728
  8014f0:	68 08 27 80 00       	push   $0x802708
  8014f5:	6a 7d                	push   $0x7d
  8014f7:	68 1d 27 80 00       	push   $0x80271d
  8014fc:	e8 cf 09 00 00       	call   801ed0 <_panic>

00801501 <open>:
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	56                   	push   %esi
  801505:	53                   	push   %ebx
  801506:	83 ec 1c             	sub    $0x1c,%esp
  801509:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80150c:	56                   	push   %esi
  80150d:	e8 20 f2 ff ff       	call   800732 <strlen>
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80151a:	7f 6c                	jg     801588 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	e8 6c f8 ff ff       	call   800d94 <fd_alloc>
  801528:	89 c3                	mov    %eax,%ebx
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 3c                	js     80156d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801531:	83 ec 08             	sub    $0x8,%esp
  801534:	56                   	push   %esi
  801535:	68 00 50 80 00       	push   $0x805000
  80153a:	e8 2c f2 ff ff       	call   80076b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154a:	b8 01 00 00 00       	mov    $0x1,%eax
  80154f:	e8 ab fd ff ff       	call   8012ff <fsipc>
  801554:	89 c3                	mov    %eax,%ebx
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 19                	js     801576 <open+0x75>
	return fd2num(fd);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	e8 05 f8 ff ff       	call   800d6d <fd2num>
  801568:	89 c3                	mov    %eax,%ebx
  80156a:	83 c4 10             	add    $0x10,%esp
}
  80156d:	89 d8                	mov    %ebx,%eax
  80156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		fd_close(fd, 0);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 f4             	pushl  -0xc(%ebp)
  80157e:	e8 0e f9 ff ff       	call   800e91 <fd_close>
		return r;
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	eb e5                	jmp    80156d <open+0x6c>
		return -E_BAD_PATH;
  801588:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80158d:	eb de                	jmp    80156d <open+0x6c>

0080158f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	b8 08 00 00 00       	mov    $0x8,%eax
  80159f:	e8 5b fd ff ff       	call   8012ff <fsipc>
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	e8 c4 f7 ff ff       	call   800d7d <fd2data>
  8015b9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015bb:	83 c4 08             	add    $0x8,%esp
  8015be:	68 3b 27 80 00       	push   $0x80273b
  8015c3:	53                   	push   %ebx
  8015c4:	e8 a2 f1 ff ff       	call   80076b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015c9:	8b 46 04             	mov    0x4(%esi),%eax
  8015cc:	2b 06                	sub    (%esi),%eax
  8015ce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015db:	00 00 00 
	stat->st_dev = &devpipe;
  8015de:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015e5:	30 80 00 
	return 0;
}
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015fe:	53                   	push   %ebx
  8015ff:	6a 00                	push   $0x0
  801601:	e8 dc f5 ff ff       	call   800be2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801606:	89 1c 24             	mov    %ebx,(%esp)
  801609:	e8 6f f7 ff ff       	call   800d7d <fd2data>
  80160e:	83 c4 08             	add    $0x8,%esp
  801611:	50                   	push   %eax
  801612:	6a 00                	push   $0x0
  801614:	e8 c9 f5 ff ff       	call   800be2 <sys_page_unmap>
}
  801619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <_pipeisclosed>:
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	57                   	push   %edi
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
  801624:	83 ec 1c             	sub    $0x1c,%esp
  801627:	89 c7                	mov    %eax,%edi
  801629:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80162b:	a1 08 40 80 00       	mov    0x804008,%eax
  801630:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	57                   	push   %edi
  801637:	e8 f2 09 00 00       	call   80202e <pageref>
  80163c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80163f:	89 34 24             	mov    %esi,(%esp)
  801642:	e8 e7 09 00 00       	call   80202e <pageref>
		nn = thisenv->env_runs;
  801647:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80164d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	39 cb                	cmp    %ecx,%ebx
  801655:	74 1b                	je     801672 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801657:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80165a:	75 cf                	jne    80162b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80165c:	8b 42 58             	mov    0x58(%edx),%eax
  80165f:	6a 01                	push   $0x1
  801661:	50                   	push   %eax
  801662:	53                   	push   %ebx
  801663:	68 42 27 80 00       	push   $0x802742
  801668:	e8 22 eb ff ff       	call   80018f <cprintf>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	eb b9                	jmp    80162b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801672:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801675:	0f 94 c0             	sete   %al
  801678:	0f b6 c0             	movzbl %al,%eax
}
  80167b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <devpipe_write>:
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 28             	sub    $0x28,%esp
  80168c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80168f:	56                   	push   %esi
  801690:	e8 e8 f6 ff ff       	call   800d7d <fd2data>
  801695:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	bf 00 00 00 00       	mov    $0x0,%edi
  80169f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016a2:	74 4f                	je     8016f3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016a4:	8b 43 04             	mov    0x4(%ebx),%eax
  8016a7:	8b 0b                	mov    (%ebx),%ecx
  8016a9:	8d 51 20             	lea    0x20(%ecx),%edx
  8016ac:	39 d0                	cmp    %edx,%eax
  8016ae:	72 14                	jb     8016c4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8016b0:	89 da                	mov    %ebx,%edx
  8016b2:	89 f0                	mov    %esi,%eax
  8016b4:	e8 65 ff ff ff       	call   80161e <_pipeisclosed>
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	75 3b                	jne    8016f8 <devpipe_write+0x75>
			sys_yield();
  8016bd:	e8 7c f4 ff ff       	call   800b3e <sys_yield>
  8016c2:	eb e0                	jmp    8016a4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016cb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016ce:	89 c2                	mov    %eax,%edx
  8016d0:	c1 fa 1f             	sar    $0x1f,%edx
  8016d3:	89 d1                	mov    %edx,%ecx
  8016d5:	c1 e9 1b             	shr    $0x1b,%ecx
  8016d8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016db:	83 e2 1f             	and    $0x1f,%edx
  8016de:	29 ca                	sub    %ecx,%edx
  8016e0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016e8:	83 c0 01             	add    $0x1,%eax
  8016eb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016ee:	83 c7 01             	add    $0x1,%edi
  8016f1:	eb ac                	jmp    80169f <devpipe_write+0x1c>
	return i;
  8016f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f6:	eb 05                	jmp    8016fd <devpipe_write+0x7a>
				return 0;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <devpipe_read>:
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	57                   	push   %edi
  801709:	56                   	push   %esi
  80170a:	53                   	push   %ebx
  80170b:	83 ec 18             	sub    $0x18,%esp
  80170e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801711:	57                   	push   %edi
  801712:	e8 66 f6 ff ff       	call   800d7d <fd2data>
  801717:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	be 00 00 00 00       	mov    $0x0,%esi
  801721:	3b 75 10             	cmp    0x10(%ebp),%esi
  801724:	75 14                	jne    80173a <devpipe_read+0x35>
	return i;
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	eb 02                	jmp    80172d <devpipe_read+0x28>
				return i;
  80172b:	89 f0                	mov    %esi,%eax
}
  80172d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    
			sys_yield();
  801735:	e8 04 f4 ff ff       	call   800b3e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80173a:	8b 03                	mov    (%ebx),%eax
  80173c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80173f:	75 18                	jne    801759 <devpipe_read+0x54>
			if (i > 0)
  801741:	85 f6                	test   %esi,%esi
  801743:	75 e6                	jne    80172b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801745:	89 da                	mov    %ebx,%edx
  801747:	89 f8                	mov    %edi,%eax
  801749:	e8 d0 fe ff ff       	call   80161e <_pipeisclosed>
  80174e:	85 c0                	test   %eax,%eax
  801750:	74 e3                	je     801735 <devpipe_read+0x30>
				return 0;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb d4                	jmp    80172d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801759:	99                   	cltd   
  80175a:	c1 ea 1b             	shr    $0x1b,%edx
  80175d:	01 d0                	add    %edx,%eax
  80175f:	83 e0 1f             	and    $0x1f,%eax
  801762:	29 d0                	sub    %edx,%eax
  801764:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80176f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801772:	83 c6 01             	add    $0x1,%esi
  801775:	eb aa                	jmp    801721 <devpipe_read+0x1c>

00801777 <pipe>:
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	56                   	push   %esi
  80177b:	53                   	push   %ebx
  80177c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80177f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	e8 0c f6 ff ff       	call   800d94 <fd_alloc>
  801788:	89 c3                	mov    %eax,%ebx
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	0f 88 23 01 00 00    	js     8018b8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	68 07 04 00 00       	push   $0x407
  80179d:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a0:	6a 00                	push   $0x0
  8017a2:	e8 b6 f3 ff ff       	call   800b5d <sys_page_alloc>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	0f 88 04 01 00 00    	js     8018b8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8017b4:	83 ec 0c             	sub    $0xc,%esp
  8017b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ba:	50                   	push   %eax
  8017bb:	e8 d4 f5 ff ff       	call   800d94 <fd_alloc>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	0f 88 db 00 00 00    	js     8018a8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 07 04 00 00       	push   $0x407
  8017d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d8:	6a 00                	push   $0x0
  8017da:	e8 7e f3 ff ff       	call   800b5d <sys_page_alloc>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	0f 88 bc 00 00 00    	js     8018a8 <pipe+0x131>
	va = fd2data(fd0);
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f2:	e8 86 f5 ff ff       	call   800d7d <fd2data>
  8017f7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f9:	83 c4 0c             	add    $0xc,%esp
  8017fc:	68 07 04 00 00       	push   $0x407
  801801:	50                   	push   %eax
  801802:	6a 00                	push   $0x0
  801804:	e8 54 f3 ff ff       	call   800b5d <sys_page_alloc>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	0f 88 82 00 00 00    	js     801898 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	ff 75 f0             	pushl  -0x10(%ebp)
  80181c:	e8 5c f5 ff ff       	call   800d7d <fd2data>
  801821:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801828:	50                   	push   %eax
  801829:	6a 00                	push   $0x0
  80182b:	56                   	push   %esi
  80182c:	6a 00                	push   $0x0
  80182e:	e8 6d f3 ff ff       	call   800ba0 <sys_page_map>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	83 c4 20             	add    $0x20,%esp
  801838:	85 c0                	test   %eax,%eax
  80183a:	78 4e                	js     80188a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80183c:	a1 20 30 80 00       	mov    0x803020,%eax
  801841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801844:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801849:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801850:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801853:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801858:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80185f:	83 ec 0c             	sub    $0xc,%esp
  801862:	ff 75 f4             	pushl  -0xc(%ebp)
  801865:	e8 03 f5 ff ff       	call   800d6d <fd2num>
  80186a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80186f:	83 c4 04             	add    $0x4,%esp
  801872:	ff 75 f0             	pushl  -0x10(%ebp)
  801875:	e8 f3 f4 ff ff       	call   800d6d <fd2num>
  80187a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	bb 00 00 00 00       	mov    $0x0,%ebx
  801888:	eb 2e                	jmp    8018b8 <pipe+0x141>
	sys_page_unmap(0, va);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	56                   	push   %esi
  80188e:	6a 00                	push   $0x0
  801890:	e8 4d f3 ff ff       	call   800be2 <sys_page_unmap>
  801895:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	ff 75 f0             	pushl  -0x10(%ebp)
  80189e:	6a 00                	push   $0x0
  8018a0:	e8 3d f3 ff ff       	call   800be2 <sys_page_unmap>
  8018a5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ae:	6a 00                	push   $0x0
  8018b0:	e8 2d f3 ff ff       	call   800be2 <sys_page_unmap>
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    

008018c1 <pipeisclosed>:
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ca:	50                   	push   %eax
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	e8 13 f5 ff ff       	call   800de6 <fd_lookup>
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 18                	js     8018f2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e0:	e8 98 f4 ff ff       	call   800d7d <fd2data>
	return _pipeisclosed(fd, p);
  8018e5:	89 c2                	mov    %eax,%edx
  8018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ea:	e8 2f fd ff ff       	call   80161e <_pipeisclosed>
  8018ef:	83 c4 10             	add    $0x10,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018fa:	68 5a 27 80 00       	push   $0x80275a
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	e8 64 ee ff ff       	call   80076b <strcpy>
	return 0;
}
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <devsock_close>:
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	53                   	push   %ebx
  801912:	83 ec 10             	sub    $0x10,%esp
  801915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801918:	53                   	push   %ebx
  801919:	e8 10 07 00 00       	call   80202e <pageref>
  80191e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801921:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801926:	83 f8 01             	cmp    $0x1,%eax
  801929:	74 07                	je     801932 <devsock_close+0x24>
}
  80192b:	89 d0                	mov    %edx,%eax
  80192d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801930:	c9                   	leave  
  801931:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	ff 73 0c             	pushl  0xc(%ebx)
  801938:	e8 b9 02 00 00       	call   801bf6 <nsipc_close>
  80193d:	89 c2                	mov    %eax,%edx
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	eb e7                	jmp    80192b <devsock_close+0x1d>

00801944 <devsock_write>:
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 10             	pushl  0x10(%ebp)
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	ff 70 0c             	pushl  0xc(%eax)
  801958:	e8 76 03 00 00       	call   801cd3 <nsipc_send>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <devsock_read>:
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801965:	6a 00                	push   $0x0
  801967:	ff 75 10             	pushl  0x10(%ebp)
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	ff 70 0c             	pushl  0xc(%eax)
  801973:	e8 ef 02 00 00       	call   801c67 <nsipc_recv>
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <fd2sockid>:
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801980:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	e8 5c f4 ff ff       	call   800de6 <fd_lookup>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 10                	js     8019a1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  80199a:	39 08                	cmp    %ecx,(%eax)
  80199c:	75 05                	jne    8019a3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80199e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a8:	eb f7                	jmp    8019a1 <fd2sockid+0x27>

008019aa <alloc_sockfd>:
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 1c             	sub    $0x1c,%esp
  8019b2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	e8 d7 f3 ff ff       	call   800d94 <fd_alloc>
  8019bd:	89 c3                	mov    %eax,%ebx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 43                	js     801a09 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	68 07 04 00 00       	push   $0x407
  8019ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d1:	6a 00                	push   $0x0
  8019d3:	e8 85 f1 ff ff       	call   800b5d <sys_page_alloc>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 28                	js     801a09 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019ea:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019f6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	50                   	push   %eax
  8019fd:	e8 6b f3 ff ff       	call   800d6d <fd2num>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	eb 0c                	jmp    801a15 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	56                   	push   %esi
  801a0d:	e8 e4 01 00 00       	call   801bf6 <nsipc_close>
		return r;
  801a12:	83 c4 10             	add    $0x10,%esp
}
  801a15:	89 d8                	mov    %ebx,%eax
  801a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5d                   	pop    %ebp
  801a1d:	c3                   	ret    

00801a1e <accept>:
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	e8 4e ff ff ff       	call   80197a <fd2sockid>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 1b                	js     801a4b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 0e 01 00 00       	call   801b4d <nsipc_accept>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 05                	js     801a4b <accept+0x2d>
	return alloc_sockfd(r);
  801a46:	e8 5f ff ff ff       	call   8019aa <alloc_sockfd>
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <bind>:
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	e8 1f ff ff ff       	call   80197a <fd2sockid>
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 12                	js     801a71 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	ff 75 10             	pushl  0x10(%ebp)
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	50                   	push   %eax
  801a69:	e8 31 01 00 00       	call   801b9f <nsipc_bind>
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <shutdown>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	e8 f9 fe ff ff       	call   80197a <fd2sockid>
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 0f                	js     801a94 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a85:	83 ec 08             	sub    $0x8,%esp
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	50                   	push   %eax
  801a8c:	e8 43 01 00 00       	call   801bd4 <nsipc_shutdown>
  801a91:	83 c4 10             	add    $0x10,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <connect>:
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	e8 d6 fe ff ff       	call   80197a <fd2sockid>
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 12                	js     801aba <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	e8 59 01 00 00       	call   801c10 <nsipc_connect>
  801ab7:	83 c4 10             	add    $0x10,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <listen>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	e8 b0 fe ff ff       	call   80197a <fd2sockid>
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 0f                	js     801add <listen+0x21>
	return nsipc_listen(r, backlog);
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	e8 6b 01 00 00       	call   801c45 <nsipc_listen>
  801ada:	83 c4 10             	add    $0x10,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <socket>:

int
socket(int domain, int type, int protocol)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	e8 3e 02 00 00       	call   801d31 <nsipc_socket>
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 05                	js     801aff <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801afa:	e8 ab fe ff ff       	call   8019aa <alloc_sockfd>
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	53                   	push   %ebx
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b0a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b11:	74 26                	je     801b39 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b13:	6a 07                	push   $0x7
  801b15:	68 00 60 80 00       	push   $0x806000
  801b1a:	53                   	push   %ebx
  801b1b:	ff 35 04 40 80 00    	pushl  0x804004
  801b21:	e8 63 04 00 00       	call   801f89 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b26:	83 c4 0c             	add    $0xc,%esp
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	e8 e2 03 00 00       	call   801f16 <ipc_recv>
}
  801b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b39:	83 ec 0c             	sub    $0xc,%esp
  801b3c:	6a 02                	push   $0x2
  801b3e:	e8 b2 04 00 00       	call   801ff5 <ipc_find_env>
  801b43:	a3 04 40 80 00       	mov    %eax,0x804004
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	eb c6                	jmp    801b13 <nsipc+0x12>

00801b4d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	56                   	push   %esi
  801b51:	53                   	push   %ebx
  801b52:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b5d:	8b 06                	mov    (%esi),%eax
  801b5f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b64:	b8 01 00 00 00       	mov    $0x1,%eax
  801b69:	e8 93 ff ff ff       	call   801b01 <nsipc>
  801b6e:	89 c3                	mov    %eax,%ebx
  801b70:	85 c0                	test   %eax,%eax
  801b72:	79 09                	jns    801b7d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b74:	89 d8                	mov    %ebx,%eax
  801b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5e                   	pop    %esi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	ff 35 10 60 80 00    	pushl  0x806010
  801b86:	68 00 60 80 00       	push   $0x806000
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	e8 66 ed ff ff       	call   8008f9 <memmove>
		*addrlen = ret->ret_addrlen;
  801b93:	a1 10 60 80 00       	mov    0x806010,%eax
  801b98:	89 06                	mov    %eax,(%esi)
  801b9a:	83 c4 10             	add    $0x10,%esp
	return r;
  801b9d:	eb d5                	jmp    801b74 <nsipc_accept+0x27>

00801b9f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	53                   	push   %ebx
  801ba3:	83 ec 08             	sub    $0x8,%esp
  801ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb1:	53                   	push   %ebx
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	68 04 60 80 00       	push   $0x806004
  801bba:	e8 3a ed ff ff       	call   8008f9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bbf:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bc5:	b8 02 00 00 00       	mov    $0x2,%eax
  801bca:	e8 32 ff ff ff       	call   801b01 <nsipc>
}
  801bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bea:	b8 03 00 00 00       	mov    $0x3,%eax
  801bef:	e8 0d ff ff ff       	call   801b01 <nsipc>
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <nsipc_close>:

int
nsipc_close(int s)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c04:	b8 04 00 00 00       	mov    $0x4,%eax
  801c09:	e8 f3 fe ff ff       	call   801b01 <nsipc>
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c22:	53                   	push   %ebx
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	68 04 60 80 00       	push   $0x806004
  801c2b:	e8 c9 ec ff ff       	call   8008f9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c30:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c36:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3b:	e8 c1 fe ff ff       	call   801b01 <nsipc>
}
  801c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c56:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c5b:	b8 06 00 00 00       	mov    $0x6,%eax
  801c60:	e8 9c fe ff ff       	call   801b01 <nsipc>
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c77:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c80:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c85:	b8 07 00 00 00       	mov    $0x7,%eax
  801c8a:	e8 72 fe ff ff       	call   801b01 <nsipc>
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 1f                	js     801cb4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c95:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c9a:	7f 21                	jg     801cbd <nsipc_recv+0x56>
  801c9c:	39 c6                	cmp    %eax,%esi
  801c9e:	7c 1d                	jl     801cbd <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	50                   	push   %eax
  801ca4:	68 00 60 80 00       	push   $0x806000
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	e8 48 ec ff ff       	call   8008f9 <memmove>
  801cb1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cb4:	89 d8                	mov    %ebx,%eax
  801cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb9:	5b                   	pop    %ebx
  801cba:	5e                   	pop    %esi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cbd:	68 66 27 80 00       	push   $0x802766
  801cc2:	68 08 27 80 00       	push   $0x802708
  801cc7:	6a 62                	push   $0x62
  801cc9:	68 7b 27 80 00       	push   $0x80277b
  801cce:	e8 fd 01 00 00       	call   801ed0 <_panic>

00801cd3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ce5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ceb:	7f 2e                	jg     801d1b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	53                   	push   %ebx
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	68 0c 60 80 00       	push   $0x80600c
  801cf9:	e8 fb eb ff ff       	call   8008f9 <memmove>
	nsipcbuf.send.req_size = size;
  801cfe:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d04:	8b 45 14             	mov    0x14(%ebp),%eax
  801d07:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d0c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d11:	e8 eb fd ff ff       	call   801b01 <nsipc>
}
  801d16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    
	assert(size < 1600);
  801d1b:	68 87 27 80 00       	push   $0x802787
  801d20:	68 08 27 80 00       	push   $0x802708
  801d25:	6a 6d                	push   $0x6d
  801d27:	68 7b 27 80 00       	push   $0x80277b
  801d2c:	e8 9f 01 00 00       	call   801ed0 <_panic>

00801d31 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d42:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d47:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d4f:	b8 09 00 00 00       	mov    $0x9,%eax
  801d54:	e8 a8 fd ff ff       	call   801b01 <nsipc>
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	c3                   	ret    

00801d61 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d67:	68 93 27 80 00       	push   $0x802793
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	e8 f7 e9 ff ff       	call   80076b <strcpy>
	return 0;
}
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <devcons_write>:
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	57                   	push   %edi
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d87:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d8c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d92:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d95:	73 31                	jae    801dc8 <devcons_write+0x4d>
		m = n - tot;
  801d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d9a:	29 f3                	sub    %esi,%ebx
  801d9c:	83 fb 7f             	cmp    $0x7f,%ebx
  801d9f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801da4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	53                   	push   %ebx
  801dab:	89 f0                	mov    %esi,%eax
  801dad:	03 45 0c             	add    0xc(%ebp),%eax
  801db0:	50                   	push   %eax
  801db1:	57                   	push   %edi
  801db2:	e8 42 eb ff ff       	call   8008f9 <memmove>
		sys_cputs(buf, m);
  801db7:	83 c4 08             	add    $0x8,%esp
  801dba:	53                   	push   %ebx
  801dbb:	57                   	push   %edi
  801dbc:	e8 e0 ec ff ff       	call   800aa1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dc1:	01 de                	add    %ebx,%esi
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	eb ca                	jmp    801d92 <devcons_write+0x17>
}
  801dc8:	89 f0                	mov    %esi,%eax
  801dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5f                   	pop    %edi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <devcons_read>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ddd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801de1:	74 21                	je     801e04 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801de3:	e8 d7 ec ff ff       	call   800abf <sys_cgetc>
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 07                	jne    801df3 <devcons_read+0x21>
		sys_yield();
  801dec:	e8 4d ed ff ff       	call   800b3e <sys_yield>
  801df1:	eb f0                	jmp    801de3 <devcons_read+0x11>
	if (c < 0)
  801df3:	78 0f                	js     801e04 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801df5:	83 f8 04             	cmp    $0x4,%eax
  801df8:	74 0c                	je     801e06 <devcons_read+0x34>
	*(char*)vbuf = c;
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	88 02                	mov    %al,(%edx)
	return 1;
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	eb f7                	jmp    801e04 <devcons_read+0x32>

00801e0d <cputchar>:
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e19:	6a 01                	push   $0x1
  801e1b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e1e:	50                   	push   %eax
  801e1f:	e8 7d ec ff ff       	call   800aa1 <sys_cputs>
}
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <getchar>:
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e2f:	6a 01                	push   $0x1
  801e31:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e34:	50                   	push   %eax
  801e35:	6a 00                	push   $0x0
  801e37:	e8 1a f2 ff ff       	call   801056 <read>
	if (r < 0)
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 06                	js     801e49 <getchar+0x20>
	if (r < 1)
  801e43:	74 06                	je     801e4b <getchar+0x22>
	return c;
  801e45:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    
		return -E_EOF;
  801e4b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e50:	eb f7                	jmp    801e49 <getchar+0x20>

00801e52 <iscons>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5b:	50                   	push   %eax
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	e8 82 ef ff ff       	call   800de6 <fd_lookup>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 11                	js     801e7c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e74:	39 10                	cmp    %edx,(%eax)
  801e76:	0f 94 c0             	sete   %al
  801e79:	0f b6 c0             	movzbl %al,%eax
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <opencons>:
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e87:	50                   	push   %eax
  801e88:	e8 07 ef ff ff       	call   800d94 <fd_alloc>
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 3a                	js     801ece <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 07 04 00 00       	push   $0x407
  801e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 b7 ec ff ff       	call   800b5d <sys_page_alloc>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 21                	js     801ece <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801eb6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	50                   	push   %eax
  801ec6:	e8 a2 ee ff ff       	call   800d6d <fd2num>
  801ecb:	83 c4 10             	add    $0x10,%esp
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ed5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ed8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ede:	e8 3c ec ff ff       	call   800b1f <sys_getenvid>
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	56                   	push   %esi
  801eed:	50                   	push   %eax
  801eee:	68 a0 27 80 00       	push   $0x8027a0
  801ef3:	e8 97 e2 ff ff       	call   80018f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ef8:	83 c4 18             	add    $0x18,%esp
  801efb:	53                   	push   %ebx
  801efc:	ff 75 10             	pushl  0x10(%ebp)
  801eff:	e8 3a e2 ff ff       	call   80013e <vcprintf>
	cprintf("\n");
  801f04:	c7 04 24 53 27 80 00 	movl   $0x802753,(%esp)
  801f0b:	e8 7f e2 ff ff       	call   80018f <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f13:	cc                   	int3   
  801f14:	eb fd                	jmp    801f13 <_panic+0x43>

00801f16 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	8b 75 08             	mov    0x8(%ebp),%esi
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f24:	85 c0                	test   %eax,%eax
  801f26:	74 4f                	je     801f77 <ipc_recv+0x61>
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	50                   	push   %eax
  801f2c:	e8 dc ed ff ff       	call   800d0d <sys_ipc_recv>
  801f31:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f34:	85 f6                	test   %esi,%esi
  801f36:	74 14                	je     801f4c <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f38:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	75 09                	jne    801f4a <ipc_recv+0x34>
  801f41:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f47:	8b 52 74             	mov    0x74(%edx),%edx
  801f4a:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f4c:	85 db                	test   %ebx,%ebx
  801f4e:	74 14                	je     801f64 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f50:	ba 00 00 00 00       	mov    $0x0,%edx
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 09                	jne    801f62 <ipc_recv+0x4c>
  801f59:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f5f:	8b 52 78             	mov    0x78(%edx),%edx
  801f62:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f64:	85 c0                	test   %eax,%eax
  801f66:	75 08                	jne    801f70 <ipc_recv+0x5a>
  801f68:	a1 08 40 80 00       	mov    0x804008,%eax
  801f6d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	68 00 00 c0 ee       	push   $0xeec00000
  801f7f:	e8 89 ed ff ff       	call   800d0d <sys_ipc_recv>
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	eb ab                	jmp    801f34 <ipc_recv+0x1e>

00801f89 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	57                   	push   %edi
  801f8d:	56                   	push   %esi
  801f8e:	53                   	push   %ebx
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f95:	8b 75 10             	mov    0x10(%ebp),%esi
  801f98:	eb 20                	jmp    801fba <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f9a:	6a 00                	push   $0x0
  801f9c:	68 00 00 c0 ee       	push   $0xeec00000
  801fa1:	ff 75 0c             	pushl  0xc(%ebp)
  801fa4:	57                   	push   %edi
  801fa5:	e8 40 ed ff ff       	call   800cea <sys_ipc_try_send>
  801faa:	89 c3                	mov    %eax,%ebx
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	eb 1f                	jmp    801fd0 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801fb1:	e8 88 eb ff ff       	call   800b3e <sys_yield>
	while(retval != 0) {
  801fb6:	85 db                	test   %ebx,%ebx
  801fb8:	74 33                	je     801fed <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801fba:	85 f6                	test   %esi,%esi
  801fbc:	74 dc                	je     801f9a <ipc_send+0x11>
  801fbe:	ff 75 14             	pushl  0x14(%ebp)
  801fc1:	56                   	push   %esi
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	57                   	push   %edi
  801fc6:	e8 1f ed ff ff       	call   800cea <sys_ipc_try_send>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801fd0:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801fd3:	74 dc                	je     801fb1 <ipc_send+0x28>
  801fd5:	85 db                	test   %ebx,%ebx
  801fd7:	74 d8                	je     801fb1 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	68 c4 27 80 00       	push   $0x8027c4
  801fe1:	6a 35                	push   $0x35
  801fe3:	68 f4 27 80 00       	push   $0x8027f4
  801fe8:	e8 e3 fe ff ff       	call   801ed0 <_panic>
	}
}
  801fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802000:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802003:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802009:	8b 52 50             	mov    0x50(%edx),%edx
  80200c:	39 ca                	cmp    %ecx,%edx
  80200e:	74 11                	je     802021 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802010:	83 c0 01             	add    $0x1,%eax
  802013:	3d 00 04 00 00       	cmp    $0x400,%eax
  802018:	75 e6                	jne    802000 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	eb 0b                	jmp    80202c <ipc_find_env+0x37>
			return envs[i].env_id;
  802021:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802024:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802029:	8b 40 48             	mov    0x48(%eax),%eax
}
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802034:	89 d0                	mov    %edx,%eax
  802036:	c1 e8 16             	shr    $0x16,%eax
  802039:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802045:	f6 c1 01             	test   $0x1,%cl
  802048:	74 1d                	je     802067 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80204a:	c1 ea 0c             	shr    $0xc,%edx
  80204d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802054:	f6 c2 01             	test   $0x1,%dl
  802057:	74 0e                	je     802067 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802059:	c1 ea 0c             	shr    $0xc,%edx
  80205c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802063:	ef 
  802064:	0f b7 c0             	movzwl %ax,%eax
}
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    
  802069:	66 90                	xchg   %ax,%ax
  80206b:	66 90                	xchg   %ax,%ax
  80206d:	66 90                	xchg   %ax,%ax
  80206f:	90                   	nop

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
