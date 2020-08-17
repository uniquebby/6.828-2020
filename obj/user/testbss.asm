
obj/user/testbss.debug：     文件格式 elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 00 23 80 00       	push   $0x802300
  80003e:	e8 d4 01 00 00       	call   800217 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 48 23 80 00       	push   $0x802348
  800095:	e8 7d 01 00 00       	call   800217 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 a7 23 80 00       	push   $0x8023a7
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 98 23 80 00       	push   $0x802398
  8000b3:	e8 84 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 7b 23 80 00       	push   $0x80237b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 98 23 80 00       	push   $0x802398
  8000c5:	e8 72 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 20 23 80 00       	push   $0x802320
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 98 23 80 00       	push   $0x802398
  8000d7:	e8 60 00 00 00       	call   80013c <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 bb 0a 00 00       	call   800ba7 <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800128:	e8 a0 0e 00 00       	call   800fcd <close_all>
	sys_env_destroy(0);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	6a 00                	push   $0x0
  800132:	e8 2f 0a 00 00       	call   800b66 <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800141:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800144:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014a:	e8 58 0a 00 00       	call   800ba7 <sys_getenvid>
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	56                   	push   %esi
  800159:	50                   	push   %eax
  80015a:	68 c8 23 80 00       	push   $0x8023c8
  80015f:	e8 b3 00 00 00       	call   800217 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800164:	83 c4 18             	add    $0x18,%esp
  800167:	53                   	push   %ebx
  800168:	ff 75 10             	pushl  0x10(%ebp)
  80016b:	e8 56 00 00 00       	call   8001c6 <vcprintf>
	cprintf("\n");
  800170:	c7 04 24 96 23 80 00 	movl   $0x802396,(%esp)
  800177:	e8 9b 00 00 00       	call   800217 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017f:	cc                   	int3   
  800180:	eb fd                	jmp    80017f <_panic+0x43>

00800182 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	53                   	push   %ebx
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018c:	8b 13                	mov    (%ebx),%edx
  80018e:	8d 42 01             	lea    0x1(%edx),%eax
  800191:	89 03                	mov    %eax,(%ebx)
  800193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800196:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019f:	74 09                	je     8001aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	68 ff 00 00 00       	push   $0xff
  8001b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 6e 09 00 00       	call   800b29 <sys_cputs>
		b->idx = 0;
  8001bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	eb db                	jmp    8001a1 <putch+0x1f>

008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d6:	00 00 00 
	b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	68 82 01 80 00       	push   $0x800182
  8001f5:	e8 19 01 00 00       	call   800313 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fa:	83 c4 08             	add    $0x8,%esp
  8001fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800203:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800209:	50                   	push   %eax
  80020a:	e8 1a 09 00 00       	call   800b29 <sys_cputs>

	return b.cnt;
}
  80020f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800220:	50                   	push   %eax
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 9d ff ff ff       	call   8001c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 1c             	sub    $0x1c,%esp
  800234:	89 c7                	mov    %eax,%edi
  800236:	89 d6                	mov    %edx,%esi
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800241:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800244:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800247:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80024f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800252:	3b 45 10             	cmp    0x10(%ebp),%eax
  800255:	89 d0                	mov    %edx,%eax
  800257:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80025a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80025d:	73 15                	jae    800274 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	85 db                	test   %ebx,%ebx
  800264:	7e 43                	jle    8002a9 <printnum+0x7e>
			putch(padc, putdat);
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	56                   	push   %esi
  80026a:	ff 75 18             	pushl  0x18(%ebp)
  80026d:	ff d7                	call   *%edi
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	eb eb                	jmp    80025f <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	ff 75 18             	pushl  0x18(%ebp)
  80027a:	8b 45 14             	mov    0x14(%ebp),%eax
  80027d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800280:	53                   	push   %ebx
  800281:	ff 75 10             	pushl  0x10(%ebp)
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028a:	ff 75 e0             	pushl  -0x20(%ebp)
  80028d:	ff 75 dc             	pushl  -0x24(%ebp)
  800290:	ff 75 d8             	pushl  -0x28(%ebp)
  800293:	e8 18 1e 00 00       	call   8020b0 <__udivdi3>
  800298:	83 c4 18             	add    $0x18,%esp
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	89 f2                	mov    %esi,%edx
  80029f:	89 f8                	mov    %edi,%eax
  8002a1:	e8 85 ff ff ff       	call   80022b <printnum>
  8002a6:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	56                   	push   %esi
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bc:	e8 ff 1e 00 00       	call   8021c0 <__umoddi3>
  8002c1:	83 c4 14             	add    $0x14,%esp
  8002c4:	0f be 80 eb 23 80 00 	movsbl 0x8023eb(%eax),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff d7                	call   *%edi
}
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e3:	8b 10                	mov    (%eax),%edx
  8002e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e8:	73 0a                	jae    8002f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ed:	89 08                	mov    %ecx,(%eax)
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	88 02                	mov    %al,(%edx)
}
  8002f4:	5d                   	pop    %ebp
  8002f5:	c3                   	ret    

008002f6 <printfmt>:
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ff:	50                   	push   %eax
  800300:	ff 75 10             	pushl  0x10(%ebp)
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	e8 05 00 00 00       	call   800313 <vprintfmt>
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <vprintfmt>:
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 3c             	sub    $0x3c,%esp
  80031c:	8b 75 08             	mov    0x8(%ebp),%esi
  80031f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	eb 0a                	jmp    800331 <vprintfmt+0x1e>
			putch(ch, putdat);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	53                   	push   %ebx
  80032b:	50                   	push   %eax
  80032c:	ff d6                	call   *%esi
  80032e:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800331:	83 c7 01             	add    $0x1,%edi
  800334:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800338:	83 f8 25             	cmp    $0x25,%eax
  80033b:	74 0c                	je     800349 <vprintfmt+0x36>
			if (ch == '\0')
  80033d:	85 c0                	test   %eax,%eax
  80033f:	75 e6                	jne    800327 <vprintfmt+0x14>
}
  800341:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800344:	5b                   	pop    %ebx
  800345:	5e                   	pop    %esi
  800346:	5f                   	pop    %edi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    
		padc = ' ';
  800349:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80034d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800354:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8d 47 01             	lea    0x1(%edi),%eax
  80036a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036d:	0f b6 17             	movzbl (%edi),%edx
  800370:	8d 42 dd             	lea    -0x23(%edx),%eax
  800373:	3c 55                	cmp    $0x55,%al
  800375:	0f 87 ba 03 00 00    	ja     800735 <vprintfmt+0x422>
  80037b:	0f b6 c0             	movzbl %al,%eax
  80037e:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800388:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80038c:	eb d9                	jmp    800367 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800391:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800395:	eb d0                	jmp    800367 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800397:	0f b6 d2             	movzbl %dl,%edx
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039d:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ac:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003af:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b2:	83 f9 09             	cmp    $0x9,%ecx
  8003b5:	77 55                	ja     80040c <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003b7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ba:	eb e9                	jmp    8003a5 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8d 40 04             	lea    0x4(%eax),%eax
  8003ca:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d4:	79 91                	jns    800367 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e3:	eb 82                	jmp    800367 <vprintfmt+0x54>
  8003e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ef:	0f 49 d0             	cmovns %eax,%edx
  8003f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f8:	e9 6a ff ff ff       	jmp    800367 <vprintfmt+0x54>
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800400:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800407:	e9 5b ff ff ff       	jmp    800367 <vprintfmt+0x54>
  80040c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800412:	eb bc                	jmp    8003d0 <vprintfmt+0xbd>
			lflag++;
  800414:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041a:	e9 48 ff ff ff       	jmp    800367 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 78 04             	lea    0x4(%eax),%edi
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	53                   	push   %ebx
  800429:	ff 30                	pushl  (%eax)
  80042b:	ff d6                	call   *%esi
			break;
  80042d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800430:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800433:	e9 9c 02 00 00       	jmp    8006d4 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 78 04             	lea    0x4(%eax),%edi
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	99                   	cltd   
  800441:	31 d0                	xor    %edx,%eax
  800443:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800445:	83 f8 0f             	cmp    $0xf,%eax
  800448:	7f 23                	jg     80046d <vprintfmt+0x15a>
  80044a:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  800451:	85 d2                	test   %edx,%edx
  800453:	74 18                	je     80046d <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800455:	52                   	push   %edx
  800456:	68 ba 27 80 00       	push   $0x8027ba
  80045b:	53                   	push   %ebx
  80045c:	56                   	push   %esi
  80045d:	e8 94 fe ff ff       	call   8002f6 <printfmt>
  800462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
  800468:	e9 67 02 00 00       	jmp    8006d4 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80046d:	50                   	push   %eax
  80046e:	68 03 24 80 00       	push   $0x802403
  800473:	53                   	push   %ebx
  800474:	56                   	push   %esi
  800475:	e8 7c fe ff ff       	call   8002f6 <printfmt>
  80047a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800480:	e9 4f 02 00 00       	jmp    8006d4 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	83 c0 04             	add    $0x4,%eax
  80048b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800493:	85 d2                	test   %edx,%edx
  800495:	b8 fc 23 80 00       	mov    $0x8023fc,%eax
  80049a:	0f 45 c2             	cmovne %edx,%eax
  80049d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a4:	7e 06                	jle    8004ac <vprintfmt+0x199>
  8004a6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004aa:	75 0d                	jne    8004b9 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004af:	89 c7                	mov    %eax,%edi
  8004b1:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	eb 3f                	jmp    8004f8 <vprintfmt+0x1e5>
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 0d 03 00 00       	call   8007d2 <strnlen>
  8004c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c8:	29 c2                	sub    %eax,%edx
  8004ca:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d9:	85 ff                	test   %edi,%edi
  8004db:	7e 58                	jle    800535 <vprintfmt+0x222>
					putch(padc, putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e6:	83 ef 01             	sub    $0x1,%edi
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	eb eb                	jmp    8004d9 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	53                   	push   %ebx
  8004f2:	52                   	push   %edx
  8004f3:	ff d6                	call   *%esi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fd:	83 c7 01             	add    $0x1,%edi
  800500:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800504:	0f be d0             	movsbl %al,%edx
  800507:	85 d2                	test   %edx,%edx
  800509:	74 45                	je     800550 <vprintfmt+0x23d>
  80050b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050f:	78 06                	js     800517 <vprintfmt+0x204>
  800511:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800515:	78 35                	js     80054c <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800517:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051b:	74 d1                	je     8004ee <vprintfmt+0x1db>
  80051d:	0f be c0             	movsbl %al,%eax
  800520:	83 e8 20             	sub    $0x20,%eax
  800523:	83 f8 5e             	cmp    $0x5e,%eax
  800526:	76 c6                	jbe    8004ee <vprintfmt+0x1db>
					putch('?', putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	6a 3f                	push   $0x3f
  80052e:	ff d6                	call   *%esi
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb c3                	jmp    8004f8 <vprintfmt+0x1e5>
  800535:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800538:	85 d2                	test   %edx,%edx
  80053a:	b8 00 00 00 00       	mov    $0x0,%eax
  80053f:	0f 49 c2             	cmovns %edx,%eax
  800542:	29 c2                	sub    %eax,%edx
  800544:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800547:	e9 60 ff ff ff       	jmp    8004ac <vprintfmt+0x199>
  80054c:	89 cf                	mov    %ecx,%edi
  80054e:	eb 02                	jmp    800552 <vprintfmt+0x23f>
  800550:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800552:	85 ff                	test   %edi,%edi
  800554:	7e 10                	jle    800566 <vprintfmt+0x253>
				putch(' ', putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	6a 20                	push   $0x20
  80055c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055e:	83 ef 01             	sub    $0x1,%edi
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	eb ec                	jmp    800552 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 63 01 00 00       	jmp    8006d4 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800571:	83 f9 01             	cmp    $0x1,%ecx
  800574:	7f 1b                	jg     800591 <vprintfmt+0x27e>
	else if (lflag)
  800576:	85 c9                	test   %ecx,%ecx
  800578:	74 63                	je     8005dd <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800582:	99                   	cltd   
  800583:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8d 40 04             	lea    0x4(%eax),%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
  80058f:	eb 17                	jmp    8005a8 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 50 04             	mov    0x4(%eax),%edx
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 40 08             	lea    0x8(%eax),%eax
  8005a5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ae:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	0f 89 ff 00 00 00    	jns    8006ba <vprintfmt+0x3a7>
				putch('-', putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 2d                	push   $0x2d
  8005c1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c9:	f7 da                	neg    %edx
  8005cb:	83 d1 00             	adc    $0x0,%ecx
  8005ce:	f7 d9                	neg    %ecx
  8005d0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d8:	e9 dd 00 00 00       	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e5:	99                   	cltd   
  8005e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f2:	eb b4                	jmp    8005a8 <vprintfmt+0x295>
	if (lflag >= 2)
  8005f4:	83 f9 01             	cmp    $0x1,%ecx
  8005f7:	7f 1e                	jg     800617 <vprintfmt+0x304>
	else if (lflag)
  8005f9:	85 c9                	test   %ecx,%ecx
  8005fb:	74 32                	je     80062f <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	b9 00 00 00 00       	mov    $0x0,%ecx
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 a3 00 00 00       	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 10                	mov    (%eax),%edx
  80061c:	8b 48 04             	mov    0x4(%eax),%ecx
  80061f:	8d 40 08             	lea    0x8(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062a:	e9 8b 00 00 00       	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	b9 00 00 00 00       	mov    $0x0,%ecx
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800644:	eb 74                	jmp    8006ba <vprintfmt+0x3a7>
	if (lflag >= 2)
  800646:	83 f9 01             	cmp    $0x1,%ecx
  800649:	7f 1b                	jg     800666 <vprintfmt+0x353>
	else if (lflag)
  80064b:	85 c9                	test   %ecx,%ecx
  80064d:	74 2c                	je     80067b <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	b9 00 00 00 00       	mov    $0x0,%ecx
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065f:	b8 08 00 00 00       	mov    $0x8,%eax
  800664:	eb 54                	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	8b 48 04             	mov    0x4(%eax),%ecx
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800674:	b8 08 00 00 00       	mov    $0x8,%eax
  800679:	eb 3f                	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068b:	b8 08 00 00 00       	mov    $0x8,%eax
  800690:	eb 28                	jmp    8006ba <vprintfmt+0x3a7>
			putch('0', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 30                	push   $0x30
  800698:	ff d6                	call   *%esi
			putch('x', putdat);
  80069a:	83 c4 08             	add    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 78                	push   $0x78
  8006a0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006ac:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006c1:	57                   	push   %edi
  8006c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c5:	50                   	push   %eax
  8006c6:	51                   	push   %ecx
  8006c7:	52                   	push   %edx
  8006c8:	89 da                	mov    %ebx,%edx
  8006ca:	89 f0                	mov    %esi,%eax
  8006cc:	e8 5a fb ff ff       	call   80022b <printnum>
			break;
  8006d1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d7:	e9 55 fc ff ff       	jmp    800331 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x3e9>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	74 2c                	je     800711 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fa:	eb be                	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
  80070f:	eb a9                	jmp    8006ba <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
  800726:	eb 92                	jmp    8006ba <vprintfmt+0x3a7>
			putch(ch, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	6a 25                	push   $0x25
  80072e:	ff d6                	call   *%esi
			break;
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	eb 9f                	jmp    8006d4 <vprintfmt+0x3c1>
			putch('%', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 25                	push   $0x25
  80073b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 f8                	mov    %edi,%eax
  800742:	eb 03                	jmp    800747 <vprintfmt+0x434>
  800744:	83 e8 01             	sub    $0x1,%eax
  800747:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074b:	75 f7                	jne    800744 <vprintfmt+0x431>
  80074d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800750:	eb 82                	jmp    8006d4 <vprintfmt+0x3c1>

00800752 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	83 ec 18             	sub    $0x18,%esp
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800761:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800765:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076f:	85 c0                	test   %eax,%eax
  800771:	74 26                	je     800799 <vsnprintf+0x47>
  800773:	85 d2                	test   %edx,%edx
  800775:	7e 22                	jle    800799 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800777:	ff 75 14             	pushl  0x14(%ebp)
  80077a:	ff 75 10             	pushl  0x10(%ebp)
  80077d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800780:	50                   	push   %eax
  800781:	68 d9 02 80 00       	push   $0x8002d9
  800786:	e8 88 fb ff ff       	call   800313 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800794:	83 c4 10             	add    $0x10,%esp
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    
		return -E_INVAL;
  800799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079e:	eb f7                	jmp    800797 <vsnprintf+0x45>

008007a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a9:	50                   	push   %eax
  8007aa:	ff 75 10             	pushl  0x10(%ebp)
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 9a ff ff ff       	call   800752 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c9:	74 05                	je     8007d0 <strlen+0x16>
		n++;
  8007cb:	83 c0 01             	add    $0x1,%eax
  8007ce:	eb f5                	jmp    8007c5 <strlen+0xb>
	return n;
}
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007db:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 0d                	je     8007f1 <strnlen+0x1f>
  8007e4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007e8:	74 05                	je     8007ef <strnlen+0x1d>
		n++;
  8007ea:	83 c2 01             	add    $0x1,%edx
  8007ed:	eb f1                	jmp    8007e0 <strnlen+0xe>
  8007ef:	89 d0                	mov    %edx,%eax
	return n;
}
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	53                   	push   %ebx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800806:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800809:	83 c2 01             	add    $0x1,%edx
  80080c:	84 c9                	test   %cl,%cl
  80080e:	75 f2                	jne    800802 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800810:	5b                   	pop    %ebx
  800811:	5d                   	pop    %ebp
  800812:	c3                   	ret    

00800813 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	53                   	push   %ebx
  800817:	83 ec 10             	sub    $0x10,%esp
  80081a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80081d:	53                   	push   %ebx
  80081e:	e8 97 ff ff ff       	call   8007ba <strlen>
  800823:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	01 d8                	add    %ebx,%eax
  80082b:	50                   	push   %eax
  80082c:	e8 c2 ff ff ff       	call   8007f3 <strcpy>
	return dst;
}
  800831:	89 d8                	mov    %ebx,%eax
  800833:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800843:	89 c6                	mov    %eax,%esi
  800845:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800848:	89 c2                	mov    %eax,%edx
  80084a:	39 f2                	cmp    %esi,%edx
  80084c:	74 11                	je     80085f <strncpy+0x27>
		*dst++ = *src;
  80084e:	83 c2 01             	add    $0x1,%edx
  800851:	0f b6 19             	movzbl (%ecx),%ebx
  800854:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800857:	80 fb 01             	cmp    $0x1,%bl
  80085a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80085d:	eb eb                	jmp    80084a <strncpy+0x12>
	}
	return ret;
}
  80085f:	5b                   	pop    %ebx
  800860:	5e                   	pop    %esi
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	56                   	push   %esi
  800867:	53                   	push   %ebx
  800868:	8b 75 08             	mov    0x8(%ebp),%esi
  80086b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086e:	8b 55 10             	mov    0x10(%ebp),%edx
  800871:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	85 d2                	test   %edx,%edx
  800875:	74 21                	je     800898 <strlcpy+0x35>
  800877:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80087b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80087d:	39 c2                	cmp    %eax,%edx
  80087f:	74 14                	je     800895 <strlcpy+0x32>
  800881:	0f b6 19             	movzbl (%ecx),%ebx
  800884:	84 db                	test   %bl,%bl
  800886:	74 0b                	je     800893 <strlcpy+0x30>
			*dst++ = *src++;
  800888:	83 c1 01             	add    $0x1,%ecx
  80088b:	83 c2 01             	add    $0x1,%edx
  80088e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800891:	eb ea                	jmp    80087d <strlcpy+0x1a>
  800893:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800895:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800898:	29 f0                	sub    %esi,%eax
}
  80089a:	5b                   	pop    %ebx
  80089b:	5e                   	pop    %esi
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	84 c0                	test   %al,%al
  8008ac:	74 0c                	je     8008ba <strcmp+0x1c>
  8008ae:	3a 02                	cmp    (%edx),%al
  8008b0:	75 08                	jne    8008ba <strcmp+0x1c>
		p++, q++;
  8008b2:	83 c1 01             	add    $0x1,%ecx
  8008b5:	83 c2 01             	add    $0x1,%edx
  8008b8:	eb ed                	jmp    8008a7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ba:	0f b6 c0             	movzbl %al,%eax
  8008bd:	0f b6 12             	movzbl (%edx),%edx
  8008c0:	29 d0                	sub    %edx,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	53                   	push   %ebx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ce:	89 c3                	mov    %eax,%ebx
  8008d0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d3:	eb 06                	jmp    8008db <strncmp+0x17>
		n--, p++, q++;
  8008d5:	83 c0 01             	add    $0x1,%eax
  8008d8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008db:	39 d8                	cmp    %ebx,%eax
  8008dd:	74 16                	je     8008f5 <strncmp+0x31>
  8008df:	0f b6 08             	movzbl (%eax),%ecx
  8008e2:	84 c9                	test   %cl,%cl
  8008e4:	74 04                	je     8008ea <strncmp+0x26>
  8008e6:	3a 0a                	cmp    (%edx),%cl
  8008e8:	74 eb                	je     8008d5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ea:	0f b6 00             	movzbl (%eax),%eax
  8008ed:	0f b6 12             	movzbl (%edx),%edx
  8008f0:	29 d0                	sub    %edx,%eax
}
  8008f2:	5b                   	pop    %ebx
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    
		return 0;
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fa:	eb f6                	jmp    8008f2 <strncmp+0x2e>

008008fc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800906:	0f b6 10             	movzbl (%eax),%edx
  800909:	84 d2                	test   %dl,%dl
  80090b:	74 09                	je     800916 <strchr+0x1a>
		if (*s == c)
  80090d:	38 ca                	cmp    %cl,%dl
  80090f:	74 0a                	je     80091b <strchr+0x1f>
	for (; *s; s++)
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f0                	jmp    800906 <strchr+0xa>
			return (char *) s;
	return 0;
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800927:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80092a:	38 ca                	cmp    %cl,%dl
  80092c:	74 09                	je     800937 <strfind+0x1a>
  80092e:	84 d2                	test   %dl,%dl
  800930:	74 05                	je     800937 <strfind+0x1a>
	for (; *s; s++)
  800932:	83 c0 01             	add    $0x1,%eax
  800935:	eb f0                	jmp    800927 <strfind+0xa>
			break;
	return (char *) s;
}
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	57                   	push   %edi
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
  80093f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800942:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	74 31                	je     80097a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800949:	89 f8                	mov    %edi,%eax
  80094b:	09 c8                	or     %ecx,%eax
  80094d:	a8 03                	test   $0x3,%al
  80094f:	75 23                	jne    800974 <memset+0x3b>
		c &= 0xFF;
  800951:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800955:	89 d3                	mov    %edx,%ebx
  800957:	c1 e3 08             	shl    $0x8,%ebx
  80095a:	89 d0                	mov    %edx,%eax
  80095c:	c1 e0 18             	shl    $0x18,%eax
  80095f:	89 d6                	mov    %edx,%esi
  800961:	c1 e6 10             	shl    $0x10,%esi
  800964:	09 f0                	or     %esi,%eax
  800966:	09 c2                	or     %eax,%edx
  800968:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80096a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	fc                   	cld    
  800970:	f3 ab                	rep stos %eax,%es:(%edi)
  800972:	eb 06                	jmp    80097a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	fc                   	cld    
  800978:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097a:	89 f8                	mov    %edi,%eax
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5f                   	pop    %edi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	57                   	push   %edi
  800985:	56                   	push   %esi
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098f:	39 c6                	cmp    %eax,%esi
  800991:	73 32                	jae    8009c5 <memmove+0x44>
  800993:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800996:	39 c2                	cmp    %eax,%edx
  800998:	76 2b                	jbe    8009c5 <memmove+0x44>
		s += n;
		d += n;
  80099a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099d:	89 fe                	mov    %edi,%esi
  80099f:	09 ce                	or     %ecx,%esi
  8009a1:	09 d6                	or     %edx,%esi
  8009a3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a9:	75 0e                	jne    8009b9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ab:	83 ef 04             	sub    $0x4,%edi
  8009ae:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b4:	fd                   	std    
  8009b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b7:	eb 09                	jmp    8009c2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b9:	83 ef 01             	sub    $0x1,%edi
  8009bc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009bf:	fd                   	std    
  8009c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c2:	fc                   	cld    
  8009c3:	eb 1a                	jmp    8009df <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c5:	89 c2                	mov    %eax,%edx
  8009c7:	09 ca                	or     %ecx,%edx
  8009c9:	09 f2                	or     %esi,%edx
  8009cb:	f6 c2 03             	test   $0x3,%dl
  8009ce:	75 0a                	jne    8009da <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d3:	89 c7                	mov    %eax,%edi
  8009d5:	fc                   	cld    
  8009d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d8:	eb 05                	jmp    8009df <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009da:	89 c7                	mov    %eax,%edi
  8009dc:	fc                   	cld    
  8009dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009df:	5e                   	pop    %esi
  8009e0:	5f                   	pop    %edi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e9:	ff 75 10             	pushl  0x10(%ebp)
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 8a ff ff ff       	call   800981 <memmove>
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	89 c6                	mov    %eax,%esi
  800a06:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a09:	39 f0                	cmp    %esi,%eax
  800a0b:	74 1c                	je     800a29 <memcmp+0x30>
		if (*s1 != *s2)
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	0f b6 1a             	movzbl (%edx),%ebx
  800a13:	38 d9                	cmp    %bl,%cl
  800a15:	75 08                	jne    800a1f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	eb ea                	jmp    800a09 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1f:	0f b6 c1             	movzbl %cl,%eax
  800a22:	0f b6 db             	movzbl %bl,%ebx
  800a25:	29 d8                	sub    %ebx,%eax
  800a27:	eb 05                	jmp    800a2e <memcmp+0x35>
	}

	return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2e:	5b                   	pop    %ebx
  800a2f:	5e                   	pop    %esi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a40:	39 d0                	cmp    %edx,%eax
  800a42:	73 09                	jae    800a4d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a44:	38 08                	cmp    %cl,(%eax)
  800a46:	74 05                	je     800a4d <memfind+0x1b>
	for (; s < ends; s++)
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	eb f3                	jmp    800a40 <memfind+0xe>
			break;
	return (void *) s;
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	57                   	push   %edi
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5b:	eb 03                	jmp    800a60 <strtol+0x11>
		s++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a60:	0f b6 01             	movzbl (%ecx),%eax
  800a63:	3c 20                	cmp    $0x20,%al
  800a65:	74 f6                	je     800a5d <strtol+0xe>
  800a67:	3c 09                	cmp    $0x9,%al
  800a69:	74 f2                	je     800a5d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6b:	3c 2b                	cmp    $0x2b,%al
  800a6d:	74 2a                	je     800a99 <strtol+0x4a>
	int neg = 0;
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a74:	3c 2d                	cmp    $0x2d,%al
  800a76:	74 2b                	je     800aa3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7e:	75 0f                	jne    800a8f <strtol+0x40>
  800a80:	80 39 30             	cmpb   $0x30,(%ecx)
  800a83:	74 28                	je     800aad <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a8c:	0f 44 d8             	cmove  %eax,%ebx
  800a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a97:	eb 50                	jmp    800ae9 <strtol+0x9a>
		s++;
  800a99:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa1:	eb d5                	jmp    800a78 <strtol+0x29>
		s++, neg = 1;
  800aa3:	83 c1 01             	add    $0x1,%ecx
  800aa6:	bf 01 00 00 00       	mov    $0x1,%edi
  800aab:	eb cb                	jmp    800a78 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aad:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab1:	74 0e                	je     800ac1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ab3:	85 db                	test   %ebx,%ebx
  800ab5:	75 d8                	jne    800a8f <strtol+0x40>
		s++, base = 8;
  800ab7:	83 c1 01             	add    $0x1,%ecx
  800aba:	bb 08 00 00 00       	mov    $0x8,%ebx
  800abf:	eb ce                	jmp    800a8f <strtol+0x40>
		s += 2, base = 16;
  800ac1:	83 c1 02             	add    $0x2,%ecx
  800ac4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac9:	eb c4                	jmp    800a8f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800acb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ace:	89 f3                	mov    %esi,%ebx
  800ad0:	80 fb 19             	cmp    $0x19,%bl
  800ad3:	77 29                	ja     800afe <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ad5:	0f be d2             	movsbl %dl,%edx
  800ad8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800adb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ade:	7d 30                	jge    800b10 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ae0:	83 c1 01             	add    $0x1,%ecx
  800ae3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ae7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ae9:	0f b6 11             	movzbl (%ecx),%edx
  800aec:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 09             	cmp    $0x9,%bl
  800af4:	77 d5                	ja     800acb <strtol+0x7c>
			dig = *s - '0';
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 30             	sub    $0x30,%edx
  800afc:	eb dd                	jmp    800adb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800afe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 19             	cmp    $0x19,%bl
  800b06:	77 08                	ja     800b10 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b08:	0f be d2             	movsbl %dl,%edx
  800b0b:	83 ea 37             	sub    $0x37,%edx
  800b0e:	eb cb                	jmp    800adb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b14:	74 05                	je     800b1b <strtol+0xcc>
		*endptr = (char *) s;
  800b16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b19:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1b:	89 c2                	mov    %eax,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	85 ff                	test   %edi,%edi
  800b21:	0f 45 c2             	cmovne %edx,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3a:	89 c3                	mov    %eax,%ebx
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	89 c6                	mov    %eax,%esi
  800b40:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	b8 01 00 00 00       	mov    $0x1,%eax
  800b57:	89 d1                	mov    %edx,%ecx
  800b59:	89 d3                	mov    %edx,%ebx
  800b5b:	89 d7                	mov    %edx,%edi
  800b5d:	89 d6                	mov    %edx,%esi
  800b5f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7c:	89 cb                	mov    %ecx,%ebx
  800b7e:	89 cf                	mov    %ecx,%edi
  800b80:	89 ce                	mov    %ecx,%esi
  800b82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b84:	85 c0                	test   %eax,%eax
  800b86:	7f 08                	jg     800b90 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800b94:	6a 03                	push   $0x3
  800b96:	68 df 26 80 00       	push   $0x8026df
  800b9b:	6a 23                	push   $0x23
  800b9d:	68 fc 26 80 00       	push   $0x8026fc
  800ba2:	e8 95 f5 ff ff       	call   80013c <_panic>

00800ba7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_yield>:

void
sys_yield(void)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bd6:	89 d1                	mov    %edx,%ecx
  800bd8:	89 d3                	mov    %edx,%ebx
  800bda:	89 d7                	mov    %edx,%edi
  800bdc:	89 d6                	mov    %edx,%esi
  800bde:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bee:	be 00 00 00 00       	mov    $0x0,%esi
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c01:	89 f7                	mov    %esi,%edi
  800c03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	7f 08                	jg     800c11 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c11:	83 ec 0c             	sub    $0xc,%esp
  800c14:	50                   	push   %eax
  800c15:	6a 04                	push   $0x4
  800c17:	68 df 26 80 00       	push   $0x8026df
  800c1c:	6a 23                	push   $0x23
  800c1e:	68 fc 26 80 00       	push   $0x8026fc
  800c23:	e8 14 f5 ff ff       	call   80013c <_panic>

00800c28 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c31:	8b 55 08             	mov    0x8(%ebp),%edx
  800c34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c37:	b8 05 00 00 00       	mov    $0x5,%eax
  800c3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c42:	8b 75 18             	mov    0x18(%ebp),%esi
  800c45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c47:	85 c0                	test   %eax,%eax
  800c49:	7f 08                	jg     800c53 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	50                   	push   %eax
  800c57:	6a 05                	push   $0x5
  800c59:	68 df 26 80 00       	push   $0x8026df
  800c5e:	6a 23                	push   $0x23
  800c60:	68 fc 26 80 00       	push   $0x8026fc
  800c65:	e8 d2 f4 ff ff       	call   80013c <_panic>

00800c6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	89 df                	mov    %ebx,%edi
  800c85:	89 de                	mov    %ebx,%esi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 06                	push   $0x6
  800c9b:	68 df 26 80 00       	push   $0x8026df
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 fc 26 80 00       	push   $0x8026fc
  800ca7:	e8 90 f4 ff ff       	call   80013c <_panic>

00800cac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc5:	89 df                	mov    %ebx,%edi
  800cc7:	89 de                	mov    %ebx,%esi
  800cc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	7f 08                	jg     800cd7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	50                   	push   %eax
  800cdb:	6a 08                	push   $0x8
  800cdd:	68 df 26 80 00       	push   $0x8026df
  800ce2:	6a 23                	push   $0x23
  800ce4:	68 fc 26 80 00       	push   $0x8026fc
  800ce9:	e8 4e f4 ff ff       	call   80013c <_panic>

00800cee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 09 00 00 00       	mov    $0x9,%eax
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	89 de                	mov    %ebx,%esi
  800d0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 09                	push   $0x9
  800d1f:	68 df 26 80 00       	push   $0x8026df
  800d24:	6a 23                	push   $0x23
  800d26:	68 fc 26 80 00       	push   $0x8026fc
  800d2b:	e8 0c f4 ff ff       	call   80013c <_panic>

00800d30 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 0a                	push   $0xa
  800d61:	68 df 26 80 00       	push   $0x8026df
  800d66:	6a 23                	push   $0x23
  800d68:	68 fc 26 80 00       	push   $0x8026fc
  800d6d:	e8 ca f3 ff ff       	call   80013c <_panic>

00800d72 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d83:	be 00 00 00 00       	mov    $0x0,%esi
  800d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dab:	89 cb                	mov    %ecx,%ebx
  800dad:	89 cf                	mov    %ecx,%edi
  800daf:	89 ce                	mov    %ecx,%esi
  800db1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7f 08                	jg     800dbf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	50                   	push   %eax
  800dc3:	6a 0d                	push   $0xd
  800dc5:	68 df 26 80 00       	push   $0x8026df
  800dca:	6a 23                	push   $0x23
  800dcc:	68 fc 26 80 00       	push   $0x8026fc
  800dd1:	e8 66 f3 ff ff       	call   80013c <_panic>

00800dd6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800de6:	89 d1                	mov    %edx,%ecx
  800de8:	89 d3                	mov    %edx,%ebx
  800dea:	89 d7                	mov    %edx,%edi
  800dec:	89 d6                	mov    %edx,%esi
  800dee:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	05 00 00 00 30       	add    $0x30000000,%eax
  800e00:	c1 e8 0c             	shr    $0xc,%eax
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e15:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e24:	89 c2                	mov    %eax,%edx
  800e26:	c1 ea 16             	shr    $0x16,%edx
  800e29:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e30:	f6 c2 01             	test   $0x1,%dl
  800e33:	74 2d                	je     800e62 <fd_alloc+0x46>
  800e35:	89 c2                	mov    %eax,%edx
  800e37:	c1 ea 0c             	shr    $0xc,%edx
  800e3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e41:	f6 c2 01             	test   $0x1,%dl
  800e44:	74 1c                	je     800e62 <fd_alloc+0x46>
  800e46:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e4b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e50:	75 d2                	jne    800e24 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e5b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e60:	eb 0a                	jmp    800e6c <fd_alloc+0x50>
			*fd_store = fd;
  800e62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e65:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e74:	83 f8 1f             	cmp    $0x1f,%eax
  800e77:	77 30                	ja     800ea9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e79:	c1 e0 0c             	shl    $0xc,%eax
  800e7c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e81:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e87:	f6 c2 01             	test   $0x1,%dl
  800e8a:	74 24                	je     800eb0 <fd_lookup+0x42>
  800e8c:	89 c2                	mov    %eax,%edx
  800e8e:	c1 ea 0c             	shr    $0xc,%edx
  800e91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e98:	f6 c2 01             	test   $0x1,%dl
  800e9b:	74 1a                	je     800eb7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea0:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    
		return -E_INVAL;
  800ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eae:	eb f7                	jmp    800ea7 <fd_lookup+0x39>
		return -E_INVAL;
  800eb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb5:	eb f0                	jmp    800ea7 <fd_lookup+0x39>
  800eb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebc:	eb e9                	jmp    800ea7 <fd_lookup+0x39>

00800ebe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ec7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ed1:	39 08                	cmp    %ecx,(%eax)
  800ed3:	74 38                	je     800f0d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800ed5:	83 c2 01             	add    $0x1,%edx
  800ed8:	8b 04 95 88 27 80 00 	mov    0x802788(,%edx,4),%eax
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	75 ee                	jne    800ed1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800ee8:	8b 40 48             	mov    0x48(%eax),%eax
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	51                   	push   %ecx
  800eef:	50                   	push   %eax
  800ef0:	68 0c 27 80 00       	push   $0x80270c
  800ef5:	e8 1d f3 ff ff       	call   800217 <cprintf>
	*dev = 0;
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    
			*dev = devtab[i];
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
  800f17:	eb f2                	jmp    800f0b <dev_lookup+0x4d>

00800f19 <fd_close>:
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 24             	sub    $0x24,%esp
  800f22:	8b 75 08             	mov    0x8(%ebp),%esi
  800f25:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f28:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f2b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f2c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f32:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f35:	50                   	push   %eax
  800f36:	e8 33 ff ff ff       	call   800e6e <fd_lookup>
  800f3b:	89 c3                	mov    %eax,%ebx
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	85 c0                	test   %eax,%eax
  800f42:	78 05                	js     800f49 <fd_close+0x30>
	    || fd != fd2)
  800f44:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f47:	74 16                	je     800f5f <fd_close+0x46>
		return (must_exist ? r : 0);
  800f49:	89 f8                	mov    %edi,%eax
  800f4b:	84 c0                	test   %al,%al
  800f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f52:	0f 44 d8             	cmove  %eax,%ebx
}
  800f55:	89 d8                	mov    %ebx,%eax
  800f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f65:	50                   	push   %eax
  800f66:	ff 36                	pushl  (%esi)
  800f68:	e8 51 ff ff ff       	call   800ebe <dev_lookup>
  800f6d:	89 c3                	mov    %eax,%ebx
  800f6f:	83 c4 10             	add    $0x10,%esp
  800f72:	85 c0                	test   %eax,%eax
  800f74:	78 1a                	js     800f90 <fd_close+0x77>
		if (dev->dev_close)
  800f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f79:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	74 0b                	je     800f90 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	56                   	push   %esi
  800f89:	ff d0                	call   *%eax
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f90:	83 ec 08             	sub    $0x8,%esp
  800f93:	56                   	push   %esi
  800f94:	6a 00                	push   $0x0
  800f96:	e8 cf fc ff ff       	call   800c6a <sys_page_unmap>
	return r;
  800f9b:	83 c4 10             	add    $0x10,%esp
  800f9e:	eb b5                	jmp    800f55 <fd_close+0x3c>

00800fa0 <close>:

int
close(int fdnum)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa9:	50                   	push   %eax
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 bc fe ff ff       	call   800e6e <fd_lookup>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	79 02                	jns    800fbb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    
		return fd_close(fd, 1);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	6a 01                	push   $0x1
  800fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc3:	e8 51 ff ff ff       	call   800f19 <fd_close>
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	eb ec                	jmp    800fb9 <close+0x19>

00800fcd <close_all>:

void
close_all(void)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fd9:	83 ec 0c             	sub    $0xc,%esp
  800fdc:	53                   	push   %ebx
  800fdd:	e8 be ff ff ff       	call   800fa0 <close>
	for (i = 0; i < MAXFD; i++)
  800fe2:	83 c3 01             	add    $0x1,%ebx
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	83 fb 20             	cmp    $0x20,%ebx
  800feb:	75 ec                	jne    800fd9 <close_all+0xc>
}
  800fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ffb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ffe:	50                   	push   %eax
  800fff:	ff 75 08             	pushl  0x8(%ebp)
  801002:	e8 67 fe ff ff       	call   800e6e <fd_lookup>
  801007:	89 c3                	mov    %eax,%ebx
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	0f 88 81 00 00 00    	js     801095 <dup+0xa3>
		return r;
	close(newfdnum);
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	ff 75 0c             	pushl  0xc(%ebp)
  80101a:	e8 81 ff ff ff       	call   800fa0 <close>

	newfd = INDEX2FD(newfdnum);
  80101f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801022:	c1 e6 0c             	shl    $0xc,%esi
  801025:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80102b:	83 c4 04             	add    $0x4,%esp
  80102e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801031:	e8 cf fd ff ff       	call   800e05 <fd2data>
  801036:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801038:	89 34 24             	mov    %esi,(%esp)
  80103b:	e8 c5 fd ff ff       	call   800e05 <fd2data>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801045:	89 d8                	mov    %ebx,%eax
  801047:	c1 e8 16             	shr    $0x16,%eax
  80104a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801051:	a8 01                	test   $0x1,%al
  801053:	74 11                	je     801066 <dup+0x74>
  801055:	89 d8                	mov    %ebx,%eax
  801057:	c1 e8 0c             	shr    $0xc,%eax
  80105a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801061:	f6 c2 01             	test   $0x1,%dl
  801064:	75 39                	jne    80109f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801069:	89 d0                	mov    %edx,%eax
  80106b:	c1 e8 0c             	shr    $0xc,%eax
  80106e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801075:	83 ec 0c             	sub    $0xc,%esp
  801078:	25 07 0e 00 00       	and    $0xe07,%eax
  80107d:	50                   	push   %eax
  80107e:	56                   	push   %esi
  80107f:	6a 00                	push   $0x0
  801081:	52                   	push   %edx
  801082:	6a 00                	push   $0x0
  801084:	e8 9f fb ff ff       	call   800c28 <sys_page_map>
  801089:	89 c3                	mov    %eax,%ebx
  80108b:	83 c4 20             	add    $0x20,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	78 31                	js     8010c3 <dup+0xd1>
		goto err;

	return newfdnum;
  801092:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801095:	89 d8                	mov    %ebx,%eax
  801097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80109f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ae:	50                   	push   %eax
  8010af:	57                   	push   %edi
  8010b0:	6a 00                	push   $0x0
  8010b2:	53                   	push   %ebx
  8010b3:	6a 00                	push   $0x0
  8010b5:	e8 6e fb ff ff       	call   800c28 <sys_page_map>
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	83 c4 20             	add    $0x20,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	79 a3                	jns    801066 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010c3:	83 ec 08             	sub    $0x8,%esp
  8010c6:	56                   	push   %esi
  8010c7:	6a 00                	push   $0x0
  8010c9:	e8 9c fb ff ff       	call   800c6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010ce:	83 c4 08             	add    $0x8,%esp
  8010d1:	57                   	push   %edi
  8010d2:	6a 00                	push   $0x0
  8010d4:	e8 91 fb ff ff       	call   800c6a <sys_page_unmap>
	return r;
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	eb b7                	jmp    801095 <dup+0xa3>

008010de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 1c             	sub    $0x1c,%esp
  8010e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	53                   	push   %ebx
  8010ed:	e8 7c fd ff ff       	call   800e6e <fd_lookup>
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 3f                	js     801138 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ff:	50                   	push   %eax
  801100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801103:	ff 30                	pushl  (%eax)
  801105:	e8 b4 fd ff ff       	call   800ebe <dev_lookup>
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	78 27                	js     801138 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801111:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801114:	8b 42 08             	mov    0x8(%edx),%eax
  801117:	83 e0 03             	and    $0x3,%eax
  80111a:	83 f8 01             	cmp    $0x1,%eax
  80111d:	74 1e                	je     80113d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80111f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801122:	8b 40 08             	mov    0x8(%eax),%eax
  801125:	85 c0                	test   %eax,%eax
  801127:	74 35                	je     80115e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	ff 75 10             	pushl  0x10(%ebp)
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	52                   	push   %edx
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
}
  801138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80113d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801142:	8b 40 48             	mov    0x48(%eax),%eax
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	53                   	push   %ebx
  801149:	50                   	push   %eax
  80114a:	68 4d 27 80 00       	push   $0x80274d
  80114f:	e8 c3 f0 ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb da                	jmp    801138 <read+0x5a>
		return -E_NOT_SUPP;
  80115e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801163:	eb d3                	jmp    801138 <read+0x5a>

00801165 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801171:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801174:	bb 00 00 00 00       	mov    $0x0,%ebx
  801179:	39 f3                	cmp    %esi,%ebx
  80117b:	73 23                	jae    8011a0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80117d:	83 ec 04             	sub    $0x4,%esp
  801180:	89 f0                	mov    %esi,%eax
  801182:	29 d8                	sub    %ebx,%eax
  801184:	50                   	push   %eax
  801185:	89 d8                	mov    %ebx,%eax
  801187:	03 45 0c             	add    0xc(%ebp),%eax
  80118a:	50                   	push   %eax
  80118b:	57                   	push   %edi
  80118c:	e8 4d ff ff ff       	call   8010de <read>
		if (m < 0)
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	78 06                	js     80119e <readn+0x39>
			return m;
		if (m == 0)
  801198:	74 06                	je     8011a0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80119a:	01 c3                	add    %eax,%ebx
  80119c:	eb db                	jmp    801179 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80119e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011a0:	89 d8                	mov    %ebx,%eax
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 1c             	sub    $0x1c,%esp
  8011b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b7:	50                   	push   %eax
  8011b8:	53                   	push   %ebx
  8011b9:	e8 b0 fc ff ff       	call   800e6e <fd_lookup>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	78 3a                	js     8011ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011cb:	50                   	push   %eax
  8011cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cf:	ff 30                	pushl  (%eax)
  8011d1:	e8 e8 fc ff ff       	call   800ebe <dev_lookup>
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 22                	js     8011ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e4:	74 1e                	je     801204 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8011ec:	85 d2                	test   %edx,%edx
  8011ee:	74 35                	je     801225 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	ff 75 10             	pushl  0x10(%ebp)
  8011f6:	ff 75 0c             	pushl  0xc(%ebp)
  8011f9:	50                   	push   %eax
  8011fa:	ff d2                	call   *%edx
  8011fc:	83 c4 10             	add    $0x10,%esp
}
  8011ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801202:	c9                   	leave  
  801203:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801204:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801209:	8b 40 48             	mov    0x48(%eax),%eax
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	53                   	push   %ebx
  801210:	50                   	push   %eax
  801211:	68 69 27 80 00       	push   $0x802769
  801216:	e8 fc ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801223:	eb da                	jmp    8011ff <write+0x55>
		return -E_NOT_SUPP;
  801225:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80122a:	eb d3                	jmp    8011ff <write+0x55>

0080122c <seek>:

int
seek(int fdnum, off_t offset)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801235:	50                   	push   %eax
  801236:	ff 75 08             	pushl  0x8(%ebp)
  801239:	e8 30 fc ff ff       	call   800e6e <fd_lookup>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 0e                	js     801253 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801245:	8b 55 0c             	mov    0xc(%ebp),%edx
  801248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	53                   	push   %ebx
  801259:	83 ec 1c             	sub    $0x1c,%esp
  80125c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80125f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801262:	50                   	push   %eax
  801263:	53                   	push   %ebx
  801264:	e8 05 fc ff ff       	call   800e6e <fd_lookup>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	78 37                	js     8012a7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127a:	ff 30                	pushl  (%eax)
  80127c:	e8 3d fc ff ff       	call   800ebe <dev_lookup>
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 1f                	js     8012a7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80128f:	74 1b                	je     8012ac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801294:	8b 52 18             	mov    0x18(%edx),%edx
  801297:	85 d2                	test   %edx,%edx
  801299:	74 32                	je     8012cd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	50                   	push   %eax
  8012a2:	ff d2                	call   *%edx
  8012a4:	83 c4 10             	add    $0x10,%esp
}
  8012a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012ac:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b1:	8b 40 48             	mov    0x48(%eax),%eax
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	53                   	push   %ebx
  8012b8:	50                   	push   %eax
  8012b9:	68 2c 27 80 00       	push   $0x80272c
  8012be:	e8 54 ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cb:	eb da                	jmp    8012a7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d2:	eb d3                	jmp    8012a7 <ftruncate+0x52>

008012d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 1c             	sub    $0x1c,%esp
  8012db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	e8 84 fb ff ff       	call   800e6e <fd_lookup>
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 4b                	js     80133c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f7:	50                   	push   %eax
  8012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fb:	ff 30                	pushl  (%eax)
  8012fd:	e8 bc fb ff ff       	call   800ebe <dev_lookup>
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 33                	js     80133c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801310:	74 2f                	je     801341 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801312:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801315:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80131c:	00 00 00 
	stat->st_isdir = 0;
  80131f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801326:	00 00 00 
	stat->st_dev = dev;
  801329:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	53                   	push   %ebx
  801333:	ff 75 f0             	pushl  -0x10(%ebp)
  801336:	ff 50 14             	call   *0x14(%eax)
  801339:	83 c4 10             	add    $0x10,%esp
}
  80133c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133f:	c9                   	leave  
  801340:	c3                   	ret    
		return -E_NOT_SUPP;
  801341:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801346:	eb f4                	jmp    80133c <fstat+0x68>

00801348 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	56                   	push   %esi
  80134c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	6a 00                	push   $0x0
  801352:	ff 75 08             	pushl  0x8(%ebp)
  801355:	e8 2f 02 00 00       	call   801589 <open>
  80135a:	89 c3                	mov    %eax,%ebx
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	78 1b                	js     80137e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	ff 75 0c             	pushl  0xc(%ebp)
  801369:	50                   	push   %eax
  80136a:	e8 65 ff ff ff       	call   8012d4 <fstat>
  80136f:	89 c6                	mov    %eax,%esi
	close(fd);
  801371:	89 1c 24             	mov    %ebx,(%esp)
  801374:	e8 27 fc ff ff       	call   800fa0 <close>
	return r;
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	89 f3                	mov    %esi,%ebx
}
  80137e:	89 d8                	mov    %ebx,%eax
  801380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801383:	5b                   	pop    %ebx
  801384:	5e                   	pop    %esi
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
  80138c:	89 c6                	mov    %eax,%esi
  80138e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801390:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801397:	74 27                	je     8013c0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801399:	6a 07                	push   $0x7
  80139b:	68 00 50 c0 00       	push   $0xc05000
  8013a0:	56                   	push   %esi
  8013a1:	ff 35 00 40 80 00    	pushl  0x804000
  8013a7:	e8 1f 0c 00 00       	call   801fcb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013ac:	83 c4 0c             	add    $0xc,%esp
  8013af:	6a 00                	push   $0x0
  8013b1:	53                   	push   %ebx
  8013b2:	6a 00                	push   $0x0
  8013b4:	e8 9f 0b 00 00       	call   801f58 <ipc_recv>
}
  8013b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013bc:	5b                   	pop    %ebx
  8013bd:	5e                   	pop    %esi
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	6a 01                	push   $0x1
  8013c5:	e8 6d 0c 00 00       	call   802037 <ipc_find_env>
  8013ca:	a3 00 40 80 00       	mov    %eax,0x804000
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	eb c5                	jmp    801399 <fsipc+0x12>

008013d4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e0:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8013f7:	e8 8b ff ff ff       	call   801387 <fsipc>
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <devfile_flush>:
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8b 40 0c             	mov    0xc(%eax),%eax
  80140a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  80140f:	ba 00 00 00 00       	mov    $0x0,%edx
  801414:	b8 06 00 00 00       	mov    $0x6,%eax
  801419:	e8 69 ff ff ff       	call   801387 <fsipc>
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <devfile_stat>:
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8b 40 0c             	mov    0xc(%eax),%eax
  801430:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801435:	ba 00 00 00 00       	mov    $0x0,%edx
  80143a:	b8 05 00 00 00       	mov    $0x5,%eax
  80143f:	e8 43 ff ff ff       	call   801387 <fsipc>
  801444:	85 c0                	test   %eax,%eax
  801446:	78 2c                	js     801474 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	68 00 50 c0 00       	push   $0xc05000
  801450:	53                   	push   %ebx
  801451:	e8 9d f3 ff ff       	call   8007f3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801456:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80145b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801461:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801466:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <devfile_write>:
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	53                   	push   %ebx
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801483:	85 db                	test   %ebx,%ebx
  801485:	75 07                	jne    80148e <devfile_write+0x15>
	return n_all;
  801487:	89 d8                	mov    %ebx,%eax
}
  801489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8b 40 0c             	mov    0xc(%eax),%eax
  801494:	a3 00 50 c0 00       	mov    %eax,0xc05000
	  fsipcbuf.write.req_n = n_left;
  801499:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	53                   	push   %ebx
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	68 08 50 c0 00       	push   $0xc05008
  8014ab:	e8 d1 f4 ff ff       	call   800981 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8014ba:	e8 c8 fe ff ff       	call   801387 <fsipc>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 c3                	js     801489 <devfile_write+0x10>
	  assert(r <= n_left);
  8014c6:	39 d8                	cmp    %ebx,%eax
  8014c8:	77 0b                	ja     8014d5 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8014ca:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014cf:	7f 1d                	jg     8014ee <devfile_write+0x75>
    n_all += r;
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	eb b2                	jmp    801487 <devfile_write+0xe>
	  assert(r <= n_left);
  8014d5:	68 9c 27 80 00       	push   $0x80279c
  8014da:	68 a8 27 80 00       	push   $0x8027a8
  8014df:	68 9f 00 00 00       	push   $0x9f
  8014e4:	68 bd 27 80 00       	push   $0x8027bd
  8014e9:	e8 4e ec ff ff       	call   80013c <_panic>
	  assert(r <= PGSIZE);
  8014ee:	68 c8 27 80 00       	push   $0x8027c8
  8014f3:	68 a8 27 80 00       	push   $0x8027a8
  8014f8:	68 a0 00 00 00       	push   $0xa0
  8014fd:	68 bd 27 80 00       	push   $0x8027bd
  801502:	e8 35 ec ff ff       	call   80013c <_panic>

00801507 <devfile_read>:
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8b 40 0c             	mov    0xc(%eax),%eax
  801515:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80151a:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801520:	ba 00 00 00 00       	mov    $0x0,%edx
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	e8 58 fe ff ff       	call   801387 <fsipc>
  80152f:	89 c3                	mov    %eax,%ebx
  801531:	85 c0                	test   %eax,%eax
  801533:	78 1f                	js     801554 <devfile_read+0x4d>
	assert(r <= n);
  801535:	39 f0                	cmp    %esi,%eax
  801537:	77 24                	ja     80155d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801539:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80153e:	7f 33                	jg     801573 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	50                   	push   %eax
  801544:	68 00 50 c0 00       	push   $0xc05000
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	e8 30 f4 ff ff       	call   800981 <memmove>
	return r;
  801551:	83 c4 10             	add    $0x10,%esp
}
  801554:	89 d8                	mov    %ebx,%eax
  801556:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    
	assert(r <= n);
  80155d:	68 d4 27 80 00       	push   $0x8027d4
  801562:	68 a8 27 80 00       	push   $0x8027a8
  801567:	6a 7c                	push   $0x7c
  801569:	68 bd 27 80 00       	push   $0x8027bd
  80156e:	e8 c9 eb ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  801573:	68 c8 27 80 00       	push   $0x8027c8
  801578:	68 a8 27 80 00       	push   $0x8027a8
  80157d:	6a 7d                	push   $0x7d
  80157f:	68 bd 27 80 00       	push   $0x8027bd
  801584:	e8 b3 eb ff ff       	call   80013c <_panic>

00801589 <open>:
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
  80158e:	83 ec 1c             	sub    $0x1c,%esp
  801591:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801594:	56                   	push   %esi
  801595:	e8 20 f2 ff ff       	call   8007ba <strlen>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a2:	7f 6c                	jg     801610 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	e8 6c f8 ff ff       	call   800e1c <fd_alloc>
  8015b0:	89 c3                	mov    %eax,%ebx
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 3c                	js     8015f5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015b9:	83 ec 08             	sub    $0x8,%esp
  8015bc:	56                   	push   %esi
  8015bd:	68 00 50 c0 00       	push   $0xc05000
  8015c2:	e8 2c f2 ff ff       	call   8007f3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d7:	e8 ab fd ff ff       	call   801387 <fsipc>
  8015dc:	89 c3                	mov    %eax,%ebx
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 19                	js     8015fe <open+0x75>
	return fd2num(fd);
  8015e5:	83 ec 0c             	sub    $0xc,%esp
  8015e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015eb:	e8 05 f8 ff ff       	call   800df5 <fd2num>
  8015f0:	89 c3                	mov    %eax,%ebx
  8015f2:	83 c4 10             	add    $0x10,%esp
}
  8015f5:	89 d8                	mov    %ebx,%eax
  8015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    
		fd_close(fd, 0);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	6a 00                	push   $0x0
  801603:	ff 75 f4             	pushl  -0xc(%ebp)
  801606:	e8 0e f9 ff ff       	call   800f19 <fd_close>
		return r;
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	eb e5                	jmp    8015f5 <open+0x6c>
		return -E_BAD_PATH;
  801610:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801615:	eb de                	jmp    8015f5 <open+0x6c>

00801617 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80161d:	ba 00 00 00 00       	mov    $0x0,%edx
  801622:	b8 08 00 00 00       	mov    $0x8,%eax
  801627:	e8 5b fd ff ff       	call   801387 <fsipc>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	e8 c4 f7 ff ff       	call   800e05 <fd2data>
  801641:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801643:	83 c4 08             	add    $0x8,%esp
  801646:	68 db 27 80 00       	push   $0x8027db
  80164b:	53                   	push   %ebx
  80164c:	e8 a2 f1 ff ff       	call   8007f3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801651:	8b 46 04             	mov    0x4(%esi),%eax
  801654:	2b 06                	sub    (%esi),%eax
  801656:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80165c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801663:	00 00 00 
	stat->st_dev = &devpipe;
  801666:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80166d:	30 80 00 
	return 0;
}
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	53                   	push   %ebx
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801686:	53                   	push   %ebx
  801687:	6a 00                	push   $0x0
  801689:	e8 dc f5 ff ff       	call   800c6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80168e:	89 1c 24             	mov    %ebx,(%esp)
  801691:	e8 6f f7 ff ff       	call   800e05 <fd2data>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	50                   	push   %eax
  80169a:	6a 00                	push   $0x0
  80169c:	e8 c9 f5 ff ff       	call   800c6a <sys_page_unmap>
}
  8016a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <_pipeisclosed>:
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	57                   	push   %edi
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 1c             	sub    $0x1c,%esp
  8016af:	89 c7                	mov    %eax,%edi
  8016b1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016b3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8016b8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	57                   	push   %edi
  8016bf:	e8 ac 09 00 00       	call   802070 <pageref>
  8016c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c7:	89 34 24             	mov    %esi,(%esp)
  8016ca:	e8 a1 09 00 00       	call   802070 <pageref>
		nn = thisenv->env_runs;
  8016cf:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  8016d5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	39 cb                	cmp    %ecx,%ebx
  8016dd:	74 1b                	je     8016fa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016df:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016e2:	75 cf                	jne    8016b3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016e4:	8b 42 58             	mov    0x58(%edx),%eax
  8016e7:	6a 01                	push   $0x1
  8016e9:	50                   	push   %eax
  8016ea:	53                   	push   %ebx
  8016eb:	68 e2 27 80 00       	push   $0x8027e2
  8016f0:	e8 22 eb ff ff       	call   800217 <cprintf>
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	eb b9                	jmp    8016b3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016fa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016fd:	0f 94 c0             	sete   %al
  801700:	0f b6 c0             	movzbl %al,%eax
}
  801703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5f                   	pop    %edi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <devpipe_write>:
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	57                   	push   %edi
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	83 ec 28             	sub    $0x28,%esp
  801714:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801717:	56                   	push   %esi
  801718:	e8 e8 f6 ff ff       	call   800e05 <fd2data>
  80171d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	bf 00 00 00 00       	mov    $0x0,%edi
  801727:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80172a:	74 4f                	je     80177b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80172c:	8b 43 04             	mov    0x4(%ebx),%eax
  80172f:	8b 0b                	mov    (%ebx),%ecx
  801731:	8d 51 20             	lea    0x20(%ecx),%edx
  801734:	39 d0                	cmp    %edx,%eax
  801736:	72 14                	jb     80174c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801738:	89 da                	mov    %ebx,%edx
  80173a:	89 f0                	mov    %esi,%eax
  80173c:	e8 65 ff ff ff       	call   8016a6 <_pipeisclosed>
  801741:	85 c0                	test   %eax,%eax
  801743:	75 3b                	jne    801780 <devpipe_write+0x75>
			sys_yield();
  801745:	e8 7c f4 ff ff       	call   800bc6 <sys_yield>
  80174a:	eb e0                	jmp    80172c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80174c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801753:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801756:	89 c2                	mov    %eax,%edx
  801758:	c1 fa 1f             	sar    $0x1f,%edx
  80175b:	89 d1                	mov    %edx,%ecx
  80175d:	c1 e9 1b             	shr    $0x1b,%ecx
  801760:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801763:	83 e2 1f             	and    $0x1f,%edx
  801766:	29 ca                	sub    %ecx,%edx
  801768:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80176c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801770:	83 c0 01             	add    $0x1,%eax
  801773:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801776:	83 c7 01             	add    $0x1,%edi
  801779:	eb ac                	jmp    801727 <devpipe_write+0x1c>
	return i;
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	eb 05                	jmp    801785 <devpipe_write+0x7a>
				return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <devpipe_read>:
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	83 ec 18             	sub    $0x18,%esp
  801796:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801799:	57                   	push   %edi
  80179a:	e8 66 f6 ff ff       	call   800e05 <fd2data>
  80179f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	be 00 00 00 00       	mov    $0x0,%esi
  8017a9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017ac:	75 14                	jne    8017c2 <devpipe_read+0x35>
	return i;
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	eb 02                	jmp    8017b5 <devpipe_read+0x28>
				return i;
  8017b3:	89 f0                	mov    %esi,%eax
}
  8017b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
			sys_yield();
  8017bd:	e8 04 f4 ff ff       	call   800bc6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017c2:	8b 03                	mov    (%ebx),%eax
  8017c4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017c7:	75 18                	jne    8017e1 <devpipe_read+0x54>
			if (i > 0)
  8017c9:	85 f6                	test   %esi,%esi
  8017cb:	75 e6                	jne    8017b3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8017cd:	89 da                	mov    %ebx,%edx
  8017cf:	89 f8                	mov    %edi,%eax
  8017d1:	e8 d0 fe ff ff       	call   8016a6 <_pipeisclosed>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	74 e3                	je     8017bd <devpipe_read+0x30>
				return 0;
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	eb d4                	jmp    8017b5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017e1:	99                   	cltd   
  8017e2:	c1 ea 1b             	shr    $0x1b,%edx
  8017e5:	01 d0                	add    %edx,%eax
  8017e7:	83 e0 1f             	and    $0x1f,%eax
  8017ea:	29 d0                	sub    %edx,%eax
  8017ec:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017f7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017fa:	83 c6 01             	add    $0x1,%esi
  8017fd:	eb aa                	jmp    8017a9 <devpipe_read+0x1c>

008017ff <pipe>:
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	e8 0c f6 ff ff       	call   800e1c <fd_alloc>
  801810:	89 c3                	mov    %eax,%ebx
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	0f 88 23 01 00 00    	js     801940 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 07 04 00 00       	push   $0x407
  801825:	ff 75 f4             	pushl  -0xc(%ebp)
  801828:	6a 00                	push   $0x0
  80182a:	e8 b6 f3 ff ff       	call   800be5 <sys_page_alloc>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	0f 88 04 01 00 00    	js     801940 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801842:	50                   	push   %eax
  801843:	e8 d4 f5 ff ff       	call   800e1c <fd_alloc>
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	0f 88 db 00 00 00    	js     801930 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	68 07 04 00 00       	push   $0x407
  80185d:	ff 75 f0             	pushl  -0x10(%ebp)
  801860:	6a 00                	push   $0x0
  801862:	e8 7e f3 ff ff       	call   800be5 <sys_page_alloc>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	0f 88 bc 00 00 00    	js     801930 <pipe+0x131>
	va = fd2data(fd0);
  801874:	83 ec 0c             	sub    $0xc,%esp
  801877:	ff 75 f4             	pushl  -0xc(%ebp)
  80187a:	e8 86 f5 ff ff       	call   800e05 <fd2data>
  80187f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801881:	83 c4 0c             	add    $0xc,%esp
  801884:	68 07 04 00 00       	push   $0x407
  801889:	50                   	push   %eax
  80188a:	6a 00                	push   $0x0
  80188c:	e8 54 f3 ff ff       	call   800be5 <sys_page_alloc>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	85 c0                	test   %eax,%eax
  801898:	0f 88 82 00 00 00    	js     801920 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a4:	e8 5c f5 ff ff       	call   800e05 <fd2data>
  8018a9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018b0:	50                   	push   %eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	56                   	push   %esi
  8018b4:	6a 00                	push   $0x0
  8018b6:	e8 6d f3 ff ff       	call   800c28 <sys_page_map>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	83 c4 20             	add    $0x20,%esp
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	78 4e                	js     801912 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8018c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018db:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ed:	e8 03 f5 ff ff       	call   800df5 <fd2num>
  8018f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018f7:	83 c4 04             	add    $0x4,%esp
  8018fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fd:	e8 f3 f4 ff ff       	call   800df5 <fd2num>
  801902:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801905:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801910:	eb 2e                	jmp    801940 <pipe+0x141>
	sys_page_unmap(0, va);
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	56                   	push   %esi
  801916:	6a 00                	push   $0x0
  801918:	e8 4d f3 ff ff       	call   800c6a <sys_page_unmap>
  80191d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 f0             	pushl  -0x10(%ebp)
  801926:	6a 00                	push   $0x0
  801928:	e8 3d f3 ff ff       	call   800c6a <sys_page_unmap>
  80192d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	ff 75 f4             	pushl  -0xc(%ebp)
  801936:	6a 00                	push   $0x0
  801938:	e8 2d f3 ff ff       	call   800c6a <sys_page_unmap>
  80193d:	83 c4 10             	add    $0x10,%esp
}
  801940:	89 d8                	mov    %ebx,%eax
  801942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <pipeisclosed>:
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	e8 13 f5 ff ff       	call   800e6e <fd_lookup>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 18                	js     80197a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 98 f4 ff ff       	call   800e05 <fd2data>
	return _pipeisclosed(fd, p);
  80196d:	89 c2                	mov    %eax,%edx
  80196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801972:	e8 2f fd ff ff       	call   8016a6 <_pipeisclosed>
  801977:	83 c4 10             	add    $0x10,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801982:	68 fa 27 80 00       	push   $0x8027fa
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	e8 64 ee ff ff       	call   8007f3 <strcpy>
	return 0;
}
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <devsock_close>:
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	53                   	push   %ebx
  80199a:	83 ec 10             	sub    $0x10,%esp
  80199d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019a0:	53                   	push   %ebx
  8019a1:	e8 ca 06 00 00       	call   802070 <pageref>
  8019a6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019ae:	83 f8 01             	cmp    $0x1,%eax
  8019b1:	74 07                	je     8019ba <devsock_close+0x24>
}
  8019b3:	89 d0                	mov    %edx,%eax
  8019b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019ba:	83 ec 0c             	sub    $0xc,%esp
  8019bd:	ff 73 0c             	pushl  0xc(%ebx)
  8019c0:	e8 b9 02 00 00       	call   801c7e <nsipc_close>
  8019c5:	89 c2                	mov    %eax,%edx
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	eb e7                	jmp    8019b3 <devsock_close+0x1d>

008019cc <devsock_write>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	ff 70 0c             	pushl  0xc(%eax)
  8019e0:	e8 76 03 00 00       	call   801d5b <nsipc_send>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <devsock_read>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 10             	pushl  0x10(%ebp)
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	ff 70 0c             	pushl  0xc(%eax)
  8019fb:	e8 ef 02 00 00       	call   801cef <nsipc_recv>
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <fd2sockid>:
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a08:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	e8 5c f4 ff ff       	call   800e6e <fd_lookup>
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 10                	js     801a29 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a22:	39 08                	cmp    %ecx,(%eax)
  801a24:	75 05                	jne    801a2b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a26:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    
		return -E_NOT_SUPP;
  801a2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a30:	eb f7                	jmp    801a29 <fd2sockid+0x27>

00801a32 <alloc_sockfd>:
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	83 ec 1c             	sub    $0x1c,%esp
  801a3a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3f:	50                   	push   %eax
  801a40:	e8 d7 f3 ff ff       	call   800e1c <fd_alloc>
  801a45:	89 c3                	mov    %eax,%ebx
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 43                	js     801a91 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	68 07 04 00 00       	push   $0x407
  801a56:	ff 75 f4             	pushl  -0xc(%ebp)
  801a59:	6a 00                	push   $0x0
  801a5b:	e8 85 f1 ff ff       	call   800be5 <sys_page_alloc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 28                	js     801a91 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a72:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a7e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	50                   	push   %eax
  801a85:	e8 6b f3 ff ff       	call   800df5 <fd2num>
  801a8a:	89 c3                	mov    %eax,%ebx
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	eb 0c                	jmp    801a9d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	56                   	push   %esi
  801a95:	e8 e4 01 00 00       	call   801c7e <nsipc_close>
		return r;
  801a9a:	83 c4 10             	add    $0x10,%esp
}
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa2:	5b                   	pop    %ebx
  801aa3:	5e                   	pop    %esi
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    

00801aa6 <accept>:
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	e8 4e ff ff ff       	call   801a02 <fd2sockid>
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	78 1b                	js     801ad3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	ff 75 10             	pushl  0x10(%ebp)
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	50                   	push   %eax
  801ac2:	e8 0e 01 00 00       	call   801bd5 <nsipc_accept>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 05                	js     801ad3 <accept+0x2d>
	return alloc_sockfd(r);
  801ace:	e8 5f ff ff ff       	call   801a32 <alloc_sockfd>
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <bind>:
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	e8 1f ff ff ff       	call   801a02 <fd2sockid>
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 12                	js     801af9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	ff 75 10             	pushl  0x10(%ebp)
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	50                   	push   %eax
  801af1:	e8 31 01 00 00       	call   801c27 <nsipc_bind>
  801af6:	83 c4 10             	add    $0x10,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <shutdown>:
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	e8 f9 fe ff ff       	call   801a02 <fd2sockid>
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 0f                	js     801b1c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	e8 43 01 00 00       	call   801c5c <nsipc_shutdown>
  801b19:	83 c4 10             	add    $0x10,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <connect>:
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	e8 d6 fe ff ff       	call   801a02 <fd2sockid>
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	78 12                	js     801b42 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	50                   	push   %eax
  801b3a:	e8 59 01 00 00       	call   801c98 <nsipc_connect>
  801b3f:	83 c4 10             	add    $0x10,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <listen>:
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	e8 b0 fe ff ff       	call   801a02 <fd2sockid>
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 0f                	js     801b65 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b56:	83 ec 08             	sub    $0x8,%esp
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	50                   	push   %eax
  801b5d:	e8 6b 01 00 00       	call   801ccd <nsipc_listen>
  801b62:	83 c4 10             	add    $0x10,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b6d:	ff 75 10             	pushl  0x10(%ebp)
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	e8 3e 02 00 00       	call   801db9 <nsipc_socket>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 05                	js     801b87 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b82:	e8 ab fe ff ff       	call   801a32 <alloc_sockfd>
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	53                   	push   %ebx
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b92:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b99:	74 26                	je     801bc1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b9b:	6a 07                	push   $0x7
  801b9d:	68 00 60 c0 00       	push   $0xc06000
  801ba2:	53                   	push   %ebx
  801ba3:	ff 35 04 40 80 00    	pushl  0x804004
  801ba9:	e8 1d 04 00 00       	call   801fcb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bae:	83 c4 0c             	add    $0xc,%esp
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 9c 03 00 00       	call   801f58 <ipc_recv>
}
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	6a 02                	push   $0x2
  801bc6:	e8 6c 04 00 00       	call   802037 <ipc_find_env>
  801bcb:	a3 04 40 80 00       	mov    %eax,0x804004
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	eb c6                	jmp    801b9b <nsipc+0x12>

00801bd5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801be5:	8b 06                	mov    (%esi),%eax
  801be7:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bec:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf1:	e8 93 ff ff ff       	call   801b89 <nsipc>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	79 09                	jns    801c05 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5e                   	pop    %esi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	ff 35 10 60 c0 00    	pushl  0xc06010
  801c0e:	68 00 60 c0 00       	push   $0xc06000
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	e8 66 ed ff ff       	call   800981 <memmove>
		*addrlen = ret->ret_addrlen;
  801c1b:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801c20:	89 06                	mov    %eax,(%esi)
  801c22:	83 c4 10             	add    $0x10,%esp
	return r;
  801c25:	eb d5                	jmp    801bfc <nsipc_accept+0x27>

00801c27 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	53                   	push   %ebx
  801c2b:	83 ec 08             	sub    $0x8,%esp
  801c2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c39:	53                   	push   %ebx
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	68 04 60 c0 00       	push   $0xc06004
  801c42:	e8 3a ed ff ff       	call   800981 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c47:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801c4d:	b8 02 00 00 00       	mov    $0x2,%eax
  801c52:	e8 32 ff ff ff       	call   801b89 <nsipc>
}
  801c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801c72:	b8 03 00 00 00       	mov    $0x3,%eax
  801c77:	e8 0d ff ff ff       	call   801b89 <nsipc>
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <nsipc_close>:

int
nsipc_close(int s)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801c8c:	b8 04 00 00 00       	mov    $0x4,%eax
  801c91:	e8 f3 fe ff ff       	call   801b89 <nsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801caa:	53                   	push   %ebx
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	68 04 60 c0 00       	push   $0xc06004
  801cb3:	e8 c9 ec ff ff       	call   800981 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cb8:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801cbe:	b8 05 00 00 00       	mov    $0x5,%eax
  801cc3:	e8 c1 fe ff ff       	call   801b89 <nsipc>
}
  801cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801ce3:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce8:	e8 9c fe ff ff       	call   801b89 <nsipc>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801cff:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801d05:	8b 45 14             	mov    0x14(%ebp),%eax
  801d08:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d0d:	b8 07 00 00 00       	mov    $0x7,%eax
  801d12:	e8 72 fe ff ff       	call   801b89 <nsipc>
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	78 1f                	js     801d3c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d1d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d22:	7f 21                	jg     801d45 <nsipc_recv+0x56>
  801d24:	39 c6                	cmp    %eax,%esi
  801d26:	7c 1d                	jl     801d45 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	50                   	push   %eax
  801d2c:	68 00 60 c0 00       	push   $0xc06000
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	e8 48 ec ff ff       	call   800981 <memmove>
  801d39:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d3c:	89 d8                	mov    %ebx,%eax
  801d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d41:	5b                   	pop    %ebx
  801d42:	5e                   	pop    %esi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d45:	68 06 28 80 00       	push   $0x802806
  801d4a:	68 a8 27 80 00       	push   $0x8027a8
  801d4f:	6a 62                	push   $0x62
  801d51:	68 1b 28 80 00       	push   $0x80281b
  801d56:	e8 e1 e3 ff ff       	call   80013c <_panic>

00801d5b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801d6d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d73:	7f 2e                	jg     801da3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	53                   	push   %ebx
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	68 0c 60 c0 00       	push   $0xc0600c
  801d81:	e8 fb eb ff ff       	call   800981 <memmove>
	nsipcbuf.send.req_size = size;
  801d86:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8f:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801d94:	b8 08 00 00 00       	mov    $0x8,%eax
  801d99:	e8 eb fd ff ff       	call   801b89 <nsipc>
}
  801d9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    
	assert(size < 1600);
  801da3:	68 27 28 80 00       	push   $0x802827
  801da8:	68 a8 27 80 00       	push   $0x8027a8
  801dad:	6a 6d                	push   $0x6d
  801daf:	68 1b 28 80 00       	push   $0x80281b
  801db4:	e8 83 e3 ff ff       	call   80013c <_panic>

00801db9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd2:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801dd7:	b8 09 00 00 00       	mov    $0x9,%eax
  801ddc:	e8 a8 fd ff ff       	call   801b89 <nsipc>
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	c3                   	ret    

00801de9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801def:	68 33 28 80 00       	push   $0x802833
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	e8 f7 e9 ff ff       	call   8007f3 <strcpy>
	return 0;
}
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devcons_write>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	57                   	push   %edi
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e0f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e14:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e1a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e1d:	73 31                	jae    801e50 <devcons_write+0x4d>
		m = n - tot;
  801e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e22:	29 f3                	sub    %esi,%ebx
  801e24:	83 fb 7f             	cmp    $0x7f,%ebx
  801e27:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e2c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	53                   	push   %ebx
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	03 45 0c             	add    0xc(%ebp),%eax
  801e38:	50                   	push   %eax
  801e39:	57                   	push   %edi
  801e3a:	e8 42 eb ff ff       	call   800981 <memmove>
		sys_cputs(buf, m);
  801e3f:	83 c4 08             	add    $0x8,%esp
  801e42:	53                   	push   %ebx
  801e43:	57                   	push   %edi
  801e44:	e8 e0 ec ff ff       	call   800b29 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e49:	01 de                	add    %ebx,%esi
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	eb ca                	jmp    801e1a <devcons_write+0x17>
}
  801e50:	89 f0                	mov    %esi,%eax
  801e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5f                   	pop    %edi
  801e58:	5d                   	pop    %ebp
  801e59:	c3                   	ret    

00801e5a <devcons_read>:
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e69:	74 21                	je     801e8c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801e6b:	e8 d7 ec ff ff       	call   800b47 <sys_cgetc>
  801e70:	85 c0                	test   %eax,%eax
  801e72:	75 07                	jne    801e7b <devcons_read+0x21>
		sys_yield();
  801e74:	e8 4d ed ff ff       	call   800bc6 <sys_yield>
  801e79:	eb f0                	jmp    801e6b <devcons_read+0x11>
	if (c < 0)
  801e7b:	78 0f                	js     801e8c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801e7d:	83 f8 04             	cmp    $0x4,%eax
  801e80:	74 0c                	je     801e8e <devcons_read+0x34>
	*(char*)vbuf = c;
  801e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e85:	88 02                	mov    %al,(%edx)
	return 1;
  801e87:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    
		return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	eb f7                	jmp    801e8c <devcons_read+0x32>

00801e95 <cputchar>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ea1:	6a 01                	push   $0x1
  801ea3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea6:	50                   	push   %eax
  801ea7:	e8 7d ec ff ff       	call   800b29 <sys_cputs>
}
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <getchar>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801eb7:	6a 01                	push   $0x1
  801eb9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ebc:	50                   	push   %eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	e8 1a f2 ff ff       	call   8010de <read>
	if (r < 0)
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 06                	js     801ed1 <getchar+0x20>
	if (r < 1)
  801ecb:	74 06                	je     801ed3 <getchar+0x22>
	return c;
  801ecd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    
		return -E_EOF;
  801ed3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ed8:	eb f7                	jmp    801ed1 <getchar+0x20>

00801eda <iscons>:
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee3:	50                   	push   %eax
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	e8 82 ef ff ff       	call   800e6e <fd_lookup>
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 11                	js     801f04 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801efc:	39 10                	cmp    %edx,(%eax)
  801efe:	0f 94 c0             	sete   %al
  801f01:	0f b6 c0             	movzbl %al,%eax
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <opencons>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0f:	50                   	push   %eax
  801f10:	e8 07 ef ff ff       	call   800e1c <fd_alloc>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 3a                	js     801f56 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 b7 ec ff ff       	call   800be5 <sys_page_alloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 21                	js     801f56 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f3e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	50                   	push   %eax
  801f4e:	e8 a2 ee ff ff       	call   800df5 <fd2num>
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	56                   	push   %esi
  801f5c:	53                   	push   %ebx
  801f5d:	8b 75 08             	mov    0x8(%ebp),%esi
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f66:	85 c0                	test   %eax,%eax
  801f68:	74 4f                	je     801fb9 <ipc_recv+0x61>
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	50                   	push   %eax
  801f6e:	e8 22 ee ff ff       	call   800d95 <sys_ipc_recv>
  801f73:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f76:	85 f6                	test   %esi,%esi
  801f78:	74 14                	je     801f8e <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	75 09                	jne    801f8c <ipc_recv+0x34>
  801f83:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801f89:	8b 52 74             	mov    0x74(%edx),%edx
  801f8c:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f8e:	85 db                	test   %ebx,%ebx
  801f90:	74 14                	je     801fa6 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 09                	jne    801fa4 <ipc_recv+0x4c>
  801f9b:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801fa1:	8b 52 78             	mov    0x78(%edx),%edx
  801fa4:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	75 08                	jne    801fb2 <ipc_recv+0x5a>
  801faa:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801faf:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb5:	5b                   	pop    %ebx
  801fb6:	5e                   	pop    %esi
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	68 00 00 c0 ee       	push   $0xeec00000
  801fc1:	e8 cf ed ff ff       	call   800d95 <sys_ipc_recv>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	eb ab                	jmp    801f76 <ipc_recv+0x1e>

00801fcb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	57                   	push   %edi
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fd7:	8b 75 10             	mov    0x10(%ebp),%esi
  801fda:	eb 20                	jmp    801ffc <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801fdc:	6a 00                	push   $0x0
  801fde:	68 00 00 c0 ee       	push   $0xeec00000
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	57                   	push   %edi
  801fe7:	e8 86 ed ff ff       	call   800d72 <sys_ipc_try_send>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	eb 1f                	jmp    802012 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801ff3:	e8 ce eb ff ff       	call   800bc6 <sys_yield>
	while(retval != 0) {
  801ff8:	85 db                	test   %ebx,%ebx
  801ffa:	74 33                	je     80202f <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801ffc:	85 f6                	test   %esi,%esi
  801ffe:	74 dc                	je     801fdc <ipc_send+0x11>
  802000:	ff 75 14             	pushl  0x14(%ebp)
  802003:	56                   	push   %esi
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	57                   	push   %edi
  802008:	e8 65 ed ff ff       	call   800d72 <sys_ipc_try_send>
  80200d:	89 c3                	mov    %eax,%ebx
  80200f:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802012:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802015:	74 dc                	je     801ff3 <ipc_send+0x28>
  802017:	85 db                	test   %ebx,%ebx
  802019:	74 d8                	je     801ff3 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	68 40 28 80 00       	push   $0x802840
  802023:	6a 35                	push   $0x35
  802025:	68 70 28 80 00       	push   $0x802870
  80202a:	e8 0d e1 ff ff       	call   80013c <_panic>
	}
}
  80202f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802032:	5b                   	pop    %ebx
  802033:	5e                   	pop    %esi
  802034:	5f                   	pop    %edi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    

00802037 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802042:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802045:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80204b:	8b 52 50             	mov    0x50(%edx),%edx
  80204e:	39 ca                	cmp    %ecx,%edx
  802050:	74 11                	je     802063 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802052:	83 c0 01             	add    $0x1,%eax
  802055:	3d 00 04 00 00       	cmp    $0x400,%eax
  80205a:	75 e6                	jne    802042 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	eb 0b                	jmp    80206e <ipc_find_env+0x37>
			return envs[i].env_id;
  802063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80206b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    

00802070 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802076:	89 d0                	mov    %edx,%eax
  802078:	c1 e8 16             	shr    $0x16,%eax
  80207b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802087:	f6 c1 01             	test   $0x1,%cl
  80208a:	74 1d                	je     8020a9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80208c:	c1 ea 0c             	shr    $0xc,%edx
  80208f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802096:	f6 c2 01             	test   $0x1,%dl
  802099:	74 0e                	je     8020a9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80209b:	c1 ea 0c             	shr    $0xc,%edx
  80209e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020a5:	ef 
  8020a6:	0f b7 c0             	movzwl %ax,%eax
}
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    
  8020ab:	66 90                	xchg   %ax,%ax
  8020ad:	66 90                	xchg   %ax,%ax
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020cb:	85 d2                	test   %edx,%edx
  8020cd:	75 49                	jne    802118 <__udivdi3+0x68>
  8020cf:	39 f3                	cmp    %esi,%ebx
  8020d1:	76 15                	jbe    8020e8 <__udivdi3+0x38>
  8020d3:	31 ff                	xor    %edi,%edi
  8020d5:	89 e8                	mov    %ebp,%eax
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	f7 f3                	div    %ebx
  8020db:	89 fa                	mov    %edi,%edx
  8020dd:	83 c4 1c             	add    $0x1c,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	8d 76 00             	lea    0x0(%esi),%esi
  8020e8:	89 d9                	mov    %ebx,%ecx
  8020ea:	85 db                	test   %ebx,%ebx
  8020ec:	75 0b                	jne    8020f9 <__udivdi3+0x49>
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f3                	div    %ebx
  8020f7:	89 c1                	mov    %eax,%ecx
  8020f9:	31 d2                	xor    %edx,%edx
  8020fb:	89 f0                	mov    %esi,%eax
  8020fd:	f7 f1                	div    %ecx
  8020ff:	89 c6                	mov    %eax,%esi
  802101:	89 e8                	mov    %ebp,%eax
  802103:	89 f7                	mov    %esi,%edi
  802105:	f7 f1                	div    %ecx
  802107:	89 fa                	mov    %edi,%edx
  802109:	83 c4 1c             	add    $0x1c,%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5f                   	pop    %edi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
  802111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	77 1c                	ja     802138 <__udivdi3+0x88>
  80211c:	0f bd fa             	bsr    %edx,%edi
  80211f:	83 f7 1f             	xor    $0x1f,%edi
  802122:	75 2c                	jne    802150 <__udivdi3+0xa0>
  802124:	39 f2                	cmp    %esi,%edx
  802126:	72 06                	jb     80212e <__udivdi3+0x7e>
  802128:	31 c0                	xor    %eax,%eax
  80212a:	39 eb                	cmp    %ebp,%ebx
  80212c:	77 ad                	ja     8020db <__udivdi3+0x2b>
  80212e:	b8 01 00 00 00       	mov    $0x1,%eax
  802133:	eb a6                	jmp    8020db <__udivdi3+0x2b>
  802135:	8d 76 00             	lea    0x0(%esi),%esi
  802138:	31 ff                	xor    %edi,%edi
  80213a:	31 c0                	xor    %eax,%eax
  80213c:	89 fa                	mov    %edi,%edx
  80213e:	83 c4 1c             	add    $0x1c,%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    
  802146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80214d:	8d 76 00             	lea    0x0(%esi),%esi
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	89 eb                	mov    %ebp,%ebx
  802181:	d3 e6                	shl    %cl,%esi
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 15                	jb     8021b0 <__udivdi3+0x100>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 04                	jae    8021a7 <__udivdi3+0xf7>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	74 09                	je     8021b0 <__udivdi3+0x100>
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	31 ff                	xor    %edi,%edi
  8021ab:	e9 2b ff ff ff       	jmp    8020db <__udivdi3+0x2b>
  8021b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	e9 21 ff ff ff       	jmp    8020db <__udivdi3+0x2b>
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021d3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021db:	89 da                	mov    %ebx,%edx
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	75 3f                	jne    802220 <__umoddi3+0x60>
  8021e1:	39 df                	cmp    %ebx,%edi
  8021e3:	76 13                	jbe    8021f8 <__umoddi3+0x38>
  8021e5:	89 f0                	mov    %esi,%eax
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	89 fd                	mov    %edi,%ebp
  8021fa:	85 ff                	test   %edi,%edi
  8021fc:	75 0b                	jne    802209 <__umoddi3+0x49>
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	31 d2                	xor    %edx,%edx
  802205:	f7 f7                	div    %edi
  802207:	89 c5                	mov    %eax,%ebp
  802209:	89 d8                	mov    %ebx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f5                	div    %ebp
  80220f:	89 f0                	mov    %esi,%eax
  802211:	f7 f5                	div    %ebp
  802213:	89 d0                	mov    %edx,%eax
  802215:	eb d4                	jmp    8021eb <__umoddi3+0x2b>
  802217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80221e:	66 90                	xchg   %ax,%ax
  802220:	89 f1                	mov    %esi,%ecx
  802222:	39 d8                	cmp    %ebx,%eax
  802224:	76 0a                	jbe    802230 <__umoddi3+0x70>
  802226:	89 f0                	mov    %esi,%eax
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	0f bd e8             	bsr    %eax,%ebp
  802233:	83 f5 1f             	xor    $0x1f,%ebp
  802236:	75 20                	jne    802258 <__umoddi3+0x98>
  802238:	39 d8                	cmp    %ebx,%eax
  80223a:	0f 82 b0 00 00 00    	jb     8022f0 <__umoddi3+0x130>
  802240:	39 f7                	cmp    %esi,%edi
  802242:	0f 86 a8 00 00 00    	jbe    8022f0 <__umoddi3+0x130>
  802248:	89 c8                	mov    %ecx,%eax
  80224a:	83 c4 1c             	add    $0x1c,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
  802252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802258:	89 e9                	mov    %ebp,%ecx
  80225a:	ba 20 00 00 00       	mov    $0x20,%edx
  80225f:	29 ea                	sub    %ebp,%edx
  802261:	d3 e0                	shl    %cl,%eax
  802263:	89 44 24 08          	mov    %eax,0x8(%esp)
  802267:	89 d1                	mov    %edx,%ecx
  802269:	89 f8                	mov    %edi,%eax
  80226b:	d3 e8                	shr    %cl,%eax
  80226d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802271:	89 54 24 04          	mov    %edx,0x4(%esp)
  802275:	8b 54 24 04          	mov    0x4(%esp),%edx
  802279:	09 c1                	or     %eax,%ecx
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 e9                	mov    %ebp,%ecx
  802283:	d3 e7                	shl    %cl,%edi
  802285:	89 d1                	mov    %edx,%ecx
  802287:	d3 e8                	shr    %cl,%eax
  802289:	89 e9                	mov    %ebp,%ecx
  80228b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80228f:	d3 e3                	shl    %cl,%ebx
  802291:	89 c7                	mov    %eax,%edi
  802293:	89 d1                	mov    %edx,%ecx
  802295:	89 f0                	mov    %esi,%eax
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 fa                	mov    %edi,%edx
  80229d:	d3 e6                	shl    %cl,%esi
  80229f:	09 d8                	or     %ebx,%eax
  8022a1:	f7 74 24 08          	divl   0x8(%esp)
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	89 f3                	mov    %esi,%ebx
  8022a9:	f7 64 24 0c          	mull   0xc(%esp)
  8022ad:	89 c6                	mov    %eax,%esi
  8022af:	89 d7                	mov    %edx,%edi
  8022b1:	39 d1                	cmp    %edx,%ecx
  8022b3:	72 06                	jb     8022bb <__umoddi3+0xfb>
  8022b5:	75 10                	jne    8022c7 <__umoddi3+0x107>
  8022b7:	39 c3                	cmp    %eax,%ebx
  8022b9:	73 0c                	jae    8022c7 <__umoddi3+0x107>
  8022bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022c3:	89 d7                	mov    %edx,%edi
  8022c5:	89 c6                	mov    %eax,%esi
  8022c7:	89 ca                	mov    %ecx,%edx
  8022c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ce:	29 f3                	sub    %esi,%ebx
  8022d0:	19 fa                	sbb    %edi,%edx
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	d3 e0                	shl    %cl,%eax
  8022d6:	89 e9                	mov    %ebp,%ecx
  8022d8:	d3 eb                	shr    %cl,%ebx
  8022da:	d3 ea                	shr    %cl,%edx
  8022dc:	09 d8                	or     %ebx,%eax
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	89 da                	mov    %ebx,%edx
  8022f2:	29 fe                	sub    %edi,%esi
  8022f4:	19 c2                	sbb    %eax,%edx
  8022f6:	89 f1                	mov    %esi,%ecx
  8022f8:	89 c8                	mov    %ecx,%eax
  8022fa:	e9 4b ff ff ff       	jmp    80224a <__umoddi3+0x8a>
