
obj/user/faultalloc.debug：     文件格式 elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 a0 23 80 00       	push   $0x8023a0
  800045:	e8 bb 01 00 00       	call   800205 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 75 0b 00 00       	call   800bd3 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 ec 23 80 00       	push   $0x8023ec
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 1b 07 00 00       	call   80078e <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 c0 23 80 00       	push   $0x8023c0
  800085:	6a 0e                	push   $0xe
  800087:	68 aa 23 80 00       	push   $0x8023aa
  80008c:	e8 99 00 00 00       	call   80012a <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 42 0d 00 00       	call   800de3 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 bc 23 80 00       	push   $0x8023bc
  8000ae:	e8 52 01 00 00       	call   800205 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 bc 23 80 00       	push   $0x8023bc
  8000c0:	e8 40 01 00 00       	call   800205 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 bb 0a 00 00       	call   800b95 <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800116:	e8 3d 0f 00 00       	call   801058 <close_all>
	sys_env_destroy(0);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	6a 00                	push   $0x0
  800120:	e8 2f 0a 00 00       	call   800b54 <sys_env_destroy>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	56                   	push   %esi
  80012e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800132:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800138:	e8 58 0a 00 00       	call   800b95 <sys_getenvid>
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 0c             	pushl  0xc(%ebp)
  800143:	ff 75 08             	pushl  0x8(%ebp)
  800146:	56                   	push   %esi
  800147:	50                   	push   %eax
  800148:	68 18 24 80 00       	push   $0x802418
  80014d:	e8 b3 00 00 00       	call   800205 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800152:	83 c4 18             	add    $0x18,%esp
  800155:	53                   	push   %ebx
  800156:	ff 75 10             	pushl  0x10(%ebp)
  800159:	e8 56 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  80015e:	c7 04 24 77 28 80 00 	movl   $0x802877,(%esp)
  800165:	e8 9b 00 00 00       	call   800205 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016d:	cc                   	int3   
  80016e:	eb fd                	jmp    80016d <_panic+0x43>

00800170 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	53                   	push   %ebx
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017a:	8b 13                	mov    (%ebx),%edx
  80017c:	8d 42 01             	lea    0x1(%edx),%eax
  80017f:	89 03                	mov    %eax,(%ebx)
  800181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800184:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800188:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018d:	74 09                	je     800198 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800196:	c9                   	leave  
  800197:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	68 ff 00 00 00       	push   $0xff
  8001a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 6e 09 00 00       	call   800b17 <sys_cputs>
		b->idx = 0;
  8001a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	eb db                	jmp    80018f <putch+0x1f>

008001b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	68 70 01 80 00       	push   $0x800170
  8001e3:	e8 19 01 00 00       	call   800301 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f7:	50                   	push   %eax
  8001f8:	e8 1a 09 00 00       	call   800b17 <sys_cputs>

	return b.cnt;
}
  8001fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020e:	50                   	push   %eax
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	e8 9d ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 1c             	sub    $0x1c,%esp
  800222:	89 c7                	mov    %eax,%edi
  800224:	89 d6                	mov    %edx,%esi
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800240:	3b 45 10             	cmp    0x10(%ebp),%eax
  800243:	89 d0                	mov    %edx,%eax
  800245:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800248:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80024b:	73 15                	jae    800262 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80024d:	83 eb 01             	sub    $0x1,%ebx
  800250:	85 db                	test   %ebx,%ebx
  800252:	7e 43                	jle    800297 <printnum+0x7e>
			putch(padc, putdat);
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	56                   	push   %esi
  800258:	ff 75 18             	pushl  0x18(%ebp)
  80025b:	ff d7                	call   *%edi
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	eb eb                	jmp    80024d <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	ff 75 18             	pushl  0x18(%ebp)
  800268:	8b 45 14             	mov    0x14(%ebp),%eax
  80026b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80026e:	53                   	push   %ebx
  80026f:	ff 75 10             	pushl  0x10(%ebp)
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	ff 75 e4             	pushl  -0x1c(%ebp)
  800278:	ff 75 e0             	pushl  -0x20(%ebp)
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	e8 ba 1e 00 00       	call   802140 <__udivdi3>
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	89 f2                	mov    %esi,%edx
  80028d:	89 f8                	mov    %edi,%eax
  80028f:	e8 85 ff ff ff       	call   800219 <printnum>
  800294:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	56                   	push   %esi
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002aa:	e8 a1 1f 00 00       	call   802250 <__umoddi3>
  8002af:	83 c4 14             	add    $0x14,%esp
  8002b2:	0f be 80 3b 24 80 00 	movsbl 0x80243b(%eax),%eax
  8002b9:	50                   	push   %eax
  8002ba:	ff d7                	call   *%edi
}
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5f                   	pop    %edi
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    

008002c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d1:	8b 10                	mov    (%eax),%edx
  8002d3:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d6:	73 0a                	jae    8002e2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002db:	89 08                	mov    %ecx,(%eax)
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	88 02                	mov    %al,(%edx)
}
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <printfmt>:
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ea:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ed:	50                   	push   %eax
  8002ee:	ff 75 10             	pushl  0x10(%ebp)
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	e8 05 00 00 00       	call   800301 <vprintfmt>
}
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <vprintfmt>:
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 3c             	sub    $0x3c,%esp
  80030a:	8b 75 08             	mov    0x8(%ebp),%esi
  80030d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800310:	8b 7d 10             	mov    0x10(%ebp),%edi
  800313:	eb 0a                	jmp    80031f <vprintfmt+0x1e>
			putch(ch, putdat);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	53                   	push   %ebx
  800319:	50                   	push   %eax
  80031a:	ff d6                	call   *%esi
  80031c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80031f:	83 c7 01             	add    $0x1,%edi
  800322:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800326:	83 f8 25             	cmp    $0x25,%eax
  800329:	74 0c                	je     800337 <vprintfmt+0x36>
			if (ch == '\0')
  80032b:	85 c0                	test   %eax,%eax
  80032d:	75 e6                	jne    800315 <vprintfmt+0x14>
}
  80032f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800332:	5b                   	pop    %ebx
  800333:	5e                   	pop    %esi
  800334:	5f                   	pop    %edi
  800335:	5d                   	pop    %ebp
  800336:	c3                   	ret    
		padc = ' ';
  800337:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80033b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800342:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8d 47 01             	lea    0x1(%edi),%eax
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035b:	0f b6 17             	movzbl (%edi),%edx
  80035e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800361:	3c 55                	cmp    $0x55,%al
  800363:	0f 87 ba 03 00 00    	ja     800723 <vprintfmt+0x422>
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	ff 24 85 80 25 80 00 	jmp    *0x802580(,%eax,4)
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800376:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80037a:	eb d9                	jmp    800355 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800383:	eb d0                	jmp    800355 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	0f b6 d2             	movzbl %dl,%edx
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038b:	b8 00 00 00 00       	mov    $0x0,%eax
  800390:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a0:	83 f9 09             	cmp    $0x9,%ecx
  8003a3:	77 55                	ja     8003fa <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a8:	eb e9                	jmp    800393 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 40 04             	lea    0x4(%eax),%eax
  8003b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c2:	79 91                	jns    800355 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d1:	eb 82                	jmp    800355 <vprintfmt+0x54>
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	0f 49 d0             	cmovns %eax,%edx
  8003e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e6:	e9 6a ff ff ff       	jmp    800355 <vprintfmt+0x54>
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ee:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003f5:	e9 5b ff ff ff       	jmp    800355 <vprintfmt+0x54>
  8003fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800400:	eb bc                	jmp    8003be <vprintfmt+0xbd>
			lflag++;
  800402:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800408:	e9 48 ff ff ff       	jmp    800355 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 78 04             	lea    0x4(%eax),%edi
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	53                   	push   %ebx
  800417:	ff 30                	pushl  (%eax)
  800419:	ff d6                	call   *%esi
			break;
  80041b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800421:	e9 9c 02 00 00       	jmp    8006c2 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	99                   	cltd   
  80042f:	31 d0                	xor    %edx,%eax
  800431:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800433:	83 f8 0f             	cmp    $0xf,%eax
  800436:	7f 23                	jg     80045b <vprintfmt+0x15a>
  800438:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 18                	je     80045b <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800443:	52                   	push   %edx
  800444:	68 3e 28 80 00       	push   $0x80283e
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 94 fe ff ff       	call   8002e4 <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
  800456:	e9 67 02 00 00       	jmp    8006c2 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80045b:	50                   	push   %eax
  80045c:	68 53 24 80 00       	push   $0x802453
  800461:	53                   	push   %ebx
  800462:	56                   	push   %esi
  800463:	e8 7c fe ff ff       	call   8002e4 <printfmt>
  800468:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046e:	e9 4f 02 00 00       	jmp    8006c2 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	83 c0 04             	add    $0x4,%eax
  800479:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800481:	85 d2                	test   %edx,%edx
  800483:	b8 4c 24 80 00       	mov    $0x80244c,%eax
  800488:	0f 45 c2             	cmovne %edx,%eax
  80048b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80048e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800492:	7e 06                	jle    80049a <vprintfmt+0x199>
  800494:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800498:	75 0d                	jne    8004a7 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049d:	89 c7                	mov    %eax,%edi
  80049f:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a5:	eb 3f                	jmp    8004e6 <vprintfmt+0x1e5>
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	e8 0d 03 00 00       	call   8007c0 <strnlen>
  8004b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b6:	29 c2                	sub    %eax,%edx
  8004b8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c7:	85 ff                	test   %edi,%edi
  8004c9:	7e 58                	jle    800523 <vprintfmt+0x222>
					putch(padc, putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	83 ef 01             	sub    $0x1,%edi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	eb eb                	jmp    8004c7 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	53                   	push   %ebx
  8004e0:	52                   	push   %edx
  8004e1:	ff d6                	call   *%esi
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004eb:	83 c7 01             	add    $0x1,%edi
  8004ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f2:	0f be d0             	movsbl %al,%edx
  8004f5:	85 d2                	test   %edx,%edx
  8004f7:	74 45                	je     80053e <vprintfmt+0x23d>
  8004f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fd:	78 06                	js     800505 <vprintfmt+0x204>
  8004ff:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800503:	78 35                	js     80053a <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800505:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800509:	74 d1                	je     8004dc <vprintfmt+0x1db>
  80050b:	0f be c0             	movsbl %al,%eax
  80050e:	83 e8 20             	sub    $0x20,%eax
  800511:	83 f8 5e             	cmp    $0x5e,%eax
  800514:	76 c6                	jbe    8004dc <vprintfmt+0x1db>
					putch('?', putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	53                   	push   %ebx
  80051a:	6a 3f                	push   $0x3f
  80051c:	ff d6                	call   *%esi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	eb c3                	jmp    8004e6 <vprintfmt+0x1e5>
  800523:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800526:	85 d2                	test   %edx,%edx
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	0f 49 c2             	cmovns %edx,%eax
  800530:	29 c2                	sub    %eax,%edx
  800532:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800535:	e9 60 ff ff ff       	jmp    80049a <vprintfmt+0x199>
  80053a:	89 cf                	mov    %ecx,%edi
  80053c:	eb 02                	jmp    800540 <vprintfmt+0x23f>
  80053e:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800540:	85 ff                	test   %edi,%edi
  800542:	7e 10                	jle    800554 <vprintfmt+0x253>
				putch(' ', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	53                   	push   %ebx
  800548:	6a 20                	push   $0x20
  80054a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054c:	83 ef 01             	sub    $0x1,%edi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	eb ec                	jmp    800540 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	e9 63 01 00 00       	jmp    8006c2 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80055f:	83 f9 01             	cmp    $0x1,%ecx
  800562:	7f 1b                	jg     80057f <vprintfmt+0x27e>
	else if (lflag)
  800564:	85 c9                	test   %ecx,%ecx
  800566:	74 63                	je     8005cb <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	99                   	cltd   
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	eb 17                	jmp    800596 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 50 04             	mov    0x4(%eax),%edx
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 08             	lea    0x8(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800596:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800599:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	0f 89 ff 00 00 00    	jns    8006a8 <vprintfmt+0x3a7>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b7:	f7 da                	neg    %edx
  8005b9:	83 d1 00             	adc    $0x0,%ecx
  8005bc:	f7 d9                	neg    %ecx
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 dd 00 00 00       	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	99                   	cltd   
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb b4                	jmp    800596 <vprintfmt+0x295>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7f 1e                	jg     800605 <vprintfmt+0x304>
	else if (lflag)
  8005e7:	85 c9                	test   %ecx,%ecx
  8005e9:	74 32                	je     80061d <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 10                	mov    (%eax),%edx
  8005f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800600:	e9 a3 00 00 00       	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 10                	mov    (%eax),%edx
  80060a:	8b 48 04             	mov    0x4(%eax),%ecx
  80060d:	8d 40 08             	lea    0x8(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 8b 00 00 00       	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	eb 74                	jmp    8006a8 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800634:	83 f9 01             	cmp    $0x1,%ecx
  800637:	7f 1b                	jg     800654 <vprintfmt+0x353>
	else if (lflag)
  800639:	85 c9                	test   %ecx,%ecx
  80063b:	74 2c                	je     800669 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 10                	mov    (%eax),%edx
  800642:	b9 00 00 00 00       	mov    $0x0,%ecx
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064d:	b8 08 00 00 00       	mov    $0x8,%eax
  800652:	eb 54                	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	8b 48 04             	mov    0x4(%eax),%ecx
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	b8 08 00 00 00       	mov    $0x8,%eax
  800667:	eb 3f                	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
  80067e:	eb 28                	jmp    8006a8 <vprintfmt+0x3a7>
			putch('0', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 30                	push   $0x30
  800686:	ff d6                	call   *%esi
			putch('x', putdat);
  800688:	83 c4 08             	add    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 78                	push   $0x78
  80068e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006af:	57                   	push   %edi
  8006b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b3:	50                   	push   %eax
  8006b4:	51                   	push   %ecx
  8006b5:	52                   	push   %edx
  8006b6:	89 da                	mov    %ebx,%edx
  8006b8:	89 f0                	mov    %esi,%eax
  8006ba:	e8 5a fb ff ff       	call   800219 <printnum>
			break;
  8006bf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	e9 55 fc ff ff       	jmp    80031f <vprintfmt+0x1e>
	if (lflag >= 2)
  8006ca:	83 f9 01             	cmp    $0x1,%ecx
  8006cd:	7f 1b                	jg     8006ea <vprintfmt+0x3e9>
	else if (lflag)
  8006cf:	85 c9                	test   %ecx,%ecx
  8006d1:	74 2c                	je     8006ff <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 10                	mov    (%eax),%edx
  8006d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e8:	eb be                	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 10                	mov    (%eax),%edx
  8006ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f2:	8d 40 08             	lea    0x8(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fd:	eb a9                	jmp    8006a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	b8 10 00 00 00       	mov    $0x10,%eax
  800714:	eb 92                	jmp    8006a8 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 25                	push   $0x25
  80071c:	ff d6                	call   *%esi
			break;
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	eb 9f                	jmp    8006c2 <vprintfmt+0x3c1>
			putch('%', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	89 f8                	mov    %edi,%eax
  800730:	eb 03                	jmp    800735 <vprintfmt+0x434>
  800732:	83 e8 01             	sub    $0x1,%eax
  800735:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800739:	75 f7                	jne    800732 <vprintfmt+0x431>
  80073b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073e:	eb 82                	jmp    8006c2 <vprintfmt+0x3c1>

00800740 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80074f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800753:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800756:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075d:	85 c0                	test   %eax,%eax
  80075f:	74 26                	je     800787 <vsnprintf+0x47>
  800761:	85 d2                	test   %edx,%edx
  800763:	7e 22                	jle    800787 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800765:	ff 75 14             	pushl  0x14(%ebp)
  800768:	ff 75 10             	pushl  0x10(%ebp)
  80076b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076e:	50                   	push   %eax
  80076f:	68 c7 02 80 00       	push   $0x8002c7
  800774:	e8 88 fb ff ff       	call   800301 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800782:	83 c4 10             	add    $0x10,%esp
}
  800785:	c9                   	leave  
  800786:	c3                   	ret    
		return -E_INVAL;
  800787:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078c:	eb f7                	jmp    800785 <vsnprintf+0x45>

0080078e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800794:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800797:	50                   	push   %eax
  800798:	ff 75 10             	pushl  0x10(%ebp)
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	ff 75 08             	pushl  0x8(%ebp)
  8007a1:	e8 9a ff ff ff       	call   800740 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b7:	74 05                	je     8007be <strlen+0x16>
		n++;
  8007b9:	83 c0 01             	add    $0x1,%eax
  8007bc:	eb f5                	jmp    8007b3 <strlen+0xb>
	return n;
}
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ce:	39 c2                	cmp    %eax,%edx
  8007d0:	74 0d                	je     8007df <strnlen+0x1f>
  8007d2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007d6:	74 05                	je     8007dd <strnlen+0x1d>
		n++;
  8007d8:	83 c2 01             	add    $0x1,%edx
  8007db:	eb f1                	jmp    8007ce <strnlen+0xe>
  8007dd:	89 d0                	mov    %edx,%eax
	return n;
}
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	53                   	push   %ebx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007f7:	83 c2 01             	add    $0x1,%edx
  8007fa:	84 c9                	test   %cl,%cl
  8007fc:	75 f2                	jne    8007f0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007fe:	5b                   	pop    %ebx
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	83 ec 10             	sub    $0x10,%esp
  800808:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080b:	53                   	push   %ebx
  80080c:	e8 97 ff ff ff       	call   8007a8 <strlen>
  800811:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	01 d8                	add    %ebx,%eax
  800819:	50                   	push   %eax
  80081a:	e8 c2 ff ff ff       	call   8007e1 <strcpy>
	return dst;
}
  80081f:	89 d8                	mov    %ebx,%eax
  800821:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800824:	c9                   	leave  
  800825:	c3                   	ret    

00800826 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	56                   	push   %esi
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800831:	89 c6                	mov    %eax,%esi
  800833:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800836:	89 c2                	mov    %eax,%edx
  800838:	39 f2                	cmp    %esi,%edx
  80083a:	74 11                	je     80084d <strncpy+0x27>
		*dst++ = *src;
  80083c:	83 c2 01             	add    $0x1,%edx
  80083f:	0f b6 19             	movzbl (%ecx),%ebx
  800842:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800845:	80 fb 01             	cmp    $0x1,%bl
  800848:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80084b:	eb eb                	jmp    800838 <strncpy+0x12>
	}
	return ret;
}
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	8b 55 10             	mov    0x10(%ebp),%edx
  80085f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800861:	85 d2                	test   %edx,%edx
  800863:	74 21                	je     800886 <strlcpy+0x35>
  800865:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800869:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80086b:	39 c2                	cmp    %eax,%edx
  80086d:	74 14                	je     800883 <strlcpy+0x32>
  80086f:	0f b6 19             	movzbl (%ecx),%ebx
  800872:	84 db                	test   %bl,%bl
  800874:	74 0b                	je     800881 <strlcpy+0x30>
			*dst++ = *src++;
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	83 c2 01             	add    $0x1,%edx
  80087c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087f:	eb ea                	jmp    80086b <strlcpy+0x1a>
  800881:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800883:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800886:	29 f0                	sub    %esi,%eax
}
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800895:	0f b6 01             	movzbl (%ecx),%eax
  800898:	84 c0                	test   %al,%al
  80089a:	74 0c                	je     8008a8 <strcmp+0x1c>
  80089c:	3a 02                	cmp    (%edx),%al
  80089e:	75 08                	jne    8008a8 <strcmp+0x1c>
		p++, q++;
  8008a0:	83 c1 01             	add    $0x1,%ecx
  8008a3:	83 c2 01             	add    $0x1,%edx
  8008a6:	eb ed                	jmp    800895 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a8:	0f b6 c0             	movzbl %al,%eax
  8008ab:	0f b6 12             	movzbl (%edx),%edx
  8008ae:	29 d0                	sub    %edx,%eax
}
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	53                   	push   %ebx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 c3                	mov    %eax,%ebx
  8008be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strncmp+0x17>
		n--, p++, q++;
  8008c3:	83 c0 01             	add    $0x1,%eax
  8008c6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008c9:	39 d8                	cmp    %ebx,%eax
  8008cb:	74 16                	je     8008e3 <strncmp+0x31>
  8008cd:	0f b6 08             	movzbl (%eax),%ecx
  8008d0:	84 c9                	test   %cl,%cl
  8008d2:	74 04                	je     8008d8 <strncmp+0x26>
  8008d4:	3a 0a                	cmp    (%edx),%cl
  8008d6:	74 eb                	je     8008c3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d8:	0f b6 00             	movzbl (%eax),%eax
  8008db:	0f b6 12             	movzbl (%edx),%edx
  8008de:	29 d0                	sub    %edx,%eax
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    
		return 0;
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	eb f6                	jmp    8008e0 <strncmp+0x2e>

008008ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f4:	0f b6 10             	movzbl (%eax),%edx
  8008f7:	84 d2                	test   %dl,%dl
  8008f9:	74 09                	je     800904 <strchr+0x1a>
		if (*s == c)
  8008fb:	38 ca                	cmp    %cl,%dl
  8008fd:	74 0a                	je     800909 <strchr+0x1f>
	for (; *s; s++)
  8008ff:	83 c0 01             	add    $0x1,%eax
  800902:	eb f0                	jmp    8008f4 <strchr+0xa>
			return (char *) s;
	return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800915:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800918:	38 ca                	cmp    %cl,%dl
  80091a:	74 09                	je     800925 <strfind+0x1a>
  80091c:	84 d2                	test   %dl,%dl
  80091e:	74 05                	je     800925 <strfind+0x1a>
	for (; *s; s++)
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	eb f0                	jmp    800915 <strfind+0xa>
			break;
	return (char *) s;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800930:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 31                	je     800968 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800937:	89 f8                	mov    %edi,%eax
  800939:	09 c8                	or     %ecx,%eax
  80093b:	a8 03                	test   $0x3,%al
  80093d:	75 23                	jne    800962 <memset+0x3b>
		c &= 0xFF;
  80093f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800943:	89 d3                	mov    %edx,%ebx
  800945:	c1 e3 08             	shl    $0x8,%ebx
  800948:	89 d0                	mov    %edx,%eax
  80094a:	c1 e0 18             	shl    $0x18,%eax
  80094d:	89 d6                	mov    %edx,%esi
  80094f:	c1 e6 10             	shl    $0x10,%esi
  800952:	09 f0                	or     %esi,%eax
  800954:	09 c2                	or     %eax,%edx
  800956:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800958:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80095b:	89 d0                	mov    %edx,%eax
  80095d:	fc                   	cld    
  80095e:	f3 ab                	rep stos %eax,%es:(%edi)
  800960:	eb 06                	jmp    800968 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800962:	8b 45 0c             	mov    0xc(%ebp),%eax
  800965:	fc                   	cld    
  800966:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800968:	89 f8                	mov    %edi,%eax
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5f                   	pop    %edi
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	57                   	push   %edi
  800973:	56                   	push   %esi
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097d:	39 c6                	cmp    %eax,%esi
  80097f:	73 32                	jae    8009b3 <memmove+0x44>
  800981:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800984:	39 c2                	cmp    %eax,%edx
  800986:	76 2b                	jbe    8009b3 <memmove+0x44>
		s += n;
		d += n;
  800988:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098b:	89 fe                	mov    %edi,%esi
  80098d:	09 ce                	or     %ecx,%esi
  80098f:	09 d6                	or     %edx,%esi
  800991:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800997:	75 0e                	jne    8009a7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800999:	83 ef 04             	sub    $0x4,%edi
  80099c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a2:	fd                   	std    
  8009a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a5:	eb 09                	jmp    8009b0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a7:	83 ef 01             	sub    $0x1,%edi
  8009aa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ad:	fd                   	std    
  8009ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b0:	fc                   	cld    
  8009b1:	eb 1a                	jmp    8009cd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b3:	89 c2                	mov    %eax,%edx
  8009b5:	09 ca                	or     %ecx,%edx
  8009b7:	09 f2                	or     %esi,%edx
  8009b9:	f6 c2 03             	test   $0x3,%dl
  8009bc:	75 0a                	jne    8009c8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009be:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c1:	89 c7                	mov    %eax,%edi
  8009c3:	fc                   	cld    
  8009c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c6:	eb 05                	jmp    8009cd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009c8:	89 c7                	mov    %eax,%edi
  8009ca:	fc                   	cld    
  8009cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009cd:	5e                   	pop    %esi
  8009ce:	5f                   	pop    %edi
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d7:	ff 75 10             	pushl  0x10(%ebp)
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	ff 75 08             	pushl  0x8(%ebp)
  8009e0:	e8 8a ff ff ff       	call   80096f <memmove>
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f7:	39 f0                	cmp    %esi,%eax
  8009f9:	74 1c                	je     800a17 <memcmp+0x30>
		if (*s1 != *s2)
  8009fb:	0f b6 08             	movzbl (%eax),%ecx
  8009fe:	0f b6 1a             	movzbl (%edx),%ebx
  800a01:	38 d9                	cmp    %bl,%cl
  800a03:	75 08                	jne    800a0d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	83 c2 01             	add    $0x1,%edx
  800a0b:	eb ea                	jmp    8009f7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a0d:	0f b6 c1             	movzbl %cl,%eax
  800a10:	0f b6 db             	movzbl %bl,%ebx
  800a13:	29 d8                	sub    %ebx,%eax
  800a15:	eb 05                	jmp    800a1c <memcmp+0x35>
	}

	return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2e:	39 d0                	cmp    %edx,%eax
  800a30:	73 09                	jae    800a3b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a32:	38 08                	cmp    %cl,(%eax)
  800a34:	74 05                	je     800a3b <memfind+0x1b>
	for (; s < ends; s++)
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	eb f3                	jmp    800a2e <memfind+0xe>
			break;
	return (void *) s;
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	57                   	push   %edi
  800a41:	56                   	push   %esi
  800a42:	53                   	push   %ebx
  800a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a49:	eb 03                	jmp    800a4e <strtol+0x11>
		s++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4e:	0f b6 01             	movzbl (%ecx),%eax
  800a51:	3c 20                	cmp    $0x20,%al
  800a53:	74 f6                	je     800a4b <strtol+0xe>
  800a55:	3c 09                	cmp    $0x9,%al
  800a57:	74 f2                	je     800a4b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a59:	3c 2b                	cmp    $0x2b,%al
  800a5b:	74 2a                	je     800a87 <strtol+0x4a>
	int neg = 0;
  800a5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a62:	3c 2d                	cmp    $0x2d,%al
  800a64:	74 2b                	je     800a91 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6c:	75 0f                	jne    800a7d <strtol+0x40>
  800a6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a71:	74 28                	je     800a9b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a73:	85 db                	test   %ebx,%ebx
  800a75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7a:	0f 44 d8             	cmove  %eax,%ebx
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a85:	eb 50                	jmp    800ad7 <strtol+0x9a>
		s++;
  800a87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	eb d5                	jmp    800a66 <strtol+0x29>
		s++, neg = 1;
  800a91:	83 c1 01             	add    $0x1,%ecx
  800a94:	bf 01 00 00 00       	mov    $0x1,%edi
  800a99:	eb cb                	jmp    800a66 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a9f:	74 0e                	je     800aaf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	75 d8                	jne    800a7d <strtol+0x40>
		s++, base = 8;
  800aa5:	83 c1 01             	add    $0x1,%ecx
  800aa8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aad:	eb ce                	jmp    800a7d <strtol+0x40>
		s += 2, base = 16;
  800aaf:	83 c1 02             	add    $0x2,%ecx
  800ab2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab7:	eb c4                	jmp    800a7d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800abc:	89 f3                	mov    %esi,%ebx
  800abe:	80 fb 19             	cmp    $0x19,%bl
  800ac1:	77 29                	ja     800aec <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ac3:	0f be d2             	movsbl %dl,%edx
  800ac6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800acc:	7d 30                	jge    800afe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ace:	83 c1 01             	add    $0x1,%ecx
  800ad1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad7:	0f b6 11             	movzbl (%ecx),%edx
  800ada:	8d 72 d0             	lea    -0x30(%edx),%esi
  800add:	89 f3                	mov    %esi,%ebx
  800adf:	80 fb 09             	cmp    $0x9,%bl
  800ae2:	77 d5                	ja     800ab9 <strtol+0x7c>
			dig = *s - '0';
  800ae4:	0f be d2             	movsbl %dl,%edx
  800ae7:	83 ea 30             	sub    $0x30,%edx
  800aea:	eb dd                	jmp    800ac9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800aec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 19             	cmp    $0x19,%bl
  800af4:	77 08                	ja     800afe <strtol+0xc1>
			dig = *s - 'A' + 10;
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 37             	sub    $0x37,%edx
  800afc:	eb cb                	jmp    800ac9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800afe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b02:	74 05                	je     800b09 <strtol+0xcc>
		*endptr = (char *) s;
  800b04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	f7 da                	neg    %edx
  800b0d:	85 ff                	test   %edi,%edi
  800b0f:	0f 45 c2             	cmovne %edx,%eax
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b28:	89 c3                	mov    %eax,%ebx
  800b2a:	89 c7                	mov    %eax,%edi
  800b2c:	89 c6                	mov    %eax,%esi
  800b2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5f                   	pop    %edi
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	57                   	push   %edi
  800b39:	56                   	push   %esi
  800b3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	b8 01 00 00 00       	mov    $0x1,%eax
  800b45:	89 d1                	mov    %edx,%ecx
  800b47:	89 d3                	mov    %edx,%ebx
  800b49:	89 d7                	mov    %edx,%edi
  800b4b:	89 d6                	mov    %edx,%esi
  800b4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6a:	89 cb                	mov    %ecx,%ebx
  800b6c:	89 cf                	mov    %ecx,%edi
  800b6e:	89 ce                	mov    %ecx,%esi
  800b70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b72:	85 c0                	test   %eax,%eax
  800b74:	7f 08                	jg     800b7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	50                   	push   %eax
  800b82:	6a 03                	push   $0x3
  800b84:	68 3f 27 80 00       	push   $0x80273f
  800b89:	6a 23                	push   $0x23
  800b8b:	68 5c 27 80 00       	push   $0x80275c
  800b90:	e8 95 f5 ff ff       	call   80012a <_panic>

00800b95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba5:	89 d1                	mov    %edx,%ecx
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_yield>:

void
sys_yield(void)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bdc:	be 00 00 00 00       	mov    $0x0,%esi
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	b8 04 00 00 00       	mov    $0x4,%eax
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bef:	89 f7                	mov    %esi,%edi
  800bf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7f 08                	jg     800bff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	50                   	push   %eax
  800c03:	6a 04                	push   $0x4
  800c05:	68 3f 27 80 00       	push   $0x80273f
  800c0a:	6a 23                	push   $0x23
  800c0c:	68 5c 27 80 00       	push   $0x80275c
  800c11:	e8 14 f5 ff ff       	call   80012a <_panic>

00800c16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c25:	b8 05 00 00 00       	mov    $0x5,%eax
  800c2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c30:	8b 75 18             	mov    0x18(%ebp),%esi
  800c33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c35:	85 c0                	test   %eax,%eax
  800c37:	7f 08                	jg     800c41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c41:	83 ec 0c             	sub    $0xc,%esp
  800c44:	50                   	push   %eax
  800c45:	6a 05                	push   $0x5
  800c47:	68 3f 27 80 00       	push   $0x80273f
  800c4c:	6a 23                	push   $0x23
  800c4e:	68 5c 27 80 00       	push   $0x80275c
  800c53:	e8 d2 f4 ff ff       	call   80012a <_panic>

00800c58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c71:	89 df                	mov    %ebx,%edi
  800c73:	89 de                	mov    %ebx,%esi
  800c75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c77:	85 c0                	test   %eax,%eax
  800c79:	7f 08                	jg     800c83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	50                   	push   %eax
  800c87:	6a 06                	push   $0x6
  800c89:	68 3f 27 80 00       	push   $0x80273f
  800c8e:	6a 23                	push   $0x23
  800c90:	68 5c 27 80 00       	push   $0x80275c
  800c95:	e8 90 f4 ff ff       	call   80012a <_panic>

00800c9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cae:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb3:	89 df                	mov    %ebx,%edi
  800cb5:	89 de                	mov    %ebx,%esi
  800cb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	7f 08                	jg     800cc5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	50                   	push   %eax
  800cc9:	6a 08                	push   $0x8
  800ccb:	68 3f 27 80 00       	push   $0x80273f
  800cd0:	6a 23                	push   $0x23
  800cd2:	68 5c 27 80 00       	push   $0x80275c
  800cd7:	e8 4e f4 ff ff       	call   80012a <_panic>

00800cdc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf5:	89 df                	mov    %ebx,%edi
  800cf7:	89 de                	mov    %ebx,%esi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	6a 09                	push   $0x9
  800d0d:	68 3f 27 80 00       	push   $0x80273f
  800d12:	6a 23                	push   $0x23
  800d14:	68 5c 27 80 00       	push   $0x80275c
  800d19:	e8 0c f4 ff ff       	call   80012a <_panic>

00800d1e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d37:	89 df                	mov    %ebx,%edi
  800d39:	89 de                	mov    %ebx,%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 0a                	push   $0xa
  800d4f:	68 3f 27 80 00       	push   $0x80273f
  800d54:	6a 23                	push   $0x23
  800d56:	68 5c 27 80 00       	push   $0x80275c
  800d5b:	e8 ca f3 ff ff       	call   80012a <_panic>

00800d60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d71:	be 00 00 00 00       	mov    $0x0,%esi
  800d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d99:	89 cb                	mov    %ecx,%ebx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	89 ce                	mov    %ecx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 0d                	push   $0xd
  800db3:	68 3f 27 80 00       	push   $0x80273f
  800db8:	6a 23                	push   $0x23
  800dba:	68 5c 27 80 00       	push   $0x80275c
  800dbf:	e8 66 f3 ff ff       	call   80012a <_panic>

00800dc4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dd4:	89 d1                	mov    %edx,%ecx
  800dd6:	89 d3                	mov    %edx,%ebx
  800dd8:	89 d7                	mov    %edx,%edi
  800dda:	89 d6                	mov    %edx,%esi
  800ddc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800de9:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800df0:	74 0a                	je     800dfc <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800dfc:	a1 08 40 80 00       	mov    0x804008,%eax
  800e01:	8b 40 48             	mov    0x48(%eax),%eax
  800e04:	83 ec 04             	sub    $0x4,%esp
  800e07:	6a 07                	push   $0x7
  800e09:	68 00 f0 bf ee       	push   $0xeebff000
  800e0e:	50                   	push   %eax
  800e0f:	e8 bf fd ff ff       	call   800bd3 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	85 c0                	test   %eax,%eax
  800e19:	78 2c                	js     800e47 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800e1b:	e8 75 fd ff ff       	call   800b95 <sys_getenvid>
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	68 59 0e 80 00       	push   $0x800e59
  800e28:	50                   	push   %eax
  800e29:	e8 f0 fe ff ff       	call   800d1e <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	79 bd                	jns    800df2 <set_pgfault_handler+0xf>
  800e35:	50                   	push   %eax
  800e36:	68 6a 27 80 00       	push   $0x80276a
  800e3b:	6a 23                	push   $0x23
  800e3d:	68 82 27 80 00       	push   $0x802782
  800e42:	e8 e3 f2 ff ff       	call   80012a <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800e47:	50                   	push   %eax
  800e48:	68 6a 27 80 00       	push   $0x80276a
  800e4d:	6a 21                	push   $0x21
  800e4f:	68 82 27 80 00       	push   $0x802782
  800e54:	e8 d1 f2 ff ff       	call   80012a <_panic>

00800e59 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e59:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e5a:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e5f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e61:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  800e64:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  800e68:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  800e6b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  800e6f:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  800e73:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800e76:	83 c4 08             	add    $0x8,%esp
	popal
  800e79:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800e7a:	83 c4 04             	add    $0x4,%esp
	popfl
  800e7d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800e7e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800e7f:	c3                   	ret    

00800e80 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	05 00 00 00 30       	add    $0x30000000,%eax
  800e8b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ea0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eaf:	89 c2                	mov    %eax,%edx
  800eb1:	c1 ea 16             	shr    $0x16,%edx
  800eb4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ebb:	f6 c2 01             	test   $0x1,%dl
  800ebe:	74 2d                	je     800eed <fd_alloc+0x46>
  800ec0:	89 c2                	mov    %eax,%edx
  800ec2:	c1 ea 0c             	shr    $0xc,%edx
  800ec5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ecc:	f6 c2 01             	test   $0x1,%dl
  800ecf:	74 1c                	je     800eed <fd_alloc+0x46>
  800ed1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ed6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800edb:	75 d2                	jne    800eaf <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ee6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eeb:	eb 0a                	jmp    800ef7 <fd_alloc+0x50>
			*fd_store = fd;
  800eed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eff:	83 f8 1f             	cmp    $0x1f,%eax
  800f02:	77 30                	ja     800f34 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f04:	c1 e0 0c             	shl    $0xc,%eax
  800f07:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f0c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f12:	f6 c2 01             	test   $0x1,%dl
  800f15:	74 24                	je     800f3b <fd_lookup+0x42>
  800f17:	89 c2                	mov    %eax,%edx
  800f19:	c1 ea 0c             	shr    $0xc,%edx
  800f1c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f23:	f6 c2 01             	test   $0x1,%dl
  800f26:	74 1a                	je     800f42 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2b:	89 02                	mov    %eax,(%edx)
	return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		return -E_INVAL;
  800f34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f39:	eb f7                	jmp    800f32 <fd_lookup+0x39>
		return -E_INVAL;
  800f3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f40:	eb f0                	jmp    800f32 <fd_lookup+0x39>
  800f42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f47:	eb e9                	jmp    800f32 <fd_lookup+0x39>

00800f49 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f52:	ba 00 00 00 00       	mov    $0x0,%edx
  800f57:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f5c:	39 08                	cmp    %ecx,(%eax)
  800f5e:	74 38                	je     800f98 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f60:	83 c2 01             	add    $0x1,%edx
  800f63:	8b 04 95 0c 28 80 00 	mov    0x80280c(,%edx,4),%eax
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	75 ee                	jne    800f5c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f6e:	a1 08 40 80 00       	mov    0x804008,%eax
  800f73:	8b 40 48             	mov    0x48(%eax),%eax
  800f76:	83 ec 04             	sub    $0x4,%esp
  800f79:	51                   	push   %ecx
  800f7a:	50                   	push   %eax
  800f7b:	68 90 27 80 00       	push   $0x802790
  800f80:	e8 80 f2 ff ff       	call   800205 <cprintf>
	*dev = 0;
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f8e:	83 c4 10             	add    $0x10,%esp
  800f91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    
			*dev = devtab[i];
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb f2                	jmp    800f96 <dev_lookup+0x4d>

00800fa4 <fd_close>:
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 24             	sub    $0x24,%esp
  800fad:	8b 75 08             	mov    0x8(%ebp),%esi
  800fb0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fb3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fb6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fbd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc0:	50                   	push   %eax
  800fc1:	e8 33 ff ff ff       	call   800ef9 <fd_lookup>
  800fc6:	89 c3                	mov    %eax,%ebx
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	78 05                	js     800fd4 <fd_close+0x30>
	    || fd != fd2)
  800fcf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fd2:	74 16                	je     800fea <fd_close+0x46>
		return (must_exist ? r : 0);
  800fd4:	89 f8                	mov    %edi,%eax
  800fd6:	84 c0                	test   %al,%al
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdd:	0f 44 d8             	cmove  %eax,%ebx
}
  800fe0:	89 d8                	mov    %ebx,%eax
  800fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	ff 36                	pushl  (%esi)
  800ff3:	e8 51 ff ff ff       	call   800f49 <dev_lookup>
  800ff8:	89 c3                	mov    %eax,%ebx
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	78 1a                	js     80101b <fd_close+0x77>
		if (dev->dev_close)
  801001:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801004:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801007:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	74 0b                	je     80101b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801010:	83 ec 0c             	sub    $0xc,%esp
  801013:	56                   	push   %esi
  801014:	ff d0                	call   *%eax
  801016:	89 c3                	mov    %eax,%ebx
  801018:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	56                   	push   %esi
  80101f:	6a 00                	push   $0x0
  801021:	e8 32 fc ff ff       	call   800c58 <sys_page_unmap>
	return r;
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	eb b5                	jmp    800fe0 <fd_close+0x3c>

0080102b <close>:

int
close(int fdnum)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801031:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801034:	50                   	push   %eax
  801035:	ff 75 08             	pushl  0x8(%ebp)
  801038:	e8 bc fe ff ff       	call   800ef9 <fd_lookup>
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	85 c0                	test   %eax,%eax
  801042:	79 02                	jns    801046 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    
		return fd_close(fd, 1);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	6a 01                	push   $0x1
  80104b:	ff 75 f4             	pushl  -0xc(%ebp)
  80104e:	e8 51 ff ff ff       	call   800fa4 <fd_close>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	eb ec                	jmp    801044 <close+0x19>

00801058 <close_all>:

void
close_all(void)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	53                   	push   %ebx
  80105c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80105f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	53                   	push   %ebx
  801068:	e8 be ff ff ff       	call   80102b <close>
	for (i = 0; i < MAXFD; i++)
  80106d:	83 c3 01             	add    $0x1,%ebx
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	83 fb 20             	cmp    $0x20,%ebx
  801076:	75 ec                	jne    801064 <close_all+0xc>
}
  801078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
  801083:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801086:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801089:	50                   	push   %eax
  80108a:	ff 75 08             	pushl  0x8(%ebp)
  80108d:	e8 67 fe ff ff       	call   800ef9 <fd_lookup>
  801092:	89 c3                	mov    %eax,%ebx
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	0f 88 81 00 00 00    	js     801120 <dup+0xa3>
		return r;
	close(newfdnum);
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	e8 81 ff ff ff       	call   80102b <close>

	newfd = INDEX2FD(newfdnum);
  8010aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ad:	c1 e6 0c             	shl    $0xc,%esi
  8010b0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010b6:	83 c4 04             	add    $0x4,%esp
  8010b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010bc:	e8 cf fd ff ff       	call   800e90 <fd2data>
  8010c1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010c3:	89 34 24             	mov    %esi,(%esp)
  8010c6:	e8 c5 fd ff ff       	call   800e90 <fd2data>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010d0:	89 d8                	mov    %ebx,%eax
  8010d2:	c1 e8 16             	shr    $0x16,%eax
  8010d5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010dc:	a8 01                	test   $0x1,%al
  8010de:	74 11                	je     8010f1 <dup+0x74>
  8010e0:	89 d8                	mov    %ebx,%eax
  8010e2:	c1 e8 0c             	shr    $0xc,%eax
  8010e5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ec:	f6 c2 01             	test   $0x1,%dl
  8010ef:	75 39                	jne    80112a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010f4:	89 d0                	mov    %edx,%eax
  8010f6:	c1 e8 0c             	shr    $0xc,%eax
  8010f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	25 07 0e 00 00       	and    $0xe07,%eax
  801108:	50                   	push   %eax
  801109:	56                   	push   %esi
  80110a:	6a 00                	push   $0x0
  80110c:	52                   	push   %edx
  80110d:	6a 00                	push   $0x0
  80110f:	e8 02 fb ff ff       	call   800c16 <sys_page_map>
  801114:	89 c3                	mov    %eax,%ebx
  801116:	83 c4 20             	add    $0x20,%esp
  801119:	85 c0                	test   %eax,%eax
  80111b:	78 31                	js     80114e <dup+0xd1>
		goto err;

	return newfdnum;
  80111d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801120:	89 d8                	mov    %ebx,%eax
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80112a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	25 07 0e 00 00       	and    $0xe07,%eax
  801139:	50                   	push   %eax
  80113a:	57                   	push   %edi
  80113b:	6a 00                	push   $0x0
  80113d:	53                   	push   %ebx
  80113e:	6a 00                	push   $0x0
  801140:	e8 d1 fa ff ff       	call   800c16 <sys_page_map>
  801145:	89 c3                	mov    %eax,%ebx
  801147:	83 c4 20             	add    $0x20,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	79 a3                	jns    8010f1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	56                   	push   %esi
  801152:	6a 00                	push   $0x0
  801154:	e8 ff fa ff ff       	call   800c58 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801159:	83 c4 08             	add    $0x8,%esp
  80115c:	57                   	push   %edi
  80115d:	6a 00                	push   $0x0
  80115f:	e8 f4 fa ff ff       	call   800c58 <sys_page_unmap>
	return r;
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	eb b7                	jmp    801120 <dup+0xa3>

00801169 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	53                   	push   %ebx
  80116d:	83 ec 1c             	sub    $0x1c,%esp
  801170:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801173:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801176:	50                   	push   %eax
  801177:	53                   	push   %ebx
  801178:	e8 7c fd ff ff       	call   800ef9 <fd_lookup>
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	85 c0                	test   %eax,%eax
  801182:	78 3f                	js     8011c3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118a:	50                   	push   %eax
  80118b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118e:	ff 30                	pushl  (%eax)
  801190:	e8 b4 fd ff ff       	call   800f49 <dev_lookup>
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 27                	js     8011c3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80119c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80119f:	8b 42 08             	mov    0x8(%edx),%eax
  8011a2:	83 e0 03             	and    $0x3,%eax
  8011a5:	83 f8 01             	cmp    $0x1,%eax
  8011a8:	74 1e                	je     8011c8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	8b 40 08             	mov    0x8(%eax),%eax
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	74 35                	je     8011e9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	ff 75 10             	pushl  0x10(%ebp)
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	52                   	push   %edx
  8011be:	ff d0                	call   *%eax
  8011c0:	83 c4 10             	add    $0x10,%esp
}
  8011c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8011cd:	8b 40 48             	mov    0x48(%eax),%eax
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	53                   	push   %ebx
  8011d4:	50                   	push   %eax
  8011d5:	68 d1 27 80 00       	push   $0x8027d1
  8011da:	e8 26 f0 ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e7:	eb da                	jmp    8011c3 <read+0x5a>
		return -E_NOT_SUPP;
  8011e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011ee:	eb d3                	jmp    8011c3 <read+0x5a>

008011f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	57                   	push   %edi
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801204:	39 f3                	cmp    %esi,%ebx
  801206:	73 23                	jae    80122b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	89 f0                	mov    %esi,%eax
  80120d:	29 d8                	sub    %ebx,%eax
  80120f:	50                   	push   %eax
  801210:	89 d8                	mov    %ebx,%eax
  801212:	03 45 0c             	add    0xc(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	57                   	push   %edi
  801217:	e8 4d ff ff ff       	call   801169 <read>
		if (m < 0)
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	78 06                	js     801229 <readn+0x39>
			return m;
		if (m == 0)
  801223:	74 06                	je     80122b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801225:	01 c3                	add    %eax,%ebx
  801227:	eb db                	jmp    801204 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801229:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80122b:	89 d8                	mov    %ebx,%eax
  80122d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	53                   	push   %ebx
  801239:	83 ec 1c             	sub    $0x1c,%esp
  80123c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80123f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	53                   	push   %ebx
  801244:	e8 b0 fc ff ff       	call   800ef9 <fd_lookup>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 3a                	js     80128a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125a:	ff 30                	pushl  (%eax)
  80125c:	e8 e8 fc ff ff       	call   800f49 <dev_lookup>
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 22                	js     80128a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80126f:	74 1e                	je     80128f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801274:	8b 52 0c             	mov    0xc(%edx),%edx
  801277:	85 d2                	test   %edx,%edx
  801279:	74 35                	je     8012b0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	ff 75 10             	pushl  0x10(%ebp)
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	ff d2                	call   *%edx
  801287:	83 c4 10             	add    $0x10,%esp
}
  80128a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80128f:	a1 08 40 80 00       	mov    0x804008,%eax
  801294:	8b 40 48             	mov    0x48(%eax),%eax
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	53                   	push   %ebx
  80129b:	50                   	push   %eax
  80129c:	68 ed 27 80 00       	push   $0x8027ed
  8012a1:	e8 5f ef ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ae:	eb da                	jmp    80128a <write+0x55>
		return -E_NOT_SUPP;
  8012b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b5:	eb d3                	jmp    80128a <write+0x55>

008012b7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 08             	pushl  0x8(%ebp)
  8012c4:	e8 30 fc ff ff       	call   800ef9 <fd_lookup>
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 0e                	js     8012de <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 1c             	sub    $0x1c,%esp
  8012e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	53                   	push   %ebx
  8012ef:	e8 05 fc ff ff       	call   800ef9 <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 37                	js     801332 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801301:	50                   	push   %eax
  801302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801305:	ff 30                	pushl  (%eax)
  801307:	e8 3d fc ff ff       	call   800f49 <dev_lookup>
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	78 1f                	js     801332 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801316:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80131a:	74 1b                	je     801337 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131f:	8b 52 18             	mov    0x18(%edx),%edx
  801322:	85 d2                	test   %edx,%edx
  801324:	74 32                	je     801358 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 0c             	pushl  0xc(%ebp)
  80132c:	50                   	push   %eax
  80132d:	ff d2                	call   *%edx
  80132f:	83 c4 10             	add    $0x10,%esp
}
  801332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801335:	c9                   	leave  
  801336:	c3                   	ret    
			thisenv->env_id, fdnum);
  801337:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80133c:	8b 40 48             	mov    0x48(%eax),%eax
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	53                   	push   %ebx
  801343:	50                   	push   %eax
  801344:	68 b0 27 80 00       	push   $0x8027b0
  801349:	e8 b7 ee ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801356:	eb da                	jmp    801332 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801358:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135d:	eb d3                	jmp    801332 <ftruncate+0x52>

0080135f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	53                   	push   %ebx
  801363:	83 ec 1c             	sub    $0x1c,%esp
  801366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801369:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	e8 84 fb ff ff       	call   800ef9 <fd_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 4b                	js     8013c7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	ff 30                	pushl  (%eax)
  801388:	e8 bc fb ff ff       	call   800f49 <dev_lookup>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 33                	js     8013c7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80139b:	74 2f                	je     8013cc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80139d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013a0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013a7:	00 00 00 
	stat->st_isdir = 0;
  8013aa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013b1:	00 00 00 
	stat->st_dev = dev;
  8013b4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	53                   	push   %ebx
  8013be:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c1:	ff 50 14             	call   *0x14(%eax)
  8013c4:	83 c4 10             	add    $0x10,%esp
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
		return -E_NOT_SUPP;
  8013cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d1:	eb f4                	jmp    8013c7 <fstat+0x68>

008013d3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	6a 00                	push   $0x0
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	e8 2f 02 00 00       	call   801614 <open>
  8013e5:	89 c3                	mov    %eax,%ebx
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 1b                	js     801409 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	50                   	push   %eax
  8013f5:	e8 65 ff ff ff       	call   80135f <fstat>
  8013fa:	89 c6                	mov    %eax,%esi
	close(fd);
  8013fc:	89 1c 24             	mov    %ebx,(%esp)
  8013ff:	e8 27 fc ff ff       	call   80102b <close>
	return r;
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	89 f3                	mov    %esi,%ebx
}
  801409:	89 d8                	mov    %ebx,%eax
  80140b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80140e:	5b                   	pop    %ebx
  80140f:	5e                   	pop    %esi
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
  801417:	89 c6                	mov    %eax,%esi
  801419:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80141b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801422:	74 27                	je     80144b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801424:	6a 07                	push   $0x7
  801426:	68 00 50 80 00       	push   $0x805000
  80142b:	56                   	push   %esi
  80142c:	ff 35 00 40 80 00    	pushl  0x804000
  801432:	e8 1f 0c 00 00       	call   802056 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801437:	83 c4 0c             	add    $0xc,%esp
  80143a:	6a 00                	push   $0x0
  80143c:	53                   	push   %ebx
  80143d:	6a 00                	push   $0x0
  80143f:	e8 9f 0b 00 00       	call   801fe3 <ipc_recv>
}
  801444:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801447:	5b                   	pop    %ebx
  801448:	5e                   	pop    %esi
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80144b:	83 ec 0c             	sub    $0xc,%esp
  80144e:	6a 01                	push   $0x1
  801450:	e8 6d 0c 00 00       	call   8020c2 <ipc_find_env>
  801455:	a3 00 40 80 00       	mov    %eax,0x804000
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	eb c5                	jmp    801424 <fsipc+0x12>

0080145f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8b 40 0c             	mov    0xc(%eax),%eax
  80146b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801478:	ba 00 00 00 00       	mov    $0x0,%edx
  80147d:	b8 02 00 00 00       	mov    $0x2,%eax
  801482:	e8 8b ff ff ff       	call   801412 <fsipc>
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <devfile_flush>:
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8b 40 0c             	mov    0xc(%eax),%eax
  801495:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80149a:	ba 00 00 00 00       	mov    $0x0,%edx
  80149f:	b8 06 00 00 00       	mov    $0x6,%eax
  8014a4:	e8 69 ff ff ff       	call   801412 <fsipc>
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <devfile_stat>:
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	53                   	push   %ebx
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014bb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8014ca:	e8 43 ff ff ff       	call   801412 <fsipc>
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 2c                	js     8014ff <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	68 00 50 80 00       	push   $0x805000
  8014db:	53                   	push   %ebx
  8014dc:	e8 00 f3 ff ff       	call   8007e1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014e1:	a1 80 50 80 00       	mov    0x805080,%eax
  8014e6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014ec:	a1 84 50 80 00       	mov    0x805084,%eax
  8014f1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <devfile_write>:
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	53                   	push   %ebx
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80150e:	85 db                	test   %ebx,%ebx
  801510:	75 07                	jne    801519 <devfile_write+0x15>
	return n_all;
  801512:	89 d8                	mov    %ebx,%eax
}
  801514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8b 40 0c             	mov    0xc(%eax),%eax
  80151f:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801524:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	53                   	push   %ebx
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	68 08 50 80 00       	push   $0x805008
  801536:	e8 34 f4 ff ff       	call   80096f <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80153b:	ba 00 00 00 00       	mov    $0x0,%edx
  801540:	b8 04 00 00 00       	mov    $0x4,%eax
  801545:	e8 c8 fe ff ff       	call   801412 <fsipc>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 c3                	js     801514 <devfile_write+0x10>
	  assert(r <= n_left);
  801551:	39 d8                	cmp    %ebx,%eax
  801553:	77 0b                	ja     801560 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801555:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80155a:	7f 1d                	jg     801579 <devfile_write+0x75>
    n_all += r;
  80155c:	89 c3                	mov    %eax,%ebx
  80155e:	eb b2                	jmp    801512 <devfile_write+0xe>
	  assert(r <= n_left);
  801560:	68 20 28 80 00       	push   $0x802820
  801565:	68 2c 28 80 00       	push   $0x80282c
  80156a:	68 9f 00 00 00       	push   $0x9f
  80156f:	68 41 28 80 00       	push   $0x802841
  801574:	e8 b1 eb ff ff       	call   80012a <_panic>
	  assert(r <= PGSIZE);
  801579:	68 4c 28 80 00       	push   $0x80284c
  80157e:	68 2c 28 80 00       	push   $0x80282c
  801583:	68 a0 00 00 00       	push   $0xa0
  801588:	68 41 28 80 00       	push   $0x802841
  80158d:	e8 98 eb ff ff       	call   80012a <_panic>

00801592 <devfile_read>:
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
  801597:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015a5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b0:	b8 03 00 00 00       	mov    $0x3,%eax
  8015b5:	e8 58 fe ff ff       	call   801412 <fsipc>
  8015ba:	89 c3                	mov    %eax,%ebx
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 1f                	js     8015df <devfile_read+0x4d>
	assert(r <= n);
  8015c0:	39 f0                	cmp    %esi,%eax
  8015c2:	77 24                	ja     8015e8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015c9:	7f 33                	jg     8015fe <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	50                   	push   %eax
  8015cf:	68 00 50 80 00       	push   $0x805000
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	e8 93 f3 ff ff       	call   80096f <memmove>
	return r;
  8015dc:	83 c4 10             	add    $0x10,%esp
}
  8015df:	89 d8                	mov    %ebx,%eax
  8015e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e4:	5b                   	pop    %ebx
  8015e5:	5e                   	pop    %esi
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    
	assert(r <= n);
  8015e8:	68 58 28 80 00       	push   $0x802858
  8015ed:	68 2c 28 80 00       	push   $0x80282c
  8015f2:	6a 7c                	push   $0x7c
  8015f4:	68 41 28 80 00       	push   $0x802841
  8015f9:	e8 2c eb ff ff       	call   80012a <_panic>
	assert(r <= PGSIZE);
  8015fe:	68 4c 28 80 00       	push   $0x80284c
  801603:	68 2c 28 80 00       	push   $0x80282c
  801608:	6a 7d                	push   $0x7d
  80160a:	68 41 28 80 00       	push   $0x802841
  80160f:	e8 16 eb ff ff       	call   80012a <_panic>

00801614 <open>:
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	83 ec 1c             	sub    $0x1c,%esp
  80161c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80161f:	56                   	push   %esi
  801620:	e8 83 f1 ff ff       	call   8007a8 <strlen>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80162d:	7f 6c                	jg     80169b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801635:	50                   	push   %eax
  801636:	e8 6c f8 ff ff       	call   800ea7 <fd_alloc>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 3c                	js     801680 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	56                   	push   %esi
  801648:	68 00 50 80 00       	push   $0x805000
  80164d:	e8 8f f1 ff ff       	call   8007e1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165d:	b8 01 00 00 00       	mov    $0x1,%eax
  801662:	e8 ab fd ff ff       	call   801412 <fsipc>
  801667:	89 c3                	mov    %eax,%ebx
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 19                	js     801689 <open+0x75>
	return fd2num(fd);
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	ff 75 f4             	pushl  -0xc(%ebp)
  801676:	e8 05 f8 ff ff       	call   800e80 <fd2num>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	83 c4 10             	add    $0x10,%esp
}
  801680:	89 d8                	mov    %ebx,%eax
  801682:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    
		fd_close(fd, 0);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	6a 00                	push   $0x0
  80168e:	ff 75 f4             	pushl  -0xc(%ebp)
  801691:	e8 0e f9 ff ff       	call   800fa4 <fd_close>
		return r;
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	eb e5                	jmp    801680 <open+0x6c>
		return -E_BAD_PATH;
  80169b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016a0:	eb de                	jmp    801680 <open+0x6c>

008016a2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8016b2:	e8 5b fd ff ff       	call   801412 <fsipc>
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	56                   	push   %esi
  8016bd:	53                   	push   %ebx
  8016be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016c1:	83 ec 0c             	sub    $0xc,%esp
  8016c4:	ff 75 08             	pushl  0x8(%ebp)
  8016c7:	e8 c4 f7 ff ff       	call   800e90 <fd2data>
  8016cc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016ce:	83 c4 08             	add    $0x8,%esp
  8016d1:	68 5f 28 80 00       	push   $0x80285f
  8016d6:	53                   	push   %ebx
  8016d7:	e8 05 f1 ff ff       	call   8007e1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016dc:	8b 46 04             	mov    0x4(%esi),%eax
  8016df:	2b 06                	sub    (%esi),%eax
  8016e1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ee:	00 00 00 
	stat->st_dev = &devpipe;
  8016f1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016f8:	30 80 00 
	return 0;
}
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	53                   	push   %ebx
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801711:	53                   	push   %ebx
  801712:	6a 00                	push   $0x0
  801714:	e8 3f f5 ff ff       	call   800c58 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801719:	89 1c 24             	mov    %ebx,(%esp)
  80171c:	e8 6f f7 ff ff       	call   800e90 <fd2data>
  801721:	83 c4 08             	add    $0x8,%esp
  801724:	50                   	push   %eax
  801725:	6a 00                	push   $0x0
  801727:	e8 2c f5 ff ff       	call   800c58 <sys_page_unmap>
}
  80172c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <_pipeisclosed>:
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	57                   	push   %edi
  801735:	56                   	push   %esi
  801736:	53                   	push   %ebx
  801737:	83 ec 1c             	sub    $0x1c,%esp
  80173a:	89 c7                	mov    %eax,%edi
  80173c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80173e:	a1 08 40 80 00       	mov    0x804008,%eax
  801743:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	57                   	push   %edi
  80174a:	e8 ac 09 00 00       	call   8020fb <pageref>
  80174f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801752:	89 34 24             	mov    %esi,(%esp)
  801755:	e8 a1 09 00 00       	call   8020fb <pageref>
		nn = thisenv->env_runs;
  80175a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801760:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	39 cb                	cmp    %ecx,%ebx
  801768:	74 1b                	je     801785 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80176a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80176d:	75 cf                	jne    80173e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80176f:	8b 42 58             	mov    0x58(%edx),%eax
  801772:	6a 01                	push   $0x1
  801774:	50                   	push   %eax
  801775:	53                   	push   %ebx
  801776:	68 66 28 80 00       	push   $0x802866
  80177b:	e8 85 ea ff ff       	call   800205 <cprintf>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	eb b9                	jmp    80173e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801785:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801788:	0f 94 c0             	sete   %al
  80178b:	0f b6 c0             	movzbl %al,%eax
}
  80178e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <devpipe_write>:
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 28             	sub    $0x28,%esp
  80179f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017a2:	56                   	push   %esi
  8017a3:	e8 e8 f6 ff ff       	call   800e90 <fd2data>
  8017a8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8017b2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017b5:	74 4f                	je     801806 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017b7:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ba:	8b 0b                	mov    (%ebx),%ecx
  8017bc:	8d 51 20             	lea    0x20(%ecx),%edx
  8017bf:	39 d0                	cmp    %edx,%eax
  8017c1:	72 14                	jb     8017d7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017c3:	89 da                	mov    %ebx,%edx
  8017c5:	89 f0                	mov    %esi,%eax
  8017c7:	e8 65 ff ff ff       	call   801731 <_pipeisclosed>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	75 3b                	jne    80180b <devpipe_write+0x75>
			sys_yield();
  8017d0:	e8 df f3 ff ff       	call   800bb4 <sys_yield>
  8017d5:	eb e0                	jmp    8017b7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	c1 fa 1f             	sar    $0x1f,%edx
  8017e6:	89 d1                	mov    %edx,%ecx
  8017e8:	c1 e9 1b             	shr    $0x1b,%ecx
  8017eb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017ee:	83 e2 1f             	and    $0x1f,%edx
  8017f1:	29 ca                	sub    %ecx,%edx
  8017f3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017f7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017fb:	83 c0 01             	add    $0x1,%eax
  8017fe:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801801:	83 c7 01             	add    $0x1,%edi
  801804:	eb ac                	jmp    8017b2 <devpipe_write+0x1c>
	return i;
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	eb 05                	jmp    801810 <devpipe_write+0x7a>
				return 0;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <devpipe_read>:
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	57                   	push   %edi
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 18             	sub    $0x18,%esp
  801821:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801824:	57                   	push   %edi
  801825:	e8 66 f6 ff ff       	call   800e90 <fd2data>
  80182a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	be 00 00 00 00       	mov    $0x0,%esi
  801834:	3b 75 10             	cmp    0x10(%ebp),%esi
  801837:	75 14                	jne    80184d <devpipe_read+0x35>
	return i;
  801839:	8b 45 10             	mov    0x10(%ebp),%eax
  80183c:	eb 02                	jmp    801840 <devpipe_read+0x28>
				return i;
  80183e:	89 f0                	mov    %esi,%eax
}
  801840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    
			sys_yield();
  801848:	e8 67 f3 ff ff       	call   800bb4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80184d:	8b 03                	mov    (%ebx),%eax
  80184f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801852:	75 18                	jne    80186c <devpipe_read+0x54>
			if (i > 0)
  801854:	85 f6                	test   %esi,%esi
  801856:	75 e6                	jne    80183e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801858:	89 da                	mov    %ebx,%edx
  80185a:	89 f8                	mov    %edi,%eax
  80185c:	e8 d0 fe ff ff       	call   801731 <_pipeisclosed>
  801861:	85 c0                	test   %eax,%eax
  801863:	74 e3                	je     801848 <devpipe_read+0x30>
				return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	eb d4                	jmp    801840 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80186c:	99                   	cltd   
  80186d:	c1 ea 1b             	shr    $0x1b,%edx
  801870:	01 d0                	add    %edx,%eax
  801872:	83 e0 1f             	and    $0x1f,%eax
  801875:	29 d0                	sub    %edx,%eax
  801877:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80187c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801882:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801885:	83 c6 01             	add    $0x1,%esi
  801888:	eb aa                	jmp    801834 <devpipe_read+0x1c>

0080188a <pipe>:
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	56                   	push   %esi
  80188e:	53                   	push   %ebx
  80188f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801895:	50                   	push   %eax
  801896:	e8 0c f6 ff ff       	call   800ea7 <fd_alloc>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	0f 88 23 01 00 00    	js     8019cb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	68 07 04 00 00       	push   $0x407
  8018b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b3:	6a 00                	push   $0x0
  8018b5:	e8 19 f3 ff ff       	call   800bd3 <sys_page_alloc>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	0f 88 04 01 00 00    	js     8019cb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	e8 d4 f5 ff ff       	call   800ea7 <fd_alloc>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	0f 88 db 00 00 00    	js     8019bb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	68 07 04 00 00       	push   $0x407
  8018e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018eb:	6a 00                	push   $0x0
  8018ed:	e8 e1 f2 ff ff       	call   800bd3 <sys_page_alloc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	0f 88 bc 00 00 00    	js     8019bb <pipe+0x131>
	va = fd2data(fd0);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 75 f4             	pushl  -0xc(%ebp)
  801905:	e8 86 f5 ff ff       	call   800e90 <fd2data>
  80190a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80190c:	83 c4 0c             	add    $0xc,%esp
  80190f:	68 07 04 00 00       	push   $0x407
  801914:	50                   	push   %eax
  801915:	6a 00                	push   $0x0
  801917:	e8 b7 f2 ff ff       	call   800bd3 <sys_page_alloc>
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	0f 88 82 00 00 00    	js     8019ab <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	ff 75 f0             	pushl  -0x10(%ebp)
  80192f:	e8 5c f5 ff ff       	call   800e90 <fd2data>
  801934:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80193b:	50                   	push   %eax
  80193c:	6a 00                	push   $0x0
  80193e:	56                   	push   %esi
  80193f:	6a 00                	push   $0x0
  801941:	e8 d0 f2 ff ff       	call   800c16 <sys_page_map>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	83 c4 20             	add    $0x20,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 4e                	js     80199d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80194f:	a1 20 30 80 00       	mov    0x803020,%eax
  801954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801957:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801966:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	ff 75 f4             	pushl  -0xc(%ebp)
  801978:	e8 03 f5 ff ff       	call   800e80 <fd2num>
  80197d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801980:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801982:	83 c4 04             	add    $0x4,%esp
  801985:	ff 75 f0             	pushl  -0x10(%ebp)
  801988:	e8 f3 f4 ff ff       	call   800e80 <fd2num>
  80198d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801990:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	bb 00 00 00 00       	mov    $0x0,%ebx
  80199b:	eb 2e                	jmp    8019cb <pipe+0x141>
	sys_page_unmap(0, va);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	56                   	push   %esi
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 b0 f2 ff ff       	call   800c58 <sys_page_unmap>
  8019a8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 a0 f2 ff ff       	call   800c58 <sys_page_unmap>
  8019b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	6a 00                	push   $0x0
  8019c3:	e8 90 f2 ff ff       	call   800c58 <sys_page_unmap>
  8019c8:	83 c4 10             	add    $0x10,%esp
}
  8019cb:	89 d8                	mov    %ebx,%eax
  8019cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <pipeisclosed>:
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019dd:	50                   	push   %eax
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	e8 13 f5 ff ff       	call   800ef9 <fd_lookup>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 18                	js     801a05 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f3:	e8 98 f4 ff ff       	call   800e90 <fd2data>
	return _pipeisclosed(fd, p);
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fd:	e8 2f fd ff ff       	call   801731 <_pipeisclosed>
  801a02:	83 c4 10             	add    $0x10,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a0d:	68 7e 28 80 00       	push   $0x80287e
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	e8 c7 ed ff ff       	call   8007e1 <strcpy>
	return 0;
}
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <devsock_close>:
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
  801a25:	83 ec 10             	sub    $0x10,%esp
  801a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a2b:	53                   	push   %ebx
  801a2c:	e8 ca 06 00 00       	call   8020fb <pageref>
  801a31:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a34:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a39:	83 f8 01             	cmp    $0x1,%eax
  801a3c:	74 07                	je     801a45 <devsock_close+0x24>
}
  801a3e:	89 d0                	mov    %edx,%eax
  801a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a45:	83 ec 0c             	sub    $0xc,%esp
  801a48:	ff 73 0c             	pushl  0xc(%ebx)
  801a4b:	e8 b9 02 00 00       	call   801d09 <nsipc_close>
  801a50:	89 c2                	mov    %eax,%edx
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	eb e7                	jmp    801a3e <devsock_close+0x1d>

00801a57 <devsock_write>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 10             	pushl  0x10(%ebp)
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	ff 70 0c             	pushl  0xc(%eax)
  801a6b:	e8 76 03 00 00       	call   801de6 <nsipc_send>
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <devsock_read>:
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 10             	pushl  0x10(%ebp)
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	ff 70 0c             	pushl  0xc(%eax)
  801a86:	e8 ef 02 00 00       	call   801d7a <nsipc_recv>
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <fd2sockid>:
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a93:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a96:	52                   	push   %edx
  801a97:	50                   	push   %eax
  801a98:	e8 5c f4 ff ff       	call   800ef9 <fd_lookup>
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 10                	js     801ab4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa7:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801aad:	39 08                	cmp    %ecx,(%eax)
  801aaf:	75 05                	jne    801ab6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ab1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    
		return -E_NOT_SUPP;
  801ab6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abb:	eb f7                	jmp    801ab4 <fd2sockid+0x27>

00801abd <alloc_sockfd>:
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	83 ec 1c             	sub    $0x1c,%esp
  801ac5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aca:	50                   	push   %eax
  801acb:	e8 d7 f3 ff ff       	call   800ea7 <fd_alloc>
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 43                	js     801b1c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 07 04 00 00       	push   $0x407
  801ae1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 e8 f0 ff ff       	call   800bd3 <sys_page_alloc>
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 28                	js     801b1c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801afd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b02:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b09:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	50                   	push   %eax
  801b10:	e8 6b f3 ff ff       	call   800e80 <fd2num>
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	eb 0c                	jmp    801b28 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b1c:	83 ec 0c             	sub    $0xc,%esp
  801b1f:	56                   	push   %esi
  801b20:	e8 e4 01 00 00       	call   801d09 <nsipc_close>
		return r;
  801b25:	83 c4 10             	add    $0x10,%esp
}
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <accept>:
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	e8 4e ff ff ff       	call   801a8d <fd2sockid>
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 1b                	js     801b5e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	50                   	push   %eax
  801b4d:	e8 0e 01 00 00       	call   801c60 <nsipc_accept>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 05                	js     801b5e <accept+0x2d>
	return alloc_sockfd(r);
  801b59:	e8 5f ff ff ff       	call   801abd <alloc_sockfd>
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <bind>:
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	e8 1f ff ff ff       	call   801a8d <fd2sockid>
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 12                	js     801b84 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	50                   	push   %eax
  801b7c:	e8 31 01 00 00       	call   801cb2 <nsipc_bind>
  801b81:	83 c4 10             	add    $0x10,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <shutdown>:
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	e8 f9 fe ff ff       	call   801a8d <fd2sockid>
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 0f                	js     801ba7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	50                   	push   %eax
  801b9f:	e8 43 01 00 00       	call   801ce7 <nsipc_shutdown>
  801ba4:	83 c4 10             	add    $0x10,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <connect>:
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	e8 d6 fe ff ff       	call   801a8d <fd2sockid>
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 12                	js     801bcd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	ff 75 10             	pushl  0x10(%ebp)
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	50                   	push   %eax
  801bc5:	e8 59 01 00 00       	call   801d23 <nsipc_connect>
  801bca:	83 c4 10             	add    $0x10,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <listen>:
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	e8 b0 fe ff ff       	call   801a8d <fd2sockid>
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 0f                	js     801bf0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	50                   	push   %eax
  801be8:	e8 6b 01 00 00       	call   801d58 <nsipc_listen>
  801bed:	83 c4 10             	add    $0x10,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bf8:	ff 75 10             	pushl  0x10(%ebp)
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	e8 3e 02 00 00       	call   801e44 <nsipc_socket>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 05                	js     801c12 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c0d:	e8 ab fe ff ff       	call   801abd <alloc_sockfd>
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	53                   	push   %ebx
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c1d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c24:	74 26                	je     801c4c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c26:	6a 07                	push   $0x7
  801c28:	68 00 60 80 00       	push   $0x806000
  801c2d:	53                   	push   %ebx
  801c2e:	ff 35 04 40 80 00    	pushl  0x804004
  801c34:	e8 1d 04 00 00       	call   802056 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c39:	83 c4 0c             	add    $0xc,%esp
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	e8 9c 03 00 00       	call   801fe3 <ipc_recv>
}
  801c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	6a 02                	push   $0x2
  801c51:	e8 6c 04 00 00       	call   8020c2 <ipc_find_env>
  801c56:	a3 04 40 80 00       	mov    %eax,0x804004
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	eb c6                	jmp    801c26 <nsipc+0x12>

00801c60 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	56                   	push   %esi
  801c64:	53                   	push   %ebx
  801c65:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c70:	8b 06                	mov    (%esi),%eax
  801c72:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c77:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7c:	e8 93 ff ff ff       	call   801c14 <nsipc>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	85 c0                	test   %eax,%eax
  801c85:	79 09                	jns    801c90 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	ff 35 10 60 80 00    	pushl  0x806010
  801c99:	68 00 60 80 00       	push   $0x806000
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	e8 c9 ec ff ff       	call   80096f <memmove>
		*addrlen = ret->ret_addrlen;
  801ca6:	a1 10 60 80 00       	mov    0x806010,%eax
  801cab:	89 06                	mov    %eax,(%esi)
  801cad:	83 c4 10             	add    $0x10,%esp
	return r;
  801cb0:	eb d5                	jmp    801c87 <nsipc_accept+0x27>

00801cb2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	53                   	push   %ebx
  801cb6:	83 ec 08             	sub    $0x8,%esp
  801cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cc4:	53                   	push   %ebx
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	68 04 60 80 00       	push   $0x806004
  801ccd:	e8 9d ec ff ff       	call   80096f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cd2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cd8:	b8 02 00 00 00       	mov    $0x2,%eax
  801cdd:	e8 32 ff ff ff       	call   801c14 <nsipc>
}
  801ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cfd:	b8 03 00 00 00       	mov    $0x3,%eax
  801d02:	e8 0d ff ff ff       	call   801c14 <nsipc>
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <nsipc_close>:

int
nsipc_close(int s)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d17:	b8 04 00 00 00       	mov    $0x4,%eax
  801d1c:	e8 f3 fe ff ff       	call   801c14 <nsipc>
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 08             	sub    $0x8,%esp
  801d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d35:	53                   	push   %ebx
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	68 04 60 80 00       	push   $0x806004
  801d3e:	e8 2c ec ff ff       	call   80096f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d43:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d49:	b8 05 00 00 00       	mov    $0x5,%eax
  801d4e:	e8 c1 fe ff ff       	call   801c14 <nsipc>
}
  801d53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d6e:	b8 06 00 00 00       	mov    $0x6,%eax
  801d73:	e8 9c fe ff ff       	call   801c14 <nsipc>
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	56                   	push   %esi
  801d7e:	53                   	push   %ebx
  801d7f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d8a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d90:	8b 45 14             	mov    0x14(%ebp),%eax
  801d93:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d98:	b8 07 00 00 00       	mov    $0x7,%eax
  801d9d:	e8 72 fe ff ff       	call   801c14 <nsipc>
  801da2:	89 c3                	mov    %eax,%ebx
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 1f                	js     801dc7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801da8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dad:	7f 21                	jg     801dd0 <nsipc_recv+0x56>
  801daf:	39 c6                	cmp    %eax,%esi
  801db1:	7c 1d                	jl     801dd0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	50                   	push   %eax
  801db7:	68 00 60 80 00       	push   $0x806000
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	e8 ab eb ff ff       	call   80096f <memmove>
  801dc4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dc7:	89 d8                	mov    %ebx,%eax
  801dc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcc:	5b                   	pop    %ebx
  801dcd:	5e                   	pop    %esi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dd0:	68 8a 28 80 00       	push   $0x80288a
  801dd5:	68 2c 28 80 00       	push   $0x80282c
  801dda:	6a 62                	push   $0x62
  801ddc:	68 9f 28 80 00       	push   $0x80289f
  801de1:	e8 44 e3 ff ff       	call   80012a <_panic>

00801de6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	53                   	push   %ebx
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801df8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dfe:	7f 2e                	jg     801e2e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	53                   	push   %ebx
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	68 0c 60 80 00       	push   $0x80600c
  801e0c:	e8 5e eb ff ff       	call   80096f <memmove>
	nsipcbuf.send.req_size = size;
  801e11:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e17:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e1f:	b8 08 00 00 00       	mov    $0x8,%eax
  801e24:	e8 eb fd ff ff       	call   801c14 <nsipc>
}
  801e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    
	assert(size < 1600);
  801e2e:	68 ab 28 80 00       	push   $0x8028ab
  801e33:	68 2c 28 80 00       	push   $0x80282c
  801e38:	6a 6d                	push   $0x6d
  801e3a:	68 9f 28 80 00       	push   $0x80289f
  801e3f:	e8 e6 e2 ff ff       	call   80012a <_panic>

00801e44 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e62:	b8 09 00 00 00       	mov    $0x9,%eax
  801e67:	e8 a8 fd ff ff       	call   801c14 <nsipc>
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	c3                   	ret    

00801e74 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e7a:	68 b7 28 80 00       	push   $0x8028b7
  801e7f:	ff 75 0c             	pushl  0xc(%ebp)
  801e82:	e8 5a e9 ff ff       	call   8007e1 <strcpy>
	return 0;
}
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <devcons_write>:
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	57                   	push   %edi
  801e92:	56                   	push   %esi
  801e93:	53                   	push   %ebx
  801e94:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e9a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e9f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ea5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea8:	73 31                	jae    801edb <devcons_write+0x4d>
		m = n - tot;
  801eaa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ead:	29 f3                	sub    %esi,%ebx
  801eaf:	83 fb 7f             	cmp    $0x7f,%ebx
  801eb2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801eb7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	53                   	push   %ebx
  801ebe:	89 f0                	mov    %esi,%eax
  801ec0:	03 45 0c             	add    0xc(%ebp),%eax
  801ec3:	50                   	push   %eax
  801ec4:	57                   	push   %edi
  801ec5:	e8 a5 ea ff ff       	call   80096f <memmove>
		sys_cputs(buf, m);
  801eca:	83 c4 08             	add    $0x8,%esp
  801ecd:	53                   	push   %ebx
  801ece:	57                   	push   %edi
  801ecf:	e8 43 ec ff ff       	call   800b17 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ed4:	01 de                	add    %ebx,%esi
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	eb ca                	jmp    801ea5 <devcons_write+0x17>
}
  801edb:	89 f0                	mov    %esi,%eax
  801edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <devcons_read>:
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 08             	sub    $0x8,%esp
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ef0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ef4:	74 21                	je     801f17 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ef6:	e8 3a ec ff ff       	call   800b35 <sys_cgetc>
  801efb:	85 c0                	test   %eax,%eax
  801efd:	75 07                	jne    801f06 <devcons_read+0x21>
		sys_yield();
  801eff:	e8 b0 ec ff ff       	call   800bb4 <sys_yield>
  801f04:	eb f0                	jmp    801ef6 <devcons_read+0x11>
	if (c < 0)
  801f06:	78 0f                	js     801f17 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f08:	83 f8 04             	cmp    $0x4,%eax
  801f0b:	74 0c                	je     801f19 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	88 02                	mov    %al,(%edx)
	return 1;
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    
		return 0;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb f7                	jmp    801f17 <devcons_read+0x32>

00801f20 <cputchar>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f2c:	6a 01                	push   $0x1
  801f2e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f31:	50                   	push   %eax
  801f32:	e8 e0 eb ff ff       	call   800b17 <sys_cputs>
}
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <getchar>:
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f42:	6a 01                	push   $0x1
  801f44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f47:	50                   	push   %eax
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 1a f2 ff ff       	call   801169 <read>
	if (r < 0)
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 06                	js     801f5c <getchar+0x20>
	if (r < 1)
  801f56:	74 06                	je     801f5e <getchar+0x22>
	return c;
  801f58:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    
		return -E_EOF;
  801f5e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f63:	eb f7                	jmp    801f5c <getchar+0x20>

00801f65 <iscons>:
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6e:	50                   	push   %eax
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	e8 82 ef ff ff       	call   800ef9 <fd_lookup>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 11                	js     801f8f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f87:	39 10                	cmp    %edx,(%eax)
  801f89:	0f 94 c0             	sete   %al
  801f8c:	0f b6 c0             	movzbl %al,%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <opencons>:
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9a:	50                   	push   %eax
  801f9b:	e8 07 ef ff ff       	call   800ea7 <fd_alloc>
  801fa0:	83 c4 10             	add    $0x10,%esp
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 3a                	js     801fe1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	68 07 04 00 00       	push   $0x407
  801faf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb2:	6a 00                	push   $0x0
  801fb4:	e8 1a ec ff ff       	call   800bd3 <sys_page_alloc>
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 21                	js     801fe1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fc9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	50                   	push   %eax
  801fd9:	e8 a2 ee ff ff       	call   800e80 <fd2num>
  801fde:	83 c4 10             	add    $0x10,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	8b 75 08             	mov    0x8(%ebp),%esi
  801feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	74 4f                	je     802044 <ipc_recv+0x61>
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	50                   	push   %eax
  801ff9:	e8 85 ed ff ff       	call   800d83 <sys_ipc_recv>
  801ffe:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802001:	85 f6                	test   %esi,%esi
  802003:	74 14                	je     802019 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802005:	ba 00 00 00 00       	mov    $0x0,%edx
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 09                	jne    802017 <ipc_recv+0x34>
  80200e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802014:	8b 52 74             	mov    0x74(%edx),%edx
  802017:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802019:	85 db                	test   %ebx,%ebx
  80201b:	74 14                	je     802031 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80201d:	ba 00 00 00 00       	mov    $0x0,%edx
  802022:	85 c0                	test   %eax,%eax
  802024:	75 09                	jne    80202f <ipc_recv+0x4c>
  802026:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80202c:	8b 52 78             	mov    0x78(%edx),%edx
  80202f:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802031:	85 c0                	test   %eax,%eax
  802033:	75 08                	jne    80203d <ipc_recv+0x5a>
  802035:	a1 08 40 80 00       	mov    0x804008,%eax
  80203a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80203d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	68 00 00 c0 ee       	push   $0xeec00000
  80204c:	e8 32 ed ff ff       	call   800d83 <sys_ipc_recv>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	eb ab                	jmp    802001 <ipc_recv+0x1e>

00802056 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	57                   	push   %edi
  80205a:	56                   	push   %esi
  80205b:	53                   	push   %ebx
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802062:	8b 75 10             	mov    0x10(%ebp),%esi
  802065:	eb 20                	jmp    802087 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802067:	6a 00                	push   $0x0
  802069:	68 00 00 c0 ee       	push   $0xeec00000
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	57                   	push   %edi
  802072:	e8 e9 ec ff ff       	call   800d60 <sys_ipc_try_send>
  802077:	89 c3                	mov    %eax,%ebx
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	eb 1f                	jmp    80209d <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80207e:	e8 31 eb ff ff       	call   800bb4 <sys_yield>
	while(retval != 0) {
  802083:	85 db                	test   %ebx,%ebx
  802085:	74 33                	je     8020ba <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802087:	85 f6                	test   %esi,%esi
  802089:	74 dc                	je     802067 <ipc_send+0x11>
  80208b:	ff 75 14             	pushl  0x14(%ebp)
  80208e:	56                   	push   %esi
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	57                   	push   %edi
  802093:	e8 c8 ec ff ff       	call   800d60 <sys_ipc_try_send>
  802098:	89 c3                	mov    %eax,%ebx
  80209a:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80209d:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8020a0:	74 dc                	je     80207e <ipc_send+0x28>
  8020a2:	85 db                	test   %ebx,%ebx
  8020a4:	74 d8                	je     80207e <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 c4 28 80 00       	push   $0x8028c4
  8020ae:	6a 35                	push   $0x35
  8020b0:	68 f4 28 80 00       	push   $0x8028f4
  8020b5:	e8 70 e0 ff ff       	call   80012a <_panic>
	}
}
  8020ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020cd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020d0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020d6:	8b 52 50             	mov    0x50(%edx),%edx
  8020d9:	39 ca                	cmp    %ecx,%edx
  8020db:	74 11                	je     8020ee <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020dd:	83 c0 01             	add    $0x1,%eax
  8020e0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020e5:	75 e6                	jne    8020cd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	eb 0b                	jmp    8020f9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020ee:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020f6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802101:	89 d0                	mov    %edx,%eax
  802103:	c1 e8 16             	shr    $0x16,%eax
  802106:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802112:	f6 c1 01             	test   $0x1,%cl
  802115:	74 1d                	je     802134 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802117:	c1 ea 0c             	shr    $0xc,%edx
  80211a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802121:	f6 c2 01             	test   $0x1,%dl
  802124:	74 0e                	je     802134 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802126:	c1 ea 0c             	shr    $0xc,%edx
  802129:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802130:	ef 
  802131:	0f b7 c0             	movzwl %ax,%eax
}
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    
  802136:	66 90                	xchg   %ax,%ax
  802138:	66 90                	xchg   %ax,%ax
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <__udivdi3>:
  802140:	f3 0f 1e fb          	endbr32 
  802144:	55                   	push   %ebp
  802145:	57                   	push   %edi
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	83 ec 1c             	sub    $0x1c,%esp
  80214b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80214f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802153:	8b 74 24 34          	mov    0x34(%esp),%esi
  802157:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80215b:	85 d2                	test   %edx,%edx
  80215d:	75 49                	jne    8021a8 <__udivdi3+0x68>
  80215f:	39 f3                	cmp    %esi,%ebx
  802161:	76 15                	jbe    802178 <__udivdi3+0x38>
  802163:	31 ff                	xor    %edi,%edi
  802165:	89 e8                	mov    %ebp,%eax
  802167:	89 f2                	mov    %esi,%edx
  802169:	f7 f3                	div    %ebx
  80216b:	89 fa                	mov    %edi,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	89 d9                	mov    %ebx,%ecx
  80217a:	85 db                	test   %ebx,%ebx
  80217c:	75 0b                	jne    802189 <__udivdi3+0x49>
  80217e:	b8 01 00 00 00       	mov    $0x1,%eax
  802183:	31 d2                	xor    %edx,%edx
  802185:	f7 f3                	div    %ebx
  802187:	89 c1                	mov    %eax,%ecx
  802189:	31 d2                	xor    %edx,%edx
  80218b:	89 f0                	mov    %esi,%eax
  80218d:	f7 f1                	div    %ecx
  80218f:	89 c6                	mov    %eax,%esi
  802191:	89 e8                	mov    %ebp,%eax
  802193:	89 f7                	mov    %esi,%edi
  802195:	f7 f1                	div    %ecx
  802197:	89 fa                	mov    %edi,%edx
  802199:	83 c4 1c             	add    $0x1c,%esp
  80219c:	5b                   	pop    %ebx
  80219d:	5e                   	pop    %esi
  80219e:	5f                   	pop    %edi
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    
  8021a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	77 1c                	ja     8021c8 <__udivdi3+0x88>
  8021ac:	0f bd fa             	bsr    %edx,%edi
  8021af:	83 f7 1f             	xor    $0x1f,%edi
  8021b2:	75 2c                	jne    8021e0 <__udivdi3+0xa0>
  8021b4:	39 f2                	cmp    %esi,%edx
  8021b6:	72 06                	jb     8021be <__udivdi3+0x7e>
  8021b8:	31 c0                	xor    %eax,%eax
  8021ba:	39 eb                	cmp    %ebp,%ebx
  8021bc:	77 ad                	ja     80216b <__udivdi3+0x2b>
  8021be:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c3:	eb a6                	jmp    80216b <__udivdi3+0x2b>
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	31 ff                	xor    %edi,%edi
  8021ca:	31 c0                	xor    %eax,%eax
  8021cc:	89 fa                	mov    %edi,%edx
  8021ce:	83 c4 1c             	add    $0x1c,%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    
  8021d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021dd:	8d 76 00             	lea    0x0(%esi),%esi
  8021e0:	89 f9                	mov    %edi,%ecx
  8021e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021e7:	29 f8                	sub    %edi,%eax
  8021e9:	d3 e2                	shl    %cl,%edx
  8021eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021ef:	89 c1                	mov    %eax,%ecx
  8021f1:	89 da                	mov    %ebx,%edx
  8021f3:	d3 ea                	shr    %cl,%edx
  8021f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021f9:	09 d1                	or     %edx,%ecx
  8021fb:	89 f2                	mov    %esi,%edx
  8021fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802201:	89 f9                	mov    %edi,%ecx
  802203:	d3 e3                	shl    %cl,%ebx
  802205:	89 c1                	mov    %eax,%ecx
  802207:	d3 ea                	shr    %cl,%edx
  802209:	89 f9                	mov    %edi,%ecx
  80220b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80220f:	89 eb                	mov    %ebp,%ebx
  802211:	d3 e6                	shl    %cl,%esi
  802213:	89 c1                	mov    %eax,%ecx
  802215:	d3 eb                	shr    %cl,%ebx
  802217:	09 de                	or     %ebx,%esi
  802219:	89 f0                	mov    %esi,%eax
  80221b:	f7 74 24 08          	divl   0x8(%esp)
  80221f:	89 d6                	mov    %edx,%esi
  802221:	89 c3                	mov    %eax,%ebx
  802223:	f7 64 24 0c          	mull   0xc(%esp)
  802227:	39 d6                	cmp    %edx,%esi
  802229:	72 15                	jb     802240 <__udivdi3+0x100>
  80222b:	89 f9                	mov    %edi,%ecx
  80222d:	d3 e5                	shl    %cl,%ebp
  80222f:	39 c5                	cmp    %eax,%ebp
  802231:	73 04                	jae    802237 <__udivdi3+0xf7>
  802233:	39 d6                	cmp    %edx,%esi
  802235:	74 09                	je     802240 <__udivdi3+0x100>
  802237:	89 d8                	mov    %ebx,%eax
  802239:	31 ff                	xor    %edi,%edi
  80223b:	e9 2b ff ff ff       	jmp    80216b <__udivdi3+0x2b>
  802240:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802243:	31 ff                	xor    %edi,%edi
  802245:	e9 21 ff ff ff       	jmp    80216b <__udivdi3+0x2b>
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <__umoddi3>:
  802250:	f3 0f 1e fb          	endbr32 
  802254:	55                   	push   %ebp
  802255:	57                   	push   %edi
  802256:	56                   	push   %esi
  802257:	53                   	push   %ebx
  802258:	83 ec 1c             	sub    $0x1c,%esp
  80225b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80225f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802263:	8b 74 24 30          	mov    0x30(%esp),%esi
  802267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80226b:	89 da                	mov    %ebx,%edx
  80226d:	85 c0                	test   %eax,%eax
  80226f:	75 3f                	jne    8022b0 <__umoddi3+0x60>
  802271:	39 df                	cmp    %ebx,%edi
  802273:	76 13                	jbe    802288 <__umoddi3+0x38>
  802275:	89 f0                	mov    %esi,%eax
  802277:	f7 f7                	div    %edi
  802279:	89 d0                	mov    %edx,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	83 c4 1c             	add    $0x1c,%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    
  802285:	8d 76 00             	lea    0x0(%esi),%esi
  802288:	89 fd                	mov    %edi,%ebp
  80228a:	85 ff                	test   %edi,%edi
  80228c:	75 0b                	jne    802299 <__umoddi3+0x49>
  80228e:	b8 01 00 00 00       	mov    $0x1,%eax
  802293:	31 d2                	xor    %edx,%edx
  802295:	f7 f7                	div    %edi
  802297:	89 c5                	mov    %eax,%ebp
  802299:	89 d8                	mov    %ebx,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f5                	div    %ebp
  80229f:	89 f0                	mov    %esi,%eax
  8022a1:	f7 f5                	div    %ebp
  8022a3:	89 d0                	mov    %edx,%eax
  8022a5:	eb d4                	jmp    80227b <__umoddi3+0x2b>
  8022a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	89 f1                	mov    %esi,%ecx
  8022b2:	39 d8                	cmp    %ebx,%eax
  8022b4:	76 0a                	jbe    8022c0 <__umoddi3+0x70>
  8022b6:	89 f0                	mov    %esi,%eax
  8022b8:	83 c4 1c             	add    $0x1c,%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5f                   	pop    %edi
  8022be:	5d                   	pop    %ebp
  8022bf:	c3                   	ret    
  8022c0:	0f bd e8             	bsr    %eax,%ebp
  8022c3:	83 f5 1f             	xor    $0x1f,%ebp
  8022c6:	75 20                	jne    8022e8 <__umoddi3+0x98>
  8022c8:	39 d8                	cmp    %ebx,%eax
  8022ca:	0f 82 b0 00 00 00    	jb     802380 <__umoddi3+0x130>
  8022d0:	39 f7                	cmp    %esi,%edi
  8022d2:	0f 86 a8 00 00 00    	jbe    802380 <__umoddi3+0x130>
  8022d8:	89 c8                	mov    %ecx,%eax
  8022da:	83 c4 1c             	add    $0x1c,%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    
  8022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022e8:	89 e9                	mov    %ebp,%ecx
  8022ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8022ef:	29 ea                	sub    %ebp,%edx
  8022f1:	d3 e0                	shl    %cl,%eax
  8022f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f7:	89 d1                	mov    %edx,%ecx
  8022f9:	89 f8                	mov    %edi,%eax
  8022fb:	d3 e8                	shr    %cl,%eax
  8022fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802301:	89 54 24 04          	mov    %edx,0x4(%esp)
  802305:	8b 54 24 04          	mov    0x4(%esp),%edx
  802309:	09 c1                	or     %eax,%ecx
  80230b:	89 d8                	mov    %ebx,%eax
  80230d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802311:	89 e9                	mov    %ebp,%ecx
  802313:	d3 e7                	shl    %cl,%edi
  802315:	89 d1                	mov    %edx,%ecx
  802317:	d3 e8                	shr    %cl,%eax
  802319:	89 e9                	mov    %ebp,%ecx
  80231b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80231f:	d3 e3                	shl    %cl,%ebx
  802321:	89 c7                	mov    %eax,%edi
  802323:	89 d1                	mov    %edx,%ecx
  802325:	89 f0                	mov    %esi,%eax
  802327:	d3 e8                	shr    %cl,%eax
  802329:	89 e9                	mov    %ebp,%ecx
  80232b:	89 fa                	mov    %edi,%edx
  80232d:	d3 e6                	shl    %cl,%esi
  80232f:	09 d8                	or     %ebx,%eax
  802331:	f7 74 24 08          	divl   0x8(%esp)
  802335:	89 d1                	mov    %edx,%ecx
  802337:	89 f3                	mov    %esi,%ebx
  802339:	f7 64 24 0c          	mull   0xc(%esp)
  80233d:	89 c6                	mov    %eax,%esi
  80233f:	89 d7                	mov    %edx,%edi
  802341:	39 d1                	cmp    %edx,%ecx
  802343:	72 06                	jb     80234b <__umoddi3+0xfb>
  802345:	75 10                	jne    802357 <__umoddi3+0x107>
  802347:	39 c3                	cmp    %eax,%ebx
  802349:	73 0c                	jae    802357 <__umoddi3+0x107>
  80234b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80234f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802353:	89 d7                	mov    %edx,%edi
  802355:	89 c6                	mov    %eax,%esi
  802357:	89 ca                	mov    %ecx,%edx
  802359:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80235e:	29 f3                	sub    %esi,%ebx
  802360:	19 fa                	sbb    %edi,%edx
  802362:	89 d0                	mov    %edx,%eax
  802364:	d3 e0                	shl    %cl,%eax
  802366:	89 e9                	mov    %ebp,%ecx
  802368:	d3 eb                	shr    %cl,%ebx
  80236a:	d3 ea                	shr    %cl,%edx
  80236c:	09 d8                	or     %ebx,%eax
  80236e:	83 c4 1c             	add    $0x1c,%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
  802376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	89 da                	mov    %ebx,%edx
  802382:	29 fe                	sub    %edi,%esi
  802384:	19 c2                	sbb    %eax,%edx
  802386:	89 f1                	mov    %esi,%ecx
  802388:	89 c8                	mov    %ecx,%eax
  80238a:	e9 4b ff ff ff       	jmp    8022da <__umoddi3+0x8a>
