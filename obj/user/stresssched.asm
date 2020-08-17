
obj/user/stresssched.debug：     文件格式 elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 71 0b 00 00       	call   800bae <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 2a 0f 00 00       	call   800f73 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 73 0b 00 00       	call   800bcd <sys_yield>
		return;
  80005a:	eb 69                	jmp    8000c5 <umain+0x92>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	6b d6 7c             	imul   $0x7c,%esi,%edx
  800065:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006b:	eb 02                	jmp    80006f <umain+0x3c>
		asm volatile("pause");
  80006d:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006f:	8b 42 54             	mov    0x54(%edx),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	75 f7                	jne    80006d <umain+0x3a>
  800076:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007b:	e8 4d 0b 00 00       	call   800bcd <sys_yield>
  800080:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800085:	a1 08 40 80 00       	mov    0x804008,%eax
  80008a:	83 c0 01             	add    $0x1,%eax
  80008d:	a3 08 40 80 00       	mov    %eax,0x804008
		for (j = 0; j < 10000; j++)
  800092:	83 ea 01             	sub    $0x1,%edx
  800095:	75 ee                	jne    800085 <umain+0x52>
	for (i = 0; i < 10; i++) {
  800097:	83 eb 01             	sub    $0x1,%ebx
  80009a:	75 df                	jne    80007b <umain+0x48>
	}

	if (counter != 10*10000)
  80009c:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a1:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a6:	75 24                	jne    8000cc <umain+0x99>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000a8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000ad:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b0:	8b 40 48             	mov    0x48(%eax),%eax
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	52                   	push   %edx
  8000b7:	50                   	push   %eax
  8000b8:	68 9b 27 80 00       	push   $0x80279b
  8000bd:	e8 5c 01 00 00       	call   80021e <cprintf>
  8000c2:	83 c4 10             	add    $0x10,%esp

}
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d1:	50                   	push   %eax
  8000d2:	68 60 27 80 00       	push   $0x802760
  8000d7:	6a 21                	push   $0x21
  8000d9:	68 88 27 80 00       	push   $0x802788
  8000de:	e8 60 00 00 00       	call   800143 <_panic>

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 bb 0a 00 00       	call   800bae <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 19 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012f:	e8 45 12 00 00       	call   801379 <close_all>
	sys_env_destroy(0);
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	6a 00                	push   $0x0
  800139:	e8 2f 0a 00 00       	call   800b6d <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800148:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800151:	e8 58 0a 00 00       	call   800bae <sys_getenvid>
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	56                   	push   %esi
  800160:	50                   	push   %eax
  800161:	68 c4 27 80 00       	push   $0x8027c4
  800166:	e8 b3 00 00 00       	call   80021e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80016b:	83 c4 18             	add    $0x18,%esp
  80016e:	53                   	push   %ebx
  80016f:	ff 75 10             	pushl  0x10(%ebp)
  800172:	e8 56 00 00 00       	call   8001cd <vcprintf>
	cprintf("\n");
  800177:	c7 04 24 b7 27 80 00 	movl   $0x8027b7,(%esp)
  80017e:	e8 9b 00 00 00       	call   80021e <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800186:	cc                   	int3   
  800187:	eb fd                	jmp    800186 <_panic+0x43>

00800189 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	53                   	push   %ebx
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800193:	8b 13                	mov    (%ebx),%edx
  800195:	8d 42 01             	lea    0x1(%edx),%eax
  800198:	89 03                	mov    %eax,(%ebx)
  80019a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a6:	74 09                	je     8001b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	68 ff 00 00 00       	push   $0xff
  8001b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bc:	50                   	push   %eax
  8001bd:	e8 6e 09 00 00       	call   800b30 <sys_cputs>
		b->idx = 0;
  8001c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c8:	83 c4 10             	add    $0x10,%esp
  8001cb:	eb db                	jmp    8001a8 <putch+0x1f>

008001cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001dd:	00 00 00 
	b.cnt = 0;
  8001e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ea:	ff 75 0c             	pushl  0xc(%ebp)
  8001ed:	ff 75 08             	pushl  0x8(%ebp)
  8001f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	68 89 01 80 00       	push   $0x800189
  8001fc:	e8 19 01 00 00       	call   80031a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800201:	83 c4 08             	add    $0x8,%esp
  800204:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 1a 09 00 00       	call   800b30 <sys_cputs>

	return b.cnt;
}
  800216:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800224:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800227:	50                   	push   %eax
  800228:	ff 75 08             	pushl  0x8(%ebp)
  80022b:	e8 9d ff ff ff       	call   8001cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 1c             	sub    $0x1c,%esp
  80023b:	89 c7                	mov    %eax,%edi
  80023d:	89 d6                	mov    %edx,%esi
  80023f:	8b 45 08             	mov    0x8(%ebp),%eax
  800242:	8b 55 0c             	mov    0xc(%ebp),%edx
  800245:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800248:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80024e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800253:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800256:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800259:	3b 45 10             	cmp    0x10(%ebp),%eax
  80025c:	89 d0                	mov    %edx,%eax
  80025e:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800261:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800264:	73 15                	jae    80027b <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800266:	83 eb 01             	sub    $0x1,%ebx
  800269:	85 db                	test   %ebx,%ebx
  80026b:	7e 43                	jle    8002b0 <printnum+0x7e>
			putch(padc, putdat);
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	56                   	push   %esi
  800271:	ff 75 18             	pushl  0x18(%ebp)
  800274:	ff d7                	call   *%edi
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	eb eb                	jmp    800266 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	8b 45 14             	mov    0x14(%ebp),%eax
  800284:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800287:	53                   	push   %ebx
  800288:	ff 75 10             	pushl  0x10(%ebp)
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800291:	ff 75 e0             	pushl  -0x20(%ebp)
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	ff 75 d8             	pushl  -0x28(%ebp)
  80029a:	e8 61 22 00 00       	call   802500 <__udivdi3>
  80029f:	83 c4 18             	add    $0x18,%esp
  8002a2:	52                   	push   %edx
  8002a3:	50                   	push   %eax
  8002a4:	89 f2                	mov    %esi,%edx
  8002a6:	89 f8                	mov    %edi,%eax
  8002a8:	e8 85 ff ff ff       	call   800232 <printnum>
  8002ad:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	56                   	push   %esi
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c3:	e8 48 23 00 00       	call   802610 <__umoddi3>
  8002c8:	83 c4 14             	add    $0x14,%esp
  8002cb:	0f be 80 e7 27 80 00 	movsbl 0x8027e7(%eax),%eax
  8002d2:	50                   	push   %eax
  8002d3:	ff d7                	call   *%edi
}
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002db:	5b                   	pop    %ebx
  8002dc:	5e                   	pop    %esi
  8002dd:	5f                   	pop    %edi
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ea:	8b 10                	mov    (%eax),%edx
  8002ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ef:	73 0a                	jae    8002fb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f4:	89 08                	mov    %ecx,(%eax)
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	88 02                	mov    %al,(%edx)
}
  8002fb:	5d                   	pop    %ebp
  8002fc:	c3                   	ret    

008002fd <printfmt>:
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800303:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800306:	50                   	push   %eax
  800307:	ff 75 10             	pushl  0x10(%ebp)
  80030a:	ff 75 0c             	pushl  0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 05 00 00 00       	call   80031a <vprintfmt>
}
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <vprintfmt>:
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 3c             	sub    $0x3c,%esp
  800323:	8b 75 08             	mov    0x8(%ebp),%esi
  800326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800329:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032c:	eb 0a                	jmp    800338 <vprintfmt+0x1e>
			putch(ch, putdat);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	53                   	push   %ebx
  800332:	50                   	push   %eax
  800333:	ff d6                	call   *%esi
  800335:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800338:	83 c7 01             	add    $0x1,%edi
  80033b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80033f:	83 f8 25             	cmp    $0x25,%eax
  800342:	74 0c                	je     800350 <vprintfmt+0x36>
			if (ch == '\0')
  800344:	85 c0                	test   %eax,%eax
  800346:	75 e6                	jne    80032e <vprintfmt+0x14>
}
  800348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034b:	5b                   	pop    %ebx
  80034c:	5e                   	pop    %esi
  80034d:	5f                   	pop    %edi
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    
		padc = ' ';
  800350:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800354:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80035b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800362:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800369:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8d 47 01             	lea    0x1(%edi),%eax
  800371:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800374:	0f b6 17             	movzbl (%edi),%edx
  800377:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037a:	3c 55                	cmp    $0x55,%al
  80037c:	0f 87 ba 03 00 00    	ja     80073c <vprintfmt+0x422>
  800382:	0f b6 c0             	movzbl %al,%eax
  800385:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800393:	eb d9                	jmp    80036e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800398:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80039c:	eb d0                	jmp    80036e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	0f b6 d2             	movzbl %dl,%edx
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b9:	83 f9 09             	cmp    $0x9,%ecx
  8003bc:	77 55                	ja     800413 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003be:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c1:	eb e9                	jmp    8003ac <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8d 40 04             	lea    0x4(%eax),%eax
  8003d1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003db:	79 91                	jns    80036e <vprintfmt+0x54>
				width = precision, precision = -1;
  8003dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ea:	eb 82                	jmp    80036e <vprintfmt+0x54>
  8003ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ef:	85 c0                	test   %eax,%eax
  8003f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f6:	0f 49 d0             	cmovns %eax,%edx
  8003f9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ff:	e9 6a ff ff ff       	jmp    80036e <vprintfmt+0x54>
  800404:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800407:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80040e:	e9 5b ff ff ff       	jmp    80036e <vprintfmt+0x54>
  800413:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800416:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800419:	eb bc                	jmp    8003d7 <vprintfmt+0xbd>
			lflag++;
  80041b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800421:	e9 48 ff ff ff       	jmp    80036e <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	53                   	push   %ebx
  800430:	ff 30                	pushl  (%eax)
  800432:	ff d6                	call   *%esi
			break;
  800434:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800437:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043a:	e9 9c 02 00 00       	jmp    8006db <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8d 78 04             	lea    0x4(%eax),%edi
  800445:	8b 00                	mov    (%eax),%eax
  800447:	99                   	cltd   
  800448:	31 d0                	xor    %edx,%eax
  80044a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044c:	83 f8 0f             	cmp    $0xf,%eax
  80044f:	7f 23                	jg     800474 <vprintfmt+0x15a>
  800451:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  800458:	85 d2                	test   %edx,%edx
  80045a:	74 18                	je     800474 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80045c:	52                   	push   %edx
  80045d:	68 26 2d 80 00       	push   $0x802d26
  800462:	53                   	push   %ebx
  800463:	56                   	push   %esi
  800464:	e8 94 fe ff ff       	call   8002fd <printfmt>
  800469:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046f:	e9 67 02 00 00       	jmp    8006db <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800474:	50                   	push   %eax
  800475:	68 ff 27 80 00       	push   $0x8027ff
  80047a:	53                   	push   %ebx
  80047b:	56                   	push   %esi
  80047c:	e8 7c fe ff ff       	call   8002fd <printfmt>
  800481:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800484:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800487:	e9 4f 02 00 00       	jmp    8006db <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	83 c0 04             	add    $0x4,%eax
  800492:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800495:	8b 45 14             	mov    0x14(%ebp),%eax
  800498:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049a:	85 d2                	test   %edx,%edx
  80049c:	b8 f8 27 80 00       	mov    $0x8027f8,%eax
  8004a1:	0f 45 c2             	cmovne %edx,%eax
  8004a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ab:	7e 06                	jle    8004b3 <vprintfmt+0x199>
  8004ad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b1:	75 0d                	jne    8004c0 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b6:	89 c7                	mov    %eax,%edi
  8004b8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004be:	eb 3f                	jmp    8004ff <vprintfmt+0x1e5>
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c6:	50                   	push   %eax
  8004c7:	e8 0d 03 00 00       	call   8007d9 <strnlen>
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	29 c2                	sub    %eax,%edx
  8004d1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7e 58                	jle    80053c <vprintfmt+0x222>
					putch(padc, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	53                   	push   %ebx
  8004e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	83 ef 01             	sub    $0x1,%edi
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	eb eb                	jmp    8004e0 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	53                   	push   %ebx
  8004f9:	52                   	push   %edx
  8004fa:	ff d6                	call   *%esi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800502:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800504:	83 c7 01             	add    $0x1,%edi
  800507:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050b:	0f be d0             	movsbl %al,%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 45                	je     800557 <vprintfmt+0x23d>
  800512:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800516:	78 06                	js     80051e <vprintfmt+0x204>
  800518:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051c:	78 35                	js     800553 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80051e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800522:	74 d1                	je     8004f5 <vprintfmt+0x1db>
  800524:	0f be c0             	movsbl %al,%eax
  800527:	83 e8 20             	sub    $0x20,%eax
  80052a:	83 f8 5e             	cmp    $0x5e,%eax
  80052d:	76 c6                	jbe    8004f5 <vprintfmt+0x1db>
					putch('?', putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	53                   	push   %ebx
  800533:	6a 3f                	push   $0x3f
  800535:	ff d6                	call   *%esi
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	eb c3                	jmp    8004ff <vprintfmt+0x1e5>
  80053c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80053f:	85 d2                	test   %edx,%edx
  800541:	b8 00 00 00 00       	mov    $0x0,%eax
  800546:	0f 49 c2             	cmovns %edx,%eax
  800549:	29 c2                	sub    %eax,%edx
  80054b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80054e:	e9 60 ff ff ff       	jmp    8004b3 <vprintfmt+0x199>
  800553:	89 cf                	mov    %ecx,%edi
  800555:	eb 02                	jmp    800559 <vprintfmt+0x23f>
  800557:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800559:	85 ff                	test   %edi,%edi
  80055b:	7e 10                	jle    80056d <vprintfmt+0x253>
				putch(' ', putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	53                   	push   %ebx
  800561:	6a 20                	push   $0x20
  800563:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800565:	83 ef 01             	sub    $0x1,%edi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	eb ec                	jmp    800559 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 63 01 00 00       	jmp    8006db <vprintfmt+0x3c1>
	if (lflag >= 2)
  800578:	83 f9 01             	cmp    $0x1,%ecx
  80057b:	7f 1b                	jg     800598 <vprintfmt+0x27e>
	else if (lflag)
  80057d:	85 c9                	test   %ecx,%ecx
  80057f:	74 63                	je     8005e4 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800589:	99                   	cltd   
  80058a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 17                	jmp    8005af <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	0f 89 ff 00 00 00    	jns    8006c1 <vprintfmt+0x3a7>
				putch('-', putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 2d                	push   $0x2d
  8005c8:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d0:	f7 da                	neg    %edx
  8005d2:	83 d1 00             	adc    $0x0,%ecx
  8005d5:	f7 d9                	neg    %ecx
  8005d7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005df:	e9 dd 00 00 00       	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	99                   	cltd   
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 40 04             	lea    0x4(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f9:	eb b4                	jmp    8005af <vprintfmt+0x295>
	if (lflag >= 2)
  8005fb:	83 f9 01             	cmp    $0x1,%ecx
  8005fe:	7f 1e                	jg     80061e <vprintfmt+0x304>
	else if (lflag)
  800600:	85 c9                	test   %ecx,%ecx
  800602:	74 32                	je     800636 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 a3 00 00 00       	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	8b 48 04             	mov    0x4(%eax),%ecx
  800626:	8d 40 08             	lea    0x8(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 8b 00 00 00       	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 10                	mov    (%eax),%edx
  80063b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800646:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064b:	eb 74                	jmp    8006c1 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80064d:	83 f9 01             	cmp    $0x1,%ecx
  800650:	7f 1b                	jg     80066d <vprintfmt+0x353>
	else if (lflag)
  800652:	85 c9                	test   %ecx,%ecx
  800654:	74 2c                	je     800682 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 10                	mov    (%eax),%edx
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800660:	8d 40 04             	lea    0x4(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800666:	b8 08 00 00 00       	mov    $0x8,%eax
  80066b:	eb 54                	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 10                	mov    (%eax),%edx
  800672:	8b 48 04             	mov    0x4(%eax),%ecx
  800675:	8d 40 08             	lea    0x8(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067b:	b8 08 00 00 00       	mov    $0x8,%eax
  800680:	eb 3f                	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 10                	mov    (%eax),%edx
  800687:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800692:	b8 08 00 00 00       	mov    $0x8,%eax
  800697:	eb 28                	jmp    8006c1 <vprintfmt+0x3a7>
			putch('0', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 30                	push   $0x30
  80069f:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a1:	83 c4 08             	add    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 78                	push   $0x78
  8006a7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 10                	mov    (%eax),%edx
  8006ae:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006c8:	57                   	push   %edi
  8006c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	51                   	push   %ecx
  8006ce:	52                   	push   %edx
  8006cf:	89 da                	mov    %ebx,%edx
  8006d1:	89 f0                	mov    %esi,%eax
  8006d3:	e8 5a fb ff ff       	call   800232 <printnum>
			break;
  8006d8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006de:	e9 55 fc ff ff       	jmp    800338 <vprintfmt+0x1e>
	if (lflag >= 2)
  8006e3:	83 f9 01             	cmp    $0x1,%ecx
  8006e6:	7f 1b                	jg     800703 <vprintfmt+0x3e9>
	else if (lflag)
  8006e8:	85 c9                	test   %ecx,%ecx
  8006ea:	74 2c                	je     800718 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 10                	mov    (%eax),%edx
  8006f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800701:	eb be                	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 10                	mov    (%eax),%edx
  800708:	8b 48 04             	mov    0x4(%eax),%ecx
  80070b:	8d 40 08             	lea    0x8(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	b8 10 00 00 00       	mov    $0x10,%eax
  800716:	eb a9                	jmp    8006c1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 10                	mov    (%eax),%edx
  80071d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800728:	b8 10 00 00 00       	mov    $0x10,%eax
  80072d:	eb 92                	jmp    8006c1 <vprintfmt+0x3a7>
			putch(ch, putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 25                	push   $0x25
  800735:	ff d6                	call   *%esi
			break;
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	eb 9f                	jmp    8006db <vprintfmt+0x3c1>
			putch('%', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	53                   	push   %ebx
  800740:	6a 25                	push   $0x25
  800742:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	89 f8                	mov    %edi,%eax
  800749:	eb 03                	jmp    80074e <vprintfmt+0x434>
  80074b:	83 e8 01             	sub    $0x1,%eax
  80074e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800752:	75 f7                	jne    80074b <vprintfmt+0x431>
  800754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800757:	eb 82                	jmp    8006db <vprintfmt+0x3c1>

00800759 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800768:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80076c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80076f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800776:	85 c0                	test   %eax,%eax
  800778:	74 26                	je     8007a0 <vsnprintf+0x47>
  80077a:	85 d2                	test   %edx,%edx
  80077c:	7e 22                	jle    8007a0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80077e:	ff 75 14             	pushl  0x14(%ebp)
  800781:	ff 75 10             	pushl  0x10(%ebp)
  800784:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800787:	50                   	push   %eax
  800788:	68 e0 02 80 00       	push   $0x8002e0
  80078d:	e8 88 fb ff ff       	call   80031a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800795:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079b:	83 c4 10             	add    $0x10,%esp
}
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    
		return -E_INVAL;
  8007a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a5:	eb f7                	jmp    80079e <vsnprintf+0x45>

008007a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ad:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b0:	50                   	push   %eax
  8007b1:	ff 75 10             	pushl  0x10(%ebp)
  8007b4:	ff 75 0c             	pushl  0xc(%ebp)
  8007b7:	ff 75 08             	pushl  0x8(%ebp)
  8007ba:	e8 9a ff ff ff       	call   800759 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d0:	74 05                	je     8007d7 <strlen+0x16>
		n++;
  8007d2:	83 c0 01             	add    $0x1,%eax
  8007d5:	eb f5                	jmp    8007cc <strlen+0xb>
	return n;
}
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007df:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	74 0d                	je     8007f8 <strnlen+0x1f>
  8007eb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007ef:	74 05                	je     8007f6 <strnlen+0x1d>
		n++;
  8007f1:	83 c2 01             	add    $0x1,%edx
  8007f4:	eb f1                	jmp    8007e7 <strnlen+0xe>
  8007f6:	89 d0                	mov    %edx,%eax
	return n;
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80080d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800810:	83 c2 01             	add    $0x1,%edx
  800813:	84 c9                	test   %cl,%cl
  800815:	75 f2                	jne    800809 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800817:	5b                   	pop    %ebx
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	83 ec 10             	sub    $0x10,%esp
  800821:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800824:	53                   	push   %ebx
  800825:	e8 97 ff ff ff       	call   8007c1 <strlen>
  80082a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	01 d8                	add    %ebx,%eax
  800832:	50                   	push   %eax
  800833:	e8 c2 ff ff ff       	call   8007fa <strcpy>
	return dst;
}
  800838:	89 d8                	mov    %ebx,%eax
  80083a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083d:	c9                   	leave  
  80083e:	c3                   	ret    

0080083f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084a:	89 c6                	mov    %eax,%esi
  80084c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80084f:	89 c2                	mov    %eax,%edx
  800851:	39 f2                	cmp    %esi,%edx
  800853:	74 11                	je     800866 <strncpy+0x27>
		*dst++ = *src;
  800855:	83 c2 01             	add    $0x1,%edx
  800858:	0f b6 19             	movzbl (%ecx),%ebx
  80085b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085e:	80 fb 01             	cmp    $0x1,%bl
  800861:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800864:	eb eb                	jmp    800851 <strncpy+0x12>
	}
	return ret;
}
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 75 08             	mov    0x8(%ebp),%esi
  800872:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800875:	8b 55 10             	mov    0x10(%ebp),%edx
  800878:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80087a:	85 d2                	test   %edx,%edx
  80087c:	74 21                	je     80089f <strlcpy+0x35>
  80087e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800882:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800884:	39 c2                	cmp    %eax,%edx
  800886:	74 14                	je     80089c <strlcpy+0x32>
  800888:	0f b6 19             	movzbl (%ecx),%ebx
  80088b:	84 db                	test   %bl,%bl
  80088d:	74 0b                	je     80089a <strlcpy+0x30>
			*dst++ = *src++;
  80088f:	83 c1 01             	add    $0x1,%ecx
  800892:	83 c2 01             	add    $0x1,%edx
  800895:	88 5a ff             	mov    %bl,-0x1(%edx)
  800898:	eb ea                	jmp    800884 <strlcpy+0x1a>
  80089a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80089c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80089f:	29 f0                	sub    %esi,%eax
}
  8008a1:	5b                   	pop    %ebx
  8008a2:	5e                   	pop    %esi
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ae:	0f b6 01             	movzbl (%ecx),%eax
  8008b1:	84 c0                	test   %al,%al
  8008b3:	74 0c                	je     8008c1 <strcmp+0x1c>
  8008b5:	3a 02                	cmp    (%edx),%al
  8008b7:	75 08                	jne    8008c1 <strcmp+0x1c>
		p++, q++;
  8008b9:	83 c1 01             	add    $0x1,%ecx
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	eb ed                	jmp    8008ae <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c1:	0f b6 c0             	movzbl %al,%eax
  8008c4:	0f b6 12             	movzbl (%edx),%edx
  8008c7:	29 d0                	sub    %edx,%eax
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d5:	89 c3                	mov    %eax,%ebx
  8008d7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008da:	eb 06                	jmp    8008e2 <strncmp+0x17>
		n--, p++, q++;
  8008dc:	83 c0 01             	add    $0x1,%eax
  8008df:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008e2:	39 d8                	cmp    %ebx,%eax
  8008e4:	74 16                	je     8008fc <strncmp+0x31>
  8008e6:	0f b6 08             	movzbl (%eax),%ecx
  8008e9:	84 c9                	test   %cl,%cl
  8008eb:	74 04                	je     8008f1 <strncmp+0x26>
  8008ed:	3a 0a                	cmp    (%edx),%cl
  8008ef:	74 eb                	je     8008dc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f1:	0f b6 00             	movzbl (%eax),%eax
  8008f4:	0f b6 12             	movzbl (%edx),%edx
  8008f7:	29 d0                	sub    %edx,%eax
}
  8008f9:	5b                   	pop    %ebx
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    
		return 0;
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	eb f6                	jmp    8008f9 <strncmp+0x2e>

00800903 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090d:	0f b6 10             	movzbl (%eax),%edx
  800910:	84 d2                	test   %dl,%dl
  800912:	74 09                	je     80091d <strchr+0x1a>
		if (*s == c)
  800914:	38 ca                	cmp    %cl,%dl
  800916:	74 0a                	je     800922 <strchr+0x1f>
	for (; *s; s++)
  800918:	83 c0 01             	add    $0x1,%eax
  80091b:	eb f0                	jmp    80090d <strchr+0xa>
			return (char *) s;
	return 0;
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800931:	38 ca                	cmp    %cl,%dl
  800933:	74 09                	je     80093e <strfind+0x1a>
  800935:	84 d2                	test   %dl,%dl
  800937:	74 05                	je     80093e <strfind+0x1a>
	for (; *s; s++)
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	eb f0                	jmp    80092e <strfind+0xa>
			break;
	return (char *) s;
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	57                   	push   %edi
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	8b 7d 08             	mov    0x8(%ebp),%edi
  800949:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094c:	85 c9                	test   %ecx,%ecx
  80094e:	74 31                	je     800981 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800950:	89 f8                	mov    %edi,%eax
  800952:	09 c8                	or     %ecx,%eax
  800954:	a8 03                	test   $0x3,%al
  800956:	75 23                	jne    80097b <memset+0x3b>
		c &= 0xFF;
  800958:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095c:	89 d3                	mov    %edx,%ebx
  80095e:	c1 e3 08             	shl    $0x8,%ebx
  800961:	89 d0                	mov    %edx,%eax
  800963:	c1 e0 18             	shl    $0x18,%eax
  800966:	89 d6                	mov    %edx,%esi
  800968:	c1 e6 10             	shl    $0x10,%esi
  80096b:	09 f0                	or     %esi,%eax
  80096d:	09 c2                	or     %eax,%edx
  80096f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800971:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800974:	89 d0                	mov    %edx,%eax
  800976:	fc                   	cld    
  800977:	f3 ab                	rep stos %eax,%es:(%edi)
  800979:	eb 06                	jmp    800981 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	fc                   	cld    
  80097f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800981:	89 f8                	mov    %edi,%eax
  800983:	5b                   	pop    %ebx
  800984:	5e                   	pop    %esi
  800985:	5f                   	pop    %edi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	57                   	push   %edi
  80098c:	56                   	push   %esi
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 75 0c             	mov    0xc(%ebp),%esi
  800993:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800996:	39 c6                	cmp    %eax,%esi
  800998:	73 32                	jae    8009cc <memmove+0x44>
  80099a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80099d:	39 c2                	cmp    %eax,%edx
  80099f:	76 2b                	jbe    8009cc <memmove+0x44>
		s += n;
		d += n;
  8009a1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a4:	89 fe                	mov    %edi,%esi
  8009a6:	09 ce                	or     %ecx,%esi
  8009a8:	09 d6                	or     %edx,%esi
  8009aa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b0:	75 0e                	jne    8009c0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b2:	83 ef 04             	sub    $0x4,%edi
  8009b5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009bb:	fd                   	std    
  8009bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009be:	eb 09                	jmp    8009c9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c0:	83 ef 01             	sub    $0x1,%edi
  8009c3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c6:	fd                   	std    
  8009c7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c9:	fc                   	cld    
  8009ca:	eb 1a                	jmp    8009e6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	09 ca                	or     %ecx,%edx
  8009d0:	09 f2                	or     %esi,%edx
  8009d2:	f6 c2 03             	test   $0x3,%dl
  8009d5:	75 0a                	jne    8009e1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009da:	89 c7                	mov    %eax,%edi
  8009dc:	fc                   	cld    
  8009dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009df:	eb 05                	jmp    8009e6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009e1:	89 c7                	mov    %eax,%edi
  8009e3:	fc                   	cld    
  8009e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e6:	5e                   	pop    %esi
  8009e7:	5f                   	pop    %edi
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f0:	ff 75 10             	pushl  0x10(%ebp)
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	ff 75 08             	pushl  0x8(%ebp)
  8009f9:	e8 8a ff ff ff       	call   800988 <memmove>
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0b:	89 c6                	mov    %eax,%esi
  800a0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a10:	39 f0                	cmp    %esi,%eax
  800a12:	74 1c                	je     800a30 <memcmp+0x30>
		if (*s1 != *s2)
  800a14:	0f b6 08             	movzbl (%eax),%ecx
  800a17:	0f b6 1a             	movzbl (%edx),%ebx
  800a1a:	38 d9                	cmp    %bl,%cl
  800a1c:	75 08                	jne    800a26 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a1e:	83 c0 01             	add    $0x1,%eax
  800a21:	83 c2 01             	add    $0x1,%edx
  800a24:	eb ea                	jmp    800a10 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a26:	0f b6 c1             	movzbl %cl,%eax
  800a29:	0f b6 db             	movzbl %bl,%ebx
  800a2c:	29 d8                	sub    %ebx,%eax
  800a2e:	eb 05                	jmp    800a35 <memcmp+0x35>
	}

	return 0;
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a42:	89 c2                	mov    %eax,%edx
  800a44:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a47:	39 d0                	cmp    %edx,%eax
  800a49:	73 09                	jae    800a54 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a4b:	38 08                	cmp    %cl,(%eax)
  800a4d:	74 05                	je     800a54 <memfind+0x1b>
	for (; s < ends; s++)
  800a4f:	83 c0 01             	add    $0x1,%eax
  800a52:	eb f3                	jmp    800a47 <memfind+0xe>
			break;
	return (void *) s;
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a62:	eb 03                	jmp    800a67 <strtol+0x11>
		s++;
  800a64:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a67:	0f b6 01             	movzbl (%ecx),%eax
  800a6a:	3c 20                	cmp    $0x20,%al
  800a6c:	74 f6                	je     800a64 <strtol+0xe>
  800a6e:	3c 09                	cmp    $0x9,%al
  800a70:	74 f2                	je     800a64 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a72:	3c 2b                	cmp    $0x2b,%al
  800a74:	74 2a                	je     800aa0 <strtol+0x4a>
	int neg = 0;
  800a76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a7b:	3c 2d                	cmp    $0x2d,%al
  800a7d:	74 2b                	je     800aaa <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a85:	75 0f                	jne    800a96 <strtol+0x40>
  800a87:	80 39 30             	cmpb   $0x30,(%ecx)
  800a8a:	74 28                	je     800ab4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a8c:	85 db                	test   %ebx,%ebx
  800a8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a93:	0f 44 d8             	cmove  %eax,%ebx
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9e:	eb 50                	jmp    800af0 <strtol+0x9a>
		s++;
  800aa0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa8:	eb d5                	jmp    800a7f <strtol+0x29>
		s++, neg = 1;
  800aaa:	83 c1 01             	add    $0x1,%ecx
  800aad:	bf 01 00 00 00       	mov    $0x1,%edi
  800ab2:	eb cb                	jmp    800a7f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab8:	74 0e                	je     800ac8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	75 d8                	jne    800a96 <strtol+0x40>
		s++, base = 8;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac6:	eb ce                	jmp    800a96 <strtol+0x40>
		s += 2, base = 16;
  800ac8:	83 c1 02             	add    $0x2,%ecx
  800acb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ad0:	eb c4                	jmp    800a96 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ad2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad5:	89 f3                	mov    %esi,%ebx
  800ad7:	80 fb 19             	cmp    $0x19,%bl
  800ada:	77 29                	ja     800b05 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800adc:	0f be d2             	movsbl %dl,%edx
  800adf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae5:	7d 30                	jge    800b17 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af0:	0f b6 11             	movzbl (%ecx),%edx
  800af3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af6:	89 f3                	mov    %esi,%ebx
  800af8:	80 fb 09             	cmp    $0x9,%bl
  800afb:	77 d5                	ja     800ad2 <strtol+0x7c>
			dig = *s - '0';
  800afd:	0f be d2             	movsbl %dl,%edx
  800b00:	83 ea 30             	sub    $0x30,%edx
  800b03:	eb dd                	jmp    800ae2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b05:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b08:	89 f3                	mov    %esi,%ebx
  800b0a:	80 fb 19             	cmp    $0x19,%bl
  800b0d:	77 08                	ja     800b17 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b0f:	0f be d2             	movsbl %dl,%edx
  800b12:	83 ea 37             	sub    $0x37,%edx
  800b15:	eb cb                	jmp    800ae2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 05                	je     800b22 <strtol+0xcc>
		*endptr = (char *) s;
  800b1d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b20:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b22:	89 c2                	mov    %eax,%edx
  800b24:	f7 da                	neg    %edx
  800b26:	85 ff                	test   %edi,%edi
  800b28:	0f 45 c2             	cmovne %edx,%eax
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5f                   	pop    %edi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b41:	89 c3                	mov    %eax,%ebx
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	89 c6                	mov    %eax,%esi
  800b47:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
  800b59:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5e:	89 d1                	mov    %edx,%ecx
  800b60:	89 d3                	mov    %edx,%ebx
  800b62:	89 d7                	mov    %edx,%edi
  800b64:	89 d6                	mov    %edx,%esi
  800b66:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b83:	89 cb                	mov    %ecx,%ebx
  800b85:	89 cf                	mov    %ecx,%edi
  800b87:	89 ce                	mov    %ecx,%esi
  800b89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8b:	85 c0                	test   %eax,%eax
  800b8d:	7f 08                	jg     800b97 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5f                   	pop    %edi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b97:	83 ec 0c             	sub    $0xc,%esp
  800b9a:	50                   	push   %eax
  800b9b:	6a 03                	push   $0x3
  800b9d:	68 df 2a 80 00       	push   $0x802adf
  800ba2:	6a 23                	push   $0x23
  800ba4:	68 fc 2a 80 00       	push   $0x802afc
  800ba9:	e8 95 f5 ff ff       	call   800143 <_panic>

00800bae <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_yield>:

void
sys_yield(void)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bdd:	89 d1                	mov    %edx,%ecx
  800bdf:	89 d3                	mov    %edx,%ebx
  800be1:	89 d7                	mov    %edx,%edi
  800be3:	89 d6                	mov    %edx,%esi
  800be5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf5:	be 00 00 00 00       	mov    $0x0,%esi
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c00:	b8 04 00 00 00       	mov    $0x4,%eax
  800c05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c08:	89 f7                	mov    %esi,%edi
  800c0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	7f 08                	jg     800c18 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	50                   	push   %eax
  800c1c:	6a 04                	push   $0x4
  800c1e:	68 df 2a 80 00       	push   $0x802adf
  800c23:	6a 23                	push   $0x23
  800c25:	68 fc 2a 80 00       	push   $0x802afc
  800c2a:	e8 14 f5 ff ff       	call   800143 <_panic>

00800c2f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c46:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c49:	8b 75 18             	mov    0x18(%ebp),%esi
  800c4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	7f 08                	jg     800c5a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	50                   	push   %eax
  800c5e:	6a 05                	push   $0x5
  800c60:	68 df 2a 80 00       	push   $0x802adf
  800c65:	6a 23                	push   $0x23
  800c67:	68 fc 2a 80 00       	push   $0x802afc
  800c6c:	e8 d2 f4 ff ff       	call   800143 <_panic>

00800c71 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 06 00 00 00       	mov    $0x6,%eax
  800c8a:	89 df                	mov    %ebx,%edi
  800c8c:	89 de                	mov    %ebx,%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 06                	push   $0x6
  800ca2:	68 df 2a 80 00       	push   $0x802adf
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 fc 2a 80 00       	push   $0x802afc
  800cae:	e8 90 f4 ff ff       	call   800143 <_panic>

00800cb3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	b8 08 00 00 00       	mov    $0x8,%eax
  800ccc:	89 df                	mov    %ebx,%edi
  800cce:	89 de                	mov    %ebx,%esi
  800cd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	7f 08                	jg     800cde <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cde:	83 ec 0c             	sub    $0xc,%esp
  800ce1:	50                   	push   %eax
  800ce2:	6a 08                	push   $0x8
  800ce4:	68 df 2a 80 00       	push   $0x802adf
  800ce9:	6a 23                	push   $0x23
  800ceb:	68 fc 2a 80 00       	push   $0x802afc
  800cf0:	e8 4e f4 ff ff       	call   800143 <_panic>

00800cf5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0e:	89 df                	mov    %ebx,%edi
  800d10:	89 de                	mov    %ebx,%esi
  800d12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d14:	85 c0                	test   %eax,%eax
  800d16:	7f 08                	jg     800d20 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	50                   	push   %eax
  800d24:	6a 09                	push   $0x9
  800d26:	68 df 2a 80 00       	push   $0x802adf
  800d2b:	6a 23                	push   $0x23
  800d2d:	68 fc 2a 80 00       	push   $0x802afc
  800d32:	e8 0c f4 ff ff       	call   800143 <_panic>

00800d37 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d50:	89 df                	mov    %ebx,%edi
  800d52:	89 de                	mov    %ebx,%esi
  800d54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7f 08                	jg     800d62 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	50                   	push   %eax
  800d66:	6a 0a                	push   $0xa
  800d68:	68 df 2a 80 00       	push   $0x802adf
  800d6d:	6a 23                	push   $0x23
  800d6f:	68 fc 2a 80 00       	push   $0x802afc
  800d74:	e8 ca f3 ff ff       	call   800143 <_panic>

00800d79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d8a:	be 00 00 00 00       	mov    $0x0,%esi
  800d8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d95:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
  800da2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db2:	89 cb                	mov    %ecx,%ebx
  800db4:	89 cf                	mov    %ecx,%edi
  800db6:	89 ce                	mov    %ecx,%esi
  800db8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7f 08                	jg     800dc6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	50                   	push   %eax
  800dca:	6a 0d                	push   $0xd
  800dcc:	68 df 2a 80 00       	push   $0x802adf
  800dd1:	6a 23                	push   $0x23
  800dd3:	68 fc 2a 80 00       	push   $0x802afc
  800dd8:	e8 66 f3 ff ff       	call   800143 <_panic>

00800ddd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ded:	89 d1                	mov    %edx,%ecx
  800def:	89 d3                	mov    %edx,%ebx
  800df1:	89 d7                	mov    %edx,%edi
  800df3:	89 d6                	mov    %edx,%esi
  800df5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e08:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800e0a:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e0d:	89 d9                	mov    %ebx,%ecx
  800e0f:	c1 e9 16             	shr    $0x16,%ecx
  800e12:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800e19:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e1e:	f6 c1 01             	test   $0x1,%cl
  800e21:	74 0c                	je     800e2f <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800e23:	89 d9                	mov    %ebx,%ecx
  800e25:	c1 e9 0c             	shr    $0xc,%ecx
  800e28:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800e2f:	f6 c2 02             	test   $0x2,%dl
  800e32:	0f 84 a3 00 00 00    	je     800edb <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800e38:	89 da                	mov    %ebx,%edx
  800e3a:	c1 ea 0c             	shr    $0xc,%edx
  800e3d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e44:	f6 c6 08             	test   $0x8,%dh
  800e47:	0f 84 b7 00 00 00    	je     800f04 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800e4d:	e8 5c fd ff ff       	call   800bae <sys_getenvid>
  800e52:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	6a 07                	push   $0x7
  800e59:	68 00 f0 7f 00       	push   $0x7ff000
  800e5e:	50                   	push   %eax
  800e5f:	e8 88 fd ff ff       	call   800bec <sys_page_alloc>
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	85 c0                	test   %eax,%eax
  800e69:	0f 88 bc 00 00 00    	js     800f2b <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800e6f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e75:	83 ec 04             	sub    $0x4,%esp
  800e78:	68 00 10 00 00       	push   $0x1000
  800e7d:	53                   	push   %ebx
  800e7e:	68 00 f0 7f 00       	push   $0x7ff000
  800e83:	e8 00 fb ff ff       	call   800988 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e88:	83 c4 08             	add    $0x8,%esp
  800e8b:	53                   	push   %ebx
  800e8c:	56                   	push   %esi
  800e8d:	e8 df fd ff ff       	call   800c71 <sys_page_unmap>
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	85 c0                	test   %eax,%eax
  800e97:	0f 88 a0 00 00 00    	js     800f3d <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	6a 07                	push   $0x7
  800ea2:	53                   	push   %ebx
  800ea3:	56                   	push   %esi
  800ea4:	68 00 f0 7f 00       	push   $0x7ff000
  800ea9:	56                   	push   %esi
  800eaa:	e8 80 fd ff ff       	call   800c2f <sys_page_map>
  800eaf:	83 c4 20             	add    $0x20,%esp
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	0f 88 95 00 00 00    	js     800f4f <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	68 00 f0 7f 00       	push   $0x7ff000
  800ec2:	56                   	push   %esi
  800ec3:	e8 a9 fd ff ff       	call   800c71 <sys_page_unmap>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	0f 88 8e 00 00 00    	js     800f61 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800edb:	8b 70 28             	mov    0x28(%eax),%esi
  800ede:	e8 cb fc ff ff       	call   800bae <sys_getenvid>
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	50                   	push   %eax
  800ee6:	68 0c 2b 80 00       	push   $0x802b0c
  800eeb:	e8 2e f3 ff ff       	call   80021e <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800ef0:	83 c4 0c             	add    $0xc,%esp
  800ef3:	68 30 2b 80 00       	push   $0x802b30
  800ef8:	6a 27                	push   $0x27
  800efa:	68 04 2c 80 00       	push   $0x802c04
  800eff:	e8 3f f2 ff ff       	call   800143 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800f04:	8b 78 28             	mov    0x28(%eax),%edi
  800f07:	e8 a2 fc ff ff       	call   800bae <sys_getenvid>
  800f0c:	57                   	push   %edi
  800f0d:	53                   	push   %ebx
  800f0e:	50                   	push   %eax
  800f0f:	68 0c 2b 80 00       	push   $0x802b0c
  800f14:	e8 05 f3 ff ff       	call   80021e <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800f19:	56                   	push   %esi
  800f1a:	68 64 2b 80 00       	push   $0x802b64
  800f1f:	6a 2b                	push   $0x2b
  800f21:	68 04 2c 80 00       	push   $0x802c04
  800f26:	e8 18 f2 ff ff       	call   800143 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800f2b:	50                   	push   %eax
  800f2c:	68 9c 2b 80 00       	push   $0x802b9c
  800f31:	6a 39                	push   $0x39
  800f33:	68 04 2c 80 00       	push   $0x802c04
  800f38:	e8 06 f2 ff ff       	call   800143 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f3d:	50                   	push   %eax
  800f3e:	68 c0 2b 80 00       	push   $0x802bc0
  800f43:	6a 3e                	push   $0x3e
  800f45:	68 04 2c 80 00       	push   $0x802c04
  800f4a:	e8 f4 f1 ff ff       	call   800143 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800f4f:	50                   	push   %eax
  800f50:	68 0f 2c 80 00       	push   $0x802c0f
  800f55:	6a 40                	push   $0x40
  800f57:	68 04 2c 80 00       	push   $0x802c04
  800f5c:	e8 e2 f1 ff ff       	call   800143 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f61:	50                   	push   %eax
  800f62:	68 c0 2b 80 00       	push   $0x802bc0
  800f67:	6a 42                	push   $0x42
  800f69:	68 04 2c 80 00       	push   $0x802c04
  800f6e:	e8 d0 f1 ff ff       	call   800143 <_panic>

00800f73 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f7c:	68 fc 0d 80 00       	push   $0x800dfc
  800f81:	e8 7e 13 00 00       	call   802304 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f86:	b8 07 00 00 00       	mov    $0x7,%eax
  800f8b:	cd 30                	int    $0x30
  800f8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	85 c0                	test   %eax,%eax
  800f95:	78 2d                	js     800fc4 <fork+0x51>
  800f97:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f99:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800f9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa2:	0f 85 a6 00 00 00    	jne    80104e <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800fa8:	e8 01 fc ff ff       	call   800bae <sys_getenvid>
  800fad:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fb2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fb5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fba:	a3 0c 40 80 00       	mov    %eax,0x80400c
      return 0;
  800fbf:	e9 79 01 00 00       	jmp    80113d <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800fc4:	50                   	push   %eax
  800fc5:	68 2d 2c 80 00       	push   $0x802c2d
  800fca:	68 aa 00 00 00       	push   $0xaa
  800fcf:	68 04 2c 80 00       	push   $0x802c04
  800fd4:	e8 6a f1 ff ff       	call   800143 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800fd9:	83 ec 0c             	sub    $0xc,%esp
  800fdc:	6a 05                	push   $0x5
  800fde:	53                   	push   %ebx
  800fdf:	57                   	push   %edi
  800fe0:	53                   	push   %ebx
  800fe1:	6a 00                	push   $0x0
  800fe3:	e8 47 fc ff ff       	call   800c2f <sys_page_map>
  800fe8:	83 c4 20             	add    $0x20,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	79 4d                	jns    80103c <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  800fef:	50                   	push   %eax
  800ff0:	68 36 2c 80 00       	push   $0x802c36
  800ff5:	6a 61                	push   $0x61
  800ff7:	68 04 2c 80 00       	push   $0x802c04
  800ffc:	e8 42 f1 ff ff       	call   800143 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	68 05 08 00 00       	push   $0x805
  801009:	53                   	push   %ebx
  80100a:	57                   	push   %edi
  80100b:	53                   	push   %ebx
  80100c:	6a 00                	push   $0x0
  80100e:	e8 1c fc ff ff       	call   800c2f <sys_page_map>
  801013:	83 c4 20             	add    $0x20,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	0f 88 b7 00 00 00    	js     8010d5 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	68 05 08 00 00       	push   $0x805
  801026:	53                   	push   %ebx
  801027:	6a 00                	push   $0x0
  801029:	53                   	push   %ebx
  80102a:	6a 00                	push   $0x0
  80102c:	e8 fe fb ff ff       	call   800c2f <sys_page_map>
  801031:	83 c4 20             	add    $0x20,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	0f 88 ab 00 00 00    	js     8010e7 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80103c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801042:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801048:	0f 84 ab 00 00 00    	je     8010f9 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  80104e:	89 d8                	mov    %ebx,%eax
  801050:	c1 e8 16             	shr    $0x16,%eax
  801053:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80105a:	a8 01                	test   $0x1,%al
  80105c:	74 de                	je     80103c <fork+0xc9>
  80105e:	89 d8                	mov    %ebx,%eax
  801060:	c1 e8 0c             	shr    $0xc,%eax
  801063:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80106a:	f6 c2 01             	test   $0x1,%dl
  80106d:	74 cd                	je     80103c <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  80106f:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 16             	shr    $0x16,%edx
  801077:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 b9                	je     80103c <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801083:	c1 e8 0c             	shr    $0xc,%eax
  801086:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  80108d:	a8 01                	test   $0x1,%al
  80108f:	74 ab                	je     80103c <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801091:	a9 02 08 00 00       	test   $0x802,%eax
  801096:	0f 84 3d ff ff ff    	je     800fd9 <fork+0x66>
	else if(pte & PTE_SHARE)
  80109c:	f6 c4 04             	test   $0x4,%ah
  80109f:	0f 84 5c ff ff ff    	je     801001 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8010a5:	83 ec 0c             	sub    $0xc,%esp
  8010a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ad:	50                   	push   %eax
  8010ae:	53                   	push   %ebx
  8010af:	57                   	push   %edi
  8010b0:	53                   	push   %ebx
  8010b1:	6a 00                	push   $0x0
  8010b3:	e8 77 fb ff ff       	call   800c2f <sys_page_map>
  8010b8:	83 c4 20             	add    $0x20,%esp
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	0f 89 79 ff ff ff    	jns    80103c <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010c3:	50                   	push   %eax
  8010c4:	68 36 2c 80 00       	push   $0x802c36
  8010c9:	6a 67                	push   $0x67
  8010cb:	68 04 2c 80 00       	push   $0x802c04
  8010d0:	e8 6e f0 ff ff       	call   800143 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010d5:	50                   	push   %eax
  8010d6:	68 36 2c 80 00       	push   $0x802c36
  8010db:	6a 6d                	push   $0x6d
  8010dd:	68 04 2c 80 00       	push   $0x802c04
  8010e2:	e8 5c f0 ff ff       	call   800143 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010e7:	50                   	push   %eax
  8010e8:	68 36 2c 80 00       	push   $0x802c36
  8010ed:	6a 70                	push   $0x70
  8010ef:	68 04 2c 80 00       	push   $0x802c04
  8010f4:	e8 4a f0 ff ff       	call   800143 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	6a 07                	push   $0x7
  8010fe:	68 00 f0 bf ee       	push   $0xeebff000
  801103:	ff 75 e4             	pushl  -0x1c(%ebp)
  801106:	e8 e1 fa ff ff       	call   800bec <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	78 36                	js     801148 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	68 7a 23 80 00       	push   $0x80237a
  80111a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80111d:	e8 15 fc ff ff       	call   800d37 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	78 34                	js     80115d <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	6a 02                	push   $0x2
  80112e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801131:	e8 7d fb ff ff       	call   800cb3 <sys_env_set_status>
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	78 35                	js     801172 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  80113d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5f                   	pop    %edi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801148:	50                   	push   %eax
  801149:	68 2d 2c 80 00       	push   $0x802c2d
  80114e:	68 ba 00 00 00       	push   $0xba
  801153:	68 04 2c 80 00       	push   $0x802c04
  801158:	e8 e6 ef ff ff       	call   800143 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80115d:	50                   	push   %eax
  80115e:	68 e0 2b 80 00       	push   $0x802be0
  801163:	68 bf 00 00 00       	push   $0xbf
  801168:	68 04 2c 80 00       	push   $0x802c04
  80116d:	e8 d1 ef ff ff       	call   800143 <_panic>
      panic("sys_env_set_status: %e", r);
  801172:	50                   	push   %eax
  801173:	68 4a 2c 80 00       	push   $0x802c4a
  801178:	68 c3 00 00 00       	push   $0xc3
  80117d:	68 04 2c 80 00       	push   $0x802c04
  801182:	e8 bc ef ff ff       	call   800143 <_panic>

00801187 <sfork>:

// Challenge!
int
sfork(void)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80118d:	68 61 2c 80 00       	push   $0x802c61
  801192:	68 cc 00 00 00       	push   $0xcc
  801197:	68 04 2c 80 00       	push   $0x802c04
  80119c:	e8 a2 ef ff ff       	call   800143 <_panic>

008011a1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	05 00 00 00 30       	add    $0x30000000,%eax
  8011ac:	c1 e8 0c             	shr    $0xc,%eax
}
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	c1 ea 16             	shr    $0x16,%edx
  8011d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011dc:	f6 c2 01             	test   $0x1,%dl
  8011df:	74 2d                	je     80120e <fd_alloc+0x46>
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	c1 ea 0c             	shr    $0xc,%edx
  8011e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ed:	f6 c2 01             	test   $0x1,%dl
  8011f0:	74 1c                	je     80120e <fd_alloc+0x46>
  8011f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011fc:	75 d2                	jne    8011d0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801207:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80120c:	eb 0a                	jmp    801218 <fd_alloc+0x50>
			*fd_store = fd;
  80120e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801211:	89 01                	mov    %eax,(%ecx)
			return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801220:	83 f8 1f             	cmp    $0x1f,%eax
  801223:	77 30                	ja     801255 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801225:	c1 e0 0c             	shl    $0xc,%eax
  801228:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80122d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801233:	f6 c2 01             	test   $0x1,%dl
  801236:	74 24                	je     80125c <fd_lookup+0x42>
  801238:	89 c2                	mov    %eax,%edx
  80123a:	c1 ea 0c             	shr    $0xc,%edx
  80123d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801244:	f6 c2 01             	test   $0x1,%dl
  801247:	74 1a                	je     801263 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 02                	mov    %eax,(%edx)
	return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    
		return -E_INVAL;
  801255:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125a:	eb f7                	jmp    801253 <fd_lookup+0x39>
		return -E_INVAL;
  80125c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801261:	eb f0                	jmp    801253 <fd_lookup+0x39>
  801263:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801268:	eb e9                	jmp    801253 <fd_lookup+0x39>

0080126a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801273:	ba 00 00 00 00       	mov    $0x0,%edx
  801278:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80127d:	39 08                	cmp    %ecx,(%eax)
  80127f:	74 38                	je     8012b9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801281:	83 c2 01             	add    $0x1,%edx
  801284:	8b 04 95 f4 2c 80 00 	mov    0x802cf4(,%edx,4),%eax
  80128b:	85 c0                	test   %eax,%eax
  80128d:	75 ee                	jne    80127d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80128f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801294:	8b 40 48             	mov    0x48(%eax),%eax
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	51                   	push   %ecx
  80129b:	50                   	push   %eax
  80129c:	68 78 2c 80 00       	push   $0x802c78
  8012a1:	e8 78 ef ff ff       	call   80021e <cprintf>
	*dev = 0;
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    
			*dev = devtab[i];
  8012b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012be:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c3:	eb f2                	jmp    8012b7 <dev_lookup+0x4d>

008012c5 <fd_close>:
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	57                   	push   %edi
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
  8012cb:	83 ec 24             	sub    $0x24,%esp
  8012ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012de:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e1:	50                   	push   %eax
  8012e2:	e8 33 ff ff ff       	call   80121a <fd_lookup>
  8012e7:	89 c3                	mov    %eax,%ebx
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 05                	js     8012f5 <fd_close+0x30>
	    || fd != fd2)
  8012f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012f3:	74 16                	je     80130b <fd_close+0x46>
		return (must_exist ? r : 0);
  8012f5:	89 f8                	mov    %edi,%eax
  8012f7:	84 c0                	test   %al,%al
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801301:	89 d8                	mov    %ebx,%eax
  801303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5f                   	pop    %edi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	ff 36                	pushl  (%esi)
  801314:	e8 51 ff ff ff       	call   80126a <dev_lookup>
  801319:	89 c3                	mov    %eax,%ebx
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 1a                	js     80133c <fd_close+0x77>
		if (dev->dev_close)
  801322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801325:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801328:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80132d:	85 c0                	test   %eax,%eax
  80132f:	74 0b                	je     80133c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	56                   	push   %esi
  801335:	ff d0                	call   *%eax
  801337:	89 c3                	mov    %eax,%ebx
  801339:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	56                   	push   %esi
  801340:	6a 00                	push   $0x0
  801342:	e8 2a f9 ff ff       	call   800c71 <sys_page_unmap>
	return r;
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	eb b5                	jmp    801301 <fd_close+0x3c>

0080134c <close>:

int
close(int fdnum)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801355:	50                   	push   %eax
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	e8 bc fe ff ff       	call   80121a <fd_lookup>
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	79 02                	jns    801367 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    
		return fd_close(fd, 1);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	6a 01                	push   $0x1
  80136c:	ff 75 f4             	pushl  -0xc(%ebp)
  80136f:	e8 51 ff ff ff       	call   8012c5 <fd_close>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	eb ec                	jmp    801365 <close+0x19>

00801379 <close_all>:

void
close_all(void)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	53                   	push   %ebx
  80137d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801380:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801385:	83 ec 0c             	sub    $0xc,%esp
  801388:	53                   	push   %ebx
  801389:	e8 be ff ff ff       	call   80134c <close>
	for (i = 0; i < MAXFD; i++)
  80138e:	83 c3 01             	add    $0x1,%ebx
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	83 fb 20             	cmp    $0x20,%ebx
  801397:	75 ec                	jne    801385 <close_all+0xc>
}
  801399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	57                   	push   %edi
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 75 08             	pushl  0x8(%ebp)
  8013ae:	e8 67 fe ff ff       	call   80121a <fd_lookup>
  8013b3:	89 c3                	mov    %eax,%ebx
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	0f 88 81 00 00 00    	js     801441 <dup+0xa3>
		return r;
	close(newfdnum);
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	e8 81 ff ff ff       	call   80134c <close>

	newfd = INDEX2FD(newfdnum);
  8013cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ce:	c1 e6 0c             	shl    $0xc,%esi
  8013d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013d7:	83 c4 04             	add    $0x4,%esp
  8013da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013dd:	e8 cf fd ff ff       	call   8011b1 <fd2data>
  8013e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013e4:	89 34 24             	mov    %esi,(%esp)
  8013e7:	e8 c5 fd ff ff       	call   8011b1 <fd2data>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013f1:	89 d8                	mov    %ebx,%eax
  8013f3:	c1 e8 16             	shr    $0x16,%eax
  8013f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fd:	a8 01                	test   $0x1,%al
  8013ff:	74 11                	je     801412 <dup+0x74>
  801401:	89 d8                	mov    %ebx,%eax
  801403:	c1 e8 0c             	shr    $0xc,%eax
  801406:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80140d:	f6 c2 01             	test   $0x1,%dl
  801410:	75 39                	jne    80144b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801412:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801415:	89 d0                	mov    %edx,%eax
  801417:	c1 e8 0c             	shr    $0xc,%eax
  80141a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	25 07 0e 00 00       	and    $0xe07,%eax
  801429:	50                   	push   %eax
  80142a:	56                   	push   %esi
  80142b:	6a 00                	push   $0x0
  80142d:	52                   	push   %edx
  80142e:	6a 00                	push   $0x0
  801430:	e8 fa f7 ff ff       	call   800c2f <sys_page_map>
  801435:	89 c3                	mov    %eax,%ebx
  801437:	83 c4 20             	add    $0x20,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 31                	js     80146f <dup+0xd1>
		goto err;

	return newfdnum;
  80143e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801441:	89 d8                	mov    %ebx,%eax
  801443:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801446:	5b                   	pop    %ebx
  801447:	5e                   	pop    %esi
  801448:	5f                   	pop    %edi
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80144b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801452:	83 ec 0c             	sub    $0xc,%esp
  801455:	25 07 0e 00 00       	and    $0xe07,%eax
  80145a:	50                   	push   %eax
  80145b:	57                   	push   %edi
  80145c:	6a 00                	push   $0x0
  80145e:	53                   	push   %ebx
  80145f:	6a 00                	push   $0x0
  801461:	e8 c9 f7 ff ff       	call   800c2f <sys_page_map>
  801466:	89 c3                	mov    %eax,%ebx
  801468:	83 c4 20             	add    $0x20,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	79 a3                	jns    801412 <dup+0x74>
	sys_page_unmap(0, newfd);
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	56                   	push   %esi
  801473:	6a 00                	push   $0x0
  801475:	e8 f7 f7 ff ff       	call   800c71 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80147a:	83 c4 08             	add    $0x8,%esp
  80147d:	57                   	push   %edi
  80147e:	6a 00                	push   $0x0
  801480:	e8 ec f7 ff ff       	call   800c71 <sys_page_unmap>
	return r;
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	eb b7                	jmp    801441 <dup+0xa3>

0080148a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	53                   	push   %ebx
  80148e:	83 ec 1c             	sub    $0x1c,%esp
  801491:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801494:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801497:	50                   	push   %eax
  801498:	53                   	push   %ebx
  801499:	e8 7c fd ff ff       	call   80121a <fd_lookup>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 3f                	js     8014e4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014af:	ff 30                	pushl  (%eax)
  8014b1:	e8 b4 fd ff ff       	call   80126a <dev_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 27                	js     8014e4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c0:	8b 42 08             	mov    0x8(%edx),%eax
  8014c3:	83 e0 03             	and    $0x3,%eax
  8014c6:	83 f8 01             	cmp    $0x1,%eax
  8014c9:	74 1e                	je     8014e9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ce:	8b 40 08             	mov    0x8(%eax),%eax
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 35                	je     80150a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	ff 75 10             	pushl  0x10(%ebp)
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	52                   	push   %edx
  8014df:	ff d0                	call   *%eax
  8014e1:	83 c4 10             	add    $0x10,%esp
}
  8014e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014e9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014ee:	8b 40 48             	mov    0x48(%eax),%eax
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	50                   	push   %eax
  8014f6:	68 b9 2c 80 00       	push   $0x802cb9
  8014fb:	e8 1e ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801508:	eb da                	jmp    8014e4 <read+0x5a>
		return -E_NOT_SUPP;
  80150a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150f:	eb d3                	jmp    8014e4 <read+0x5a>

00801511 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	57                   	push   %edi
  801515:	56                   	push   %esi
  801516:	53                   	push   %ebx
  801517:	83 ec 0c             	sub    $0xc,%esp
  80151a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80151d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801520:	bb 00 00 00 00       	mov    $0x0,%ebx
  801525:	39 f3                	cmp    %esi,%ebx
  801527:	73 23                	jae    80154c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801529:	83 ec 04             	sub    $0x4,%esp
  80152c:	89 f0                	mov    %esi,%eax
  80152e:	29 d8                	sub    %ebx,%eax
  801530:	50                   	push   %eax
  801531:	89 d8                	mov    %ebx,%eax
  801533:	03 45 0c             	add    0xc(%ebp),%eax
  801536:	50                   	push   %eax
  801537:	57                   	push   %edi
  801538:	e8 4d ff ff ff       	call   80148a <read>
		if (m < 0)
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	78 06                	js     80154a <readn+0x39>
			return m;
		if (m == 0)
  801544:	74 06                	je     80154c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801546:	01 c3                	add    %eax,%ebx
  801548:	eb db                	jmp    801525 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80154a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80154c:	89 d8                	mov    %ebx,%eax
  80154e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	53                   	push   %ebx
  80155a:	83 ec 1c             	sub    $0x1c,%esp
  80155d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801560:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	53                   	push   %ebx
  801565:	e8 b0 fc ff ff       	call   80121a <fd_lookup>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 3a                	js     8015ab <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	ff 30                	pushl  (%eax)
  80157d:	e8 e8 fc ff ff       	call   80126a <dev_lookup>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	78 22                	js     8015ab <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801590:	74 1e                	je     8015b0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801595:	8b 52 0c             	mov    0xc(%edx),%edx
  801598:	85 d2                	test   %edx,%edx
  80159a:	74 35                	je     8015d1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	ff 75 10             	pushl  0x10(%ebp)
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	ff d2                	call   *%edx
  8015a8:	83 c4 10             	add    $0x10,%esp
}
  8015ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015b5:	8b 40 48             	mov    0x48(%eax),%eax
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	53                   	push   %ebx
  8015bc:	50                   	push   %eax
  8015bd:	68 d5 2c 80 00       	push   $0x802cd5
  8015c2:	e8 57 ec ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cf:	eb da                	jmp    8015ab <write+0x55>
		return -E_NOT_SUPP;
  8015d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d6:	eb d3                	jmp    8015ab <write+0x55>

008015d8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	e8 30 fc ff ff       	call   80121a <fd_lookup>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 0e                	js     8015ff <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	53                   	push   %ebx
  801605:	83 ec 1c             	sub    $0x1c,%esp
  801608:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	53                   	push   %ebx
  801610:	e8 05 fc ff ff       	call   80121a <fd_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 37                	js     801653 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	50                   	push   %eax
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	ff 30                	pushl  (%eax)
  801628:	e8 3d fc ff ff       	call   80126a <dev_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 1f                	js     801653 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163b:	74 1b                	je     801658 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80163d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801640:	8b 52 18             	mov    0x18(%edx),%edx
  801643:	85 d2                	test   %edx,%edx
  801645:	74 32                	je     801679 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	50                   	push   %eax
  80164e:	ff d2                	call   *%edx
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801656:	c9                   	leave  
  801657:	c3                   	ret    
			thisenv->env_id, fdnum);
  801658:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80165d:	8b 40 48             	mov    0x48(%eax),%eax
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	53                   	push   %ebx
  801664:	50                   	push   %eax
  801665:	68 98 2c 80 00       	push   $0x802c98
  80166a:	e8 af eb ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801677:	eb da                	jmp    801653 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167e:	eb d3                	jmp    801653 <ftruncate+0x52>

00801680 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 84 fb ff ff       	call   80121a <fd_lookup>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	78 4b                	js     8016e8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a3:	50                   	push   %eax
  8016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a7:	ff 30                	pushl  (%eax)
  8016a9:	e8 bc fb ff ff       	call   80126a <dev_lookup>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 33                	js     8016e8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016bc:	74 2f                	je     8016ed <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016be:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016c1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016c8:	00 00 00 
	stat->st_isdir = 0;
  8016cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d2:	00 00 00 
	stat->st_dev = dev;
  8016d5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	53                   	push   %ebx
  8016df:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e2:	ff 50 14             	call   *0x14(%eax)
  8016e5:	83 c4 10             	add    $0x10,%esp
}
  8016e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8016ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f2:	eb f4                	jmp    8016e8 <fstat+0x68>

008016f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	56                   	push   %esi
  8016f8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	6a 00                	push   $0x0
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 2f 02 00 00       	call   801935 <open>
  801706:	89 c3                	mov    %eax,%ebx
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 1b                	js     80172a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	50                   	push   %eax
  801716:	e8 65 ff ff ff       	call   801680 <fstat>
  80171b:	89 c6                	mov    %eax,%esi
	close(fd);
  80171d:	89 1c 24             	mov    %ebx,(%esp)
  801720:	e8 27 fc ff ff       	call   80134c <close>
	return r;
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 f3                	mov    %esi,%ebx
}
  80172a:	89 d8                	mov    %ebx,%eax
  80172c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	89 c6                	mov    %eax,%esi
  80173a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80173c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801743:	74 27                	je     80176c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801745:	6a 07                	push   $0x7
  801747:	68 00 50 80 00       	push   $0x805000
  80174c:	56                   	push   %esi
  80174d:	ff 35 00 40 80 00    	pushl  0x804000
  801753:	e8 bc 0c 00 00       	call   802414 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801758:	83 c4 0c             	add    $0xc,%esp
  80175b:	6a 00                	push   $0x0
  80175d:	53                   	push   %ebx
  80175e:	6a 00                	push   $0x0
  801760:	e8 3c 0c 00 00       	call   8023a1 <ipc_recv>
}
  801765:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	6a 01                	push   $0x1
  801771:	e8 0a 0d 00 00       	call   802480 <ipc_find_env>
  801776:	a3 00 40 80 00       	mov    %eax,0x804000
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	eb c5                	jmp    801745 <fsipc+0x12>

00801780 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	8b 40 0c             	mov    0xc(%eax),%eax
  80178c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801799:	ba 00 00 00 00       	mov    $0x0,%edx
  80179e:	b8 02 00 00 00       	mov    $0x2,%eax
  8017a3:	e8 8b ff ff ff       	call   801733 <fsipc>
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <devfile_flush>:
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017c5:	e8 69 ff ff ff       	call   801733 <fsipc>
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <devfile_stat>:
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017dc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	b8 05 00 00 00       	mov    $0x5,%eax
  8017eb:	e8 43 ff ff ff       	call   801733 <fsipc>
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 2c                	js     801820 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	68 00 50 80 00       	push   $0x805000
  8017fc:	53                   	push   %ebx
  8017fd:	e8 f8 ef ff ff       	call   8007fa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801802:	a1 80 50 80 00       	mov    0x805080,%eax
  801807:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180d:	a1 84 50 80 00       	mov    0x805084,%eax
  801812:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <devfile_write>:
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	53                   	push   %ebx
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80182f:	85 db                	test   %ebx,%ebx
  801831:	75 07                	jne    80183a <devfile_write+0x15>
	return n_all;
  801833:	89 d8                	mov    %ebx,%eax
}
  801835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801838:	c9                   	leave  
  801839:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 40 0c             	mov    0xc(%eax),%eax
  801840:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801845:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	53                   	push   %ebx
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	68 08 50 80 00       	push   $0x805008
  801857:	e8 2c f1 ff ff       	call   800988 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80185c:	ba 00 00 00 00       	mov    $0x0,%edx
  801861:	b8 04 00 00 00       	mov    $0x4,%eax
  801866:	e8 c8 fe ff ff       	call   801733 <fsipc>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 c3                	js     801835 <devfile_write+0x10>
	  assert(r <= n_left);
  801872:	39 d8                	cmp    %ebx,%eax
  801874:	77 0b                	ja     801881 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801876:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187b:	7f 1d                	jg     80189a <devfile_write+0x75>
    n_all += r;
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	eb b2                	jmp    801833 <devfile_write+0xe>
	  assert(r <= n_left);
  801881:	68 08 2d 80 00       	push   $0x802d08
  801886:	68 14 2d 80 00       	push   $0x802d14
  80188b:	68 9f 00 00 00       	push   $0x9f
  801890:	68 29 2d 80 00       	push   $0x802d29
  801895:	e8 a9 e8 ff ff       	call   800143 <_panic>
	  assert(r <= PGSIZE);
  80189a:	68 34 2d 80 00       	push   $0x802d34
  80189f:	68 14 2d 80 00       	push   $0x802d14
  8018a4:	68 a0 00 00 00       	push   $0xa0
  8018a9:	68 29 2d 80 00       	push   $0x802d29
  8018ae:	e8 90 e8 ff ff       	call   800143 <_panic>

008018b3 <devfile_read>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d6:	e8 58 fe ff ff       	call   801733 <fsipc>
  8018db:	89 c3                	mov    %eax,%ebx
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 1f                	js     801900 <devfile_read+0x4d>
	assert(r <= n);
  8018e1:	39 f0                	cmp    %esi,%eax
  8018e3:	77 24                	ja     801909 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ea:	7f 33                	jg     80191f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	50                   	push   %eax
  8018f0:	68 00 50 80 00       	push   $0x805000
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	e8 8b f0 ff ff       	call   800988 <memmove>
	return r;
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	89 d8                	mov    %ebx,%eax
  801902:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5d                   	pop    %ebp
  801908:	c3                   	ret    
	assert(r <= n);
  801909:	68 40 2d 80 00       	push   $0x802d40
  80190e:	68 14 2d 80 00       	push   $0x802d14
  801913:	6a 7c                	push   $0x7c
  801915:	68 29 2d 80 00       	push   $0x802d29
  80191a:	e8 24 e8 ff ff       	call   800143 <_panic>
	assert(r <= PGSIZE);
  80191f:	68 34 2d 80 00       	push   $0x802d34
  801924:	68 14 2d 80 00       	push   $0x802d14
  801929:	6a 7d                	push   $0x7d
  80192b:	68 29 2d 80 00       	push   $0x802d29
  801930:	e8 0e e8 ff ff       	call   800143 <_panic>

00801935 <open>:
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	83 ec 1c             	sub    $0x1c,%esp
  80193d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801940:	56                   	push   %esi
  801941:	e8 7b ee ff ff       	call   8007c1 <strlen>
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194e:	7f 6c                	jg     8019bc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	e8 6c f8 ff ff       	call   8011c8 <fd_alloc>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	78 3c                	js     8019a1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	56                   	push   %esi
  801969:	68 00 50 80 00       	push   $0x805000
  80196e:	e8 87 ee ff ff       	call   8007fa <strcpy>
	fsipcbuf.open.req_omode = mode;
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80197b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	e8 ab fd ff ff       	call   801733 <fsipc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 19                	js     8019aa <open+0x75>
	return fd2num(fd);
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	ff 75 f4             	pushl  -0xc(%ebp)
  801997:	e8 05 f8 ff ff       	call   8011a1 <fd2num>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
		fd_close(fd, 0);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b2:	e8 0e f9 ff ff       	call   8012c5 <fd_close>
		return r;
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	eb e5                	jmp    8019a1 <open+0x6c>
		return -E_BAD_PATH;
  8019bc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c1:	eb de                	jmp    8019a1 <open+0x6c>

008019c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d3:	e8 5b fd ff ff       	call   801733 <fsipc>
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 c4 f7 ff ff       	call   8011b1 <fd2data>
  8019ed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019ef:	83 c4 08             	add    $0x8,%esp
  8019f2:	68 47 2d 80 00       	push   $0x802d47
  8019f7:	53                   	push   %ebx
  8019f8:	e8 fd ed ff ff       	call   8007fa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019fd:	8b 46 04             	mov    0x4(%esi),%eax
  801a00:	2b 06                	sub    (%esi),%eax
  801a02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a08:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a0f:	00 00 00 
	stat->st_dev = &devpipe;
  801a12:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a19:	30 80 00 
	return 0;
}
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a32:	53                   	push   %ebx
  801a33:	6a 00                	push   $0x0
  801a35:	e8 37 f2 ff ff       	call   800c71 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a3a:	89 1c 24             	mov    %ebx,(%esp)
  801a3d:	e8 6f f7 ff ff       	call   8011b1 <fd2data>
  801a42:	83 c4 08             	add    $0x8,%esp
  801a45:	50                   	push   %eax
  801a46:	6a 00                	push   $0x0
  801a48:	e8 24 f2 ff ff       	call   800c71 <sys_page_unmap>
}
  801a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <_pipeisclosed>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 1c             	sub    $0x1c,%esp
  801a5b:	89 c7                	mov    %eax,%edi
  801a5d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a5f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801a64:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	57                   	push   %edi
  801a6b:	e8 49 0a 00 00       	call   8024b9 <pageref>
  801a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a73:	89 34 24             	mov    %esi,(%esp)
  801a76:	e8 3e 0a 00 00       	call   8024b9 <pageref>
		nn = thisenv->env_runs;
  801a7b:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801a81:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	39 cb                	cmp    %ecx,%ebx
  801a89:	74 1b                	je     801aa6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a8b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a8e:	75 cf                	jne    801a5f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a90:	8b 42 58             	mov    0x58(%edx),%eax
  801a93:	6a 01                	push   $0x1
  801a95:	50                   	push   %eax
  801a96:	53                   	push   %ebx
  801a97:	68 4e 2d 80 00       	push   $0x802d4e
  801a9c:	e8 7d e7 ff ff       	call   80021e <cprintf>
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	eb b9                	jmp    801a5f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aa6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aa9:	0f 94 c0             	sete   %al
  801aac:	0f b6 c0             	movzbl %al,%eax
}
  801aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5f                   	pop    %edi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <devpipe_write>:
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	57                   	push   %edi
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	83 ec 28             	sub    $0x28,%esp
  801ac0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ac3:	56                   	push   %esi
  801ac4:	e8 e8 f6 ff ff       	call   8011b1 <fd2data>
  801ac9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ad6:	74 4f                	je     801b27 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ad8:	8b 43 04             	mov    0x4(%ebx),%eax
  801adb:	8b 0b                	mov    (%ebx),%ecx
  801add:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae0:	39 d0                	cmp    %edx,%eax
  801ae2:	72 14                	jb     801af8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ae4:	89 da                	mov    %ebx,%edx
  801ae6:	89 f0                	mov    %esi,%eax
  801ae8:	e8 65 ff ff ff       	call   801a52 <_pipeisclosed>
  801aed:	85 c0                	test   %eax,%eax
  801aef:	75 3b                	jne    801b2c <devpipe_write+0x75>
			sys_yield();
  801af1:	e8 d7 f0 ff ff       	call   800bcd <sys_yield>
  801af6:	eb e0                	jmp    801ad8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801afb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801aff:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b02:	89 c2                	mov    %eax,%edx
  801b04:	c1 fa 1f             	sar    $0x1f,%edx
  801b07:	89 d1                	mov    %edx,%ecx
  801b09:	c1 e9 1b             	shr    $0x1b,%ecx
  801b0c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b0f:	83 e2 1f             	and    $0x1f,%edx
  801b12:	29 ca                	sub    %ecx,%edx
  801b14:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b18:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b1c:	83 c0 01             	add    $0x1,%eax
  801b1f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b22:	83 c7 01             	add    $0x1,%edi
  801b25:	eb ac                	jmp    801ad3 <devpipe_write+0x1c>
	return i;
  801b27:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2a:	eb 05                	jmp    801b31 <devpipe_write+0x7a>
				return 0;
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5f                   	pop    %edi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <devpipe_read>:
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	57                   	push   %edi
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 18             	sub    $0x18,%esp
  801b42:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b45:	57                   	push   %edi
  801b46:	e8 66 f6 ff ff       	call   8011b1 <fd2data>
  801b4b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	be 00 00 00 00       	mov    $0x0,%esi
  801b55:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b58:	75 14                	jne    801b6e <devpipe_read+0x35>
	return i;
  801b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5d:	eb 02                	jmp    801b61 <devpipe_read+0x28>
				return i;
  801b5f:	89 f0                	mov    %esi,%eax
}
  801b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
			sys_yield();
  801b69:	e8 5f f0 ff ff       	call   800bcd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b6e:	8b 03                	mov    (%ebx),%eax
  801b70:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b73:	75 18                	jne    801b8d <devpipe_read+0x54>
			if (i > 0)
  801b75:	85 f6                	test   %esi,%esi
  801b77:	75 e6                	jne    801b5f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b79:	89 da                	mov    %ebx,%edx
  801b7b:	89 f8                	mov    %edi,%eax
  801b7d:	e8 d0 fe ff ff       	call   801a52 <_pipeisclosed>
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 e3                	je     801b69 <devpipe_read+0x30>
				return 0;
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8b:	eb d4                	jmp    801b61 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b8d:	99                   	cltd   
  801b8e:	c1 ea 1b             	shr    $0x1b,%edx
  801b91:	01 d0                	add    %edx,%eax
  801b93:	83 e0 1f             	and    $0x1f,%eax
  801b96:	29 d0                	sub    %edx,%eax
  801b98:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ba3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ba6:	83 c6 01             	add    $0x1,%esi
  801ba9:	eb aa                	jmp    801b55 <devpipe_read+0x1c>

00801bab <pipe>:
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb6:	50                   	push   %eax
  801bb7:	e8 0c f6 ff ff       	call   8011c8 <fd_alloc>
  801bbc:	89 c3                	mov    %eax,%ebx
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	0f 88 23 01 00 00    	js     801cec <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 07 04 00 00       	push   $0x407
  801bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd4:	6a 00                	push   $0x0
  801bd6:	e8 11 f0 ff ff       	call   800bec <sys_page_alloc>
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	0f 88 04 01 00 00    	js     801cec <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	e8 d4 f5 ff ff       	call   8011c8 <fd_alloc>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	0f 88 db 00 00 00    	js     801cdc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	68 07 04 00 00       	push   $0x407
  801c09:	ff 75 f0             	pushl  -0x10(%ebp)
  801c0c:	6a 00                	push   $0x0
  801c0e:	e8 d9 ef ff ff       	call   800bec <sys_page_alloc>
  801c13:	89 c3                	mov    %eax,%ebx
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	0f 88 bc 00 00 00    	js     801cdc <pipe+0x131>
	va = fd2data(fd0);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 f4             	pushl  -0xc(%ebp)
  801c26:	e8 86 f5 ff ff       	call   8011b1 <fd2data>
  801c2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c2d:	83 c4 0c             	add    $0xc,%esp
  801c30:	68 07 04 00 00       	push   $0x407
  801c35:	50                   	push   %eax
  801c36:	6a 00                	push   $0x0
  801c38:	e8 af ef ff ff       	call   800bec <sys_page_alloc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	0f 88 82 00 00 00    	js     801ccc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c50:	e8 5c f5 ff ff       	call   8011b1 <fd2data>
  801c55:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c5c:	50                   	push   %eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	56                   	push   %esi
  801c60:	6a 00                	push   $0x0
  801c62:	e8 c8 ef ff ff       	call   800c2f <sys_page_map>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	83 c4 20             	add    $0x20,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 4e                	js     801cbe <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c70:	a1 20 30 80 00       	mov    0x803020,%eax
  801c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c78:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c87:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	ff 75 f4             	pushl  -0xc(%ebp)
  801c99:	e8 03 f5 ff ff       	call   8011a1 <fd2num>
  801c9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ca3:	83 c4 04             	add    $0x4,%esp
  801ca6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca9:	e8 f3 f4 ff ff       	call   8011a1 <fd2num>
  801cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cbc:	eb 2e                	jmp    801cec <pipe+0x141>
	sys_page_unmap(0, va);
  801cbe:	83 ec 08             	sub    $0x8,%esp
  801cc1:	56                   	push   %esi
  801cc2:	6a 00                	push   $0x0
  801cc4:	e8 a8 ef ff ff       	call   800c71 <sys_page_unmap>
  801cc9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ccc:	83 ec 08             	sub    $0x8,%esp
  801ccf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 98 ef ff ff       	call   800c71 <sys_page_unmap>
  801cd9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce2:	6a 00                	push   $0x0
  801ce4:	e8 88 ef ff ff       	call   800c71 <sys_page_unmap>
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf1:	5b                   	pop    %ebx
  801cf2:	5e                   	pop    %esi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <pipeisclosed>:
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfe:	50                   	push   %eax
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	e8 13 f5 ff ff       	call   80121a <fd_lookup>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 18                	js     801d26 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff 75 f4             	pushl  -0xc(%ebp)
  801d14:	e8 98 f4 ff ff       	call   8011b1 <fd2data>
	return _pipeisclosed(fd, p);
  801d19:	89 c2                	mov    %eax,%edx
  801d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1e:	e8 2f fd ff ff       	call   801a52 <_pipeisclosed>
  801d23:	83 c4 10             	add    $0x10,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d2e:	68 66 2d 80 00       	push   $0x802d66
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 bf ea ff ff       	call   8007fa <strcpy>
	return 0;
}
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <devsock_close>:
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 10             	sub    $0x10,%esp
  801d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4c:	53                   	push   %ebx
  801d4d:	e8 67 07 00 00       	call   8024b9 <pageref>
  801d52:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d55:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d5a:	83 f8 01             	cmp    $0x1,%eax
  801d5d:	74 07                	je     801d66 <devsock_close+0x24>
}
  801d5f:	89 d0                	mov    %edx,%eax
  801d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	ff 73 0c             	pushl  0xc(%ebx)
  801d6c:	e8 b9 02 00 00       	call   80202a <nsipc_close>
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	eb e7                	jmp    801d5f <devsock_close+0x1d>

00801d78 <devsock_write>:
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 10             	pushl  0x10(%ebp)
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	ff 70 0c             	pushl  0xc(%eax)
  801d8c:	e8 76 03 00 00       	call   802107 <nsipc_send>
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <devsock_read>:
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	ff 75 10             	pushl  0x10(%ebp)
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	ff 70 0c             	pushl  0xc(%eax)
  801da7:	e8 ef 02 00 00       	call   80209b <nsipc_recv>
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <fd2sockid>:
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	e8 5c f4 ff ff       	call   80121a <fd_lookup>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	78 10                	js     801dd5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801dce:	39 08                	cmp    %ecx,(%eax)
  801dd0:	75 05                	jne    801dd7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    
		return -E_NOT_SUPP;
  801dd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ddc:	eb f7                	jmp    801dd5 <fd2sockid+0x27>

00801dde <alloc_sockfd>:
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	56                   	push   %esi
  801de2:	53                   	push   %ebx
  801de3:	83 ec 1c             	sub    $0x1c,%esp
  801de6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801deb:	50                   	push   %eax
  801dec:	e8 d7 f3 ff ff       	call   8011c8 <fd_alloc>
  801df1:	89 c3                	mov    %eax,%ebx
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 43                	js     801e3d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 07 04 00 00       	push   $0x407
  801e02:	ff 75 f4             	pushl  -0xc(%ebp)
  801e05:	6a 00                	push   $0x0
  801e07:	e8 e0 ed ff ff       	call   800bec <sys_page_alloc>
  801e0c:	89 c3                	mov    %eax,%ebx
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	85 c0                	test   %eax,%eax
  801e13:	78 28                	js     801e3d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e1e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e2a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	50                   	push   %eax
  801e31:	e8 6b f3 ff ff       	call   8011a1 <fd2num>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	eb 0c                	jmp    801e49 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	56                   	push   %esi
  801e41:	e8 e4 01 00 00       	call   80202a <nsipc_close>
		return r;
  801e46:	83 c4 10             	add    $0x10,%esp
}
  801e49:	89 d8                	mov    %ebx,%eax
  801e4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    

00801e52 <accept>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	e8 4e ff ff ff       	call   801dae <fd2sockid>
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 1b                	js     801e7f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	ff 75 10             	pushl  0x10(%ebp)
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	50                   	push   %eax
  801e6e:	e8 0e 01 00 00       	call   801f81 <nsipc_accept>
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 05                	js     801e7f <accept+0x2d>
	return alloc_sockfd(r);
  801e7a:	e8 5f ff ff ff       	call   801dde <alloc_sockfd>
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <bind>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	e8 1f ff ff ff       	call   801dae <fd2sockid>
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	78 12                	js     801ea5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	ff 75 10             	pushl  0x10(%ebp)
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	50                   	push   %eax
  801e9d:	e8 31 01 00 00       	call   801fd3 <nsipc_bind>
  801ea2:	83 c4 10             	add    $0x10,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <shutdown>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	e8 f9 fe ff ff       	call   801dae <fd2sockid>
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 0f                	js     801ec8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	e8 43 01 00 00       	call   802008 <nsipc_shutdown>
  801ec5:	83 c4 10             	add    $0x10,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <connect>:
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	e8 d6 fe ff ff       	call   801dae <fd2sockid>
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	78 12                	js     801eee <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	ff 75 10             	pushl  0x10(%ebp)
  801ee2:	ff 75 0c             	pushl  0xc(%ebp)
  801ee5:	50                   	push   %eax
  801ee6:	e8 59 01 00 00       	call   802044 <nsipc_connect>
  801eeb:	83 c4 10             	add    $0x10,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <listen>:
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	e8 b0 fe ff ff       	call   801dae <fd2sockid>
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 0f                	js     801f11 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f02:	83 ec 08             	sub    $0x8,%esp
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	50                   	push   %eax
  801f09:	e8 6b 01 00 00       	call   802079 <nsipc_listen>
  801f0e:	83 c4 10             	add    $0x10,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f19:	ff 75 10             	pushl  0x10(%ebp)
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	e8 3e 02 00 00       	call   802165 <nsipc_socket>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 05                	js     801f33 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f2e:	e8 ab fe ff ff       	call   801dde <alloc_sockfd>
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	53                   	push   %ebx
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f3e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f45:	74 26                	je     801f6d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f47:	6a 07                	push   $0x7
  801f49:	68 00 60 80 00       	push   $0x806000
  801f4e:	53                   	push   %ebx
  801f4f:	ff 35 04 40 80 00    	pushl  0x804004
  801f55:	e8 ba 04 00 00       	call   802414 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f5a:	83 c4 0c             	add    $0xc,%esp
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	e8 39 04 00 00       	call   8023a1 <ipc_recv>
}
  801f68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	6a 02                	push   $0x2
  801f72:	e8 09 05 00 00       	call   802480 <ipc_find_env>
  801f77:	a3 04 40 80 00       	mov    %eax,0x804004
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	eb c6                	jmp    801f47 <nsipc+0x12>

00801f81 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	56                   	push   %esi
  801f85:	53                   	push   %ebx
  801f86:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f91:	8b 06                	mov    (%esi),%eax
  801f93:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f98:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9d:	e8 93 ff ff ff       	call   801f35 <nsipc>
  801fa2:	89 c3                	mov    %eax,%ebx
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	79 09                	jns    801fb1 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fa8:	89 d8                	mov    %ebx,%eax
  801faa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fad:	5b                   	pop    %ebx
  801fae:	5e                   	pop    %esi
  801faf:	5d                   	pop    %ebp
  801fb0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	ff 35 10 60 80 00    	pushl  0x806010
  801fba:	68 00 60 80 00       	push   $0x806000
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	e8 c1 e9 ff ff       	call   800988 <memmove>
		*addrlen = ret->ret_addrlen;
  801fc7:	a1 10 60 80 00       	mov    0x806010,%eax
  801fcc:	89 06                	mov    %eax,(%esi)
  801fce:	83 c4 10             	add    $0x10,%esp
	return r;
  801fd1:	eb d5                	jmp    801fa8 <nsipc_accept+0x27>

00801fd3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 08             	sub    $0x8,%esp
  801fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe5:	53                   	push   %ebx
  801fe6:	ff 75 0c             	pushl  0xc(%ebp)
  801fe9:	68 04 60 80 00       	push   $0x806004
  801fee:	e8 95 e9 ff ff       	call   800988 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ff9:	b8 02 00 00 00       	mov    $0x2,%eax
  801ffe:	e8 32 ff ff ff       	call   801f35 <nsipc>
}
  802003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80201e:	b8 03 00 00 00       	mov    $0x3,%eax
  802023:	e8 0d ff ff ff       	call   801f35 <nsipc>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <nsipc_close>:

int
nsipc_close(int s)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802038:	b8 04 00 00 00       	mov    $0x4,%eax
  80203d:	e8 f3 fe ff ff       	call   801f35 <nsipc>
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	53                   	push   %ebx
  802048:	83 ec 08             	sub    $0x8,%esp
  80204b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802056:	53                   	push   %ebx
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	68 04 60 80 00       	push   $0x806004
  80205f:	e8 24 e9 ff ff       	call   800988 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802064:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80206a:	b8 05 00 00 00       	mov    $0x5,%eax
  80206f:	e8 c1 fe ff ff       	call   801f35 <nsipc>
}
  802074:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80208f:	b8 06 00 00 00       	mov    $0x6,%eax
  802094:	e8 9c fe ff ff       	call   801f35 <nsipc>
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020ab:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020b9:	b8 07 00 00 00       	mov    $0x7,%eax
  8020be:	e8 72 fe ff ff       	call   801f35 <nsipc>
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 1f                	js     8020e8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020c9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020ce:	7f 21                	jg     8020f1 <nsipc_recv+0x56>
  8020d0:	39 c6                	cmp    %eax,%esi
  8020d2:	7c 1d                	jl     8020f1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	50                   	push   %eax
  8020d8:	68 00 60 80 00       	push   $0x806000
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	e8 a3 e8 ff ff       	call   800988 <memmove>
  8020e5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020f1:	68 72 2d 80 00       	push   $0x802d72
  8020f6:	68 14 2d 80 00       	push   $0x802d14
  8020fb:	6a 62                	push   $0x62
  8020fd:	68 87 2d 80 00       	push   $0x802d87
  802102:	e8 3c e0 ff ff       	call   800143 <_panic>

00802107 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	53                   	push   %ebx
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802119:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80211f:	7f 2e                	jg     80214f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	53                   	push   %ebx
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	68 0c 60 80 00       	push   $0x80600c
  80212d:	e8 56 e8 ff ff       	call   800988 <memmove>
	nsipcbuf.send.req_size = size;
  802132:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802138:	8b 45 14             	mov    0x14(%ebp),%eax
  80213b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802140:	b8 08 00 00 00       	mov    $0x8,%eax
  802145:	e8 eb fd ff ff       	call   801f35 <nsipc>
}
  80214a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    
	assert(size < 1600);
  80214f:	68 93 2d 80 00       	push   $0x802d93
  802154:	68 14 2d 80 00       	push   $0x802d14
  802159:	6a 6d                	push   $0x6d
  80215b:	68 87 2d 80 00       	push   $0x802d87
  802160:	e8 de df ff ff       	call   800143 <_panic>

00802165 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80217b:	8b 45 10             	mov    0x10(%ebp),%eax
  80217e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802183:	b8 09 00 00 00       	mov    $0x9,%eax
  802188:	e8 a8 fd ff ff       	call   801f35 <nsipc>
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	c3                   	ret    

00802195 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80219b:	68 9f 2d 80 00       	push   $0x802d9f
  8021a0:	ff 75 0c             	pushl  0xc(%ebp)
  8021a3:	e8 52 e6 ff ff       	call   8007fa <strcpy>
	return 0;
}
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <devcons_write>:
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	57                   	push   %edi
  8021b3:	56                   	push   %esi
  8021b4:	53                   	push   %ebx
  8021b5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021bb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021c0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021c6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c9:	73 31                	jae    8021fc <devcons_write+0x4d>
		m = n - tot;
  8021cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ce:	29 f3                	sub    %esi,%ebx
  8021d0:	83 fb 7f             	cmp    $0x7f,%ebx
  8021d3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021d8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	53                   	push   %ebx
  8021df:	89 f0                	mov    %esi,%eax
  8021e1:	03 45 0c             	add    0xc(%ebp),%eax
  8021e4:	50                   	push   %eax
  8021e5:	57                   	push   %edi
  8021e6:	e8 9d e7 ff ff       	call   800988 <memmove>
		sys_cputs(buf, m);
  8021eb:	83 c4 08             	add    $0x8,%esp
  8021ee:	53                   	push   %ebx
  8021ef:	57                   	push   %edi
  8021f0:	e8 3b e9 ff ff       	call   800b30 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021f5:	01 de                	add    %ebx,%esi
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	eb ca                	jmp    8021c6 <devcons_write+0x17>
}
  8021fc:	89 f0                	mov    %esi,%eax
  8021fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    

00802206 <devcons_read>:
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802211:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802215:	74 21                	je     802238 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802217:	e8 32 e9 ff ff       	call   800b4e <sys_cgetc>
  80221c:	85 c0                	test   %eax,%eax
  80221e:	75 07                	jne    802227 <devcons_read+0x21>
		sys_yield();
  802220:	e8 a8 e9 ff ff       	call   800bcd <sys_yield>
  802225:	eb f0                	jmp    802217 <devcons_read+0x11>
	if (c < 0)
  802227:	78 0f                	js     802238 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802229:	83 f8 04             	cmp    $0x4,%eax
  80222c:	74 0c                	je     80223a <devcons_read+0x34>
	*(char*)vbuf = c;
  80222e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802231:	88 02                	mov    %al,(%edx)
	return 1;
  802233:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    
		return 0;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
  80223f:	eb f7                	jmp    802238 <devcons_read+0x32>

00802241 <cputchar>:
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80224d:	6a 01                	push   $0x1
  80224f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802252:	50                   	push   %eax
  802253:	e8 d8 e8 ff ff       	call   800b30 <sys_cputs>
}
  802258:	83 c4 10             	add    $0x10,%esp
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <getchar>:
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802263:	6a 01                	push   $0x1
  802265:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802268:	50                   	push   %eax
  802269:	6a 00                	push   $0x0
  80226b:	e8 1a f2 ff ff       	call   80148a <read>
	if (r < 0)
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	85 c0                	test   %eax,%eax
  802275:	78 06                	js     80227d <getchar+0x20>
	if (r < 1)
  802277:	74 06                	je     80227f <getchar+0x22>
	return c;
  802279:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    
		return -E_EOF;
  80227f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802284:	eb f7                	jmp    80227d <getchar+0x20>

00802286 <iscons>:
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80228c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80228f:	50                   	push   %eax
  802290:	ff 75 08             	pushl  0x8(%ebp)
  802293:	e8 82 ef ff ff       	call   80121a <fd_lookup>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	85 c0                	test   %eax,%eax
  80229d:	78 11                	js     8022b0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a8:	39 10                	cmp    %edx,(%eax)
  8022aa:	0f 94 c0             	sete   %al
  8022ad:	0f b6 c0             	movzbl %al,%eax
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <opencons>:
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022bb:	50                   	push   %eax
  8022bc:	e8 07 ef ff ff       	call   8011c8 <fd_alloc>
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	78 3a                	js     802302 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	68 07 04 00 00       	push   $0x407
  8022d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d3:	6a 00                	push   $0x0
  8022d5:	e8 12 e9 ff ff       	call   800bec <sys_page_alloc>
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 21                	js     802302 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f6:	83 ec 0c             	sub    $0xc,%esp
  8022f9:	50                   	push   %eax
  8022fa:	e8 a2 ee ff ff       	call   8011a1 <fd2num>
  8022ff:	83 c4 10             	add    $0x10,%esp
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80230a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802311:	74 0a                	je     80231d <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80231d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802322:	8b 40 48             	mov    0x48(%eax),%eax
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	6a 07                	push   $0x7
  80232a:	68 00 f0 bf ee       	push   $0xeebff000
  80232f:	50                   	push   %eax
  802330:	e8 b7 e8 ff ff       	call   800bec <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 2c                	js     802368 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80233c:	e8 6d e8 ff ff       	call   800bae <sys_getenvid>
  802341:	83 ec 08             	sub    $0x8,%esp
  802344:	68 7a 23 80 00       	push   $0x80237a
  802349:	50                   	push   %eax
  80234a:	e8 e8 e9 ff ff       	call   800d37 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	85 c0                	test   %eax,%eax
  802354:	79 bd                	jns    802313 <set_pgfault_handler+0xf>
  802356:	50                   	push   %eax
  802357:	68 ab 2d 80 00       	push   $0x802dab
  80235c:	6a 23                	push   $0x23
  80235e:	68 c3 2d 80 00       	push   $0x802dc3
  802363:	e8 db dd ff ff       	call   800143 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802368:	50                   	push   %eax
  802369:	68 ab 2d 80 00       	push   $0x802dab
  80236e:	6a 21                	push   $0x21
  802370:	68 c3 2d 80 00       	push   $0x802dc3
  802375:	e8 c9 dd ff ff       	call   800143 <_panic>

0080237a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80237a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80237b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802380:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802382:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802385:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802389:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  80238c:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802390:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802394:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802397:	83 c4 08             	add    $0x8,%esp
	popal
  80239a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80239b:	83 c4 04             	add    $0x4,%esp
	popfl
  80239e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80239f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8023a0:	c3                   	ret    

008023a1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 4f                	je     802402 <ipc_recv+0x61>
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	50                   	push   %eax
  8023b7:	e8 e0 e9 ff ff       	call   800d9c <sys_ipc_recv>
  8023bc:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8023bf:	85 f6                	test   %esi,%esi
  8023c1:	74 14                	je     8023d7 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8023c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 09                	jne    8023d5 <ipc_recv+0x34>
  8023cc:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8023d2:	8b 52 74             	mov    0x74(%edx),%edx
  8023d5:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8023d7:	85 db                	test   %ebx,%ebx
  8023d9:	74 14                	je     8023ef <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8023db:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 09                	jne    8023ed <ipc_recv+0x4c>
  8023e4:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8023ea:	8b 52 78             	mov    0x78(%edx),%edx
  8023ed:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	75 08                	jne    8023fb <ipc_recv+0x5a>
  8023f3:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8023f8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fe:	5b                   	pop    %ebx
  8023ff:	5e                   	pop    %esi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	68 00 00 c0 ee       	push   $0xeec00000
  80240a:	e8 8d e9 ff ff       	call   800d9c <sys_ipc_recv>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	eb ab                	jmp    8023bf <ipc_recv+0x1e>

00802414 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	57                   	push   %edi
  802418:	56                   	push   %esi
  802419:	53                   	push   %ebx
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802420:	8b 75 10             	mov    0x10(%ebp),%esi
  802423:	eb 20                	jmp    802445 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802425:	6a 00                	push   $0x0
  802427:	68 00 00 c0 ee       	push   $0xeec00000
  80242c:	ff 75 0c             	pushl  0xc(%ebp)
  80242f:	57                   	push   %edi
  802430:	e8 44 e9 ff ff       	call   800d79 <sys_ipc_try_send>
  802435:	89 c3                	mov    %eax,%ebx
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	eb 1f                	jmp    80245b <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80243c:	e8 8c e7 ff ff       	call   800bcd <sys_yield>
	while(retval != 0) {
  802441:	85 db                	test   %ebx,%ebx
  802443:	74 33                	je     802478 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802445:	85 f6                	test   %esi,%esi
  802447:	74 dc                	je     802425 <ipc_send+0x11>
  802449:	ff 75 14             	pushl  0x14(%ebp)
  80244c:	56                   	push   %esi
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	57                   	push   %edi
  802451:	e8 23 e9 ff ff       	call   800d79 <sys_ipc_try_send>
  802456:	89 c3                	mov    %eax,%ebx
  802458:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80245b:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80245e:	74 dc                	je     80243c <ipc_send+0x28>
  802460:	85 db                	test   %ebx,%ebx
  802462:	74 d8                	je     80243c <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	68 d4 2d 80 00       	push   $0x802dd4
  80246c:	6a 35                	push   $0x35
  80246e:	68 04 2e 80 00       	push   $0x802e04
  802473:	e8 cb dc ff ff       	call   800143 <_panic>
	}
}
  802478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    

00802480 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80248e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802494:	8b 52 50             	mov    0x50(%edx),%edx
  802497:	39 ca                	cmp    %ecx,%edx
  802499:	74 11                	je     8024ac <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80249b:	83 c0 01             	add    $0x1,%eax
  80249e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a3:	75 e6                	jne    80248b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024aa:	eb 0b                	jmp    8024b7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    

008024b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	c1 e8 16             	shr    $0x16,%eax
  8024c4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d0:	f6 c1 01             	test   $0x1,%cl
  8024d3:	74 1d                	je     8024f2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024d5:	c1 ea 0c             	shr    $0xc,%edx
  8024d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024df:	f6 c2 01             	test   $0x1,%dl
  8024e2:	74 0e                	je     8024f2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e4:	c1 ea 0c             	shr    $0xc,%edx
  8024e7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024ee:	ef 
  8024ef:	0f b7 c0             	movzwl %ax,%eax
}
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	f3 0f 1e fb          	endbr32 
  802504:	55                   	push   %ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802513:	8b 74 24 34          	mov    0x34(%esp),%esi
  802517:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80251b:	85 d2                	test   %edx,%edx
  80251d:	75 49                	jne    802568 <__udivdi3+0x68>
  80251f:	39 f3                	cmp    %esi,%ebx
  802521:	76 15                	jbe    802538 <__udivdi3+0x38>
  802523:	31 ff                	xor    %edi,%edi
  802525:	89 e8                	mov    %ebp,%eax
  802527:	89 f2                	mov    %esi,%edx
  802529:	f7 f3                	div    %ebx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	89 d9                	mov    %ebx,%ecx
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	75 0b                	jne    802549 <__udivdi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 c1                	mov    %eax,%ecx
  802549:	31 d2                	xor    %edx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	f7 f1                	div    %ecx
  80254f:	89 c6                	mov    %eax,%esi
  802551:	89 e8                	mov    %ebp,%eax
  802553:	89 f7                	mov    %esi,%edi
  802555:	f7 f1                	div    %ecx
  802557:	89 fa                	mov    %edi,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	77 1c                	ja     802588 <__udivdi3+0x88>
  80256c:	0f bd fa             	bsr    %edx,%edi
  80256f:	83 f7 1f             	xor    $0x1f,%edi
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	39 f2                	cmp    %esi,%edx
  802576:	72 06                	jb     80257e <__udivdi3+0x7e>
  802578:	31 c0                	xor    %eax,%eax
  80257a:	39 eb                	cmp    %ebp,%ebx
  80257c:	77 ad                	ja     80252b <__udivdi3+0x2b>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb a6                	jmp    80252b <__udivdi3+0x2b>
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	89 eb                	mov    %ebp,%ebx
  8025d1:	d3 e6                	shl    %cl,%esi
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 15                	jb     802600 <__udivdi3+0x100>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 04                	jae    8025f7 <__udivdi3+0xf7>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	74 09                	je     802600 <__udivdi3+0x100>
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	31 ff                	xor    %edi,%edi
  8025fb:	e9 2b ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 21 ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80261f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802623:	8b 74 24 30          	mov    0x30(%esp),%esi
  802627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80262b:	89 da                	mov    %ebx,%edx
  80262d:	85 c0                	test   %eax,%eax
  80262f:	75 3f                	jne    802670 <__umoddi3+0x60>
  802631:	39 df                	cmp    %ebx,%edi
  802633:	76 13                	jbe    802648 <__umoddi3+0x38>
  802635:	89 f0                	mov    %esi,%eax
  802637:	f7 f7                	div    %edi
  802639:	89 d0                	mov    %edx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	89 fd                	mov    %edi,%ebp
  80264a:	85 ff                	test   %edi,%edi
  80264c:	75 0b                	jne    802659 <__umoddi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f7                	div    %edi
  802657:	89 c5                	mov    %eax,%ebp
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f5                	div    %ebp
  80265f:	89 f0                	mov    %esi,%eax
  802661:	f7 f5                	div    %ebp
  802663:	89 d0                	mov    %edx,%eax
  802665:	eb d4                	jmp    80263b <__umoddi3+0x2b>
  802667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266e:	66 90                	xchg   %ax,%ax
  802670:	89 f1                	mov    %esi,%ecx
  802672:	39 d8                	cmp    %ebx,%eax
  802674:	76 0a                	jbe    802680 <__umoddi3+0x70>
  802676:	89 f0                	mov    %esi,%eax
  802678:	83 c4 1c             	add    $0x1c,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	75 20                	jne    8026a8 <__umoddi3+0x98>
  802688:	39 d8                	cmp    %ebx,%eax
  80268a:	0f 82 b0 00 00 00    	jb     802740 <__umoddi3+0x130>
  802690:	39 f7                	cmp    %esi,%edi
  802692:	0f 86 a8 00 00 00    	jbe    802740 <__umoddi3+0x130>
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026af:	29 ea                	sub    %ebp,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	d3 e8                	shr    %cl,%eax
  8026bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026c9:	09 c1                	or     %eax,%ecx
  8026cb:	89 d8                	mov    %ebx,%eax
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	d3 e6                	shl    %cl,%esi
  8026ef:	09 d8                	or     %ebx,%eax
  8026f1:	f7 74 24 08          	divl   0x8(%esp)
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	89 f3                	mov    %esi,%ebx
  8026f9:	f7 64 24 0c          	mull   0xc(%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d7                	mov    %edx,%edi
  802701:	39 d1                	cmp    %edx,%ecx
  802703:	72 06                	jb     80270b <__umoddi3+0xfb>
  802705:	75 10                	jne    802717 <__umoddi3+0x107>
  802707:	39 c3                	cmp    %eax,%ebx
  802709:	73 0c                	jae    802717 <__umoddi3+0x107>
  80270b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80270f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802713:	89 d7                	mov    %edx,%edi
  802715:	89 c6                	mov    %eax,%esi
  802717:	89 ca                	mov    %ecx,%edx
  802719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	19 fa                	sbb    %edi,%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	d3 e0                	shl    %cl,%eax
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	d3 eb                	shr    %cl,%ebx
  80272a:	d3 ea                	shr    %cl,%edx
  80272c:	09 d8                	or     %ebx,%eax
  80272e:	83 c4 1c             	add    $0x1c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	89 da                	mov    %ebx,%edx
  802742:	29 fe                	sub    %edi,%esi
  802744:	19 c2                	sbb    %eax,%edx
  802746:	89 f1                	mov    %esi,%ecx
  802748:	89 c8                	mov    %ecx,%eax
  80274a:	e9 4b ff ff ff       	jmp    80269a <__umoddi3+0x8a>
