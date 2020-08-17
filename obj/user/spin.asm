
obj/user/spin.debug：     文件格式 elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 20 27 80 00       	push   $0x802720
  80003f:	e8 66 01 00 00       	call   8001aa <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 b6 0e 00 00       	call   800eff <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 98 27 80 00       	push   $0x802798
  800058:	e8 4d 01 00 00       	call   8001aa <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 48 27 80 00       	push   $0x802748
  80006c:	e8 39 01 00 00       	call   8001aa <cprintf>
	sys_yield();
  800071:	e8 e3 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  800076:	e8 de 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  80007b:	e8 d9 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  800080:	e8 d4 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  800085:	e8 cf 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  80008a:	e8 ca 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  80008f:	e8 c5 0a 00 00       	call   800b59 <sys_yield>
	sys_yield();
  800094:	e8 c0 0a 00 00       	call   800b59 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 70 27 80 00 	movl   $0x802770,(%esp)
  8000a0:	e8 05 01 00 00       	call   8001aa <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 4c 0a 00 00       	call   800af9 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 75 0a 00 00       	call   800b3a <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 ff 11 00 00       	call   801305 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 e9 09 00 00       	call   800af9 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	53                   	push   %ebx
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011f:	8b 13                	mov    (%ebx),%edx
  800121:	8d 42 01             	lea    0x1(%edx),%eax
  800124:	89 03                	mov    %eax,(%ebx)
  800126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800129:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800132:	74 09                	je     80013d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800134:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 ff 00 00 00       	push   $0xff
  800145:	8d 43 08             	lea    0x8(%ebx),%eax
  800148:	50                   	push   %eax
  800149:	e8 6e 09 00 00       	call   800abc <sys_cputs>
		b->idx = 0;
  80014e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	eb db                	jmp    800134 <putch+0x1f>

00800159 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 15 01 80 00       	push   $0x800115
  800188:	e8 19 01 00 00       	call   8002a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 1a 09 00 00       	call   800abc <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b3:	50                   	push   %eax
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	e8 9d ff ff ff       	call   800159 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	57                   	push   %edi
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
  8001c4:	83 ec 1c             	sub    $0x1c,%esp
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	89 d6                	mov    %edx,%esi
  8001cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8001ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001f0:	73 15                	jae    800207 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f2:	83 eb 01             	sub    $0x1,%ebx
  8001f5:	85 db                	test   %ebx,%ebx
  8001f7:	7e 43                	jle    80023c <printnum+0x7e>
			putch(padc, putdat);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	ff d7                	call   *%edi
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	eb eb                	jmp    8001f2 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	ff 75 18             	pushl  0x18(%ebp)
  80020d:	8b 45 14             	mov    0x14(%ebp),%eax
  800210:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800213:	53                   	push   %ebx
  800214:	ff 75 10             	pushl  0x10(%ebp)
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021d:	ff 75 e0             	pushl  -0x20(%ebp)
  800220:	ff 75 dc             	pushl  -0x24(%ebp)
  800223:	ff 75 d8             	pushl  -0x28(%ebp)
  800226:	e8 a5 22 00 00       	call   8024d0 <__udivdi3>
  80022b:	83 c4 18             	add    $0x18,%esp
  80022e:	52                   	push   %edx
  80022f:	50                   	push   %eax
  800230:	89 f2                	mov    %esi,%edx
  800232:	89 f8                	mov    %edi,%eax
  800234:	e8 85 ff ff ff       	call   8001be <printnum>
  800239:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	ff 75 e4             	pushl  -0x1c(%ebp)
  800246:	ff 75 e0             	pushl  -0x20(%ebp)
  800249:	ff 75 dc             	pushl  -0x24(%ebp)
  80024c:	ff 75 d8             	pushl  -0x28(%ebp)
  80024f:	e8 8c 23 00 00       	call   8025e0 <__umoddi3>
  800254:	83 c4 14             	add    $0x14,%esp
  800257:	0f be 80 c0 27 80 00 	movsbl 0x8027c0(%eax),%eax
  80025e:	50                   	push   %eax
  80025f:	ff d7                	call   *%edi
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800272:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800276:	8b 10                	mov    (%eax),%edx
  800278:	3b 50 04             	cmp    0x4(%eax),%edx
  80027b:	73 0a                	jae    800287 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800280:	89 08                	mov    %ecx,(%eax)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	88 02                	mov    %al,(%edx)
}
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <printfmt>:
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800292:	50                   	push   %eax
  800293:	ff 75 10             	pushl  0x10(%ebp)
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	e8 05 00 00 00       	call   8002a6 <vprintfmt>
}
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <vprintfmt>:
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 3c             	sub    $0x3c,%esp
  8002af:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b8:	eb 0a                	jmp    8002c4 <vprintfmt+0x1e>
			putch(ch, putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	53                   	push   %ebx
  8002be:	50                   	push   %eax
  8002bf:	ff d6                	call   *%esi
  8002c1:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002c4:	83 c7 01             	add    $0x1,%edi
  8002c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002cb:	83 f8 25             	cmp    $0x25,%eax
  8002ce:	74 0c                	je     8002dc <vprintfmt+0x36>
			if (ch == '\0')
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	75 e6                	jne    8002ba <vprintfmt+0x14>
}
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    
		padc = ' ';
  8002dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 ba 03 00 00    	ja     8006c8 <vprintfmt+0x422>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
  800318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80031f:	eb d9                	jmp    8002fa <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800324:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800328:	eb d0                	jmp    8002fa <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	0f b6 d2             	movzbl %dl,%edx
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800338:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80033f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800342:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800345:	83 f9 09             	cmp    $0x9,%ecx
  800348:	77 55                	ja     80039f <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80034a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034d:	eb e9                	jmp    800338 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80034f:	8b 45 14             	mov    0x14(%ebp),%eax
  800352:	8b 00                	mov    (%eax),%eax
  800354:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 40 04             	lea    0x4(%eax),%eax
  80035d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800363:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800367:	79 91                	jns    8002fa <vprintfmt+0x54>
				width = precision, precision = -1;
  800369:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800376:	eb 82                	jmp    8002fa <vprintfmt+0x54>
  800378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037b:	85 c0                	test   %eax,%eax
  80037d:	ba 00 00 00 00       	mov    $0x0,%edx
  800382:	0f 49 d0             	cmovns %eax,%edx
  800385:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038b:	e9 6a ff ff ff       	jmp    8002fa <vprintfmt+0x54>
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800393:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80039a:	e9 5b ff ff ff       	jmp    8002fa <vprintfmt+0x54>
  80039f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a5:	eb bc                	jmp    800363 <vprintfmt+0xbd>
			lflag++;
  8003a7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ad:	e9 48 ff ff ff       	jmp    8002fa <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 78 04             	lea    0x4(%eax),%edi
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	53                   	push   %ebx
  8003bc:	ff 30                	pushl  (%eax)
  8003be:	ff d6                	call   *%esi
			break;
  8003c0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c6:	e9 9c 02 00 00       	jmp    800667 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8d 78 04             	lea    0x4(%eax),%edi
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	99                   	cltd   
  8003d4:	31 d0                	xor    %edx,%eax
  8003d6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d8:	83 f8 0f             	cmp    $0xf,%eax
  8003db:	7f 23                	jg     800400 <vprintfmt+0x15a>
  8003dd:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  8003e4:	85 d2                	test   %edx,%edx
  8003e6:	74 18                	je     800400 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8003e8:	52                   	push   %edx
  8003e9:	68 06 2d 80 00       	push   $0x802d06
  8003ee:	53                   	push   %ebx
  8003ef:	56                   	push   %esi
  8003f0:	e8 94 fe ff ff       	call   800289 <printfmt>
  8003f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fb:	e9 67 02 00 00       	jmp    800667 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800400:	50                   	push   %eax
  800401:	68 d8 27 80 00       	push   $0x8027d8
  800406:	53                   	push   %ebx
  800407:	56                   	push   %esi
  800408:	e8 7c fe ff ff       	call   800289 <printfmt>
  80040d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800410:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800413:	e9 4f 02 00 00       	jmp    800667 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	83 c0 04             	add    $0x4,%eax
  80041e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800426:	85 d2                	test   %edx,%edx
  800428:	b8 d1 27 80 00       	mov    $0x8027d1,%eax
  80042d:	0f 45 c2             	cmovne %edx,%eax
  800430:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800433:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800437:	7e 06                	jle    80043f <vprintfmt+0x199>
  800439:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043d:	75 0d                	jne    80044c <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800442:	89 c7                	mov    %eax,%edi
  800444:	03 45 e0             	add    -0x20(%ebp),%eax
  800447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044a:	eb 3f                	jmp    80048b <vprintfmt+0x1e5>
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	ff 75 d8             	pushl  -0x28(%ebp)
  800452:	50                   	push   %eax
  800453:	e8 0d 03 00 00       	call   800765 <strnlen>
  800458:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045b:	29 c2                	sub    %eax,%edx
  80045d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800465:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800469:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	85 ff                	test   %edi,%edi
  80046e:	7e 58                	jle    8004c8 <vprintfmt+0x222>
					putch(padc, putdat);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	ff 75 e0             	pushl  -0x20(%ebp)
  800477:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800479:	83 ef 01             	sub    $0x1,%edi
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	eb eb                	jmp    80046c <vprintfmt+0x1c6>
					putch(ch, putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	53                   	push   %ebx
  800485:	52                   	push   %edx
  800486:	ff d6                	call   *%esi
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800490:	83 c7 01             	add    $0x1,%edi
  800493:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800497:	0f be d0             	movsbl %al,%edx
  80049a:	85 d2                	test   %edx,%edx
  80049c:	74 45                	je     8004e3 <vprintfmt+0x23d>
  80049e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a2:	78 06                	js     8004aa <vprintfmt+0x204>
  8004a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a8:	78 35                	js     8004df <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ae:	74 d1                	je     800481 <vprintfmt+0x1db>
  8004b0:	0f be c0             	movsbl %al,%eax
  8004b3:	83 e8 20             	sub    $0x20,%eax
  8004b6:	83 f8 5e             	cmp    $0x5e,%eax
  8004b9:	76 c6                	jbe    800481 <vprintfmt+0x1db>
					putch('?', putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	6a 3f                	push   $0x3f
  8004c1:	ff d6                	call   *%esi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	eb c3                	jmp    80048b <vprintfmt+0x1e5>
  8004c8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004cb:	85 d2                	test   %edx,%edx
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d2:	0f 49 c2             	cmovns %edx,%eax
  8004d5:	29 c2                	sub    %eax,%edx
  8004d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004da:	e9 60 ff ff ff       	jmp    80043f <vprintfmt+0x199>
  8004df:	89 cf                	mov    %ecx,%edi
  8004e1:	eb 02                	jmp    8004e5 <vprintfmt+0x23f>
  8004e3:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8004e5:	85 ff                	test   %edi,%edi
  8004e7:	7e 10                	jle    8004f9 <vprintfmt+0x253>
				putch(' ', putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	6a 20                	push   $0x20
  8004ef:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f1:	83 ef 01             	sub    $0x1,%edi
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	eb ec                	jmp    8004e5 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	e9 63 01 00 00       	jmp    800667 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800504:	83 f9 01             	cmp    $0x1,%ecx
  800507:	7f 1b                	jg     800524 <vprintfmt+0x27e>
	else if (lflag)
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	74 63                	je     800570 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	99                   	cltd   
  800516:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	eb 17                	jmp    80053b <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 50 04             	mov    0x4(%eax),%edx
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8d 40 08             	lea    0x8(%eax),%eax
  800538:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800541:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800546:	85 c9                	test   %ecx,%ecx
  800548:	0f 89 ff 00 00 00    	jns    80064d <vprintfmt+0x3a7>
				putch('-', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	53                   	push   %ebx
  800552:	6a 2d                	push   $0x2d
  800554:	ff d6                	call   *%esi
				num = -(long long) num;
  800556:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800559:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055c:	f7 da                	neg    %edx
  80055e:	83 d1 00             	adc    $0x0,%ecx
  800561:	f7 d9                	neg    %ecx
  800563:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 dd 00 00 00       	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb b4                	jmp    80053b <vprintfmt+0x295>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7f 1e                	jg     8005aa <vprintfmt+0x304>
	else if (lflag)
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	74 32                	je     8005c2 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 10                	mov    (%eax),%edx
  800595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a5:	e9 a3 00 00 00       	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 10                	mov    (%eax),%edx
  8005af:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bd:	e9 8b 00 00 00       	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	8d 40 04             	lea    0x4(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d7:	eb 74                	jmp    80064d <vprintfmt+0x3a7>
	if (lflag >= 2)
  8005d9:	83 f9 01             	cmp    $0x1,%ecx
  8005dc:	7f 1b                	jg     8005f9 <vprintfmt+0x353>
	else if (lflag)
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	74 2c                	je     80060e <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f7:	eb 54                	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 10                	mov    (%eax),%edx
  8005fe:	8b 48 04             	mov    0x4(%eax),%ecx
  800601:	8d 40 08             	lea    0x8(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800607:	b8 08 00 00 00       	mov    $0x8,%eax
  80060c:	eb 3f                	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061e:	b8 08 00 00 00       	mov    $0x8,%eax
  800623:	eb 28                	jmp    80064d <vprintfmt+0x3a7>
			putch('0', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 30                	push   $0x30
  80062b:	ff d6                	call   *%esi
			putch('x', putdat);
  80062d:	83 c4 08             	add    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	6a 78                	push   $0x78
  800633:	ff d6                	call   *%esi
			num = (unsigned long long)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80063f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80064d:	83 ec 0c             	sub    $0xc,%esp
  800650:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800654:	57                   	push   %edi
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	50                   	push   %eax
  800659:	51                   	push   %ecx
  80065a:	52                   	push   %edx
  80065b:	89 da                	mov    %ebx,%edx
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	e8 5a fb ff ff       	call   8001be <printnum>
			break;
  800664:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066a:	e9 55 fc ff ff       	jmp    8002c4 <vprintfmt+0x1e>
	if (lflag >= 2)
  80066f:	83 f9 01             	cmp    $0x1,%ecx
  800672:	7f 1b                	jg     80068f <vprintfmt+0x3e9>
	else if (lflag)
  800674:	85 c9                	test   %ecx,%ecx
  800676:	74 2c                	je     8006a4 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800688:	b8 10 00 00 00       	mov    $0x10,%eax
  80068d:	eb be                	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	8b 48 04             	mov    0x4(%eax),%ecx
  800697:	8d 40 08             	lea    0x8(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069d:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a2:	eb a9                	jmp    80064d <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 10                	mov    (%eax),%edx
  8006a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b9:	eb 92                	jmp    80064d <vprintfmt+0x3a7>
			putch(ch, putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 25                	push   $0x25
  8006c1:	ff d6                	call   *%esi
			break;
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	eb 9f                	jmp    800667 <vprintfmt+0x3c1>
			putch('%', putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 25                	push   $0x25
  8006ce:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 f8                	mov    %edi,%eax
  8006d5:	eb 03                	jmp    8006da <vprintfmt+0x434>
  8006d7:	83 e8 01             	sub    $0x1,%eax
  8006da:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006de:	75 f7                	jne    8006d7 <vprintfmt+0x431>
  8006e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e3:	eb 82                	jmp    800667 <vprintfmt+0x3c1>

008006e5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 18             	sub    $0x18,%esp
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800702:	85 c0                	test   %eax,%eax
  800704:	74 26                	je     80072c <vsnprintf+0x47>
  800706:	85 d2                	test   %edx,%edx
  800708:	7e 22                	jle    80072c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070a:	ff 75 14             	pushl  0x14(%ebp)
  80070d:	ff 75 10             	pushl  0x10(%ebp)
  800710:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	68 6c 02 80 00       	push   $0x80026c
  800719:	e8 88 fb ff ff       	call   8002a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80071e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800721:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800727:	83 c4 10             	add    $0x10,%esp
}
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    
		return -E_INVAL;
  80072c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800731:	eb f7                	jmp    80072a <vsnprintf+0x45>

00800733 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800739:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80073c:	50                   	push   %eax
  80073d:	ff 75 10             	pushl  0x10(%ebp)
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	ff 75 08             	pushl  0x8(%ebp)
  800746:	e8 9a ff ff ff       	call   8006e5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80075c:	74 05                	je     800763 <strlen+0x16>
		n++;
  80075e:	83 c0 01             	add    $0x1,%eax
  800761:	eb f5                	jmp    800758 <strlen+0xb>
	return n;
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076e:	ba 00 00 00 00       	mov    $0x0,%edx
  800773:	39 c2                	cmp    %eax,%edx
  800775:	74 0d                	je     800784 <strnlen+0x1f>
  800777:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80077b:	74 05                	je     800782 <strnlen+0x1d>
		n++;
  80077d:	83 c2 01             	add    $0x1,%edx
  800780:	eb f1                	jmp    800773 <strnlen+0xe>
  800782:	89 d0                	mov    %edx,%eax
	return n;
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	53                   	push   %ebx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
  800795:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800799:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80079c:	83 c2 01             	add    $0x1,%edx
  80079f:	84 c9                	test   %cl,%cl
  8007a1:	75 f2                	jne    800795 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007a3:	5b                   	pop    %ebx
  8007a4:	5d                   	pop    %ebp
  8007a5:	c3                   	ret    

008007a6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	53                   	push   %ebx
  8007aa:	83 ec 10             	sub    $0x10,%esp
  8007ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b0:	53                   	push   %ebx
  8007b1:	e8 97 ff ff ff       	call   80074d <strlen>
  8007b6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	01 d8                	add    %ebx,%eax
  8007be:	50                   	push   %eax
  8007bf:	e8 c2 ff ff ff       	call   800786 <strcpy>
	return dst;
}
  8007c4:	89 d8                	mov    %ebx,%eax
  8007c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	56                   	push   %esi
  8007cf:	53                   	push   %ebx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d6:	89 c6                	mov    %eax,%esi
  8007d8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	39 f2                	cmp    %esi,%edx
  8007df:	74 11                	je     8007f2 <strncpy+0x27>
		*dst++ = *src;
  8007e1:	83 c2 01             	add    $0x1,%edx
  8007e4:	0f b6 19             	movzbl (%ecx),%ebx
  8007e7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ea:	80 fb 01             	cmp    $0x1,%bl
  8007ed:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8007f0:	eb eb                	jmp    8007dd <strncpy+0x12>
	}
	return ret;
}
  8007f2:	5b                   	pop    %ebx
  8007f3:	5e                   	pop    %esi
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	56                   	push   %esi
  8007fa:	53                   	push   %ebx
  8007fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800801:	8b 55 10             	mov    0x10(%ebp),%edx
  800804:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800806:	85 d2                	test   %edx,%edx
  800808:	74 21                	je     80082b <strlcpy+0x35>
  80080a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80080e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800810:	39 c2                	cmp    %eax,%edx
  800812:	74 14                	je     800828 <strlcpy+0x32>
  800814:	0f b6 19             	movzbl (%ecx),%ebx
  800817:	84 db                	test   %bl,%bl
  800819:	74 0b                	je     800826 <strlcpy+0x30>
			*dst++ = *src++;
  80081b:	83 c1 01             	add    $0x1,%ecx
  80081e:	83 c2 01             	add    $0x1,%edx
  800821:	88 5a ff             	mov    %bl,-0x1(%edx)
  800824:	eb ea                	jmp    800810 <strlcpy+0x1a>
  800826:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800828:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082b:	29 f0                	sub    %esi,%eax
}
  80082d:	5b                   	pop    %ebx
  80082e:	5e                   	pop    %esi
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800837:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083a:	0f b6 01             	movzbl (%ecx),%eax
  80083d:	84 c0                	test   %al,%al
  80083f:	74 0c                	je     80084d <strcmp+0x1c>
  800841:	3a 02                	cmp    (%edx),%al
  800843:	75 08                	jne    80084d <strcmp+0x1c>
		p++, q++;
  800845:	83 c1 01             	add    $0x1,%ecx
  800848:	83 c2 01             	add    $0x1,%edx
  80084b:	eb ed                	jmp    80083a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80084d:	0f b6 c0             	movzbl %al,%eax
  800850:	0f b6 12             	movzbl (%edx),%edx
  800853:	29 d0                	sub    %edx,%eax
}
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800861:	89 c3                	mov    %eax,%ebx
  800863:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800866:	eb 06                	jmp    80086e <strncmp+0x17>
		n--, p++, q++;
  800868:	83 c0 01             	add    $0x1,%eax
  80086b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80086e:	39 d8                	cmp    %ebx,%eax
  800870:	74 16                	je     800888 <strncmp+0x31>
  800872:	0f b6 08             	movzbl (%eax),%ecx
  800875:	84 c9                	test   %cl,%cl
  800877:	74 04                	je     80087d <strncmp+0x26>
  800879:	3a 0a                	cmp    (%edx),%cl
  80087b:	74 eb                	je     800868 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80087d:	0f b6 00             	movzbl (%eax),%eax
  800880:	0f b6 12             	movzbl (%edx),%edx
  800883:	29 d0                	sub    %edx,%eax
}
  800885:	5b                   	pop    %ebx
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    
		return 0;
  800888:	b8 00 00 00 00       	mov    $0x0,%eax
  80088d:	eb f6                	jmp    800885 <strncmp+0x2e>

0080088f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800899:	0f b6 10             	movzbl (%eax),%edx
  80089c:	84 d2                	test   %dl,%dl
  80089e:	74 09                	je     8008a9 <strchr+0x1a>
		if (*s == c)
  8008a0:	38 ca                	cmp    %cl,%dl
  8008a2:	74 0a                	je     8008ae <strchr+0x1f>
	for (; *s; s++)
  8008a4:	83 c0 01             	add    $0x1,%eax
  8008a7:	eb f0                	jmp    800899 <strchr+0xa>
			return (char *) s;
	return 0;
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ba:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008bd:	38 ca                	cmp    %cl,%dl
  8008bf:	74 09                	je     8008ca <strfind+0x1a>
  8008c1:	84 d2                	test   %dl,%dl
  8008c3:	74 05                	je     8008ca <strfind+0x1a>
	for (; *s; s++)
  8008c5:	83 c0 01             	add    $0x1,%eax
  8008c8:	eb f0                	jmp    8008ba <strfind+0xa>
			break;
	return (char *) s;
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	57                   	push   %edi
  8008d0:	56                   	push   %esi
  8008d1:	53                   	push   %ebx
  8008d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d8:	85 c9                	test   %ecx,%ecx
  8008da:	74 31                	je     80090d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008dc:	89 f8                	mov    %edi,%eax
  8008de:	09 c8                	or     %ecx,%eax
  8008e0:	a8 03                	test   $0x3,%al
  8008e2:	75 23                	jne    800907 <memset+0x3b>
		c &= 0xFF;
  8008e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e8:	89 d3                	mov    %edx,%ebx
  8008ea:	c1 e3 08             	shl    $0x8,%ebx
  8008ed:	89 d0                	mov    %edx,%eax
  8008ef:	c1 e0 18             	shl    $0x18,%eax
  8008f2:	89 d6                	mov    %edx,%esi
  8008f4:	c1 e6 10             	shl    $0x10,%esi
  8008f7:	09 f0                	or     %esi,%eax
  8008f9:	09 c2                	or     %eax,%edx
  8008fb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008fd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800900:	89 d0                	mov    %edx,%eax
  800902:	fc                   	cld    
  800903:	f3 ab                	rep stos %eax,%es:(%edi)
  800905:	eb 06                	jmp    80090d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	fc                   	cld    
  80090b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80090d:	89 f8                	mov    %edi,%eax
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5f                   	pop    %edi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	57                   	push   %edi
  800918:	56                   	push   %esi
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80091f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800922:	39 c6                	cmp    %eax,%esi
  800924:	73 32                	jae    800958 <memmove+0x44>
  800926:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	76 2b                	jbe    800958 <memmove+0x44>
		s += n;
		d += n;
  80092d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800930:	89 fe                	mov    %edi,%esi
  800932:	09 ce                	or     %ecx,%esi
  800934:	09 d6                	or     %edx,%esi
  800936:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80093c:	75 0e                	jne    80094c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80093e:	83 ef 04             	sub    $0x4,%edi
  800941:	8d 72 fc             	lea    -0x4(%edx),%esi
  800944:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800947:	fd                   	std    
  800948:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094a:	eb 09                	jmp    800955 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094c:	83 ef 01             	sub    $0x1,%edi
  80094f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800952:	fd                   	std    
  800953:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800955:	fc                   	cld    
  800956:	eb 1a                	jmp    800972 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800958:	89 c2                	mov    %eax,%edx
  80095a:	09 ca                	or     %ecx,%edx
  80095c:	09 f2                	or     %esi,%edx
  80095e:	f6 c2 03             	test   $0x3,%dl
  800961:	75 0a                	jne    80096d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800963:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800966:	89 c7                	mov    %eax,%edi
  800968:	fc                   	cld    
  800969:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096b:	eb 05                	jmp    800972 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80096d:	89 c7                	mov    %eax,%edi
  80096f:	fc                   	cld    
  800970:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800972:	5e                   	pop    %esi
  800973:	5f                   	pop    %edi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80097c:	ff 75 10             	pushl  0x10(%ebp)
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 8a ff ff ff       	call   800914 <memmove>
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
  800997:	89 c6                	mov    %eax,%esi
  800999:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80099c:	39 f0                	cmp    %esi,%eax
  80099e:	74 1c                	je     8009bc <memcmp+0x30>
		if (*s1 != *s2)
  8009a0:	0f b6 08             	movzbl (%eax),%ecx
  8009a3:	0f b6 1a             	movzbl (%edx),%ebx
  8009a6:	38 d9                	cmp    %bl,%cl
  8009a8:	75 08                	jne    8009b2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	eb ea                	jmp    80099c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009b2:	0f b6 c1             	movzbl %cl,%eax
  8009b5:	0f b6 db             	movzbl %bl,%ebx
  8009b8:	29 d8                	sub    %ebx,%eax
  8009ba:	eb 05                	jmp    8009c1 <memcmp+0x35>
	}

	return 0;
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ce:	89 c2                	mov    %eax,%edx
  8009d0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009d3:	39 d0                	cmp    %edx,%eax
  8009d5:	73 09                	jae    8009e0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009d7:	38 08                	cmp    %cl,(%eax)
  8009d9:	74 05                	je     8009e0 <memfind+0x1b>
	for (; s < ends; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	eb f3                	jmp    8009d3 <memfind+0xe>
			break;
	return (void *) s;
}
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ee:	eb 03                	jmp    8009f3 <strtol+0x11>
		s++;
  8009f0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	3c 20                	cmp    $0x20,%al
  8009f8:	74 f6                	je     8009f0 <strtol+0xe>
  8009fa:	3c 09                	cmp    $0x9,%al
  8009fc:	74 f2                	je     8009f0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009fe:	3c 2b                	cmp    $0x2b,%al
  800a00:	74 2a                	je     800a2c <strtol+0x4a>
	int neg = 0;
  800a02:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a07:	3c 2d                	cmp    $0x2d,%al
  800a09:	74 2b                	je     800a36 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a11:	75 0f                	jne    800a22 <strtol+0x40>
  800a13:	80 39 30             	cmpb   $0x30,(%ecx)
  800a16:	74 28                	je     800a40 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a1f:	0f 44 d8             	cmove  %eax,%ebx
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
  800a27:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a2a:	eb 50                	jmp    800a7c <strtol+0x9a>
		s++;
  800a2c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a34:	eb d5                	jmp    800a0b <strtol+0x29>
		s++, neg = 1;
  800a36:	83 c1 01             	add    $0x1,%ecx
  800a39:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3e:	eb cb                	jmp    800a0b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a40:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a44:	74 0e                	je     800a54 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a46:	85 db                	test   %ebx,%ebx
  800a48:	75 d8                	jne    800a22 <strtol+0x40>
		s++, base = 8;
  800a4a:	83 c1 01             	add    $0x1,%ecx
  800a4d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a52:	eb ce                	jmp    800a22 <strtol+0x40>
		s += 2, base = 16;
  800a54:	83 c1 02             	add    $0x2,%ecx
  800a57:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a5c:	eb c4                	jmp    800a22 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a5e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a61:	89 f3                	mov    %esi,%ebx
  800a63:	80 fb 19             	cmp    $0x19,%bl
  800a66:	77 29                	ja     800a91 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800a68:	0f be d2             	movsbl %dl,%edx
  800a6b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a6e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a71:	7d 30                	jge    800aa3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800a73:	83 c1 01             	add    $0x1,%ecx
  800a76:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a7a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a7c:	0f b6 11             	movzbl (%ecx),%edx
  800a7f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a82:	89 f3                	mov    %esi,%ebx
  800a84:	80 fb 09             	cmp    $0x9,%bl
  800a87:	77 d5                	ja     800a5e <strtol+0x7c>
			dig = *s - '0';
  800a89:	0f be d2             	movsbl %dl,%edx
  800a8c:	83 ea 30             	sub    $0x30,%edx
  800a8f:	eb dd                	jmp    800a6e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800a91:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a94:	89 f3                	mov    %esi,%ebx
  800a96:	80 fb 19             	cmp    $0x19,%bl
  800a99:	77 08                	ja     800aa3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800a9b:	0f be d2             	movsbl %dl,%edx
  800a9e:	83 ea 37             	sub    $0x37,%edx
  800aa1:	eb cb                	jmp    800a6e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aa3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa7:	74 05                	je     800aae <strtol+0xcc>
		*endptr = (char *) s;
  800aa9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aac:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aae:	89 c2                	mov    %eax,%edx
  800ab0:	f7 da                	neg    %edx
  800ab2:	85 ff                	test   %edi,%edi
  800ab4:	0f 45 c2             	cmovne %edx,%eax
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5e                   	pop    %esi
  800ab9:	5f                   	pop    %edi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acd:	89 c3                	mov    %eax,%ebx
  800acf:	89 c7                	mov    %eax,%edi
  800ad1:	89 c6                	mov    %eax,%esi
  800ad3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5f                   	pop    %edi
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <sys_cgetc>:

int
sys_cgetc(void)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	57                   	push   %edi
  800ade:	56                   	push   %esi
  800adf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae5:	b8 01 00 00 00       	mov    $0x1,%eax
  800aea:	89 d1                	mov    %edx,%ecx
  800aec:	89 d3                	mov    %edx,%ebx
  800aee:	89 d7                	mov    %edx,%edi
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5f                   	pop    %edi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b0f:	89 cb                	mov    %ecx,%ebx
  800b11:	89 cf                	mov    %ecx,%edi
  800b13:	89 ce                	mov    %ecx,%esi
  800b15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b17:	85 c0                	test   %eax,%eax
  800b19:	7f 08                	jg     800b23 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b23:	83 ec 0c             	sub    $0xc,%esp
  800b26:	50                   	push   %eax
  800b27:	6a 03                	push   $0x3
  800b29:	68 bf 2a 80 00       	push   $0x802abf
  800b2e:	6a 23                	push   $0x23
  800b30:	68 dc 2a 80 00       	push   $0x802adc
  800b35:	e8 56 17 00 00       	call   802290 <_panic>

00800b3a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	57                   	push   %edi
  800b3e:	56                   	push   %esi
  800b3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b40:	ba 00 00 00 00       	mov    $0x0,%edx
  800b45:	b8 02 00 00 00       	mov    $0x2,%eax
  800b4a:	89 d1                	mov    %edx,%ecx
  800b4c:	89 d3                	mov    %edx,%ebx
  800b4e:	89 d7                	mov    %edx,%edi
  800b50:	89 d6                	mov    %edx,%esi
  800b52:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5f                   	pop    %edi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <sys_yield>:

void
sys_yield(void)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	57                   	push   %edi
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b69:	89 d1                	mov    %edx,%ecx
  800b6b:	89 d3                	mov    %edx,%ebx
  800b6d:	89 d7                	mov    %edx,%edi
  800b6f:	89 d6                	mov    %edx,%esi
  800b71:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	57                   	push   %edi
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b81:	be 00 00 00 00       	mov    $0x0,%esi
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8c:	b8 04 00 00 00       	mov    $0x4,%eax
  800b91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b94:	89 f7                	mov    %esi,%edi
  800b96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	7f 08                	jg     800ba4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba4:	83 ec 0c             	sub    $0xc,%esp
  800ba7:	50                   	push   %eax
  800ba8:	6a 04                	push   $0x4
  800baa:	68 bf 2a 80 00       	push   $0x802abf
  800baf:	6a 23                	push   $0x23
  800bb1:	68 dc 2a 80 00       	push   $0x802adc
  800bb6:	e8 d5 16 00 00       	call   802290 <_panic>

00800bbb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bca:	b8 05 00 00 00       	mov    $0x5,%eax
  800bcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bd5:	8b 75 18             	mov    0x18(%ebp),%esi
  800bd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	7f 08                	jg     800be6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	50                   	push   %eax
  800bea:	6a 05                	push   $0x5
  800bec:	68 bf 2a 80 00       	push   $0x802abf
  800bf1:	6a 23                	push   $0x23
  800bf3:	68 dc 2a 80 00       	push   $0x802adc
  800bf8:	e8 93 16 00 00       	call   802290 <_panic>

00800bfd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
  800c03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	b8 06 00 00 00       	mov    $0x6,%eax
  800c16:	89 df                	mov    %ebx,%edi
  800c18:	89 de                	mov    %ebx,%esi
  800c1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	7f 08                	jg     800c28 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	50                   	push   %eax
  800c2c:	6a 06                	push   $0x6
  800c2e:	68 bf 2a 80 00       	push   $0x802abf
  800c33:	6a 23                	push   $0x23
  800c35:	68 dc 2a 80 00       	push   $0x802adc
  800c3a:	e8 51 16 00 00       	call   802290 <_panic>

00800c3f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	b8 08 00 00 00       	mov    $0x8,%eax
  800c58:	89 df                	mov    %ebx,%edi
  800c5a:	89 de                	mov    %ebx,%esi
  800c5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	7f 08                	jg     800c6a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	6a 08                	push   $0x8
  800c70:	68 bf 2a 80 00       	push   $0x802abf
  800c75:	6a 23                	push   $0x23
  800c77:	68 dc 2a 80 00       	push   $0x802adc
  800c7c:	e8 0f 16 00 00       	call   802290 <_panic>

00800c81 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c95:	b8 09 00 00 00       	mov    $0x9,%eax
  800c9a:	89 df                	mov    %ebx,%edi
  800c9c:	89 de                	mov    %ebx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 09                	push   $0x9
  800cb2:	68 bf 2a 80 00       	push   $0x802abf
  800cb7:	6a 23                	push   $0x23
  800cb9:	68 dc 2a 80 00       	push   $0x802adc
  800cbe:	e8 cd 15 00 00       	call   802290 <_panic>

00800cc3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cdc:	89 df                	mov    %ebx,%edi
  800cde:	89 de                	mov    %ebx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 0a                	push   $0xa
  800cf4:	68 bf 2a 80 00       	push   $0x802abf
  800cf9:	6a 23                	push   $0x23
  800cfb:	68 dc 2a 80 00       	push   $0x802adc
  800d00:	e8 8b 15 00 00       	call   802290 <_panic>

00800d05 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d16:	be 00 00 00 00       	mov    $0x0,%esi
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d21:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d3e:	89 cb                	mov    %ecx,%ebx
  800d40:	89 cf                	mov    %ecx,%edi
  800d42:	89 ce                	mov    %ecx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 0d                	push   $0xd
  800d58:	68 bf 2a 80 00       	push   $0x802abf
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 dc 2a 80 00       	push   $0x802adc
  800d64:	e8 27 15 00 00       	call   802290 <_panic>

00800d69 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d79:	89 d1                	mov    %edx,%ecx
  800d7b:	89 d3                	mov    %edx,%ebx
  800d7d:	89 d7                	mov    %edx,%edi
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800d94:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800d96:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800d99:	89 d9                	mov    %ebx,%ecx
  800d9b:	c1 e9 16             	shr    $0x16,%ecx
  800d9e:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800da5:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800daa:	f6 c1 01             	test   $0x1,%cl
  800dad:	74 0c                	je     800dbb <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800daf:	89 d9                	mov    %ebx,%ecx
  800db1:	c1 e9 0c             	shr    $0xc,%ecx
  800db4:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800dbb:	f6 c2 02             	test   $0x2,%dl
  800dbe:	0f 84 a3 00 00 00    	je     800e67 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800dc4:	89 da                	mov    %ebx,%edx
  800dc6:	c1 ea 0c             	shr    $0xc,%edx
  800dc9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd0:	f6 c6 08             	test   $0x8,%dh
  800dd3:	0f 84 b7 00 00 00    	je     800e90 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800dd9:	e8 5c fd ff ff       	call   800b3a <sys_getenvid>
  800dde:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	6a 07                	push   $0x7
  800de5:	68 00 f0 7f 00       	push   $0x7ff000
  800dea:	50                   	push   %eax
  800deb:	e8 88 fd ff ff       	call   800b78 <sys_page_alloc>
  800df0:	83 c4 10             	add    $0x10,%esp
  800df3:	85 c0                	test   %eax,%eax
  800df5:	0f 88 bc 00 00 00    	js     800eb7 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800dfb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e01:	83 ec 04             	sub    $0x4,%esp
  800e04:	68 00 10 00 00       	push   $0x1000
  800e09:	53                   	push   %ebx
  800e0a:	68 00 f0 7f 00       	push   $0x7ff000
  800e0f:	e8 00 fb ff ff       	call   800914 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e14:	83 c4 08             	add    $0x8,%esp
  800e17:	53                   	push   %ebx
  800e18:	56                   	push   %esi
  800e19:	e8 df fd ff ff       	call   800bfd <sys_page_unmap>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	85 c0                	test   %eax,%eax
  800e23:	0f 88 a0 00 00 00    	js     800ec9 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	6a 07                	push   $0x7
  800e2e:	53                   	push   %ebx
  800e2f:	56                   	push   %esi
  800e30:	68 00 f0 7f 00       	push   $0x7ff000
  800e35:	56                   	push   %esi
  800e36:	e8 80 fd ff ff       	call   800bbb <sys_page_map>
  800e3b:	83 c4 20             	add    $0x20,%esp
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	0f 88 95 00 00 00    	js     800edb <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	68 00 f0 7f 00       	push   $0x7ff000
  800e4e:	56                   	push   %esi
  800e4f:	e8 a9 fd ff ff       	call   800bfd <sys_page_unmap>
  800e54:	83 c4 10             	add    $0x10,%esp
  800e57:	85 c0                	test   %eax,%eax
  800e59:	0f 88 8e 00 00 00    	js     800eed <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800e67:	8b 70 28             	mov    0x28(%eax),%esi
  800e6a:	e8 cb fc ff ff       	call   800b3a <sys_getenvid>
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	50                   	push   %eax
  800e72:	68 ec 2a 80 00       	push   $0x802aec
  800e77:	e8 2e f3 ff ff       	call   8001aa <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800e7c:	83 c4 0c             	add    $0xc,%esp
  800e7f:	68 10 2b 80 00       	push   $0x802b10
  800e84:	6a 27                	push   $0x27
  800e86:	68 e4 2b 80 00       	push   $0x802be4
  800e8b:	e8 00 14 00 00       	call   802290 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800e90:	8b 78 28             	mov    0x28(%eax),%edi
  800e93:	e8 a2 fc ff ff       	call   800b3a <sys_getenvid>
  800e98:	57                   	push   %edi
  800e99:	53                   	push   %ebx
  800e9a:	50                   	push   %eax
  800e9b:	68 ec 2a 80 00       	push   $0x802aec
  800ea0:	e8 05 f3 ff ff       	call   8001aa <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800ea5:	56                   	push   %esi
  800ea6:	68 44 2b 80 00       	push   $0x802b44
  800eab:	6a 2b                	push   $0x2b
  800ead:	68 e4 2b 80 00       	push   $0x802be4
  800eb2:	e8 d9 13 00 00       	call   802290 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800eb7:	50                   	push   %eax
  800eb8:	68 7c 2b 80 00       	push   $0x802b7c
  800ebd:	6a 39                	push   $0x39
  800ebf:	68 e4 2b 80 00       	push   $0x802be4
  800ec4:	e8 c7 13 00 00       	call   802290 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800ec9:	50                   	push   %eax
  800eca:	68 a0 2b 80 00       	push   $0x802ba0
  800ecf:	6a 3e                	push   $0x3e
  800ed1:	68 e4 2b 80 00       	push   $0x802be4
  800ed6:	e8 b5 13 00 00       	call   802290 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800edb:	50                   	push   %eax
  800edc:	68 ef 2b 80 00       	push   $0x802bef
  800ee1:	6a 40                	push   $0x40
  800ee3:	68 e4 2b 80 00       	push   $0x802be4
  800ee8:	e8 a3 13 00 00       	call   802290 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800eed:	50                   	push   %eax
  800eee:	68 a0 2b 80 00       	push   $0x802ba0
  800ef3:	6a 42                	push   $0x42
  800ef5:	68 e4 2b 80 00       	push   $0x802be4
  800efa:	e8 91 13 00 00       	call   802290 <_panic>

00800eff <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f08:	68 88 0d 80 00       	push   $0x800d88
  800f0d:	e8 c4 13 00 00       	call   8022d6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f12:	b8 07 00 00 00       	mov    $0x7,%eax
  800f17:	cd 30                	int    $0x30
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 2d                	js     800f50 <fork+0x51>
  800f23:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800f2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2e:	0f 85 a6 00 00 00    	jne    800fda <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800f34:	e8 01 fc ff ff       	call   800b3a <sys_getenvid>
  800f39:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f3e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f41:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f46:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  800f4b:	e9 79 01 00 00       	jmp    8010c9 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800f50:	50                   	push   %eax
  800f51:	68 0d 2c 80 00       	push   $0x802c0d
  800f56:	68 aa 00 00 00       	push   $0xaa
  800f5b:	68 e4 2b 80 00       	push   $0x802be4
  800f60:	e8 2b 13 00 00       	call   802290 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	6a 05                	push   $0x5
  800f6a:	53                   	push   %ebx
  800f6b:	57                   	push   %edi
  800f6c:	53                   	push   %ebx
  800f6d:	6a 00                	push   $0x0
  800f6f:	e8 47 fc ff ff       	call   800bbb <sys_page_map>
  800f74:	83 c4 20             	add    $0x20,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	79 4d                	jns    800fc8 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  800f7b:	50                   	push   %eax
  800f7c:	68 16 2c 80 00       	push   $0x802c16
  800f81:	6a 61                	push   $0x61
  800f83:	68 e4 2b 80 00       	push   $0x802be4
  800f88:	e8 03 13 00 00       	call   802290 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	68 05 08 00 00       	push   $0x805
  800f95:	53                   	push   %ebx
  800f96:	57                   	push   %edi
  800f97:	53                   	push   %ebx
  800f98:	6a 00                	push   $0x0
  800f9a:	e8 1c fc ff ff       	call   800bbb <sys_page_map>
  800f9f:	83 c4 20             	add    $0x20,%esp
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	0f 88 b7 00 00 00    	js     801061 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	68 05 08 00 00       	push   $0x805
  800fb2:	53                   	push   %ebx
  800fb3:	6a 00                	push   $0x0
  800fb5:	53                   	push   %ebx
  800fb6:	6a 00                	push   $0x0
  800fb8:	e8 fe fb ff ff       	call   800bbb <sys_page_map>
  800fbd:	83 c4 20             	add    $0x20,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	0f 88 ab 00 00 00    	js     801073 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fce:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fd4:	0f 84 ab 00 00 00    	je     801085 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  800fda:	89 d8                	mov    %ebx,%eax
  800fdc:	c1 e8 16             	shr    $0x16,%eax
  800fdf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe6:	a8 01                	test   $0x1,%al
  800fe8:	74 de                	je     800fc8 <fork+0xc9>
  800fea:	89 d8                	mov    %ebx,%eax
  800fec:	c1 e8 0c             	shr    $0xc,%eax
  800fef:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff6:	f6 c2 01             	test   $0x1,%dl
  800ff9:	74 cd                	je     800fc8 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  800ffb:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 16             	shr    $0x16,%edx
  801003:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 b9                	je     800fc8 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80100f:	c1 e8 0c             	shr    $0xc,%eax
  801012:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801019:	a8 01                	test   $0x1,%al
  80101b:	74 ab                	je     800fc8 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  80101d:	a9 02 08 00 00       	test   $0x802,%eax
  801022:	0f 84 3d ff ff ff    	je     800f65 <fork+0x66>
	else if(pte & PTE_SHARE)
  801028:	f6 c4 04             	test   $0x4,%ah
  80102b:	0f 84 5c ff ff ff    	je     800f8d <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	25 07 0e 00 00       	and    $0xe07,%eax
  801039:	50                   	push   %eax
  80103a:	53                   	push   %ebx
  80103b:	57                   	push   %edi
  80103c:	53                   	push   %ebx
  80103d:	6a 00                	push   $0x0
  80103f:	e8 77 fb ff ff       	call   800bbb <sys_page_map>
  801044:	83 c4 20             	add    $0x20,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	0f 89 79 ff ff ff    	jns    800fc8 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  80104f:	50                   	push   %eax
  801050:	68 16 2c 80 00       	push   $0x802c16
  801055:	6a 67                	push   $0x67
  801057:	68 e4 2b 80 00       	push   $0x802be4
  80105c:	e8 2f 12 00 00       	call   802290 <_panic>
			panic("Page Map Failed: %e", error_code);
  801061:	50                   	push   %eax
  801062:	68 16 2c 80 00       	push   $0x802c16
  801067:	6a 6d                	push   $0x6d
  801069:	68 e4 2b 80 00       	push   $0x802be4
  80106e:	e8 1d 12 00 00       	call   802290 <_panic>
			panic("Page Map Failed: %e", error_code);
  801073:	50                   	push   %eax
  801074:	68 16 2c 80 00       	push   $0x802c16
  801079:	6a 70                	push   $0x70
  80107b:	68 e4 2b 80 00       	push   $0x802be4
  801080:	e8 0b 12 00 00       	call   802290 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	6a 07                	push   $0x7
  80108a:	68 00 f0 bf ee       	push   $0xeebff000
  80108f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801092:	e8 e1 fa ff ff       	call   800b78 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	78 36                	js     8010d4 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	68 4c 23 80 00       	push   $0x80234c
  8010a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a9:	e8 15 fc ff ff       	call   800cc3 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 34                	js     8010e9 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	6a 02                	push   $0x2
  8010ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010bd:	e8 7d fb ff ff       	call   800c3f <sys_env_set_status>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 35                	js     8010fe <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8010c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8010d4:	50                   	push   %eax
  8010d5:	68 0d 2c 80 00       	push   $0x802c0d
  8010da:	68 ba 00 00 00       	push   $0xba
  8010df:	68 e4 2b 80 00       	push   $0x802be4
  8010e4:	e8 a7 11 00 00       	call   802290 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010e9:	50                   	push   %eax
  8010ea:	68 c0 2b 80 00       	push   $0x802bc0
  8010ef:	68 bf 00 00 00       	push   $0xbf
  8010f4:	68 e4 2b 80 00       	push   $0x802be4
  8010f9:	e8 92 11 00 00       	call   802290 <_panic>
      panic("sys_env_set_status: %e", r);
  8010fe:	50                   	push   %eax
  8010ff:	68 2a 2c 80 00       	push   $0x802c2a
  801104:	68 c3 00 00 00       	push   $0xc3
  801109:	68 e4 2b 80 00       	push   $0x802be4
  80110e:	e8 7d 11 00 00       	call   802290 <_panic>

00801113 <sfork>:

// Challenge!
int
sfork(void)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801119:	68 41 2c 80 00       	push   $0x802c41
  80111e:	68 cc 00 00 00       	push   $0xcc
  801123:	68 e4 2b 80 00       	push   $0x802be4
  801128:	e8 63 11 00 00       	call   802290 <_panic>

0080112d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	05 00 00 00 30       	add    $0x30000000,%eax
  801138:	c1 e8 0c             	shr    $0xc,%eax
}
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801148:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80114d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	c1 ea 16             	shr    $0x16,%edx
  801161:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801168:	f6 c2 01             	test   $0x1,%dl
  80116b:	74 2d                	je     80119a <fd_alloc+0x46>
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	c1 ea 0c             	shr    $0xc,%edx
  801172:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801179:	f6 c2 01             	test   $0x1,%dl
  80117c:	74 1c                	je     80119a <fd_alloc+0x46>
  80117e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801183:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801188:	75 d2                	jne    80115c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801193:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801198:	eb 0a                	jmp    8011a4 <fd_alloc+0x50>
			*fd_store = fd;
  80119a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80119f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ac:	83 f8 1f             	cmp    $0x1f,%eax
  8011af:	77 30                	ja     8011e1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b1:	c1 e0 0c             	shl    $0xc,%eax
  8011b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011bf:	f6 c2 01             	test   $0x1,%dl
  8011c2:	74 24                	je     8011e8 <fd_lookup+0x42>
  8011c4:	89 c2                	mov    %eax,%edx
  8011c6:	c1 ea 0c             	shr    $0xc,%edx
  8011c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d0:	f6 c2 01             	test   $0x1,%dl
  8011d3:	74 1a                	je     8011ef <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d8:	89 02                	mov    %eax,(%edx)
	return 0;
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    
		return -E_INVAL;
  8011e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e6:	eb f7                	jmp    8011df <fd_lookup+0x39>
		return -E_INVAL;
  8011e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ed:	eb f0                	jmp    8011df <fd_lookup+0x39>
  8011ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f4:	eb e9                	jmp    8011df <fd_lookup+0x39>

008011f6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801204:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801209:	39 08                	cmp    %ecx,(%eax)
  80120b:	74 38                	je     801245 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80120d:	83 c2 01             	add    $0x1,%edx
  801210:	8b 04 95 d4 2c 80 00 	mov    0x802cd4(,%edx,4),%eax
  801217:	85 c0                	test   %eax,%eax
  801219:	75 ee                	jne    801209 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80121b:	a1 08 40 80 00       	mov    0x804008,%eax
  801220:	8b 40 48             	mov    0x48(%eax),%eax
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	51                   	push   %ecx
  801227:	50                   	push   %eax
  801228:	68 58 2c 80 00       	push   $0x802c58
  80122d:	e8 78 ef ff ff       	call   8001aa <cprintf>
	*dev = 0;
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    
			*dev = devtab[i];
  801245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801248:	89 01                	mov    %eax,(%ecx)
			return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
  80124f:	eb f2                	jmp    801243 <dev_lookup+0x4d>

00801251 <fd_close>:
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 24             	sub    $0x24,%esp
  80125a:	8b 75 08             	mov    0x8(%ebp),%esi
  80125d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801260:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801263:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801264:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80126a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80126d:	50                   	push   %eax
  80126e:	e8 33 ff ff ff       	call   8011a6 <fd_lookup>
  801273:	89 c3                	mov    %eax,%ebx
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 05                	js     801281 <fd_close+0x30>
	    || fd != fd2)
  80127c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80127f:	74 16                	je     801297 <fd_close+0x46>
		return (must_exist ? r : 0);
  801281:	89 f8                	mov    %edi,%eax
  801283:	84 c0                	test   %al,%al
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	0f 44 d8             	cmove  %eax,%ebx
}
  80128d:	89 d8                	mov    %ebx,%eax
  80128f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5f                   	pop    %edi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801297:	83 ec 08             	sub    $0x8,%esp
  80129a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	ff 36                	pushl  (%esi)
  8012a0:	e8 51 ff ff ff       	call   8011f6 <dev_lookup>
  8012a5:	89 c3                	mov    %eax,%ebx
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 1a                	js     8012c8 <fd_close+0x77>
		if (dev->dev_close)
  8012ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012b4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	74 0b                	je     8012c8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012bd:	83 ec 0c             	sub    $0xc,%esp
  8012c0:	56                   	push   %esi
  8012c1:	ff d0                	call   *%eax
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012c8:	83 ec 08             	sub    $0x8,%esp
  8012cb:	56                   	push   %esi
  8012cc:	6a 00                	push   $0x0
  8012ce:	e8 2a f9 ff ff       	call   800bfd <sys_page_unmap>
	return r;
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	eb b5                	jmp    80128d <fd_close+0x3c>

008012d8 <close>:

int
close(int fdnum)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	e8 bc fe ff ff       	call   8011a6 <fd_lookup>
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	79 02                	jns    8012f3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    
		return fd_close(fd, 1);
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	6a 01                	push   $0x1
  8012f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fb:	e8 51 ff ff ff       	call   801251 <fd_close>
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	eb ec                	jmp    8012f1 <close+0x19>

00801305 <close_all>:

void
close_all(void)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	53                   	push   %ebx
  801309:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80130c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801311:	83 ec 0c             	sub    $0xc,%esp
  801314:	53                   	push   %ebx
  801315:	e8 be ff ff ff       	call   8012d8 <close>
	for (i = 0; i < MAXFD; i++)
  80131a:	83 c3 01             	add    $0x1,%ebx
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	83 fb 20             	cmp    $0x20,%ebx
  801323:	75 ec                	jne    801311 <close_all+0xc>
}
  801325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	57                   	push   %edi
  80132e:	56                   	push   %esi
  80132f:	53                   	push   %ebx
  801330:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801333:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801336:	50                   	push   %eax
  801337:	ff 75 08             	pushl  0x8(%ebp)
  80133a:	e8 67 fe ff ff       	call   8011a6 <fd_lookup>
  80133f:	89 c3                	mov    %eax,%ebx
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	0f 88 81 00 00 00    	js     8013cd <dup+0xa3>
		return r;
	close(newfdnum);
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	e8 81 ff ff ff       	call   8012d8 <close>

	newfd = INDEX2FD(newfdnum);
  801357:	8b 75 0c             	mov    0xc(%ebp),%esi
  80135a:	c1 e6 0c             	shl    $0xc,%esi
  80135d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801363:	83 c4 04             	add    $0x4,%esp
  801366:	ff 75 e4             	pushl  -0x1c(%ebp)
  801369:	e8 cf fd ff ff       	call   80113d <fd2data>
  80136e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801370:	89 34 24             	mov    %esi,(%esp)
  801373:	e8 c5 fd ff ff       	call   80113d <fd2data>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80137d:	89 d8                	mov    %ebx,%eax
  80137f:	c1 e8 16             	shr    $0x16,%eax
  801382:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801389:	a8 01                	test   $0x1,%al
  80138b:	74 11                	je     80139e <dup+0x74>
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	c1 e8 0c             	shr    $0xc,%eax
  801392:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801399:	f6 c2 01             	test   $0x1,%dl
  80139c:	75 39                	jne    8013d7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80139e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a1:	89 d0                	mov    %edx,%eax
  8013a3:	c1 e8 0c             	shr    $0xc,%eax
  8013a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013b5:	50                   	push   %eax
  8013b6:	56                   	push   %esi
  8013b7:	6a 00                	push   $0x0
  8013b9:	52                   	push   %edx
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 fa f7 ff ff       	call   800bbb <sys_page_map>
  8013c1:	89 c3                	mov    %eax,%ebx
  8013c3:	83 c4 20             	add    $0x20,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 31                	js     8013fb <dup+0xd1>
		goto err;

	return newfdnum;
  8013ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013cd:	89 d8                	mov    %ebx,%eax
  8013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d2:	5b                   	pop    %ebx
  8013d3:	5e                   	pop    %esi
  8013d4:	5f                   	pop    %edi
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013de:	83 ec 0c             	sub    $0xc,%esp
  8013e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e6:	50                   	push   %eax
  8013e7:	57                   	push   %edi
  8013e8:	6a 00                	push   $0x0
  8013ea:	53                   	push   %ebx
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 c9 f7 ff ff       	call   800bbb <sys_page_map>
  8013f2:	89 c3                	mov    %eax,%ebx
  8013f4:	83 c4 20             	add    $0x20,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	79 a3                	jns    80139e <dup+0x74>
	sys_page_unmap(0, newfd);
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	56                   	push   %esi
  8013ff:	6a 00                	push   $0x0
  801401:	e8 f7 f7 ff ff       	call   800bfd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801406:	83 c4 08             	add    $0x8,%esp
  801409:	57                   	push   %edi
  80140a:	6a 00                	push   $0x0
  80140c:	e8 ec f7 ff ff       	call   800bfd <sys_page_unmap>
	return r;
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	eb b7                	jmp    8013cd <dup+0xa3>

00801416 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 1c             	sub    $0x1c,%esp
  80141d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	53                   	push   %ebx
  801425:	e8 7c fd ff ff       	call   8011a6 <fd_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 3f                	js     801470 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	ff 30                	pushl  (%eax)
  80143d:	e8 b4 fd ff ff       	call   8011f6 <dev_lookup>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 27                	js     801470 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144c:	8b 42 08             	mov    0x8(%edx),%eax
  80144f:	83 e0 03             	and    $0x3,%eax
  801452:	83 f8 01             	cmp    $0x1,%eax
  801455:	74 1e                	je     801475 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145a:	8b 40 08             	mov    0x8(%eax),%eax
  80145d:	85 c0                	test   %eax,%eax
  80145f:	74 35                	je     801496 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	ff 75 10             	pushl  0x10(%ebp)
  801467:	ff 75 0c             	pushl  0xc(%ebp)
  80146a:	52                   	push   %edx
  80146b:	ff d0                	call   *%eax
  80146d:	83 c4 10             	add    $0x10,%esp
}
  801470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801473:	c9                   	leave  
  801474:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801475:	a1 08 40 80 00       	mov    0x804008,%eax
  80147a:	8b 40 48             	mov    0x48(%eax),%eax
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	53                   	push   %ebx
  801481:	50                   	push   %eax
  801482:	68 99 2c 80 00       	push   $0x802c99
  801487:	e8 1e ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801494:	eb da                	jmp    801470 <read+0x5a>
		return -E_NOT_SUPP;
  801496:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149b:	eb d3                	jmp    801470 <read+0x5a>

0080149d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	57                   	push   %edi
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 0c             	sub    $0xc,%esp
  8014a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b1:	39 f3                	cmp    %esi,%ebx
  8014b3:	73 23                	jae    8014d8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	89 f0                	mov    %esi,%eax
  8014ba:	29 d8                	sub    %ebx,%eax
  8014bc:	50                   	push   %eax
  8014bd:	89 d8                	mov    %ebx,%eax
  8014bf:	03 45 0c             	add    0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	57                   	push   %edi
  8014c4:	e8 4d ff ff ff       	call   801416 <read>
		if (m < 0)
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 06                	js     8014d6 <readn+0x39>
			return m;
		if (m == 0)
  8014d0:	74 06                	je     8014d8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014d2:	01 c3                	add    %eax,%ebx
  8014d4:	eb db                	jmp    8014b1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014d8:	89 d8                	mov    %ebx,%eax
  8014da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014dd:	5b                   	pop    %ebx
  8014de:	5e                   	pop    %esi
  8014df:	5f                   	pop    %edi
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 1c             	sub    $0x1c,%esp
  8014e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	53                   	push   %ebx
  8014f1:	e8 b0 fc ff ff       	call   8011a6 <fd_lookup>
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 3a                	js     801537 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801507:	ff 30                	pushl  (%eax)
  801509:	e8 e8 fc ff ff       	call   8011f6 <dev_lookup>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 22                	js     801537 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801518:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151c:	74 1e                	je     80153c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80151e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801521:	8b 52 0c             	mov    0xc(%edx),%edx
  801524:	85 d2                	test   %edx,%edx
  801526:	74 35                	je     80155d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801528:	83 ec 04             	sub    $0x4,%esp
  80152b:	ff 75 10             	pushl  0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	50                   	push   %eax
  801532:	ff d2                	call   *%edx
  801534:	83 c4 10             	add    $0x10,%esp
}
  801537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80153c:	a1 08 40 80 00       	mov    0x804008,%eax
  801541:	8b 40 48             	mov    0x48(%eax),%eax
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	53                   	push   %ebx
  801548:	50                   	push   %eax
  801549:	68 b5 2c 80 00       	push   $0x802cb5
  80154e:	e8 57 ec ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155b:	eb da                	jmp    801537 <write+0x55>
		return -E_NOT_SUPP;
  80155d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801562:	eb d3                	jmp    801537 <write+0x55>

00801564 <seek>:

int
seek(int fdnum, off_t offset)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80156a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156d:	50                   	push   %eax
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	e8 30 fc ff ff       	call   8011a6 <fd_lookup>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 0e                	js     80158b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	53                   	push   %ebx
  801591:	83 ec 1c             	sub    $0x1c,%esp
  801594:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801597:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	53                   	push   %ebx
  80159c:	e8 05 fc ff ff       	call   8011a6 <fd_lookup>
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 37                	js     8015df <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	ff 30                	pushl  (%eax)
  8015b4:	e8 3d fc ff ff       	call   8011f6 <dev_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 1f                	js     8015df <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c7:	74 1b                	je     8015e4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cc:	8b 52 18             	mov    0x18(%edx),%edx
  8015cf:	85 d2                	test   %edx,%edx
  8015d1:	74 32                	je     801605 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	50                   	push   %eax
  8015da:	ff d2                	call   *%edx
  8015dc:	83 c4 10             	add    $0x10,%esp
}
  8015df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015e4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	50                   	push   %eax
  8015f1:	68 78 2c 80 00       	push   $0x802c78
  8015f6:	e8 af eb ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801603:	eb da                	jmp    8015df <ftruncate+0x52>
		return -E_NOT_SUPP;
  801605:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160a:	eb d3                	jmp    8015df <ftruncate+0x52>

0080160c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	53                   	push   %ebx
  801610:	83 ec 1c             	sub    $0x1c,%esp
  801613:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801616:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	e8 84 fb ff ff       	call   8011a6 <fd_lookup>
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 4b                	js     801674 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162f:	50                   	push   %eax
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	ff 30                	pushl  (%eax)
  801635:	e8 bc fb ff ff       	call   8011f6 <dev_lookup>
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 33                	js     801674 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801648:	74 2f                	je     801679 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80164a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80164d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801654:	00 00 00 
	stat->st_isdir = 0;
  801657:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80165e:	00 00 00 
	stat->st_dev = dev;
  801661:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	53                   	push   %ebx
  80166b:	ff 75 f0             	pushl  -0x10(%ebp)
  80166e:	ff 50 14             	call   *0x14(%eax)
  801671:	83 c4 10             	add    $0x10,%esp
}
  801674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801677:	c9                   	leave  
  801678:	c3                   	ret    
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167e:	eb f4                	jmp    801674 <fstat+0x68>

00801680 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	6a 00                	push   $0x0
  80168a:	ff 75 08             	pushl  0x8(%ebp)
  80168d:	e8 2f 02 00 00       	call   8018c1 <open>
  801692:	89 c3                	mov    %eax,%ebx
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	78 1b                	js     8016b6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	50                   	push   %eax
  8016a2:	e8 65 ff ff ff       	call   80160c <fstat>
  8016a7:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a9:	89 1c 24             	mov    %ebx,(%esp)
  8016ac:	e8 27 fc ff ff       	call   8012d8 <close>
	return r;
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	89 f3                	mov    %esi,%ebx
}
  8016b6:	89 d8                	mov    %ebx,%eax
  8016b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    

008016bf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
  8016c4:	89 c6                	mov    %eax,%esi
  8016c6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016c8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016cf:	74 27                	je     8016f8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d1:	6a 07                	push   $0x7
  8016d3:	68 00 50 80 00       	push   $0x805000
  8016d8:	56                   	push   %esi
  8016d9:	ff 35 00 40 80 00    	pushl  0x804000
  8016df:	e8 02 0d 00 00       	call   8023e6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016e4:	83 c4 0c             	add    $0xc,%esp
  8016e7:	6a 00                	push   $0x0
  8016e9:	53                   	push   %ebx
  8016ea:	6a 00                	push   $0x0
  8016ec:	e8 82 0c 00 00       	call   802373 <ipc_recv>
}
  8016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f8:	83 ec 0c             	sub    $0xc,%esp
  8016fb:	6a 01                	push   $0x1
  8016fd:	e8 50 0d 00 00       	call   802452 <ipc_find_env>
  801702:	a3 00 40 80 00       	mov    %eax,0x804000
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	eb c5                	jmp    8016d1 <fsipc+0x12>

0080170c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8b 40 0c             	mov    0xc(%eax),%eax
  801718:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801725:	ba 00 00 00 00       	mov    $0x0,%edx
  80172a:	b8 02 00 00 00       	mov    $0x2,%eax
  80172f:	e8 8b ff ff ff       	call   8016bf <fsipc>
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <devfile_flush>:
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8b 40 0c             	mov    0xc(%eax),%eax
  801742:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	b8 06 00 00 00       	mov    $0x6,%eax
  801751:	e8 69 ff ff ff       	call   8016bf <fsipc>
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <devfile_stat>:
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	53                   	push   %ebx
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8b 40 0c             	mov    0xc(%eax),%eax
  801768:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	b8 05 00 00 00       	mov    $0x5,%eax
  801777:	e8 43 ff ff ff       	call   8016bf <fsipc>
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 2c                	js     8017ac <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	68 00 50 80 00       	push   $0x805000
  801788:	53                   	push   %ebx
  801789:	e8 f8 ef ff ff       	call   800786 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80178e:	a1 80 50 80 00       	mov    0x805080,%eax
  801793:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801799:	a1 84 50 80 00       	mov    0x805084,%eax
  80179e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <devfile_write>:
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8017bb:	85 db                	test   %ebx,%ebx
  8017bd:	75 07                	jne    8017c6 <devfile_write+0x15>
	return n_all;
  8017bf:	89 d8                	mov    %ebx,%eax
}
  8017c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cc:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8017d1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	53                   	push   %ebx
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	68 08 50 80 00       	push   $0x805008
  8017e3:	e8 2c f1 ff ff       	call   800914 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f2:	e8 c8 fe ff ff       	call   8016bf <fsipc>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	78 c3                	js     8017c1 <devfile_write+0x10>
	  assert(r <= n_left);
  8017fe:	39 d8                	cmp    %ebx,%eax
  801800:	77 0b                	ja     80180d <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801802:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801807:	7f 1d                	jg     801826 <devfile_write+0x75>
    n_all += r;
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	eb b2                	jmp    8017bf <devfile_write+0xe>
	  assert(r <= n_left);
  80180d:	68 e8 2c 80 00       	push   $0x802ce8
  801812:	68 f4 2c 80 00       	push   $0x802cf4
  801817:	68 9f 00 00 00       	push   $0x9f
  80181c:	68 09 2d 80 00       	push   $0x802d09
  801821:	e8 6a 0a 00 00       	call   802290 <_panic>
	  assert(r <= PGSIZE);
  801826:	68 14 2d 80 00       	push   $0x802d14
  80182b:	68 f4 2c 80 00       	push   $0x802cf4
  801830:	68 a0 00 00 00       	push   $0xa0
  801835:	68 09 2d 80 00       	push   $0x802d09
  80183a:	e8 51 0a 00 00       	call   802290 <_panic>

0080183f <devfile_read>:
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 40 0c             	mov    0xc(%eax),%eax
  80184d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801852:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 03 00 00 00       	mov    $0x3,%eax
  801862:	e8 58 fe ff ff       	call   8016bf <fsipc>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 1f                	js     80188c <devfile_read+0x4d>
	assert(r <= n);
  80186d:	39 f0                	cmp    %esi,%eax
  80186f:	77 24                	ja     801895 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801871:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801876:	7f 33                	jg     8018ab <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	50                   	push   %eax
  80187c:	68 00 50 80 00       	push   $0x805000
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 8b f0 ff ff       	call   800914 <memmove>
	return r;
  801889:	83 c4 10             	add    $0x10,%esp
}
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    
	assert(r <= n);
  801895:	68 20 2d 80 00       	push   $0x802d20
  80189a:	68 f4 2c 80 00       	push   $0x802cf4
  80189f:	6a 7c                	push   $0x7c
  8018a1:	68 09 2d 80 00       	push   $0x802d09
  8018a6:	e8 e5 09 00 00       	call   802290 <_panic>
	assert(r <= PGSIZE);
  8018ab:	68 14 2d 80 00       	push   $0x802d14
  8018b0:	68 f4 2c 80 00       	push   $0x802cf4
  8018b5:	6a 7d                	push   $0x7d
  8018b7:	68 09 2d 80 00       	push   $0x802d09
  8018bc:	e8 cf 09 00 00       	call   802290 <_panic>

008018c1 <open>:
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 1c             	sub    $0x1c,%esp
  8018c9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018cc:	56                   	push   %esi
  8018cd:	e8 7b ee ff ff       	call   80074d <strlen>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018da:	7f 6c                	jg     801948 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	e8 6c f8 ff ff       	call   801154 <fd_alloc>
  8018e8:	89 c3                	mov    %eax,%ebx
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 3c                	js     80192d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	56                   	push   %esi
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	e8 87 ee ff ff       	call   800786 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	e8 ab fd ff ff       	call   8016bf <fsipc>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 19                	js     801936 <open+0x75>
	return fd2num(fd);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	e8 05 f8 ff ff       	call   80112d <fd2num>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	83 c4 10             	add    $0x10,%esp
}
  80192d:	89 d8                	mov    %ebx,%eax
  80192f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    
		fd_close(fd, 0);
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	e8 0e f9 ff ff       	call   801251 <fd_close>
		return r;
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	eb e5                	jmp    80192d <open+0x6c>
		return -E_BAD_PATH;
  801948:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194d:	eb de                	jmp    80192d <open+0x6c>

0080194f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801955:	ba 00 00 00 00       	mov    $0x0,%edx
  80195a:	b8 08 00 00 00       	mov    $0x8,%eax
  80195f:	e8 5b fd ff ff       	call   8016bf <fsipc>
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	e8 c4 f7 ff ff       	call   80113d <fd2data>
  801979:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80197b:	83 c4 08             	add    $0x8,%esp
  80197e:	68 27 2d 80 00       	push   $0x802d27
  801983:	53                   	push   %ebx
  801984:	e8 fd ed ff ff       	call   800786 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801989:	8b 46 04             	mov    0x4(%esi),%eax
  80198c:	2b 06                	sub    (%esi),%eax
  80198e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801994:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199b:	00 00 00 
	stat->st_dev = &devpipe;
  80199e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019a5:	30 80 00 
	return 0;
}
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b0:	5b                   	pop    %ebx
  8019b1:	5e                   	pop    %esi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    

008019b4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019be:	53                   	push   %ebx
  8019bf:	6a 00                	push   $0x0
  8019c1:	e8 37 f2 ff ff       	call   800bfd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 6f f7 ff ff       	call   80113d <fd2data>
  8019ce:	83 c4 08             	add    $0x8,%esp
  8019d1:	50                   	push   %eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	e8 24 f2 ff ff       	call   800bfd <sys_page_unmap>
}
  8019d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <_pipeisclosed>:
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	57                   	push   %edi
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 1c             	sub    $0x1c,%esp
  8019e7:	89 c7                	mov    %eax,%edi
  8019e9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8019f0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	57                   	push   %edi
  8019f7:	e8 8f 0a 00 00       	call   80248b <pageref>
  8019fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ff:	89 34 24             	mov    %esi,(%esp)
  801a02:	e8 84 0a 00 00       	call   80248b <pageref>
		nn = thisenv->env_runs;
  801a07:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a0d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	39 cb                	cmp    %ecx,%ebx
  801a15:	74 1b                	je     801a32 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a17:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a1a:	75 cf                	jne    8019eb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a1c:	8b 42 58             	mov    0x58(%edx),%eax
  801a1f:	6a 01                	push   $0x1
  801a21:	50                   	push   %eax
  801a22:	53                   	push   %ebx
  801a23:	68 2e 2d 80 00       	push   $0x802d2e
  801a28:	e8 7d e7 ff ff       	call   8001aa <cprintf>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	eb b9                	jmp    8019eb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a32:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a35:	0f 94 c0             	sete   %al
  801a38:	0f b6 c0             	movzbl %al,%eax
}
  801a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5f                   	pop    %edi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <devpipe_write>:
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	57                   	push   %edi
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	83 ec 28             	sub    $0x28,%esp
  801a4c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a4f:	56                   	push   %esi
  801a50:	e8 e8 f6 ff ff       	call   80113d <fd2data>
  801a55:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801a5f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a62:	74 4f                	je     801ab3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a64:	8b 43 04             	mov    0x4(%ebx),%eax
  801a67:	8b 0b                	mov    (%ebx),%ecx
  801a69:	8d 51 20             	lea    0x20(%ecx),%edx
  801a6c:	39 d0                	cmp    %edx,%eax
  801a6e:	72 14                	jb     801a84 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a70:	89 da                	mov    %ebx,%edx
  801a72:	89 f0                	mov    %esi,%eax
  801a74:	e8 65 ff ff ff       	call   8019de <_pipeisclosed>
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	75 3b                	jne    801ab8 <devpipe_write+0x75>
			sys_yield();
  801a7d:	e8 d7 f0 ff ff       	call   800b59 <sys_yield>
  801a82:	eb e0                	jmp    801a64 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a87:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a8b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a8e:	89 c2                	mov    %eax,%edx
  801a90:	c1 fa 1f             	sar    $0x1f,%edx
  801a93:	89 d1                	mov    %edx,%ecx
  801a95:	c1 e9 1b             	shr    $0x1b,%ecx
  801a98:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a9b:	83 e2 1f             	and    $0x1f,%edx
  801a9e:	29 ca                	sub    %ecx,%edx
  801aa0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aa4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aa8:	83 c0 01             	add    $0x1,%eax
  801aab:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801aae:	83 c7 01             	add    $0x1,%edi
  801ab1:	eb ac                	jmp    801a5f <devpipe_write+0x1c>
	return i;
  801ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab6:	eb 05                	jmp    801abd <devpipe_write+0x7a>
				return 0;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    

00801ac5 <devpipe_read>:
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	57                   	push   %edi
  801ac9:	56                   	push   %esi
  801aca:	53                   	push   %ebx
  801acb:	83 ec 18             	sub    $0x18,%esp
  801ace:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ad1:	57                   	push   %edi
  801ad2:	e8 66 f6 ff ff       	call   80113d <fd2data>
  801ad7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	be 00 00 00 00       	mov    $0x0,%esi
  801ae1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ae4:	75 14                	jne    801afa <devpipe_read+0x35>
	return i;
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	eb 02                	jmp    801aed <devpipe_read+0x28>
				return i;
  801aeb:	89 f0                	mov    %esi,%eax
}
  801aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    
			sys_yield();
  801af5:	e8 5f f0 ff ff       	call   800b59 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801afa:	8b 03                	mov    (%ebx),%eax
  801afc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801aff:	75 18                	jne    801b19 <devpipe_read+0x54>
			if (i > 0)
  801b01:	85 f6                	test   %esi,%esi
  801b03:	75 e6                	jne    801aeb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b05:	89 da                	mov    %ebx,%edx
  801b07:	89 f8                	mov    %edi,%eax
  801b09:	e8 d0 fe ff ff       	call   8019de <_pipeisclosed>
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	74 e3                	je     801af5 <devpipe_read+0x30>
				return 0;
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
  801b17:	eb d4                	jmp    801aed <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b19:	99                   	cltd   
  801b1a:	c1 ea 1b             	shr    $0x1b,%edx
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	83 e0 1f             	and    $0x1f,%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b2c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b2f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b32:	83 c6 01             	add    $0x1,%esi
  801b35:	eb aa                	jmp    801ae1 <devpipe_read+0x1c>

00801b37 <pipe>:
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b42:	50                   	push   %eax
  801b43:	e8 0c f6 ff ff       	call   801154 <fd_alloc>
  801b48:	89 c3                	mov    %eax,%ebx
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	0f 88 23 01 00 00    	js     801c78 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	68 07 04 00 00       	push   $0x407
  801b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b60:	6a 00                	push   $0x0
  801b62:	e8 11 f0 ff ff       	call   800b78 <sys_page_alloc>
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	0f 88 04 01 00 00    	js     801c78 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b74:	83 ec 0c             	sub    $0xc,%esp
  801b77:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7a:	50                   	push   %eax
  801b7b:	e8 d4 f5 ff ff       	call   801154 <fd_alloc>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	0f 88 db 00 00 00    	js     801c68 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	68 07 04 00 00       	push   $0x407
  801b95:	ff 75 f0             	pushl  -0x10(%ebp)
  801b98:	6a 00                	push   $0x0
  801b9a:	e8 d9 ef ff ff       	call   800b78 <sys_page_alloc>
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	0f 88 bc 00 00 00    	js     801c68 <pipe+0x131>
	va = fd2data(fd0);
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb2:	e8 86 f5 ff ff       	call   80113d <fd2data>
  801bb7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb9:	83 c4 0c             	add    $0xc,%esp
  801bbc:	68 07 04 00 00       	push   $0x407
  801bc1:	50                   	push   %eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	e8 af ef ff ff       	call   800b78 <sys_page_alloc>
  801bc9:	89 c3                	mov    %eax,%ebx
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	0f 88 82 00 00 00    	js     801c58 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	ff 75 f0             	pushl  -0x10(%ebp)
  801bdc:	e8 5c f5 ff ff       	call   80113d <fd2data>
  801be1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801be8:	50                   	push   %eax
  801be9:	6a 00                	push   $0x0
  801beb:	56                   	push   %esi
  801bec:	6a 00                	push   $0x0
  801bee:	e8 c8 ef ff ff       	call   800bbb <sys_page_map>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	83 c4 20             	add    $0x20,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 4e                	js     801c4a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801bfc:	a1 20 30 80 00       	mov    0x803020,%eax
  801c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c04:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c09:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c13:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	e8 03 f5 ff ff       	call   80112d <fd2num>
  801c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c2f:	83 c4 04             	add    $0x4,%esp
  801c32:	ff 75 f0             	pushl  -0x10(%ebp)
  801c35:	e8 f3 f4 ff ff       	call   80112d <fd2num>
  801c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c40:	83 c4 10             	add    $0x10,%esp
  801c43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c48:	eb 2e                	jmp    801c78 <pipe+0x141>
	sys_page_unmap(0, va);
  801c4a:	83 ec 08             	sub    $0x8,%esp
  801c4d:	56                   	push   %esi
  801c4e:	6a 00                	push   $0x0
  801c50:	e8 a8 ef ff ff       	call   800bfd <sys_page_unmap>
  801c55:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c5e:	6a 00                	push   $0x0
  801c60:	e8 98 ef ff ff       	call   800bfd <sys_page_unmap>
  801c65:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6e:	6a 00                	push   $0x0
  801c70:	e8 88 ef ff ff       	call   800bfd <sys_page_unmap>
  801c75:	83 c4 10             	add    $0x10,%esp
}
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <pipeisclosed>:
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8a:	50                   	push   %eax
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	e8 13 f5 ff ff       	call   8011a6 <fd_lookup>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 18                	js     801cb2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca0:	e8 98 f4 ff ff       	call   80113d <fd2data>
	return _pipeisclosed(fd, p);
  801ca5:	89 c2                	mov    %eax,%edx
  801ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caa:	e8 2f fd ff ff       	call   8019de <_pipeisclosed>
  801caf:	83 c4 10             	add    $0x10,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cba:	68 46 2d 80 00       	push   $0x802d46
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	e8 bf ea ff ff       	call   800786 <strcpy>
	return 0;
}
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <devsock_close>:
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 10             	sub    $0x10,%esp
  801cd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cd8:	53                   	push   %ebx
  801cd9:	e8 ad 07 00 00       	call   80248b <pageref>
  801cde:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ce1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ce6:	83 f8 01             	cmp    $0x1,%eax
  801ce9:	74 07                	je     801cf2 <devsock_close+0x24>
}
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	ff 73 0c             	pushl  0xc(%ebx)
  801cf8:	e8 b9 02 00 00       	call   801fb6 <nsipc_close>
  801cfd:	89 c2                	mov    %eax,%edx
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	eb e7                	jmp    801ceb <devsock_close+0x1d>

00801d04 <devsock_write>:
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	ff 75 10             	pushl  0x10(%ebp)
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	ff 70 0c             	pushl  0xc(%eax)
  801d18:	e8 76 03 00 00       	call   802093 <nsipc_send>
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <devsock_read>:
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	ff 75 10             	pushl  0x10(%ebp)
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	ff 70 0c             	pushl  0xc(%eax)
  801d33:	e8 ef 02 00 00       	call   802027 <nsipc_recv>
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <fd2sockid>:
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d40:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	e8 5c f4 ff ff       	call   8011a6 <fd_lookup>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 10                	js     801d61 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d5a:	39 08                	cmp    %ecx,(%eax)
  801d5c:	75 05                	jne    801d63 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d5e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    
		return -E_NOT_SUPP;
  801d63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d68:	eb f7                	jmp    801d61 <fd2sockid+0x27>

00801d6a <alloc_sockfd>:
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	56                   	push   %esi
  801d6e:	53                   	push   %ebx
  801d6f:	83 ec 1c             	sub    $0x1c,%esp
  801d72:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d77:	50                   	push   %eax
  801d78:	e8 d7 f3 ff ff       	call   801154 <fd_alloc>
  801d7d:	89 c3                	mov    %eax,%ebx
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	78 43                	js     801dc9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	68 07 04 00 00       	push   $0x407
  801d8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d91:	6a 00                	push   $0x0
  801d93:	e8 e0 ed ff ff       	call   800b78 <sys_page_alloc>
  801d98:	89 c3                	mov    %eax,%ebx
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	78 28                	js     801dc9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801daa:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801db6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	50                   	push   %eax
  801dbd:	e8 6b f3 ff ff       	call   80112d <fd2num>
  801dc2:	89 c3                	mov    %eax,%ebx
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	eb 0c                	jmp    801dd5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	56                   	push   %esi
  801dcd:	e8 e4 01 00 00       	call   801fb6 <nsipc_close>
		return r;
  801dd2:	83 c4 10             	add    $0x10,%esp
}
  801dd5:	89 d8                	mov    %ebx,%eax
  801dd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    

00801dde <accept>:
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	e8 4e ff ff ff       	call   801d3a <fd2sockid>
  801dec:	85 c0                	test   %eax,%eax
  801dee:	78 1b                	js     801e0b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	50                   	push   %eax
  801dfa:	e8 0e 01 00 00       	call   801f0d <nsipc_accept>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 05                	js     801e0b <accept+0x2d>
	return alloc_sockfd(r);
  801e06:	e8 5f ff ff ff       	call   801d6a <alloc_sockfd>
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <bind>:
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	e8 1f ff ff ff       	call   801d3a <fd2sockid>
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	78 12                	js     801e31 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	ff 75 10             	pushl  0x10(%ebp)
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	50                   	push   %eax
  801e29:	e8 31 01 00 00       	call   801f5f <nsipc_bind>
  801e2e:	83 c4 10             	add    $0x10,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <shutdown>:
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	e8 f9 fe ff ff       	call   801d3a <fd2sockid>
  801e41:	85 c0                	test   %eax,%eax
  801e43:	78 0f                	js     801e54 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e45:	83 ec 08             	sub    $0x8,%esp
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	50                   	push   %eax
  801e4c:	e8 43 01 00 00       	call   801f94 <nsipc_shutdown>
  801e51:	83 c4 10             	add    $0x10,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <connect>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	e8 d6 fe ff ff       	call   801d3a <fd2sockid>
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 12                	js     801e7a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	ff 75 10             	pushl  0x10(%ebp)
  801e6e:	ff 75 0c             	pushl  0xc(%ebp)
  801e71:	50                   	push   %eax
  801e72:	e8 59 01 00 00       	call   801fd0 <nsipc_connect>
  801e77:	83 c4 10             	add    $0x10,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <listen>:
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	e8 b0 fe ff ff       	call   801d3a <fd2sockid>
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	78 0f                	js     801e9d <listen+0x21>
	return nsipc_listen(r, backlog);
  801e8e:	83 ec 08             	sub    $0x8,%esp
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	e8 6b 01 00 00       	call   802005 <nsipc_listen>
  801e9a:	83 c4 10             	add    $0x10,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <socket>:

int
socket(int domain, int type, int protocol)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ea5:	ff 75 10             	pushl  0x10(%ebp)
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	ff 75 08             	pushl  0x8(%ebp)
  801eae:	e8 3e 02 00 00       	call   8020f1 <nsipc_socket>
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 05                	js     801ebf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801eba:	e8 ab fe ff ff       	call   801d6a <alloc_sockfd>
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	53                   	push   %ebx
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801eca:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ed1:	74 26                	je     801ef9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ed3:	6a 07                	push   $0x7
  801ed5:	68 00 60 80 00       	push   $0x806000
  801eda:	53                   	push   %ebx
  801edb:	ff 35 04 40 80 00    	pushl  0x804004
  801ee1:	e8 00 05 00 00       	call   8023e6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ee6:	83 c4 0c             	add    $0xc,%esp
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	e8 7f 04 00 00       	call   802373 <ipc_recv>
}
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	6a 02                	push   $0x2
  801efe:	e8 4f 05 00 00       	call   802452 <ipc_find_env>
  801f03:	a3 04 40 80 00       	mov    %eax,0x804004
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	eb c6                	jmp    801ed3 <nsipc+0x12>

00801f0d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	56                   	push   %esi
  801f11:	53                   	push   %ebx
  801f12:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f1d:	8b 06                	mov    (%esi),%eax
  801f1f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f24:	b8 01 00 00 00       	mov    $0x1,%eax
  801f29:	e8 93 ff ff ff       	call   801ec1 <nsipc>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	85 c0                	test   %eax,%eax
  801f32:	79 09                	jns    801f3d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	ff 35 10 60 80 00    	pushl  0x806010
  801f46:	68 00 60 80 00       	push   $0x806000
  801f4b:	ff 75 0c             	pushl  0xc(%ebp)
  801f4e:	e8 c1 e9 ff ff       	call   800914 <memmove>
		*addrlen = ret->ret_addrlen;
  801f53:	a1 10 60 80 00       	mov    0x806010,%eax
  801f58:	89 06                	mov    %eax,(%esi)
  801f5a:	83 c4 10             	add    $0x10,%esp
	return r;
  801f5d:	eb d5                	jmp    801f34 <nsipc_accept+0x27>

00801f5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 08             	sub    $0x8,%esp
  801f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f71:	53                   	push   %ebx
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	68 04 60 80 00       	push   $0x806004
  801f7a:	e8 95 e9 ff ff       	call   800914 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f7f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f85:	b8 02 00 00 00       	mov    $0x2,%eax
  801f8a:	e8 32 ff ff ff       	call   801ec1 <nsipc>
}
  801f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801faa:	b8 03 00 00 00       	mov    $0x3,%eax
  801faf:	e8 0d ff ff ff       	call   801ec1 <nsipc>
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <nsipc_close>:

int
nsipc_close(int s)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fc4:	b8 04 00 00 00       	mov    $0x4,%eax
  801fc9:	e8 f3 fe ff ff       	call   801ec1 <nsipc>
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 08             	sub    $0x8,%esp
  801fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fe2:	53                   	push   %ebx
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	68 04 60 80 00       	push   $0x806004
  801feb:	e8 24 e9 ff ff       	call   800914 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ff0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ff6:	b8 05 00 00 00       	mov    $0x5,%eax
  801ffb:	e8 c1 fe ff ff       	call   801ec1 <nsipc>
}
  802000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80201b:	b8 06 00 00 00       	mov    $0x6,%eax
  802020:	e8 9c fe ff ff       	call   801ec1 <nsipc>
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802037:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80203d:	8b 45 14             	mov    0x14(%ebp),%eax
  802040:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802045:	b8 07 00 00 00       	mov    $0x7,%eax
  80204a:	e8 72 fe ff ff       	call   801ec1 <nsipc>
  80204f:	89 c3                	mov    %eax,%ebx
  802051:	85 c0                	test   %eax,%eax
  802053:	78 1f                	js     802074 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802055:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80205a:	7f 21                	jg     80207d <nsipc_recv+0x56>
  80205c:	39 c6                	cmp    %eax,%esi
  80205e:	7c 1d                	jl     80207d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	50                   	push   %eax
  802064:	68 00 60 80 00       	push   $0x806000
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	e8 a3 e8 ff ff       	call   800914 <memmove>
  802071:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802074:	89 d8                	mov    %ebx,%eax
  802076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80207d:	68 52 2d 80 00       	push   $0x802d52
  802082:	68 f4 2c 80 00       	push   $0x802cf4
  802087:	6a 62                	push   $0x62
  802089:	68 67 2d 80 00       	push   $0x802d67
  80208e:	e8 fd 01 00 00       	call   802290 <_panic>

00802093 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	53                   	push   %ebx
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020a5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020ab:	7f 2e                	jg     8020db <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	53                   	push   %ebx
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	68 0c 60 80 00       	push   $0x80600c
  8020b9:	e8 56 e8 ff ff       	call   800914 <memmove>
	nsipcbuf.send.req_size = size;
  8020be:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8020d1:	e8 eb fd ff ff       	call   801ec1 <nsipc>
}
  8020d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    
	assert(size < 1600);
  8020db:	68 73 2d 80 00       	push   $0x802d73
  8020e0:	68 f4 2c 80 00       	push   $0x802cf4
  8020e5:	6a 6d                	push   $0x6d
  8020e7:	68 67 2d 80 00       	push   $0x802d67
  8020ec:	e8 9f 01 00 00       	call   802290 <_panic>

008020f1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802102:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802107:	8b 45 10             	mov    0x10(%ebp),%eax
  80210a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80210f:	b8 09 00 00 00       	mov    $0x9,%eax
  802114:	e8 a8 fd ff ff       	call   801ec1 <nsipc>
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	c3                   	ret    

00802121 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802127:	68 7f 2d 80 00       	push   $0x802d7f
  80212c:	ff 75 0c             	pushl  0xc(%ebp)
  80212f:	e8 52 e6 ff ff       	call   800786 <strcpy>
	return 0;
}
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <devcons_write>:
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	57                   	push   %edi
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802147:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80214c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802152:	3b 75 10             	cmp    0x10(%ebp),%esi
  802155:	73 31                	jae    802188 <devcons_write+0x4d>
		m = n - tot;
  802157:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80215a:	29 f3                	sub    %esi,%ebx
  80215c:	83 fb 7f             	cmp    $0x7f,%ebx
  80215f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802164:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	53                   	push   %ebx
  80216b:	89 f0                	mov    %esi,%eax
  80216d:	03 45 0c             	add    0xc(%ebp),%eax
  802170:	50                   	push   %eax
  802171:	57                   	push   %edi
  802172:	e8 9d e7 ff ff       	call   800914 <memmove>
		sys_cputs(buf, m);
  802177:	83 c4 08             	add    $0x8,%esp
  80217a:	53                   	push   %ebx
  80217b:	57                   	push   %edi
  80217c:	e8 3b e9 ff ff       	call   800abc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802181:	01 de                	add    %ebx,%esi
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	eb ca                	jmp    802152 <devcons_write+0x17>
}
  802188:	89 f0                	mov    %esi,%eax
  80218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5f                   	pop    %edi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    

00802192 <devcons_read>:
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
  802198:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80219d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a1:	74 21                	je     8021c4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021a3:	e8 32 e9 ff ff       	call   800ada <sys_cgetc>
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	75 07                	jne    8021b3 <devcons_read+0x21>
		sys_yield();
  8021ac:	e8 a8 e9 ff ff       	call   800b59 <sys_yield>
  8021b1:	eb f0                	jmp    8021a3 <devcons_read+0x11>
	if (c < 0)
  8021b3:	78 0f                	js     8021c4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021b5:	83 f8 04             	cmp    $0x4,%eax
  8021b8:	74 0c                	je     8021c6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bd:	88 02                	mov    %al,(%edx)
	return 1;
  8021bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    
		return 0;
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	eb f7                	jmp    8021c4 <devcons_read+0x32>

008021cd <cputchar>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d9:	6a 01                	push   $0x1
  8021db:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021de:	50                   	push   %eax
  8021df:	e8 d8 e8 ff ff       	call   800abc <sys_cputs>
}
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <getchar>:
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ef:	6a 01                	push   $0x1
  8021f1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f4:	50                   	push   %eax
  8021f5:	6a 00                	push   $0x0
  8021f7:	e8 1a f2 ff ff       	call   801416 <read>
	if (r < 0)
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 06                	js     802209 <getchar+0x20>
	if (r < 1)
  802203:	74 06                	je     80220b <getchar+0x22>
	return c;
  802205:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    
		return -E_EOF;
  80220b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802210:	eb f7                	jmp    802209 <getchar+0x20>

00802212 <iscons>:
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 82 ef ff ff       	call   8011a6 <fd_lookup>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	85 c0                	test   %eax,%eax
  802229:	78 11                	js     80223c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802234:	39 10                	cmp    %edx,(%eax)
  802236:	0f 94 c0             	sete   %al
  802239:	0f b6 c0             	movzbl %al,%eax
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <opencons>:
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802247:	50                   	push   %eax
  802248:	e8 07 ef ff ff       	call   801154 <fd_alloc>
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	78 3a                	js     80228e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 07 04 00 00       	push   $0x407
  80225c:	ff 75 f4             	pushl  -0xc(%ebp)
  80225f:	6a 00                	push   $0x0
  802261:	e8 12 e9 ff ff       	call   800b78 <sys_page_alloc>
  802266:	83 c4 10             	add    $0x10,%esp
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 21                	js     80228e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802276:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	50                   	push   %eax
  802286:	e8 a2 ee ff ff       	call   80112d <fd2num>
  80228b:	83 c4 10             	add    $0x10,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	56                   	push   %esi
  802294:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802295:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802298:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80229e:	e8 97 e8 ff ff       	call   800b3a <sys_getenvid>
  8022a3:	83 ec 0c             	sub    $0xc,%esp
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	56                   	push   %esi
  8022ad:	50                   	push   %eax
  8022ae:	68 8c 2d 80 00       	push   $0x802d8c
  8022b3:	e8 f2 de ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022b8:	83 c4 18             	add    $0x18,%esp
  8022bb:	53                   	push   %ebx
  8022bc:	ff 75 10             	pushl  0x10(%ebp)
  8022bf:	e8 95 de ff ff       	call   800159 <vcprintf>
	cprintf("\n");
  8022c4:	c7 04 24 b4 27 80 00 	movl   $0x8027b4,(%esp)
  8022cb:	e8 da de ff ff       	call   8001aa <cprintf>
  8022d0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022d3:	cc                   	int3   
  8022d4:	eb fd                	jmp    8022d3 <_panic+0x43>

008022d6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8022dc:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8022e3:	74 0a                	je     8022ef <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8022ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f4:	8b 40 48             	mov    0x48(%eax),%eax
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	6a 07                	push   $0x7
  8022fc:	68 00 f0 bf ee       	push   $0xeebff000
  802301:	50                   	push   %eax
  802302:	e8 71 e8 ff ff       	call   800b78 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802307:	83 c4 10             	add    $0x10,%esp
  80230a:	85 c0                	test   %eax,%eax
  80230c:	78 2c                	js     80233a <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80230e:	e8 27 e8 ff ff       	call   800b3a <sys_getenvid>
  802313:	83 ec 08             	sub    $0x8,%esp
  802316:	68 4c 23 80 00       	push   $0x80234c
  80231b:	50                   	push   %eax
  80231c:	e8 a2 e9 ff ff       	call   800cc3 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	85 c0                	test   %eax,%eax
  802326:	79 bd                	jns    8022e5 <set_pgfault_handler+0xf>
  802328:	50                   	push   %eax
  802329:	68 af 2d 80 00       	push   $0x802daf
  80232e:	6a 23                	push   $0x23
  802330:	68 c7 2d 80 00       	push   $0x802dc7
  802335:	e8 56 ff ff ff       	call   802290 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80233a:	50                   	push   %eax
  80233b:	68 af 2d 80 00       	push   $0x802daf
  802340:	6a 21                	push   $0x21
  802342:	68 c7 2d 80 00       	push   $0x802dc7
  802347:	e8 44 ff ff ff       	call   802290 <_panic>

0080234c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80234c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80234d:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802352:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802354:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802357:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  80235b:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  80235e:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802362:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802366:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802369:	83 c4 08             	add    $0x8,%esp
	popal
  80236c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80236d:	83 c4 04             	add    $0x4,%esp
	popfl
  802370:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802371:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802372:	c3                   	ret    

00802373 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	8b 75 08             	mov    0x8(%ebp),%esi
  80237b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802381:	85 c0                	test   %eax,%eax
  802383:	74 4f                	je     8023d4 <ipc_recv+0x61>
  802385:	83 ec 0c             	sub    $0xc,%esp
  802388:	50                   	push   %eax
  802389:	e8 9a e9 ff ff       	call   800d28 <sys_ipc_recv>
  80238e:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802391:	85 f6                	test   %esi,%esi
  802393:	74 14                	je     8023a9 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802395:	ba 00 00 00 00       	mov    $0x0,%edx
  80239a:	85 c0                	test   %eax,%eax
  80239c:	75 09                	jne    8023a7 <ipc_recv+0x34>
  80239e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023a4:	8b 52 74             	mov    0x74(%edx),%edx
  8023a7:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8023a9:	85 db                	test   %ebx,%ebx
  8023ab:	74 14                	je     8023c1 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8023ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	75 09                	jne    8023bf <ipc_recv+0x4c>
  8023b6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023bc:	8b 52 78             	mov    0x78(%edx),%edx
  8023bf:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	75 08                	jne    8023cd <ipc_recv+0x5a>
  8023c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ca:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5e                   	pop    %esi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8023d4:	83 ec 0c             	sub    $0xc,%esp
  8023d7:	68 00 00 c0 ee       	push   $0xeec00000
  8023dc:	e8 47 e9 ff ff       	call   800d28 <sys_ipc_recv>
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	eb ab                	jmp    802391 <ipc_recv+0x1e>

008023e6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	57                   	push   %edi
  8023ea:	56                   	push   %esi
  8023eb:	53                   	push   %ebx
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f2:	8b 75 10             	mov    0x10(%ebp),%esi
  8023f5:	eb 20                	jmp    802417 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8023f7:	6a 00                	push   $0x0
  8023f9:	68 00 00 c0 ee       	push   $0xeec00000
  8023fe:	ff 75 0c             	pushl  0xc(%ebp)
  802401:	57                   	push   %edi
  802402:	e8 fe e8 ff ff       	call   800d05 <sys_ipc_try_send>
  802407:	89 c3                	mov    %eax,%ebx
  802409:	83 c4 10             	add    $0x10,%esp
  80240c:	eb 1f                	jmp    80242d <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80240e:	e8 46 e7 ff ff       	call   800b59 <sys_yield>
	while(retval != 0) {
  802413:	85 db                	test   %ebx,%ebx
  802415:	74 33                	je     80244a <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802417:	85 f6                	test   %esi,%esi
  802419:	74 dc                	je     8023f7 <ipc_send+0x11>
  80241b:	ff 75 14             	pushl  0x14(%ebp)
  80241e:	56                   	push   %esi
  80241f:	ff 75 0c             	pushl  0xc(%ebp)
  802422:	57                   	push   %edi
  802423:	e8 dd e8 ff ff       	call   800d05 <sys_ipc_try_send>
  802428:	89 c3                	mov    %eax,%ebx
  80242a:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80242d:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802430:	74 dc                	je     80240e <ipc_send+0x28>
  802432:	85 db                	test   %ebx,%ebx
  802434:	74 d8                	je     80240e <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	68 d8 2d 80 00       	push   $0x802dd8
  80243e:	6a 35                	push   $0x35
  802440:	68 08 2e 80 00       	push   $0x802e08
  802445:	e8 46 fe ff ff       	call   802290 <_panic>
	}
}
  80244a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802458:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80245d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802460:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802466:	8b 52 50             	mov    0x50(%edx),%edx
  802469:	39 ca                	cmp    %ecx,%edx
  80246b:	74 11                	je     80247e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80246d:	83 c0 01             	add    $0x1,%eax
  802470:	3d 00 04 00 00       	cmp    $0x400,%eax
  802475:	75 e6                	jne    80245d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
  80247c:	eb 0b                	jmp    802489 <ipc_find_env+0x37>
			return envs[i].env_id;
  80247e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802481:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802486:	8b 40 48             	mov    0x48(%eax),%eax
}
  802489:	5d                   	pop    %ebp
  80248a:	c3                   	ret    

0080248b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802491:	89 d0                	mov    %edx,%eax
  802493:	c1 e8 16             	shr    $0x16,%eax
  802496:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024a2:	f6 c1 01             	test   $0x1,%cl
  8024a5:	74 1d                	je     8024c4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024a7:	c1 ea 0c             	shr    $0xc,%edx
  8024aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024b1:	f6 c2 01             	test   $0x1,%dl
  8024b4:	74 0e                	je     8024c4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024b6:	c1 ea 0c             	shr    $0xc,%edx
  8024b9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024c0:	ef 
  8024c1:	0f b7 c0             	movzwl %ax,%eax
}
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    
  8024c6:	66 90                	xchg   %ax,%ax
  8024c8:	66 90                	xchg   %ax,%ax
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	66 90                	xchg   %ax,%ax
  8024ce:	66 90                	xchg   %ax,%ax

008024d0 <__udivdi3>:
  8024d0:	f3 0f 1e fb          	endbr32 
  8024d4:	55                   	push   %ebp
  8024d5:	57                   	push   %edi
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 1c             	sub    $0x1c,%esp
  8024db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024eb:	85 d2                	test   %edx,%edx
  8024ed:	75 49                	jne    802538 <__udivdi3+0x68>
  8024ef:	39 f3                	cmp    %esi,%ebx
  8024f1:	76 15                	jbe    802508 <__udivdi3+0x38>
  8024f3:	31 ff                	xor    %edi,%edi
  8024f5:	89 e8                	mov    %ebp,%eax
  8024f7:	89 f2                	mov    %esi,%edx
  8024f9:	f7 f3                	div    %ebx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	83 c4 1c             	add    $0x1c,%esp
  802500:	5b                   	pop    %ebx
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	89 d9                	mov    %ebx,%ecx
  80250a:	85 db                	test   %ebx,%ebx
  80250c:	75 0b                	jne    802519 <__udivdi3+0x49>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f3                	div    %ebx
  802517:	89 c1                	mov    %eax,%ecx
  802519:	31 d2                	xor    %edx,%edx
  80251b:	89 f0                	mov    %esi,%eax
  80251d:	f7 f1                	div    %ecx
  80251f:	89 c6                	mov    %eax,%esi
  802521:	89 e8                	mov    %ebp,%eax
  802523:	89 f7                	mov    %esi,%edi
  802525:	f7 f1                	div    %ecx
  802527:	89 fa                	mov    %edi,%edx
  802529:	83 c4 1c             	add    $0x1c,%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5f                   	pop    %edi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	39 f2                	cmp    %esi,%edx
  80253a:	77 1c                	ja     802558 <__udivdi3+0x88>
  80253c:	0f bd fa             	bsr    %edx,%edi
  80253f:	83 f7 1f             	xor    $0x1f,%edi
  802542:	75 2c                	jne    802570 <__udivdi3+0xa0>
  802544:	39 f2                	cmp    %esi,%edx
  802546:	72 06                	jb     80254e <__udivdi3+0x7e>
  802548:	31 c0                	xor    %eax,%eax
  80254a:	39 eb                	cmp    %ebp,%ebx
  80254c:	77 ad                	ja     8024fb <__udivdi3+0x2b>
  80254e:	b8 01 00 00 00       	mov    $0x1,%eax
  802553:	eb a6                	jmp    8024fb <__udivdi3+0x2b>
  802555:	8d 76 00             	lea    0x0(%esi),%esi
  802558:	31 ff                	xor    %edi,%edi
  80255a:	31 c0                	xor    %eax,%eax
  80255c:	89 fa                	mov    %edi,%edx
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 f9                	mov    %edi,%ecx
  802572:	b8 20 00 00 00       	mov    $0x20,%eax
  802577:	29 f8                	sub    %edi,%eax
  802579:	d3 e2                	shl    %cl,%edx
  80257b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80257f:	89 c1                	mov    %eax,%ecx
  802581:	89 da                	mov    %ebx,%edx
  802583:	d3 ea                	shr    %cl,%edx
  802585:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802589:	09 d1                	or     %edx,%ecx
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 f9                	mov    %edi,%ecx
  802593:	d3 e3                	shl    %cl,%ebx
  802595:	89 c1                	mov    %eax,%ecx
  802597:	d3 ea                	shr    %cl,%edx
  802599:	89 f9                	mov    %edi,%ecx
  80259b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80259f:	89 eb                	mov    %ebp,%ebx
  8025a1:	d3 e6                	shl    %cl,%esi
  8025a3:	89 c1                	mov    %eax,%ecx
  8025a5:	d3 eb                	shr    %cl,%ebx
  8025a7:	09 de                	or     %ebx,%esi
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	f7 74 24 08          	divl   0x8(%esp)
  8025af:	89 d6                	mov    %edx,%esi
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	f7 64 24 0c          	mull   0xc(%esp)
  8025b7:	39 d6                	cmp    %edx,%esi
  8025b9:	72 15                	jb     8025d0 <__udivdi3+0x100>
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e5                	shl    %cl,%ebp
  8025bf:	39 c5                	cmp    %eax,%ebp
  8025c1:	73 04                	jae    8025c7 <__udivdi3+0xf7>
  8025c3:	39 d6                	cmp    %edx,%esi
  8025c5:	74 09                	je     8025d0 <__udivdi3+0x100>
  8025c7:	89 d8                	mov    %ebx,%eax
  8025c9:	31 ff                	xor    %edi,%edi
  8025cb:	e9 2b ff ff ff       	jmp    8024fb <__udivdi3+0x2b>
  8025d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025d3:	31 ff                	xor    %edi,%edi
  8025d5:	e9 21 ff ff ff       	jmp    8024fb <__udivdi3+0x2b>
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <__umoddi3>:
  8025e0:	f3 0f 1e fb          	endbr32 
  8025e4:	55                   	push   %ebp
  8025e5:	57                   	push   %edi
  8025e6:	56                   	push   %esi
  8025e7:	53                   	push   %ebx
  8025e8:	83 ec 1c             	sub    $0x1c,%esp
  8025eb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025f3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025fb:	89 da                	mov    %ebx,%edx
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	75 3f                	jne    802640 <__umoddi3+0x60>
  802601:	39 df                	cmp    %ebx,%edi
  802603:	76 13                	jbe    802618 <__umoddi3+0x38>
  802605:	89 f0                	mov    %esi,%eax
  802607:	f7 f7                	div    %edi
  802609:	89 d0                	mov    %edx,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	83 c4 1c             	add    $0x1c,%esp
  802610:	5b                   	pop    %ebx
  802611:	5e                   	pop    %esi
  802612:	5f                   	pop    %edi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    
  802615:	8d 76 00             	lea    0x0(%esi),%esi
  802618:	89 fd                	mov    %edi,%ebp
  80261a:	85 ff                	test   %edi,%edi
  80261c:	75 0b                	jne    802629 <__umoddi3+0x49>
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	31 d2                	xor    %edx,%edx
  802625:	f7 f7                	div    %edi
  802627:	89 c5                	mov    %eax,%ebp
  802629:	89 d8                	mov    %ebx,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	f7 f5                	div    %ebp
  80262f:	89 f0                	mov    %esi,%eax
  802631:	f7 f5                	div    %ebp
  802633:	89 d0                	mov    %edx,%eax
  802635:	eb d4                	jmp    80260b <__umoddi3+0x2b>
  802637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263e:	66 90                	xchg   %ax,%ax
  802640:	89 f1                	mov    %esi,%ecx
  802642:	39 d8                	cmp    %ebx,%eax
  802644:	76 0a                	jbe    802650 <__umoddi3+0x70>
  802646:	89 f0                	mov    %esi,%eax
  802648:	83 c4 1c             	add    $0x1c,%esp
  80264b:	5b                   	pop    %ebx
  80264c:	5e                   	pop    %esi
  80264d:	5f                   	pop    %edi
  80264e:	5d                   	pop    %ebp
  80264f:	c3                   	ret    
  802650:	0f bd e8             	bsr    %eax,%ebp
  802653:	83 f5 1f             	xor    $0x1f,%ebp
  802656:	75 20                	jne    802678 <__umoddi3+0x98>
  802658:	39 d8                	cmp    %ebx,%eax
  80265a:	0f 82 b0 00 00 00    	jb     802710 <__umoddi3+0x130>
  802660:	39 f7                	cmp    %esi,%edi
  802662:	0f 86 a8 00 00 00    	jbe    802710 <__umoddi3+0x130>
  802668:	89 c8                	mov    %ecx,%eax
  80266a:	83 c4 1c             	add    $0x1c,%esp
  80266d:	5b                   	pop    %ebx
  80266e:	5e                   	pop    %esi
  80266f:	5f                   	pop    %edi
  802670:	5d                   	pop    %ebp
  802671:	c3                   	ret    
  802672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	ba 20 00 00 00       	mov    $0x20,%edx
  80267f:	29 ea                	sub    %ebp,%edx
  802681:	d3 e0                	shl    %cl,%eax
  802683:	89 44 24 08          	mov    %eax,0x8(%esp)
  802687:	89 d1                	mov    %edx,%ecx
  802689:	89 f8                	mov    %edi,%eax
  80268b:	d3 e8                	shr    %cl,%eax
  80268d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802691:	89 54 24 04          	mov    %edx,0x4(%esp)
  802695:	8b 54 24 04          	mov    0x4(%esp),%edx
  802699:	09 c1                	or     %eax,%ecx
  80269b:	89 d8                	mov    %ebx,%eax
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 e9                	mov    %ebp,%ecx
  8026a3:	d3 e7                	shl    %cl,%edi
  8026a5:	89 d1                	mov    %edx,%ecx
  8026a7:	d3 e8                	shr    %cl,%eax
  8026a9:	89 e9                	mov    %ebp,%ecx
  8026ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026af:	d3 e3                	shl    %cl,%ebx
  8026b1:	89 c7                	mov    %eax,%edi
  8026b3:	89 d1                	mov    %edx,%ecx
  8026b5:	89 f0                	mov    %esi,%eax
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	89 e9                	mov    %ebp,%ecx
  8026bb:	89 fa                	mov    %edi,%edx
  8026bd:	d3 e6                	shl    %cl,%esi
  8026bf:	09 d8                	or     %ebx,%eax
  8026c1:	f7 74 24 08          	divl   0x8(%esp)
  8026c5:	89 d1                	mov    %edx,%ecx
  8026c7:	89 f3                	mov    %esi,%ebx
  8026c9:	f7 64 24 0c          	mull   0xc(%esp)
  8026cd:	89 c6                	mov    %eax,%esi
  8026cf:	89 d7                	mov    %edx,%edi
  8026d1:	39 d1                	cmp    %edx,%ecx
  8026d3:	72 06                	jb     8026db <__umoddi3+0xfb>
  8026d5:	75 10                	jne    8026e7 <__umoddi3+0x107>
  8026d7:	39 c3                	cmp    %eax,%ebx
  8026d9:	73 0c                	jae    8026e7 <__umoddi3+0x107>
  8026db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026e3:	89 d7                	mov    %edx,%edi
  8026e5:	89 c6                	mov    %eax,%esi
  8026e7:	89 ca                	mov    %ecx,%edx
  8026e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ee:	29 f3                	sub    %esi,%ebx
  8026f0:	19 fa                	sbb    %edi,%edx
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	d3 e0                	shl    %cl,%eax
  8026f6:	89 e9                	mov    %ebp,%ecx
  8026f8:	d3 eb                	shr    %cl,%ebx
  8026fa:	d3 ea                	shr    %cl,%edx
  8026fc:	09 d8                	or     %ebx,%eax
  8026fe:	83 c4 1c             	add    $0x1c,%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    
  802706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80270d:	8d 76 00             	lea    0x0(%esi),%esi
  802710:	89 da                	mov    %ebx,%edx
  802712:	29 fe                	sub    %edi,%esi
  802714:	19 c2                	sbb    %eax,%edx
  802716:	89 f1                	mov    %esi,%ecx
  802718:	89 c8                	mov    %ecx,%eax
  80271a:	e9 4b ff ff ff       	jmp    80266a <__umoddi3+0x8a>
