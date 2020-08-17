
obj/user/icode.debug：     文件格式 elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 60 	movl   $0x802960,0x803000
  800045:	29 80 00 

	cprintf("icode startup\n");
  800048:	68 66 29 80 00       	push   $0x802966
  80004d:	e8 1d 02 00 00       	call   80026f <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 75 29 80 00 	movl   $0x802975,(%esp)
  800059:	e8 11 02 00 00       	call   80026f <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 88 29 80 00       	push   $0x802988
  800068:	e8 74 15 00 00       	call   8015e1 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 b1 29 80 00       	push   $0x8029b1
  80007e:	e8 ec 01 00 00       	call   80026f <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 9b 10 00 00       	call   801136 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 d5 0a 00 00       	call   800b81 <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 8e 29 80 00       	push   $0x80298e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 a4 29 80 00       	push   $0x8029a4
  8000be:	e8 d1 00 00 00       	call   800194 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 c4 29 80 00       	push   $0x8029c4
  8000cb:	e8 9f 01 00 00       	call   80026f <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 20 0f 00 00       	call   800ff8 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 d8 29 80 00 	movl   $0x8029d8,(%esp)
  8000df:	e8 8b 01 00 00       	call   80026f <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ec 29 80 00       	push   $0x8029ec
  8000f0:	68 f5 29 80 00       	push   $0x8029f5
  8000f5:	68 ff 29 80 00       	push   $0x8029ff
  8000fa:	68 fe 29 80 00       	push   $0x8029fe
  8000ff:	e8 04 1b 00 00       	call   801c08 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 1b 2a 80 00       	push   $0x802a1b
  800113:	e8 57 01 00 00       	call   80026f <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 04 2a 80 00       	push   $0x802a04
  800128:	6a 1a                	push   $0x1a
  80012a:	68 a4 29 80 00       	push   $0x8029a4
  80012f:	e8 60 00 00 00       	call   800194 <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 bb 0a 00 00       	call   800bff <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800180:	e8 a0 0e 00 00       	call   801025 <close_all>
	sys_env_destroy(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 2f 0a 00 00       	call   800bbe <sys_env_destroy>
}
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800199:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a2:	e8 58 0a 00 00       	call   800bff <sys_getenvid>
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	56                   	push   %esi
  8001b1:	50                   	push   %eax
  8001b2:	68 38 2a 80 00       	push   $0x802a38
  8001b7:	e8 b3 00 00 00       	call   80026f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bc:	83 c4 18             	add    $0x18,%esp
  8001bf:	53                   	push   %ebx
  8001c0:	ff 75 10             	pushl  0x10(%ebp)
  8001c3:	e8 56 00 00 00       	call   80021e <vcprintf>
	cprintf("\n");
  8001c8:	c7 04 24 56 2f 80 00 	movl   $0x802f56,(%esp)
  8001cf:	e8 9b 00 00 00       	call   80026f <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d7:	cc                   	int3   
  8001d8:	eb fd                	jmp    8001d7 <_panic+0x43>

008001da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e4:	8b 13                	mov    (%ebx),%edx
  8001e6:	8d 42 01             	lea    0x1(%edx),%eax
  8001e9:	89 03                	mov    %eax,(%ebx)
  8001eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f7:	74 09                	je     800202 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800200:	c9                   	leave  
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 43 08             	lea    0x8(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 6e 09 00 00       	call   800b81 <sys_cputs>
		b->idx = 0;
  800213:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb db                	jmp    8001f9 <putch+0x1f>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800227:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022e:	00 00 00 
	b.cnt = 0;
  800231:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800238:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	68 da 01 80 00       	push   $0x8001da
  80024d:	e8 19 01 00 00       	call   80036b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800252:	83 c4 08             	add    $0x8,%esp
  800255:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	e8 1a 09 00 00       	call   800b81 <sys_cputs>

	return b.cnt;
}
  800267:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800275:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 9d ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 1c             	sub    $0x1c,%esp
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	89 d6                	mov    %edx,%esi
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002ad:	89 d0                	mov    %edx,%eax
  8002af:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8002b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b5:	73 15                	jae    8002cc <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b7:	83 eb 01             	sub    $0x1,%ebx
  8002ba:	85 db                	test   %ebx,%ebx
  8002bc:	7e 43                	jle    800301 <printnum+0x7e>
			putch(padc, putdat);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	56                   	push   %esi
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	ff d7                	call   *%edi
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	eb eb                	jmp    8002b7 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	ff 75 18             	pushl  0x18(%ebp)
  8002d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002d8:	53                   	push   %ebx
  8002d9:	ff 75 10             	pushl  0x10(%ebp)
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 20 24 00 00       	call   802710 <__udivdi3>
  8002f0:	83 c4 18             	add    $0x18,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	89 f2                	mov    %esi,%edx
  8002f7:	89 f8                	mov    %edi,%eax
  8002f9:	e8 85 ff ff ff       	call   800283 <printnum>
  8002fe:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	56                   	push   %esi
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030b:	ff 75 e0             	pushl  -0x20(%ebp)
  80030e:	ff 75 dc             	pushl  -0x24(%ebp)
  800311:	ff 75 d8             	pushl  -0x28(%ebp)
  800314:	e8 07 25 00 00       	call   802820 <__umoddi3>
  800319:	83 c4 14             	add    $0x14,%esp
  80031c:	0f be 80 5b 2a 80 00 	movsbl 0x802a5b(%eax),%eax
  800323:	50                   	push   %eax
  800324:	ff d7                	call   *%edi
}
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800337:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033b:	8b 10                	mov    (%eax),%edx
  80033d:	3b 50 04             	cmp    0x4(%eax),%edx
  800340:	73 0a                	jae    80034c <sprintputch+0x1b>
		*b->buf++ = ch;
  800342:	8d 4a 01             	lea    0x1(%edx),%ecx
  800345:	89 08                	mov    %ecx,(%eax)
  800347:	8b 45 08             	mov    0x8(%ebp),%eax
  80034a:	88 02                	mov    %al,(%edx)
}
  80034c:	5d                   	pop    %ebp
  80034d:	c3                   	ret    

0080034e <printfmt>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800354:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800357:	50                   	push   %eax
  800358:	ff 75 10             	pushl  0x10(%ebp)
  80035b:	ff 75 0c             	pushl  0xc(%ebp)
  80035e:	ff 75 08             	pushl  0x8(%ebp)
  800361:	e8 05 00 00 00       	call   80036b <vprintfmt>
}
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <vprintfmt>:
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	57                   	push   %edi
  80036f:	56                   	push   %esi
  800370:	53                   	push   %ebx
  800371:	83 ec 3c             	sub    $0x3c,%esp
  800374:	8b 75 08             	mov    0x8(%ebp),%esi
  800377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037d:	eb 0a                	jmp    800389 <vprintfmt+0x1e>
			putch(ch, putdat);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	53                   	push   %ebx
  800383:	50                   	push   %eax
  800384:	ff d6                	call   *%esi
  800386:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800389:	83 c7 01             	add    $0x1,%edi
  80038c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800390:	83 f8 25             	cmp    $0x25,%eax
  800393:	74 0c                	je     8003a1 <vprintfmt+0x36>
			if (ch == '\0')
  800395:	85 c0                	test   %eax,%eax
  800397:	75 e6                	jne    80037f <vprintfmt+0x14>
}
  800399:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039c:	5b                   	pop    %ebx
  80039d:	5e                   	pop    %esi
  80039e:	5f                   	pop    %edi
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    
		padc = ' ';
  8003a1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ba:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8d 47 01             	lea    0x1(%edi),%eax
  8003c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c5:	0f b6 17             	movzbl (%edi),%edx
  8003c8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cb:	3c 55                	cmp    $0x55,%al
  8003cd:	0f 87 ba 03 00 00    	ja     80078d <vprintfmt+0x422>
  8003d3:	0f b6 c0             	movzbl %al,%eax
  8003d6:	ff 24 85 a0 2b 80 00 	jmp    *0x802ba0(,%eax,4)
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e4:	eb d9                	jmp    8003bf <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e9:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003ed:	eb d0                	jmp    8003bf <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	0f b6 d2             	movzbl %dl,%edx
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800400:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800404:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800407:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040a:	83 f9 09             	cmp    $0x9,%ecx
  80040d:	77 55                	ja     800464 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80040f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800412:	eb e9                	jmp    8003fd <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8d 40 04             	lea    0x4(%eax),%eax
  800422:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042c:	79 91                	jns    8003bf <vprintfmt+0x54>
				width = precision, precision = -1;
  80042e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800431:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800434:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80043b:	eb 82                	jmp    8003bf <vprintfmt+0x54>
  80043d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
  800447:	0f 49 d0             	cmovns %eax,%edx
  80044a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800450:	e9 6a ff ff ff       	jmp    8003bf <vprintfmt+0x54>
  800455:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800458:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80045f:	e9 5b ff ff ff       	jmp    8003bf <vprintfmt+0x54>
  800464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	eb bc                	jmp    800428 <vprintfmt+0xbd>
			lflag++;
  80046c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800472:	e9 48 ff ff ff       	jmp    8003bf <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 78 04             	lea    0x4(%eax),%edi
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	ff 30                	pushl  (%eax)
  800483:	ff d6                	call   *%esi
			break;
  800485:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048b:	e9 9c 02 00 00       	jmp    80072c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 78 04             	lea    0x4(%eax),%edi
  800496:	8b 00                	mov    (%eax),%eax
  800498:	99                   	cltd   
  800499:	31 d0                	xor    %edx,%eax
  80049b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049d:	83 f8 0f             	cmp    $0xf,%eax
  8004a0:	7f 23                	jg     8004c5 <vprintfmt+0x15a>
  8004a2:	8b 14 85 00 2d 80 00 	mov    0x802d00(,%eax,4),%edx
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	74 18                	je     8004c5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8004ad:	52                   	push   %edx
  8004ae:	68 3a 2e 80 00       	push   $0x802e3a
  8004b3:	53                   	push   %ebx
  8004b4:	56                   	push   %esi
  8004b5:	e8 94 fe ff ff       	call   80034e <printfmt>
  8004ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c0:	e9 67 02 00 00       	jmp    80072c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8004c5:	50                   	push   %eax
  8004c6:	68 73 2a 80 00       	push   $0x802a73
  8004cb:	53                   	push   %ebx
  8004cc:	56                   	push   %esi
  8004cd:	e8 7c fe ff ff       	call   80034e <printfmt>
  8004d2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d8:	e9 4f 02 00 00       	jmp    80072c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	83 c0 04             	add    $0x4,%eax
  8004e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004eb:	85 d2                	test   %edx,%edx
  8004ed:	b8 6c 2a 80 00       	mov    $0x802a6c,%eax
  8004f2:	0f 45 c2             	cmovne %edx,%eax
  8004f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fc:	7e 06                	jle    800504 <vprintfmt+0x199>
  8004fe:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800502:	75 0d                	jne    800511 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800507:	89 c7                	mov    %eax,%edi
  800509:	03 45 e0             	add    -0x20(%ebp),%eax
  80050c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050f:	eb 3f                	jmp    800550 <vprintfmt+0x1e5>
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	ff 75 d8             	pushl  -0x28(%ebp)
  800517:	50                   	push   %eax
  800518:	e8 0d 03 00 00       	call   80082a <strnlen>
  80051d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800520:	29 c2                	sub    %eax,%edx
  800522:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800525:	83 c4 10             	add    $0x10,%esp
  800528:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80052a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80052e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800531:	85 ff                	test   %edi,%edi
  800533:	7e 58                	jle    80058d <vprintfmt+0x222>
					putch(padc, putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	ff 75 e0             	pushl  -0x20(%ebp)
  80053c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053e:	83 ef 01             	sub    $0x1,%edi
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb eb                	jmp    800531 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	52                   	push   %edx
  80054b:	ff d6                	call   *%esi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 c7 01             	add    $0x1,%edi
  800558:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055c:	0f be d0             	movsbl %al,%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	74 45                	je     8005a8 <vprintfmt+0x23d>
  800563:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800567:	78 06                	js     80056f <vprintfmt+0x204>
  800569:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056d:	78 35                	js     8005a4 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80056f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800573:	74 d1                	je     800546 <vprintfmt+0x1db>
  800575:	0f be c0             	movsbl %al,%eax
  800578:	83 e8 20             	sub    $0x20,%eax
  80057b:	83 f8 5e             	cmp    $0x5e,%eax
  80057e:	76 c6                	jbe    800546 <vprintfmt+0x1db>
					putch('?', putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	6a 3f                	push   $0x3f
  800586:	ff d6                	call   *%esi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	eb c3                	jmp    800550 <vprintfmt+0x1e5>
  80058d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800590:	85 d2                	test   %edx,%edx
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	0f 49 c2             	cmovns %edx,%eax
  80059a:	29 c2                	sub    %eax,%edx
  80059c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80059f:	e9 60 ff ff ff       	jmp    800504 <vprintfmt+0x199>
  8005a4:	89 cf                	mov    %ecx,%edi
  8005a6:	eb 02                	jmp    8005aa <vprintfmt+0x23f>
  8005a8:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8005aa:	85 ff                	test   %edi,%edi
  8005ac:	7e 10                	jle    8005be <vprintfmt+0x253>
				putch(' ', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 20                	push   $0x20
  8005b4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	eb ec                	jmp    8005aa <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 63 01 00 00       	jmp    80072c <vprintfmt+0x3c1>
	if (lflag >= 2)
  8005c9:	83 f9 01             	cmp    $0x1,%ecx
  8005cc:	7f 1b                	jg     8005e9 <vprintfmt+0x27e>
	else if (lflag)
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	74 63                	je     800635 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005da:	99                   	cltd   
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e7:	eb 17                	jmp    800600 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 08             	lea    0x8(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800600:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800603:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060b:	85 c9                	test   %ecx,%ecx
  80060d:	0f 89 ff 00 00 00    	jns    800712 <vprintfmt+0x3a7>
				putch('-', putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	6a 2d                	push   $0x2d
  800619:	ff d6                	call   *%esi
				num = -(long long) num;
  80061b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800621:	f7 da                	neg    %edx
  800623:	83 d1 00             	adc    $0x0,%ecx
  800626:	f7 d9                	neg    %ecx
  800628:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800630:	e9 dd 00 00 00       	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	99                   	cltd   
  80063e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	eb b4                	jmp    800600 <vprintfmt+0x295>
	if (lflag >= 2)
  80064c:	83 f9 01             	cmp    $0x1,%ecx
  80064f:	7f 1e                	jg     80066f <vprintfmt+0x304>
	else if (lflag)
  800651:	85 c9                	test   %ecx,%ecx
  800653:	74 32                	je     800687 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 10                	mov    (%eax),%edx
  80065a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800665:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066a:	e9 a3 00 00 00       	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 10                	mov    (%eax),%edx
  800674:	8b 48 04             	mov    0x4(%eax),%ecx
  800677:	8d 40 08             	lea    0x8(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800682:	e9 8b 00 00 00       	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 10                	mov    (%eax),%edx
  80068c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800697:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069c:	eb 74                	jmp    800712 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80069e:	83 f9 01             	cmp    $0x1,%ecx
  8006a1:	7f 1b                	jg     8006be <vprintfmt+0x353>
	else if (lflag)
  8006a3:	85 c9                	test   %ecx,%ecx
  8006a5:	74 2c                	je     8006d3 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bc:	eb 54                	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 10                	mov    (%eax),%edx
  8006c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c6:	8d 40 08             	lea    0x8(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d1:	eb 3f                	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 10                	mov    (%eax),%edx
  8006d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e8:	eb 28                	jmp    800712 <vprintfmt+0x3a7>
			putch('0', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 30                	push   $0x30
  8006f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f2:	83 c4 08             	add    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 78                	push   $0x78
  8006f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 10                	mov    (%eax),%edx
  8006ff:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800704:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800712:	83 ec 0c             	sub    $0xc,%esp
  800715:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800719:	57                   	push   %edi
  80071a:	ff 75 e0             	pushl  -0x20(%ebp)
  80071d:	50                   	push   %eax
  80071e:	51                   	push   %ecx
  80071f:	52                   	push   %edx
  800720:	89 da                	mov    %ebx,%edx
  800722:	89 f0                	mov    %esi,%eax
  800724:	e8 5a fb ff ff       	call   800283 <printnum>
			break;
  800729:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80072c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072f:	e9 55 fc ff ff       	jmp    800389 <vprintfmt+0x1e>
	if (lflag >= 2)
  800734:	83 f9 01             	cmp    $0x1,%ecx
  800737:	7f 1b                	jg     800754 <vprintfmt+0x3e9>
	else if (lflag)
  800739:	85 c9                	test   %ecx,%ecx
  80073b:	74 2c                	je     800769 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074d:	b8 10 00 00 00       	mov    $0x10,%eax
  800752:	eb be                	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 10                	mov    (%eax),%edx
  800759:	8b 48 04             	mov    0x4(%eax),%ecx
  80075c:	8d 40 08             	lea    0x8(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
  800767:	eb a9                	jmp    800712 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800779:	b8 10 00 00 00       	mov    $0x10,%eax
  80077e:	eb 92                	jmp    800712 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 25                	push   $0x25
  800786:	ff d6                	call   *%esi
			break;
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	eb 9f                	jmp    80072c <vprintfmt+0x3c1>
			putch('%', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	53                   	push   %ebx
  800791:	6a 25                	push   $0x25
  800793:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 f8                	mov    %edi,%eax
  80079a:	eb 03                	jmp    80079f <vprintfmt+0x434>
  80079c:	83 e8 01             	sub    $0x1,%eax
  80079f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a3:	75 f7                	jne    80079c <vprintfmt+0x431>
  8007a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a8:	eb 82                	jmp    80072c <vprintfmt+0x3c1>

008007aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	74 26                	je     8007f1 <vsnprintf+0x47>
  8007cb:	85 d2                	test   %edx,%edx
  8007cd:	7e 22                	jle    8007f1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cf:	ff 75 14             	pushl  0x14(%ebp)
  8007d2:	ff 75 10             	pushl  0x10(%ebp)
  8007d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	68 31 03 80 00       	push   $0x800331
  8007de:	e8 88 fb ff ff       	call   80036b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ec:	83 c4 10             	add    $0x10,%esp
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    
		return -E_INVAL;
  8007f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f6:	eb f7                	jmp    8007ef <vsnprintf+0x45>

008007f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800801:	50                   	push   %eax
  800802:	ff 75 10             	pushl  0x10(%ebp)
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	ff 75 08             	pushl  0x8(%ebp)
  80080b:	e8 9a ff ff ff       	call   8007aa <vsnprintf>
	va_end(ap);

	return rc;
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800818:	b8 00 00 00 00       	mov    $0x0,%eax
  80081d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800821:	74 05                	je     800828 <strlen+0x16>
		n++;
  800823:	83 c0 01             	add    $0x1,%eax
  800826:	eb f5                	jmp    80081d <strlen+0xb>
	return n;
}
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800830:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
  800838:	39 c2                	cmp    %eax,%edx
  80083a:	74 0d                	je     800849 <strnlen+0x1f>
  80083c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800840:	74 05                	je     800847 <strnlen+0x1d>
		n++;
  800842:	83 c2 01             	add    $0x1,%edx
  800845:	eb f1                	jmp    800838 <strnlen+0xe>
  800847:	89 d0                	mov    %edx,%eax
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80085e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800861:	83 c2 01             	add    $0x1,%edx
  800864:	84 c9                	test   %cl,%cl
  800866:	75 f2                	jne    80085a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	83 ec 10             	sub    $0x10,%esp
  800872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800875:	53                   	push   %ebx
  800876:	e8 97 ff ff ff       	call   800812 <strlen>
  80087b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	01 d8                	add    %ebx,%eax
  800883:	50                   	push   %eax
  800884:	e8 c2 ff ff ff       	call   80084b <strcpy>
	return dst;
}
  800889:	89 d8                	mov    %ebx,%eax
  80088b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089b:	89 c6                	mov    %eax,%esi
  80089d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a0:	89 c2                	mov    %eax,%edx
  8008a2:	39 f2                	cmp    %esi,%edx
  8008a4:	74 11                	je     8008b7 <strncpy+0x27>
		*dst++ = *src;
  8008a6:	83 c2 01             	add    $0x1,%edx
  8008a9:	0f b6 19             	movzbl (%ecx),%ebx
  8008ac:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008af:	80 fb 01             	cmp    $0x1,%bl
  8008b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008b5:	eb eb                	jmp    8008a2 <strncpy+0x12>
	}
	return ret;
}
  8008b7:	5b                   	pop    %ebx
  8008b8:	5e                   	pop    %esi
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8008c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	74 21                	je     8008f0 <strlcpy+0x35>
  8008cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008d5:	39 c2                	cmp    %eax,%edx
  8008d7:	74 14                	je     8008ed <strlcpy+0x32>
  8008d9:	0f b6 19             	movzbl (%ecx),%ebx
  8008dc:	84 db                	test   %bl,%bl
  8008de:	74 0b                	je     8008eb <strlcpy+0x30>
			*dst++ = *src++;
  8008e0:	83 c1 01             	add    $0x1,%ecx
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e9:	eb ea                	jmp    8008d5 <strlcpy+0x1a>
  8008eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f0:	29 f0                	sub    %esi,%eax
}
  8008f2:	5b                   	pop    %ebx
  8008f3:	5e                   	pop    %esi
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ff:	0f b6 01             	movzbl (%ecx),%eax
  800902:	84 c0                	test   %al,%al
  800904:	74 0c                	je     800912 <strcmp+0x1c>
  800906:	3a 02                	cmp    (%edx),%al
  800908:	75 08                	jne    800912 <strcmp+0x1c>
		p++, q++;
  80090a:	83 c1 01             	add    $0x1,%ecx
  80090d:	83 c2 01             	add    $0x1,%edx
  800910:	eb ed                	jmp    8008ff <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800912:	0f b6 c0             	movzbl %al,%eax
  800915:	0f b6 12             	movzbl (%edx),%edx
  800918:	29 d0                	sub    %edx,%eax
}
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	53                   	push   %ebx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
  800926:	89 c3                	mov    %eax,%ebx
  800928:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092b:	eb 06                	jmp    800933 <strncmp+0x17>
		n--, p++, q++;
  80092d:	83 c0 01             	add    $0x1,%eax
  800930:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800933:	39 d8                	cmp    %ebx,%eax
  800935:	74 16                	je     80094d <strncmp+0x31>
  800937:	0f b6 08             	movzbl (%eax),%ecx
  80093a:	84 c9                	test   %cl,%cl
  80093c:	74 04                	je     800942 <strncmp+0x26>
  80093e:	3a 0a                	cmp    (%edx),%cl
  800940:	74 eb                	je     80092d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800942:	0f b6 00             	movzbl (%eax),%eax
  800945:	0f b6 12             	movzbl (%edx),%edx
  800948:	29 d0                	sub    %edx,%eax
}
  80094a:	5b                   	pop    %ebx
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    
		return 0;
  80094d:	b8 00 00 00 00       	mov    $0x0,%eax
  800952:	eb f6                	jmp    80094a <strncmp+0x2e>

00800954 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	74 09                	je     80096e <strchr+0x1a>
		if (*s == c)
  800965:	38 ca                	cmp    %cl,%dl
  800967:	74 0a                	je     800973 <strchr+0x1f>
	for (; *s; s++)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	eb f0                	jmp    80095e <strchr+0xa>
			return (char *) s;
	return 0;
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800982:	38 ca                	cmp    %cl,%dl
  800984:	74 09                	je     80098f <strfind+0x1a>
  800986:	84 d2                	test   %dl,%dl
  800988:	74 05                	je     80098f <strfind+0x1a>
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	eb f0                	jmp    80097f <strfind+0xa>
			break;
	return (char *) s;
}
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	57                   	push   %edi
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099d:	85 c9                	test   %ecx,%ecx
  80099f:	74 31                	je     8009d2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a1:	89 f8                	mov    %edi,%eax
  8009a3:	09 c8                	or     %ecx,%eax
  8009a5:	a8 03                	test   $0x3,%al
  8009a7:	75 23                	jne    8009cc <memset+0x3b>
		c &= 0xFF;
  8009a9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ad:	89 d3                	mov    %edx,%ebx
  8009af:	c1 e3 08             	shl    $0x8,%ebx
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 18             	shl    $0x18,%eax
  8009b7:	89 d6                	mov    %edx,%esi
  8009b9:	c1 e6 10             	shl    $0x10,%esi
  8009bc:	09 f0                	or     %esi,%eax
  8009be:	09 c2                	or     %eax,%edx
  8009c0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	fc                   	cld    
  8009c8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ca:	eb 06                	jmp    8009d2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d2:	89 f8                	mov    %edi,%eax
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5f                   	pop    %edi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	57                   	push   %edi
  8009dd:	56                   	push   %esi
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e7:	39 c6                	cmp    %eax,%esi
  8009e9:	73 32                	jae    800a1d <memmove+0x44>
  8009eb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ee:	39 c2                	cmp    %eax,%edx
  8009f0:	76 2b                	jbe    800a1d <memmove+0x44>
		s += n;
		d += n;
  8009f2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f5:	89 fe                	mov    %edi,%esi
  8009f7:	09 ce                	or     %ecx,%esi
  8009f9:	09 d6                	or     %edx,%esi
  8009fb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a01:	75 0e                	jne    800a11 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a03:	83 ef 04             	sub    $0x4,%edi
  800a06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a0c:	fd                   	std    
  800a0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0f:	eb 09                	jmp    800a1a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a11:	83 ef 01             	sub    $0x1,%edi
  800a14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a17:	fd                   	std    
  800a18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1a:	fc                   	cld    
  800a1b:	eb 1a                	jmp    800a37 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	09 ca                	or     %ecx,%edx
  800a21:	09 f2                	or     %esi,%edx
  800a23:	f6 c2 03             	test   $0x3,%dl
  800a26:	75 0a                	jne    800a32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a2b:	89 c7                	mov    %eax,%edi
  800a2d:	fc                   	cld    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb 05                	jmp    800a37 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	fc                   	cld    
  800a35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a37:	5e                   	pop    %esi
  800a38:	5f                   	pop    %edi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a41:	ff 75 10             	pushl  0x10(%ebp)
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	ff 75 08             	pushl  0x8(%ebp)
  800a4a:	e8 8a ff ff ff       	call   8009d9 <memmove>
}
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    

00800a51 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	89 c6                	mov    %eax,%esi
  800a5e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a61:	39 f0                	cmp    %esi,%eax
  800a63:	74 1c                	je     800a81 <memcmp+0x30>
		if (*s1 != *s2)
  800a65:	0f b6 08             	movzbl (%eax),%ecx
  800a68:	0f b6 1a             	movzbl (%edx),%ebx
  800a6b:	38 d9                	cmp    %bl,%cl
  800a6d:	75 08                	jne    800a77 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6f:	83 c0 01             	add    $0x1,%eax
  800a72:	83 c2 01             	add    $0x1,%edx
  800a75:	eb ea                	jmp    800a61 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a77:	0f b6 c1             	movzbl %cl,%eax
  800a7a:	0f b6 db             	movzbl %bl,%ebx
  800a7d:	29 d8                	sub    %ebx,%eax
  800a7f:	eb 05                	jmp    800a86 <memcmp+0x35>
	}

	return 0;
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a93:	89 c2                	mov    %eax,%edx
  800a95:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a98:	39 d0                	cmp    %edx,%eax
  800a9a:	73 09                	jae    800aa5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9c:	38 08                	cmp    %cl,(%eax)
  800a9e:	74 05                	je     800aa5 <memfind+0x1b>
	for (; s < ends; s++)
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	eb f3                	jmp    800a98 <memfind+0xe>
			break;
	return (void *) s;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab3:	eb 03                	jmp    800ab8 <strtol+0x11>
		s++;
  800ab5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab8:	0f b6 01             	movzbl (%ecx),%eax
  800abb:	3c 20                	cmp    $0x20,%al
  800abd:	74 f6                	je     800ab5 <strtol+0xe>
  800abf:	3c 09                	cmp    $0x9,%al
  800ac1:	74 f2                	je     800ab5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac3:	3c 2b                	cmp    $0x2b,%al
  800ac5:	74 2a                	je     800af1 <strtol+0x4a>
	int neg = 0;
  800ac7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800acc:	3c 2d                	cmp    $0x2d,%al
  800ace:	74 2b                	je     800afb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad6:	75 0f                	jne    800ae7 <strtol+0x40>
  800ad8:	80 39 30             	cmpb   $0x30,(%ecx)
  800adb:	74 28                	je     800b05 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800add:	85 db                	test   %ebx,%ebx
  800adf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae4:	0f 44 d8             	cmove  %eax,%ebx
  800ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aef:	eb 50                	jmp    800b41 <strtol+0x9a>
		s++;
  800af1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af4:	bf 00 00 00 00       	mov    $0x0,%edi
  800af9:	eb d5                	jmp    800ad0 <strtol+0x29>
		s++, neg = 1;
  800afb:	83 c1 01             	add    $0x1,%ecx
  800afe:	bf 01 00 00 00       	mov    $0x1,%edi
  800b03:	eb cb                	jmp    800ad0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b05:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b09:	74 0e                	je     800b19 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b0b:	85 db                	test   %ebx,%ebx
  800b0d:	75 d8                	jne    800ae7 <strtol+0x40>
		s++, base = 8;
  800b0f:	83 c1 01             	add    $0x1,%ecx
  800b12:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b17:	eb ce                	jmp    800ae7 <strtol+0x40>
		s += 2, base = 16;
  800b19:	83 c1 02             	add    $0x2,%ecx
  800b1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b21:	eb c4                	jmp    800ae7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b23:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b26:	89 f3                	mov    %esi,%ebx
  800b28:	80 fb 19             	cmp    $0x19,%bl
  800b2b:	77 29                	ja     800b56 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b2d:	0f be d2             	movsbl %dl,%edx
  800b30:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b36:	7d 30                	jge    800b68 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b41:	0f b6 11             	movzbl (%ecx),%edx
  800b44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b47:	89 f3                	mov    %esi,%ebx
  800b49:	80 fb 09             	cmp    $0x9,%bl
  800b4c:	77 d5                	ja     800b23 <strtol+0x7c>
			dig = *s - '0';
  800b4e:	0f be d2             	movsbl %dl,%edx
  800b51:	83 ea 30             	sub    $0x30,%edx
  800b54:	eb dd                	jmp    800b33 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b56:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 19             	cmp    $0x19,%bl
  800b5e:	77 08                	ja     800b68 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b60:	0f be d2             	movsbl %dl,%edx
  800b63:	83 ea 37             	sub    $0x37,%edx
  800b66:	eb cb                	jmp    800b33 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6c:	74 05                	je     800b73 <strtol+0xcc>
		*endptr = (char *) s;
  800b6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b71:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b73:	89 c2                	mov    %eax,%edx
  800b75:	f7 da                	neg    %edx
  800b77:	85 ff                	test   %edi,%edi
  800b79:	0f 45 c2             	cmovne %edx,%eax
}
  800b7c:	5b                   	pop    %ebx
  800b7d:	5e                   	pop    %esi
  800b7e:	5f                   	pop    %edi
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	57                   	push   %edi
  800b85:	56                   	push   %esi
  800b86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b92:	89 c3                	mov    %eax,%ebx
  800b94:	89 c7                	mov    %eax,%edi
  800b96:	89 c6                	mov    %eax,%esi
  800b98:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	b8 01 00 00 00       	mov    $0x1,%eax
  800baf:	89 d1                	mov    %edx,%ecx
  800bb1:	89 d3                	mov    %edx,%ebx
  800bb3:	89 d7                	mov    %edx,%edi
  800bb5:	89 d6                	mov    %edx,%esi
  800bb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5f                   	pop    %edi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd4:	89 cb                	mov    %ecx,%ebx
  800bd6:	89 cf                	mov    %ecx,%edi
  800bd8:	89 ce                	mov    %ecx,%esi
  800bda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdc:	85 c0                	test   %eax,%eax
  800bde:	7f 08                	jg     800be8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be8:	83 ec 0c             	sub    $0xc,%esp
  800beb:	50                   	push   %eax
  800bec:	6a 03                	push   $0x3
  800bee:	68 5f 2d 80 00       	push   $0x802d5f
  800bf3:	6a 23                	push   $0x23
  800bf5:	68 7c 2d 80 00       	push   $0x802d7c
  800bfa:	e8 95 f5 ff ff       	call   800194 <_panic>

00800bff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c05:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0f:	89 d1                	mov    %edx,%ecx
  800c11:	89 d3                	mov    %edx,%ebx
  800c13:	89 d7                	mov    %edx,%edi
  800c15:	89 d6                	mov    %edx,%esi
  800c17:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <sys_yield>:

void
sys_yield(void)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c2e:	89 d1                	mov    %edx,%ecx
  800c30:	89 d3                	mov    %edx,%ebx
  800c32:	89 d7                	mov    %edx,%edi
  800c34:	89 d6                	mov    %edx,%esi
  800c36:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c46:	be 00 00 00 00       	mov    $0x0,%esi
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c51:	b8 04 00 00 00       	mov    $0x4,%eax
  800c56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c59:	89 f7                	mov    %esi,%edi
  800c5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	7f 08                	jg     800c69 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	50                   	push   %eax
  800c6d:	6a 04                	push   $0x4
  800c6f:	68 5f 2d 80 00       	push   $0x802d5f
  800c74:	6a 23                	push   $0x23
  800c76:	68 7c 2d 80 00       	push   $0x802d7c
  800c7b:	e8 14 f5 ff ff       	call   800194 <_panic>

00800c80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 05                	push   $0x5
  800cb1:	68 5f 2d 80 00       	push   $0x802d5f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 7c 2d 80 00       	push   $0x802d7c
  800cbd:	e8 d2 f4 ff ff       	call   800194 <_panic>

00800cc2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800cdb:	89 df                	mov    %ebx,%edi
  800cdd:	89 de                	mov    %ebx,%esi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ced:	83 ec 0c             	sub    $0xc,%esp
  800cf0:	50                   	push   %eax
  800cf1:	6a 06                	push   $0x6
  800cf3:	68 5f 2d 80 00       	push   $0x802d5f
  800cf8:	6a 23                	push   $0x23
  800cfa:	68 7c 2d 80 00       	push   $0x802d7c
  800cff:	e8 90 f4 ff ff       	call   800194 <_panic>

00800d04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	b8 08 00 00 00       	mov    $0x8,%eax
  800d1d:	89 df                	mov    %ebx,%edi
  800d1f:	89 de                	mov    %ebx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 08                	push   $0x8
  800d35:	68 5f 2d 80 00       	push   $0x802d5f
  800d3a:	6a 23                	push   $0x23
  800d3c:	68 7c 2d 80 00       	push   $0x802d7c
  800d41:	e8 4e f4 ff ff       	call   800194 <_panic>

00800d46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d5f:	89 df                	mov    %ebx,%edi
  800d61:	89 de                	mov    %ebx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 09                	push   $0x9
  800d77:	68 5f 2d 80 00       	push   $0x802d5f
  800d7c:	6a 23                	push   $0x23
  800d7e:	68 7c 2d 80 00       	push   $0x802d7c
  800d83:	e8 0c f4 ff ff       	call   800194 <_panic>

00800d88 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da1:	89 df                	mov    %ebx,%edi
  800da3:	89 de                	mov    %ebx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 0a                	push   $0xa
  800db9:	68 5f 2d 80 00       	push   $0x802d5f
  800dbe:	6a 23                	push   $0x23
  800dc0:	68 7c 2d 80 00       	push   $0x802d7c
  800dc5:	e8 ca f3 ff ff       	call   800194 <_panic>

00800dca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ddb:	be 00 00 00 00       	mov    $0x0,%esi
  800de0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e03:	89 cb                	mov    %ecx,%ebx
  800e05:	89 cf                	mov    %ecx,%edi
  800e07:	89 ce                	mov    %ecx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 0d                	push   $0xd
  800e1d:	68 5f 2d 80 00       	push   $0x802d5f
  800e22:	6a 23                	push   $0x23
  800e24:	68 7c 2d 80 00       	push   $0x802d7c
  800e29:	e8 66 f3 ff ff       	call   800194 <_panic>

00800e2e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e34:	ba 00 00 00 00       	mov    $0x0,%edx
  800e39:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3e:	89 d1                	mov    %edx,%ecx
  800e40:	89 d3                	mov    %edx,%ebx
  800e42:	89 d7                	mov    %edx,%edi
  800e44:	89 d6                	mov    %edx,%esi
  800e46:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	05 00 00 00 30       	add    $0x30000000,%eax
  800e58:	c1 e8 0c             	shr    $0xc,%eax
}
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e6d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	c1 ea 16             	shr    $0x16,%edx
  800e81:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e88:	f6 c2 01             	test   $0x1,%dl
  800e8b:	74 2d                	je     800eba <fd_alloc+0x46>
  800e8d:	89 c2                	mov    %eax,%edx
  800e8f:	c1 ea 0c             	shr    $0xc,%edx
  800e92:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e99:	f6 c2 01             	test   $0x1,%dl
  800e9c:	74 1c                	je     800eba <fd_alloc+0x46>
  800e9e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ea3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ea8:	75 d2                	jne    800e7c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800eb3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eb8:	eb 0a                	jmp    800ec4 <fd_alloc+0x50>
			*fd_store = fd;
  800eba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ecc:	83 f8 1f             	cmp    $0x1f,%eax
  800ecf:	77 30                	ja     800f01 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ed1:	c1 e0 0c             	shl    $0xc,%eax
  800ed4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ed9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800edf:	f6 c2 01             	test   $0x1,%dl
  800ee2:	74 24                	je     800f08 <fd_lookup+0x42>
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	c1 ea 0c             	shr    $0xc,%edx
  800ee9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ef0:	f6 c2 01             	test   $0x1,%dl
  800ef3:	74 1a                	je     800f0f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	89 02                	mov    %eax,(%edx)
	return 0;
  800efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		return -E_INVAL;
  800f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f06:	eb f7                	jmp    800eff <fd_lookup+0x39>
		return -E_INVAL;
  800f08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0d:	eb f0                	jmp    800eff <fd_lookup+0x39>
  800f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f14:	eb e9                	jmp    800eff <fd_lookup+0x39>

00800f16 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f29:	39 08                	cmp    %ecx,(%eax)
  800f2b:	74 38                	je     800f65 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f2d:	83 c2 01             	add    $0x1,%edx
  800f30:	8b 04 95 08 2e 80 00 	mov    0x802e08(,%edx,4),%eax
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 ee                	jne    800f29 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f3b:	a1 08 40 80 00       	mov    0x804008,%eax
  800f40:	8b 40 48             	mov    0x48(%eax),%eax
  800f43:	83 ec 04             	sub    $0x4,%esp
  800f46:	51                   	push   %ecx
  800f47:	50                   	push   %eax
  800f48:	68 8c 2d 80 00       	push   $0x802d8c
  800f4d:	e8 1d f3 ff ff       	call   80026f <cprintf>
	*dev = 0;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f5b:	83 c4 10             	add    $0x10,%esp
  800f5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    
			*dev = devtab[i];
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6f:	eb f2                	jmp    800f63 <dev_lookup+0x4d>

00800f71 <fd_close>:
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
  800f77:	83 ec 24             	sub    $0x24,%esp
  800f7a:	8b 75 08             	mov    0x8(%ebp),%esi
  800f7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f83:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f84:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f8a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f8d:	50                   	push   %eax
  800f8e:	e8 33 ff ff ff       	call   800ec6 <fd_lookup>
  800f93:	89 c3                	mov    %eax,%ebx
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	78 05                	js     800fa1 <fd_close+0x30>
	    || fd != fd2)
  800f9c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f9f:	74 16                	je     800fb7 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fa1:	89 f8                	mov    %edi,%eax
  800fa3:	84 c0                	test   %al,%al
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	0f 44 d8             	cmove  %eax,%ebx
}
  800fad:	89 d8                	mov    %ebx,%eax
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fbd:	50                   	push   %eax
  800fbe:	ff 36                	pushl  (%esi)
  800fc0:	e8 51 ff ff ff       	call   800f16 <dev_lookup>
  800fc5:	89 c3                	mov    %eax,%ebx
  800fc7:	83 c4 10             	add    $0x10,%esp
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	78 1a                	js     800fe8 <fd_close+0x77>
		if (dev->dev_close)
  800fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	74 0b                	je     800fe8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800fdd:	83 ec 0c             	sub    $0xc,%esp
  800fe0:	56                   	push   %esi
  800fe1:	ff d0                	call   *%eax
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	56                   	push   %esi
  800fec:	6a 00                	push   $0x0
  800fee:	e8 cf fc ff ff       	call   800cc2 <sys_page_unmap>
	return r;
  800ff3:	83 c4 10             	add    $0x10,%esp
  800ff6:	eb b5                	jmp    800fad <fd_close+0x3c>

00800ff8 <close>:

int
close(int fdnum)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801001:	50                   	push   %eax
  801002:	ff 75 08             	pushl  0x8(%ebp)
  801005:	e8 bc fe ff ff       	call   800ec6 <fd_lookup>
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	85 c0                	test   %eax,%eax
  80100f:	79 02                	jns    801013 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801011:	c9                   	leave  
  801012:	c3                   	ret    
		return fd_close(fd, 1);
  801013:	83 ec 08             	sub    $0x8,%esp
  801016:	6a 01                	push   $0x1
  801018:	ff 75 f4             	pushl  -0xc(%ebp)
  80101b:	e8 51 ff ff ff       	call   800f71 <fd_close>
  801020:	83 c4 10             	add    $0x10,%esp
  801023:	eb ec                	jmp    801011 <close+0x19>

00801025 <close_all>:

void
close_all(void)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	53                   	push   %ebx
  801029:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80102c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	53                   	push   %ebx
  801035:	e8 be ff ff ff       	call   800ff8 <close>
	for (i = 0; i < MAXFD; i++)
  80103a:	83 c3 01             	add    $0x1,%ebx
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	83 fb 20             	cmp    $0x20,%ebx
  801043:	75 ec                	jne    801031 <close_all+0xc>
}
  801045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801056:	50                   	push   %eax
  801057:	ff 75 08             	pushl  0x8(%ebp)
  80105a:	e8 67 fe ff ff       	call   800ec6 <fd_lookup>
  80105f:	89 c3                	mov    %eax,%ebx
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	85 c0                	test   %eax,%eax
  801066:	0f 88 81 00 00 00    	js     8010ed <dup+0xa3>
		return r;
	close(newfdnum);
  80106c:	83 ec 0c             	sub    $0xc,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	e8 81 ff ff ff       	call   800ff8 <close>

	newfd = INDEX2FD(newfdnum);
  801077:	8b 75 0c             	mov    0xc(%ebp),%esi
  80107a:	c1 e6 0c             	shl    $0xc,%esi
  80107d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801083:	83 c4 04             	add    $0x4,%esp
  801086:	ff 75 e4             	pushl  -0x1c(%ebp)
  801089:	e8 cf fd ff ff       	call   800e5d <fd2data>
  80108e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801090:	89 34 24             	mov    %esi,(%esp)
  801093:	e8 c5 fd ff ff       	call   800e5d <fd2data>
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80109d:	89 d8                	mov    %ebx,%eax
  80109f:	c1 e8 16             	shr    $0x16,%eax
  8010a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a9:	a8 01                	test   $0x1,%al
  8010ab:	74 11                	je     8010be <dup+0x74>
  8010ad:	89 d8                	mov    %ebx,%eax
  8010af:	c1 e8 0c             	shr    $0xc,%eax
  8010b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b9:	f6 c2 01             	test   $0x1,%dl
  8010bc:	75 39                	jne    8010f7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010c1:	89 d0                	mov    %edx,%eax
  8010c3:	c1 e8 0c             	shr    $0xc,%eax
  8010c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d5:	50                   	push   %eax
  8010d6:	56                   	push   %esi
  8010d7:	6a 00                	push   $0x0
  8010d9:	52                   	push   %edx
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 9f fb ff ff       	call   800c80 <sys_page_map>
  8010e1:	89 c3                	mov    %eax,%ebx
  8010e3:	83 c4 20             	add    $0x20,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	78 31                	js     80111b <dup+0xd1>
		goto err;

	return newfdnum;
  8010ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ed:	89 d8                	mov    %ebx,%eax
  8010ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	25 07 0e 00 00       	and    $0xe07,%eax
  801106:	50                   	push   %eax
  801107:	57                   	push   %edi
  801108:	6a 00                	push   $0x0
  80110a:	53                   	push   %ebx
  80110b:	6a 00                	push   $0x0
  80110d:	e8 6e fb ff ff       	call   800c80 <sys_page_map>
  801112:	89 c3                	mov    %eax,%ebx
  801114:	83 c4 20             	add    $0x20,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	79 a3                	jns    8010be <dup+0x74>
	sys_page_unmap(0, newfd);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	56                   	push   %esi
  80111f:	6a 00                	push   $0x0
  801121:	e8 9c fb ff ff       	call   800cc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801126:	83 c4 08             	add    $0x8,%esp
  801129:	57                   	push   %edi
  80112a:	6a 00                	push   $0x0
  80112c:	e8 91 fb ff ff       	call   800cc2 <sys_page_unmap>
	return r;
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	eb b7                	jmp    8010ed <dup+0xa3>

00801136 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	53                   	push   %ebx
  80113a:	83 ec 1c             	sub    $0x1c,%esp
  80113d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801140:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801143:	50                   	push   %eax
  801144:	53                   	push   %ebx
  801145:	e8 7c fd ff ff       	call   800ec6 <fd_lookup>
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	78 3f                	js     801190 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801157:	50                   	push   %eax
  801158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115b:	ff 30                	pushl  (%eax)
  80115d:	e8 b4 fd ff ff       	call   800f16 <dev_lookup>
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	78 27                	js     801190 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801169:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116c:	8b 42 08             	mov    0x8(%edx),%eax
  80116f:	83 e0 03             	and    $0x3,%eax
  801172:	83 f8 01             	cmp    $0x1,%eax
  801175:	74 1e                	je     801195 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117a:	8b 40 08             	mov    0x8(%eax),%eax
  80117d:	85 c0                	test   %eax,%eax
  80117f:	74 35                	je     8011b6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	ff 75 10             	pushl  0x10(%ebp)
  801187:	ff 75 0c             	pushl  0xc(%ebp)
  80118a:	52                   	push   %edx
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
}
  801190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801193:	c9                   	leave  
  801194:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801195:	a1 08 40 80 00       	mov    0x804008,%eax
  80119a:	8b 40 48             	mov    0x48(%eax),%eax
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	53                   	push   %ebx
  8011a1:	50                   	push   %eax
  8011a2:	68 cd 2d 80 00       	push   $0x802dcd
  8011a7:	e8 c3 f0 ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b4:	eb da                	jmp    801190 <read+0x5a>
		return -E_NOT_SUPP;
  8011b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011bb:	eb d3                	jmp    801190 <read+0x5a>

008011bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 0c             	sub    $0xc,%esp
  8011c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d1:	39 f3                	cmp    %esi,%ebx
  8011d3:	73 23                	jae    8011f8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	89 f0                	mov    %esi,%eax
  8011da:	29 d8                	sub    %ebx,%eax
  8011dc:	50                   	push   %eax
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	03 45 0c             	add    0xc(%ebp),%eax
  8011e2:	50                   	push   %eax
  8011e3:	57                   	push   %edi
  8011e4:	e8 4d ff ff ff       	call   801136 <read>
		if (m < 0)
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 06                	js     8011f6 <readn+0x39>
			return m;
		if (m == 0)
  8011f0:	74 06                	je     8011f8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8011f2:	01 c3                	add    %eax,%ebx
  8011f4:	eb db                	jmp    8011d1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011f8:	89 d8                	mov    %ebx,%eax
  8011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fd:	5b                   	pop    %ebx
  8011fe:	5e                   	pop    %esi
  8011ff:	5f                   	pop    %edi
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	53                   	push   %ebx
  801206:	83 ec 1c             	sub    $0x1c,%esp
  801209:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80120f:	50                   	push   %eax
  801210:	53                   	push   %ebx
  801211:	e8 b0 fc ff ff       	call   800ec6 <fd_lookup>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 3a                	js     801257 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801223:	50                   	push   %eax
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801227:	ff 30                	pushl  (%eax)
  801229:	e8 e8 fc ff ff       	call   800f16 <dev_lookup>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 22                	js     801257 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801238:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80123c:	74 1e                	je     80125c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80123e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801241:	8b 52 0c             	mov    0xc(%edx),%edx
  801244:	85 d2                	test   %edx,%edx
  801246:	74 35                	je     80127d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801248:	83 ec 04             	sub    $0x4,%esp
  80124b:	ff 75 10             	pushl  0x10(%ebp)
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	50                   	push   %eax
  801252:	ff d2                	call   *%edx
  801254:	83 c4 10             	add    $0x10,%esp
}
  801257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80125c:	a1 08 40 80 00       	mov    0x804008,%eax
  801261:	8b 40 48             	mov    0x48(%eax),%eax
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	53                   	push   %ebx
  801268:	50                   	push   %eax
  801269:	68 e9 2d 80 00       	push   $0x802de9
  80126e:	e8 fc ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127b:	eb da                	jmp    801257 <write+0x55>
		return -E_NOT_SUPP;
  80127d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801282:	eb d3                	jmp    801257 <write+0x55>

00801284 <seek>:

int
seek(int fdnum, off_t offset)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80128a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128d:	50                   	push   %eax
  80128e:	ff 75 08             	pushl  0x8(%ebp)
  801291:	e8 30 fc ff ff       	call   800ec6 <fd_lookup>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 0e                	js     8012ab <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80129d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	53                   	push   %ebx
  8012b1:	83 ec 1c             	sub    $0x1c,%esp
  8012b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ba:	50                   	push   %eax
  8012bb:	53                   	push   %ebx
  8012bc:	e8 05 fc ff ff       	call   800ec6 <fd_lookup>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 37                	js     8012ff <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c8:	83 ec 08             	sub    $0x8,%esp
  8012cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ce:	50                   	push   %eax
  8012cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d2:	ff 30                	pushl  (%eax)
  8012d4:	e8 3d fc ff ff       	call   800f16 <dev_lookup>
  8012d9:	83 c4 10             	add    $0x10,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 1f                	js     8012ff <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012e7:	74 1b                	je     801304 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ec:	8b 52 18             	mov    0x18(%edx),%edx
  8012ef:	85 d2                	test   %edx,%edx
  8012f1:	74 32                	je     801325 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	ff 75 0c             	pushl  0xc(%ebp)
  8012f9:	50                   	push   %eax
  8012fa:	ff d2                	call   *%edx
  8012fc:	83 c4 10             	add    $0x10,%esp
}
  8012ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801302:	c9                   	leave  
  801303:	c3                   	ret    
			thisenv->env_id, fdnum);
  801304:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801309:	8b 40 48             	mov    0x48(%eax),%eax
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	53                   	push   %ebx
  801310:	50                   	push   %eax
  801311:	68 ac 2d 80 00       	push   $0x802dac
  801316:	e8 54 ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801323:	eb da                	jmp    8012ff <ftruncate+0x52>
		return -E_NOT_SUPP;
  801325:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132a:	eb d3                	jmp    8012ff <ftruncate+0x52>

0080132c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	53                   	push   %ebx
  801330:	83 ec 1c             	sub    $0x1c,%esp
  801333:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801336:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 84 fb ff ff       	call   800ec6 <fd_lookup>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 4b                	js     801394 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134f:	50                   	push   %eax
  801350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801353:	ff 30                	pushl  (%eax)
  801355:	e8 bc fb ff ff       	call   800f16 <dev_lookup>
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 33                	js     801394 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801368:	74 2f                	je     801399 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80136a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80136d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801374:	00 00 00 
	stat->st_isdir = 0;
  801377:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80137e:	00 00 00 
	stat->st_dev = dev;
  801381:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	53                   	push   %ebx
  80138b:	ff 75 f0             	pushl  -0x10(%ebp)
  80138e:	ff 50 14             	call   *0x14(%eax)
  801391:	83 c4 10             	add    $0x10,%esp
}
  801394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801397:	c9                   	leave  
  801398:	c3                   	ret    
		return -E_NOT_SUPP;
  801399:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139e:	eb f4                	jmp    801394 <fstat+0x68>

008013a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	6a 00                	push   $0x0
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 2f 02 00 00       	call   8015e1 <open>
  8013b2:	89 c3                	mov    %eax,%ebx
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 1b                	js     8013d6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	50                   	push   %eax
  8013c2:	e8 65 ff ff ff       	call   80132c <fstat>
  8013c7:	89 c6                	mov    %eax,%esi
	close(fd);
  8013c9:	89 1c 24             	mov    %ebx,(%esp)
  8013cc:	e8 27 fc ff ff       	call   800ff8 <close>
	return r;
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	89 f3                	mov    %esi,%ebx
}
  8013d6:	89 d8                	mov    %ebx,%eax
  8013d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	89 c6                	mov    %eax,%esi
  8013e6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013e8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013ef:	74 27                	je     801418 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013f1:	6a 07                	push   $0x7
  8013f3:	68 00 50 80 00       	push   $0x805000
  8013f8:	56                   	push   %esi
  8013f9:	ff 35 00 40 80 00    	pushl  0x804000
  8013ff:	e8 1e 12 00 00       	call   802622 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801404:	83 c4 0c             	add    $0xc,%esp
  801407:	6a 00                	push   $0x0
  801409:	53                   	push   %ebx
  80140a:	6a 00                	push   $0x0
  80140c:	e8 9e 11 00 00       	call   8025af <ipc_recv>
}
  801411:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	6a 01                	push   $0x1
  80141d:	e8 6c 12 00 00       	call   80268e <ipc_find_env>
  801422:	a3 00 40 80 00       	mov    %eax,0x804000
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	eb c5                	jmp    8013f1 <fsipc+0x12>

0080142c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8b 40 0c             	mov    0xc(%eax),%eax
  801438:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801445:	ba 00 00 00 00       	mov    $0x0,%edx
  80144a:	b8 02 00 00 00       	mov    $0x2,%eax
  80144f:	e8 8b ff ff ff       	call   8013df <fsipc>
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <devfile_flush>:
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8b 40 0c             	mov    0xc(%eax),%eax
  801462:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801467:	ba 00 00 00 00       	mov    $0x0,%edx
  80146c:	b8 06 00 00 00       	mov    $0x6,%eax
  801471:	e8 69 ff ff ff       	call   8013df <fsipc>
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <devfile_stat>:
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	53                   	push   %ebx
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8b 40 0c             	mov    0xc(%eax),%eax
  801488:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80148d:	ba 00 00 00 00       	mov    $0x0,%edx
  801492:	b8 05 00 00 00       	mov    $0x5,%eax
  801497:	e8 43 ff ff ff       	call   8013df <fsipc>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 2c                	js     8014cc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	68 00 50 80 00       	push   $0x805000
  8014a8:	53                   	push   %ebx
  8014a9:	e8 9d f3 ff ff       	call   80084b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014ae:	a1 80 50 80 00       	mov    0x805080,%eax
  8014b3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b9:	a1 84 50 80 00       	mov    0x805084,%eax
  8014be:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <devfile_write>:
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8014db:	85 db                	test   %ebx,%ebx
  8014dd:	75 07                	jne    8014e6 <devfile_write+0x15>
	return n_all;
  8014df:	89 d8                	mov    %ebx,%eax
}
  8014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ec:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8014f1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	53                   	push   %ebx
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	68 08 50 80 00       	push   $0x805008
  801503:	e8 d1 f4 ff ff       	call   8009d9 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801508:	ba 00 00 00 00       	mov    $0x0,%edx
  80150d:	b8 04 00 00 00       	mov    $0x4,%eax
  801512:	e8 c8 fe ff ff       	call   8013df <fsipc>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 c3                	js     8014e1 <devfile_write+0x10>
	  assert(r <= n_left);
  80151e:	39 d8                	cmp    %ebx,%eax
  801520:	77 0b                	ja     80152d <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801522:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801527:	7f 1d                	jg     801546 <devfile_write+0x75>
    n_all += r;
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	eb b2                	jmp    8014df <devfile_write+0xe>
	  assert(r <= n_left);
  80152d:	68 1c 2e 80 00       	push   $0x802e1c
  801532:	68 28 2e 80 00       	push   $0x802e28
  801537:	68 9f 00 00 00       	push   $0x9f
  80153c:	68 3d 2e 80 00       	push   $0x802e3d
  801541:	e8 4e ec ff ff       	call   800194 <_panic>
	  assert(r <= PGSIZE);
  801546:	68 48 2e 80 00       	push   $0x802e48
  80154b:	68 28 2e 80 00       	push   $0x802e28
  801550:	68 a0 00 00 00       	push   $0xa0
  801555:	68 3d 2e 80 00       	push   $0x802e3d
  80155a:	e8 35 ec ff ff       	call   800194 <_panic>

0080155f <devfile_read>:
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8b 40 0c             	mov    0xc(%eax),%eax
  80156d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801572:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801578:	ba 00 00 00 00       	mov    $0x0,%edx
  80157d:	b8 03 00 00 00       	mov    $0x3,%eax
  801582:	e8 58 fe ff ff       	call   8013df <fsipc>
  801587:	89 c3                	mov    %eax,%ebx
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 1f                	js     8015ac <devfile_read+0x4d>
	assert(r <= n);
  80158d:	39 f0                	cmp    %esi,%eax
  80158f:	77 24                	ja     8015b5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801591:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801596:	7f 33                	jg     8015cb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	50                   	push   %eax
  80159c:	68 00 50 80 00       	push   $0x805000
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	e8 30 f4 ff ff       	call   8009d9 <memmove>
	return r;
  8015a9:	83 c4 10             	add    $0x10,%esp
}
  8015ac:	89 d8                	mov    %ebx,%eax
  8015ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5d                   	pop    %ebp
  8015b4:	c3                   	ret    
	assert(r <= n);
  8015b5:	68 54 2e 80 00       	push   $0x802e54
  8015ba:	68 28 2e 80 00       	push   $0x802e28
  8015bf:	6a 7c                	push   $0x7c
  8015c1:	68 3d 2e 80 00       	push   $0x802e3d
  8015c6:	e8 c9 eb ff ff       	call   800194 <_panic>
	assert(r <= PGSIZE);
  8015cb:	68 48 2e 80 00       	push   $0x802e48
  8015d0:	68 28 2e 80 00       	push   $0x802e28
  8015d5:	6a 7d                	push   $0x7d
  8015d7:	68 3d 2e 80 00       	push   $0x802e3d
  8015dc:	e8 b3 eb ff ff       	call   800194 <_panic>

008015e1 <open>:
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	56                   	push   %esi
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 1c             	sub    $0x1c,%esp
  8015e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ec:	56                   	push   %esi
  8015ed:	e8 20 f2 ff ff       	call   800812 <strlen>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015fa:	7f 6c                	jg     801668 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801602:	50                   	push   %eax
  801603:	e8 6c f8 ff ff       	call   800e74 <fd_alloc>
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 3c                	js     80164d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	56                   	push   %esi
  801615:	68 00 50 80 00       	push   $0x805000
  80161a:	e8 2c f2 ff ff       	call   80084b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80161f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801622:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162a:	b8 01 00 00 00       	mov    $0x1,%eax
  80162f:	e8 ab fd ff ff       	call   8013df <fsipc>
  801634:	89 c3                	mov    %eax,%ebx
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 19                	js     801656 <open+0x75>
	return fd2num(fd);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff 75 f4             	pushl  -0xc(%ebp)
  801643:	e8 05 f8 ff ff       	call   800e4d <fd2num>
  801648:	89 c3                	mov    %eax,%ebx
  80164a:	83 c4 10             	add    $0x10,%esp
}
  80164d:	89 d8                	mov    %ebx,%eax
  80164f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    
		fd_close(fd, 0);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	6a 00                	push   $0x0
  80165b:	ff 75 f4             	pushl  -0xc(%ebp)
  80165e:	e8 0e f9 ff ff       	call   800f71 <fd_close>
		return r;
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	eb e5                	jmp    80164d <open+0x6c>
		return -E_BAD_PATH;
  801668:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80166d:	eb de                	jmp    80164d <open+0x6c>

0080166f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	b8 08 00 00 00       	mov    $0x8,%eax
  80167f:	e8 5b fd ff ff       	call   8013df <fsipc>
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	57                   	push   %edi
  80168a:	56                   	push   %esi
  80168b:	53                   	push   %ebx
  80168c:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  801692:	e8 68 f5 ff ff       	call   800bff <sys_getenvid>
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	50                   	push   %eax
  80169b:	68 5b 2e 80 00       	push   $0x802e5b
  8016a0:	e8 ca eb ff ff       	call   80026f <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8016a5:	83 c4 08             	add    $0x8,%esp
  8016a8:	6a 00                	push   $0x0
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 2f ff ff ff       	call   8015e1 <open>
  8016b2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	0f 88 fb 04 00 00    	js     801bbe <spawn+0x538>
  8016c3:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	68 00 02 00 00       	push   $0x200
  8016cd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016d3:	50                   	push   %eax
  8016d4:	52                   	push   %edx
  8016d5:	e8 e3 fa ff ff       	call   8011bd <readn>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016e2:	75 71                	jne    801755 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  8016e4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016eb:	45 4c 46 
  8016ee:	75 65                	jne    801755 <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016f0:	b8 07 00 00 00       	mov    $0x7,%eax
  8016f5:	cd 30                	int    $0x30
  8016f7:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8016fd:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801703:	89 c6                	mov    %eax,%esi
  801705:	85 c0                	test   %eax,%eax
  801707:	0f 88 a5 04 00 00    	js     801bb2 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	50                   	push   %eax
  801711:	68 8f 2e 80 00       	push   $0x802e8f
  801716:	e8 54 eb ff ff       	call   80026f <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80171b:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801721:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801724:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80172a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801730:	b9 11 00 00 00       	mov    $0x11,%ecx
  801735:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801737:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80173d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801743:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801746:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80174b:	be 00 00 00 00       	mov    $0x0,%esi
  801750:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801753:	eb 4b                	jmp    8017a0 <spawn+0x11a>
		close(fd);
  801755:	83 ec 0c             	sub    $0xc,%esp
  801758:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80175e:	e8 95 f8 ff ff       	call   800ff8 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801763:	83 c4 0c             	add    $0xc,%esp
  801766:	68 7f 45 4c 46       	push   $0x464c457f
  80176b:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801771:	68 75 2e 80 00       	push   $0x802e75
  801776:	e8 f4 ea ff ff       	call   80026f <cprintf>
		return -E_NOT_EXEC;
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801785:	ff ff ff 
  801788:	e9 31 04 00 00       	jmp    801bbe <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  80178d:	83 ec 0c             	sub    $0xc,%esp
  801790:	50                   	push   %eax
  801791:	e8 7c f0 ff ff       	call   800812 <strlen>
  801796:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80179a:	83 c3 01             	add    $0x1,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8017a7:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	75 df                	jne    80178d <spawn+0x107>
  8017ae:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8017b4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8017ba:	bf 00 10 40 00       	mov    $0x401000,%edi
  8017bf:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8017c1:	89 fa                	mov    %edi,%edx
  8017c3:	83 e2 fc             	and    $0xfffffffc,%edx
  8017c6:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8017cd:	29 c2                	sub    %eax,%edx
  8017cf:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8017d5:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017d8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017dd:	0f 86 fe 03 00 00    	jbe    801be1 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	6a 07                	push   $0x7
  8017e8:	68 00 00 40 00       	push   $0x400000
  8017ed:	6a 00                	push   $0x0
  8017ef:	e8 49 f4 ff ff       	call   800c3d <sys_page_alloc>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	0f 88 e7 03 00 00    	js     801be6 <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8017ff:	be 00 00 00 00       	mov    $0x0,%esi
  801804:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80180a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80180d:	eb 30                	jmp    80183f <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  80180f:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801815:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80181b:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801824:	57                   	push   %edi
  801825:	e8 21 f0 ff ff       	call   80084b <strcpy>
		string_store += strlen(argv[i]) + 1;
  80182a:	83 c4 04             	add    $0x4,%esp
  80182d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801830:	e8 dd ef ff ff       	call   800812 <strlen>
  801835:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801839:	83 c6 01             	add    $0x1,%esi
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801845:	7f c8                	jg     80180f <spawn+0x189>
	}
	argv_store[argc] = 0;
  801847:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80184d:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801853:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80185a:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801860:	0f 85 86 00 00 00    	jne    8018ec <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801866:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80186c:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801872:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801875:	89 c8                	mov    %ecx,%eax
  801877:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  80187d:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801880:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801885:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	6a 07                	push   $0x7
  801890:	68 00 d0 bf ee       	push   $0xeebfd000
  801895:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80189b:	68 00 00 40 00       	push   $0x400000
  8018a0:	6a 00                	push   $0x0
  8018a2:	e8 d9 f3 ff ff       	call   800c80 <sys_page_map>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 20             	add    $0x20,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	0f 88 3a 03 00 00    	js     801bee <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8018b4:	83 ec 08             	sub    $0x8,%esp
  8018b7:	68 00 00 40 00       	push   $0x400000
  8018bc:	6a 00                	push   $0x0
  8018be:	e8 ff f3 ff ff       	call   800cc2 <sys_page_unmap>
  8018c3:	89 c3                	mov    %eax,%ebx
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	0f 88 1e 03 00 00    	js     801bee <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8018d0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018d6:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018dd:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8018e4:	00 00 00 
  8018e7:	e9 4f 01 00 00       	jmp    801a3b <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018ec:	68 18 2f 80 00       	push   $0x802f18
  8018f1:	68 28 2e 80 00       	push   $0x802e28
  8018f6:	68 f4 00 00 00       	push   $0xf4
  8018fb:	68 a8 2e 80 00       	push   $0x802ea8
  801900:	e8 8f e8 ff ff       	call   800194 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	6a 07                	push   $0x7
  80190a:	68 00 00 40 00       	push   $0x400000
  80190f:	6a 00                	push   $0x0
  801911:	e8 27 f3 ff ff       	call   800c3d <sys_page_alloc>
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	0f 88 ab 02 00 00    	js     801bcc <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80192a:	01 f0                	add    %esi,%eax
  80192c:	50                   	push   %eax
  80192d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801933:	e8 4c f9 ff ff       	call   801284 <seek>
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	0f 88 90 02 00 00    	js     801bd3 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80194c:	29 f0                	sub    %esi,%eax
  80194e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801953:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801958:	0f 47 c1             	cmova  %ecx,%eax
  80195b:	50                   	push   %eax
  80195c:	68 00 00 40 00       	push   $0x400000
  801961:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801967:	e8 51 f8 ff ff       	call   8011bd <readn>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	0f 88 63 02 00 00    	js     801bda <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801980:	53                   	push   %ebx
  801981:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801987:	68 00 00 40 00       	push   $0x400000
  80198c:	6a 00                	push   $0x0
  80198e:	e8 ed f2 ff ff       	call   800c80 <sys_page_map>
  801993:	83 c4 20             	add    $0x20,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	78 7c                	js     801a16 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	68 00 00 40 00       	push   $0x400000
  8019a2:	6a 00                	push   $0x0
  8019a4:	e8 19 f3 ff ff       	call   800cc2 <sys_page_unmap>
  8019a9:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8019ac:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8019b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019b8:	89 fe                	mov    %edi,%esi
  8019ba:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8019c0:	76 69                	jbe    801a2b <spawn+0x3a5>
		if (i >= filesz) {
  8019c2:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8019c8:	0f 87 37 ff ff ff    	ja     801905 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019d7:	53                   	push   %ebx
  8019d8:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8019de:	e8 5a f2 ff ff       	call   800c3d <sys_page_alloc>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	79 c2                	jns    8019ac <spawn+0x326>
  8019ea:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019f5:	e8 c4 f1 ff ff       	call   800bbe <sys_env_destroy>
	close(fd);
  8019fa:	83 c4 04             	add    $0x4,%esp
  8019fd:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a03:	e8 f0 f5 ff ff       	call   800ff8 <close>
	return r;
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801a11:	e9 a8 01 00 00       	jmp    801bbe <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  801a16:	50                   	push   %eax
  801a17:	68 b4 2e 80 00       	push   $0x802eb4
  801a1c:	68 27 01 00 00       	push   $0x127
  801a21:	68 a8 2e 80 00       	push   $0x802ea8
  801a26:	e8 69 e7 ff ff       	call   800194 <_panic>
  801a2b:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a31:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801a38:	83 c6 20             	add    $0x20,%esi
  801a3b:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a42:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801a48:	7e 6d                	jle    801ab7 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801a4a:	83 3e 01             	cmpl   $0x1,(%esi)
  801a4d:	75 e2                	jne    801a31 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a4f:	8b 46 18             	mov    0x18(%esi),%eax
  801a52:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a55:	83 f8 01             	cmp    $0x1,%eax
  801a58:	19 c0                	sbb    %eax,%eax
  801a5a:	83 e0 fe             	and    $0xfffffffe,%eax
  801a5d:	83 c0 07             	add    $0x7,%eax
  801a60:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a66:	8b 4e 04             	mov    0x4(%esi),%ecx
  801a69:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a6f:	8b 56 10             	mov    0x10(%esi),%edx
  801a72:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801a78:	8b 7e 14             	mov    0x14(%esi),%edi
  801a7b:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801a81:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a8b:	74 1a                	je     801aa7 <spawn+0x421>
		va -= i;
  801a8d:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801a8f:	01 c7                	add    %eax,%edi
  801a91:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801a97:	01 c2                	add    %eax,%edx
  801a99:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801a9f:	29 c1                	sub    %eax,%ecx
  801aa1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  801aac:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801ab2:	e9 01 ff ff ff       	jmp    8019b8 <spawn+0x332>
	close(fd);
  801ab7:	83 ec 0c             	sub    $0xc,%esp
  801aba:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ac0:	e8 33 f5 ff ff       	call   800ff8 <close>
  801ac5:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801ac8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801acd:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ad3:	eb 0d                	jmp    801ae2 <spawn+0x45c>
  801ad5:	83 c3 01             	add    $0x1,%ebx
  801ad8:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801ade:	77 5d                	ja     801b3d <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  801ae0:	74 f3                	je     801ad5 <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  801ae2:	89 da                	mov    %ebx,%edx
  801ae4:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  801ae7:	89 d0                	mov    %edx,%eax
  801ae9:	c1 e8 16             	shr    $0x16,%eax
  801aec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801af3:	a8 01                	test   $0x1,%al
  801af5:	74 de                	je     801ad5 <spawn+0x44f>
		pte_t pte = uvpt[i];
  801af7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  801afe:	89 c1                	mov    %eax,%ecx
  801b00:	81 e1 01 04 00 00    	and    $0x401,%ecx
  801b06:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  801b0c:	75 c7                	jne    801ad5 <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	25 07 0e 00 00       	and    $0xe07,%eax
  801b16:	50                   	push   %eax
  801b17:	52                   	push   %edx
  801b18:	56                   	push   %esi
  801b19:	52                   	push   %edx
  801b1a:	6a 00                	push   $0x0
  801b1c:	e8 5f f1 ff ff       	call   800c80 <sys_page_map>
  801b21:	83 c4 20             	add    $0x20,%esp
  801b24:	85 c0                	test   %eax,%eax
  801b26:	79 ad                	jns    801ad5 <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  801b28:	50                   	push   %eax
  801b29:	68 d1 2e 80 00       	push   $0x802ed1
  801b2e:	68 42 01 00 00       	push   $0x142
  801b33:	68 a8 2e 80 00       	push   $0x802ea8
  801b38:	e8 57 e6 ff ff       	call   800194 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b3d:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b44:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b50:	50                   	push   %eax
  801b51:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b57:	e8 ea f1 ff ff       	call   800d46 <sys_env_set_trapframe>
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 25                	js     801b88 <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	6a 02                	push   $0x2
  801b68:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b6e:	e8 91 f1 ff ff       	call   800d04 <sys_env_set_status>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 23                	js     801b9d <spawn+0x517>
	return child;
  801b7a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b80:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b86:	eb 36                	jmp    801bbe <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  801b88:	50                   	push   %eax
  801b89:	68 e5 2e 80 00       	push   $0x802ee5
  801b8e:	68 88 00 00 00       	push   $0x88
  801b93:	68 a8 2e 80 00       	push   $0x802ea8
  801b98:	e8 f7 e5 ff ff       	call   800194 <_panic>
		panic("sys_env_set_status: %e", r);
  801b9d:	50                   	push   %eax
  801b9e:	68 ff 2e 80 00       	push   $0x802eff
  801ba3:	68 8b 00 00 00       	push   $0x8b
  801ba8:	68 a8 2e 80 00       	push   $0x802ea8
  801bad:	e8 e2 e5 ff ff       	call   800194 <_panic>
		return r;
  801bb2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bb8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801bbe:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
  801bcc:	89 c7                	mov    %eax,%edi
  801bce:	e9 19 fe ff ff       	jmp    8019ec <spawn+0x366>
  801bd3:	89 c7                	mov    %eax,%edi
  801bd5:	e9 12 fe ff ff       	jmp    8019ec <spawn+0x366>
  801bda:	89 c7                	mov    %eax,%edi
  801bdc:	e9 0b fe ff ff       	jmp    8019ec <spawn+0x366>
		return -E_NO_MEM;
  801be1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801be6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801bec:	eb d0                	jmp    801bbe <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  801bee:	83 ec 08             	sub    $0x8,%esp
  801bf1:	68 00 00 40 00       	push   $0x400000
  801bf6:	6a 00                	push   $0x0
  801bf8:	e8 c5 f0 ff ff       	call   800cc2 <sys_page_unmap>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801c06:	eb b6                	jmp    801bbe <spawn+0x538>

00801c08 <spawnl>:
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	57                   	push   %edi
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c11:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c19:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c1c:	83 3a 00             	cmpl   $0x0,(%edx)
  801c1f:	74 07                	je     801c28 <spawnl+0x20>
		argc++;
  801c21:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801c24:	89 ca                	mov    %ecx,%edx
  801c26:	eb f1                	jmp    801c19 <spawnl+0x11>
	const char *argv[argc+2];
  801c28:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801c2f:	83 e2 f0             	and    $0xfffffff0,%edx
  801c32:	29 d4                	sub    %edx,%esp
  801c34:	8d 54 24 03          	lea    0x3(%esp),%edx
  801c38:	c1 ea 02             	shr    $0x2,%edx
  801c3b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c42:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c47:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c4e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c55:	00 
	va_start(vl, arg0);
  801c56:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c59:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	eb 0b                	jmp    801c6d <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801c62:	83 c0 01             	add    $0x1,%eax
  801c65:	8b 39                	mov    (%ecx),%edi
  801c67:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c6a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c6d:	39 d0                	cmp    %edx,%eax
  801c6f:	75 f1                	jne    801c62 <spawnl+0x5a>
	return spawn(prog, argv);
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	56                   	push   %esi
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	e8 09 fa ff ff       	call   801686 <spawn>
}
  801c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    

00801c85 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	56                   	push   %esi
  801c89:	53                   	push   %ebx
  801c8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 c5 f1 ff ff       	call   800e5d <fd2data>
  801c98:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	68 3e 2f 80 00       	push   $0x802f3e
  801ca2:	53                   	push   %ebx
  801ca3:	e8 a3 eb ff ff       	call   80084b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca8:	8b 46 04             	mov    0x4(%esi),%eax
  801cab:	2b 06                	sub    (%esi),%eax
  801cad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cba:	00 00 00 
	stat->st_dev = &devpipe;
  801cbd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cc4:	30 80 00 
	return 0;
}
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cdd:	53                   	push   %ebx
  801cde:	6a 00                	push   $0x0
  801ce0:	e8 dd ef ff ff       	call   800cc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce5:	89 1c 24             	mov    %ebx,(%esp)
  801ce8:	e8 70 f1 ff ff       	call   800e5d <fd2data>
  801ced:	83 c4 08             	add    $0x8,%esp
  801cf0:	50                   	push   %eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	e8 ca ef ff ff       	call   800cc2 <sys_page_unmap>
}
  801cf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <_pipeisclosed>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	57                   	push   %edi
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 1c             	sub    $0x1c,%esp
  801d06:	89 c7                	mov    %eax,%edi
  801d08:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d0a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d0f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	57                   	push   %edi
  801d16:	e8 ac 09 00 00       	call   8026c7 <pageref>
  801d1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d1e:	89 34 24             	mov    %esi,(%esp)
  801d21:	e8 a1 09 00 00       	call   8026c7 <pageref>
		nn = thisenv->env_runs;
  801d26:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d2c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	39 cb                	cmp    %ecx,%ebx
  801d34:	74 1b                	je     801d51 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d36:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d39:	75 cf                	jne    801d0a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d3b:	8b 42 58             	mov    0x58(%edx),%eax
  801d3e:	6a 01                	push   $0x1
  801d40:	50                   	push   %eax
  801d41:	53                   	push   %ebx
  801d42:	68 45 2f 80 00       	push   $0x802f45
  801d47:	e8 23 e5 ff ff       	call   80026f <cprintf>
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	eb b9                	jmp    801d0a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d51:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d54:	0f 94 c0             	sete   %al
  801d57:	0f b6 c0             	movzbl %al,%eax
}
  801d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5e                   	pop    %esi
  801d5f:	5f                   	pop    %edi
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    

00801d62 <devpipe_write>:
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 28             	sub    $0x28,%esp
  801d6b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d6e:	56                   	push   %esi
  801d6f:	e8 e9 f0 ff ff       	call   800e5d <fd2data>
  801d74:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d81:	74 4f                	je     801dd2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d83:	8b 43 04             	mov    0x4(%ebx),%eax
  801d86:	8b 0b                	mov    (%ebx),%ecx
  801d88:	8d 51 20             	lea    0x20(%ecx),%edx
  801d8b:	39 d0                	cmp    %edx,%eax
  801d8d:	72 14                	jb     801da3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d8f:	89 da                	mov    %ebx,%edx
  801d91:	89 f0                	mov    %esi,%eax
  801d93:	e8 65 ff ff ff       	call   801cfd <_pipeisclosed>
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	75 3b                	jne    801dd7 <devpipe_write+0x75>
			sys_yield();
  801d9c:	e8 7d ee ff ff       	call   800c1e <sys_yield>
  801da1:	eb e0                	jmp    801d83 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801daa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dad:	89 c2                	mov    %eax,%edx
  801daf:	c1 fa 1f             	sar    $0x1f,%edx
  801db2:	89 d1                	mov    %edx,%ecx
  801db4:	c1 e9 1b             	shr    $0x1b,%ecx
  801db7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dba:	83 e2 1f             	and    $0x1f,%edx
  801dbd:	29 ca                	sub    %ecx,%edx
  801dbf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dc3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dc7:	83 c0 01             	add    $0x1,%eax
  801dca:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dcd:	83 c7 01             	add    $0x1,%edi
  801dd0:	eb ac                	jmp    801d7e <devpipe_write+0x1c>
	return i;
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	eb 05                	jmp    801ddc <devpipe_write+0x7a>
				return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5f                   	pop    %edi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <devpipe_read>:
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	57                   	push   %edi
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	83 ec 18             	sub    $0x18,%esp
  801ded:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df0:	57                   	push   %edi
  801df1:	e8 67 f0 ff ff       	call   800e5d <fd2data>
  801df6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	be 00 00 00 00       	mov    $0x0,%esi
  801e00:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e03:	75 14                	jne    801e19 <devpipe_read+0x35>
	return i;
  801e05:	8b 45 10             	mov    0x10(%ebp),%eax
  801e08:	eb 02                	jmp    801e0c <devpipe_read+0x28>
				return i;
  801e0a:	89 f0                	mov    %esi,%eax
}
  801e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    
			sys_yield();
  801e14:	e8 05 ee ff ff       	call   800c1e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e19:	8b 03                	mov    (%ebx),%eax
  801e1b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e1e:	75 18                	jne    801e38 <devpipe_read+0x54>
			if (i > 0)
  801e20:	85 f6                	test   %esi,%esi
  801e22:	75 e6                	jne    801e0a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e24:	89 da                	mov    %ebx,%edx
  801e26:	89 f8                	mov    %edi,%eax
  801e28:	e8 d0 fe ff ff       	call   801cfd <_pipeisclosed>
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 e3                	je     801e14 <devpipe_read+0x30>
				return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	eb d4                	jmp    801e0c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e38:	99                   	cltd   
  801e39:	c1 ea 1b             	shr    $0x1b,%edx
  801e3c:	01 d0                	add    %edx,%eax
  801e3e:	83 e0 1f             	and    $0x1f,%eax
  801e41:	29 d0                	sub    %edx,%eax
  801e43:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e4e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e51:	83 c6 01             	add    $0x1,%esi
  801e54:	eb aa                	jmp    801e00 <devpipe_read+0x1c>

00801e56 <pipe>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e61:	50                   	push   %eax
  801e62:	e8 0d f0 ff ff       	call   800e74 <fd_alloc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 88 23 01 00 00    	js     801f97 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 07 04 00 00       	push   $0x407
  801e7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7f:	6a 00                	push   $0x0
  801e81:	e8 b7 ed ff ff       	call   800c3d <sys_page_alloc>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 88 04 01 00 00    	js     801f97 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e99:	50                   	push   %eax
  801e9a:	e8 d5 ef ff ff       	call   800e74 <fd_alloc>
  801e9f:	89 c3                	mov    %eax,%ebx
  801ea1:	83 c4 10             	add    $0x10,%esp
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	0f 88 db 00 00 00    	js     801f87 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 07 04 00 00       	push   $0x407
  801eb4:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb7:	6a 00                	push   $0x0
  801eb9:	e8 7f ed ff ff       	call   800c3d <sys_page_alloc>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 88 bc 00 00 00    	js     801f87 <pipe+0x131>
	va = fd2data(fd0);
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed1:	e8 87 ef ff ff       	call   800e5d <fd2data>
  801ed6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed8:	83 c4 0c             	add    $0xc,%esp
  801edb:	68 07 04 00 00       	push   $0x407
  801ee0:	50                   	push   %eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	e8 55 ed ff ff       	call   800c3d <sys_page_alloc>
  801ee8:	89 c3                	mov    %eax,%ebx
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	85 c0                	test   %eax,%eax
  801eef:	0f 88 82 00 00 00    	js     801f77 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 f0             	pushl  -0x10(%ebp)
  801efb:	e8 5d ef ff ff       	call   800e5d <fd2data>
  801f00:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f07:	50                   	push   %eax
  801f08:	6a 00                	push   $0x0
  801f0a:	56                   	push   %esi
  801f0b:	6a 00                	push   $0x0
  801f0d:	e8 6e ed ff ff       	call   800c80 <sys_page_map>
  801f12:	89 c3                	mov    %eax,%ebx
  801f14:	83 c4 20             	add    $0x20,%esp
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 4e                	js     801f69 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f1b:	a1 20 30 80 00       	mov    0x803020,%eax
  801f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f23:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f32:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	ff 75 f4             	pushl  -0xc(%ebp)
  801f44:	e8 04 ef ff ff       	call   800e4d <fd2num>
  801f49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f4e:	83 c4 04             	add    $0x4,%esp
  801f51:	ff 75 f0             	pushl  -0x10(%ebp)
  801f54:	e8 f4 ee ff ff       	call   800e4d <fd2num>
  801f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f67:	eb 2e                	jmp    801f97 <pipe+0x141>
	sys_page_unmap(0, va);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	56                   	push   %esi
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 4e ed ff ff       	call   800cc2 <sys_page_unmap>
  801f74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f7d:	6a 00                	push   $0x0
  801f7f:	e8 3e ed ff ff       	call   800cc2 <sys_page_unmap>
  801f84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 2e ed ff ff       	call   800cc2 <sys_page_unmap>
  801f94:	83 c4 10             	add    $0x10,%esp
}
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <pipeisclosed>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa9:	50                   	push   %eax
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	e8 14 ef ff ff       	call   800ec6 <fd_lookup>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 18                	js     801fd1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	e8 99 ee ff ff       	call   800e5d <fd2data>
	return _pipeisclosed(fd, p);
  801fc4:	89 c2                	mov    %eax,%edx
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	e8 2f fd ff ff       	call   801cfd <_pipeisclosed>
  801fce:	83 c4 10             	add    $0x10,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fd9:	68 5d 2f 80 00       	push   $0x802f5d
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	e8 65 e8 ff ff       	call   80084b <strcpy>
	return 0;
}
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <devsock_close>:
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 10             	sub    $0x10,%esp
  801ff4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ff7:	53                   	push   %ebx
  801ff8:	e8 ca 06 00 00       	call   8026c7 <pageref>
  801ffd:	83 c4 10             	add    $0x10,%esp
		return 0;
  802000:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802005:	83 f8 01             	cmp    $0x1,%eax
  802008:	74 07                	je     802011 <devsock_close+0x24>
}
  80200a:	89 d0                	mov    %edx,%eax
  80200c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200f:	c9                   	leave  
  802010:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 73 0c             	pushl  0xc(%ebx)
  802017:	e8 b9 02 00 00       	call   8022d5 <nsipc_close>
  80201c:	89 c2                	mov    %eax,%edx
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	eb e7                	jmp    80200a <devsock_close+0x1d>

00802023 <devsock_write>:
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 10             	pushl  0x10(%ebp)
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	ff 70 0c             	pushl  0xc(%eax)
  802037:	e8 76 03 00 00       	call   8023b2 <nsipc_send>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <devsock_read>:
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802044:	6a 00                	push   $0x0
  802046:	ff 75 10             	pushl  0x10(%ebp)
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	ff 70 0c             	pushl  0xc(%eax)
  802052:	e8 ef 02 00 00       	call   802346 <nsipc_recv>
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <fd2sockid>:
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80205f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802062:	52                   	push   %edx
  802063:	50                   	push   %eax
  802064:	e8 5d ee ff ff       	call   800ec6 <fd_lookup>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	85 c0                	test   %eax,%eax
  80206e:	78 10                	js     802080 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802079:	39 08                	cmp    %ecx,(%eax)
  80207b:	75 05                	jne    802082 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80207d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    
		return -E_NOT_SUPP;
  802082:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802087:	eb f7                	jmp    802080 <fd2sockid+0x27>

00802089 <alloc_sockfd>:
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	56                   	push   %esi
  80208d:	53                   	push   %ebx
  80208e:	83 ec 1c             	sub    $0x1c,%esp
  802091:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802093:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	e8 d8 ed ff ff       	call   800e74 <fd_alloc>
  80209c:	89 c3                	mov    %eax,%ebx
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 43                	js     8020e8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 07 04 00 00       	push   $0x407
  8020ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 86 eb ff ff       	call   800c3d <sys_page_alloc>
  8020b7:	89 c3                	mov    %eax,%ebx
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 28                	js     8020e8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020d5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020d8:	83 ec 0c             	sub    $0xc,%esp
  8020db:	50                   	push   %eax
  8020dc:	e8 6c ed ff ff       	call   800e4d <fd2num>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	eb 0c                	jmp    8020f4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020e8:	83 ec 0c             	sub    $0xc,%esp
  8020eb:	56                   	push   %esi
  8020ec:	e8 e4 01 00 00       	call   8022d5 <nsipc_close>
		return r;
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	89 d8                	mov    %ebx,%eax
  8020f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f9:	5b                   	pop    %ebx
  8020fa:	5e                   	pop    %esi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    

008020fd <accept>:
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	e8 4e ff ff ff       	call   802059 <fd2sockid>
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 1b                	js     80212a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	50                   	push   %eax
  802119:	e8 0e 01 00 00       	call   80222c <nsipc_accept>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	85 c0                	test   %eax,%eax
  802123:	78 05                	js     80212a <accept+0x2d>
	return alloc_sockfd(r);
  802125:	e8 5f ff ff ff       	call   802089 <alloc_sockfd>
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <bind>:
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	e8 1f ff ff ff       	call   802059 <fd2sockid>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	78 12                	js     802150 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	ff 75 10             	pushl  0x10(%ebp)
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	50                   	push   %eax
  802148:	e8 31 01 00 00       	call   80227e <nsipc_bind>
  80214d:	83 c4 10             	add    $0x10,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <shutdown>:
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	e8 f9 fe ff ff       	call   802059 <fd2sockid>
  802160:	85 c0                	test   %eax,%eax
  802162:	78 0f                	js     802173 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802164:	83 ec 08             	sub    $0x8,%esp
  802167:	ff 75 0c             	pushl  0xc(%ebp)
  80216a:	50                   	push   %eax
  80216b:	e8 43 01 00 00       	call   8022b3 <nsipc_shutdown>
  802170:	83 c4 10             	add    $0x10,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <connect>:
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	e8 d6 fe ff ff       	call   802059 <fd2sockid>
  802183:	85 c0                	test   %eax,%eax
  802185:	78 12                	js     802199 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	ff 75 10             	pushl  0x10(%ebp)
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	50                   	push   %eax
  802191:	e8 59 01 00 00       	call   8022ef <nsipc_connect>
  802196:	83 c4 10             	add    $0x10,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <listen>:
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	e8 b0 fe ff ff       	call   802059 <fd2sockid>
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 0f                	js     8021bc <listen+0x21>
	return nsipc_listen(r, backlog);
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	ff 75 0c             	pushl  0xc(%ebp)
  8021b3:	50                   	push   %eax
  8021b4:	e8 6b 01 00 00       	call   802324 <nsipc_listen>
  8021b9:	83 c4 10             	add    $0x10,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <socket>:

int
socket(int domain, int type, int protocol)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021c4:	ff 75 10             	pushl  0x10(%ebp)
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	e8 3e 02 00 00       	call   802410 <nsipc_socket>
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 05                	js     8021de <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021d9:	e8 ab fe ff ff       	call   802089 <alloc_sockfd>
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021e9:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8021f0:	74 26                	je     802218 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021f2:	6a 07                	push   $0x7
  8021f4:	68 00 60 80 00       	push   $0x806000
  8021f9:	53                   	push   %ebx
  8021fa:	ff 35 04 40 80 00    	pushl  0x804004
  802200:	e8 1d 04 00 00       	call   802622 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802205:	83 c4 0c             	add    $0xc,%esp
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	e8 9c 03 00 00       	call   8025af <ipc_recv>
}
  802213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802216:	c9                   	leave  
  802217:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	6a 02                	push   $0x2
  80221d:	e8 6c 04 00 00       	call   80268e <ipc_find_env>
  802222:	a3 04 40 80 00       	mov    %eax,0x804004
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	eb c6                	jmp    8021f2 <nsipc+0x12>

0080222c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	56                   	push   %esi
  802230:	53                   	push   %ebx
  802231:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80223c:	8b 06                	mov    (%esi),%eax
  80223e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802243:	b8 01 00 00 00       	mov    $0x1,%eax
  802248:	e8 93 ff ff ff       	call   8021e0 <nsipc>
  80224d:	89 c3                	mov    %eax,%ebx
  80224f:	85 c0                	test   %eax,%eax
  802251:	79 09                	jns    80225c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802253:	89 d8                	mov    %ebx,%eax
  802255:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802258:	5b                   	pop    %ebx
  802259:	5e                   	pop    %esi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	ff 35 10 60 80 00    	pushl  0x806010
  802265:	68 00 60 80 00       	push   $0x806000
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	e8 67 e7 ff ff       	call   8009d9 <memmove>
		*addrlen = ret->ret_addrlen;
  802272:	a1 10 60 80 00       	mov    0x806010,%eax
  802277:	89 06                	mov    %eax,(%esi)
  802279:	83 c4 10             	add    $0x10,%esp
	return r;
  80227c:	eb d5                	jmp    802253 <nsipc_accept+0x27>

0080227e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	53                   	push   %ebx
  802282:	83 ec 08             	sub    $0x8,%esp
  802285:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802290:	53                   	push   %ebx
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	68 04 60 80 00       	push   $0x806004
  802299:	e8 3b e7 ff ff       	call   8009d9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80229e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8022a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8022a9:	e8 32 ff ff ff       	call   8021e0 <nsipc>
}
  8022ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8022c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8022ce:	e8 0d ff ff ff       	call   8021e0 <nsipc>
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <nsipc_close>:

int
nsipc_close(int s)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8022e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8022e8:	e8 f3 fe ff ff       	call   8021e0 <nsipc>
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	53                   	push   %ebx
  8022f3:	83 ec 08             	sub    $0x8,%esp
  8022f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802301:	53                   	push   %ebx
  802302:	ff 75 0c             	pushl  0xc(%ebp)
  802305:	68 04 60 80 00       	push   $0x806004
  80230a:	e8 ca e6 ff ff       	call   8009d9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80230f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802315:	b8 05 00 00 00       	mov    $0x5,%eax
  80231a:	e8 c1 fe ff ff       	call   8021e0 <nsipc>
}
  80231f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802332:	8b 45 0c             	mov    0xc(%ebp),%eax
  802335:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80233a:	b8 06 00 00 00       	mov    $0x6,%eax
  80233f:	e8 9c fe ff ff       	call   8021e0 <nsipc>
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	56                   	push   %esi
  80234a:	53                   	push   %ebx
  80234b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802356:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80235c:	8b 45 14             	mov    0x14(%ebp),%eax
  80235f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802364:	b8 07 00 00 00       	mov    $0x7,%eax
  802369:	e8 72 fe ff ff       	call   8021e0 <nsipc>
  80236e:	89 c3                	mov    %eax,%ebx
  802370:	85 c0                	test   %eax,%eax
  802372:	78 1f                	js     802393 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802374:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802379:	7f 21                	jg     80239c <nsipc_recv+0x56>
  80237b:	39 c6                	cmp    %eax,%esi
  80237d:	7c 1d                	jl     80239c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80237f:	83 ec 04             	sub    $0x4,%esp
  802382:	50                   	push   %eax
  802383:	68 00 60 80 00       	push   $0x806000
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	e8 49 e6 ff ff       	call   8009d9 <memmove>
  802390:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802393:	89 d8                	mov    %ebx,%eax
  802395:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802398:	5b                   	pop    %ebx
  802399:	5e                   	pop    %esi
  80239a:	5d                   	pop    %ebp
  80239b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80239c:	68 69 2f 80 00       	push   $0x802f69
  8023a1:	68 28 2e 80 00       	push   $0x802e28
  8023a6:	6a 62                	push   $0x62
  8023a8:	68 7e 2f 80 00       	push   $0x802f7e
  8023ad:	e8 e2 dd ff ff       	call   800194 <_panic>

008023b2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
  8023b5:	53                   	push   %ebx
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8023c4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023ca:	7f 2e                	jg     8023fa <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	53                   	push   %ebx
  8023d0:	ff 75 0c             	pushl  0xc(%ebp)
  8023d3:	68 0c 60 80 00       	push   $0x80600c
  8023d8:	e8 fc e5 ff ff       	call   8009d9 <memmove>
	nsipcbuf.send.req_size = size;
  8023dd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8023f0:	e8 eb fd ff ff       	call   8021e0 <nsipc>
}
  8023f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    
	assert(size < 1600);
  8023fa:	68 8a 2f 80 00       	push   $0x802f8a
  8023ff:	68 28 2e 80 00       	push   $0x802e28
  802404:	6a 6d                	push   $0x6d
  802406:	68 7e 2f 80 00       	push   $0x802f7e
  80240b:	e8 84 dd ff ff       	call   800194 <_panic>

00802410 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80241e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802421:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802426:	8b 45 10             	mov    0x10(%ebp),%eax
  802429:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80242e:	b8 09 00 00 00       	mov    $0x9,%eax
  802433:	e8 a8 fd ff ff       	call   8021e0 <nsipc>
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	c3                   	ret    

00802440 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802446:	68 96 2f 80 00       	push   $0x802f96
  80244b:	ff 75 0c             	pushl  0xc(%ebp)
  80244e:	e8 f8 e3 ff ff       	call   80084b <strcpy>
	return 0;
}
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <devcons_write>:
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	57                   	push   %edi
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802466:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80246b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802471:	3b 75 10             	cmp    0x10(%ebp),%esi
  802474:	73 31                	jae    8024a7 <devcons_write+0x4d>
		m = n - tot;
  802476:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802479:	29 f3                	sub    %esi,%ebx
  80247b:	83 fb 7f             	cmp    $0x7f,%ebx
  80247e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802483:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802486:	83 ec 04             	sub    $0x4,%esp
  802489:	53                   	push   %ebx
  80248a:	89 f0                	mov    %esi,%eax
  80248c:	03 45 0c             	add    0xc(%ebp),%eax
  80248f:	50                   	push   %eax
  802490:	57                   	push   %edi
  802491:	e8 43 e5 ff ff       	call   8009d9 <memmove>
		sys_cputs(buf, m);
  802496:	83 c4 08             	add    $0x8,%esp
  802499:	53                   	push   %ebx
  80249a:	57                   	push   %edi
  80249b:	e8 e1 e6 ff ff       	call   800b81 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024a0:	01 de                	add    %ebx,%esi
  8024a2:	83 c4 10             	add    $0x10,%esp
  8024a5:	eb ca                	jmp    802471 <devcons_write+0x17>
}
  8024a7:	89 f0                	mov    %esi,%eax
  8024a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    

008024b1 <devcons_read>:
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 08             	sub    $0x8,%esp
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024c0:	74 21                	je     8024e3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8024c2:	e8 d8 e6 ff ff       	call   800b9f <sys_cgetc>
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 07                	jne    8024d2 <devcons_read+0x21>
		sys_yield();
  8024cb:	e8 4e e7 ff ff       	call   800c1e <sys_yield>
  8024d0:	eb f0                	jmp    8024c2 <devcons_read+0x11>
	if (c < 0)
  8024d2:	78 0f                	js     8024e3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8024d4:	83 f8 04             	cmp    $0x4,%eax
  8024d7:	74 0c                	je     8024e5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8024d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dc:	88 02                	mov    %al,(%edx)
	return 1;
  8024de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    
		return 0;
  8024e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ea:	eb f7                	jmp    8024e3 <devcons_read+0x32>

008024ec <cputchar>:
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024f8:	6a 01                	push   $0x1
  8024fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024fd:	50                   	push   %eax
  8024fe:	e8 7e e6 ff ff       	call   800b81 <sys_cputs>
}
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <getchar>:
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80250e:	6a 01                	push   $0x1
  802510:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802513:	50                   	push   %eax
  802514:	6a 00                	push   $0x0
  802516:	e8 1b ec ff ff       	call   801136 <read>
	if (r < 0)
  80251b:	83 c4 10             	add    $0x10,%esp
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 06                	js     802528 <getchar+0x20>
	if (r < 1)
  802522:	74 06                	je     80252a <getchar+0x22>
	return c;
  802524:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    
		return -E_EOF;
  80252a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80252f:	eb f7                	jmp    802528 <getchar+0x20>

00802531 <iscons>:
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802537:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253a:	50                   	push   %eax
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	e8 83 e9 ff ff       	call   800ec6 <fd_lookup>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	85 c0                	test   %eax,%eax
  802548:	78 11                	js     80255b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802553:	39 10                	cmp    %edx,(%eax)
  802555:	0f 94 c0             	sete   %al
  802558:	0f b6 c0             	movzbl %al,%eax
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <opencons>:
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802566:	50                   	push   %eax
  802567:	e8 08 e9 ff ff       	call   800e74 <fd_alloc>
  80256c:	83 c4 10             	add    $0x10,%esp
  80256f:	85 c0                	test   %eax,%eax
  802571:	78 3a                	js     8025ad <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 07 04 00 00       	push   $0x407
  80257b:	ff 75 f4             	pushl  -0xc(%ebp)
  80257e:	6a 00                	push   $0x0
  802580:	e8 b8 e6 ff ff       	call   800c3d <sys_page_alloc>
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	85 c0                	test   %eax,%eax
  80258a:	78 21                	js     8025ad <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802595:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	50                   	push   %eax
  8025a5:	e8 a3 e8 ff ff       	call   800e4d <fd2num>
  8025aa:	83 c4 10             	add    $0x10,%esp
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	56                   	push   %esi
  8025b3:	53                   	push   %ebx
  8025b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8025b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 4f                	je     802610 <ipc_recv+0x61>
  8025c1:	83 ec 0c             	sub    $0xc,%esp
  8025c4:	50                   	push   %eax
  8025c5:	e8 23 e8 ff ff       	call   800ded <sys_ipc_recv>
  8025ca:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8025cd:	85 f6                	test   %esi,%esi
  8025cf:	74 14                	je     8025e5 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8025d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	75 09                	jne    8025e3 <ipc_recv+0x34>
  8025da:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025e0:	8b 52 74             	mov    0x74(%edx),%edx
  8025e3:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8025e5:	85 db                	test   %ebx,%ebx
  8025e7:	74 14                	je     8025fd <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8025e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	75 09                	jne    8025fb <ipc_recv+0x4c>
  8025f2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025f8:	8b 52 78             	mov    0x78(%edx),%edx
  8025fb:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	75 08                	jne    802609 <ipc_recv+0x5a>
  802601:	a1 08 40 80 00       	mov    0x804008,%eax
  802606:	8b 40 70             	mov    0x70(%eax),%eax
}
  802609:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80260c:	5b                   	pop    %ebx
  80260d:	5e                   	pop    %esi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	68 00 00 c0 ee       	push   $0xeec00000
  802618:	e8 d0 e7 ff ff       	call   800ded <sys_ipc_recv>
  80261d:	83 c4 10             	add    $0x10,%esp
  802620:	eb ab                	jmp    8025cd <ipc_recv+0x1e>

00802622 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	57                   	push   %edi
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80262e:	8b 75 10             	mov    0x10(%ebp),%esi
  802631:	eb 20                	jmp    802653 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802633:	6a 00                	push   $0x0
  802635:	68 00 00 c0 ee       	push   $0xeec00000
  80263a:	ff 75 0c             	pushl  0xc(%ebp)
  80263d:	57                   	push   %edi
  80263e:	e8 87 e7 ff ff       	call   800dca <sys_ipc_try_send>
  802643:	89 c3                	mov    %eax,%ebx
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	eb 1f                	jmp    802669 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80264a:	e8 cf e5 ff ff       	call   800c1e <sys_yield>
	while(retval != 0) {
  80264f:	85 db                	test   %ebx,%ebx
  802651:	74 33                	je     802686 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802653:	85 f6                	test   %esi,%esi
  802655:	74 dc                	je     802633 <ipc_send+0x11>
  802657:	ff 75 14             	pushl  0x14(%ebp)
  80265a:	56                   	push   %esi
  80265b:	ff 75 0c             	pushl  0xc(%ebp)
  80265e:	57                   	push   %edi
  80265f:	e8 66 e7 ff ff       	call   800dca <sys_ipc_try_send>
  802664:	89 c3                	mov    %eax,%ebx
  802666:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802669:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80266c:	74 dc                	je     80264a <ipc_send+0x28>
  80266e:	85 db                	test   %ebx,%ebx
  802670:	74 d8                	je     80264a <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802672:	83 ec 04             	sub    $0x4,%esp
  802675:	68 a4 2f 80 00       	push   $0x802fa4
  80267a:	6a 35                	push   $0x35
  80267c:	68 d4 2f 80 00       	push   $0x802fd4
  802681:	e8 0e db ff ff       	call   800194 <_panic>
	}
}
  802686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802689:	5b                   	pop    %ebx
  80268a:	5e                   	pop    %esi
  80268b:	5f                   	pop    %edi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    

0080268e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802699:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80269c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026a2:	8b 52 50             	mov    0x50(%edx),%edx
  8026a5:	39 ca                	cmp    %ecx,%edx
  8026a7:	74 11                	je     8026ba <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8026a9:	83 c0 01             	add    $0x1,%eax
  8026ac:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026b1:	75 e6                	jne    802699 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	eb 0b                	jmp    8026c5 <ipc_find_env+0x37>
			return envs[i].env_id;
  8026ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026c2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026c5:	5d                   	pop    %ebp
  8026c6:	c3                   	ret    

008026c7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026cd:	89 d0                	mov    %edx,%eax
  8026cf:	c1 e8 16             	shr    $0x16,%eax
  8026d2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026d9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026de:	f6 c1 01             	test   $0x1,%cl
  8026e1:	74 1d                	je     802700 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026e3:	c1 ea 0c             	shr    $0xc,%edx
  8026e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026ed:	f6 c2 01             	test   $0x1,%dl
  8026f0:	74 0e                	je     802700 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026f2:	c1 ea 0c             	shr    $0xc,%edx
  8026f5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026fc:	ef 
  8026fd:	0f b7 c0             	movzwl %ax,%eax
}
  802700:	5d                   	pop    %ebp
  802701:	c3                   	ret    
  802702:	66 90                	xchg   %ax,%ax
  802704:	66 90                	xchg   %ax,%ax
  802706:	66 90                	xchg   %ax,%ax
  802708:	66 90                	xchg   %ax,%ax
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__udivdi3>:
  802710:	f3 0f 1e fb          	endbr32 
  802714:	55                   	push   %ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 1c             	sub    $0x1c,%esp
  80271b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80271f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802723:	8b 74 24 34          	mov    0x34(%esp),%esi
  802727:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80272b:	85 d2                	test   %edx,%edx
  80272d:	75 49                	jne    802778 <__udivdi3+0x68>
  80272f:	39 f3                	cmp    %esi,%ebx
  802731:	76 15                	jbe    802748 <__udivdi3+0x38>
  802733:	31 ff                	xor    %edi,%edi
  802735:	89 e8                	mov    %ebp,%eax
  802737:	89 f2                	mov    %esi,%edx
  802739:	f7 f3                	div    %ebx
  80273b:	89 fa                	mov    %edi,%edx
  80273d:	83 c4 1c             	add    $0x1c,%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5f                   	pop    %edi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
  802745:	8d 76 00             	lea    0x0(%esi),%esi
  802748:	89 d9                	mov    %ebx,%ecx
  80274a:	85 db                	test   %ebx,%ebx
  80274c:	75 0b                	jne    802759 <__udivdi3+0x49>
  80274e:	b8 01 00 00 00       	mov    $0x1,%eax
  802753:	31 d2                	xor    %edx,%edx
  802755:	f7 f3                	div    %ebx
  802757:	89 c1                	mov    %eax,%ecx
  802759:	31 d2                	xor    %edx,%edx
  80275b:	89 f0                	mov    %esi,%eax
  80275d:	f7 f1                	div    %ecx
  80275f:	89 c6                	mov    %eax,%esi
  802761:	89 e8                	mov    %ebp,%eax
  802763:	89 f7                	mov    %esi,%edi
  802765:	f7 f1                	div    %ecx
  802767:	89 fa                	mov    %edi,%edx
  802769:	83 c4 1c             	add    $0x1c,%esp
  80276c:	5b                   	pop    %ebx
  80276d:	5e                   	pop    %esi
  80276e:	5f                   	pop    %edi
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
  802771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	77 1c                	ja     802798 <__udivdi3+0x88>
  80277c:	0f bd fa             	bsr    %edx,%edi
  80277f:	83 f7 1f             	xor    $0x1f,%edi
  802782:	75 2c                	jne    8027b0 <__udivdi3+0xa0>
  802784:	39 f2                	cmp    %esi,%edx
  802786:	72 06                	jb     80278e <__udivdi3+0x7e>
  802788:	31 c0                	xor    %eax,%eax
  80278a:	39 eb                	cmp    %ebp,%ebx
  80278c:	77 ad                	ja     80273b <__udivdi3+0x2b>
  80278e:	b8 01 00 00 00       	mov    $0x1,%eax
  802793:	eb a6                	jmp    80273b <__udivdi3+0x2b>
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	31 ff                	xor    %edi,%edi
  80279a:	31 c0                	xor    %eax,%eax
  80279c:	89 fa                	mov    %edi,%edx
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	89 f9                	mov    %edi,%ecx
  8027b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027b7:	29 f8                	sub    %edi,%eax
  8027b9:	d3 e2                	shl    %cl,%edx
  8027bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027bf:	89 c1                	mov    %eax,%ecx
  8027c1:	89 da                	mov    %ebx,%edx
  8027c3:	d3 ea                	shr    %cl,%edx
  8027c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027c9:	09 d1                	or     %edx,%ecx
  8027cb:	89 f2                	mov    %esi,%edx
  8027cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027d1:	89 f9                	mov    %edi,%ecx
  8027d3:	d3 e3                	shl    %cl,%ebx
  8027d5:	89 c1                	mov    %eax,%ecx
  8027d7:	d3 ea                	shr    %cl,%edx
  8027d9:	89 f9                	mov    %edi,%ecx
  8027db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027df:	89 eb                	mov    %ebp,%ebx
  8027e1:	d3 e6                	shl    %cl,%esi
  8027e3:	89 c1                	mov    %eax,%ecx
  8027e5:	d3 eb                	shr    %cl,%ebx
  8027e7:	09 de                	or     %ebx,%esi
  8027e9:	89 f0                	mov    %esi,%eax
  8027eb:	f7 74 24 08          	divl   0x8(%esp)
  8027ef:	89 d6                	mov    %edx,%esi
  8027f1:	89 c3                	mov    %eax,%ebx
  8027f3:	f7 64 24 0c          	mull   0xc(%esp)
  8027f7:	39 d6                	cmp    %edx,%esi
  8027f9:	72 15                	jb     802810 <__udivdi3+0x100>
  8027fb:	89 f9                	mov    %edi,%ecx
  8027fd:	d3 e5                	shl    %cl,%ebp
  8027ff:	39 c5                	cmp    %eax,%ebp
  802801:	73 04                	jae    802807 <__udivdi3+0xf7>
  802803:	39 d6                	cmp    %edx,%esi
  802805:	74 09                	je     802810 <__udivdi3+0x100>
  802807:	89 d8                	mov    %ebx,%eax
  802809:	31 ff                	xor    %edi,%edi
  80280b:	e9 2b ff ff ff       	jmp    80273b <__udivdi3+0x2b>
  802810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802813:	31 ff                	xor    %edi,%edi
  802815:	e9 21 ff ff ff       	jmp    80273b <__udivdi3+0x2b>
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <__umoddi3>:
  802820:	f3 0f 1e fb          	endbr32 
  802824:	55                   	push   %ebp
  802825:	57                   	push   %edi
  802826:	56                   	push   %esi
  802827:	53                   	push   %ebx
  802828:	83 ec 1c             	sub    $0x1c,%esp
  80282b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80282f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802833:	8b 74 24 30          	mov    0x30(%esp),%esi
  802837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80283b:	89 da                	mov    %ebx,%edx
  80283d:	85 c0                	test   %eax,%eax
  80283f:	75 3f                	jne    802880 <__umoddi3+0x60>
  802841:	39 df                	cmp    %ebx,%edi
  802843:	76 13                	jbe    802858 <__umoddi3+0x38>
  802845:	89 f0                	mov    %esi,%eax
  802847:	f7 f7                	div    %edi
  802849:	89 d0                	mov    %edx,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	83 c4 1c             	add    $0x1c,%esp
  802850:	5b                   	pop    %ebx
  802851:	5e                   	pop    %esi
  802852:	5f                   	pop    %edi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    
  802855:	8d 76 00             	lea    0x0(%esi),%esi
  802858:	89 fd                	mov    %edi,%ebp
  80285a:	85 ff                	test   %edi,%edi
  80285c:	75 0b                	jne    802869 <__umoddi3+0x49>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	31 d2                	xor    %edx,%edx
  802865:	f7 f7                	div    %edi
  802867:	89 c5                	mov    %eax,%ebp
  802869:	89 d8                	mov    %ebx,%eax
  80286b:	31 d2                	xor    %edx,%edx
  80286d:	f7 f5                	div    %ebp
  80286f:	89 f0                	mov    %esi,%eax
  802871:	f7 f5                	div    %ebp
  802873:	89 d0                	mov    %edx,%eax
  802875:	eb d4                	jmp    80284b <__umoddi3+0x2b>
  802877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80287e:	66 90                	xchg   %ax,%ax
  802880:	89 f1                	mov    %esi,%ecx
  802882:	39 d8                	cmp    %ebx,%eax
  802884:	76 0a                	jbe    802890 <__umoddi3+0x70>
  802886:	89 f0                	mov    %esi,%eax
  802888:	83 c4 1c             	add    $0x1c,%esp
  80288b:	5b                   	pop    %ebx
  80288c:	5e                   	pop    %esi
  80288d:	5f                   	pop    %edi
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    
  802890:	0f bd e8             	bsr    %eax,%ebp
  802893:	83 f5 1f             	xor    $0x1f,%ebp
  802896:	75 20                	jne    8028b8 <__umoddi3+0x98>
  802898:	39 d8                	cmp    %ebx,%eax
  80289a:	0f 82 b0 00 00 00    	jb     802950 <__umoddi3+0x130>
  8028a0:	39 f7                	cmp    %esi,%edi
  8028a2:	0f 86 a8 00 00 00    	jbe    802950 <__umoddi3+0x130>
  8028a8:	89 c8                	mov    %ecx,%eax
  8028aa:	83 c4 1c             	add    $0x1c,%esp
  8028ad:	5b                   	pop    %ebx
  8028ae:	5e                   	pop    %esi
  8028af:	5f                   	pop    %edi
  8028b0:	5d                   	pop    %ebp
  8028b1:	c3                   	ret    
  8028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028b8:	89 e9                	mov    %ebp,%ecx
  8028ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8028bf:	29 ea                	sub    %ebp,%edx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c7:	89 d1                	mov    %edx,%ecx
  8028c9:	89 f8                	mov    %edi,%eax
  8028cb:	d3 e8                	shr    %cl,%eax
  8028cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028d9:	09 c1                	or     %eax,%ecx
  8028db:	89 d8                	mov    %ebx,%eax
  8028dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028e1:	89 e9                	mov    %ebp,%ecx
  8028e3:	d3 e7                	shl    %cl,%edi
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	d3 e8                	shr    %cl,%eax
  8028e9:	89 e9                	mov    %ebp,%ecx
  8028eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ef:	d3 e3                	shl    %cl,%ebx
  8028f1:	89 c7                	mov    %eax,%edi
  8028f3:	89 d1                	mov    %edx,%ecx
  8028f5:	89 f0                	mov    %esi,%eax
  8028f7:	d3 e8                	shr    %cl,%eax
  8028f9:	89 e9                	mov    %ebp,%ecx
  8028fb:	89 fa                	mov    %edi,%edx
  8028fd:	d3 e6                	shl    %cl,%esi
  8028ff:	09 d8                	or     %ebx,%eax
  802901:	f7 74 24 08          	divl   0x8(%esp)
  802905:	89 d1                	mov    %edx,%ecx
  802907:	89 f3                	mov    %esi,%ebx
  802909:	f7 64 24 0c          	mull   0xc(%esp)
  80290d:	89 c6                	mov    %eax,%esi
  80290f:	89 d7                	mov    %edx,%edi
  802911:	39 d1                	cmp    %edx,%ecx
  802913:	72 06                	jb     80291b <__umoddi3+0xfb>
  802915:	75 10                	jne    802927 <__umoddi3+0x107>
  802917:	39 c3                	cmp    %eax,%ebx
  802919:	73 0c                	jae    802927 <__umoddi3+0x107>
  80291b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80291f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802923:	89 d7                	mov    %edx,%edi
  802925:	89 c6                	mov    %eax,%esi
  802927:	89 ca                	mov    %ecx,%edx
  802929:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80292e:	29 f3                	sub    %esi,%ebx
  802930:	19 fa                	sbb    %edi,%edx
  802932:	89 d0                	mov    %edx,%eax
  802934:	d3 e0                	shl    %cl,%eax
  802936:	89 e9                	mov    %ebp,%ecx
  802938:	d3 eb                	shr    %cl,%ebx
  80293a:	d3 ea                	shr    %cl,%edx
  80293c:	09 d8                	or     %ebx,%eax
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	89 da                	mov    %ebx,%edx
  802952:	29 fe                	sub    %edi,%esi
  802954:	19 c2                	sbb    %eax,%edx
  802956:	89 f1                	mov    %esi,%ecx
  802958:	89 c8                	mov    %ecx,%eax
  80295a:	e9 4b ff ff ff       	jmp    8028aa <__umoddi3+0x8a>
