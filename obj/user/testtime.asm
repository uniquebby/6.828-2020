
obj/user/testtime.debug：     文件格式 elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003a:	e8 b1 0d 00 00       	call   800df0 <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80004f:	7d 14                	jge    800065 <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	77 22                	ja     800077 <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  800055:	e8 96 0d 00 00       	call   800df0 <sys_time_msec>
  80005a:	39 d8                	cmp    %ebx,%eax
  80005c:	73 2d                	jae    80008b <sleep+0x58>
		sys_yield();
  80005e:	e8 7d 0b 00 00       	call   800be0 <sys_yield>
  800063:	eb f0                	jmp    800055 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800065:	50                   	push   %eax
  800066:	68 20 23 80 00       	push   $0x802320
  80006b:	6a 0b                	push   $0xb
  80006d:	68 32 23 80 00       	push   $0x802332
  800072:	e8 df 00 00 00       	call   800156 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 42 23 80 00       	push   $0x802342
  80007f:	6a 0d                	push   $0xd
  800081:	68 32 23 80 00       	push   $0x802332
  800086:	e8 cb 00 00 00       	call   800156 <_panic>
}
  80008b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008e:	c9                   	leave  
  80008f:	c3                   	ret    

00800090 <umain>:

void
umain(int argc, char **argv)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	53                   	push   %ebx
  800094:	83 ec 04             	sub    $0x4,%esp
  800097:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80009c:	e8 3f 0b 00 00       	call   800be0 <sys_yield>
	for (i = 0; i < 50; i++)
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 f6                	jne    80009c <umain+0xc>

	cprintf("starting count down: ");
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	68 4e 23 80 00       	push   $0x80234e
  8000ae:	e8 7e 01 00 00       	call   800231 <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 64 23 80 00       	push   $0x802364
  8000c4:	e8 68 01 00 00       	call   800231 <cprintf>
		sleep(1);
  8000c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d0:	e8 5e ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000d5:	83 eb 01             	sub    $0x1,%ebx
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000de:	75 db                	jne    8000bb <umain+0x2b>
	}
	cprintf("\n");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 b3 27 80 00       	push   $0x8027b3
  8000e8:	e8 44 01 00 00       	call   800231 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000ed:	cc                   	int3   
	breakpoint();
}
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800101:	e8 bb 0a 00 00       	call   800bc1 <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800113:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800118:	85 db                	test   %ebx,%ebx
  80011a:	7e 07                	jle    800123 <libmain+0x2d>
		binaryname = argv[0];
  80011c:	8b 06                	mov    (%esi),%eax
  80011e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800123:	83 ec 08             	sub    $0x8,%esp
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
  800128:	e8 63 ff ff ff       	call   800090 <umain>

	// exit gracefully
	exit();
  80012d:	e8 0a 00 00 00       	call   80013c <exit>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800142:	e8 a0 0e 00 00       	call   800fe7 <close_all>
	sys_env_destroy(0);
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 00                	push   $0x0
  80014c:	e8 2f 0a 00 00       	call   800b80 <sys_env_destroy>
}
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	c9                   	leave  
  800155:	c3                   	ret    

00800156 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80015b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800164:	e8 58 0a 00 00       	call   800bc1 <sys_getenvid>
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	ff 75 0c             	pushl  0xc(%ebp)
  80016f:	ff 75 08             	pushl  0x8(%ebp)
  800172:	56                   	push   %esi
  800173:	50                   	push   %eax
  800174:	68 74 23 80 00       	push   $0x802374
  800179:	e8 b3 00 00 00       	call   800231 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017e:	83 c4 18             	add    $0x18,%esp
  800181:	53                   	push   %ebx
  800182:	ff 75 10             	pushl  0x10(%ebp)
  800185:	e8 56 00 00 00       	call   8001e0 <vcprintf>
	cprintf("\n");
  80018a:	c7 04 24 b3 27 80 00 	movl   $0x8027b3,(%esp)
  800191:	e8 9b 00 00 00       	call   800231 <cprintf>
  800196:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800199:	cc                   	int3   
  80019a:	eb fd                	jmp    800199 <_panic+0x43>

0080019c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	53                   	push   %ebx
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a6:	8b 13                	mov    (%ebx),%edx
  8001a8:	8d 42 01             	lea    0x1(%edx),%eax
  8001ab:	89 03                	mov    %eax,(%ebx)
  8001ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b9:	74 09                	je     8001c4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	68 ff 00 00 00       	push   $0xff
  8001cc:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cf:	50                   	push   %eax
  8001d0:	e8 6e 09 00 00       	call   800b43 <sys_cputs>
		b->idx = 0;
  8001d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	eb db                	jmp    8001bb <putch+0x1f>

008001e0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f0:	00 00 00 
	b.cnt = 0;
  8001f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fd:	ff 75 0c             	pushl  0xc(%ebp)
  800200:	ff 75 08             	pushl  0x8(%ebp)
  800203:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800209:	50                   	push   %eax
  80020a:	68 9c 01 80 00       	push   $0x80019c
  80020f:	e8 19 01 00 00       	call   80032d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800214:	83 c4 08             	add    $0x8,%esp
  800217:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	e8 1a 09 00 00       	call   800b43 <sys_cputs>

	return b.cnt;
}
  800229:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022f:	c9                   	leave  
  800230:	c3                   	ret    

00800231 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800237:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023a:	50                   	push   %eax
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	e8 9d ff ff ff       	call   8001e0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	57                   	push   %edi
  800249:	56                   	push   %esi
  80024a:	53                   	push   %ebx
  80024b:	83 ec 1c             	sub    $0x1c,%esp
  80024e:	89 c7                	mov    %eax,%edi
  800250:	89 d6                	mov    %edx,%esi
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	8b 55 0c             	mov    0xc(%ebp),%edx
  800258:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800261:	bb 00 00 00 00       	mov    $0x0,%ebx
  800266:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800269:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80026f:	89 d0                	mov    %edx,%eax
  800271:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800277:	73 15                	jae    80028e <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800279:	83 eb 01             	sub    $0x1,%ebx
  80027c:	85 db                	test   %ebx,%ebx
  80027e:	7e 43                	jle    8002c3 <printnum+0x7e>
			putch(padc, putdat);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	56                   	push   %esi
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	ff d7                	call   *%edi
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb eb                	jmp    800279 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	ff 75 18             	pushl  0x18(%ebp)
  800294:	8b 45 14             	mov    0x14(%ebp),%eax
  800297:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80029a:	53                   	push   %ebx
  80029b:	ff 75 10             	pushl  0x10(%ebp)
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ad:	e8 1e 1e 00 00       	call   8020d0 <__udivdi3>
  8002b2:	83 c4 18             	add    $0x18,%esp
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	89 f2                	mov    %esi,%edx
  8002b9:	89 f8                	mov    %edi,%eax
  8002bb:	e8 85 ff ff ff       	call   800245 <printnum>
  8002c0:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	56                   	push   %esi
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d6:	e8 05 1f 00 00       	call   8021e0 <__umoddi3>
  8002db:	83 c4 14             	add    $0x14,%esp
  8002de:	0f be 80 97 23 80 00 	movsbl 0x802397(%eax),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff d7                	call   *%edi
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ee:	5b                   	pop    %ebx
  8002ef:	5e                   	pop    %esi
  8002f0:	5f                   	pop    %edi
  8002f1:	5d                   	pop    %ebp
  8002f2:	c3                   	ret    

008002f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fd:	8b 10                	mov    (%eax),%edx
  8002ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800302:	73 0a                	jae    80030e <sprintputch+0x1b>
		*b->buf++ = ch;
  800304:	8d 4a 01             	lea    0x1(%edx),%ecx
  800307:	89 08                	mov    %ecx,(%eax)
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	88 02                	mov    %al,(%edx)
}
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <printfmt>:
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800316:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800319:	50                   	push   %eax
  80031a:	ff 75 10             	pushl  0x10(%ebp)
  80031d:	ff 75 0c             	pushl  0xc(%ebp)
  800320:	ff 75 08             	pushl  0x8(%ebp)
  800323:	e8 05 00 00 00       	call   80032d <vprintfmt>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <vprintfmt>:
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	57                   	push   %edi
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
  800333:	83 ec 3c             	sub    $0x3c,%esp
  800336:	8b 75 08             	mov    0x8(%ebp),%esi
  800339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033f:	eb 0a                	jmp    80034b <vprintfmt+0x1e>
			putch(ch, putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	53                   	push   %ebx
  800345:	50                   	push   %eax
  800346:	ff d6                	call   *%esi
  800348:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80034b:	83 c7 01             	add    $0x1,%edi
  80034e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800352:	83 f8 25             	cmp    $0x25,%eax
  800355:	74 0c                	je     800363 <vprintfmt+0x36>
			if (ch == '\0')
  800357:	85 c0                	test   %eax,%eax
  800359:	75 e6                	jne    800341 <vprintfmt+0x14>
}
  80035b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035e:	5b                   	pop    %ebx
  80035f:	5e                   	pop    %esi
  800360:	5f                   	pop    %edi
  800361:	5d                   	pop    %ebp
  800362:	c3                   	ret    
		padc = ' ';
  800363:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800367:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80036e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800375:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80037c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800381:	8d 47 01             	lea    0x1(%edi),%eax
  800384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800387:	0f b6 17             	movzbl (%edi),%edx
  80038a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80038d:	3c 55                	cmp    $0x55,%al
  80038f:	0f 87 ba 03 00 00    	ja     80074f <vprintfmt+0x422>
  800395:	0f b6 c0             	movzbl %al,%eax
  800398:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003a6:	eb d9                	jmp    800381 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ab:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003af:	eb d0                	jmp    800381 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	0f b6 d2             	movzbl %dl,%edx
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003cc:	83 f9 09             	cmp    $0x9,%ecx
  8003cf:	77 55                	ja     800426 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003d1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d4:	eb e9                	jmp    8003bf <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8d 40 04             	lea    0x4(%eax),%eax
  8003e4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ee:	79 91                	jns    800381 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fd:	eb 82                	jmp    800381 <vprintfmt+0x54>
  8003ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800402:	85 c0                	test   %eax,%eax
  800404:	ba 00 00 00 00       	mov    $0x0,%edx
  800409:	0f 49 d0             	cmovns %eax,%edx
  80040c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800412:	e9 6a ff ff ff       	jmp    800381 <vprintfmt+0x54>
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800421:	e9 5b ff ff ff       	jmp    800381 <vprintfmt+0x54>
  800426:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800429:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042c:	eb bc                	jmp    8003ea <vprintfmt+0xbd>
			lflag++;
  80042e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800434:	e9 48 ff ff ff       	jmp    800381 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	8d 78 04             	lea    0x4(%eax),%edi
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	53                   	push   %ebx
  800443:	ff 30                	pushl  (%eax)
  800445:	ff d6                	call   *%esi
			break;
  800447:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80044a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80044d:	e9 9c 02 00 00       	jmp    8006ee <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800452:	8b 45 14             	mov    0x14(%ebp),%eax
  800455:	8d 78 04             	lea    0x4(%eax),%edi
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	99                   	cltd   
  80045b:	31 d0                	xor    %edx,%eax
  80045d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045f:	83 f8 0f             	cmp    $0xf,%eax
  800462:	7f 23                	jg     800487 <vprintfmt+0x15a>
  800464:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 18                	je     800487 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80046f:	52                   	push   %edx
  800470:	68 7a 27 80 00       	push   $0x80277a
  800475:	53                   	push   %ebx
  800476:	56                   	push   %esi
  800477:	e8 94 fe ff ff       	call   800310 <printfmt>
  80047c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800482:	e9 67 02 00 00       	jmp    8006ee <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800487:	50                   	push   %eax
  800488:	68 af 23 80 00       	push   $0x8023af
  80048d:	53                   	push   %ebx
  80048e:	56                   	push   %esi
  80048f:	e8 7c fe ff ff       	call   800310 <printfmt>
  800494:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800497:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80049a:	e9 4f 02 00 00       	jmp    8006ee <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004ad:	85 d2                	test   %edx,%edx
  8004af:	b8 a8 23 80 00       	mov    $0x8023a8,%eax
  8004b4:	0f 45 c2             	cmovne %edx,%eax
  8004b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004be:	7e 06                	jle    8004c6 <vprintfmt+0x199>
  8004c0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c4:	75 0d                	jne    8004d3 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c9:	89 c7                	mov    %eax,%edi
  8004cb:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d1:	eb 3f                	jmp    800512 <vprintfmt+0x1e5>
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	e8 0d 03 00 00       	call   8007ec <strnlen>
  8004df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e2:	29 c2                	sub    %eax,%edx
  8004e4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004ec:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	85 ff                	test   %edi,%edi
  8004f5:	7e 58                	jle    80054f <vprintfmt+0x222>
					putch(padc, putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fe:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800500:	83 ef 01             	sub    $0x1,%edi
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb eb                	jmp    8004f3 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	52                   	push   %edx
  80050d:	ff d6                	call   *%esi
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800515:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800517:	83 c7 01             	add    $0x1,%edi
  80051a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051e:	0f be d0             	movsbl %al,%edx
  800521:	85 d2                	test   %edx,%edx
  800523:	74 45                	je     80056a <vprintfmt+0x23d>
  800525:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800529:	78 06                	js     800531 <vprintfmt+0x204>
  80052b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80052f:	78 35                	js     800566 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800531:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800535:	74 d1                	je     800508 <vprintfmt+0x1db>
  800537:	0f be c0             	movsbl %al,%eax
  80053a:	83 e8 20             	sub    $0x20,%eax
  80053d:	83 f8 5e             	cmp    $0x5e,%eax
  800540:	76 c6                	jbe    800508 <vprintfmt+0x1db>
					putch('?', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	6a 3f                	push   $0x3f
  800548:	ff d6                	call   *%esi
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb c3                	jmp    800512 <vprintfmt+0x1e5>
  80054f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	b8 00 00 00 00       	mov    $0x0,%eax
  800559:	0f 49 c2             	cmovns %edx,%eax
  80055c:	29 c2                	sub    %eax,%edx
  80055e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800561:	e9 60 ff ff ff       	jmp    8004c6 <vprintfmt+0x199>
  800566:	89 cf                	mov    %ecx,%edi
  800568:	eb 02                	jmp    80056c <vprintfmt+0x23f>
  80056a:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80056c:	85 ff                	test   %edi,%edi
  80056e:	7e 10                	jle    800580 <vprintfmt+0x253>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	eb ec                	jmp    80056c <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800580:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
  800586:	e9 63 01 00 00       	jmp    8006ee <vprintfmt+0x3c1>
	if (lflag >= 2)
  80058b:	83 f9 01             	cmp    $0x1,%ecx
  80058e:	7f 1b                	jg     8005ab <vprintfmt+0x27e>
	else if (lflag)
  800590:	85 c9                	test   %ecx,%ecx
  800592:	74 63                	je     8005f7 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	99                   	cltd   
  80059d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a9:	eb 17                	jmp    8005c2 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 50 04             	mov    0x4(%eax),%edx
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 08             	lea    0x8(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	0f 89 ff 00 00 00    	jns    8006d4 <vprintfmt+0x3a7>
				putch('-', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 2d                	push   $0x2d
  8005db:	ff d6                	call   *%esi
				num = -(long long) num;
  8005dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e3:	f7 da                	neg    %edx
  8005e5:	83 d1 00             	adc    $0x0,%ecx
  8005e8:	f7 d9                	neg    %ecx
  8005ea:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 dd 00 00 00       	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	99                   	cltd   
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb b4                	jmp    8005c2 <vprintfmt+0x295>
	if (lflag >= 2)
  80060e:	83 f9 01             	cmp    $0x1,%ecx
  800611:	7f 1e                	jg     800631 <vprintfmt+0x304>
	else if (lflag)
  800613:	85 c9                	test   %ecx,%ecx
  800615:	74 32                	je     800649 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 10                	mov    (%eax),%edx
  80061c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800627:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062c:	e9 a3 00 00 00       	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 10                	mov    (%eax),%edx
  800636:	8b 48 04             	mov    0x4(%eax),%ecx
  800639:	8d 40 08             	lea    0x8(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800644:	e9 8b 00 00 00       	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800659:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065e:	eb 74                	jmp    8006d4 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800660:	83 f9 01             	cmp    $0x1,%ecx
  800663:	7f 1b                	jg     800680 <vprintfmt+0x353>
	else if (lflag)
  800665:	85 c9                	test   %ecx,%ecx
  800667:	74 2c                	je     800695 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
  80067e:	eb 54                	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 10                	mov    (%eax),%edx
  800685:	8b 48 04             	mov    0x4(%eax),%ecx
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068e:	b8 08 00 00 00       	mov    $0x8,%eax
  800693:	eb 3f                	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006aa:	eb 28                	jmp    8006d4 <vprintfmt+0x3a7>
			putch('0', putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 30                	push   $0x30
  8006b2:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b4:	83 c4 08             	add    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 78                	push   $0x78
  8006ba:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 10                	mov    (%eax),%edx
  8006c1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c9:	8d 40 04             	lea    0x4(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cf:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006d4:	83 ec 0c             	sub    $0xc,%esp
  8006d7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006db:	57                   	push   %edi
  8006dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	51                   	push   %ecx
  8006e1:	52                   	push   %edx
  8006e2:	89 da                	mov    %ebx,%edx
  8006e4:	89 f0                	mov    %esi,%eax
  8006e6:	e8 5a fb ff ff       	call   800245 <printnum>
			break;
  8006eb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	e9 55 fc ff ff       	jmp    80034b <vprintfmt+0x1e>
	if (lflag >= 2)
  8006f6:	83 f9 01             	cmp    $0x1,%ecx
  8006f9:	7f 1b                	jg     800716 <vprintfmt+0x3e9>
	else if (lflag)
  8006fb:	85 c9                	test   %ecx,%ecx
  8006fd:	74 2c                	je     80072b <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	b8 10 00 00 00       	mov    $0x10,%eax
  800714:	eb be                	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 10                	mov    (%eax),%edx
  80071b:	8b 48 04             	mov    0x4(%eax),%ecx
  80071e:	8d 40 08             	lea    0x8(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800724:	b8 10 00 00 00       	mov    $0x10,%eax
  800729:	eb a9                	jmp    8006d4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 10                	mov    (%eax),%edx
  800730:	b9 00 00 00 00       	mov    $0x0,%ecx
  800735:	8d 40 04             	lea    0x4(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073b:	b8 10 00 00 00       	mov    $0x10,%eax
  800740:	eb 92                	jmp    8006d4 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	6a 25                	push   $0x25
  800748:	ff d6                	call   *%esi
			break;
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	eb 9f                	jmp    8006ee <vprintfmt+0x3c1>
			putch('%', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	6a 25                	push   $0x25
  800755:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	89 f8                	mov    %edi,%eax
  80075c:	eb 03                	jmp    800761 <vprintfmt+0x434>
  80075e:	83 e8 01             	sub    $0x1,%eax
  800761:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800765:	75 f7                	jne    80075e <vprintfmt+0x431>
  800767:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076a:	eb 82                	jmp    8006ee <vprintfmt+0x3c1>

0080076c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800778:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800782:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 26                	je     8007b3 <vsnprintf+0x47>
  80078d:	85 d2                	test   %edx,%edx
  80078f:	7e 22                	jle    8007b3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800791:	ff 75 14             	pushl  0x14(%ebp)
  800794:	ff 75 10             	pushl  0x10(%ebp)
  800797:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	68 f3 02 80 00       	push   $0x8002f3
  8007a0:	e8 88 fb ff ff       	call   80032d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    
		return -E_INVAL;
  8007b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b8:	eb f7                	jmp    8007b1 <vsnprintf+0x45>

008007ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 10             	pushl  0x10(%ebp)
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 9a ff ff ff       	call   80076c <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e3:	74 05                	je     8007ea <strlen+0x16>
		n++;
  8007e5:	83 c0 01             	add    $0x1,%eax
  8007e8:	eb f5                	jmp    8007df <strlen+0xb>
	return n;
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	39 c2                	cmp    %eax,%edx
  8007fc:	74 0d                	je     80080b <strnlen+0x1f>
  8007fe:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800802:	74 05                	je     800809 <strnlen+0x1d>
		n++;
  800804:	83 c2 01             	add    $0x1,%edx
  800807:	eb f1                	jmp    8007fa <strnlen+0xe>
  800809:	89 d0                	mov    %edx,%eax
	return n;
}
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800820:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800823:	83 c2 01             	add    $0x1,%edx
  800826:	84 c9                	test   %cl,%cl
  800828:	75 f2                	jne    80081c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80082a:	5b                   	pop    %ebx
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	53                   	push   %ebx
  800831:	83 ec 10             	sub    $0x10,%esp
  800834:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800837:	53                   	push   %ebx
  800838:	e8 97 ff ff ff       	call   8007d4 <strlen>
  80083d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	01 d8                	add    %ebx,%eax
  800845:	50                   	push   %eax
  800846:	e8 c2 ff ff ff       	call   80080d <strcpy>
	return dst;
}
  80084b:	89 d8                	mov    %ebx,%eax
  80084d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	56                   	push   %esi
  800856:	53                   	push   %ebx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	89 c6                	mov    %eax,%esi
  80085f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800862:	89 c2                	mov    %eax,%edx
  800864:	39 f2                	cmp    %esi,%edx
  800866:	74 11                	je     800879 <strncpy+0x27>
		*dst++ = *src;
  800868:	83 c2 01             	add    $0x1,%edx
  80086b:	0f b6 19             	movzbl (%ecx),%ebx
  80086e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800871:	80 fb 01             	cmp    $0x1,%bl
  800874:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800877:	eb eb                	jmp    800864 <strncpy+0x12>
	}
	return ret;
}
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	8b 75 08             	mov    0x8(%ebp),%esi
  800885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800888:	8b 55 10             	mov    0x10(%ebp),%edx
  80088b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80088d:	85 d2                	test   %edx,%edx
  80088f:	74 21                	je     8008b2 <strlcpy+0x35>
  800891:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800895:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800897:	39 c2                	cmp    %eax,%edx
  800899:	74 14                	je     8008af <strlcpy+0x32>
  80089b:	0f b6 19             	movzbl (%ecx),%ebx
  80089e:	84 db                	test   %bl,%bl
  8008a0:	74 0b                	je     8008ad <strlcpy+0x30>
			*dst++ = *src++;
  8008a2:	83 c1 01             	add    $0x1,%ecx
  8008a5:	83 c2 01             	add    $0x1,%edx
  8008a8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ab:	eb ea                	jmp    800897 <strlcpy+0x1a>
  8008ad:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b2:	29 f0                	sub    %esi,%eax
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c1:	0f b6 01             	movzbl (%ecx),%eax
  8008c4:	84 c0                	test   %al,%al
  8008c6:	74 0c                	je     8008d4 <strcmp+0x1c>
  8008c8:	3a 02                	cmp    (%edx),%al
  8008ca:	75 08                	jne    8008d4 <strcmp+0x1c>
		p++, q++;
  8008cc:	83 c1 01             	add    $0x1,%ecx
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	eb ed                	jmp    8008c1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d4:	0f b6 c0             	movzbl %al,%eax
  8008d7:	0f b6 12             	movzbl (%edx),%edx
  8008da:	29 d0                	sub    %edx,%eax
}
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e8:	89 c3                	mov    %eax,%ebx
  8008ea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ed:	eb 06                	jmp    8008f5 <strncmp+0x17>
		n--, p++, q++;
  8008ef:	83 c0 01             	add    $0x1,%eax
  8008f2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f5:	39 d8                	cmp    %ebx,%eax
  8008f7:	74 16                	je     80090f <strncmp+0x31>
  8008f9:	0f b6 08             	movzbl (%eax),%ecx
  8008fc:	84 c9                	test   %cl,%cl
  8008fe:	74 04                	je     800904 <strncmp+0x26>
  800900:	3a 0a                	cmp    (%edx),%cl
  800902:	74 eb                	je     8008ef <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800904:	0f b6 00             	movzbl (%eax),%eax
  800907:	0f b6 12             	movzbl (%edx),%edx
  80090a:	29 d0                	sub    %edx,%eax
}
  80090c:	5b                   	pop    %ebx
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    
		return 0;
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	eb f6                	jmp    80090c <strncmp+0x2e>

00800916 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	0f b6 10             	movzbl (%eax),%edx
  800923:	84 d2                	test   %dl,%dl
  800925:	74 09                	je     800930 <strchr+0x1a>
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 0a                	je     800935 <strchr+0x1f>
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f0                	jmp    800920 <strchr+0xa>
			return (char *) s;
	return 0;
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800941:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800944:	38 ca                	cmp    %cl,%dl
  800946:	74 09                	je     800951 <strfind+0x1a>
  800948:	84 d2                	test   %dl,%dl
  80094a:	74 05                	je     800951 <strfind+0x1a>
	for (; *s; s++)
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	eb f0                	jmp    800941 <strfind+0xa>
			break;
	return (char *) s;
}
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	57                   	push   %edi
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095f:	85 c9                	test   %ecx,%ecx
  800961:	74 31                	je     800994 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800963:	89 f8                	mov    %edi,%eax
  800965:	09 c8                	or     %ecx,%eax
  800967:	a8 03                	test   $0x3,%al
  800969:	75 23                	jne    80098e <memset+0x3b>
		c &= 0xFF;
  80096b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80096f:	89 d3                	mov    %edx,%ebx
  800971:	c1 e3 08             	shl    $0x8,%ebx
  800974:	89 d0                	mov    %edx,%eax
  800976:	c1 e0 18             	shl    $0x18,%eax
  800979:	89 d6                	mov    %edx,%esi
  80097b:	c1 e6 10             	shl    $0x10,%esi
  80097e:	09 f0                	or     %esi,%eax
  800980:	09 c2                	or     %eax,%edx
  800982:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800984:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800987:	89 d0                	mov    %edx,%eax
  800989:	fc                   	cld    
  80098a:	f3 ab                	rep stos %eax,%es:(%edi)
  80098c:	eb 06                	jmp    800994 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	fc                   	cld    
  800992:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800994:	89 f8                	mov    %edi,%eax
  800996:	5b                   	pop    %ebx
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	57                   	push   %edi
  80099f:	56                   	push   %esi
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a9:	39 c6                	cmp    %eax,%esi
  8009ab:	73 32                	jae    8009df <memmove+0x44>
  8009ad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	76 2b                	jbe    8009df <memmove+0x44>
		s += n;
		d += n;
  8009b4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b7:	89 fe                	mov    %edi,%esi
  8009b9:	09 ce                	or     %ecx,%esi
  8009bb:	09 d6                	or     %edx,%esi
  8009bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c3:	75 0e                	jne    8009d3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c5:	83 ef 04             	sub    $0x4,%edi
  8009c8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009cb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ce:	fd                   	std    
  8009cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d1:	eb 09                	jmp    8009dc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009d3:	83 ef 01             	sub    $0x1,%edi
  8009d6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d9:	fd                   	std    
  8009da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009dc:	fc                   	cld    
  8009dd:	eb 1a                	jmp    8009f9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	09 ca                	or     %ecx,%edx
  8009e3:	09 f2                	or     %esi,%edx
  8009e5:	f6 c2 03             	test   $0x3,%dl
  8009e8:	75 0a                	jne    8009f4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ed:	89 c7                	mov    %eax,%edi
  8009ef:	fc                   	cld    
  8009f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f2:	eb 05                	jmp    8009f9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009f4:	89 c7                	mov    %eax,%edi
  8009f6:	fc                   	cld    
  8009f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f9:	5e                   	pop    %esi
  8009fa:	5f                   	pop    %edi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a03:	ff 75 10             	pushl  0x10(%ebp)
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	e8 8a ff ff ff       	call   80099b <memmove>
}
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	56                   	push   %esi
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	89 c6                	mov    %eax,%esi
  800a20:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a23:	39 f0                	cmp    %esi,%eax
  800a25:	74 1c                	je     800a43 <memcmp+0x30>
		if (*s1 != *s2)
  800a27:	0f b6 08             	movzbl (%eax),%ecx
  800a2a:	0f b6 1a             	movzbl (%edx),%ebx
  800a2d:	38 d9                	cmp    %bl,%cl
  800a2f:	75 08                	jne    800a39 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a31:	83 c0 01             	add    $0x1,%eax
  800a34:	83 c2 01             	add    $0x1,%edx
  800a37:	eb ea                	jmp    800a23 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a39:	0f b6 c1             	movzbl %cl,%eax
  800a3c:	0f b6 db             	movzbl %bl,%ebx
  800a3f:	29 d8                	sub    %ebx,%eax
  800a41:	eb 05                	jmp    800a48 <memcmp+0x35>
	}

	return 0;
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5e                   	pop    %esi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5a:	39 d0                	cmp    %edx,%eax
  800a5c:	73 09                	jae    800a67 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5e:	38 08                	cmp    %cl,(%eax)
  800a60:	74 05                	je     800a67 <memfind+0x1b>
	for (; s < ends; s++)
  800a62:	83 c0 01             	add    $0x1,%eax
  800a65:	eb f3                	jmp    800a5a <memfind+0xe>
			break;
	return (void *) s;
}
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	57                   	push   %edi
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a75:	eb 03                	jmp    800a7a <strtol+0x11>
		s++;
  800a77:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7a:	0f b6 01             	movzbl (%ecx),%eax
  800a7d:	3c 20                	cmp    $0x20,%al
  800a7f:	74 f6                	je     800a77 <strtol+0xe>
  800a81:	3c 09                	cmp    $0x9,%al
  800a83:	74 f2                	je     800a77 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a85:	3c 2b                	cmp    $0x2b,%al
  800a87:	74 2a                	je     800ab3 <strtol+0x4a>
	int neg = 0;
  800a89:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a8e:	3c 2d                	cmp    $0x2d,%al
  800a90:	74 2b                	je     800abd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a92:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a98:	75 0f                	jne    800aa9 <strtol+0x40>
  800a9a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9d:	74 28                	je     800ac7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a9f:	85 db                	test   %ebx,%ebx
  800aa1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa6:	0f 44 d8             	cmove  %eax,%ebx
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab1:	eb 50                	jmp    800b03 <strtol+0x9a>
		s++;
  800ab3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
  800abb:	eb d5                	jmp    800a92 <strtol+0x29>
		s++, neg = 1;
  800abd:	83 c1 01             	add    $0x1,%ecx
  800ac0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac5:	eb cb                	jmp    800a92 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800acb:	74 0e                	je     800adb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	75 d8                	jne    800aa9 <strtol+0x40>
		s++, base = 8;
  800ad1:	83 c1 01             	add    $0x1,%ecx
  800ad4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad9:	eb ce                	jmp    800aa9 <strtol+0x40>
		s += 2, base = 16;
  800adb:	83 c1 02             	add    $0x2,%ecx
  800ade:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae3:	eb c4                	jmp    800aa9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ae5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae8:	89 f3                	mov    %esi,%ebx
  800aea:	80 fb 19             	cmp    $0x19,%bl
  800aed:	77 29                	ja     800b18 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800aef:	0f be d2             	movsbl %dl,%edx
  800af2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af8:	7d 30                	jge    800b2a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800afa:	83 c1 01             	add    $0x1,%ecx
  800afd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b01:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b03:	0f b6 11             	movzbl (%ecx),%edx
  800b06:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b09:	89 f3                	mov    %esi,%ebx
  800b0b:	80 fb 09             	cmp    $0x9,%bl
  800b0e:	77 d5                	ja     800ae5 <strtol+0x7c>
			dig = *s - '0';
  800b10:	0f be d2             	movsbl %dl,%edx
  800b13:	83 ea 30             	sub    $0x30,%edx
  800b16:	eb dd                	jmp    800af5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b18:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b1b:	89 f3                	mov    %esi,%ebx
  800b1d:	80 fb 19             	cmp    $0x19,%bl
  800b20:	77 08                	ja     800b2a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b22:	0f be d2             	movsbl %dl,%edx
  800b25:	83 ea 37             	sub    $0x37,%edx
  800b28:	eb cb                	jmp    800af5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2e:	74 05                	je     800b35 <strtol+0xcc>
		*endptr = (char *) s;
  800b30:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b33:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	f7 da                	neg    %edx
  800b39:	85 ff                	test   %edi,%edi
  800b3b:	0f 45 c2             	cmovne %edx,%eax
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b54:	89 c3                	mov    %eax,%ebx
  800b56:	89 c7                	mov    %eax,%edi
  800b58:	89 c6                	mov    %eax,%esi
  800b5a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b5c:	5b                   	pop    %ebx
  800b5d:	5e                   	pop    %esi
  800b5e:	5f                   	pop    %edi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b71:	89 d1                	mov    %edx,%ecx
  800b73:	89 d3                	mov    %edx,%ebx
  800b75:	89 d7                	mov    %edx,%edi
  800b77:	89 d6                	mov    %edx,%esi
  800b79:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b91:	b8 03 00 00 00       	mov    $0x3,%eax
  800b96:	89 cb                	mov    %ecx,%ebx
  800b98:	89 cf                	mov    %ecx,%edi
  800b9a:	89 ce                	mov    %ecx,%esi
  800b9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	7f 08                	jg     800baa <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	6a 03                	push   $0x3
  800bb0:	68 9f 26 80 00       	push   $0x80269f
  800bb5:	6a 23                	push   $0x23
  800bb7:	68 bc 26 80 00       	push   $0x8026bc
  800bbc:	e8 95 f5 ff ff       	call   800156 <_panic>

00800bc1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	57                   	push   %edi
  800bc5:	56                   	push   %esi
  800bc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd1:	89 d1                	mov    %edx,%ecx
  800bd3:	89 d3                	mov    %edx,%ebx
  800bd5:	89 d7                	mov    %edx,%edi
  800bd7:	89 d6                	mov    %edx,%esi
  800bd9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <sys_yield>:

void
sys_yield(void)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be6:	ba 00 00 00 00       	mov    $0x0,%edx
  800beb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf0:	89 d1                	mov    %edx,%ecx
  800bf2:	89 d3                	mov    %edx,%ebx
  800bf4:	89 d7                	mov    %edx,%edi
  800bf6:	89 d6                	mov    %edx,%esi
  800bf8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
  800c05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c08:	be 00 00 00 00       	mov    $0x0,%esi
  800c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	b8 04 00 00 00       	mov    $0x4,%eax
  800c18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1b:	89 f7                	mov    %esi,%edi
  800c1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	7f 08                	jg     800c2b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	50                   	push   %eax
  800c2f:	6a 04                	push   $0x4
  800c31:	68 9f 26 80 00       	push   $0x80269f
  800c36:	6a 23                	push   $0x23
  800c38:	68 bc 26 80 00       	push   $0x8026bc
  800c3d:	e8 14 f5 ff ff       	call   800156 <_panic>

00800c42 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c51:	b8 05 00 00 00       	mov    $0x5,%eax
  800c56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c59:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5c:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	7f 08                	jg     800c6d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6d:	83 ec 0c             	sub    $0xc,%esp
  800c70:	50                   	push   %eax
  800c71:	6a 05                	push   $0x5
  800c73:	68 9f 26 80 00       	push   $0x80269f
  800c78:	6a 23                	push   $0x23
  800c7a:	68 bc 26 80 00       	push   $0x8026bc
  800c7f:	e8 d2 f4 ff ff       	call   800156 <_panic>

00800c84 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
  800c8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9d:	89 df                	mov    %ebx,%edi
  800c9f:	89 de                	mov    %ebx,%esi
  800ca1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7f 08                	jg     800caf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caf:	83 ec 0c             	sub    $0xc,%esp
  800cb2:	50                   	push   %eax
  800cb3:	6a 06                	push   $0x6
  800cb5:	68 9f 26 80 00       	push   $0x80269f
  800cba:	6a 23                	push   $0x23
  800cbc:	68 bc 26 80 00       	push   $0x8026bc
  800cc1:	e8 90 f4 ff ff       	call   800156 <_panic>

00800cc6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	b8 08 00 00 00       	mov    $0x8,%eax
  800cdf:	89 df                	mov    %ebx,%edi
  800ce1:	89 de                	mov    %ebx,%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 08                	push   $0x8
  800cf7:	68 9f 26 80 00       	push   $0x80269f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 bc 26 80 00       	push   $0x8026bc
  800d03:	e8 4e f4 ff ff       	call   800156 <_panic>

00800d08 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1c:	b8 09 00 00 00       	mov    $0x9,%eax
  800d21:	89 df                	mov    %ebx,%edi
  800d23:	89 de                	mov    %ebx,%esi
  800d25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7f 08                	jg     800d33 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	50                   	push   %eax
  800d37:	6a 09                	push   $0x9
  800d39:	68 9f 26 80 00       	push   $0x80269f
  800d3e:	6a 23                	push   $0x23
  800d40:	68 bc 26 80 00       	push   $0x8026bc
  800d45:	e8 0c f4 ff ff       	call   800156 <_panic>

00800d4a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	89 de                	mov    %ebx,%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 0a                	push   $0xa
  800d7b:	68 9f 26 80 00       	push   $0x80269f
  800d80:	6a 23                	push   $0x23
  800d82:	68 bc 26 80 00       	push   $0x8026bc
  800d87:	e8 ca f3 ff ff       	call   800156 <_panic>

00800d8c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d92:	8b 55 08             	mov    0x8(%ebp),%edx
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d9d:	be 00 00 00 00       	mov    $0x0,%esi
  800da2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dc5:	89 cb                	mov    %ecx,%ebx
  800dc7:	89 cf                	mov    %ecx,%edi
  800dc9:	89 ce                	mov    %ecx,%esi
  800dcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	7f 08                	jg     800dd9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd9:	83 ec 0c             	sub    $0xc,%esp
  800ddc:	50                   	push   %eax
  800ddd:	6a 0d                	push   $0xd
  800ddf:	68 9f 26 80 00       	push   $0x80269f
  800de4:	6a 23                	push   $0x23
  800de6:	68 bc 26 80 00       	push   $0x8026bc
  800deb:	e8 66 f3 ff ff       	call   800156 <_panic>

00800df0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e00:	89 d1                	mov    %edx,%ecx
  800e02:	89 d3                	mov    %edx,%ebx
  800e04:	89 d7                	mov    %edx,%edi
  800e06:	89 d6                	mov    %edx,%esi
  800e08:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	05 00 00 00 30       	add    $0x30000000,%eax
  800e1a:	c1 e8 0c             	shr    $0xc,%eax
}
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e2f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e3e:	89 c2                	mov    %eax,%edx
  800e40:	c1 ea 16             	shr    $0x16,%edx
  800e43:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e4a:	f6 c2 01             	test   $0x1,%dl
  800e4d:	74 2d                	je     800e7c <fd_alloc+0x46>
  800e4f:	89 c2                	mov    %eax,%edx
  800e51:	c1 ea 0c             	shr    $0xc,%edx
  800e54:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e5b:	f6 c2 01             	test   $0x1,%dl
  800e5e:	74 1c                	je     800e7c <fd_alloc+0x46>
  800e60:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e65:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e6a:	75 d2                	jne    800e3e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e75:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e7a:	eb 0a                	jmp    800e86 <fd_alloc+0x50>
			*fd_store = fd;
  800e7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e8e:	83 f8 1f             	cmp    $0x1f,%eax
  800e91:	77 30                	ja     800ec3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e93:	c1 e0 0c             	shl    $0xc,%eax
  800e96:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e9b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ea1:	f6 c2 01             	test   $0x1,%dl
  800ea4:	74 24                	je     800eca <fd_lookup+0x42>
  800ea6:	89 c2                	mov    %eax,%edx
  800ea8:	c1 ea 0c             	shr    $0xc,%edx
  800eab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb2:	f6 c2 01             	test   $0x1,%dl
  800eb5:	74 1a                	je     800ed1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eba:	89 02                	mov    %eax,(%edx)
	return 0;
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		return -E_INVAL;
  800ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec8:	eb f7                	jmp    800ec1 <fd_lookup+0x39>
		return -E_INVAL;
  800eca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecf:	eb f0                	jmp    800ec1 <fd_lookup+0x39>
  800ed1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed6:	eb e9                	jmp    800ec1 <fd_lookup+0x39>

00800ed8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eeb:	39 08                	cmp    %ecx,(%eax)
  800eed:	74 38                	je     800f27 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800eef:	83 c2 01             	add    $0x1,%edx
  800ef2:	8b 04 95 48 27 80 00 	mov    0x802748(,%edx,4),%eax
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	75 ee                	jne    800eeb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800efd:	a1 08 40 80 00       	mov    0x804008,%eax
  800f02:	8b 40 48             	mov    0x48(%eax),%eax
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	51                   	push   %ecx
  800f09:	50                   	push   %eax
  800f0a:	68 cc 26 80 00       	push   $0x8026cc
  800f0f:	e8 1d f3 ff ff       	call   800231 <cprintf>
	*dev = 0;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f1d:	83 c4 10             	add    $0x10,%esp
  800f20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    
			*dev = devtab[i];
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f31:	eb f2                	jmp    800f25 <dev_lookup+0x4d>

00800f33 <fd_close>:
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 24             	sub    $0x24,%esp
  800f3c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f45:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f46:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f4c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f4f:	50                   	push   %eax
  800f50:	e8 33 ff ff ff       	call   800e88 <fd_lookup>
  800f55:	89 c3                	mov    %eax,%ebx
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	78 05                	js     800f63 <fd_close+0x30>
	    || fd != fd2)
  800f5e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f61:	74 16                	je     800f79 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f63:	89 f8                	mov    %edi,%eax
  800f65:	84 c0                	test   %al,%al
  800f67:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6c:	0f 44 d8             	cmove  %eax,%ebx
}
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f7f:	50                   	push   %eax
  800f80:	ff 36                	pushl  (%esi)
  800f82:	e8 51 ff ff ff       	call   800ed8 <dev_lookup>
  800f87:	89 c3                	mov    %eax,%ebx
  800f89:	83 c4 10             	add    $0x10,%esp
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	78 1a                	js     800faa <fd_close+0x77>
		if (dev->dev_close)
  800f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f93:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	74 0b                	je     800faa <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	56                   	push   %esi
  800fa3:	ff d0                	call   *%eax
  800fa5:	89 c3                	mov    %eax,%ebx
  800fa7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800faa:	83 ec 08             	sub    $0x8,%esp
  800fad:	56                   	push   %esi
  800fae:	6a 00                	push   $0x0
  800fb0:	e8 cf fc ff ff       	call   800c84 <sys_page_unmap>
	return r;
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	eb b5                	jmp    800f6f <fd_close+0x3c>

00800fba <close>:

int
close(int fdnum)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc3:	50                   	push   %eax
  800fc4:	ff 75 08             	pushl  0x8(%ebp)
  800fc7:	e8 bc fe ff ff       	call   800e88 <fd_lookup>
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	79 02                	jns    800fd5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    
		return fd_close(fd, 1);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	6a 01                	push   $0x1
  800fda:	ff 75 f4             	pushl  -0xc(%ebp)
  800fdd:	e8 51 ff ff ff       	call   800f33 <fd_close>
  800fe2:	83 c4 10             	add    $0x10,%esp
  800fe5:	eb ec                	jmp    800fd3 <close+0x19>

00800fe7 <close_all>:

void
close_all(void)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	53                   	push   %ebx
  800feb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	53                   	push   %ebx
  800ff7:	e8 be ff ff ff       	call   800fba <close>
	for (i = 0; i < MAXFD; i++)
  800ffc:	83 c3 01             	add    $0x1,%ebx
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	83 fb 20             	cmp    $0x20,%ebx
  801005:	75 ec                	jne    800ff3 <close_all+0xc>
}
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801015:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801018:	50                   	push   %eax
  801019:	ff 75 08             	pushl  0x8(%ebp)
  80101c:	e8 67 fe ff ff       	call   800e88 <fd_lookup>
  801021:	89 c3                	mov    %eax,%ebx
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	0f 88 81 00 00 00    	js     8010af <dup+0xa3>
		return r;
	close(newfdnum);
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	ff 75 0c             	pushl  0xc(%ebp)
  801034:	e8 81 ff ff ff       	call   800fba <close>

	newfd = INDEX2FD(newfdnum);
  801039:	8b 75 0c             	mov    0xc(%ebp),%esi
  80103c:	c1 e6 0c             	shl    $0xc,%esi
  80103f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801045:	83 c4 04             	add    $0x4,%esp
  801048:	ff 75 e4             	pushl  -0x1c(%ebp)
  80104b:	e8 cf fd ff ff       	call   800e1f <fd2data>
  801050:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801052:	89 34 24             	mov    %esi,(%esp)
  801055:	e8 c5 fd ff ff       	call   800e1f <fd2data>
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80105f:	89 d8                	mov    %ebx,%eax
  801061:	c1 e8 16             	shr    $0x16,%eax
  801064:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80106b:	a8 01                	test   $0x1,%al
  80106d:	74 11                	je     801080 <dup+0x74>
  80106f:	89 d8                	mov    %ebx,%eax
  801071:	c1 e8 0c             	shr    $0xc,%eax
  801074:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80107b:	f6 c2 01             	test   $0x1,%dl
  80107e:	75 39                	jne    8010b9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801080:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	c1 e8 0c             	shr    $0xc,%eax
  801088:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108f:	83 ec 0c             	sub    $0xc,%esp
  801092:	25 07 0e 00 00       	and    $0xe07,%eax
  801097:	50                   	push   %eax
  801098:	56                   	push   %esi
  801099:	6a 00                	push   $0x0
  80109b:	52                   	push   %edx
  80109c:	6a 00                	push   $0x0
  80109e:	e8 9f fb ff ff       	call   800c42 <sys_page_map>
  8010a3:	89 c3                	mov    %eax,%ebx
  8010a5:	83 c4 20             	add    $0x20,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	78 31                	js     8010dd <dup+0xd1>
		goto err;

	return newfdnum;
  8010ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010af:	89 d8                	mov    %ebx,%eax
  8010b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c8:	50                   	push   %eax
  8010c9:	57                   	push   %edi
  8010ca:	6a 00                	push   $0x0
  8010cc:	53                   	push   %ebx
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 6e fb ff ff       	call   800c42 <sys_page_map>
  8010d4:	89 c3                	mov    %eax,%ebx
  8010d6:	83 c4 20             	add    $0x20,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	79 a3                	jns    801080 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	56                   	push   %esi
  8010e1:	6a 00                	push   $0x0
  8010e3:	e8 9c fb ff ff       	call   800c84 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010e8:	83 c4 08             	add    $0x8,%esp
  8010eb:	57                   	push   %edi
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 91 fb ff ff       	call   800c84 <sys_page_unmap>
	return r;
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	eb b7                	jmp    8010af <dup+0xa3>

008010f8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 1c             	sub    $0x1c,%esp
  8010ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801102:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801105:	50                   	push   %eax
  801106:	53                   	push   %ebx
  801107:	e8 7c fd ff ff       	call   800e88 <fd_lookup>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 3f                	js     801152 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801119:	50                   	push   %eax
  80111a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111d:	ff 30                	pushl  (%eax)
  80111f:	e8 b4 fd ff ff       	call   800ed8 <dev_lookup>
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 27                	js     801152 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80112b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112e:	8b 42 08             	mov    0x8(%edx),%eax
  801131:	83 e0 03             	and    $0x3,%eax
  801134:	83 f8 01             	cmp    $0x1,%eax
  801137:	74 1e                	je     801157 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113c:	8b 40 08             	mov    0x8(%eax),%eax
  80113f:	85 c0                	test   %eax,%eax
  801141:	74 35                	je     801178 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801143:	83 ec 04             	sub    $0x4,%esp
  801146:	ff 75 10             	pushl  0x10(%ebp)
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	52                   	push   %edx
  80114d:	ff d0                	call   *%eax
  80114f:	83 c4 10             	add    $0x10,%esp
}
  801152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801155:	c9                   	leave  
  801156:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801157:	a1 08 40 80 00       	mov    0x804008,%eax
  80115c:	8b 40 48             	mov    0x48(%eax),%eax
  80115f:	83 ec 04             	sub    $0x4,%esp
  801162:	53                   	push   %ebx
  801163:	50                   	push   %eax
  801164:	68 0d 27 80 00       	push   $0x80270d
  801169:	e8 c3 f0 ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801176:	eb da                	jmp    801152 <read+0x5a>
		return -E_NOT_SUPP;
  801178:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80117d:	eb d3                	jmp    801152 <read+0x5a>

0080117f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	53                   	push   %ebx
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	8b 7d 08             	mov    0x8(%ebp),%edi
  80118b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801193:	39 f3                	cmp    %esi,%ebx
  801195:	73 23                	jae    8011ba <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	89 f0                	mov    %esi,%eax
  80119c:	29 d8                	sub    %ebx,%eax
  80119e:	50                   	push   %eax
  80119f:	89 d8                	mov    %ebx,%eax
  8011a1:	03 45 0c             	add    0xc(%ebp),%eax
  8011a4:	50                   	push   %eax
  8011a5:	57                   	push   %edi
  8011a6:	e8 4d ff ff ff       	call   8010f8 <read>
		if (m < 0)
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 06                	js     8011b8 <readn+0x39>
			return m;
		if (m == 0)
  8011b2:	74 06                	je     8011ba <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8011b4:	01 c3                	add    %eax,%ebx
  8011b6:	eb db                	jmp    801193 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ba:	89 d8                	mov    %ebx,%eax
  8011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bf:	5b                   	pop    %ebx
  8011c0:	5e                   	pop    %esi
  8011c1:	5f                   	pop    %edi
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 1c             	sub    $0x1c,%esp
  8011cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	53                   	push   %ebx
  8011d3:	e8 b0 fc ff ff       	call   800e88 <fd_lookup>
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 3a                	js     801219 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e9:	ff 30                	pushl  (%eax)
  8011eb:	e8 e8 fc ff ff       	call   800ed8 <dev_lookup>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	78 22                	js     801219 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011fe:	74 1e                	je     80121e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801203:	8b 52 0c             	mov    0xc(%edx),%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	74 35                	je     80123f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	ff 75 10             	pushl  0x10(%ebp)
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	50                   	push   %eax
  801214:	ff d2                	call   *%edx
  801216:	83 c4 10             	add    $0x10,%esp
}
  801219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80121e:	a1 08 40 80 00       	mov    0x804008,%eax
  801223:	8b 40 48             	mov    0x48(%eax),%eax
  801226:	83 ec 04             	sub    $0x4,%esp
  801229:	53                   	push   %ebx
  80122a:	50                   	push   %eax
  80122b:	68 29 27 80 00       	push   $0x802729
  801230:	e8 fc ef ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123d:	eb da                	jmp    801219 <write+0x55>
		return -E_NOT_SUPP;
  80123f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801244:	eb d3                	jmp    801219 <write+0x55>

00801246 <seek>:

int
seek(int fdnum, off_t offset)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	ff 75 08             	pushl  0x8(%ebp)
  801253:	e8 30 fc ff ff       	call   800e88 <fd_lookup>
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 0e                	js     80126d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801265:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801268:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	53                   	push   %ebx
  801273:	83 ec 1c             	sub    $0x1c,%esp
  801276:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801279:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	53                   	push   %ebx
  80127e:	e8 05 fc ff ff       	call   800e88 <fd_lookup>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	78 37                	js     8012c1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801294:	ff 30                	pushl  (%eax)
  801296:	e8 3d fc ff ff       	call   800ed8 <dev_lookup>
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 1f                	js     8012c1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a9:	74 1b                	je     8012c6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ae:	8b 52 18             	mov    0x18(%edx),%edx
  8012b1:	85 d2                	test   %edx,%edx
  8012b3:	74 32                	je     8012e7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	ff 75 0c             	pushl  0xc(%ebp)
  8012bb:	50                   	push   %eax
  8012bc:	ff d2                	call   *%edx
  8012be:	83 c4 10             	add    $0x10,%esp
}
  8012c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012c6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012cb:	8b 40 48             	mov    0x48(%eax),%eax
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	53                   	push   %ebx
  8012d2:	50                   	push   %eax
  8012d3:	68 ec 26 80 00       	push   $0x8026ec
  8012d8:	e8 54 ef ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e5:	eb da                	jmp    8012c1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ec:	eb d3                	jmp    8012c1 <ftruncate+0x52>

008012ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 1c             	sub    $0x1c,%esp
  8012f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 08             	pushl  0x8(%ebp)
  8012ff:	e8 84 fb ff ff       	call   800e88 <fd_lookup>
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	85 c0                	test   %eax,%eax
  801309:	78 4b                	js     801356 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801315:	ff 30                	pushl  (%eax)
  801317:	e8 bc fb ff ff       	call   800ed8 <dev_lookup>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	78 33                	js     801356 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801326:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80132a:	74 2f                	je     80135b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80132c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80132f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801336:	00 00 00 
	stat->st_isdir = 0;
  801339:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801340:	00 00 00 
	stat->st_dev = dev;
  801343:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	53                   	push   %ebx
  80134d:	ff 75 f0             	pushl  -0x10(%ebp)
  801350:	ff 50 14             	call   *0x14(%eax)
  801353:	83 c4 10             	add    $0x10,%esp
}
  801356:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801359:	c9                   	leave  
  80135a:	c3                   	ret    
		return -E_NOT_SUPP;
  80135b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801360:	eb f4                	jmp    801356 <fstat+0x68>

00801362 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	6a 00                	push   $0x0
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 2f 02 00 00       	call   8015a3 <open>
  801374:	89 c3                	mov    %eax,%ebx
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 1b                	js     801398 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	ff 75 0c             	pushl  0xc(%ebp)
  801383:	50                   	push   %eax
  801384:	e8 65 ff ff ff       	call   8012ee <fstat>
  801389:	89 c6                	mov    %eax,%esi
	close(fd);
  80138b:	89 1c 24             	mov    %ebx,(%esp)
  80138e:	e8 27 fc ff ff       	call   800fba <close>
	return r;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	89 f3                	mov    %esi,%ebx
}
  801398:	89 d8                	mov    %ebx,%eax
  80139a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139d:	5b                   	pop    %ebx
  80139e:	5e                   	pop    %esi
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	89 c6                	mov    %eax,%esi
  8013a8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013aa:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013b1:	74 27                	je     8013da <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013b3:	6a 07                	push   $0x7
  8013b5:	68 00 50 80 00       	push   $0x805000
  8013ba:	56                   	push   %esi
  8013bb:	ff 35 00 40 80 00    	pushl  0x804000
  8013c1:	e8 1f 0c 00 00       	call   801fe5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013c6:	83 c4 0c             	add    $0xc,%esp
  8013c9:	6a 00                	push   $0x0
  8013cb:	53                   	push   %ebx
  8013cc:	6a 00                	push   $0x0
  8013ce:	e8 9f 0b 00 00       	call   801f72 <ipc_recv>
}
  8013d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	6a 01                	push   $0x1
  8013df:	e8 6d 0c 00 00       	call   802051 <ipc_find_env>
  8013e4:	a3 00 40 80 00       	mov    %eax,0x804000
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	eb c5                	jmp    8013b3 <fsipc+0x12>

008013ee <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8013fa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801407:	ba 00 00 00 00       	mov    $0x0,%edx
  80140c:	b8 02 00 00 00       	mov    $0x2,%eax
  801411:	e8 8b ff ff ff       	call   8013a1 <fsipc>
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <devfile_flush>:
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8b 40 0c             	mov    0xc(%eax),%eax
  801424:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801429:	ba 00 00 00 00       	mov    $0x0,%edx
  80142e:	b8 06 00 00 00       	mov    $0x6,%eax
  801433:	e8 69 ff ff ff       	call   8013a1 <fsipc>
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <devfile_stat>:
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 40 0c             	mov    0xc(%eax),%eax
  80144a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 05 00 00 00       	mov    $0x5,%eax
  801459:	e8 43 ff ff ff       	call   8013a1 <fsipc>
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 2c                	js     80148e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	68 00 50 80 00       	push   $0x805000
  80146a:	53                   	push   %ebx
  80146b:	e8 9d f3 ff ff       	call   80080d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801470:	a1 80 50 80 00       	mov    0x805080,%eax
  801475:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80147b:	a1 84 50 80 00       	mov    0x805084,%eax
  801480:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <devfile_write>:
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80149d:	85 db                	test   %ebx,%ebx
  80149f:	75 07                	jne    8014a8 <devfile_write+0x15>
	return n_all;
  8014a1:	89 d8                	mov    %ebx,%eax
}
  8014a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ae:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8014b3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	53                   	push   %ebx
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	68 08 50 80 00       	push   $0x805008
  8014c5:	e8 d1 f4 ff ff       	call   80099b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8014d4:	e8 c8 fe ff ff       	call   8013a1 <fsipc>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 c3                	js     8014a3 <devfile_write+0x10>
	  assert(r <= n_left);
  8014e0:	39 d8                	cmp    %ebx,%eax
  8014e2:	77 0b                	ja     8014ef <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8014e4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014e9:	7f 1d                	jg     801508 <devfile_write+0x75>
    n_all += r;
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	eb b2                	jmp    8014a1 <devfile_write+0xe>
	  assert(r <= n_left);
  8014ef:	68 5c 27 80 00       	push   $0x80275c
  8014f4:	68 68 27 80 00       	push   $0x802768
  8014f9:	68 9f 00 00 00       	push   $0x9f
  8014fe:	68 7d 27 80 00       	push   $0x80277d
  801503:	e8 4e ec ff ff       	call   800156 <_panic>
	  assert(r <= PGSIZE);
  801508:	68 88 27 80 00       	push   $0x802788
  80150d:	68 68 27 80 00       	push   $0x802768
  801512:	68 a0 00 00 00       	push   $0xa0
  801517:	68 7d 27 80 00       	push   $0x80277d
  80151c:	e8 35 ec ff ff       	call   800156 <_panic>

00801521 <devfile_read>:
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8b 40 0c             	mov    0xc(%eax),%eax
  80152f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801534:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	b8 03 00 00 00       	mov    $0x3,%eax
  801544:	e8 58 fe ff ff       	call   8013a1 <fsipc>
  801549:	89 c3                	mov    %eax,%ebx
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 1f                	js     80156e <devfile_read+0x4d>
	assert(r <= n);
  80154f:	39 f0                	cmp    %esi,%eax
  801551:	77 24                	ja     801577 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801553:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801558:	7f 33                	jg     80158d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	50                   	push   %eax
  80155e:	68 00 50 80 00       	push   $0x805000
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	e8 30 f4 ff ff       	call   80099b <memmove>
	return r;
  80156b:	83 c4 10             	add    $0x10,%esp
}
  80156e:	89 d8                	mov    %ebx,%eax
  801570:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    
	assert(r <= n);
  801577:	68 94 27 80 00       	push   $0x802794
  80157c:	68 68 27 80 00       	push   $0x802768
  801581:	6a 7c                	push   $0x7c
  801583:	68 7d 27 80 00       	push   $0x80277d
  801588:	e8 c9 eb ff ff       	call   800156 <_panic>
	assert(r <= PGSIZE);
  80158d:	68 88 27 80 00       	push   $0x802788
  801592:	68 68 27 80 00       	push   $0x802768
  801597:	6a 7d                	push   $0x7d
  801599:	68 7d 27 80 00       	push   $0x80277d
  80159e:	e8 b3 eb ff ff       	call   800156 <_panic>

008015a3 <open>:
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 1c             	sub    $0x1c,%esp
  8015ab:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ae:	56                   	push   %esi
  8015af:	e8 20 f2 ff ff       	call   8007d4 <strlen>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015bc:	7f 6c                	jg     80162a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c4:	50                   	push   %eax
  8015c5:	e8 6c f8 ff ff       	call   800e36 <fd_alloc>
  8015ca:	89 c3                	mov    %eax,%ebx
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 3c                	js     80160f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	56                   	push   %esi
  8015d7:	68 00 50 80 00       	push   $0x805000
  8015dc:	e8 2c f2 ff ff       	call   80080d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f1:	e8 ab fd ff ff       	call   8013a1 <fsipc>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 19                	js     801618 <open+0x75>
	return fd2num(fd);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	ff 75 f4             	pushl  -0xc(%ebp)
  801605:	e8 05 f8 ff ff       	call   800e0f <fd2num>
  80160a:	89 c3                	mov    %eax,%ebx
  80160c:	83 c4 10             	add    $0x10,%esp
}
  80160f:	89 d8                	mov    %ebx,%eax
  801611:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801614:	5b                   	pop    %ebx
  801615:	5e                   	pop    %esi
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		fd_close(fd, 0);
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	6a 00                	push   $0x0
  80161d:	ff 75 f4             	pushl  -0xc(%ebp)
  801620:	e8 0e f9 ff ff       	call   800f33 <fd_close>
		return r;
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	eb e5                	jmp    80160f <open+0x6c>
		return -E_BAD_PATH;
  80162a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80162f:	eb de                	jmp    80160f <open+0x6c>

00801631 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	b8 08 00 00 00       	mov    $0x8,%eax
  801641:	e8 5b fd ff ff       	call   8013a1 <fsipc>
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	e8 c4 f7 ff ff       	call   800e1f <fd2data>
  80165b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80165d:	83 c4 08             	add    $0x8,%esp
  801660:	68 9b 27 80 00       	push   $0x80279b
  801665:	53                   	push   %ebx
  801666:	e8 a2 f1 ff ff       	call   80080d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80166b:	8b 46 04             	mov    0x4(%esi),%eax
  80166e:	2b 06                	sub    (%esi),%eax
  801670:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801676:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80167d:	00 00 00 
	stat->st_dev = &devpipe;
  801680:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801687:	30 80 00 
	return 0;
}
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
  80168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 0c             	sub    $0xc,%esp
  80169d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016a0:	53                   	push   %ebx
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 dc f5 ff ff       	call   800c84 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016a8:	89 1c 24             	mov    %ebx,(%esp)
  8016ab:	e8 6f f7 ff ff       	call   800e1f <fd2data>
  8016b0:	83 c4 08             	add    $0x8,%esp
  8016b3:	50                   	push   %eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	e8 c9 f5 ff ff       	call   800c84 <sys_page_unmap>
}
  8016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <_pipeisclosed>:
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	57                   	push   %edi
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 1c             	sub    $0x1c,%esp
  8016c9:	89 c7                	mov    %eax,%edi
  8016cb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8016d2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	57                   	push   %edi
  8016d9:	e8 ac 09 00 00       	call   80208a <pageref>
  8016de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016e1:	89 34 24             	mov    %esi,(%esp)
  8016e4:	e8 a1 09 00 00       	call   80208a <pageref>
		nn = thisenv->env_runs;
  8016e9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016ef:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	39 cb                	cmp    %ecx,%ebx
  8016f7:	74 1b                	je     801714 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016fc:	75 cf                	jne    8016cd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016fe:	8b 42 58             	mov    0x58(%edx),%eax
  801701:	6a 01                	push   $0x1
  801703:	50                   	push   %eax
  801704:	53                   	push   %ebx
  801705:	68 a2 27 80 00       	push   $0x8027a2
  80170a:	e8 22 eb ff ff       	call   800231 <cprintf>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	eb b9                	jmp    8016cd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801714:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801717:	0f 94 c0             	sete   %al
  80171a:	0f b6 c0             	movzbl %al,%eax
}
  80171d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801720:	5b                   	pop    %ebx
  801721:	5e                   	pop    %esi
  801722:	5f                   	pop    %edi
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <devpipe_write>:
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	57                   	push   %edi
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
  80172b:	83 ec 28             	sub    $0x28,%esp
  80172e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801731:	56                   	push   %esi
  801732:	e8 e8 f6 ff ff       	call   800e1f <fd2data>
  801737:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	bf 00 00 00 00       	mov    $0x0,%edi
  801741:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801744:	74 4f                	je     801795 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801746:	8b 43 04             	mov    0x4(%ebx),%eax
  801749:	8b 0b                	mov    (%ebx),%ecx
  80174b:	8d 51 20             	lea    0x20(%ecx),%edx
  80174e:	39 d0                	cmp    %edx,%eax
  801750:	72 14                	jb     801766 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801752:	89 da                	mov    %ebx,%edx
  801754:	89 f0                	mov    %esi,%eax
  801756:	e8 65 ff ff ff       	call   8016c0 <_pipeisclosed>
  80175b:	85 c0                	test   %eax,%eax
  80175d:	75 3b                	jne    80179a <devpipe_write+0x75>
			sys_yield();
  80175f:	e8 7c f4 ff ff       	call   800be0 <sys_yield>
  801764:	eb e0                	jmp    801746 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801769:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80176d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801770:	89 c2                	mov    %eax,%edx
  801772:	c1 fa 1f             	sar    $0x1f,%edx
  801775:	89 d1                	mov    %edx,%ecx
  801777:	c1 e9 1b             	shr    $0x1b,%ecx
  80177a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80177d:	83 e2 1f             	and    $0x1f,%edx
  801780:	29 ca                	sub    %ecx,%edx
  801782:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801786:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80178a:	83 c0 01             	add    $0x1,%eax
  80178d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801790:	83 c7 01             	add    $0x1,%edi
  801793:	eb ac                	jmp    801741 <devpipe_write+0x1c>
	return i;
  801795:	8b 45 10             	mov    0x10(%ebp),%eax
  801798:	eb 05                	jmp    80179f <devpipe_write+0x7a>
				return 0;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5f                   	pop    %edi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <devpipe_read>:
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	57                   	push   %edi
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 18             	sub    $0x18,%esp
  8017b0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017b3:	57                   	push   %edi
  8017b4:	e8 66 f6 ff ff       	call   800e1f <fd2data>
  8017b9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	be 00 00 00 00       	mov    $0x0,%esi
  8017c3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017c6:	75 14                	jne    8017dc <devpipe_read+0x35>
	return i;
  8017c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cb:	eb 02                	jmp    8017cf <devpipe_read+0x28>
				return i;
  8017cd:	89 f0                	mov    %esi,%eax
}
  8017cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d2:	5b                   	pop    %ebx
  8017d3:	5e                   	pop    %esi
  8017d4:	5f                   	pop    %edi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    
			sys_yield();
  8017d7:	e8 04 f4 ff ff       	call   800be0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017dc:	8b 03                	mov    (%ebx),%eax
  8017de:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017e1:	75 18                	jne    8017fb <devpipe_read+0x54>
			if (i > 0)
  8017e3:	85 f6                	test   %esi,%esi
  8017e5:	75 e6                	jne    8017cd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8017e7:	89 da                	mov    %ebx,%edx
  8017e9:	89 f8                	mov    %edi,%eax
  8017eb:	e8 d0 fe ff ff       	call   8016c0 <_pipeisclosed>
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	74 e3                	je     8017d7 <devpipe_read+0x30>
				return 0;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb d4                	jmp    8017cf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017fb:	99                   	cltd   
  8017fc:	c1 ea 1b             	shr    $0x1b,%edx
  8017ff:	01 d0                	add    %edx,%eax
  801801:	83 e0 1f             	and    $0x1f,%eax
  801804:	29 d0                	sub    %edx,%eax
  801806:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80180b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801811:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801814:	83 c6 01             	add    $0x1,%esi
  801817:	eb aa                	jmp    8017c3 <devpipe_read+0x1c>

00801819 <pipe>:
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801824:	50                   	push   %eax
  801825:	e8 0c f6 ff ff       	call   800e36 <fd_alloc>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	0f 88 23 01 00 00    	js     80195a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	68 07 04 00 00       	push   $0x407
  80183f:	ff 75 f4             	pushl  -0xc(%ebp)
  801842:	6a 00                	push   $0x0
  801844:	e8 b6 f3 ff ff       	call   800bff <sys_page_alloc>
  801849:	89 c3                	mov    %eax,%ebx
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	0f 88 04 01 00 00    	js     80195a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	e8 d4 f5 ff ff       	call   800e36 <fd_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	0f 88 db 00 00 00    	js     80194a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	68 07 04 00 00       	push   $0x407
  801877:	ff 75 f0             	pushl  -0x10(%ebp)
  80187a:	6a 00                	push   $0x0
  80187c:	e8 7e f3 ff ff       	call   800bff <sys_page_alloc>
  801881:	89 c3                	mov    %eax,%ebx
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	85 c0                	test   %eax,%eax
  801888:	0f 88 bc 00 00 00    	js     80194a <pipe+0x131>
	va = fd2data(fd0);
  80188e:	83 ec 0c             	sub    $0xc,%esp
  801891:	ff 75 f4             	pushl  -0xc(%ebp)
  801894:	e8 86 f5 ff ff       	call   800e1f <fd2data>
  801899:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80189b:	83 c4 0c             	add    $0xc,%esp
  80189e:	68 07 04 00 00       	push   $0x407
  8018a3:	50                   	push   %eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	e8 54 f3 ff ff       	call   800bff <sys_page_alloc>
  8018ab:	89 c3                	mov    %eax,%ebx
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	0f 88 82 00 00 00    	js     80193a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b8:	83 ec 0c             	sub    $0xc,%esp
  8018bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8018be:	e8 5c f5 ff ff       	call   800e1f <fd2data>
  8018c3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018ca:	50                   	push   %eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	56                   	push   %esi
  8018ce:	6a 00                	push   $0x0
  8018d0:	e8 6d f3 ff ff       	call   800c42 <sys_page_map>
  8018d5:	89 c3                	mov    %eax,%ebx
  8018d7:	83 c4 20             	add    $0x20,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 4e                	js     80192c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8018de:	a1 20 30 80 00       	mov    0x803020,%eax
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018eb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	ff 75 f4             	pushl  -0xc(%ebp)
  801907:	e8 03 f5 ff ff       	call   800e0f <fd2num>
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801911:	83 c4 04             	add    $0x4,%esp
  801914:	ff 75 f0             	pushl  -0x10(%ebp)
  801917:	e8 f3 f4 ff ff       	call   800e0f <fd2num>
  80191c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80191f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	bb 00 00 00 00       	mov    $0x0,%ebx
  80192a:	eb 2e                	jmp    80195a <pipe+0x141>
	sys_page_unmap(0, va);
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	56                   	push   %esi
  801930:	6a 00                	push   $0x0
  801932:	e8 4d f3 ff ff       	call   800c84 <sys_page_unmap>
  801937:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	ff 75 f0             	pushl  -0x10(%ebp)
  801940:	6a 00                	push   $0x0
  801942:	e8 3d f3 ff ff       	call   800c84 <sys_page_unmap>
  801947:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80194a:	83 ec 08             	sub    $0x8,%esp
  80194d:	ff 75 f4             	pushl  -0xc(%ebp)
  801950:	6a 00                	push   $0x0
  801952:	e8 2d f3 ff ff       	call   800c84 <sys_page_unmap>
  801957:	83 c4 10             	add    $0x10,%esp
}
  80195a:	89 d8                	mov    %ebx,%eax
  80195c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195f:	5b                   	pop    %ebx
  801960:	5e                   	pop    %esi
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <pipeisclosed>:
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801969:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196c:	50                   	push   %eax
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	e8 13 f5 ff ff       	call   800e88 <fd_lookup>
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 18                	js     801994 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	ff 75 f4             	pushl  -0xc(%ebp)
  801982:	e8 98 f4 ff ff       	call   800e1f <fd2data>
	return _pipeisclosed(fd, p);
  801987:	89 c2                	mov    %eax,%edx
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	e8 2f fd ff ff       	call   8016c0 <_pipeisclosed>
  801991:	83 c4 10             	add    $0x10,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80199c:	68 ba 27 80 00       	push   $0x8027ba
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	e8 64 ee ff ff       	call   80080d <strcpy>
	return 0;
}
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devsock_close>:
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 10             	sub    $0x10,%esp
  8019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019ba:	53                   	push   %ebx
  8019bb:	e8 ca 06 00 00       	call   80208a <pageref>
  8019c0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019c8:	83 f8 01             	cmp    $0x1,%eax
  8019cb:	74 07                	je     8019d4 <devsock_close+0x24>
}
  8019cd:	89 d0                	mov    %edx,%eax
  8019cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	ff 73 0c             	pushl  0xc(%ebx)
  8019da:	e8 b9 02 00 00       	call   801c98 <nsipc_close>
  8019df:	89 c2                	mov    %eax,%edx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	eb e7                	jmp    8019cd <devsock_close+0x1d>

008019e6 <devsock_write>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 10             	pushl  0x10(%ebp)
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	ff 70 0c             	pushl  0xc(%eax)
  8019fa:	e8 76 03 00 00       	call   801d75 <nsipc_send>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <devsock_read>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 10             	pushl  0x10(%ebp)
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	ff 70 0c             	pushl  0xc(%eax)
  801a15:	e8 ef 02 00 00       	call   801d09 <nsipc_recv>
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <fd2sockid>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a22:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	e8 5c f4 ff ff       	call   800e88 <fd_lookup>
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 10                	js     801a43 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a3c:	39 08                	cmp    %ecx,(%eax)
  801a3e:	75 05                	jne    801a45 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a40:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    
		return -E_NOT_SUPP;
  801a45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4a:	eb f7                	jmp    801a43 <fd2sockid+0x27>

00801a4c <alloc_sockfd>:
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	83 ec 1c             	sub    $0x1c,%esp
  801a54:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a59:	50                   	push   %eax
  801a5a:	e8 d7 f3 ff ff       	call   800e36 <fd_alloc>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 43                	js     801aab <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	68 07 04 00 00       	push   $0x407
  801a70:	ff 75 f4             	pushl  -0xc(%ebp)
  801a73:	6a 00                	push   $0x0
  801a75:	e8 85 f1 ff ff       	call   800bff <sys_page_alloc>
  801a7a:	89 c3                	mov    %eax,%ebx
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 28                	js     801aab <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a98:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a9b:	83 ec 0c             	sub    $0xc,%esp
  801a9e:	50                   	push   %eax
  801a9f:	e8 6b f3 ff ff       	call   800e0f <fd2num>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	eb 0c                	jmp    801ab7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801aab:	83 ec 0c             	sub    $0xc,%esp
  801aae:	56                   	push   %esi
  801aaf:	e8 e4 01 00 00       	call   801c98 <nsipc_close>
		return r;
  801ab4:	83 c4 10             	add    $0x10,%esp
}
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    

00801ac0 <accept>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	e8 4e ff ff ff       	call   801a1c <fd2sockid>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 1b                	js     801aed <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	e8 0e 01 00 00       	call   801bef <nsipc_accept>
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 05                	js     801aed <accept+0x2d>
	return alloc_sockfd(r);
  801ae8:	e8 5f ff ff ff       	call   801a4c <alloc_sockfd>
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <bind>:
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	e8 1f ff ff ff       	call   801a1c <fd2sockid>
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 12                	js     801b13 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b01:	83 ec 04             	sub    $0x4,%esp
  801b04:	ff 75 10             	pushl  0x10(%ebp)
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	50                   	push   %eax
  801b0b:	e8 31 01 00 00       	call   801c41 <nsipc_bind>
  801b10:	83 c4 10             	add    $0x10,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <shutdown>:
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	e8 f9 fe ff ff       	call   801a1c <fd2sockid>
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 0f                	js     801b36 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	50                   	push   %eax
  801b2e:	e8 43 01 00 00       	call   801c76 <nsipc_shutdown>
  801b33:	83 c4 10             	add    $0x10,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <connect>:
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	e8 d6 fe ff ff       	call   801a1c <fd2sockid>
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 12                	js     801b5c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	e8 59 01 00 00       	call   801cb2 <nsipc_connect>
  801b59:	83 c4 10             	add    $0x10,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <listen>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	e8 b0 fe ff ff       	call   801a1c <fd2sockid>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 0f                	js     801b7f <listen+0x21>
	return nsipc_listen(r, backlog);
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	50                   	push   %eax
  801b77:	e8 6b 01 00 00       	call   801ce7 <nsipc_listen>
  801b7c:	83 c4 10             	add    $0x10,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b87:	ff 75 10             	pushl  0x10(%ebp)
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	e8 3e 02 00 00       	call   801dd3 <nsipc_socket>
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 05                	js     801ba1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b9c:	e8 ab fe ff ff       	call   801a4c <alloc_sockfd>
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bb3:	74 26                	je     801bdb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bb5:	6a 07                	push   $0x7
  801bb7:	68 00 60 80 00       	push   $0x806000
  801bbc:	53                   	push   %ebx
  801bbd:	ff 35 04 40 80 00    	pushl  0x804004
  801bc3:	e8 1d 04 00 00       	call   801fe5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bc8:	83 c4 0c             	add    $0xc,%esp
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	e8 9c 03 00 00       	call   801f72 <ipc_recv>
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bdb:	83 ec 0c             	sub    $0xc,%esp
  801bde:	6a 02                	push   $0x2
  801be0:	e8 6c 04 00 00       	call   802051 <ipc_find_env>
  801be5:	a3 04 40 80 00       	mov    %eax,0x804004
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	eb c6                	jmp    801bb5 <nsipc+0x12>

00801bef <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bff:	8b 06                	mov    (%esi),%eax
  801c01:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	e8 93 ff ff ff       	call   801ba3 <nsipc>
  801c10:	89 c3                	mov    %eax,%ebx
  801c12:	85 c0                	test   %eax,%eax
  801c14:	79 09                	jns    801c1f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c16:	89 d8                	mov    %ebx,%eax
  801c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	ff 35 10 60 80 00    	pushl  0x806010
  801c28:	68 00 60 80 00       	push   $0x806000
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	e8 66 ed ff ff       	call   80099b <memmove>
		*addrlen = ret->ret_addrlen;
  801c35:	a1 10 60 80 00       	mov    0x806010,%eax
  801c3a:	89 06                	mov    %eax,(%esi)
  801c3c:	83 c4 10             	add    $0x10,%esp
	return r;
  801c3f:	eb d5                	jmp    801c16 <nsipc_accept+0x27>

00801c41 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c53:	53                   	push   %ebx
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	68 04 60 80 00       	push   $0x806004
  801c5c:	e8 3a ed ff ff       	call   80099b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c61:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c67:	b8 02 00 00 00       	mov    $0x2,%eax
  801c6c:	e8 32 ff ff ff       	call   801ba3 <nsipc>
}
  801c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c91:	e8 0d ff ff ff       	call   801ba3 <nsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <nsipc_close>:

int
nsipc_close(int s)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ca6:	b8 04 00 00 00       	mov    $0x4,%eax
  801cab:	e8 f3 fe ff ff       	call   801ba3 <nsipc>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	53                   	push   %ebx
  801cb6:	83 ec 08             	sub    $0x8,%esp
  801cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cc4:	53                   	push   %ebx
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	68 04 60 80 00       	push   $0x806004
  801ccd:	e8 c9 ec ff ff       	call   80099b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cd2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cd8:	b8 05 00 00 00       	mov    $0x5,%eax
  801cdd:	e8 c1 fe ff ff       	call   801ba3 <nsipc>
}
  801ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  801d02:	e8 9c fe ff ff       	call   801ba3 <nsipc>
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	56                   	push   %esi
  801d0d:	53                   	push   %ebx
  801d0e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d19:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d22:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d27:	b8 07 00 00 00       	mov    $0x7,%eax
  801d2c:	e8 72 fe ff ff       	call   801ba3 <nsipc>
  801d31:	89 c3                	mov    %eax,%ebx
  801d33:	85 c0                	test   %eax,%eax
  801d35:	78 1f                	js     801d56 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d37:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d3c:	7f 21                	jg     801d5f <nsipc_recv+0x56>
  801d3e:	39 c6                	cmp    %eax,%esi
  801d40:	7c 1d                	jl     801d5f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	50                   	push   %eax
  801d46:	68 00 60 80 00       	push   $0x806000
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	e8 48 ec ff ff       	call   80099b <memmove>
  801d53:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d56:	89 d8                	mov    %ebx,%eax
  801d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d5f:	68 c6 27 80 00       	push   $0x8027c6
  801d64:	68 68 27 80 00       	push   $0x802768
  801d69:	6a 62                	push   $0x62
  801d6b:	68 db 27 80 00       	push   $0x8027db
  801d70:	e8 e1 e3 ff ff       	call   800156 <_panic>

00801d75 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	53                   	push   %ebx
  801d79:	83 ec 04             	sub    $0x4,%esp
  801d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d87:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d8d:	7f 2e                	jg     801dbd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	53                   	push   %ebx
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	68 0c 60 80 00       	push   $0x80600c
  801d9b:	e8 fb eb ff ff       	call   80099b <memmove>
	nsipcbuf.send.req_size = size;
  801da0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801da6:	8b 45 14             	mov    0x14(%ebp),%eax
  801da9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dae:	b8 08 00 00 00       	mov    $0x8,%eax
  801db3:	e8 eb fd ff ff       	call   801ba3 <nsipc>
}
  801db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    
	assert(size < 1600);
  801dbd:	68 e7 27 80 00       	push   $0x8027e7
  801dc2:	68 68 27 80 00       	push   $0x802768
  801dc7:	6a 6d                	push   $0x6d
  801dc9:	68 db 27 80 00       	push   $0x8027db
  801dce:	e8 83 e3 ff ff       	call   800156 <_panic>

00801dd3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801de9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dec:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801df1:	b8 09 00 00 00       	mov    $0x9,%eax
  801df6:	e8 a8 fd ff ff       	call   801ba3 <nsipc>
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	c3                   	ret    

00801e03 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e09:	68 f3 27 80 00       	push   $0x8027f3
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	e8 f7 e9 ff ff       	call   80080d <strcpy>
	return 0;
}
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <devcons_write>:
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	57                   	push   %edi
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e29:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e2e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e34:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e37:	73 31                	jae    801e6a <devcons_write+0x4d>
		m = n - tot;
  801e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e3c:	29 f3                	sub    %esi,%ebx
  801e3e:	83 fb 7f             	cmp    $0x7f,%ebx
  801e41:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e46:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	53                   	push   %ebx
  801e4d:	89 f0                	mov    %esi,%eax
  801e4f:	03 45 0c             	add    0xc(%ebp),%eax
  801e52:	50                   	push   %eax
  801e53:	57                   	push   %edi
  801e54:	e8 42 eb ff ff       	call   80099b <memmove>
		sys_cputs(buf, m);
  801e59:	83 c4 08             	add    $0x8,%esp
  801e5c:	53                   	push   %ebx
  801e5d:	57                   	push   %edi
  801e5e:	e8 e0 ec ff ff       	call   800b43 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e63:	01 de                	add    %ebx,%esi
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	eb ca                	jmp    801e34 <devcons_write+0x17>
}
  801e6a:	89 f0                	mov    %esi,%eax
  801e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    

00801e74 <devcons_read>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e83:	74 21                	je     801ea6 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801e85:	e8 d7 ec ff ff       	call   800b61 <sys_cgetc>
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	75 07                	jne    801e95 <devcons_read+0x21>
		sys_yield();
  801e8e:	e8 4d ed ff ff       	call   800be0 <sys_yield>
  801e93:	eb f0                	jmp    801e85 <devcons_read+0x11>
	if (c < 0)
  801e95:	78 0f                	js     801ea6 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801e97:	83 f8 04             	cmp    $0x4,%eax
  801e9a:	74 0c                	je     801ea8 <devcons_read+0x34>
	*(char*)vbuf = c;
  801e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9f:	88 02                	mov    %al,(%edx)
	return 1;
  801ea1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    
		return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	eb f7                	jmp    801ea6 <devcons_read+0x32>

00801eaf <cputchar>:
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ebb:	6a 01                	push   $0x1
  801ebd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	e8 7d ec ff ff       	call   800b43 <sys_cputs>
}
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <getchar>:
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ed1:	6a 01                	push   $0x1
  801ed3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ed6:	50                   	push   %eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 1a f2 ff ff       	call   8010f8 <read>
	if (r < 0)
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 06                	js     801eeb <getchar+0x20>
	if (r < 1)
  801ee5:	74 06                	je     801eed <getchar+0x22>
	return c;
  801ee7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    
		return -E_EOF;
  801eed:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef2:	eb f7                	jmp    801eeb <getchar+0x20>

00801ef4 <iscons>:
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801efa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801efd:	50                   	push   %eax
  801efe:	ff 75 08             	pushl  0x8(%ebp)
  801f01:	e8 82 ef ff ff       	call   800e88 <fd_lookup>
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 11                	js     801f1e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f16:	39 10                	cmp    %edx,(%eax)
  801f18:	0f 94 c0             	sete   %al
  801f1b:	0f b6 c0             	movzbl %al,%eax
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <opencons>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f29:	50                   	push   %eax
  801f2a:	e8 07 ef ff ff       	call   800e36 <fd_alloc>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 3a                	js     801f70 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	68 07 04 00 00       	push   $0x407
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	6a 00                	push   $0x0
  801f43:	e8 b7 ec ff ff       	call   800bff <sys_page_alloc>
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 21                	js     801f70 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f58:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	50                   	push   %eax
  801f68:	e8 a2 ee ff ff       	call   800e0f <fd2num>
  801f6d:	83 c4 10             	add    $0x10,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	56                   	push   %esi
  801f76:	53                   	push   %ebx
  801f77:	8b 75 08             	mov    0x8(%ebp),%esi
  801f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f80:	85 c0                	test   %eax,%eax
  801f82:	74 4f                	je     801fd3 <ipc_recv+0x61>
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	50                   	push   %eax
  801f88:	e8 22 ee ff ff       	call   800daf <sys_ipc_recv>
  801f8d:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f90:	85 f6                	test   %esi,%esi
  801f92:	74 14                	je     801fa8 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f94:	ba 00 00 00 00       	mov    $0x0,%edx
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 09                	jne    801fa6 <ipc_recv+0x34>
  801f9d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fa3:	8b 52 74             	mov    0x74(%edx),%edx
  801fa6:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801fa8:	85 db                	test   %ebx,%ebx
  801faa:	74 14                	je     801fc0 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	75 09                	jne    801fbe <ipc_recv+0x4c>
  801fb5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fbb:	8b 52 78             	mov    0x78(%edx),%edx
  801fbe:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	75 08                	jne    801fcc <ipc_recv+0x5a>
  801fc4:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc9:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5d                   	pop    %ebp
  801fd2:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 00 00 c0 ee       	push   $0xeec00000
  801fdb:	e8 cf ed ff ff       	call   800daf <sys_ipc_recv>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	eb ab                	jmp    801f90 <ipc_recv+0x1e>

00801fe5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	57                   	push   %edi
  801fe9:	56                   	push   %esi
  801fea:	53                   	push   %ebx
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ff1:	8b 75 10             	mov    0x10(%ebp),%esi
  801ff4:	eb 20                	jmp    802016 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801ff6:	6a 00                	push   $0x0
  801ff8:	68 00 00 c0 ee       	push   $0xeec00000
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	57                   	push   %edi
  802001:	e8 86 ed ff ff       	call   800d8c <sys_ipc_try_send>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	eb 1f                	jmp    80202c <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80200d:	e8 ce eb ff ff       	call   800be0 <sys_yield>
	while(retval != 0) {
  802012:	85 db                	test   %ebx,%ebx
  802014:	74 33                	je     802049 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802016:	85 f6                	test   %esi,%esi
  802018:	74 dc                	je     801ff6 <ipc_send+0x11>
  80201a:	ff 75 14             	pushl  0x14(%ebp)
  80201d:	56                   	push   %esi
  80201e:	ff 75 0c             	pushl  0xc(%ebp)
  802021:	57                   	push   %edi
  802022:	e8 65 ed ff ff       	call   800d8c <sys_ipc_try_send>
  802027:	89 c3                	mov    %eax,%ebx
  802029:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80202c:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80202f:	74 dc                	je     80200d <ipc_send+0x28>
  802031:	85 db                	test   %ebx,%ebx
  802033:	74 d8                	je     80200d <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	68 00 28 80 00       	push   $0x802800
  80203d:	6a 35                	push   $0x35
  80203f:	68 30 28 80 00       	push   $0x802830
  802044:	e8 0d e1 ff ff       	call   800156 <_panic>
	}
}
  802049:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80205c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802065:	8b 52 50             	mov    0x50(%edx),%edx
  802068:	39 ca                	cmp    %ecx,%edx
  80206a:	74 11                	je     80207d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80206c:	83 c0 01             	add    $0x1,%eax
  80206f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802074:	75 e6                	jne    80205c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	eb 0b                	jmp    802088 <ipc_find_env+0x37>
			return envs[i].env_id;
  80207d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802085:	8b 40 48             	mov    0x48(%eax),%eax
}
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802090:	89 d0                	mov    %edx,%eax
  802092:	c1 e8 16             	shr    $0x16,%eax
  802095:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a1:	f6 c1 01             	test   $0x1,%cl
  8020a4:	74 1d                	je     8020c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a6:	c1 ea 0c             	shr    $0xc,%edx
  8020a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020b0:	f6 c2 01             	test   $0x1,%dl
  8020b3:	74 0e                	je     8020c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b5:	c1 ea 0c             	shr    $0xc,%edx
  8020b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020bf:	ef 
  8020c0:	0f b7 c0             	movzwl %ax,%eax
}
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    
  8020c5:	66 90                	xchg   %ax,%ax
  8020c7:	66 90                	xchg   %ax,%ax
  8020c9:	66 90                	xchg   %ax,%ax
  8020cb:	66 90                	xchg   %ax,%ax
  8020cd:	66 90                	xchg   %ax,%ax
  8020cf:	90                   	nop

008020d0 <__udivdi3>:
  8020d0:	f3 0f 1e fb          	endbr32 
  8020d4:	55                   	push   %ebp
  8020d5:	57                   	push   %edi
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	83 ec 1c             	sub    $0x1c,%esp
  8020db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020eb:	85 d2                	test   %edx,%edx
  8020ed:	75 49                	jne    802138 <__udivdi3+0x68>
  8020ef:	39 f3                	cmp    %esi,%ebx
  8020f1:	76 15                	jbe    802108 <__udivdi3+0x38>
  8020f3:	31 ff                	xor    %edi,%edi
  8020f5:	89 e8                	mov    %ebp,%eax
  8020f7:	89 f2                	mov    %esi,%edx
  8020f9:	f7 f3                	div    %ebx
  8020fb:	89 fa                	mov    %edi,%edx
  8020fd:	83 c4 1c             	add    $0x1c,%esp
  802100:	5b                   	pop    %ebx
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
  802105:	8d 76 00             	lea    0x0(%esi),%esi
  802108:	89 d9                	mov    %ebx,%ecx
  80210a:	85 db                	test   %ebx,%ebx
  80210c:	75 0b                	jne    802119 <__udivdi3+0x49>
  80210e:	b8 01 00 00 00       	mov    $0x1,%eax
  802113:	31 d2                	xor    %edx,%edx
  802115:	f7 f3                	div    %ebx
  802117:	89 c1                	mov    %eax,%ecx
  802119:	31 d2                	xor    %edx,%edx
  80211b:	89 f0                	mov    %esi,%eax
  80211d:	f7 f1                	div    %ecx
  80211f:	89 c6                	mov    %eax,%esi
  802121:	89 e8                	mov    %ebp,%eax
  802123:	89 f7                	mov    %esi,%edi
  802125:	f7 f1                	div    %ecx
  802127:	89 fa                	mov    %edi,%edx
  802129:	83 c4 1c             	add    $0x1c,%esp
  80212c:	5b                   	pop    %ebx
  80212d:	5e                   	pop    %esi
  80212e:	5f                   	pop    %edi
  80212f:	5d                   	pop    %ebp
  802130:	c3                   	ret    
  802131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802138:	39 f2                	cmp    %esi,%edx
  80213a:	77 1c                	ja     802158 <__udivdi3+0x88>
  80213c:	0f bd fa             	bsr    %edx,%edi
  80213f:	83 f7 1f             	xor    $0x1f,%edi
  802142:	75 2c                	jne    802170 <__udivdi3+0xa0>
  802144:	39 f2                	cmp    %esi,%edx
  802146:	72 06                	jb     80214e <__udivdi3+0x7e>
  802148:	31 c0                	xor    %eax,%eax
  80214a:	39 eb                	cmp    %ebp,%ebx
  80214c:	77 ad                	ja     8020fb <__udivdi3+0x2b>
  80214e:	b8 01 00 00 00       	mov    $0x1,%eax
  802153:	eb a6                	jmp    8020fb <__udivdi3+0x2b>
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 c0                	xor    %eax,%eax
  80215c:	89 fa                	mov    %edi,%edx
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
  802166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80216d:	8d 76 00             	lea    0x0(%esi),%esi
  802170:	89 f9                	mov    %edi,%ecx
  802172:	b8 20 00 00 00       	mov    $0x20,%eax
  802177:	29 f8                	sub    %edi,%eax
  802179:	d3 e2                	shl    %cl,%edx
  80217b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	89 da                	mov    %ebx,%edx
  802183:	d3 ea                	shr    %cl,%edx
  802185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802189:	09 d1                	or     %edx,%ecx
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802191:	89 f9                	mov    %edi,%ecx
  802193:	d3 e3                	shl    %cl,%ebx
  802195:	89 c1                	mov    %eax,%ecx
  802197:	d3 ea                	shr    %cl,%edx
  802199:	89 f9                	mov    %edi,%ecx
  80219b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80219f:	89 eb                	mov    %ebp,%ebx
  8021a1:	d3 e6                	shl    %cl,%esi
  8021a3:	89 c1                	mov    %eax,%ecx
  8021a5:	d3 eb                	shr    %cl,%ebx
  8021a7:	09 de                	or     %ebx,%esi
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	f7 74 24 08          	divl   0x8(%esp)
  8021af:	89 d6                	mov    %edx,%esi
  8021b1:	89 c3                	mov    %eax,%ebx
  8021b3:	f7 64 24 0c          	mull   0xc(%esp)
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 15                	jb     8021d0 <__udivdi3+0x100>
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e5                	shl    %cl,%ebp
  8021bf:	39 c5                	cmp    %eax,%ebp
  8021c1:	73 04                	jae    8021c7 <__udivdi3+0xf7>
  8021c3:	39 d6                	cmp    %edx,%esi
  8021c5:	74 09                	je     8021d0 <__udivdi3+0x100>
  8021c7:	89 d8                	mov    %ebx,%eax
  8021c9:	31 ff                	xor    %edi,%edi
  8021cb:	e9 2b ff ff ff       	jmp    8020fb <__udivdi3+0x2b>
  8021d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d3:	31 ff                	xor    %edi,%edi
  8021d5:	e9 21 ff ff ff       	jmp    8020fb <__udivdi3+0x2b>
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__umoddi3>:
  8021e0:	f3 0f 1e fb          	endbr32 
  8021e4:	55                   	push   %ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 1c             	sub    $0x1c,%esp
  8021eb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021f3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	89 da                	mov    %ebx,%edx
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	75 3f                	jne    802240 <__umoddi3+0x60>
  802201:	39 df                	cmp    %ebx,%edi
  802203:	76 13                	jbe    802218 <__umoddi3+0x38>
  802205:	89 f0                	mov    %esi,%eax
  802207:	f7 f7                	div    %edi
  802209:	89 d0                	mov    %edx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	83 c4 1c             	add    $0x1c,%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	89 fd                	mov    %edi,%ebp
  80221a:	85 ff                	test   %edi,%edi
  80221c:	75 0b                	jne    802229 <__umoddi3+0x49>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c5                	mov    %eax,%ebp
  802229:	89 d8                	mov    %ebx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f5                	div    %ebp
  80222f:	89 f0                	mov    %esi,%eax
  802231:	f7 f5                	div    %ebp
  802233:	89 d0                	mov    %edx,%eax
  802235:	eb d4                	jmp    80220b <__umoddi3+0x2b>
  802237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223e:	66 90                	xchg   %ax,%ax
  802240:	89 f1                	mov    %esi,%ecx
  802242:	39 d8                	cmp    %ebx,%eax
  802244:	76 0a                	jbe    802250 <__umoddi3+0x70>
  802246:	89 f0                	mov    %esi,%eax
  802248:	83 c4 1c             	add    $0x1c,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    
  802250:	0f bd e8             	bsr    %eax,%ebp
  802253:	83 f5 1f             	xor    $0x1f,%ebp
  802256:	75 20                	jne    802278 <__umoddi3+0x98>
  802258:	39 d8                	cmp    %ebx,%eax
  80225a:	0f 82 b0 00 00 00    	jb     802310 <__umoddi3+0x130>
  802260:	39 f7                	cmp    %esi,%edi
  802262:	0f 86 a8 00 00 00    	jbe    802310 <__umoddi3+0x130>
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	83 c4 1c             	add    $0x1c,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
  802272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802278:	89 e9                	mov    %ebp,%ecx
  80227a:	ba 20 00 00 00       	mov    $0x20,%edx
  80227f:	29 ea                	sub    %ebp,%edx
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 44 24 08          	mov    %eax,0x8(%esp)
  802287:	89 d1                	mov    %edx,%ecx
  802289:	89 f8                	mov    %edi,%eax
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802291:	89 54 24 04          	mov    %edx,0x4(%esp)
  802295:	8b 54 24 04          	mov    0x4(%esp),%edx
  802299:	09 c1                	or     %eax,%ecx
  80229b:	89 d8                	mov    %ebx,%eax
  80229d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a1:	89 e9                	mov    %ebp,%ecx
  8022a3:	d3 e7                	shl    %cl,%edi
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022af:	d3 e3                	shl    %cl,%ebx
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	89 d1                	mov    %edx,%ecx
  8022b5:	89 f0                	mov    %esi,%eax
  8022b7:	d3 e8                	shr    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	89 fa                	mov    %edi,%edx
  8022bd:	d3 e6                	shl    %cl,%esi
  8022bf:	09 d8                	or     %ebx,%eax
  8022c1:	f7 74 24 08          	divl   0x8(%esp)
  8022c5:	89 d1                	mov    %edx,%ecx
  8022c7:	89 f3                	mov    %esi,%ebx
  8022c9:	f7 64 24 0c          	mull   0xc(%esp)
  8022cd:	89 c6                	mov    %eax,%esi
  8022cf:	89 d7                	mov    %edx,%edi
  8022d1:	39 d1                	cmp    %edx,%ecx
  8022d3:	72 06                	jb     8022db <__umoddi3+0xfb>
  8022d5:	75 10                	jne    8022e7 <__umoddi3+0x107>
  8022d7:	39 c3                	cmp    %eax,%ebx
  8022d9:	73 0c                	jae    8022e7 <__umoddi3+0x107>
  8022db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022e3:	89 d7                	mov    %edx,%edi
  8022e5:	89 c6                	mov    %eax,%esi
  8022e7:	89 ca                	mov    %ecx,%edx
  8022e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ee:	29 f3                	sub    %esi,%ebx
  8022f0:	19 fa                	sbb    %edi,%edx
  8022f2:	89 d0                	mov    %edx,%eax
  8022f4:	d3 e0                	shl    %cl,%eax
  8022f6:	89 e9                	mov    %ebp,%ecx
  8022f8:	d3 eb                	shr    %cl,%ebx
  8022fa:	d3 ea                	shr    %cl,%edx
  8022fc:	09 d8                	or     %ebx,%eax
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	89 da                	mov    %ebx,%edx
  802312:	29 fe                	sub    %edi,%esi
  802314:	19 c2                	sbb    %eax,%edx
  802316:	89 f1                	mov    %esi,%ecx
  802318:	89 c8                	mov    %ecx,%eax
  80231a:	e9 4b ff ff ff       	jmp    80226a <__umoddi3+0x8a>
