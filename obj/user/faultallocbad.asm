
obj/user/faultallocbad.debug：     文件格式 elf32-i386


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
  800040:	68 80 23 80 00       	push   $0x802380
  800045:	e8 a6 01 00 00       	call   8001f0 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 60 0b 00 00       	call   800bbe <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 cc 23 80 00       	push   $0x8023cc
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 06 07 00 00       	call   800779 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 a0 23 80 00       	push   $0x8023a0
  800085:	6a 0f                	push   $0xf
  800087:	68 8a 23 80 00       	push   $0x80238a
  80008c:	e8 84 00 00 00       	call   800115 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 2d 0d 00 00       	call   800dce <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 52 0a 00 00       	call   800b02 <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
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
  8000c0:	e8 bb 0a 00 00       	call   800b80 <sys_getenvid>
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
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

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
  800101:	e8 3d 0f 00 00       	call   801043 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 2f 0a 00 00       	call   800b3f <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80011a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80011d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800123:	e8 58 0a 00 00       	call   800b80 <sys_getenvid>
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	56                   	push   %esi
  800132:	50                   	push   %eax
  800133:	68 f8 23 80 00       	push   $0x8023f8
  800138:	e8 b3 00 00 00       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80013d:	83 c4 18             	add    $0x18,%esp
  800140:	53                   	push   %ebx
  800141:	ff 75 10             	pushl  0x10(%ebp)
  800144:	e8 56 00 00 00       	call   80019f <vcprintf>
	cprintf("\n");
  800149:	c7 04 24 57 28 80 00 	movl   $0x802857,(%esp)
  800150:	e8 9b 00 00 00       	call   8001f0 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800158:	cc                   	int3   
  800159:	eb fd                	jmp    800158 <_panic+0x43>

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 6e 09 00 00       	call   800b02 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 19 01 00 00       	call   8002ec <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 1a 09 00 00       	call   800b02 <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80022e:	89 d0                	mov    %edx,%eax
  800230:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800233:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800236:	73 15                	jae    80024d <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800238:	83 eb 01             	sub    $0x1,%ebx
  80023b:	85 db                	test   %ebx,%ebx
  80023d:	7e 43                	jle    800282 <printnum+0x7e>
			putch(padc, putdat);
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	56                   	push   %esi
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	ff d7                	call   *%edi
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	eb eb                	jmp    800238 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 18             	pushl  0x18(%ebp)
  800253:	8b 45 14             	mov    0x14(%ebp),%eax
  800256:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800259:	53                   	push   %ebx
  80025a:	ff 75 10             	pushl  0x10(%ebp)
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	ff 75 e4             	pushl  -0x1c(%ebp)
  800263:	ff 75 e0             	pushl  -0x20(%ebp)
  800266:	ff 75 dc             	pushl  -0x24(%ebp)
  800269:	ff 75 d8             	pushl  -0x28(%ebp)
  80026c:	e8 bf 1e 00 00       	call   802130 <__udivdi3>
  800271:	83 c4 18             	add    $0x18,%esp
  800274:	52                   	push   %edx
  800275:	50                   	push   %eax
  800276:	89 f2                	mov    %esi,%edx
  800278:	89 f8                	mov    %edi,%eax
  80027a:	e8 85 ff ff ff       	call   800204 <printnum>
  80027f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	56                   	push   %esi
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028c:	ff 75 e0             	pushl  -0x20(%ebp)
  80028f:	ff 75 dc             	pushl  -0x24(%ebp)
  800292:	ff 75 d8             	pushl  -0x28(%ebp)
  800295:	e8 a6 1f 00 00       	call   802240 <__umoddi3>
  80029a:	83 c4 14             	add    $0x14,%esp
  80029d:	0f be 80 1b 24 80 00 	movsbl 0x80241b(%eax),%eax
  8002a4:	50                   	push   %eax
  8002a5:	ff d7                	call   *%edi
}
  8002a7:	83 c4 10             	add    $0x10,%esp
  8002aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ad:	5b                   	pop    %ebx
  8002ae:	5e                   	pop    %esi
  8002af:	5f                   	pop    %edi
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    

008002b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bc:	8b 10                	mov    (%eax),%edx
  8002be:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c1:	73 0a                	jae    8002cd <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c6:	89 08                	mov    %ecx,(%eax)
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	88 02                	mov    %al,(%edx)
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <printfmt>:
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d8:	50                   	push   %eax
  8002d9:	ff 75 10             	pushl  0x10(%ebp)
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	e8 05 00 00 00       	call   8002ec <vprintfmt>
}
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <vprintfmt>:
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 3c             	sub    $0x3c,%esp
  8002f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002fe:	eb 0a                	jmp    80030a <vprintfmt+0x1e>
			putch(ch, putdat);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	53                   	push   %ebx
  800304:	50                   	push   %eax
  800305:	ff d6                	call   *%esi
  800307:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80030a:	83 c7 01             	add    $0x1,%edi
  80030d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800311:	83 f8 25             	cmp    $0x25,%eax
  800314:	74 0c                	je     800322 <vprintfmt+0x36>
			if (ch == '\0')
  800316:	85 c0                	test   %eax,%eax
  800318:	75 e6                	jne    800300 <vprintfmt+0x14>
}
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    
		padc = ' ';
  800322:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800326:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80032d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800334:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800340:	8d 47 01             	lea    0x1(%edi),%eax
  800343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800346:	0f b6 17             	movzbl (%edi),%edx
  800349:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034c:	3c 55                	cmp    $0x55,%al
  80034e:	0f 87 ba 03 00 00    	ja     80070e <vprintfmt+0x422>
  800354:	0f b6 c0             	movzbl %al,%eax
  800357:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800361:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800365:	eb d9                	jmp    800340 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80036a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80036e:	eb d0                	jmp    800340 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	0f b6 d2             	movzbl %dl,%edx
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80037e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800381:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800385:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800388:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80038b:	83 f9 09             	cmp    $0x9,%ecx
  80038e:	77 55                	ja     8003e5 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800390:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800393:	eb e9                	jmp    80037e <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	8d 40 04             	lea    0x4(%eax),%eax
  8003a3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ad:	79 91                	jns    800340 <vprintfmt+0x54>
				width = precision, precision = -1;
  8003af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003bc:	eb 82                	jmp    800340 <vprintfmt+0x54>
  8003be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c1:	85 c0                	test   %eax,%eax
  8003c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c8:	0f 49 d0             	cmovns %eax,%edx
  8003cb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d1:	e9 6a ff ff ff       	jmp    800340 <vprintfmt+0x54>
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e0:	e9 5b ff ff ff       	jmp    800340 <vprintfmt+0x54>
  8003e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003eb:	eb bc                	jmp    8003a9 <vprintfmt+0xbd>
			lflag++;
  8003ed:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f3:	e9 48 ff ff ff       	jmp    800340 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 78 04             	lea    0x4(%eax),%edi
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	53                   	push   %ebx
  800402:	ff 30                	pushl  (%eax)
  800404:	ff d6                	call   *%esi
			break;
  800406:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040c:	e9 9c 02 00 00       	jmp    8006ad <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	8d 78 04             	lea    0x4(%eax),%edi
  800417:	8b 00                	mov    (%eax),%eax
  800419:	99                   	cltd   
  80041a:	31 d0                	xor    %edx,%eax
  80041c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041e:	83 f8 0f             	cmp    $0xf,%eax
  800421:	7f 23                	jg     800446 <vprintfmt+0x15a>
  800423:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  80042a:	85 d2                	test   %edx,%edx
  80042c:	74 18                	je     800446 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80042e:	52                   	push   %edx
  80042f:	68 1e 28 80 00       	push   $0x80281e
  800434:	53                   	push   %ebx
  800435:	56                   	push   %esi
  800436:	e8 94 fe ff ff       	call   8002cf <printfmt>
  80043b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800441:	e9 67 02 00 00       	jmp    8006ad <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800446:	50                   	push   %eax
  800447:	68 33 24 80 00       	push   $0x802433
  80044c:	53                   	push   %ebx
  80044d:	56                   	push   %esi
  80044e:	e8 7c fe ff ff       	call   8002cf <printfmt>
  800453:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800456:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800459:	e9 4f 02 00 00       	jmp    8006ad <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	83 c0 04             	add    $0x4,%eax
  800464:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80046c:	85 d2                	test   %edx,%edx
  80046e:	b8 2c 24 80 00       	mov    $0x80242c,%eax
  800473:	0f 45 c2             	cmovne %edx,%eax
  800476:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800479:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047d:	7e 06                	jle    800485 <vprintfmt+0x199>
  80047f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800483:	75 0d                	jne    800492 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800485:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800488:	89 c7                	mov    %eax,%edi
  80048a:	03 45 e0             	add    -0x20(%ebp),%eax
  80048d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800490:	eb 3f                	jmp    8004d1 <vprintfmt+0x1e5>
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	ff 75 d8             	pushl  -0x28(%ebp)
  800498:	50                   	push   %eax
  800499:	e8 0d 03 00 00       	call   8007ab <strnlen>
  80049e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004a6:	83 c4 10             	add    $0x10,%esp
  8004a9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004ab:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	85 ff                	test   %edi,%edi
  8004b4:	7e 58                	jle    80050e <vprintfmt+0x222>
					putch(padc, putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	83 ef 01             	sub    $0x1,%edi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	eb eb                	jmp    8004b2 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	53                   	push   %ebx
  8004cb:	52                   	push   %edx
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d6:	83 c7 01             	add    $0x1,%edi
  8004d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004dd:	0f be d0             	movsbl %al,%edx
  8004e0:	85 d2                	test   %edx,%edx
  8004e2:	74 45                	je     800529 <vprintfmt+0x23d>
  8004e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e8:	78 06                	js     8004f0 <vprintfmt+0x204>
  8004ea:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ee:	78 35                	js     800525 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f4:	74 d1                	je     8004c7 <vprintfmt+0x1db>
  8004f6:	0f be c0             	movsbl %al,%eax
  8004f9:	83 e8 20             	sub    $0x20,%eax
  8004fc:	83 f8 5e             	cmp    $0x5e,%eax
  8004ff:	76 c6                	jbe    8004c7 <vprintfmt+0x1db>
					putch('?', putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	6a 3f                	push   $0x3f
  800507:	ff d6                	call   *%esi
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb c3                	jmp    8004d1 <vprintfmt+0x1e5>
  80050e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	0f 49 c2             	cmovns %edx,%eax
  80051b:	29 c2                	sub    %eax,%edx
  80051d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800520:	e9 60 ff ff ff       	jmp    800485 <vprintfmt+0x199>
  800525:	89 cf                	mov    %ecx,%edi
  800527:	eb 02                	jmp    80052b <vprintfmt+0x23f>
  800529:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80052b:	85 ff                	test   %edi,%edi
  80052d:	7e 10                	jle    80053f <vprintfmt+0x253>
				putch(' ', putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	53                   	push   %ebx
  800533:	6a 20                	push   $0x20
  800535:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800537:	83 ef 01             	sub    $0x1,%edi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb ec                	jmp    80052b <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 63 01 00 00       	jmp    8006ad <vprintfmt+0x3c1>
	if (lflag >= 2)
  80054a:	83 f9 01             	cmp    $0x1,%ecx
  80054d:	7f 1b                	jg     80056a <vprintfmt+0x27e>
	else if (lflag)
  80054f:	85 c9                	test   %ecx,%ecx
  800551:	74 63                	je     8005b6 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055b:	99                   	cltd   
  80055c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 40 04             	lea    0x4(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	eb 17                	jmp    800581 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8b 50 04             	mov    0x4(%eax),%edx
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800575:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8d 40 08             	lea    0x8(%eax),%eax
  80057e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800581:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800584:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	0f 89 ff 00 00 00    	jns    800693 <vprintfmt+0x3a7>
				putch('-', putdat);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	53                   	push   %ebx
  800598:	6a 2d                	push   $0x2d
  80059a:	ff d6                	call   *%esi
				num = -(long long) num;
  80059c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a2:	f7 da                	neg    %edx
  8005a4:	83 d1 00             	adc    $0x0,%ecx
  8005a7:	f7 d9                	neg    %ecx
  8005a9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b1:	e9 dd 00 00 00       	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	99                   	cltd   
  8005bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	eb b4                	jmp    800581 <vprintfmt+0x295>
	if (lflag >= 2)
  8005cd:	83 f9 01             	cmp    $0x1,%ecx
  8005d0:	7f 1e                	jg     8005f0 <vprintfmt+0x304>
	else if (lflag)
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	74 32                	je     800608 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 10                	mov    (%eax),%edx
  8005db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 a3 00 00 00       	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f8:	8d 40 08             	lea    0x8(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800603:	e9 8b 00 00 00       	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061d:	eb 74                	jmp    800693 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7f 1b                	jg     80063f <vprintfmt+0x353>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	74 2c                	je     800654 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800638:	b8 08 00 00 00       	mov    $0x8,%eax
  80063d:	eb 54                	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 10                	mov    (%eax),%edx
  800644:	8b 48 04             	mov    0x4(%eax),%ecx
  800647:	8d 40 08             	lea    0x8(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064d:	b8 08 00 00 00       	mov    $0x8,%eax
  800652:	eb 3f                	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800664:	b8 08 00 00 00       	mov    $0x8,%eax
  800669:	eb 28                	jmp    800693 <vprintfmt+0x3a7>
			putch('0', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 30                	push   $0x30
  800671:	ff d6                	call   *%esi
			putch('x', putdat);
  800673:	83 c4 08             	add    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 78                	push   $0x78
  800679:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800685:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80069a:	57                   	push   %edi
  80069b:	ff 75 e0             	pushl  -0x20(%ebp)
  80069e:	50                   	push   %eax
  80069f:	51                   	push   %ecx
  8006a0:	52                   	push   %edx
  8006a1:	89 da                	mov    %ebx,%edx
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	e8 5a fb ff ff       	call   800204 <printnum>
			break;
  8006aa:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b0:	e9 55 fc ff ff       	jmp    80030a <vprintfmt+0x1e>
	if (lflag >= 2)
  8006b5:	83 f9 01             	cmp    $0x1,%ecx
  8006b8:	7f 1b                	jg     8006d5 <vprintfmt+0x3e9>
	else if (lflag)
  8006ba:	85 c9                	test   %ecx,%ecx
  8006bc:	74 2c                	je     8006ea <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 10                	mov    (%eax),%edx
  8006c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d3:	eb be                	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 10                	mov    (%eax),%edx
  8006da:	8b 48 04             	mov    0x4(%eax),%ecx
  8006dd:	8d 40 08             	lea    0x8(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e8:	eb a9                	jmp    800693 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 10                	mov    (%eax),%edx
  8006ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f4:	8d 40 04             	lea    0x4(%eax),%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ff:	eb 92                	jmp    800693 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	53                   	push   %ebx
  800705:	6a 25                	push   $0x25
  800707:	ff d6                	call   *%esi
			break;
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	eb 9f                	jmp    8006ad <vprintfmt+0x3c1>
			putch('%', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 25                	push   $0x25
  800714:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	89 f8                	mov    %edi,%eax
  80071b:	eb 03                	jmp    800720 <vprintfmt+0x434>
  80071d:	83 e8 01             	sub    $0x1,%eax
  800720:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800724:	75 f7                	jne    80071d <vprintfmt+0x431>
  800726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800729:	eb 82                	jmp    8006ad <vprintfmt+0x3c1>

0080072b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800737:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80073a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80073e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800741:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800748:	85 c0                	test   %eax,%eax
  80074a:	74 26                	je     800772 <vsnprintf+0x47>
  80074c:	85 d2                	test   %edx,%edx
  80074e:	7e 22                	jle    800772 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800750:	ff 75 14             	pushl  0x14(%ebp)
  800753:	ff 75 10             	pushl  0x10(%ebp)
  800756:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800759:	50                   	push   %eax
  80075a:	68 b2 02 80 00       	push   $0x8002b2
  80075f:	e8 88 fb ff ff       	call   8002ec <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800767:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076d:	83 c4 10             	add    $0x10,%esp
}
  800770:	c9                   	leave  
  800771:	c3                   	ret    
		return -E_INVAL;
  800772:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800777:	eb f7                	jmp    800770 <vsnprintf+0x45>

00800779 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800782:	50                   	push   %eax
  800783:	ff 75 10             	pushl  0x10(%ebp)
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 9a ff ff ff       	call   80072b <vsnprintf>
	va_end(ap);

	return rc;
}
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
  80079e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a2:	74 05                	je     8007a9 <strlen+0x16>
		n++;
  8007a4:	83 c0 01             	add    $0x1,%eax
  8007a7:	eb f5                	jmp    80079e <strlen+0xb>
	return n;
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	39 c2                	cmp    %eax,%edx
  8007bb:	74 0d                	je     8007ca <strnlen+0x1f>
  8007bd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007c1:	74 05                	je     8007c8 <strnlen+0x1d>
		n++;
  8007c3:	83 c2 01             	add    $0x1,%edx
  8007c6:	eb f1                	jmp    8007b9 <strnlen+0xe>
  8007c8:	89 d0                	mov    %edx,%eax
	return n;
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007db:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007df:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007e2:	83 c2 01             	add    $0x1,%edx
  8007e5:	84 c9                	test   %cl,%cl
  8007e7:	75 f2                	jne    8007db <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007e9:	5b                   	pop    %ebx
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	53                   	push   %ebx
  8007f0:	83 ec 10             	sub    $0x10,%esp
  8007f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f6:	53                   	push   %ebx
  8007f7:	e8 97 ff ff ff       	call   800793 <strlen>
  8007fc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	01 d8                	add    %ebx,%eax
  800804:	50                   	push   %eax
  800805:	e8 c2 ff ff ff       	call   8007cc <strcpy>
	return dst;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080f:	c9                   	leave  
  800810:	c3                   	ret    

00800811 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	56                   	push   %esi
  800815:	53                   	push   %ebx
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081c:	89 c6                	mov    %eax,%esi
  80081e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800821:	89 c2                	mov    %eax,%edx
  800823:	39 f2                	cmp    %esi,%edx
  800825:	74 11                	je     800838 <strncpy+0x27>
		*dst++ = *src;
  800827:	83 c2 01             	add    $0x1,%edx
  80082a:	0f b6 19             	movzbl (%ecx),%ebx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800830:	80 fb 01             	cmp    $0x1,%bl
  800833:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800836:	eb eb                	jmp    800823 <strncpy+0x12>
	}
	return ret;
}
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	56                   	push   %esi
  800840:	53                   	push   %ebx
  800841:	8b 75 08             	mov    0x8(%ebp),%esi
  800844:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800847:	8b 55 10             	mov    0x10(%ebp),%edx
  80084a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084c:	85 d2                	test   %edx,%edx
  80084e:	74 21                	je     800871 <strlcpy+0x35>
  800850:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800854:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800856:	39 c2                	cmp    %eax,%edx
  800858:	74 14                	je     80086e <strlcpy+0x32>
  80085a:	0f b6 19             	movzbl (%ecx),%ebx
  80085d:	84 db                	test   %bl,%bl
  80085f:	74 0b                	je     80086c <strlcpy+0x30>
			*dst++ = *src++;
  800861:	83 c1 01             	add    $0x1,%ecx
  800864:	83 c2 01             	add    $0x1,%edx
  800867:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086a:	eb ea                	jmp    800856 <strlcpy+0x1a>
  80086c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80086e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800871:	29 f0                	sub    %esi,%eax
}
  800873:	5b                   	pop    %ebx
  800874:	5e                   	pop    %esi
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800880:	0f b6 01             	movzbl (%ecx),%eax
  800883:	84 c0                	test   %al,%al
  800885:	74 0c                	je     800893 <strcmp+0x1c>
  800887:	3a 02                	cmp    (%edx),%al
  800889:	75 08                	jne    800893 <strcmp+0x1c>
		p++, q++;
  80088b:	83 c1 01             	add    $0x1,%ecx
  80088e:	83 c2 01             	add    $0x1,%edx
  800891:	eb ed                	jmp    800880 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800893:	0f b6 c0             	movzbl %al,%eax
  800896:	0f b6 12             	movzbl (%edx),%edx
  800899:	29 d0                	sub    %edx,%eax
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	53                   	push   %ebx
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a7:	89 c3                	mov    %eax,%ebx
  8008a9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ac:	eb 06                	jmp    8008b4 <strncmp+0x17>
		n--, p++, q++;
  8008ae:	83 c0 01             	add    $0x1,%eax
  8008b1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b4:	39 d8                	cmp    %ebx,%eax
  8008b6:	74 16                	je     8008ce <strncmp+0x31>
  8008b8:	0f b6 08             	movzbl (%eax),%ecx
  8008bb:	84 c9                	test   %cl,%cl
  8008bd:	74 04                	je     8008c3 <strncmp+0x26>
  8008bf:	3a 0a                	cmp    (%edx),%cl
  8008c1:	74 eb                	je     8008ae <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c3:	0f b6 00             	movzbl (%eax),%eax
  8008c6:	0f b6 12             	movzbl (%edx),%edx
  8008c9:	29 d0                	sub    %edx,%eax
}
  8008cb:	5b                   	pop    %ebx
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    
		return 0;
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d3:	eb f6                	jmp    8008cb <strncmp+0x2e>

008008d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008df:	0f b6 10             	movzbl (%eax),%edx
  8008e2:	84 d2                	test   %dl,%dl
  8008e4:	74 09                	je     8008ef <strchr+0x1a>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0a                	je     8008f4 <strchr+0x1f>
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f0                	jmp    8008df <strchr+0xa>
			return (char *) s;
	return 0;
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800900:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800903:	38 ca                	cmp    %cl,%dl
  800905:	74 09                	je     800910 <strfind+0x1a>
  800907:	84 d2                	test   %dl,%dl
  800909:	74 05                	je     800910 <strfind+0x1a>
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	eb f0                	jmp    800900 <strfind+0xa>
			break;
	return (char *) s;
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	57                   	push   %edi
  800916:	56                   	push   %esi
  800917:	53                   	push   %ebx
  800918:	8b 7d 08             	mov    0x8(%ebp),%edi
  80091b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80091e:	85 c9                	test   %ecx,%ecx
  800920:	74 31                	je     800953 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800922:	89 f8                	mov    %edi,%eax
  800924:	09 c8                	or     %ecx,%eax
  800926:	a8 03                	test   $0x3,%al
  800928:	75 23                	jne    80094d <memset+0x3b>
		c &= 0xFF;
  80092a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092e:	89 d3                	mov    %edx,%ebx
  800930:	c1 e3 08             	shl    $0x8,%ebx
  800933:	89 d0                	mov    %edx,%eax
  800935:	c1 e0 18             	shl    $0x18,%eax
  800938:	89 d6                	mov    %edx,%esi
  80093a:	c1 e6 10             	shl    $0x10,%esi
  80093d:	09 f0                	or     %esi,%eax
  80093f:	09 c2                	or     %eax,%edx
  800941:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800943:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800946:	89 d0                	mov    %edx,%eax
  800948:	fc                   	cld    
  800949:	f3 ab                	rep stos %eax,%es:(%edi)
  80094b:	eb 06                	jmp    800953 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	fc                   	cld    
  800951:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800953:	89 f8                	mov    %edi,%eax
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5f                   	pop    %edi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	57                   	push   %edi
  80095e:	56                   	push   %esi
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 75 0c             	mov    0xc(%ebp),%esi
  800965:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800968:	39 c6                	cmp    %eax,%esi
  80096a:	73 32                	jae    80099e <memmove+0x44>
  80096c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096f:	39 c2                	cmp    %eax,%edx
  800971:	76 2b                	jbe    80099e <memmove+0x44>
		s += n;
		d += n;
  800973:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800976:	89 fe                	mov    %edi,%esi
  800978:	09 ce                	or     %ecx,%esi
  80097a:	09 d6                	or     %edx,%esi
  80097c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800982:	75 0e                	jne    800992 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800984:	83 ef 04             	sub    $0x4,%edi
  800987:	8d 72 fc             	lea    -0x4(%edx),%esi
  80098a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80098d:	fd                   	std    
  80098e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800990:	eb 09                	jmp    80099b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800992:	83 ef 01             	sub    $0x1,%edi
  800995:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800998:	fd                   	std    
  800999:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099b:	fc                   	cld    
  80099c:	eb 1a                	jmp    8009b8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 c2                	mov    %eax,%edx
  8009a0:	09 ca                	or     %ecx,%edx
  8009a2:	09 f2                	or     %esi,%edx
  8009a4:	f6 c2 03             	test   $0x3,%dl
  8009a7:	75 0a                	jne    8009b3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ac:	89 c7                	mov    %eax,%edi
  8009ae:	fc                   	cld    
  8009af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b1:	eb 05                	jmp    8009b8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8009b3:	89 c7                	mov    %eax,%edi
  8009b5:	fc                   	cld    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009c2:	ff 75 10             	pushl  0x10(%ebp)
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	e8 8a ff ff ff       	call   80095a <memmove>
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dd:	89 c6                	mov    %eax,%esi
  8009df:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e2:	39 f0                	cmp    %esi,%eax
  8009e4:	74 1c                	je     800a02 <memcmp+0x30>
		if (*s1 != *s2)
  8009e6:	0f b6 08             	movzbl (%eax),%ecx
  8009e9:	0f b6 1a             	movzbl (%edx),%ebx
  8009ec:	38 d9                	cmp    %bl,%cl
  8009ee:	75 08                	jne    8009f8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f0:	83 c0 01             	add    $0x1,%eax
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	eb ea                	jmp    8009e2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009f8:	0f b6 c1             	movzbl %cl,%eax
  8009fb:	0f b6 db             	movzbl %bl,%ebx
  8009fe:	29 d8                	sub    %ebx,%eax
  800a00:	eb 05                	jmp    800a07 <memcmp+0x35>
	}

	return 0;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 09                	jae    800a26 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a1d:	38 08                	cmp    %cl,(%eax)
  800a1f:	74 05                	je     800a26 <memfind+0x1b>
	for (; s < ends; s++)
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	eb f3                	jmp    800a19 <memfind+0xe>
			break;
	return (void *) s;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	57                   	push   %edi
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
  800a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a34:	eb 03                	jmp    800a39 <strtol+0x11>
		s++;
  800a36:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a39:	0f b6 01             	movzbl (%ecx),%eax
  800a3c:	3c 20                	cmp    $0x20,%al
  800a3e:	74 f6                	je     800a36 <strtol+0xe>
  800a40:	3c 09                	cmp    $0x9,%al
  800a42:	74 f2                	je     800a36 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a44:	3c 2b                	cmp    $0x2b,%al
  800a46:	74 2a                	je     800a72 <strtol+0x4a>
	int neg = 0;
  800a48:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4d:	3c 2d                	cmp    $0x2d,%al
  800a4f:	74 2b                	je     800a7c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a51:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a57:	75 0f                	jne    800a68 <strtol+0x40>
  800a59:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5c:	74 28                	je     800a86 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a65:	0f 44 d8             	cmove  %eax,%ebx
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a70:	eb 50                	jmp    800ac2 <strtol+0x9a>
		s++;
  800a72:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a75:	bf 00 00 00 00       	mov    $0x0,%edi
  800a7a:	eb d5                	jmp    800a51 <strtol+0x29>
		s++, neg = 1;
  800a7c:	83 c1 01             	add    $0x1,%ecx
  800a7f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a84:	eb cb                	jmp    800a51 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a86:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a8a:	74 0e                	je     800a9a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800a8c:	85 db                	test   %ebx,%ebx
  800a8e:	75 d8                	jne    800a68 <strtol+0x40>
		s++, base = 8;
  800a90:	83 c1 01             	add    $0x1,%ecx
  800a93:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a98:	eb ce                	jmp    800a68 <strtol+0x40>
		s += 2, base = 16;
  800a9a:	83 c1 02             	add    $0x2,%ecx
  800a9d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa2:	eb c4                	jmp    800a68 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aa4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa7:	89 f3                	mov    %esi,%ebx
  800aa9:	80 fb 19             	cmp    $0x19,%bl
  800aac:	77 29                	ja     800ad7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800aae:	0f be d2             	movsbl %dl,%edx
  800ab1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab7:	7d 30                	jge    800ae9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ab9:	83 c1 01             	add    $0x1,%ecx
  800abc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac2:	0f b6 11             	movzbl (%ecx),%edx
  800ac5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac8:	89 f3                	mov    %esi,%ebx
  800aca:	80 fb 09             	cmp    $0x9,%bl
  800acd:	77 d5                	ja     800aa4 <strtol+0x7c>
			dig = *s - '0';
  800acf:	0f be d2             	movsbl %dl,%edx
  800ad2:	83 ea 30             	sub    $0x30,%edx
  800ad5:	eb dd                	jmp    800ab4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ad7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ada:	89 f3                	mov    %esi,%ebx
  800adc:	80 fb 19             	cmp    $0x19,%bl
  800adf:	77 08                	ja     800ae9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ae1:	0f be d2             	movsbl %dl,%edx
  800ae4:	83 ea 37             	sub    $0x37,%edx
  800ae7:	eb cb                	jmp    800ab4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ae9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aed:	74 05                	je     800af4 <strtol+0xcc>
		*endptr = (char *) s;
  800aef:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af4:	89 c2                	mov    %eax,%edx
  800af6:	f7 da                	neg    %edx
  800af8:	85 ff                	test   %edi,%edi
  800afa:	0f 45 c2             	cmovne %edx,%eax
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5f                   	pop    %edi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b08:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b13:	89 c3                	mov    %eax,%ebx
  800b15:	89 c7                	mov    %eax,%edi
  800b17:	89 c6                	mov    %eax,%esi
  800b19:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5f                   	pop    %edi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	57                   	push   %edi
  800b24:	56                   	push   %esi
  800b25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b26:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b30:	89 d1                	mov    %edx,%ecx
  800b32:	89 d3                	mov    %edx,%ebx
  800b34:	89 d7                	mov    %edx,%edi
  800b36:	89 d6                	mov    %edx,%esi
  800b38:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	57                   	push   %edi
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	b8 03 00 00 00       	mov    $0x3,%eax
  800b55:	89 cb                	mov    %ecx,%ebx
  800b57:	89 cf                	mov    %ecx,%edi
  800b59:	89 ce                	mov    %ecx,%esi
  800b5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	7f 08                	jg     800b69 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5f                   	pop    %edi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b69:	83 ec 0c             	sub    $0xc,%esp
  800b6c:	50                   	push   %eax
  800b6d:	6a 03                	push   $0x3
  800b6f:	68 1f 27 80 00       	push   $0x80271f
  800b74:	6a 23                	push   $0x23
  800b76:	68 3c 27 80 00       	push   $0x80273c
  800b7b:	e8 95 f5 ff ff       	call   800115 <_panic>

00800b80 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b86:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8b:	b8 02 00 00 00       	mov    $0x2,%eax
  800b90:	89 d1                	mov    %edx,%ecx
  800b92:	89 d3                	mov    %edx,%ebx
  800b94:	89 d7                	mov    %edx,%edi
  800b96:	89 d6                	mov    %edx,%esi
  800b98:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <sys_yield>:

void
sys_yield(void)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800baf:	89 d1                	mov    %edx,%ecx
  800bb1:	89 d3                	mov    %edx,%ebx
  800bb3:	89 d7                	mov    %edx,%edi
  800bb5:	89 d6                	mov    %edx,%esi
  800bb7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5f                   	pop    %edi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc7:	be 00 00 00 00       	mov    $0x0,%esi
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd2:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bda:	89 f7                	mov    %esi,%edi
  800bdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bde:	85 c0                	test   %eax,%eax
  800be0:	7f 08                	jg     800bea <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	50                   	push   %eax
  800bee:	6a 04                	push   $0x4
  800bf0:	68 1f 27 80 00       	push   $0x80271f
  800bf5:	6a 23                	push   $0x23
  800bf7:	68 3c 27 80 00       	push   $0x80273c
  800bfc:	e8 14 f5 ff ff       	call   800115 <_panic>

00800c01 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	57                   	push   %edi
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
  800c07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c10:	b8 05 00 00 00       	mov    $0x5,%eax
  800c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c1b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c20:	85 c0                	test   %eax,%eax
  800c22:	7f 08                	jg     800c2c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2c:	83 ec 0c             	sub    $0xc,%esp
  800c2f:	50                   	push   %eax
  800c30:	6a 05                	push   $0x5
  800c32:	68 1f 27 80 00       	push   $0x80271f
  800c37:	6a 23                	push   $0x23
  800c39:	68 3c 27 80 00       	push   $0x80273c
  800c3e:	e8 d2 f4 ff ff       	call   800115 <_panic>

00800c43 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c57:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5c:	89 df                	mov    %ebx,%edi
  800c5e:	89 de                	mov    %ebx,%esi
  800c60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c62:	85 c0                	test   %eax,%eax
  800c64:	7f 08                	jg     800c6e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 06                	push   $0x6
  800c74:	68 1f 27 80 00       	push   $0x80271f
  800c79:	6a 23                	push   $0x23
  800c7b:	68 3c 27 80 00       	push   $0x80273c
  800c80:	e8 90 f4 ff ff       	call   800115 <_panic>

00800c85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	b8 08 00 00 00       	mov    $0x8,%eax
  800c9e:	89 df                	mov    %ebx,%edi
  800ca0:	89 de                	mov    %ebx,%esi
  800ca2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	7f 08                	jg     800cb0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	50                   	push   %eax
  800cb4:	6a 08                	push   $0x8
  800cb6:	68 1f 27 80 00       	push   $0x80271f
  800cbb:	6a 23                	push   $0x23
  800cbd:	68 3c 27 80 00       	push   $0x80273c
  800cc2:	e8 4e f4 ff ff       	call   800115 <_panic>

00800cc7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdb:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce0:	89 df                	mov    %ebx,%edi
  800ce2:	89 de                	mov    %ebx,%esi
  800ce4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	7f 08                	jg     800cf2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf2:	83 ec 0c             	sub    $0xc,%esp
  800cf5:	50                   	push   %eax
  800cf6:	6a 09                	push   $0x9
  800cf8:	68 1f 27 80 00       	push   $0x80271f
  800cfd:	6a 23                	push   $0x23
  800cff:	68 3c 27 80 00       	push   $0x80273c
  800d04:	e8 0c f4 ff ff       	call   800115 <_panic>

00800d09 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
  800d0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d22:	89 df                	mov    %ebx,%edi
  800d24:	89 de                	mov    %ebx,%esi
  800d26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	7f 08                	jg     800d34 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d34:	83 ec 0c             	sub    $0xc,%esp
  800d37:	50                   	push   %eax
  800d38:	6a 0a                	push   $0xa
  800d3a:	68 1f 27 80 00       	push   $0x80271f
  800d3f:	6a 23                	push   $0x23
  800d41:	68 3c 27 80 00       	push   $0x80273c
  800d46:	e8 ca f3 ff ff       	call   800115 <_panic>

00800d4b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d67:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d84:	89 cb                	mov    %ecx,%ebx
  800d86:	89 cf                	mov    %ecx,%edi
  800d88:	89 ce                	mov    %ecx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 0d                	push   $0xd
  800d9e:	68 1f 27 80 00       	push   $0x80271f
  800da3:	6a 23                	push   $0x23
  800da5:	68 3c 27 80 00       	push   $0x80273c
  800daa:	e8 66 f3 ff ff       	call   800115 <_panic>

00800daf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db5:	ba 00 00 00 00       	mov    $0x0,%edx
  800dba:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dbf:	89 d1                	mov    %edx,%ecx
  800dc1:	89 d3                	mov    %edx,%ebx
  800dc3:	89 d7                	mov    %edx,%edi
  800dc5:	89 d6                	mov    %edx,%esi
  800dc7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800dd4:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800ddb:	74 0a                	je     800de7 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800de7:	a1 08 40 80 00       	mov    0x804008,%eax
  800dec:	8b 40 48             	mov    0x48(%eax),%eax
  800def:	83 ec 04             	sub    $0x4,%esp
  800df2:	6a 07                	push   $0x7
  800df4:	68 00 f0 bf ee       	push   $0xeebff000
  800df9:	50                   	push   %eax
  800dfa:	e8 bf fd ff ff       	call   800bbe <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	85 c0                	test   %eax,%eax
  800e04:	78 2c                	js     800e32 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800e06:	e8 75 fd ff ff       	call   800b80 <sys_getenvid>
  800e0b:	83 ec 08             	sub    $0x8,%esp
  800e0e:	68 44 0e 80 00       	push   $0x800e44
  800e13:	50                   	push   %eax
  800e14:	e8 f0 fe ff ff       	call   800d09 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	79 bd                	jns    800ddd <set_pgfault_handler+0xf>
  800e20:	50                   	push   %eax
  800e21:	68 4a 27 80 00       	push   $0x80274a
  800e26:	6a 23                	push   $0x23
  800e28:	68 62 27 80 00       	push   $0x802762
  800e2d:	e8 e3 f2 ff ff       	call   800115 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  800e32:	50                   	push   %eax
  800e33:	68 4a 27 80 00       	push   $0x80274a
  800e38:	6a 21                	push   $0x21
  800e3a:	68 62 27 80 00       	push   $0x802762
  800e3f:	e8 d1 f2 ff ff       	call   800115 <_panic>

00800e44 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e44:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e45:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e4a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e4c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  800e4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  800e53:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  800e56:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  800e5a:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  800e5e:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800e61:	83 c4 08             	add    $0x8,%esp
	popal
  800e64:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800e65:	83 c4 04             	add    $0x4,%esp
	popfl
  800e68:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800e69:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800e6a:	c3                   	ret    

00800e6b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	05 00 00 00 30       	add    $0x30000000,%eax
  800e76:	c1 e8 0c             	shr    $0xc,%eax
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e8b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	c1 ea 16             	shr    $0x16,%edx
  800e9f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ea6:	f6 c2 01             	test   $0x1,%dl
  800ea9:	74 2d                	je     800ed8 <fd_alloc+0x46>
  800eab:	89 c2                	mov    %eax,%edx
  800ead:	c1 ea 0c             	shr    $0xc,%edx
  800eb0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb7:	f6 c2 01             	test   $0x1,%dl
  800eba:	74 1c                	je     800ed8 <fd_alloc+0x46>
  800ebc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ec1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ec6:	75 d2                	jne    800e9a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ed1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ed6:	eb 0a                	jmp    800ee2 <fd_alloc+0x50>
			*fd_store = fd;
  800ed8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edb:	89 01                	mov    %eax,(%ecx)
			return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eea:	83 f8 1f             	cmp    $0x1f,%eax
  800eed:	77 30                	ja     800f1f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eef:	c1 e0 0c             	shl    $0xc,%eax
  800ef2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ef7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800efd:	f6 c2 01             	test   $0x1,%dl
  800f00:	74 24                	je     800f26 <fd_lookup+0x42>
  800f02:	89 c2                	mov    %eax,%edx
  800f04:	c1 ea 0c             	shr    $0xc,%edx
  800f07:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0e:	f6 c2 01             	test   $0x1,%dl
  800f11:	74 1a                	je     800f2d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f16:	89 02                	mov    %eax,(%edx)
	return 0;
  800f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    
		return -E_INVAL;
  800f1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f24:	eb f7                	jmp    800f1d <fd_lookup+0x39>
		return -E_INVAL;
  800f26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2b:	eb f0                	jmp    800f1d <fd_lookup+0x39>
  800f2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f32:	eb e9                	jmp    800f1d <fd_lookup+0x39>

00800f34 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 08             	sub    $0x8,%esp
  800f3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f47:	39 08                	cmp    %ecx,(%eax)
  800f49:	74 38                	je     800f83 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f4b:	83 c2 01             	add    $0x1,%edx
  800f4e:	8b 04 95 ec 27 80 00 	mov    0x8027ec(,%edx,4),%eax
  800f55:	85 c0                	test   %eax,%eax
  800f57:	75 ee                	jne    800f47 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f59:	a1 08 40 80 00       	mov    0x804008,%eax
  800f5e:	8b 40 48             	mov    0x48(%eax),%eax
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	51                   	push   %ecx
  800f65:	50                   	push   %eax
  800f66:	68 70 27 80 00       	push   $0x802770
  800f6b:	e8 80 f2 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    
			*dev = devtab[i];
  800f83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f86:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	eb f2                	jmp    800f81 <dev_lookup+0x4d>

00800f8f <fd_close>:
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
  800f95:	83 ec 24             	sub    $0x24,%esp
  800f98:	8b 75 08             	mov    0x8(%ebp),%esi
  800f9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f9e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fa1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fa8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fab:	50                   	push   %eax
  800fac:	e8 33 ff ff ff       	call   800ee4 <fd_lookup>
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	78 05                	js     800fbf <fd_close+0x30>
	    || fd != fd2)
  800fba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fbd:	74 16                	je     800fd5 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fbf:	89 f8                	mov    %edi,%eax
  800fc1:	84 c0                	test   %al,%al
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc8:	0f 44 d8             	cmove  %eax,%ebx
}
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd0:	5b                   	pop    %ebx
  800fd1:	5e                   	pop    %esi
  800fd2:	5f                   	pop    %edi
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	ff 36                	pushl  (%esi)
  800fde:	e8 51 ff ff ff       	call   800f34 <dev_lookup>
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	78 1a                	js     801006 <fd_close+0x77>
		if (dev->dev_close)
  800fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fef:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	74 0b                	je     801006 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	56                   	push   %esi
  800fff:	ff d0                	call   *%eax
  801001:	89 c3                	mov    %eax,%ebx
  801003:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	56                   	push   %esi
  80100a:	6a 00                	push   $0x0
  80100c:	e8 32 fc ff ff       	call   800c43 <sys_page_unmap>
	return r;
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	eb b5                	jmp    800fcb <fd_close+0x3c>

00801016 <close>:

int
close(int fdnum)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80101c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	ff 75 08             	pushl  0x8(%ebp)
  801023:	e8 bc fe ff ff       	call   800ee4 <fd_lookup>
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	79 02                	jns    801031 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    
		return fd_close(fd, 1);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	6a 01                	push   $0x1
  801036:	ff 75 f4             	pushl  -0xc(%ebp)
  801039:	e8 51 ff ff ff       	call   800f8f <fd_close>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	eb ec                	jmp    80102f <close+0x19>

00801043 <close_all>:

void
close_all(void)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	53                   	push   %ebx
  801047:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80104a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	53                   	push   %ebx
  801053:	e8 be ff ff ff       	call   801016 <close>
	for (i = 0; i < MAXFD; i++)
  801058:	83 c3 01             	add    $0x1,%ebx
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	83 fb 20             	cmp    $0x20,%ebx
  801061:	75 ec                	jne    80104f <close_all+0xc>
}
  801063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	53                   	push   %ebx
  80106e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801071:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801074:	50                   	push   %eax
  801075:	ff 75 08             	pushl  0x8(%ebp)
  801078:	e8 67 fe ff ff       	call   800ee4 <fd_lookup>
  80107d:	89 c3                	mov    %eax,%ebx
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	0f 88 81 00 00 00    	js     80110b <dup+0xa3>
		return r;
	close(newfdnum);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	e8 81 ff ff ff       	call   801016 <close>

	newfd = INDEX2FD(newfdnum);
  801095:	8b 75 0c             	mov    0xc(%ebp),%esi
  801098:	c1 e6 0c             	shl    $0xc,%esi
  80109b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010a1:	83 c4 04             	add    $0x4,%esp
  8010a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a7:	e8 cf fd ff ff       	call   800e7b <fd2data>
  8010ac:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ae:	89 34 24             	mov    %esi,(%esp)
  8010b1:	e8 c5 fd ff ff       	call   800e7b <fd2data>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	c1 e8 16             	shr    $0x16,%eax
  8010c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c7:	a8 01                	test   $0x1,%al
  8010c9:	74 11                	je     8010dc <dup+0x74>
  8010cb:	89 d8                	mov    %ebx,%eax
  8010cd:	c1 e8 0c             	shr    $0xc,%eax
  8010d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010d7:	f6 c2 01             	test   $0x1,%dl
  8010da:	75 39                	jne    801115 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010df:	89 d0                	mov    %edx,%eax
  8010e1:	c1 e8 0c             	shr    $0xc,%eax
  8010e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010eb:	83 ec 0c             	sub    $0xc,%esp
  8010ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f3:	50                   	push   %eax
  8010f4:	56                   	push   %esi
  8010f5:	6a 00                	push   $0x0
  8010f7:	52                   	push   %edx
  8010f8:	6a 00                	push   $0x0
  8010fa:	e8 02 fb ff ff       	call   800c01 <sys_page_map>
  8010ff:	89 c3                	mov    %eax,%ebx
  801101:	83 c4 20             	add    $0x20,%esp
  801104:	85 c0                	test   %eax,%eax
  801106:	78 31                	js     801139 <dup+0xd1>
		goto err;

	return newfdnum;
  801108:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801115:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	25 07 0e 00 00       	and    $0xe07,%eax
  801124:	50                   	push   %eax
  801125:	57                   	push   %edi
  801126:	6a 00                	push   $0x0
  801128:	53                   	push   %ebx
  801129:	6a 00                	push   $0x0
  80112b:	e8 d1 fa ff ff       	call   800c01 <sys_page_map>
  801130:	89 c3                	mov    %eax,%ebx
  801132:	83 c4 20             	add    $0x20,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	79 a3                	jns    8010dc <dup+0x74>
	sys_page_unmap(0, newfd);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	56                   	push   %esi
  80113d:	6a 00                	push   $0x0
  80113f:	e8 ff fa ff ff       	call   800c43 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801144:	83 c4 08             	add    $0x8,%esp
  801147:	57                   	push   %edi
  801148:	6a 00                	push   $0x0
  80114a:	e8 f4 fa ff ff       	call   800c43 <sys_page_unmap>
	return r;
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	eb b7                	jmp    80110b <dup+0xa3>

00801154 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	53                   	push   %ebx
  801158:	83 ec 1c             	sub    $0x1c,%esp
  80115b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80115e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	53                   	push   %ebx
  801163:	e8 7c fd ff ff       	call   800ee4 <fd_lookup>
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	78 3f                	js     8011ae <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801175:	50                   	push   %eax
  801176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801179:	ff 30                	pushl  (%eax)
  80117b:	e8 b4 fd ff ff       	call   800f34 <dev_lookup>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 27                	js     8011ae <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80118a:	8b 42 08             	mov    0x8(%edx),%eax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	83 f8 01             	cmp    $0x1,%eax
  801193:	74 1e                	je     8011b3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801198:	8b 40 08             	mov    0x8(%eax),%eax
  80119b:	85 c0                	test   %eax,%eax
  80119d:	74 35                	je     8011d4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	ff 75 10             	pushl  0x10(%ebp)
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	52                   	push   %edx
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
}
  8011ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8011b8:	8b 40 48             	mov    0x48(%eax),%eax
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	53                   	push   %ebx
  8011bf:	50                   	push   %eax
  8011c0:	68 b1 27 80 00       	push   $0x8027b1
  8011c5:	e8 26 f0 ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d2:	eb da                	jmp    8011ae <read+0x5a>
		return -E_NOT_SUPP;
  8011d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011d9:	eb d3                	jmp    8011ae <read+0x5a>

008011db <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011e7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ef:	39 f3                	cmp    %esi,%ebx
  8011f1:	73 23                	jae    801216 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f3:	83 ec 04             	sub    $0x4,%esp
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	29 d8                	sub    %ebx,%eax
  8011fa:	50                   	push   %eax
  8011fb:	89 d8                	mov    %ebx,%eax
  8011fd:	03 45 0c             	add    0xc(%ebp),%eax
  801200:	50                   	push   %eax
  801201:	57                   	push   %edi
  801202:	e8 4d ff ff ff       	call   801154 <read>
		if (m < 0)
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 06                	js     801214 <readn+0x39>
			return m;
		if (m == 0)
  80120e:	74 06                	je     801216 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801210:	01 c3                	add    %eax,%ebx
  801212:	eb db                	jmp    8011ef <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801214:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801216:	89 d8                	mov    %ebx,%eax
  801218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	53                   	push   %ebx
  801224:	83 ec 1c             	sub    $0x1c,%esp
  801227:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122d:	50                   	push   %eax
  80122e:	53                   	push   %ebx
  80122f:	e8 b0 fc ff ff       	call   800ee4 <fd_lookup>
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 3a                	js     801275 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801241:	50                   	push   %eax
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801245:	ff 30                	pushl  (%eax)
  801247:	e8 e8 fc ff ff       	call   800f34 <dev_lookup>
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 22                	js     801275 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801256:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80125a:	74 1e                	je     80127a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	8b 52 0c             	mov    0xc(%edx),%edx
  801262:	85 d2                	test   %edx,%edx
  801264:	74 35                	je     80129b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	ff 75 10             	pushl  0x10(%ebp)
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	50                   	push   %eax
  801270:	ff d2                	call   *%edx
  801272:	83 c4 10             	add    $0x10,%esp
}
  801275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801278:	c9                   	leave  
  801279:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80127a:	a1 08 40 80 00       	mov    0x804008,%eax
  80127f:	8b 40 48             	mov    0x48(%eax),%eax
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	53                   	push   %ebx
  801286:	50                   	push   %eax
  801287:	68 cd 27 80 00       	push   $0x8027cd
  80128c:	e8 5f ef ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801299:	eb da                	jmp    801275 <write+0x55>
		return -E_NOT_SUPP;
  80129b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a0:	eb d3                	jmp    801275 <write+0x55>

008012a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 08             	pushl  0x8(%ebp)
  8012af:	e8 30 fc ff ff       	call   800ee4 <fd_lookup>
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 0e                	js     8012c9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 1c             	sub    $0x1c,%esp
  8012d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d8:	50                   	push   %eax
  8012d9:	53                   	push   %ebx
  8012da:	e8 05 fc ff ff       	call   800ee4 <fd_lookup>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	78 37                	js     80131d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e6:	83 ec 08             	sub    $0x8,%esp
  8012e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ec:	50                   	push   %eax
  8012ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f0:	ff 30                	pushl  (%eax)
  8012f2:	e8 3d fc ff ff       	call   800f34 <dev_lookup>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 1f                	js     80131d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801301:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801305:	74 1b                	je     801322 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130a:	8b 52 18             	mov    0x18(%edx),%edx
  80130d:	85 d2                	test   %edx,%edx
  80130f:	74 32                	je     801343 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	50                   	push   %eax
  801318:	ff d2                	call   *%edx
  80131a:	83 c4 10             	add    $0x10,%esp
}
  80131d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801320:	c9                   	leave  
  801321:	c3                   	ret    
			thisenv->env_id, fdnum);
  801322:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801327:	8b 40 48             	mov    0x48(%eax),%eax
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	53                   	push   %ebx
  80132e:	50                   	push   %eax
  80132f:	68 90 27 80 00       	push   $0x802790
  801334:	e8 b7 ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801341:	eb da                	jmp    80131d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801343:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801348:	eb d3                	jmp    80131d <ftruncate+0x52>

0080134a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 1c             	sub    $0x1c,%esp
  801351:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	e8 84 fb ff ff       	call   800ee4 <fd_lookup>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 4b                	js     8013b2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801371:	ff 30                	pushl  (%eax)
  801373:	e8 bc fb ff ff       	call   800f34 <dev_lookup>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 33                	js     8013b2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801386:	74 2f                	je     8013b7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801388:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80138b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801392:	00 00 00 
	stat->st_isdir = 0;
  801395:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80139c:	00 00 00 
	stat->st_dev = dev;
  80139f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ac:	ff 50 14             	call   *0x14(%eax)
  8013af:	83 c4 10             	add    $0x10,%esp
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bc:	eb f4                	jmp    8013b2 <fstat+0x68>

008013be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	6a 00                	push   $0x0
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	e8 2f 02 00 00       	call   8015ff <open>
  8013d0:	89 c3                	mov    %eax,%ebx
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 1b                	js     8013f4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	50                   	push   %eax
  8013e0:	e8 65 ff ff ff       	call   80134a <fstat>
  8013e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8013e7:	89 1c 24             	mov    %ebx,(%esp)
  8013ea:	e8 27 fc ff ff       	call   801016 <close>
	return r;
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	89 f3                	mov    %esi,%ebx
}
  8013f4:	89 d8                	mov    %ebx,%eax
  8013f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	89 c6                	mov    %eax,%esi
  801404:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801406:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80140d:	74 27                	je     801436 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80140f:	6a 07                	push   $0x7
  801411:	68 00 50 80 00       	push   $0x805000
  801416:	56                   	push   %esi
  801417:	ff 35 00 40 80 00    	pushl  0x804000
  80141d:	e8 1f 0c 00 00       	call   802041 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801422:	83 c4 0c             	add    $0xc,%esp
  801425:	6a 00                	push   $0x0
  801427:	53                   	push   %ebx
  801428:	6a 00                	push   $0x0
  80142a:	e8 9f 0b 00 00       	call   801fce <ipc_recv>
}
  80142f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	6a 01                	push   $0x1
  80143b:	e8 6d 0c 00 00       	call   8020ad <ipc_find_env>
  801440:	a3 00 40 80 00       	mov    %eax,0x804000
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	eb c5                	jmp    80140f <fsipc+0x12>

0080144a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8b 40 0c             	mov    0xc(%eax),%eax
  801456:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801463:	ba 00 00 00 00       	mov    $0x0,%edx
  801468:	b8 02 00 00 00       	mov    $0x2,%eax
  80146d:	e8 8b ff ff ff       	call   8013fd <fsipc>
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <devfile_flush>:
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8b 40 0c             	mov    0xc(%eax),%eax
  801480:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	b8 06 00 00 00       	mov    $0x6,%eax
  80148f:	e8 69 ff ff ff       	call   8013fd <fsipc>
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <devfile_stat>:
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	53                   	push   %ebx
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8014b5:	e8 43 ff ff ff       	call   8013fd <fsipc>
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 2c                	js     8014ea <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	68 00 50 80 00       	push   $0x805000
  8014c6:	53                   	push   %ebx
  8014c7:	e8 00 f3 ff ff       	call   8007cc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014cc:	a1 80 50 80 00       	mov    0x805080,%eax
  8014d1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014d7:	a1 84 50 80 00       	mov    0x805084,%eax
  8014dc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <devfile_write>:
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8014f9:	85 db                	test   %ebx,%ebx
  8014fb:	75 07                	jne    801504 <devfile_write+0x15>
	return n_all;
  8014fd:	89 d8                	mov    %ebx,%eax
}
  8014ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801502:	c9                   	leave  
  801503:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8b 40 0c             	mov    0xc(%eax),%eax
  80150a:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  80150f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	53                   	push   %ebx
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	68 08 50 80 00       	push   $0x805008
  801521:	e8 34 f4 ff ff       	call   80095a <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	b8 04 00 00 00       	mov    $0x4,%eax
  801530:	e8 c8 fe ff ff       	call   8013fd <fsipc>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 c3                	js     8014ff <devfile_write+0x10>
	  assert(r <= n_left);
  80153c:	39 d8                	cmp    %ebx,%eax
  80153e:	77 0b                	ja     80154b <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801540:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801545:	7f 1d                	jg     801564 <devfile_write+0x75>
    n_all += r;
  801547:	89 c3                	mov    %eax,%ebx
  801549:	eb b2                	jmp    8014fd <devfile_write+0xe>
	  assert(r <= n_left);
  80154b:	68 00 28 80 00       	push   $0x802800
  801550:	68 0c 28 80 00       	push   $0x80280c
  801555:	68 9f 00 00 00       	push   $0x9f
  80155a:	68 21 28 80 00       	push   $0x802821
  80155f:	e8 b1 eb ff ff       	call   800115 <_panic>
	  assert(r <= PGSIZE);
  801564:	68 2c 28 80 00       	push   $0x80282c
  801569:	68 0c 28 80 00       	push   $0x80280c
  80156e:	68 a0 00 00 00       	push   $0xa0
  801573:	68 21 28 80 00       	push   $0x802821
  801578:	e8 98 eb ff ff       	call   800115 <_panic>

0080157d <devfile_read>:
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
  801582:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8b 40 0c             	mov    0xc(%eax),%eax
  80158b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801590:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801596:	ba 00 00 00 00       	mov    $0x0,%edx
  80159b:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a0:	e8 58 fe ff ff       	call   8013fd <fsipc>
  8015a5:	89 c3                	mov    %eax,%ebx
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 1f                	js     8015ca <devfile_read+0x4d>
	assert(r <= n);
  8015ab:	39 f0                	cmp    %esi,%eax
  8015ad:	77 24                	ja     8015d3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015b4:	7f 33                	jg     8015e9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	50                   	push   %eax
  8015ba:	68 00 50 80 00       	push   $0x805000
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	e8 93 f3 ff ff       	call   80095a <memmove>
	return r;
  8015c7:	83 c4 10             	add    $0x10,%esp
}
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    
	assert(r <= n);
  8015d3:	68 38 28 80 00       	push   $0x802838
  8015d8:	68 0c 28 80 00       	push   $0x80280c
  8015dd:	6a 7c                	push   $0x7c
  8015df:	68 21 28 80 00       	push   $0x802821
  8015e4:	e8 2c eb ff ff       	call   800115 <_panic>
	assert(r <= PGSIZE);
  8015e9:	68 2c 28 80 00       	push   $0x80282c
  8015ee:	68 0c 28 80 00       	push   $0x80280c
  8015f3:	6a 7d                	push   $0x7d
  8015f5:	68 21 28 80 00       	push   $0x802821
  8015fa:	e8 16 eb ff ff       	call   800115 <_panic>

008015ff <open>:
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
  801604:	83 ec 1c             	sub    $0x1c,%esp
  801607:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80160a:	56                   	push   %esi
  80160b:	e8 83 f1 ff ff       	call   800793 <strlen>
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801618:	7f 6c                	jg     801686 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801620:	50                   	push   %eax
  801621:	e8 6c f8 ff ff       	call   800e92 <fd_alloc>
  801626:	89 c3                	mov    %eax,%ebx
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	85 c0                	test   %eax,%eax
  80162d:	78 3c                	js     80166b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	56                   	push   %esi
  801633:	68 00 50 80 00       	push   $0x805000
  801638:	e8 8f f1 ff ff       	call   8007cc <strcpy>
	fsipcbuf.open.req_omode = mode;
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801648:	b8 01 00 00 00       	mov    $0x1,%eax
  80164d:	e8 ab fd ff ff       	call   8013fd <fsipc>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 19                	js     801674 <open+0x75>
	return fd2num(fd);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	ff 75 f4             	pushl  -0xc(%ebp)
  801661:	e8 05 f8 ff ff       	call   800e6b <fd2num>
  801666:	89 c3                	mov    %eax,%ebx
  801668:	83 c4 10             	add    $0x10,%esp
}
  80166b:	89 d8                	mov    %ebx,%eax
  80166d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801670:	5b                   	pop    %ebx
  801671:	5e                   	pop    %esi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    
		fd_close(fd, 0);
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	6a 00                	push   $0x0
  801679:	ff 75 f4             	pushl  -0xc(%ebp)
  80167c:	e8 0e f9 ff ff       	call   800f8f <fd_close>
		return r;
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	eb e5                	jmp    80166b <open+0x6c>
		return -E_BAD_PATH;
  801686:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80168b:	eb de                	jmp    80166b <open+0x6c>

0080168d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801693:	ba 00 00 00 00       	mov    $0x0,%edx
  801698:	b8 08 00 00 00       	mov    $0x8,%eax
  80169d:	e8 5b fd ff ff       	call   8013fd <fsipc>
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	e8 c4 f7 ff ff       	call   800e7b <fd2data>
  8016b7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	68 3f 28 80 00       	push   $0x80283f
  8016c1:	53                   	push   %ebx
  8016c2:	e8 05 f1 ff ff       	call   8007cc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016c7:	8b 46 04             	mov    0x4(%esi),%eax
  8016ca:	2b 06                	sub    (%esi),%eax
  8016cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d9:	00 00 00 
	stat->st_dev = &devpipe;
  8016dc:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016e3:	30 80 00 
	return 0;
}
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    

008016f2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 0c             	sub    $0xc,%esp
  8016f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016fc:	53                   	push   %ebx
  8016fd:	6a 00                	push   $0x0
  8016ff:	e8 3f f5 ff ff       	call   800c43 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801704:	89 1c 24             	mov    %ebx,(%esp)
  801707:	e8 6f f7 ff ff       	call   800e7b <fd2data>
  80170c:	83 c4 08             	add    $0x8,%esp
  80170f:	50                   	push   %eax
  801710:	6a 00                	push   $0x0
  801712:	e8 2c f5 ff ff       	call   800c43 <sys_page_unmap>
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <_pipeisclosed>:
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	57                   	push   %edi
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	83 ec 1c             	sub    $0x1c,%esp
  801725:	89 c7                	mov    %eax,%edi
  801727:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801729:	a1 08 40 80 00       	mov    0x804008,%eax
  80172e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	57                   	push   %edi
  801735:	e8 ac 09 00 00       	call   8020e6 <pageref>
  80173a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80173d:	89 34 24             	mov    %esi,(%esp)
  801740:	e8 a1 09 00 00       	call   8020e6 <pageref>
		nn = thisenv->env_runs;
  801745:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80174b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	39 cb                	cmp    %ecx,%ebx
  801753:	74 1b                	je     801770 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801755:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801758:	75 cf                	jne    801729 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80175a:	8b 42 58             	mov    0x58(%edx),%eax
  80175d:	6a 01                	push   $0x1
  80175f:	50                   	push   %eax
  801760:	53                   	push   %ebx
  801761:	68 46 28 80 00       	push   $0x802846
  801766:	e8 85 ea ff ff       	call   8001f0 <cprintf>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	eb b9                	jmp    801729 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801770:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801773:	0f 94 c0             	sete   %al
  801776:	0f b6 c0             	movzbl %al,%eax
}
  801779:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5f                   	pop    %edi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <devpipe_write>:
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	57                   	push   %edi
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 28             	sub    $0x28,%esp
  80178a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80178d:	56                   	push   %esi
  80178e:	e8 e8 f6 ff ff       	call   800e7b <fd2data>
  801793:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	bf 00 00 00 00       	mov    $0x0,%edi
  80179d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017a0:	74 4f                	je     8017f1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017a2:	8b 43 04             	mov    0x4(%ebx),%eax
  8017a5:	8b 0b                	mov    (%ebx),%ecx
  8017a7:	8d 51 20             	lea    0x20(%ecx),%edx
  8017aa:	39 d0                	cmp    %edx,%eax
  8017ac:	72 14                	jb     8017c2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017ae:	89 da                	mov    %ebx,%edx
  8017b0:	89 f0                	mov    %esi,%eax
  8017b2:	e8 65 ff ff ff       	call   80171c <_pipeisclosed>
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	75 3b                	jne    8017f6 <devpipe_write+0x75>
			sys_yield();
  8017bb:	e8 df f3 ff ff       	call   800b9f <sys_yield>
  8017c0:	eb e0                	jmp    8017a2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017c9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017cc:	89 c2                	mov    %eax,%edx
  8017ce:	c1 fa 1f             	sar    $0x1f,%edx
  8017d1:	89 d1                	mov    %edx,%ecx
  8017d3:	c1 e9 1b             	shr    $0x1b,%ecx
  8017d6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017d9:	83 e2 1f             	and    $0x1f,%edx
  8017dc:	29 ca                	sub    %ecx,%edx
  8017de:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017e6:	83 c0 01             	add    $0x1,%eax
  8017e9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017ec:	83 c7 01             	add    $0x1,%edi
  8017ef:	eb ac                	jmp    80179d <devpipe_write+0x1c>
	return i;
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	eb 05                	jmp    8017fb <devpipe_write+0x7a>
				return 0;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5f                   	pop    %edi
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <devpipe_read>:
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	57                   	push   %edi
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 18             	sub    $0x18,%esp
  80180c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80180f:	57                   	push   %edi
  801810:	e8 66 f6 ff ff       	call   800e7b <fd2data>
  801815:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	be 00 00 00 00       	mov    $0x0,%esi
  80181f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801822:	75 14                	jne    801838 <devpipe_read+0x35>
	return i;
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	eb 02                	jmp    80182b <devpipe_read+0x28>
				return i;
  801829:	89 f0                	mov    %esi,%eax
}
  80182b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    
			sys_yield();
  801833:	e8 67 f3 ff ff       	call   800b9f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801838:	8b 03                	mov    (%ebx),%eax
  80183a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80183d:	75 18                	jne    801857 <devpipe_read+0x54>
			if (i > 0)
  80183f:	85 f6                	test   %esi,%esi
  801841:	75 e6                	jne    801829 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801843:	89 da                	mov    %ebx,%edx
  801845:	89 f8                	mov    %edi,%eax
  801847:	e8 d0 fe ff ff       	call   80171c <_pipeisclosed>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	74 e3                	je     801833 <devpipe_read+0x30>
				return 0;
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	eb d4                	jmp    80182b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801857:	99                   	cltd   
  801858:	c1 ea 1b             	shr    $0x1b,%edx
  80185b:	01 d0                	add    %edx,%eax
  80185d:	83 e0 1f             	and    $0x1f,%eax
  801860:	29 d0                	sub    %edx,%eax
  801862:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80186a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80186d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801870:	83 c6 01             	add    $0x1,%esi
  801873:	eb aa                	jmp    80181f <devpipe_read+0x1c>

00801875 <pipe>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	56                   	push   %esi
  801879:	53                   	push   %ebx
  80187a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80187d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801880:	50                   	push   %eax
  801881:	e8 0c f6 ff ff       	call   800e92 <fd_alloc>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	0f 88 23 01 00 00    	js     8019b6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 07 04 00 00       	push   $0x407
  80189b:	ff 75 f4             	pushl  -0xc(%ebp)
  80189e:	6a 00                	push   $0x0
  8018a0:	e8 19 f3 ff ff       	call   800bbe <sys_page_alloc>
  8018a5:	89 c3                	mov    %eax,%ebx
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	0f 88 04 01 00 00    	js     8019b6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8018b2:	83 ec 0c             	sub    $0xc,%esp
  8018b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b8:	50                   	push   %eax
  8018b9:	e8 d4 f5 ff ff       	call   800e92 <fd_alloc>
  8018be:	89 c3                	mov    %eax,%ebx
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	0f 88 db 00 00 00    	js     8019a6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	68 07 04 00 00       	push   $0x407
  8018d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d6:	6a 00                	push   $0x0
  8018d8:	e8 e1 f2 ff ff       	call   800bbe <sys_page_alloc>
  8018dd:	89 c3                	mov    %eax,%ebx
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	0f 88 bc 00 00 00    	js     8019a6 <pipe+0x131>
	va = fd2data(fd0);
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f0:	e8 86 f5 ff ff       	call   800e7b <fd2data>
  8018f5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018f7:	83 c4 0c             	add    $0xc,%esp
  8018fa:	68 07 04 00 00       	push   $0x407
  8018ff:	50                   	push   %eax
  801900:	6a 00                	push   $0x0
  801902:	e8 b7 f2 ff ff       	call   800bbe <sys_page_alloc>
  801907:	89 c3                	mov    %eax,%ebx
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	0f 88 82 00 00 00    	js     801996 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801914:	83 ec 0c             	sub    $0xc,%esp
  801917:	ff 75 f0             	pushl  -0x10(%ebp)
  80191a:	e8 5c f5 ff ff       	call   800e7b <fd2data>
  80191f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801926:	50                   	push   %eax
  801927:	6a 00                	push   $0x0
  801929:	56                   	push   %esi
  80192a:	6a 00                	push   $0x0
  80192c:	e8 d0 f2 ff ff       	call   800c01 <sys_page_map>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	83 c4 20             	add    $0x20,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 4e                	js     801988 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80193a:	a1 20 30 80 00       	mov    0x803020,%eax
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801947:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	ff 75 f4             	pushl  -0xc(%ebp)
  801963:	e8 03 f5 ff ff       	call   800e6b <fd2num>
  801968:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80196b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80196d:	83 c4 04             	add    $0x4,%esp
  801970:	ff 75 f0             	pushl  -0x10(%ebp)
  801973:	e8 f3 f4 ff ff       	call   800e6b <fd2num>
  801978:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	bb 00 00 00 00       	mov    $0x0,%ebx
  801986:	eb 2e                	jmp    8019b6 <pipe+0x141>
	sys_page_unmap(0, va);
  801988:	83 ec 08             	sub    $0x8,%esp
  80198b:	56                   	push   %esi
  80198c:	6a 00                	push   $0x0
  80198e:	e8 b0 f2 ff ff       	call   800c43 <sys_page_unmap>
  801993:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	ff 75 f0             	pushl  -0x10(%ebp)
  80199c:	6a 00                	push   $0x0
  80199e:	e8 a0 f2 ff ff       	call   800c43 <sys_page_unmap>
  8019a3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ac:	6a 00                	push   $0x0
  8019ae:	e8 90 f2 ff ff       	call   800c43 <sys_page_unmap>
  8019b3:	83 c4 10             	add    $0x10,%esp
}
  8019b6:	89 d8                	mov    %ebx,%eax
  8019b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5d                   	pop    %ebp
  8019be:	c3                   	ret    

008019bf <pipeisclosed>:
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c8:	50                   	push   %eax
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	e8 13 f5 ff ff       	call   800ee4 <fd_lookup>
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 18                	js     8019f0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	ff 75 f4             	pushl  -0xc(%ebp)
  8019de:	e8 98 f4 ff ff       	call   800e7b <fd2data>
	return _pipeisclosed(fd, p);
  8019e3:	89 c2                	mov    %eax,%edx
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	e8 2f fd ff ff       	call   80171c <_pipeisclosed>
  8019ed:	83 c4 10             	add    $0x10,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019f8:	68 5e 28 80 00       	push   $0x80285e
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	e8 c7 ed ff ff       	call   8007cc <strcpy>
	return 0;
}
  801a05:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <devsock_close>:
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 10             	sub    $0x10,%esp
  801a13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a16:	53                   	push   %ebx
  801a17:	e8 ca 06 00 00       	call   8020e6 <pageref>
  801a1c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a24:	83 f8 01             	cmp    $0x1,%eax
  801a27:	74 07                	je     801a30 <devsock_close+0x24>
}
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a30:	83 ec 0c             	sub    $0xc,%esp
  801a33:	ff 73 0c             	pushl  0xc(%ebx)
  801a36:	e8 b9 02 00 00       	call   801cf4 <nsipc_close>
  801a3b:	89 c2                	mov    %eax,%edx
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	eb e7                	jmp    801a29 <devsock_close+0x1d>

00801a42 <devsock_write>:
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff 70 0c             	pushl  0xc(%eax)
  801a56:	e8 76 03 00 00       	call   801dd1 <nsipc_send>
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <devsock_read>:
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	ff 70 0c             	pushl  0xc(%eax)
  801a71:	e8 ef 02 00 00       	call   801d65 <nsipc_recv>
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <fd2sockid>:
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a7e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	e8 5c f4 ff ff       	call   800ee4 <fd_lookup>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 10                	js     801a9f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a92:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a98:	39 08                	cmp    %ecx,(%eax)
  801a9a:	75 05                	jne    801aa1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a9c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    
		return -E_NOT_SUPP;
  801aa1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa6:	eb f7                	jmp    801a9f <fd2sockid+0x27>

00801aa8 <alloc_sockfd>:
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
  801aad:	83 ec 1c             	sub    $0x1c,%esp
  801ab0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	e8 d7 f3 ff ff       	call   800e92 <fd_alloc>
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 43                	js     801b07 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 07 04 00 00       	push   $0x407
  801acc:	ff 75 f4             	pushl  -0xc(%ebp)
  801acf:	6a 00                	push   $0x0
  801ad1:	e8 e8 f0 ff ff       	call   800bbe <sys_page_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 28                	js     801b07 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ae8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801af4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801af7:	83 ec 0c             	sub    $0xc,%esp
  801afa:	50                   	push   %eax
  801afb:	e8 6b f3 ff ff       	call   800e6b <fd2num>
  801b00:	89 c3                	mov    %eax,%ebx
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	eb 0c                	jmp    801b13 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	56                   	push   %esi
  801b0b:	e8 e4 01 00 00       	call   801cf4 <nsipc_close>
		return r;
  801b10:	83 c4 10             	add    $0x10,%esp
}
  801b13:	89 d8                	mov    %ebx,%eax
  801b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b18:	5b                   	pop    %ebx
  801b19:	5e                   	pop    %esi
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    

00801b1c <accept>:
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	e8 4e ff ff ff       	call   801a78 <fd2sockid>
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 1b                	js     801b49 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	e8 0e 01 00 00       	call   801c4b <nsipc_accept>
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 05                	js     801b49 <accept+0x2d>
	return alloc_sockfd(r);
  801b44:	e8 5f ff ff ff       	call   801aa8 <alloc_sockfd>
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <bind>:
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	e8 1f ff ff ff       	call   801a78 <fd2sockid>
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	78 12                	js     801b6f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	ff 75 10             	pushl  0x10(%ebp)
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	e8 31 01 00 00       	call   801c9d <nsipc_bind>
  801b6c:	83 c4 10             	add    $0x10,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <shutdown>:
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	e8 f9 fe ff ff       	call   801a78 <fd2sockid>
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 0f                	js     801b92 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	e8 43 01 00 00       	call   801cd2 <nsipc_shutdown>
  801b8f:	83 c4 10             	add    $0x10,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <connect>:
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	e8 d6 fe ff ff       	call   801a78 <fd2sockid>
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	78 12                	js     801bb8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ba6:	83 ec 04             	sub    $0x4,%esp
  801ba9:	ff 75 10             	pushl  0x10(%ebp)
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	50                   	push   %eax
  801bb0:	e8 59 01 00 00       	call   801d0e <nsipc_connect>
  801bb5:	83 c4 10             	add    $0x10,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <listen>:
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	e8 b0 fe ff ff       	call   801a78 <fd2sockid>
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	78 0f                	js     801bdb <listen+0x21>
	return nsipc_listen(r, backlog);
  801bcc:	83 ec 08             	sub    $0x8,%esp
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	50                   	push   %eax
  801bd3:	e8 6b 01 00 00       	call   801d43 <nsipc_listen>
  801bd8:	83 c4 10             	add    $0x10,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <socket>:

int
socket(int domain, int type, int protocol)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801be3:	ff 75 10             	pushl  0x10(%ebp)
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	e8 3e 02 00 00       	call   801e2f <nsipc_socket>
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 05                	js     801bfd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bf8:	e8 ab fe ff ff       	call   801aa8 <alloc_sockfd>
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	53                   	push   %ebx
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c08:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c0f:	74 26                	je     801c37 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c11:	6a 07                	push   $0x7
  801c13:	68 00 60 80 00       	push   $0x806000
  801c18:	53                   	push   %ebx
  801c19:	ff 35 04 40 80 00    	pushl  0x804004
  801c1f:	e8 1d 04 00 00       	call   802041 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c24:	83 c4 0c             	add    $0xc,%esp
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	e8 9c 03 00 00       	call   801fce <ipc_recv>
}
  801c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	6a 02                	push   $0x2
  801c3c:	e8 6c 04 00 00       	call   8020ad <ipc_find_env>
  801c41:	a3 04 40 80 00       	mov    %eax,0x804004
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	eb c6                	jmp    801c11 <nsipc+0x12>

00801c4b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c5b:	8b 06                	mov    (%esi),%eax
  801c5d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c62:	b8 01 00 00 00       	mov    $0x1,%eax
  801c67:	e8 93 ff ff ff       	call   801bff <nsipc>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	79 09                	jns    801c7b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	ff 35 10 60 80 00    	pushl  0x806010
  801c84:	68 00 60 80 00       	push   $0x806000
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	e8 c9 ec ff ff       	call   80095a <memmove>
		*addrlen = ret->ret_addrlen;
  801c91:	a1 10 60 80 00       	mov    0x806010,%eax
  801c96:	89 06                	mov    %eax,(%esi)
  801c98:	83 c4 10             	add    $0x10,%esp
	return r;
  801c9b:	eb d5                	jmp    801c72 <nsipc_accept+0x27>

00801c9d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	53                   	push   %ebx
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801caf:	53                   	push   %ebx
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	68 04 60 80 00       	push   $0x806004
  801cb8:	e8 9d ec ff ff       	call   80095a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cbd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cc3:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc8:	e8 32 ff ff ff       	call   801bff <nsipc>
}
  801ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ce8:	b8 03 00 00 00       	mov    $0x3,%eax
  801ced:	e8 0d ff ff ff       	call   801bff <nsipc>
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <nsipc_close>:

int
nsipc_close(int s)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d02:	b8 04 00 00 00       	mov    $0x4,%eax
  801d07:	e8 f3 fe ff ff       	call   801bff <nsipc>
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 08             	sub    $0x8,%esp
  801d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d20:	53                   	push   %ebx
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	68 04 60 80 00       	push   $0x806004
  801d29:	e8 2c ec ff ff       	call   80095a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d2e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d34:	b8 05 00 00 00       	mov    $0x5,%eax
  801d39:	e8 c1 fe ff ff       	call   801bff <nsipc>
}
  801d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d59:	b8 06 00 00 00       	mov    $0x6,%eax
  801d5e:	e8 9c fe ff ff       	call   801bff <nsipc>
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d75:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d83:	b8 07 00 00 00       	mov    $0x7,%eax
  801d88:	e8 72 fe ff ff       	call   801bff <nsipc>
  801d8d:	89 c3                	mov    %eax,%ebx
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	78 1f                	js     801db2 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d93:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d98:	7f 21                	jg     801dbb <nsipc_recv+0x56>
  801d9a:	39 c6                	cmp    %eax,%esi
  801d9c:	7c 1d                	jl     801dbb <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	50                   	push   %eax
  801da2:	68 00 60 80 00       	push   $0x806000
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	e8 ab eb ff ff       	call   80095a <memmove>
  801daf:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801db2:	89 d8                	mov    %ebx,%eax
  801db4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dbb:	68 6a 28 80 00       	push   $0x80286a
  801dc0:	68 0c 28 80 00       	push   $0x80280c
  801dc5:	6a 62                	push   $0x62
  801dc7:	68 7f 28 80 00       	push   $0x80287f
  801dcc:	e8 44 e3 ff ff       	call   800115 <_panic>

00801dd1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801de3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801de9:	7f 2e                	jg     801e19 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801deb:	83 ec 04             	sub    $0x4,%esp
  801dee:	53                   	push   %ebx
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	68 0c 60 80 00       	push   $0x80600c
  801df7:	e8 5e eb ff ff       	call   80095a <memmove>
	nsipcbuf.send.req_size = size;
  801dfc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e02:	8b 45 14             	mov    0x14(%ebp),%eax
  801e05:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e0a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e0f:	e8 eb fd ff ff       	call   801bff <nsipc>
}
  801e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    
	assert(size < 1600);
  801e19:	68 8b 28 80 00       	push   $0x80288b
  801e1e:	68 0c 28 80 00       	push   $0x80280c
  801e23:	6a 6d                	push   $0x6d
  801e25:	68 7f 28 80 00       	push   $0x80287f
  801e2a:	e8 e6 e2 ff ff       	call   800115 <_panic>

00801e2f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e40:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e45:	8b 45 10             	mov    0x10(%ebp),%eax
  801e48:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e4d:	b8 09 00 00 00       	mov    $0x9,%eax
  801e52:	e8 a8 fd ff ff       	call   801bff <nsipc>
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	c3                   	ret    

00801e5f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e65:	68 97 28 80 00       	push   $0x802897
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	e8 5a e9 ff ff       	call   8007cc <strcpy>
	return 0;
}
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <devcons_write>:
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	57                   	push   %edi
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e85:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e8a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e90:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e93:	73 31                	jae    801ec6 <devcons_write+0x4d>
		m = n - tot;
  801e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e98:	29 f3                	sub    %esi,%ebx
  801e9a:	83 fb 7f             	cmp    $0x7f,%ebx
  801e9d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ea2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	53                   	push   %ebx
  801ea9:	89 f0                	mov    %esi,%eax
  801eab:	03 45 0c             	add    0xc(%ebp),%eax
  801eae:	50                   	push   %eax
  801eaf:	57                   	push   %edi
  801eb0:	e8 a5 ea ff ff       	call   80095a <memmove>
		sys_cputs(buf, m);
  801eb5:	83 c4 08             	add    $0x8,%esp
  801eb8:	53                   	push   %ebx
  801eb9:	57                   	push   %edi
  801eba:	e8 43 ec ff ff       	call   800b02 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ebf:	01 de                	add    %ebx,%esi
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	eb ca                	jmp    801e90 <devcons_write+0x17>
}
  801ec6:	89 f0                	mov    %esi,%eax
  801ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5f                   	pop    %edi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    

00801ed0 <devcons_read>:
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801edf:	74 21                	je     801f02 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ee1:	e8 3a ec ff ff       	call   800b20 <sys_cgetc>
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 07                	jne    801ef1 <devcons_read+0x21>
		sys_yield();
  801eea:	e8 b0 ec ff ff       	call   800b9f <sys_yield>
  801eef:	eb f0                	jmp    801ee1 <devcons_read+0x11>
	if (c < 0)
  801ef1:	78 0f                	js     801f02 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801ef3:	83 f8 04             	cmp    $0x4,%eax
  801ef6:	74 0c                	je     801f04 <devcons_read+0x34>
	*(char*)vbuf = c;
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	88 02                	mov    %al,(%edx)
	return 1;
  801efd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    
		return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	eb f7                	jmp    801f02 <devcons_read+0x32>

00801f0b <cputchar>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f17:	6a 01                	push   $0x1
  801f19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1c:	50                   	push   %eax
  801f1d:	e8 e0 eb ff ff       	call   800b02 <sys_cputs>
}
  801f22:	83 c4 10             	add    $0x10,%esp
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <getchar>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f2d:	6a 01                	push   $0x1
  801f2f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f32:	50                   	push   %eax
  801f33:	6a 00                	push   $0x0
  801f35:	e8 1a f2 ff ff       	call   801154 <read>
	if (r < 0)
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 06                	js     801f47 <getchar+0x20>
	if (r < 1)
  801f41:	74 06                	je     801f49 <getchar+0x22>
	return c;
  801f43:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    
		return -E_EOF;
  801f49:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f4e:	eb f7                	jmp    801f47 <getchar+0x20>

00801f50 <iscons>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f59:	50                   	push   %eax
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 82 ef ff ff       	call   800ee4 <fd_lookup>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 11                	js     801f7a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f72:	39 10                	cmp    %edx,(%eax)
  801f74:	0f 94 c0             	sete   %al
  801f77:	0f b6 c0             	movzbl %al,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <opencons>:
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f85:	50                   	push   %eax
  801f86:	e8 07 ef ff ff       	call   800e92 <fd_alloc>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 3a                	js     801fcc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 07 04 00 00       	push   $0x407
  801f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 1a ec ff ff       	call   800bbe <sys_page_alloc>
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 21                	js     801fcc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fb4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	50                   	push   %eax
  801fc4:	e8 a2 ee ff ff       	call   800e6b <fd2num>
  801fc9:	83 c4 10             	add    $0x10,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	56                   	push   %esi
  801fd2:	53                   	push   %ebx
  801fd3:	8b 75 08             	mov    0x8(%ebp),%esi
  801fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	74 4f                	je     80202f <ipc_recv+0x61>
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	50                   	push   %eax
  801fe4:	e8 85 ed ff ff       	call   800d6e <sys_ipc_recv>
  801fe9:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801fec:	85 f6                	test   %esi,%esi
  801fee:	74 14                	je     802004 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ff0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	75 09                	jne    802002 <ipc_recv+0x34>
  801ff9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fff:	8b 52 74             	mov    0x74(%edx),%edx
  802002:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802004:	85 db                	test   %ebx,%ebx
  802006:	74 14                	je     80201c <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802008:	ba 00 00 00 00       	mov    $0x0,%edx
  80200d:	85 c0                	test   %eax,%eax
  80200f:	75 09                	jne    80201a <ipc_recv+0x4c>
  802011:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802017:	8b 52 78             	mov    0x78(%edx),%edx
  80201a:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80201c:	85 c0                	test   %eax,%eax
  80201e:	75 08                	jne    802028 <ipc_recv+0x5a>
  802020:	a1 08 40 80 00       	mov    0x804008,%eax
  802025:	8b 40 70             	mov    0x70(%eax),%eax
}
  802028:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 00 00 c0 ee       	push   $0xeec00000
  802037:	e8 32 ed ff ff       	call   800d6e <sys_ipc_recv>
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	eb ab                	jmp    801fec <ipc_recv+0x1e>

00802041 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	57                   	push   %edi
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80204d:	8b 75 10             	mov    0x10(%ebp),%esi
  802050:	eb 20                	jmp    802072 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802052:	6a 00                	push   $0x0
  802054:	68 00 00 c0 ee       	push   $0xeec00000
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	57                   	push   %edi
  80205d:	e8 e9 ec ff ff       	call   800d4b <sys_ipc_try_send>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	eb 1f                	jmp    802088 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802069:	e8 31 eb ff ff       	call   800b9f <sys_yield>
	while(retval != 0) {
  80206e:	85 db                	test   %ebx,%ebx
  802070:	74 33                	je     8020a5 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802072:	85 f6                	test   %esi,%esi
  802074:	74 dc                	je     802052 <ipc_send+0x11>
  802076:	ff 75 14             	pushl  0x14(%ebp)
  802079:	56                   	push   %esi
  80207a:	ff 75 0c             	pushl  0xc(%ebp)
  80207d:	57                   	push   %edi
  80207e:	e8 c8 ec ff ff       	call   800d4b <sys_ipc_try_send>
  802083:	89 c3                	mov    %eax,%ebx
  802085:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802088:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80208b:	74 dc                	je     802069 <ipc_send+0x28>
  80208d:	85 db                	test   %ebx,%ebx
  80208f:	74 d8                	je     802069 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 a4 28 80 00       	push   $0x8028a4
  802099:	6a 35                	push   $0x35
  80209b:	68 d4 28 80 00       	push   $0x8028d4
  8020a0:	e8 70 e0 ff ff       	call   800115 <_panic>
	}
}
  8020a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5f                   	pop    %edi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020b8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020c1:	8b 52 50             	mov    0x50(%edx),%edx
  8020c4:	39 ca                	cmp    %ecx,%edx
  8020c6:	74 11                	je     8020d9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020c8:	83 c0 01             	add    $0x1,%eax
  8020cb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020d0:	75 e6                	jne    8020b8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	eb 0b                	jmp    8020e4 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020e1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020ec:	89 d0                	mov    %edx,%eax
  8020ee:	c1 e8 16             	shr    $0x16,%eax
  8020f1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020fd:	f6 c1 01             	test   $0x1,%cl
  802100:	74 1d                	je     80211f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802102:	c1 ea 0c             	shr    $0xc,%edx
  802105:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80210c:	f6 c2 01             	test   $0x1,%dl
  80210f:	74 0e                	je     80211f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802111:	c1 ea 0c             	shr    $0xc,%edx
  802114:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80211b:	ef 
  80211c:	0f b7 c0             	movzwl %ax,%eax
}
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    
  802121:	66 90                	xchg   %ax,%ax
  802123:	66 90                	xchg   %ax,%ax
  802125:	66 90                	xchg   %ax,%ax
  802127:	66 90                	xchg   %ax,%ax
  802129:	66 90                	xchg   %ax,%ax
  80212b:	66 90                	xchg   %ax,%ax
  80212d:	66 90                	xchg   %ax,%ax
  80212f:	90                   	nop

00802130 <__udivdi3>:
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	57                   	push   %edi
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	83 ec 1c             	sub    $0x1c,%esp
  80213b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80213f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802143:	8b 74 24 34          	mov    0x34(%esp),%esi
  802147:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80214b:	85 d2                	test   %edx,%edx
  80214d:	75 49                	jne    802198 <__udivdi3+0x68>
  80214f:	39 f3                	cmp    %esi,%ebx
  802151:	76 15                	jbe    802168 <__udivdi3+0x38>
  802153:	31 ff                	xor    %edi,%edi
  802155:	89 e8                	mov    %ebp,%eax
  802157:	89 f2                	mov    %esi,%edx
  802159:	f7 f3                	div    %ebx
  80215b:	89 fa                	mov    %edi,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	89 d9                	mov    %ebx,%ecx
  80216a:	85 db                	test   %ebx,%ebx
  80216c:	75 0b                	jne    802179 <__udivdi3+0x49>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	31 d2                	xor    %edx,%edx
  802175:	f7 f3                	div    %ebx
  802177:	89 c1                	mov    %eax,%ecx
  802179:	31 d2                	xor    %edx,%edx
  80217b:	89 f0                	mov    %esi,%eax
  80217d:	f7 f1                	div    %ecx
  80217f:	89 c6                	mov    %eax,%esi
  802181:	89 e8                	mov    %ebp,%eax
  802183:	89 f7                	mov    %esi,%edi
  802185:	f7 f1                	div    %ecx
  802187:	89 fa                	mov    %edi,%edx
  802189:	83 c4 1c             	add    $0x1c,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    
  802191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802198:	39 f2                	cmp    %esi,%edx
  80219a:	77 1c                	ja     8021b8 <__udivdi3+0x88>
  80219c:	0f bd fa             	bsr    %edx,%edi
  80219f:	83 f7 1f             	xor    $0x1f,%edi
  8021a2:	75 2c                	jne    8021d0 <__udivdi3+0xa0>
  8021a4:	39 f2                	cmp    %esi,%edx
  8021a6:	72 06                	jb     8021ae <__udivdi3+0x7e>
  8021a8:	31 c0                	xor    %eax,%eax
  8021aa:	39 eb                	cmp    %ebp,%ebx
  8021ac:	77 ad                	ja     80215b <__udivdi3+0x2b>
  8021ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b3:	eb a6                	jmp    80215b <__udivdi3+0x2b>
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	31 ff                	xor    %edi,%edi
  8021ba:	31 c0                	xor    %eax,%eax
  8021bc:	89 fa                	mov    %edi,%edx
  8021be:	83 c4 1c             	add    $0x1c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
  8021c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021cd:	8d 76 00             	lea    0x0(%esi),%esi
  8021d0:	89 f9                	mov    %edi,%ecx
  8021d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021d7:	29 f8                	sub    %edi,%eax
  8021d9:	d3 e2                	shl    %cl,%edx
  8021db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021df:	89 c1                	mov    %eax,%ecx
  8021e1:	89 da                	mov    %ebx,%edx
  8021e3:	d3 ea                	shr    %cl,%edx
  8021e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e9:	09 d1                	or     %edx,%ecx
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 f9                	mov    %edi,%ecx
  8021f3:	d3 e3                	shl    %cl,%ebx
  8021f5:	89 c1                	mov    %eax,%ecx
  8021f7:	d3 ea                	shr    %cl,%edx
  8021f9:	89 f9                	mov    %edi,%ecx
  8021fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ff:	89 eb                	mov    %ebp,%ebx
  802201:	d3 e6                	shl    %cl,%esi
  802203:	89 c1                	mov    %eax,%ecx
  802205:	d3 eb                	shr    %cl,%ebx
  802207:	09 de                	or     %ebx,%esi
  802209:	89 f0                	mov    %esi,%eax
  80220b:	f7 74 24 08          	divl   0x8(%esp)
  80220f:	89 d6                	mov    %edx,%esi
  802211:	89 c3                	mov    %eax,%ebx
  802213:	f7 64 24 0c          	mull   0xc(%esp)
  802217:	39 d6                	cmp    %edx,%esi
  802219:	72 15                	jb     802230 <__udivdi3+0x100>
  80221b:	89 f9                	mov    %edi,%ecx
  80221d:	d3 e5                	shl    %cl,%ebp
  80221f:	39 c5                	cmp    %eax,%ebp
  802221:	73 04                	jae    802227 <__udivdi3+0xf7>
  802223:	39 d6                	cmp    %edx,%esi
  802225:	74 09                	je     802230 <__udivdi3+0x100>
  802227:	89 d8                	mov    %ebx,%eax
  802229:	31 ff                	xor    %edi,%edi
  80222b:	e9 2b ff ff ff       	jmp    80215b <__udivdi3+0x2b>
  802230:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802233:	31 ff                	xor    %edi,%edi
  802235:	e9 21 ff ff ff       	jmp    80215b <__udivdi3+0x2b>
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <__umoddi3>:
  802240:	f3 0f 1e fb          	endbr32 
  802244:	55                   	push   %ebp
  802245:	57                   	push   %edi
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	83 ec 1c             	sub    $0x1c,%esp
  80224b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80224f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802253:	8b 74 24 30          	mov    0x30(%esp),%esi
  802257:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80225b:	89 da                	mov    %ebx,%edx
  80225d:	85 c0                	test   %eax,%eax
  80225f:	75 3f                	jne    8022a0 <__umoddi3+0x60>
  802261:	39 df                	cmp    %ebx,%edi
  802263:	76 13                	jbe    802278 <__umoddi3+0x38>
  802265:	89 f0                	mov    %esi,%eax
  802267:	f7 f7                	div    %edi
  802269:	89 d0                	mov    %edx,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	83 c4 1c             	add    $0x1c,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	89 fd                	mov    %edi,%ebp
  80227a:	85 ff                	test   %edi,%edi
  80227c:	75 0b                	jne    802289 <__umoddi3+0x49>
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f7                	div    %edi
  802287:	89 c5                	mov    %eax,%ebp
  802289:	89 d8                	mov    %ebx,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f5                	div    %ebp
  80228f:	89 f0                	mov    %esi,%eax
  802291:	f7 f5                	div    %ebp
  802293:	89 d0                	mov    %edx,%eax
  802295:	eb d4                	jmp    80226b <__umoddi3+0x2b>
  802297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	89 f1                	mov    %esi,%ecx
  8022a2:	39 d8                	cmp    %ebx,%eax
  8022a4:	76 0a                	jbe    8022b0 <__umoddi3+0x70>
  8022a6:	89 f0                	mov    %esi,%eax
  8022a8:	83 c4 1c             	add    $0x1c,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5f                   	pop    %edi
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    
  8022b0:	0f bd e8             	bsr    %eax,%ebp
  8022b3:	83 f5 1f             	xor    $0x1f,%ebp
  8022b6:	75 20                	jne    8022d8 <__umoddi3+0x98>
  8022b8:	39 d8                	cmp    %ebx,%eax
  8022ba:	0f 82 b0 00 00 00    	jb     802370 <__umoddi3+0x130>
  8022c0:	39 f7                	cmp    %esi,%edi
  8022c2:	0f 86 a8 00 00 00    	jbe    802370 <__umoddi3+0x130>
  8022c8:	89 c8                	mov    %ecx,%eax
  8022ca:	83 c4 1c             	add    $0x1c,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5e                   	pop    %esi
  8022cf:	5f                   	pop    %edi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    
  8022d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d8:	89 e9                	mov    %ebp,%ecx
  8022da:	ba 20 00 00 00       	mov    $0x20,%edx
  8022df:	29 ea                	sub    %ebp,%edx
  8022e1:	d3 e0                	shl    %cl,%eax
  8022e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022e7:	89 d1                	mov    %edx,%ecx
  8022e9:	89 f8                	mov    %edi,%eax
  8022eb:	d3 e8                	shr    %cl,%eax
  8022ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022f9:	09 c1                	or     %eax,%ecx
  8022fb:	89 d8                	mov    %ebx,%eax
  8022fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802301:	89 e9                	mov    %ebp,%ecx
  802303:	d3 e7                	shl    %cl,%edi
  802305:	89 d1                	mov    %edx,%ecx
  802307:	d3 e8                	shr    %cl,%eax
  802309:	89 e9                	mov    %ebp,%ecx
  80230b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80230f:	d3 e3                	shl    %cl,%ebx
  802311:	89 c7                	mov    %eax,%edi
  802313:	89 d1                	mov    %edx,%ecx
  802315:	89 f0                	mov    %esi,%eax
  802317:	d3 e8                	shr    %cl,%eax
  802319:	89 e9                	mov    %ebp,%ecx
  80231b:	89 fa                	mov    %edi,%edx
  80231d:	d3 e6                	shl    %cl,%esi
  80231f:	09 d8                	or     %ebx,%eax
  802321:	f7 74 24 08          	divl   0x8(%esp)
  802325:	89 d1                	mov    %edx,%ecx
  802327:	89 f3                	mov    %esi,%ebx
  802329:	f7 64 24 0c          	mull   0xc(%esp)
  80232d:	89 c6                	mov    %eax,%esi
  80232f:	89 d7                	mov    %edx,%edi
  802331:	39 d1                	cmp    %edx,%ecx
  802333:	72 06                	jb     80233b <__umoddi3+0xfb>
  802335:	75 10                	jne    802347 <__umoddi3+0x107>
  802337:	39 c3                	cmp    %eax,%ebx
  802339:	73 0c                	jae    802347 <__umoddi3+0x107>
  80233b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80233f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802343:	89 d7                	mov    %edx,%edi
  802345:	89 c6                	mov    %eax,%esi
  802347:	89 ca                	mov    %ecx,%edx
  802349:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80234e:	29 f3                	sub    %esi,%ebx
  802350:	19 fa                	sbb    %edi,%edx
  802352:	89 d0                	mov    %edx,%eax
  802354:	d3 e0                	shl    %cl,%eax
  802356:	89 e9                	mov    %ebp,%ecx
  802358:	d3 eb                	shr    %cl,%ebx
  80235a:	d3 ea                	shr    %cl,%edx
  80235c:	09 d8                	or     %ebx,%eax
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 da                	mov    %ebx,%edx
  802372:	29 fe                	sub    %edi,%esi
  802374:	19 c2                	sbb    %eax,%edx
  802376:	89 f1                	mov    %esi,%ecx
  802378:	89 c8                	mov    %ecx,%eax
  80237a:	e9 4b ff ff ff       	jmp    8022ca <__umoddi3+0x8a>
