
obj/user/testpteshare.debug：     文件格式 elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 62 08 00 00       	call   8008ab <strcpy>
	exit();
  800049:	e8 8c 01 00 00       	call   8001da <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 25 0c 00 00       	call   800c9d <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 9c 0f 00 00       	call   801024 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 37 23 00 00       	call   8023d8 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 a2 08 00 00       	call   800956 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 60 2e 80 00       	mov    $0x802e60,%eax
  8000be:	ba 66 2e 80 00       	mov    $0x802e66,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 9c 2e 80 00       	push   $0x802e9c
  8000cc:	e8 fe 01 00 00       	call   8002cf <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 b7 2e 80 00       	push   $0x802eb7
  8000d8:	68 bc 2e 80 00       	push   $0x802ebc
  8000dd:	68 bb 2e 80 00       	push   $0x802ebb
  8000e2:	e8 26 1f 00 00       	call   80200d <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 dd 22 00 00       	call   8023d8 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 48 08 00 00       	call   800956 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 60 2e 80 00       	mov    $0x802e60,%eax
  800118:	ba 66 2e 80 00       	mov    $0x802e66,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 d3 2e 80 00       	push   $0x802ed3
  800126:	e8 a4 01 00 00       	call   8002cf <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 6c 2e 80 00       	push   $0x802e6c
  800144:	6a 13                	push   $0x13
  800146:	68 7f 2e 80 00       	push   $0x802e7f
  80014b:	e8 a4 00 00 00       	call   8001f4 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 93 2e 80 00       	push   $0x802e93
  800156:	6a 17                	push   $0x17
  800158:	68 7f 2e 80 00       	push   $0x802e7f
  80015d:	e8 92 00 00 00       	call   8001f4 <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 36 07 00 00       	call   8008ab <strcpy>
		exit();
  800175:	e8 60 00 00 00       	call   8001da <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 c9 2e 80 00       	push   $0x802ec9
  800188:	6a 21                	push   $0x21
  80018a:	68 7f 2e 80 00       	push   $0x802e7f
  80018f:	e8 60 00 00 00       	call   8001f4 <_panic>

00800194 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80019f:	e8 bb 0a 00 00       	call   800c5f <sys_getenvid>
  8001a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b1:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b6:	85 db                	test   %ebx,%ebx
  8001b8:	7e 07                	jle    8001c1 <libmain+0x2d>
		binaryname = argv[0];
  8001ba:	8b 06                	mov    (%esi),%eax
  8001bc:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	e8 88 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cb:	e8 0a 00 00 00       	call   8001da <exit>
}
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5e                   	pop    %esi
  8001d8:	5d                   	pop    %ebp
  8001d9:	c3                   	ret    

008001da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001e0:	e8 45 12 00 00       	call   80142a <close_all>
	sys_env_destroy(0);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 2f 0a 00 00       	call   800c1e <sys_env_destroy>
}
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	56                   	push   %esi
  8001f8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fc:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800202:	e8 58 0a 00 00       	call   800c5f <sys_getenvid>
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	ff 75 0c             	pushl  0xc(%ebp)
  80020d:	ff 75 08             	pushl  0x8(%ebp)
  800210:	56                   	push   %esi
  800211:	50                   	push   %eax
  800212:	68 18 2f 80 00       	push   $0x802f18
  800217:	e8 b3 00 00 00       	call   8002cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021c:	83 c4 18             	add    $0x18,%esp
  80021f:	53                   	push   %ebx
  800220:	ff 75 10             	pushl  0x10(%ebp)
  800223:	e8 56 00 00 00       	call   80027e <vcprintf>
	cprintf("\n");
  800228:	c7 04 24 6e 35 80 00 	movl   $0x80356e,(%esp)
  80022f:	e8 9b 00 00 00       	call   8002cf <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800237:	cc                   	int3   
  800238:	eb fd                	jmp    800237 <_panic+0x43>

0080023a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	53                   	push   %ebx
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800244:	8b 13                	mov    (%ebx),%edx
  800246:	8d 42 01             	lea    0x1(%edx),%eax
  800249:	89 03                	mov    %eax,(%ebx)
  80024b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800252:	3d ff 00 00 00       	cmp    $0xff,%eax
  800257:	74 09                	je     800262 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800259:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800260:	c9                   	leave  
  800261:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	68 ff 00 00 00       	push   $0xff
  80026a:	8d 43 08             	lea    0x8(%ebx),%eax
  80026d:	50                   	push   %eax
  80026e:	e8 6e 09 00 00       	call   800be1 <sys_cputs>
		b->idx = 0;
  800273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb db                	jmp    800259 <putch+0x1f>

0080027e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028e:	00 00 00 
	b.cnt = 0;
  800291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800298:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a7:	50                   	push   %eax
  8002a8:	68 3a 02 80 00       	push   $0x80023a
  8002ad:	e8 19 01 00 00       	call   8003cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b2:	83 c4 08             	add    $0x8,%esp
  8002b5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c1:	50                   	push   %eax
  8002c2:	e8 1a 09 00 00       	call   800be1 <sys_cputs>

	return b.cnt;
}
  8002c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d8:	50                   	push   %eax
  8002d9:	ff 75 08             	pushl  0x8(%ebp)
  8002dc:	e8 9d ff ff ff       	call   80027e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 1c             	sub    $0x1c,%esp
  8002ec:	89 c7                	mov    %eax,%edi
  8002ee:	89 d6                	mov    %edx,%esi
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800304:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800307:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80030a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80030d:	89 d0                	mov    %edx,%eax
  80030f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800312:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800315:	73 15                	jae    80032c <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800317:	83 eb 01             	sub    $0x1,%ebx
  80031a:	85 db                	test   %ebx,%ebx
  80031c:	7e 43                	jle    800361 <printnum+0x7e>
			putch(padc, putdat);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	56                   	push   %esi
  800322:	ff 75 18             	pushl  0x18(%ebp)
  800325:	ff d7                	call   *%edi
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	eb eb                	jmp    800317 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 18             	pushl  0x18(%ebp)
  800332:	8b 45 14             	mov    0x14(%ebp),%eax
  800335:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800338:	53                   	push   %ebx
  800339:	ff 75 10             	pushl  0x10(%ebp)
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800342:	ff 75 e0             	pushl  -0x20(%ebp)
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	ff 75 d8             	pushl  -0x28(%ebp)
  80034b:	e8 b0 28 00 00       	call   802c00 <__udivdi3>
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	52                   	push   %edx
  800354:	50                   	push   %eax
  800355:	89 f2                	mov    %esi,%edx
  800357:	89 f8                	mov    %edi,%eax
  800359:	e8 85 ff ff ff       	call   8002e3 <printnum>
  80035e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	56                   	push   %esi
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	ff 75 e0             	pushl  -0x20(%ebp)
  80036e:	ff 75 dc             	pushl  -0x24(%ebp)
  800371:	ff 75 d8             	pushl  -0x28(%ebp)
  800374:	e8 97 29 00 00       	call   802d10 <__umoddi3>
  800379:	83 c4 14             	add    $0x14,%esp
  80037c:	0f be 80 3b 2f 80 00 	movsbl 0x802f3b(%eax),%eax
  800383:	50                   	push   %eax
  800384:	ff d7                	call   *%edi
}
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800397:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039b:	8b 10                	mov    (%eax),%edx
  80039d:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a0:	73 0a                	jae    8003ac <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a5:	89 08                	mov    %ecx,(%eax)
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	88 02                	mov    %al,(%edx)
}
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <printfmt>:
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 10             	pushl  0x10(%ebp)
  8003bb:	ff 75 0c             	pushl  0xc(%ebp)
  8003be:	ff 75 08             	pushl  0x8(%ebp)
  8003c1:	e8 05 00 00 00       	call   8003cb <vprintfmt>
}
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	c9                   	leave  
  8003ca:	c3                   	ret    

008003cb <vprintfmt>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	57                   	push   %edi
  8003cf:	56                   	push   %esi
  8003d0:	53                   	push   %ebx
  8003d1:	83 ec 3c             	sub    $0x3c,%esp
  8003d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003dd:	eb 0a                	jmp    8003e9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	53                   	push   %ebx
  8003e3:	50                   	push   %eax
  8003e4:	ff d6                	call   *%esi
  8003e6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e9:	83 c7 01             	add    $0x1,%edi
  8003ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003f0:	83 f8 25             	cmp    $0x25,%eax
  8003f3:	74 0c                	je     800401 <vprintfmt+0x36>
			if (ch == '\0')
  8003f5:	85 c0                	test   %eax,%eax
  8003f7:	75 e6                	jne    8003df <vprintfmt+0x14>
}
  8003f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fc:	5b                   	pop    %ebx
  8003fd:	5e                   	pop    %esi
  8003fe:	5f                   	pop    %edi
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    
		padc = ' ';
  800401:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800405:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80040c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800413:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80041a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8d 47 01             	lea    0x1(%edi),%eax
  800422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800425:	0f b6 17             	movzbl (%edi),%edx
  800428:	8d 42 dd             	lea    -0x23(%edx),%eax
  80042b:	3c 55                	cmp    $0x55,%al
  80042d:	0f 87 ba 03 00 00    	ja     8007ed <vprintfmt+0x422>
  800433:	0f b6 c0             	movzbl %al,%eax
  800436:	ff 24 85 80 30 80 00 	jmp    *0x803080(,%eax,4)
  80043d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800440:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800444:	eb d9                	jmp    80041f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800449:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80044d:	eb d0                	jmp    80041f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	0f b6 d2             	movzbl %dl,%edx
  800452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80045d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800460:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800464:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800467:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80046a:	83 f9 09             	cmp    $0x9,%ecx
  80046d:	77 55                	ja     8004c4 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80046f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800472:	eb e9                	jmp    80045d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 40 04             	lea    0x4(%eax),%eax
  800482:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048c:	79 91                	jns    80041f <vprintfmt+0x54>
				width = precision, precision = -1;
  80048e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049b:	eb 82                	jmp    80041f <vprintfmt+0x54>
  80049d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a7:	0f 49 d0             	cmovns %eax,%edx
  8004aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004b0:	e9 6a ff ff ff       	jmp    80041f <vprintfmt+0x54>
  8004b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004bf:	e9 5b ff ff ff       	jmp    80041f <vprintfmt+0x54>
  8004c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	eb bc                	jmp    800488 <vprintfmt+0xbd>
			lflag++;
  8004cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004d2:	e9 48 ff ff ff       	jmp    80041f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 78 04             	lea    0x4(%eax),%edi
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	ff 30                	pushl  (%eax)
  8004e3:	ff d6                	call   *%esi
			break;
  8004e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004eb:	e9 9c 02 00 00       	jmp    80078c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	8d 78 04             	lea    0x4(%eax),%edi
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	99                   	cltd   
  8004f9:	31 d0                	xor    %edx,%eax
  8004fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fd:	83 f8 0f             	cmp    $0xf,%eax
  800500:	7f 23                	jg     800525 <vprintfmt+0x15a>
  800502:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800509:	85 d2                	test   %edx,%edx
  80050b:	74 18                	je     800525 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80050d:	52                   	push   %edx
  80050e:	68 7e 34 80 00       	push   $0x80347e
  800513:	53                   	push   %ebx
  800514:	56                   	push   %esi
  800515:	e8 94 fe ff ff       	call   8003ae <printfmt>
  80051a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80051d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800520:	e9 67 02 00 00       	jmp    80078c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800525:	50                   	push   %eax
  800526:	68 53 2f 80 00       	push   $0x802f53
  80052b:	53                   	push   %ebx
  80052c:	56                   	push   %esi
  80052d:	e8 7c fe ff ff       	call   8003ae <printfmt>
  800532:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800535:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800538:	e9 4f 02 00 00       	jmp    80078c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	83 c0 04             	add    $0x4,%eax
  800543:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80054b:	85 d2                	test   %edx,%edx
  80054d:	b8 4c 2f 80 00       	mov    $0x802f4c,%eax
  800552:	0f 45 c2             	cmovne %edx,%eax
  800555:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800558:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80055c:	7e 06                	jle    800564 <vprintfmt+0x199>
  80055e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800562:	75 0d                	jne    800571 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800564:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800567:	89 c7                	mov    %eax,%edi
  800569:	03 45 e0             	add    -0x20(%ebp),%eax
  80056c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056f:	eb 3f                	jmp    8005b0 <vprintfmt+0x1e5>
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	ff 75 d8             	pushl  -0x28(%ebp)
  800577:	50                   	push   %eax
  800578:	e8 0d 03 00 00       	call   80088a <strnlen>
  80057d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800580:	29 c2                	sub    %eax,%edx
  800582:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80058a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80058e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800591:	85 ff                	test   %edi,%edi
  800593:	7e 58                	jle    8005ed <vprintfmt+0x222>
					putch(padc, putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	ff 75 e0             	pushl  -0x20(%ebp)
  80059c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80059e:	83 ef 01             	sub    $0x1,%edi
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	eb eb                	jmp    800591 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	53                   	push   %ebx
  8005aa:	52                   	push   %edx
  8005ab:	ff d6                	call   *%esi
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b5:	83 c7 01             	add    $0x1,%edi
  8005b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005bc:	0f be d0             	movsbl %al,%edx
  8005bf:	85 d2                	test   %edx,%edx
  8005c1:	74 45                	je     800608 <vprintfmt+0x23d>
  8005c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c7:	78 06                	js     8005cf <vprintfmt+0x204>
  8005c9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005cd:	78 35                	js     800604 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8005cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d3:	74 d1                	je     8005a6 <vprintfmt+0x1db>
  8005d5:	0f be c0             	movsbl %al,%eax
  8005d8:	83 e8 20             	sub    $0x20,%eax
  8005db:	83 f8 5e             	cmp    $0x5e,%eax
  8005de:	76 c6                	jbe    8005a6 <vprintfmt+0x1db>
					putch('?', putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	6a 3f                	push   $0x3f
  8005e6:	ff d6                	call   *%esi
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	eb c3                	jmp    8005b0 <vprintfmt+0x1e5>
  8005ed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005f0:	85 d2                	test   %edx,%edx
  8005f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f7:	0f 49 c2             	cmovns %edx,%eax
  8005fa:	29 c2                	sub    %eax,%edx
  8005fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005ff:	e9 60 ff ff ff       	jmp    800564 <vprintfmt+0x199>
  800604:	89 cf                	mov    %ecx,%edi
  800606:	eb 02                	jmp    80060a <vprintfmt+0x23f>
  800608:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80060a:	85 ff                	test   %edi,%edi
  80060c:	7e 10                	jle    80061e <vprintfmt+0x253>
				putch(' ', putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	6a 20                	push   $0x20
  800614:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800616:	83 ef 01             	sub    $0x1,%edi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	eb ec                	jmp    80060a <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80061e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800621:	89 45 14             	mov    %eax,0x14(%ebp)
  800624:	e9 63 01 00 00       	jmp    80078c <vprintfmt+0x3c1>
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <vprintfmt+0x27e>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	74 63                	je     800695 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063a:	99                   	cltd   
  80063b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb 17                	jmp    800660 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 08             	lea    0x8(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800660:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800663:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800666:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	0f 89 ff 00 00 00    	jns    800772 <vprintfmt+0x3a7>
				putch('-', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 2d                	push   $0x2d
  800679:	ff d6                	call   *%esi
				num = -(long long) num;
  80067b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800681:	f7 da                	neg    %edx
  800683:	83 d1 00             	adc    $0x0,%ecx
  800686:	f7 d9                	neg    %ecx
  800688:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800690:	e9 dd 00 00 00       	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	99                   	cltd   
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 04             	lea    0x4(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	eb b4                	jmp    800660 <vprintfmt+0x295>
	if (lflag >= 2)
  8006ac:	83 f9 01             	cmp    $0x1,%ecx
  8006af:	7f 1e                	jg     8006cf <vprintfmt+0x304>
	else if (lflag)
  8006b1:	85 c9                	test   %ecx,%ecx
  8006b3:	74 32                	je     8006e7 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 a3 00 00 00       	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d7:	8d 40 08             	lea    0x8(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e2:	e9 8b 00 00 00       	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 10                	mov    (%eax),%edx
  8006ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fc:	eb 74                	jmp    800772 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8006fe:	83 f9 01             	cmp    $0x1,%ecx
  800701:	7f 1b                	jg     80071e <vprintfmt+0x353>
	else if (lflag)
  800703:	85 c9                	test   %ecx,%ecx
  800705:	74 2c                	je     800733 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800717:	b8 08 00 00 00       	mov    $0x8,%eax
  80071c:	eb 54                	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	8b 48 04             	mov    0x4(%eax),%ecx
  800726:	8d 40 08             	lea    0x8(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072c:	b8 08 00 00 00       	mov    $0x8,%eax
  800731:	eb 3f                	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800743:	b8 08 00 00 00       	mov    $0x8,%eax
  800748:	eb 28                	jmp    800772 <vprintfmt+0x3a7>
			putch('0', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 30                	push   $0x30
  800750:	ff d6                	call   *%esi
			putch('x', putdat);
  800752:	83 c4 08             	add    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 78                	push   $0x78
  800758:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800764:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800772:	83 ec 0c             	sub    $0xc,%esp
  800775:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800779:	57                   	push   %edi
  80077a:	ff 75 e0             	pushl  -0x20(%ebp)
  80077d:	50                   	push   %eax
  80077e:	51                   	push   %ecx
  80077f:	52                   	push   %edx
  800780:	89 da                	mov    %ebx,%edx
  800782:	89 f0                	mov    %esi,%eax
  800784:	e8 5a fb ff ff       	call   8002e3 <printnum>
			break;
  800789:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80078c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078f:	e9 55 fc ff ff       	jmp    8003e9 <vprintfmt+0x1e>
	if (lflag >= 2)
  800794:	83 f9 01             	cmp    $0x1,%ecx
  800797:	7f 1b                	jg     8007b4 <vprintfmt+0x3e9>
	else if (lflag)
  800799:	85 c9                	test   %ecx,%ecx
  80079b:	74 2c                	je     8007c9 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b2:	eb be                	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 10                	mov    (%eax),%edx
  8007b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007bc:	8d 40 08             	lea    0x8(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c7:	eb a9                	jmp    800772 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d3:	8d 40 04             	lea    0x4(%eax),%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007de:	eb 92                	jmp    800772 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	6a 25                	push   $0x25
  8007e6:	ff d6                	call   *%esi
			break;
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb 9f                	jmp    80078c <vprintfmt+0x3c1>
			putch('%', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 25                	push   $0x25
  8007f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 f8                	mov    %edi,%eax
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x434>
  8007fc:	83 e8 01             	sub    $0x1,%eax
  8007ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x431>
  800805:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800808:	eb 82                	jmp    80078c <vprintfmt+0x3c1>

0080080a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800816:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800819:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800820:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800827:	85 c0                	test   %eax,%eax
  800829:	74 26                	je     800851 <vsnprintf+0x47>
  80082b:	85 d2                	test   %edx,%edx
  80082d:	7e 22                	jle    800851 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082f:	ff 75 14             	pushl  0x14(%ebp)
  800832:	ff 75 10             	pushl  0x10(%ebp)
  800835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	68 91 03 80 00       	push   $0x800391
  80083e:	e8 88 fb ff ff       	call   8003cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800846:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084c:	83 c4 10             	add    $0x10,%esp
}
  80084f:	c9                   	leave  
  800850:	c3                   	ret    
		return -E_INVAL;
  800851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800856:	eb f7                	jmp    80084f <vsnprintf+0x45>

00800858 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800861:	50                   	push   %eax
  800862:	ff 75 10             	pushl  0x10(%ebp)
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 9a ff ff ff       	call   80080a <vsnprintf>
	va_end(ap);

	return rc;
}
  800870:	c9                   	leave  
  800871:	c3                   	ret    

00800872 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800881:	74 05                	je     800888 <strlen+0x16>
		n++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	eb f5                	jmp    80087d <strlen+0xb>
	return n;
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	74 0d                	je     8008a9 <strnlen+0x1f>
  80089c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008a0:	74 05                	je     8008a7 <strnlen+0x1d>
		n++;
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	eb f1                	jmp    800898 <strnlen+0xe>
  8008a7:	89 d0                	mov    %edx,%eax
	return n;
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008be:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c1:	83 c2 01             	add    $0x1,%edx
  8008c4:	84 c9                	test   %cl,%cl
  8008c6:	75 f2                	jne    8008ba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	83 ec 10             	sub    $0x10,%esp
  8008d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d5:	53                   	push   %ebx
  8008d6:	e8 97 ff ff ff       	call   800872 <strlen>
  8008db:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	01 d8                	add    %ebx,%eax
  8008e3:	50                   	push   %eax
  8008e4:	e8 c2 ff ff ff       	call   8008ab <strcpy>
	return dst;
}
  8008e9:	89 d8                	mov    %ebx,%eax
  8008eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	56                   	push   %esi
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fb:	89 c6                	mov    %eax,%esi
  8008fd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800900:	89 c2                	mov    %eax,%edx
  800902:	39 f2                	cmp    %esi,%edx
  800904:	74 11                	je     800917 <strncpy+0x27>
		*dst++ = *src;
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	0f b6 19             	movzbl (%ecx),%ebx
  80090c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090f:	80 fb 01             	cmp    $0x1,%bl
  800912:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800915:	eb eb                	jmp    800902 <strncpy+0x12>
	}
	return ret;
}
  800917:	5b                   	pop    %ebx
  800918:	5e                   	pop    %esi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 75 08             	mov    0x8(%ebp),%esi
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	8b 55 10             	mov    0x10(%ebp),%edx
  800929:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092b:	85 d2                	test   %edx,%edx
  80092d:	74 21                	je     800950 <strlcpy+0x35>
  80092f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800933:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800935:	39 c2                	cmp    %eax,%edx
  800937:	74 14                	je     80094d <strlcpy+0x32>
  800939:	0f b6 19             	movzbl (%ecx),%ebx
  80093c:	84 db                	test   %bl,%bl
  80093e:	74 0b                	je     80094b <strlcpy+0x30>
			*dst++ = *src++;
  800940:	83 c1 01             	add    $0x1,%ecx
  800943:	83 c2 01             	add    $0x1,%edx
  800946:	88 5a ff             	mov    %bl,-0x1(%edx)
  800949:	eb ea                	jmp    800935 <strlcpy+0x1a>
  80094b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80094d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800950:	29 f0                	sub    %esi,%eax
}
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095f:	0f b6 01             	movzbl (%ecx),%eax
  800962:	84 c0                	test   %al,%al
  800964:	74 0c                	je     800972 <strcmp+0x1c>
  800966:	3a 02                	cmp    (%edx),%al
  800968:	75 08                	jne    800972 <strcmp+0x1c>
		p++, q++;
  80096a:	83 c1 01             	add    $0x1,%ecx
  80096d:	83 c2 01             	add    $0x1,%edx
  800970:	eb ed                	jmp    80095f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800972:	0f b6 c0             	movzbl %al,%eax
  800975:	0f b6 12             	movzbl (%edx),%edx
  800978:	29 d0                	sub    %edx,%eax
}
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 c3                	mov    %eax,%ebx
  800988:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098b:	eb 06                	jmp    800993 <strncmp+0x17>
		n--, p++, q++;
  80098d:	83 c0 01             	add    $0x1,%eax
  800990:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800993:	39 d8                	cmp    %ebx,%eax
  800995:	74 16                	je     8009ad <strncmp+0x31>
  800997:	0f b6 08             	movzbl (%eax),%ecx
  80099a:	84 c9                	test   %cl,%cl
  80099c:	74 04                	je     8009a2 <strncmp+0x26>
  80099e:	3a 0a                	cmp    (%edx),%cl
  8009a0:	74 eb                	je     80098d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a2:	0f b6 00             	movzbl (%eax),%eax
  8009a5:	0f b6 12             	movzbl (%edx),%edx
  8009a8:	29 d0                	sub    %edx,%eax
}
  8009aa:	5b                   	pop    %ebx
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    
		return 0;
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	eb f6                	jmp    8009aa <strncmp+0x2e>

008009b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	74 09                	je     8009ce <strchr+0x1a>
		if (*s == c)
  8009c5:	38 ca                	cmp    %cl,%dl
  8009c7:	74 0a                	je     8009d3 <strchr+0x1f>
	for (; *s; s++)
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	eb f0                	jmp    8009be <strchr+0xa>
			return (char *) s;
	return 0;
  8009ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009df:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e2:	38 ca                	cmp    %cl,%dl
  8009e4:	74 09                	je     8009ef <strfind+0x1a>
  8009e6:	84 d2                	test   %dl,%dl
  8009e8:	74 05                	je     8009ef <strfind+0x1a>
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	eb f0                	jmp    8009df <strfind+0xa>
			break;
	return (char *) s;
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	57                   	push   %edi
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009fd:	85 c9                	test   %ecx,%ecx
  8009ff:	74 31                	je     800a32 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a01:	89 f8                	mov    %edi,%eax
  800a03:	09 c8                	or     %ecx,%eax
  800a05:	a8 03                	test   $0x3,%al
  800a07:	75 23                	jne    800a2c <memset+0x3b>
		c &= 0xFF;
  800a09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a0d:	89 d3                	mov    %edx,%ebx
  800a0f:	c1 e3 08             	shl    $0x8,%ebx
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 18             	shl    $0x18,%eax
  800a17:	89 d6                	mov    %edx,%esi
  800a19:	c1 e6 10             	shl    $0x10,%esi
  800a1c:	09 f0                	or     %esi,%eax
  800a1e:	09 c2                	or     %eax,%edx
  800a20:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a25:	89 d0                	mov    %edx,%eax
  800a27:	fc                   	cld    
  800a28:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2a:	eb 06                	jmp    800a32 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	fc                   	cld    
  800a30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a32:	89 f8                	mov    %edi,%eax
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5f                   	pop    %edi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a47:	39 c6                	cmp    %eax,%esi
  800a49:	73 32                	jae    800a7d <memmove+0x44>
  800a4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a4e:	39 c2                	cmp    %eax,%edx
  800a50:	76 2b                	jbe    800a7d <memmove+0x44>
		s += n;
		d += n;
  800a52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 fe                	mov    %edi,%esi
  800a57:	09 ce                	or     %ecx,%esi
  800a59:	09 d6                	or     %edx,%esi
  800a5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a61:	75 0e                	jne    800a71 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a63:	83 ef 04             	sub    $0x4,%edi
  800a66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a6c:	fd                   	std    
  800a6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6f:	eb 09                	jmp    800a7a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a71:	83 ef 01             	sub    $0x1,%edi
  800a74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a77:	fd                   	std    
  800a78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7a:	fc                   	cld    
  800a7b:	eb 1a                	jmp    800a97 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	09 ca                	or     %ecx,%edx
  800a81:	09 f2                	or     %esi,%edx
  800a83:	f6 c2 03             	test   $0x3,%dl
  800a86:	75 0a                	jne    800a92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a8b:	89 c7                	mov    %eax,%edi
  800a8d:	fc                   	cld    
  800a8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a90:	eb 05                	jmp    800a97 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	fc                   	cld    
  800a95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a97:	5e                   	pop    %esi
  800a98:	5f                   	pop    %edi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa1:	ff 75 10             	pushl  0x10(%ebp)
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	e8 8a ff ff ff       	call   800a39 <memmove>
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 c6                	mov    %eax,%esi
  800abe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac1:	39 f0                	cmp    %esi,%eax
  800ac3:	74 1c                	je     800ae1 <memcmp+0x30>
		if (*s1 != *s2)
  800ac5:	0f b6 08             	movzbl (%eax),%ecx
  800ac8:	0f b6 1a             	movzbl (%edx),%ebx
  800acb:	38 d9                	cmp    %bl,%cl
  800acd:	75 08                	jne    800ad7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	eb ea                	jmp    800ac1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad7:	0f b6 c1             	movzbl %cl,%eax
  800ada:	0f b6 db             	movzbl %bl,%ebx
  800add:	29 d8                	sub    %ebx,%eax
  800adf:	eb 05                	jmp    800ae6 <memcmp+0x35>
	}

	return 0;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af8:	39 d0                	cmp    %edx,%eax
  800afa:	73 09                	jae    800b05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800afc:	38 08                	cmp    %cl,(%eax)
  800afe:	74 05                	je     800b05 <memfind+0x1b>
	for (; s < ends; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	eb f3                	jmp    800af8 <memfind+0xe>
			break;
	return (void *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b13:	eb 03                	jmp    800b18 <strtol+0x11>
		s++;
  800b15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b18:	0f b6 01             	movzbl (%ecx),%eax
  800b1b:	3c 20                	cmp    $0x20,%al
  800b1d:	74 f6                	je     800b15 <strtol+0xe>
  800b1f:	3c 09                	cmp    $0x9,%al
  800b21:	74 f2                	je     800b15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b23:	3c 2b                	cmp    $0x2b,%al
  800b25:	74 2a                	je     800b51 <strtol+0x4a>
	int neg = 0;
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b2c:	3c 2d                	cmp    $0x2d,%al
  800b2e:	74 2b                	je     800b5b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b36:	75 0f                	jne    800b47 <strtol+0x40>
  800b38:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3b:	74 28                	je     800b65 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b3d:	85 db                	test   %ebx,%ebx
  800b3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b44:	0f 44 d8             	cmove  %eax,%ebx
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4f:	eb 50                	jmp    800ba1 <strtol+0x9a>
		s++;
  800b51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b54:	bf 00 00 00 00       	mov    $0x0,%edi
  800b59:	eb d5                	jmp    800b30 <strtol+0x29>
		s++, neg = 1;
  800b5b:	83 c1 01             	add    $0x1,%ecx
  800b5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b63:	eb cb                	jmp    800b30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b69:	74 0e                	je     800b79 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b6b:	85 db                	test   %ebx,%ebx
  800b6d:	75 d8                	jne    800b47 <strtol+0x40>
		s++, base = 8;
  800b6f:	83 c1 01             	add    $0x1,%ecx
  800b72:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b77:	eb ce                	jmp    800b47 <strtol+0x40>
		s += 2, base = 16;
  800b79:	83 c1 02             	add    $0x2,%ecx
  800b7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b81:	eb c4                	jmp    800b47 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b83:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b86:	89 f3                	mov    %esi,%ebx
  800b88:	80 fb 19             	cmp    $0x19,%bl
  800b8b:	77 29                	ja     800bb6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b8d:	0f be d2             	movsbl %dl,%edx
  800b90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b93:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b96:	7d 30                	jge    800bc8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b98:	83 c1 01             	add    $0x1,%ecx
  800b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba1:	0f b6 11             	movzbl (%ecx),%edx
  800ba4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba7:	89 f3                	mov    %esi,%ebx
  800ba9:	80 fb 09             	cmp    $0x9,%bl
  800bac:	77 d5                	ja     800b83 <strtol+0x7c>
			dig = *s - '0';
  800bae:	0f be d2             	movsbl %dl,%edx
  800bb1:	83 ea 30             	sub    $0x30,%edx
  800bb4:	eb dd                	jmp    800b93 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bb6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb9:	89 f3                	mov    %esi,%ebx
  800bbb:	80 fb 19             	cmp    $0x19,%bl
  800bbe:	77 08                	ja     800bc8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc0:	0f be d2             	movsbl %dl,%edx
  800bc3:	83 ea 37             	sub    $0x37,%edx
  800bc6:	eb cb                	jmp    800b93 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcc:	74 05                	je     800bd3 <strtol+0xcc>
		*endptr = (char *) s;
  800bce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd3:	89 c2                	mov    %eax,%edx
  800bd5:	f7 da                	neg    %edx
  800bd7:	85 ff                	test   %edi,%edi
  800bd9:	0f 45 c2             	cmovne %edx,%eax
}
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf2:	89 c3                	mov    %eax,%ebx
  800bf4:	89 c7                	mov    %eax,%edi
  800bf6:	89 c6                	mov    %eax,%esi
  800bf8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_cgetc>:

int
sys_cgetc(void)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c05:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0f:	89 d1                	mov    %edx,%ecx
  800c11:	89 d3                	mov    %edx,%ebx
  800c13:	89 d7                	mov    %edx,%edi
  800c15:	89 d6                	mov    %edx,%esi
  800c17:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c34:	89 cb                	mov    %ecx,%ebx
  800c36:	89 cf                	mov    %ecx,%edi
  800c38:	89 ce                	mov    %ecx,%esi
  800c3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7f 08                	jg     800c48 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 03                	push   $0x3
  800c4e:	68 3f 32 80 00       	push   $0x80323f
  800c53:	6a 23                	push   $0x23
  800c55:	68 5c 32 80 00       	push   $0x80325c
  800c5a:	e8 95 f5 ff ff       	call   8001f4 <_panic>

00800c5f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c65:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6f:	89 d1                	mov    %edx,%ecx
  800c71:	89 d3                	mov    %edx,%ebx
  800c73:	89 d7                	mov    %edx,%edi
  800c75:	89 d6                	mov    %edx,%esi
  800c77:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_yield>:

void
sys_yield(void)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8e:	89 d1                	mov    %edx,%ecx
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	89 d7                	mov    %edx,%edi
  800c94:	89 d6                	mov    %edx,%esi
  800c96:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	be 00 00 00 00       	mov    $0x0,%esi
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	89 f7                	mov    %esi,%edi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 04                	push   $0x4
  800ccf:	68 3f 32 80 00       	push   $0x80323f
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 5c 32 80 00       	push   $0x80325c
  800cdb:	e8 14 f5 ff ff       	call   8001f4 <_panic>

00800ce0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfa:	8b 75 18             	mov    0x18(%ebp),%esi
  800cfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	7f 08                	jg     800d0b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0b:	83 ec 0c             	sub    $0xc,%esp
  800d0e:	50                   	push   %eax
  800d0f:	6a 05                	push   $0x5
  800d11:	68 3f 32 80 00       	push   $0x80323f
  800d16:	6a 23                	push   $0x23
  800d18:	68 5c 32 80 00       	push   $0x80325c
  800d1d:	e8 d2 f4 ff ff       	call   8001f4 <_panic>

00800d22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3b:	89 df                	mov    %ebx,%edi
  800d3d:	89 de                	mov    %ebx,%esi
  800d3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7f 08                	jg     800d4d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	83 ec 0c             	sub    $0xc,%esp
  800d50:	50                   	push   %eax
  800d51:	6a 06                	push   $0x6
  800d53:	68 3f 32 80 00       	push   $0x80323f
  800d58:	6a 23                	push   $0x23
  800d5a:	68 5c 32 80 00       	push   $0x80325c
  800d5f:	e8 90 f4 ff ff       	call   8001f4 <_panic>

00800d64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	b8 08 00 00 00       	mov    $0x8,%eax
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	89 de                	mov    %ebx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 08                	push   $0x8
  800d95:	68 3f 32 80 00       	push   $0x80323f
  800d9a:	6a 23                	push   $0x23
  800d9c:	68 5c 32 80 00       	push   $0x80325c
  800da1:	e8 4e f4 ff ff       	call   8001f4 <_panic>

00800da6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbf:	89 df                	mov    %ebx,%edi
  800dc1:	89 de                	mov    %ebx,%esi
  800dc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7f 08                	jg     800dd1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	50                   	push   %eax
  800dd5:	6a 09                	push   $0x9
  800dd7:	68 3f 32 80 00       	push   $0x80323f
  800ddc:	6a 23                	push   $0x23
  800dde:	68 5c 32 80 00       	push   $0x80325c
  800de3:	e8 0c f4 ff ff       	call   8001f4 <_panic>

00800de8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e01:	89 df                	mov    %ebx,%edi
  800e03:	89 de                	mov    %ebx,%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 0a                	push   $0xa
  800e19:	68 3f 32 80 00       	push   $0x80323f
  800e1e:	6a 23                	push   $0x23
  800e20:	68 5c 32 80 00       	push   $0x80325c
  800e25:	e8 ca f3 ff ff       	call   8001f4 <_panic>

00800e2a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3b:	be 00 00 00 00       	mov    $0x0,%esi
  800e40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e46:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e63:	89 cb                	mov    %ecx,%ebx
  800e65:	89 cf                	mov    %ecx,%edi
  800e67:	89 ce                	mov    %ecx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 0d                	push   $0xd
  800e7d:	68 3f 32 80 00       	push   $0x80323f
  800e82:	6a 23                	push   $0x23
  800e84:	68 5c 32 80 00       	push   $0x80325c
  800e89:	e8 66 f3 ff ff       	call   8001f4 <_panic>

00800e8e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e94:	ba 00 00 00 00       	mov    $0x0,%edx
  800e99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e9e:	89 d1                	mov    %edx,%ecx
  800ea0:	89 d3                	mov    %edx,%ebx
  800ea2:	89 d7                	mov    %edx,%edi
  800ea4:	89 d6                	mov    %edx,%esi
  800ea6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eb9:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ebb:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ebe:	89 d9                	mov    %ebx,%ecx
  800ec0:	c1 e9 16             	shr    $0x16,%ecx
  800ec3:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800eca:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ecf:	f6 c1 01             	test   $0x1,%cl
  800ed2:	74 0c                	je     800ee0 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800ed4:	89 d9                	mov    %ebx,%ecx
  800ed6:	c1 e9 0c             	shr    $0xc,%ecx
  800ed9:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800ee0:	f6 c2 02             	test   $0x2,%dl
  800ee3:	0f 84 a3 00 00 00    	je     800f8c <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800ee9:	89 da                	mov    %ebx,%edx
  800eeb:	c1 ea 0c             	shr    $0xc,%edx
  800eee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ef5:	f6 c6 08             	test   $0x8,%dh
  800ef8:	0f 84 b7 00 00 00    	je     800fb5 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800efe:	e8 5c fd ff ff       	call   800c5f <sys_getenvid>
  800f03:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	6a 07                	push   $0x7
  800f0a:	68 00 f0 7f 00       	push   $0x7ff000
  800f0f:	50                   	push   %eax
  800f10:	e8 88 fd ff ff       	call   800c9d <sys_page_alloc>
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	0f 88 bc 00 00 00    	js     800fdc <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800f20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800f26:	83 ec 04             	sub    $0x4,%esp
  800f29:	68 00 10 00 00       	push   $0x1000
  800f2e:	53                   	push   %ebx
  800f2f:	68 00 f0 7f 00       	push   $0x7ff000
  800f34:	e8 00 fb ff ff       	call   800a39 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f39:	83 c4 08             	add    $0x8,%esp
  800f3c:	53                   	push   %ebx
  800f3d:	56                   	push   %esi
  800f3e:	e8 df fd ff ff       	call   800d22 <sys_page_unmap>
  800f43:	83 c4 10             	add    $0x10,%esp
  800f46:	85 c0                	test   %eax,%eax
  800f48:	0f 88 a0 00 00 00    	js     800fee <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f4e:	83 ec 0c             	sub    $0xc,%esp
  800f51:	6a 07                	push   $0x7
  800f53:	53                   	push   %ebx
  800f54:	56                   	push   %esi
  800f55:	68 00 f0 7f 00       	push   $0x7ff000
  800f5a:	56                   	push   %esi
  800f5b:	e8 80 fd ff ff       	call   800ce0 <sys_page_map>
  800f60:	83 c4 20             	add    $0x20,%esp
  800f63:	85 c0                	test   %eax,%eax
  800f65:	0f 88 95 00 00 00    	js     801000 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f6b:	83 ec 08             	sub    $0x8,%esp
  800f6e:	68 00 f0 7f 00       	push   $0x7ff000
  800f73:	56                   	push   %esi
  800f74:	e8 a9 fd ff ff       	call   800d22 <sys_page_unmap>
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	0f 88 8e 00 00 00    	js     801012 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800f8c:	8b 70 28             	mov    0x28(%eax),%esi
  800f8f:	e8 cb fc ff ff       	call   800c5f <sys_getenvid>
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
  800f96:	50                   	push   %eax
  800f97:	68 6c 32 80 00       	push   $0x80326c
  800f9c:	e8 2e f3 ff ff       	call   8002cf <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800fa1:	83 c4 0c             	add    $0xc,%esp
  800fa4:	68 90 32 80 00       	push   $0x803290
  800fa9:	6a 27                	push   $0x27
  800fab:	68 64 33 80 00       	push   $0x803364
  800fb0:	e8 3f f2 ff ff       	call   8001f4 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800fb5:	8b 78 28             	mov    0x28(%eax),%edi
  800fb8:	e8 a2 fc ff ff       	call   800c5f <sys_getenvid>
  800fbd:	57                   	push   %edi
  800fbe:	53                   	push   %ebx
  800fbf:	50                   	push   %eax
  800fc0:	68 6c 32 80 00       	push   $0x80326c
  800fc5:	e8 05 f3 ff ff       	call   8002cf <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800fca:	56                   	push   %esi
  800fcb:	68 c4 32 80 00       	push   $0x8032c4
  800fd0:	6a 2b                	push   $0x2b
  800fd2:	68 64 33 80 00       	push   $0x803364
  800fd7:	e8 18 f2 ff ff       	call   8001f4 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800fdc:	50                   	push   %eax
  800fdd:	68 fc 32 80 00       	push   $0x8032fc
  800fe2:	6a 39                	push   $0x39
  800fe4:	68 64 33 80 00       	push   $0x803364
  800fe9:	e8 06 f2 ff ff       	call   8001f4 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800fee:	50                   	push   %eax
  800fef:	68 20 33 80 00       	push   $0x803320
  800ff4:	6a 3e                	push   $0x3e
  800ff6:	68 64 33 80 00       	push   $0x803364
  800ffb:	e8 f4 f1 ff ff       	call   8001f4 <_panic>
      panic("pgfault: page map failed (%e)", r);
  801000:	50                   	push   %eax
  801001:	68 6f 33 80 00       	push   $0x80336f
  801006:	6a 40                	push   $0x40
  801008:	68 64 33 80 00       	push   $0x803364
  80100d:	e8 e2 f1 ff ff       	call   8001f4 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801012:	50                   	push   %eax
  801013:	68 20 33 80 00       	push   $0x803320
  801018:	6a 42                	push   $0x42
  80101a:	68 64 33 80 00       	push   $0x803364
  80101f:	e8 d0 f1 ff ff       	call   8001f4 <_panic>

00801024 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	57                   	push   %edi
  801028:	56                   	push   %esi
  801029:	53                   	push   %ebx
  80102a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  80102d:	68 ad 0e 80 00       	push   $0x800ead
  801032:	e8 cc 19 00 00       	call   802a03 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801037:	b8 07 00 00 00       	mov    $0x7,%eax
  80103c:	cd 30                	int    $0x30
  80103e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	78 2d                	js     801075 <fork+0x51>
  801048:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80104a:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  80104f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801053:	0f 85 a6 00 00 00    	jne    8010ff <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  801059:	e8 01 fc ff ff       	call   800c5f <sys_getenvid>
  80105e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106b:	a3 08 50 80 00       	mov    %eax,0x805008
      return 0;
  801070:	e9 79 01 00 00       	jmp    8011ee <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  801075:	50                   	push   %eax
  801076:	68 93 2e 80 00       	push   $0x802e93
  80107b:	68 aa 00 00 00       	push   $0xaa
  801080:	68 64 33 80 00       	push   $0x803364
  801085:	e8 6a f1 ff ff       	call   8001f4 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	6a 05                	push   $0x5
  80108f:	53                   	push   %ebx
  801090:	57                   	push   %edi
  801091:	53                   	push   %ebx
  801092:	6a 00                	push   $0x0
  801094:	e8 47 fc ff ff       	call   800ce0 <sys_page_map>
  801099:	83 c4 20             	add    $0x20,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	79 4d                	jns    8010ed <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010a0:	50                   	push   %eax
  8010a1:	68 8d 33 80 00       	push   $0x80338d
  8010a6:	6a 61                	push   $0x61
  8010a8:	68 64 33 80 00       	push   $0x803364
  8010ad:	e8 42 f1 ff ff       	call   8001f4 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8010b2:	83 ec 0c             	sub    $0xc,%esp
  8010b5:	68 05 08 00 00       	push   $0x805
  8010ba:	53                   	push   %ebx
  8010bb:	57                   	push   %edi
  8010bc:	53                   	push   %ebx
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 1c fc ff ff       	call   800ce0 <sys_page_map>
  8010c4:	83 c4 20             	add    $0x20,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	0f 88 b7 00 00 00    	js     801186 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	68 05 08 00 00       	push   $0x805
  8010d7:	53                   	push   %ebx
  8010d8:	6a 00                	push   $0x0
  8010da:	53                   	push   %ebx
  8010db:	6a 00                	push   $0x0
  8010dd:	e8 fe fb ff ff       	call   800ce0 <sys_page_map>
  8010e2:	83 c4 20             	add    $0x20,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	0f 88 ab 00 00 00    	js     801198 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010f9:	0f 84 ab 00 00 00    	je     8011aa <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  8010ff:	89 d8                	mov    %ebx,%eax
  801101:	c1 e8 16             	shr    $0x16,%eax
  801104:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80110b:	a8 01                	test   $0x1,%al
  80110d:	74 de                	je     8010ed <fork+0xc9>
  80110f:	89 d8                	mov    %ebx,%eax
  801111:	c1 e8 0c             	shr    $0xc,%eax
  801114:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80111b:	f6 c2 01             	test   $0x1,%dl
  80111e:	74 cd                	je     8010ed <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801120:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801123:	89 c2                	mov    %eax,%edx
  801125:	c1 ea 16             	shr    $0x16,%edx
  801128:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80112f:	f6 c2 01             	test   $0x1,%dl
  801132:	74 b9                	je     8010ed <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801134:	c1 e8 0c             	shr    $0xc,%eax
  801137:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  80113e:	a8 01                	test   $0x1,%al
  801140:	74 ab                	je     8010ed <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801142:	a9 02 08 00 00       	test   $0x802,%eax
  801147:	0f 84 3d ff ff ff    	je     80108a <fork+0x66>
	else if(pte & PTE_SHARE)
  80114d:	f6 c4 04             	test   $0x4,%ah
  801150:	0f 84 5c ff ff ff    	je     8010b2 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	25 07 0e 00 00       	and    $0xe07,%eax
  80115e:	50                   	push   %eax
  80115f:	53                   	push   %ebx
  801160:	57                   	push   %edi
  801161:	53                   	push   %ebx
  801162:	6a 00                	push   $0x0
  801164:	e8 77 fb ff ff       	call   800ce0 <sys_page_map>
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	0f 89 79 ff ff ff    	jns    8010ed <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801174:	50                   	push   %eax
  801175:	68 8d 33 80 00       	push   $0x80338d
  80117a:	6a 67                	push   $0x67
  80117c:	68 64 33 80 00       	push   $0x803364
  801181:	e8 6e f0 ff ff       	call   8001f4 <_panic>
			panic("Page Map Failed: %e", error_code);
  801186:	50                   	push   %eax
  801187:	68 8d 33 80 00       	push   $0x80338d
  80118c:	6a 6d                	push   $0x6d
  80118e:	68 64 33 80 00       	push   $0x803364
  801193:	e8 5c f0 ff ff       	call   8001f4 <_panic>
			panic("Page Map Failed: %e", error_code);
  801198:	50                   	push   %eax
  801199:	68 8d 33 80 00       	push   $0x80338d
  80119e:	6a 70                	push   $0x70
  8011a0:	68 64 33 80 00       	push   $0x803364
  8011a5:	e8 4a f0 ff ff       	call   8001f4 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	6a 07                	push   $0x7
  8011af:	68 00 f0 bf ee       	push   $0xeebff000
  8011b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b7:	e8 e1 fa ff ff       	call   800c9d <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 36                	js     8011f9 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	68 79 2a 80 00       	push   $0x802a79
  8011cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ce:	e8 15 fc ff ff       	call   800de8 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	78 34                	js     80120e <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	6a 02                	push   $0x2
  8011df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e2:	e8 7d fb ff ff       	call   800d64 <sys_env_set_status>
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 35                	js     801223 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8011ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8011f9:	50                   	push   %eax
  8011fa:	68 93 2e 80 00       	push   $0x802e93
  8011ff:	68 ba 00 00 00       	push   $0xba
  801204:	68 64 33 80 00       	push   $0x803364
  801209:	e8 e6 ef ff ff       	call   8001f4 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80120e:	50                   	push   %eax
  80120f:	68 40 33 80 00       	push   $0x803340
  801214:	68 bf 00 00 00       	push   $0xbf
  801219:	68 64 33 80 00       	push   $0x803364
  80121e:	e8 d1 ef ff ff       	call   8001f4 <_panic>
      panic("sys_env_set_status: %e", r);
  801223:	50                   	push   %eax
  801224:	68 a1 33 80 00       	push   $0x8033a1
  801229:	68 c3 00 00 00       	push   $0xc3
  80122e:	68 64 33 80 00       	push   $0x803364
  801233:	e8 bc ef ff ff       	call   8001f4 <_panic>

00801238 <sfork>:

// Challenge!
int
sfork(void)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80123e:	68 b8 33 80 00       	push   $0x8033b8
  801243:	68 cc 00 00 00       	push   $0xcc
  801248:	68 64 33 80 00       	push   $0x803364
  80124d:	e8 a2 ef ff ff       	call   8001f4 <_panic>

00801252 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	05 00 00 00 30       	add    $0x30000000,%eax
  80125d:	c1 e8 0c             	shr    $0xc,%eax
}
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    

00801262 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80126d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801272:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 ea 16             	shr    $0x16,%edx
  801286:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128d:	f6 c2 01             	test   $0x1,%dl
  801290:	74 2d                	je     8012bf <fd_alloc+0x46>
  801292:	89 c2                	mov    %eax,%edx
  801294:	c1 ea 0c             	shr    $0xc,%edx
  801297:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129e:	f6 c2 01             	test   $0x1,%dl
  8012a1:	74 1c                	je     8012bf <fd_alloc+0x46>
  8012a3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012a8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ad:	75 d2                	jne    801281 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012b8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012bd:	eb 0a                	jmp    8012c9 <fd_alloc+0x50>
			*fd_store = fd;
  8012bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012d1:	83 f8 1f             	cmp    $0x1f,%eax
  8012d4:	77 30                	ja     801306 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d6:	c1 e0 0c             	shl    $0xc,%eax
  8012d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012de:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012e4:	f6 c2 01             	test   $0x1,%dl
  8012e7:	74 24                	je     80130d <fd_lookup+0x42>
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	c1 ea 0c             	shr    $0xc,%edx
  8012ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f5:	f6 c2 01             	test   $0x1,%dl
  8012f8:	74 1a                	je     801314 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    
		return -E_INVAL;
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb f7                	jmp    801304 <fd_lookup+0x39>
		return -E_INVAL;
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801312:	eb f0                	jmp    801304 <fd_lookup+0x39>
  801314:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801319:	eb e9                	jmp    801304 <fd_lookup+0x39>

0080131b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801324:	ba 00 00 00 00       	mov    $0x0,%edx
  801329:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132e:	39 08                	cmp    %ecx,(%eax)
  801330:	74 38                	je     80136a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801332:	83 c2 01             	add    $0x1,%edx
  801335:	8b 04 95 4c 34 80 00 	mov    0x80344c(,%edx,4),%eax
  80133c:	85 c0                	test   %eax,%eax
  80133e:	75 ee                	jne    80132e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801340:	a1 08 50 80 00       	mov    0x805008,%eax
  801345:	8b 40 48             	mov    0x48(%eax),%eax
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	51                   	push   %ecx
  80134c:	50                   	push   %eax
  80134d:	68 d0 33 80 00       	push   $0x8033d0
  801352:	e8 78 ef ff ff       	call   8002cf <cprintf>
	*dev = 0;
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    
			*dev = devtab[i];
  80136a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	eb f2                	jmp    801368 <dev_lookup+0x4d>

00801376 <fd_close>:
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	57                   	push   %edi
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
  80137c:	83 ec 24             	sub    $0x24,%esp
  80137f:	8b 75 08             	mov    0x8(%ebp),%esi
  801382:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801385:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801388:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801389:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80138f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801392:	50                   	push   %eax
  801393:	e8 33 ff ff ff       	call   8012cb <fd_lookup>
  801398:	89 c3                	mov    %eax,%ebx
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 05                	js     8013a6 <fd_close+0x30>
	    || fd != fd2)
  8013a1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013a4:	74 16                	je     8013bc <fd_close+0x46>
		return (must_exist ? r : 0);
  8013a6:	89 f8                	mov    %edi,%eax
  8013a8:	84 c0                	test   %al,%al
  8013aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013af:	0f 44 d8             	cmove  %eax,%ebx
}
  8013b2:	89 d8                	mov    %ebx,%eax
  8013b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5f                   	pop    %edi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	ff 36                	pushl  (%esi)
  8013c5:	e8 51 ff ff ff       	call   80131b <dev_lookup>
  8013ca:	89 c3                	mov    %eax,%ebx
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 1a                	js     8013ed <fd_close+0x77>
		if (dev->dev_close)
  8013d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	74 0b                	je     8013ed <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	56                   	push   %esi
  8013e6:	ff d0                	call   *%eax
  8013e8:	89 c3                	mov    %eax,%ebx
  8013ea:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	56                   	push   %esi
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 2a f9 ff ff       	call   800d22 <sys_page_unmap>
	return r;
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	eb b5                	jmp    8013b2 <fd_close+0x3c>

008013fd <close>:

int
close(int fdnum)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801403:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801406:	50                   	push   %eax
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	e8 bc fe ff ff       	call   8012cb <fd_lookup>
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	79 02                	jns    801418 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    
		return fd_close(fd, 1);
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	6a 01                	push   $0x1
  80141d:	ff 75 f4             	pushl  -0xc(%ebp)
  801420:	e8 51 ff ff ff       	call   801376 <fd_close>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	eb ec                	jmp    801416 <close+0x19>

0080142a <close_all>:

void
close_all(void)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801431:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	53                   	push   %ebx
  80143a:	e8 be ff ff ff       	call   8013fd <close>
	for (i = 0; i < MAXFD; i++)
  80143f:	83 c3 01             	add    $0x1,%ebx
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	83 fb 20             	cmp    $0x20,%ebx
  801448:	75 ec                	jne    801436 <close_all+0xc>
}
  80144a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	57                   	push   %edi
  801453:	56                   	push   %esi
  801454:	53                   	push   %ebx
  801455:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801458:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80145b:	50                   	push   %eax
  80145c:	ff 75 08             	pushl  0x8(%ebp)
  80145f:	e8 67 fe ff ff       	call   8012cb <fd_lookup>
  801464:	89 c3                	mov    %eax,%ebx
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	0f 88 81 00 00 00    	js     8014f2 <dup+0xa3>
		return r;
	close(newfdnum);
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	e8 81 ff ff ff       	call   8013fd <close>

	newfd = INDEX2FD(newfdnum);
  80147c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80147f:	c1 e6 0c             	shl    $0xc,%esi
  801482:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801488:	83 c4 04             	add    $0x4,%esp
  80148b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80148e:	e8 cf fd ff ff       	call   801262 <fd2data>
  801493:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801495:	89 34 24             	mov    %esi,(%esp)
  801498:	e8 c5 fd ff ff       	call   801262 <fd2data>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014a2:	89 d8                	mov    %ebx,%eax
  8014a4:	c1 e8 16             	shr    $0x16,%eax
  8014a7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ae:	a8 01                	test   $0x1,%al
  8014b0:	74 11                	je     8014c3 <dup+0x74>
  8014b2:	89 d8                	mov    %ebx,%eax
  8014b4:	c1 e8 0c             	shr    $0xc,%eax
  8014b7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014be:	f6 c2 01             	test   $0x1,%dl
  8014c1:	75 39                	jne    8014fc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c6:	89 d0                	mov    %edx,%eax
  8014c8:	c1 e8 0c             	shr    $0xc,%eax
  8014cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8014da:	50                   	push   %eax
  8014db:	56                   	push   %esi
  8014dc:	6a 00                	push   $0x0
  8014de:	52                   	push   %edx
  8014df:	6a 00                	push   $0x0
  8014e1:	e8 fa f7 ff ff       	call   800ce0 <sys_page_map>
  8014e6:	89 c3                	mov    %eax,%ebx
  8014e8:	83 c4 20             	add    $0x20,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 31                	js     801520 <dup+0xd1>
		goto err;

	return newfdnum;
  8014ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014f2:	89 d8                	mov    %ebx,%eax
  8014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	25 07 0e 00 00       	and    $0xe07,%eax
  80150b:	50                   	push   %eax
  80150c:	57                   	push   %edi
  80150d:	6a 00                	push   $0x0
  80150f:	53                   	push   %ebx
  801510:	6a 00                	push   $0x0
  801512:	e8 c9 f7 ff ff       	call   800ce0 <sys_page_map>
  801517:	89 c3                	mov    %eax,%ebx
  801519:	83 c4 20             	add    $0x20,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	79 a3                	jns    8014c3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	56                   	push   %esi
  801524:	6a 00                	push   $0x0
  801526:	e8 f7 f7 ff ff       	call   800d22 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80152b:	83 c4 08             	add    $0x8,%esp
  80152e:	57                   	push   %edi
  80152f:	6a 00                	push   $0x0
  801531:	e8 ec f7 ff ff       	call   800d22 <sys_page_unmap>
	return r;
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	eb b7                	jmp    8014f2 <dup+0xa3>

0080153b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	53                   	push   %ebx
  80153f:	83 ec 1c             	sub    $0x1c,%esp
  801542:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801545:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801548:	50                   	push   %eax
  801549:	53                   	push   %ebx
  80154a:	e8 7c fd ff ff       	call   8012cb <fd_lookup>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 3f                	js     801595 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155c:	50                   	push   %eax
  80155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801560:	ff 30                	pushl  (%eax)
  801562:	e8 b4 fd ff ff       	call   80131b <dev_lookup>
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 27                	js     801595 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80156e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801571:	8b 42 08             	mov    0x8(%edx),%eax
  801574:	83 e0 03             	and    $0x3,%eax
  801577:	83 f8 01             	cmp    $0x1,%eax
  80157a:	74 1e                	je     80159a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	8b 40 08             	mov    0x8(%eax),%eax
  801582:	85 c0                	test   %eax,%eax
  801584:	74 35                	je     8015bb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	ff 75 10             	pushl  0x10(%ebp)
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	52                   	push   %edx
  801590:	ff d0                	call   *%eax
  801592:	83 c4 10             	add    $0x10,%esp
}
  801595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801598:	c9                   	leave  
  801599:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80159a:	a1 08 50 80 00       	mov    0x805008,%eax
  80159f:	8b 40 48             	mov    0x48(%eax),%eax
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	53                   	push   %ebx
  8015a6:	50                   	push   %eax
  8015a7:	68 11 34 80 00       	push   $0x803411
  8015ac:	e8 1e ed ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b9:	eb da                	jmp    801595 <read+0x5a>
		return -E_NOT_SUPP;
  8015bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c0:	eb d3                	jmp    801595 <read+0x5a>

008015c2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	57                   	push   %edi
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 0c             	sub    $0xc,%esp
  8015cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015ce:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	39 f3                	cmp    %esi,%ebx
  8015d8:	73 23                	jae    8015fd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	89 f0                	mov    %esi,%eax
  8015df:	29 d8                	sub    %ebx,%eax
  8015e1:	50                   	push   %eax
  8015e2:	89 d8                	mov    %ebx,%eax
  8015e4:	03 45 0c             	add    0xc(%ebp),%eax
  8015e7:	50                   	push   %eax
  8015e8:	57                   	push   %edi
  8015e9:	e8 4d ff ff ff       	call   80153b <read>
		if (m < 0)
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 06                	js     8015fb <readn+0x39>
			return m;
		if (m == 0)
  8015f5:	74 06                	je     8015fd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015f7:	01 c3                	add    %eax,%ebx
  8015f9:	eb db                	jmp    8015d6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015fb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015fd:	89 d8                	mov    %ebx,%eax
  8015ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801602:	5b                   	pop    %ebx
  801603:	5e                   	pop    %esi
  801604:	5f                   	pop    %edi
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    

00801607 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	53                   	push   %ebx
  80160b:	83 ec 1c             	sub    $0x1c,%esp
  80160e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801611:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801614:	50                   	push   %eax
  801615:	53                   	push   %ebx
  801616:	e8 b0 fc ff ff       	call   8012cb <fd_lookup>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 3a                	js     80165c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162c:	ff 30                	pushl  (%eax)
  80162e:	e8 e8 fc ff ff       	call   80131b <dev_lookup>
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	78 22                	js     80165c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801641:	74 1e                	je     801661 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801646:	8b 52 0c             	mov    0xc(%edx),%edx
  801649:	85 d2                	test   %edx,%edx
  80164b:	74 35                	je     801682 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	ff 75 10             	pushl  0x10(%ebp)
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	50                   	push   %eax
  801657:	ff d2                	call   *%edx
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801661:	a1 08 50 80 00       	mov    0x805008,%eax
  801666:	8b 40 48             	mov    0x48(%eax),%eax
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	53                   	push   %ebx
  80166d:	50                   	push   %eax
  80166e:	68 2d 34 80 00       	push   $0x80342d
  801673:	e8 57 ec ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801680:	eb da                	jmp    80165c <write+0x55>
		return -E_NOT_SUPP;
  801682:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801687:	eb d3                	jmp    80165c <write+0x55>

00801689 <seek>:

int
seek(int fdnum, off_t offset)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 30 fc ff ff       	call   8012cb <fd_lookup>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 0e                	js     8016b0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 1c             	sub    $0x1c,%esp
  8016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	53                   	push   %ebx
  8016c1:	e8 05 fc ff ff       	call   8012cb <fd_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 37                	js     801704 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d3:	50                   	push   %eax
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d7:	ff 30                	pushl  (%eax)
  8016d9:	e8 3d fc ff ff       	call   80131b <dev_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 1f                	js     801704 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ec:	74 1b                	je     801709 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f1:	8b 52 18             	mov    0x18(%edx),%edx
  8016f4:	85 d2                	test   %edx,%edx
  8016f6:	74 32                	je     80172a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	50                   	push   %eax
  8016ff:	ff d2                	call   *%edx
  801701:	83 c4 10             	add    $0x10,%esp
}
  801704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801707:	c9                   	leave  
  801708:	c3                   	ret    
			thisenv->env_id, fdnum);
  801709:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80170e:	8b 40 48             	mov    0x48(%eax),%eax
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	53                   	push   %ebx
  801715:	50                   	push   %eax
  801716:	68 f0 33 80 00       	push   $0x8033f0
  80171b:	e8 af eb ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801728:	eb da                	jmp    801704 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80172a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172f:	eb d3                	jmp    801704 <ftruncate+0x52>

00801731 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	53                   	push   %ebx
  801735:	83 ec 1c             	sub    $0x1c,%esp
  801738:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173e:	50                   	push   %eax
  80173f:	ff 75 08             	pushl  0x8(%ebp)
  801742:	e8 84 fb ff ff       	call   8012cb <fd_lookup>
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	85 c0                	test   %eax,%eax
  80174c:	78 4b                	js     801799 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801754:	50                   	push   %eax
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	ff 30                	pushl  (%eax)
  80175a:	e8 bc fb ff ff       	call   80131b <dev_lookup>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 33                	js     801799 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801769:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80176d:	74 2f                	je     80179e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80176f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801772:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801779:	00 00 00 
	stat->st_isdir = 0;
  80177c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801783:	00 00 00 
	stat->st_dev = dev;
  801786:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	53                   	push   %ebx
  801790:	ff 75 f0             	pushl  -0x10(%ebp)
  801793:	ff 50 14             	call   *0x14(%eax)
  801796:	83 c4 10             	add    $0x10,%esp
}
  801799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    
		return -E_NOT_SUPP;
  80179e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a3:	eb f4                	jmp    801799 <fstat+0x68>

008017a5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	6a 00                	push   $0x0
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	e8 2f 02 00 00       	call   8019e6 <open>
  8017b7:	89 c3                	mov    %eax,%ebx
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 1b                	js     8017db <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017c0:	83 ec 08             	sub    $0x8,%esp
  8017c3:	ff 75 0c             	pushl  0xc(%ebp)
  8017c6:	50                   	push   %eax
  8017c7:	e8 65 ff ff ff       	call   801731 <fstat>
  8017cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8017ce:	89 1c 24             	mov    %ebx,(%esp)
  8017d1:	e8 27 fc ff ff       	call   8013fd <close>
	return r;
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	89 f3                	mov    %esi,%ebx
}
  8017db:	89 d8                	mov    %ebx,%eax
  8017dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	89 c6                	mov    %eax,%esi
  8017eb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017ed:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8017f4:	74 27                	je     80181d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017f6:	6a 07                	push   $0x7
  8017f8:	68 00 60 80 00       	push   $0x806000
  8017fd:	56                   	push   %esi
  8017fe:	ff 35 00 50 80 00    	pushl  0x805000
  801804:	e8 0a 13 00 00       	call   802b13 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801809:	83 c4 0c             	add    $0xc,%esp
  80180c:	6a 00                	push   $0x0
  80180e:	53                   	push   %ebx
  80180f:	6a 00                	push   $0x0
  801811:	e8 8a 12 00 00       	call   802aa0 <ipc_recv>
}
  801816:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	6a 01                	push   $0x1
  801822:	e8 58 13 00 00       	call   802b7f <ipc_find_env>
  801827:	a3 00 50 80 00       	mov    %eax,0x805000
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	eb c5                	jmp    8017f6 <fsipc+0x12>

00801831 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 40 0c             	mov    0xc(%eax),%eax
  80183d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	b8 02 00 00 00       	mov    $0x2,%eax
  801854:	e8 8b ff ff ff       	call   8017e4 <fsipc>
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <devfile_flush>:
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 40 0c             	mov    0xc(%eax),%eax
  801867:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	b8 06 00 00 00       	mov    $0x6,%eax
  801876:	e8 69 ff ff ff       	call   8017e4 <fsipc>
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <devfile_stat>:
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	53                   	push   %ebx
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	8b 40 0c             	mov    0xc(%eax),%eax
  80188d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801892:	ba 00 00 00 00       	mov    $0x0,%edx
  801897:	b8 05 00 00 00       	mov    $0x5,%eax
  80189c:	e8 43 ff ff ff       	call   8017e4 <fsipc>
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 2c                	js     8018d1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018a5:	83 ec 08             	sub    $0x8,%esp
  8018a8:	68 00 60 80 00       	push   $0x806000
  8018ad:	53                   	push   %ebx
  8018ae:	e8 f8 ef ff ff       	call   8008ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018b3:	a1 80 60 80 00       	mov    0x806080,%eax
  8018b8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018be:	a1 84 60 80 00       	mov    0x806084,%eax
  8018c3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <devfile_write>:
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8018e0:	85 db                	test   %ebx,%ebx
  8018e2:	75 07                	jne    8018eb <devfile_write+0x15>
	return n_all;
  8018e4:	89 d8                	mov    %ebx,%eax
}
  8018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f1:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  8018f6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	53                   	push   %ebx
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	68 08 60 80 00       	push   $0x806008
  801908:	e8 2c f1 ff ff       	call   800a39 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
  801912:	b8 04 00 00 00       	mov    $0x4,%eax
  801917:	e8 c8 fe ff ff       	call   8017e4 <fsipc>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 c3                	js     8018e6 <devfile_write+0x10>
	  assert(r <= n_left);
  801923:	39 d8                	cmp    %ebx,%eax
  801925:	77 0b                	ja     801932 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801927:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80192c:	7f 1d                	jg     80194b <devfile_write+0x75>
    n_all += r;
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	eb b2                	jmp    8018e4 <devfile_write+0xe>
	  assert(r <= n_left);
  801932:	68 60 34 80 00       	push   $0x803460
  801937:	68 6c 34 80 00       	push   $0x80346c
  80193c:	68 9f 00 00 00       	push   $0x9f
  801941:	68 81 34 80 00       	push   $0x803481
  801946:	e8 a9 e8 ff ff       	call   8001f4 <_panic>
	  assert(r <= PGSIZE);
  80194b:	68 8c 34 80 00       	push   $0x80348c
  801950:	68 6c 34 80 00       	push   $0x80346c
  801955:	68 a0 00 00 00       	push   $0xa0
  80195a:	68 81 34 80 00       	push   $0x803481
  80195f:	e8 90 e8 ff ff       	call   8001f4 <_panic>

00801964 <devfile_read>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
  801969:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8b 40 0c             	mov    0xc(%eax),%eax
  801972:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801977:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80197d:	ba 00 00 00 00       	mov    $0x0,%edx
  801982:	b8 03 00 00 00       	mov    $0x3,%eax
  801987:	e8 58 fe ff ff       	call   8017e4 <fsipc>
  80198c:	89 c3                	mov    %eax,%ebx
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 1f                	js     8019b1 <devfile_read+0x4d>
	assert(r <= n);
  801992:	39 f0                	cmp    %esi,%eax
  801994:	77 24                	ja     8019ba <devfile_read+0x56>
	assert(r <= PGSIZE);
  801996:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80199b:	7f 33                	jg     8019d0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	50                   	push   %eax
  8019a1:	68 00 60 80 00       	push   $0x806000
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	e8 8b f0 ff ff       	call   800a39 <memmove>
	return r;
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	89 d8                	mov    %ebx,%eax
  8019b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5e                   	pop    %esi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    
	assert(r <= n);
  8019ba:	68 98 34 80 00       	push   $0x803498
  8019bf:	68 6c 34 80 00       	push   $0x80346c
  8019c4:	6a 7c                	push   $0x7c
  8019c6:	68 81 34 80 00       	push   $0x803481
  8019cb:	e8 24 e8 ff ff       	call   8001f4 <_panic>
	assert(r <= PGSIZE);
  8019d0:	68 8c 34 80 00       	push   $0x80348c
  8019d5:	68 6c 34 80 00       	push   $0x80346c
  8019da:	6a 7d                	push   $0x7d
  8019dc:	68 81 34 80 00       	push   $0x803481
  8019e1:	e8 0e e8 ff ff       	call   8001f4 <_panic>

008019e6 <open>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	56                   	push   %esi
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 1c             	sub    $0x1c,%esp
  8019ee:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019f1:	56                   	push   %esi
  8019f2:	e8 7b ee ff ff       	call   800872 <strlen>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019ff:	7f 6c                	jg     801a6d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a01:	83 ec 0c             	sub    $0xc,%esp
  801a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	e8 6c f8 ff ff       	call   801279 <fd_alloc>
  801a0d:	89 c3                	mov    %eax,%ebx
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 3c                	js     801a52 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	56                   	push   %esi
  801a1a:	68 00 60 80 00       	push   $0x806000
  801a1f:	e8 87 ee ff ff       	call   8008ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a34:	e8 ab fd ff ff       	call   8017e4 <fsipc>
  801a39:	89 c3                	mov    %eax,%ebx
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 19                	js     801a5b <open+0x75>
	return fd2num(fd);
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	ff 75 f4             	pushl  -0xc(%ebp)
  801a48:	e8 05 f8 ff ff       	call   801252 <fd2num>
  801a4d:	89 c3                	mov    %eax,%ebx
  801a4f:	83 c4 10             	add    $0x10,%esp
}
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    
		fd_close(fd, 0);
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	6a 00                	push   $0x0
  801a60:	ff 75 f4             	pushl  -0xc(%ebp)
  801a63:	e8 0e f9 ff ff       	call   801376 <fd_close>
		return r;
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	eb e5                	jmp    801a52 <open+0x6c>
		return -E_BAD_PATH;
  801a6d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a72:	eb de                	jmp    801a52 <open+0x6c>

00801a74 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a84:	e8 5b fd ff ff       	call   8017e4 <fsipc>
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	57                   	push   %edi
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  801a97:	e8 c3 f1 ff ff       	call   800c5f <sys_getenvid>
  801a9c:	83 ec 08             	sub    $0x8,%esp
  801a9f:	50                   	push   %eax
  801aa0:	68 9f 34 80 00       	push   $0x80349f
  801aa5:	e8 25 e8 ff ff       	call   8002cf <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801aaa:	83 c4 08             	add    $0x8,%esp
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	e8 2f ff ff ff       	call   8019e6 <open>
  801ab7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	0f 88 fb 04 00 00    	js     801fc3 <spawn+0x538>
  801ac8:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	68 00 02 00 00       	push   $0x200
  801ad2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801ad8:	50                   	push   %eax
  801ad9:	52                   	push   %edx
  801ada:	e8 e3 fa ff ff       	call   8015c2 <readn>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ae7:	75 71                	jne    801b5a <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801ae9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801af0:	45 4c 46 
  801af3:	75 65                	jne    801b5a <spawn+0xcf>
  801af5:	b8 07 00 00 00       	mov    $0x7,%eax
  801afa:	cd 30                	int    $0x30
  801afc:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801b02:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b08:	89 c6                	mov    %eax,%esi
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	0f 88 a5 04 00 00    	js     801fb7 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  801b12:	83 ec 08             	sub    $0x8,%esp
  801b15:	50                   	push   %eax
  801b16:	68 d3 34 80 00       	push   $0x8034d3
  801b1b:	e8 af e7 ff ff       	call   8002cf <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b20:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801b26:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801b29:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b2f:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b35:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b3c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b42:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801b48:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b50:	be 00 00 00 00       	mov    $0x0,%esi
  801b55:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b58:	eb 4b                	jmp    801ba5 <spawn+0x11a>
		close(fd);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b63:	e8 95 f8 ff ff       	call   8013fd <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b68:	83 c4 0c             	add    $0xc,%esp
  801b6b:	68 7f 45 4c 46       	push   $0x464c457f
  801b70:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b76:	68 b9 34 80 00       	push   $0x8034b9
  801b7b:	e8 4f e7 ff ff       	call   8002cf <cprintf>
		return -E_NOT_EXEC;
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801b8a:	ff ff ff 
  801b8d:	e9 31 04 00 00       	jmp    801fc3 <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	50                   	push   %eax
  801b96:	e8 d7 ec ff ff       	call   800872 <strlen>
  801b9b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b9f:	83 c3 01             	add    $0x1,%ebx
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801bac:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	75 df                	jne    801b92 <spawn+0x107>
  801bb3:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801bb9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801bbf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801bc4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801bc6:	89 fa                	mov    %edi,%edx
  801bc8:	83 e2 fc             	and    $0xfffffffc,%edx
  801bcb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801bd2:	29 c2                	sub    %eax,%edx
  801bd4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bda:	8d 42 f8             	lea    -0x8(%edx),%eax
  801bdd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801be2:	0f 86 fe 03 00 00    	jbe    801fe6 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	6a 07                	push   $0x7
  801bed:	68 00 00 40 00       	push   $0x400000
  801bf2:	6a 00                	push   $0x0
  801bf4:	e8 a4 f0 ff ff       	call   800c9d <sys_page_alloc>
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	0f 88 e7 03 00 00    	js     801feb <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c04:	be 00 00 00 00       	mov    $0x0,%esi
  801c09:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c12:	eb 30                	jmp    801c44 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801c14:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c1a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c20:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c29:	57                   	push   %edi
  801c2a:	e8 7c ec ff ff       	call   8008ab <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c2f:	83 c4 04             	add    $0x4,%esp
  801c32:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c35:	e8 38 ec ff ff       	call   800872 <strlen>
  801c3a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c3e:	83 c6 01             	add    $0x1,%esi
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c4a:	7f c8                	jg     801c14 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801c4c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c52:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c58:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c5f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c65:	0f 85 86 00 00 00    	jne    801cf1 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c6b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c71:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801c77:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c7a:	89 c8                	mov    %ecx,%eax
  801c7c:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801c82:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c85:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c8a:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	6a 07                	push   $0x7
  801c95:	68 00 d0 bf ee       	push   $0xeebfd000
  801c9a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ca0:	68 00 00 40 00       	push   $0x400000
  801ca5:	6a 00                	push   $0x0
  801ca7:	e8 34 f0 ff ff       	call   800ce0 <sys_page_map>
  801cac:	89 c3                	mov    %eax,%ebx
  801cae:	83 c4 20             	add    $0x20,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	0f 88 3a 03 00 00    	js     801ff3 <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	68 00 00 40 00       	push   $0x400000
  801cc1:	6a 00                	push   $0x0
  801cc3:	e8 5a f0 ff ff       	call   800d22 <sys_page_unmap>
  801cc8:	89 c3                	mov    %eax,%ebx
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	0f 88 1e 03 00 00    	js     801ff3 <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801cd5:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801cdb:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ce2:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801ce9:	00 00 00 
  801cec:	e9 4f 01 00 00       	jmp    801e40 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801cf1:	68 30 35 80 00       	push   $0x803530
  801cf6:	68 6c 34 80 00       	push   $0x80346c
  801cfb:	68 f4 00 00 00       	push   $0xf4
  801d00:	68 ec 34 80 00       	push   $0x8034ec
  801d05:	e8 ea e4 ff ff       	call   8001f4 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	6a 07                	push   $0x7
  801d0f:	68 00 00 40 00       	push   $0x400000
  801d14:	6a 00                	push   $0x0
  801d16:	e8 82 ef ff ff       	call   800c9d <sys_page_alloc>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	0f 88 ab 02 00 00    	js     801fd1 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d2f:	01 f0                	add    %esi,%eax
  801d31:	50                   	push   %eax
  801d32:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d38:	e8 4c f9 ff ff       	call   801689 <seek>
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	85 c0                	test   %eax,%eax
  801d42:	0f 88 90 02 00 00    	js     801fd8 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d51:	29 f0                	sub    %esi,%eax
  801d53:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d58:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d5d:	0f 47 c1             	cmova  %ecx,%eax
  801d60:	50                   	push   %eax
  801d61:	68 00 00 40 00       	push   $0x400000
  801d66:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d6c:	e8 51 f8 ff ff       	call   8015c2 <readn>
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 88 63 02 00 00    	js     801fdf <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d85:	53                   	push   %ebx
  801d86:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d8c:	68 00 00 40 00       	push   $0x400000
  801d91:	6a 00                	push   $0x0
  801d93:	e8 48 ef ff ff       	call   800ce0 <sys_page_map>
  801d98:	83 c4 20             	add    $0x20,%esp
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	78 7c                	js     801e1b <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d9f:	83 ec 08             	sub    $0x8,%esp
  801da2:	68 00 00 40 00       	push   $0x400000
  801da7:	6a 00                	push   $0x0
  801da9:	e8 74 ef ff ff       	call   800d22 <sys_page_unmap>
  801dae:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801db1:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801db7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dbd:	89 fe                	mov    %edi,%esi
  801dbf:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801dc5:	76 69                	jbe    801e30 <spawn+0x3a5>
		if (i >= filesz) {
  801dc7:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801dcd:	0f 87 37 ff ff ff    	ja     801d0a <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ddc:	53                   	push   %ebx
  801ddd:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801de3:	e8 b5 ee ff ff       	call   800c9d <sys_page_alloc>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	79 c2                	jns    801db1 <spawn+0x326>
  801def:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801df1:	83 ec 0c             	sub    $0xc,%esp
  801df4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dfa:	e8 1f ee ff ff       	call   800c1e <sys_env_destroy>
	close(fd);
  801dff:	83 c4 04             	add    $0x4,%esp
  801e02:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e08:	e8 f0 f5 ff ff       	call   8013fd <close>
	return r;
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801e16:	e9 a8 01 00 00       	jmp    801fc3 <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  801e1b:	50                   	push   %eax
  801e1c:	68 f8 34 80 00       	push   $0x8034f8
  801e21:	68 27 01 00 00       	push   $0x127
  801e26:	68 ec 34 80 00       	push   $0x8034ec
  801e2b:	e8 c4 e3 ff ff       	call   8001f4 <_panic>
  801e30:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e36:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801e3d:	83 c6 20             	add    $0x20,%esi
  801e40:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e47:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801e4d:	7e 6d                	jle    801ebc <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801e4f:	83 3e 01             	cmpl   $0x1,(%esi)
  801e52:	75 e2                	jne    801e36 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e54:	8b 46 18             	mov    0x18(%esi),%eax
  801e57:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e5a:	83 f8 01             	cmp    $0x1,%eax
  801e5d:	19 c0                	sbb    %eax,%eax
  801e5f:	83 e0 fe             	and    $0xfffffffe,%eax
  801e62:	83 c0 07             	add    $0x7,%eax
  801e65:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e6b:	8b 4e 04             	mov    0x4(%esi),%ecx
  801e6e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e74:	8b 56 10             	mov    0x10(%esi),%edx
  801e77:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801e7d:	8b 7e 14             	mov    0x14(%esi),%edi
  801e80:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801e86:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e89:	89 d8                	mov    %ebx,%eax
  801e8b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e90:	74 1a                	je     801eac <spawn+0x421>
		va -= i;
  801e92:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e94:	01 c7                	add    %eax,%edi
  801e96:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e9c:	01 c2                	add    %eax,%edx
  801e9e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801ea4:	29 c1                	sub    %eax,%ecx
  801ea6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801eac:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb1:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801eb7:	e9 01 ff ff ff       	jmp    801dbd <spawn+0x332>
	close(fd);
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ec5:	e8 33 f5 ff ff       	call   8013fd <close>
  801eca:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801ecd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ed2:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ed8:	eb 0d                	jmp    801ee7 <spawn+0x45c>
  801eda:	83 c3 01             	add    $0x1,%ebx
  801edd:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801ee3:	77 5d                	ja     801f42 <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  801ee5:	74 f3                	je     801eda <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  801ee7:	89 da                	mov    %ebx,%edx
  801ee9:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	c1 e8 16             	shr    $0x16,%eax
  801ef1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ef8:	a8 01                	test   $0x1,%al
  801efa:	74 de                	je     801eda <spawn+0x44f>
		pte_t pte = uvpt[i];
  801efc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  801f03:	89 c1                	mov    %eax,%ecx
  801f05:	81 e1 01 04 00 00    	and    $0x401,%ecx
  801f0b:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  801f11:	75 c7                	jne    801eda <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	25 07 0e 00 00       	and    $0xe07,%eax
  801f1b:	50                   	push   %eax
  801f1c:	52                   	push   %edx
  801f1d:	56                   	push   %esi
  801f1e:	52                   	push   %edx
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 ba ed ff ff       	call   800ce0 <sys_page_map>
  801f26:	83 c4 20             	add    $0x20,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	79 ad                	jns    801eda <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  801f2d:	50                   	push   %eax
  801f2e:	68 8d 33 80 00       	push   $0x80338d
  801f33:	68 42 01 00 00       	push   $0x142
  801f38:	68 ec 34 80 00       	push   $0x8034ec
  801f3d:	e8 b2 e2 ff ff       	call   8001f4 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801f42:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f49:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f55:	50                   	push   %eax
  801f56:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f5c:	e8 45 ee ff ff       	call   800da6 <sys_env_set_trapframe>
  801f61:	83 c4 10             	add    $0x10,%esp
  801f64:	85 c0                	test   %eax,%eax
  801f66:	78 25                	js     801f8d <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	6a 02                	push   $0x2
  801f6d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f73:	e8 ec ed ff ff       	call   800d64 <sys_env_set_status>
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 23                	js     801fa2 <spawn+0x517>
	return child;
  801f7f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f85:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f8b:	eb 36                	jmp    801fc3 <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  801f8d:	50                   	push   %eax
  801f8e:	68 15 35 80 00       	push   $0x803515
  801f93:	68 88 00 00 00       	push   $0x88
  801f98:	68 ec 34 80 00       	push   $0x8034ec
  801f9d:	e8 52 e2 ff ff       	call   8001f4 <_panic>
		panic("sys_env_set_status: %e", r);
  801fa2:	50                   	push   %eax
  801fa3:	68 a1 33 80 00       	push   $0x8033a1
  801fa8:	68 8b 00 00 00       	push   $0x8b
  801fad:	68 ec 34 80 00       	push   $0x8034ec
  801fb2:	e8 3d e2 ff ff       	call   8001f4 <_panic>
		return r;
  801fb7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801fbd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801fc3:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	e9 19 fe ff ff       	jmp    801df1 <spawn+0x366>
  801fd8:	89 c7                	mov    %eax,%edi
  801fda:	e9 12 fe ff ff       	jmp    801df1 <spawn+0x366>
  801fdf:	89 c7                	mov    %eax,%edi
  801fe1:	e9 0b fe ff ff       	jmp    801df1 <spawn+0x366>
		return -E_NO_MEM;
  801fe6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801feb:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ff1:	eb d0                	jmp    801fc3 <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  801ff3:	83 ec 08             	sub    $0x8,%esp
  801ff6:	68 00 00 40 00       	push   $0x400000
  801ffb:	6a 00                	push   $0x0
  801ffd:	e8 20 ed ff ff       	call   800d22 <sys_page_unmap>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80200b:	eb b6                	jmp    801fc3 <spawn+0x538>

0080200d <spawnl>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	57                   	push   %edi
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802016:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80201e:	8d 4a 04             	lea    0x4(%edx),%ecx
  802021:	83 3a 00             	cmpl   $0x0,(%edx)
  802024:	74 07                	je     80202d <spawnl+0x20>
		argc++;
  802026:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802029:	89 ca                	mov    %ecx,%edx
  80202b:	eb f1                	jmp    80201e <spawnl+0x11>
	const char *argv[argc+2];
  80202d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802034:	83 e2 f0             	and    $0xfffffff0,%edx
  802037:	29 d4                	sub    %edx,%esp
  802039:	8d 54 24 03          	lea    0x3(%esp),%edx
  80203d:	c1 ea 02             	shr    $0x2,%edx
  802040:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802047:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80204c:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802053:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80205a:	00 
	va_start(vl, arg0);
  80205b:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80205e:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
  802065:	eb 0b                	jmp    802072 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802067:	83 c0 01             	add    $0x1,%eax
  80206a:	8b 39                	mov    (%ecx),%edi
  80206c:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80206f:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802072:	39 d0                	cmp    %edx,%eax
  802074:	75 f1                	jne    802067 <spawnl+0x5a>
	return spawn(prog, argv);
  802076:	83 ec 08             	sub    $0x8,%esp
  802079:	56                   	push   %esi
  80207a:	ff 75 08             	pushl  0x8(%ebp)
  80207d:	e8 09 fa ff ff       	call   801a8b <spawn>
}
  802082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	56                   	push   %esi
  80208e:	53                   	push   %ebx
  80208f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	ff 75 08             	pushl  0x8(%ebp)
  802098:	e8 c5 f1 ff ff       	call   801262 <fd2data>
  80209d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80209f:	83 c4 08             	add    $0x8,%esp
  8020a2:	68 56 35 80 00       	push   $0x803556
  8020a7:	53                   	push   %ebx
  8020a8:	e8 fe e7 ff ff       	call   8008ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020ad:	8b 46 04             	mov    0x4(%esi),%eax
  8020b0:	2b 06                	sub    (%esi),%eax
  8020b2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020bf:	00 00 00 
	stat->st_dev = &devpipe;
  8020c2:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  8020c9:	40 80 00 
	return 0;
}
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d4:	5b                   	pop    %ebx
  8020d5:	5e                   	pop    %esi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    

008020d8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020e2:	53                   	push   %ebx
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 38 ec ff ff       	call   800d22 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020ea:	89 1c 24             	mov    %ebx,(%esp)
  8020ed:	e8 70 f1 ff ff       	call   801262 <fd2data>
  8020f2:	83 c4 08             	add    $0x8,%esp
  8020f5:	50                   	push   %eax
  8020f6:	6a 00                	push   $0x0
  8020f8:	e8 25 ec ff ff       	call   800d22 <sys_page_unmap>
}
  8020fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <_pipeisclosed>:
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 1c             	sub    $0x1c,%esp
  80210b:	89 c7                	mov    %eax,%edi
  80210d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80210f:	a1 08 50 80 00       	mov    0x805008,%eax
  802114:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	57                   	push   %edi
  80211b:	e8 98 0a 00 00       	call   802bb8 <pageref>
  802120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802123:	89 34 24             	mov    %esi,(%esp)
  802126:	e8 8d 0a 00 00       	call   802bb8 <pageref>
		nn = thisenv->env_runs;
  80212b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802131:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	39 cb                	cmp    %ecx,%ebx
  802139:	74 1b                	je     802156 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80213b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80213e:	75 cf                	jne    80210f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802140:	8b 42 58             	mov    0x58(%edx),%eax
  802143:	6a 01                	push   $0x1
  802145:	50                   	push   %eax
  802146:	53                   	push   %ebx
  802147:	68 5d 35 80 00       	push   $0x80355d
  80214c:	e8 7e e1 ff ff       	call   8002cf <cprintf>
  802151:	83 c4 10             	add    $0x10,%esp
  802154:	eb b9                	jmp    80210f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802156:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802159:	0f 94 c0             	sete   %al
  80215c:	0f b6 c0             	movzbl %al,%eax
}
  80215f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802162:	5b                   	pop    %ebx
  802163:	5e                   	pop    %esi
  802164:	5f                   	pop    %edi
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    

00802167 <devpipe_write>:
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	57                   	push   %edi
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
  80216d:	83 ec 28             	sub    $0x28,%esp
  802170:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802173:	56                   	push   %esi
  802174:	e8 e9 f0 ff ff       	call   801262 <fd2data>
  802179:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	bf 00 00 00 00       	mov    $0x0,%edi
  802183:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802186:	74 4f                	je     8021d7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802188:	8b 43 04             	mov    0x4(%ebx),%eax
  80218b:	8b 0b                	mov    (%ebx),%ecx
  80218d:	8d 51 20             	lea    0x20(%ecx),%edx
  802190:	39 d0                	cmp    %edx,%eax
  802192:	72 14                	jb     8021a8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802194:	89 da                	mov    %ebx,%edx
  802196:	89 f0                	mov    %esi,%eax
  802198:	e8 65 ff ff ff       	call   802102 <_pipeisclosed>
  80219d:	85 c0                	test   %eax,%eax
  80219f:	75 3b                	jne    8021dc <devpipe_write+0x75>
			sys_yield();
  8021a1:	e8 d8 ea ff ff       	call   800c7e <sys_yield>
  8021a6:	eb e0                	jmp    802188 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021ab:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021af:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	c1 fa 1f             	sar    $0x1f,%edx
  8021b7:	89 d1                	mov    %edx,%ecx
  8021b9:	c1 e9 1b             	shr    $0x1b,%ecx
  8021bc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021bf:	83 e2 1f             	and    $0x1f,%edx
  8021c2:	29 ca                	sub    %ecx,%edx
  8021c4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021cc:	83 c0 01             	add    $0x1,%eax
  8021cf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021d2:	83 c7 01             	add    $0x1,%edi
  8021d5:	eb ac                	jmp    802183 <devpipe_write+0x1c>
	return i;
  8021d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021da:	eb 05                	jmp    8021e1 <devpipe_write+0x7a>
				return 0;
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e4:	5b                   	pop    %ebx
  8021e5:	5e                   	pop    %esi
  8021e6:	5f                   	pop    %edi
  8021e7:	5d                   	pop    %ebp
  8021e8:	c3                   	ret    

008021e9 <devpipe_read>:
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	57                   	push   %edi
  8021ed:	56                   	push   %esi
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 18             	sub    $0x18,%esp
  8021f2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021f5:	57                   	push   %edi
  8021f6:	e8 67 f0 ff ff       	call   801262 <fd2data>
  8021fb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	be 00 00 00 00       	mov    $0x0,%esi
  802205:	3b 75 10             	cmp    0x10(%ebp),%esi
  802208:	75 14                	jne    80221e <devpipe_read+0x35>
	return i;
  80220a:	8b 45 10             	mov    0x10(%ebp),%eax
  80220d:	eb 02                	jmp    802211 <devpipe_read+0x28>
				return i;
  80220f:	89 f0                	mov    %esi,%eax
}
  802211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    
			sys_yield();
  802219:	e8 60 ea ff ff       	call   800c7e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80221e:	8b 03                	mov    (%ebx),%eax
  802220:	3b 43 04             	cmp    0x4(%ebx),%eax
  802223:	75 18                	jne    80223d <devpipe_read+0x54>
			if (i > 0)
  802225:	85 f6                	test   %esi,%esi
  802227:	75 e6                	jne    80220f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802229:	89 da                	mov    %ebx,%edx
  80222b:	89 f8                	mov    %edi,%eax
  80222d:	e8 d0 fe ff ff       	call   802102 <_pipeisclosed>
  802232:	85 c0                	test   %eax,%eax
  802234:	74 e3                	je     802219 <devpipe_read+0x30>
				return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	eb d4                	jmp    802211 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80223d:	99                   	cltd   
  80223e:	c1 ea 1b             	shr    $0x1b,%edx
  802241:	01 d0                	add    %edx,%eax
  802243:	83 e0 1f             	and    $0x1f,%eax
  802246:	29 d0                	sub    %edx,%eax
  802248:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80224d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802250:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802253:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802256:	83 c6 01             	add    $0x1,%esi
  802259:	eb aa                	jmp    802205 <devpipe_read+0x1c>

0080225b <pipe>:
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	50                   	push   %eax
  802267:	e8 0d f0 ff ff       	call   801279 <fd_alloc>
  80226c:	89 c3                	mov    %eax,%ebx
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	85 c0                	test   %eax,%eax
  802273:	0f 88 23 01 00 00    	js     80239c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 07 04 00 00       	push   $0x407
  802281:	ff 75 f4             	pushl  -0xc(%ebp)
  802284:	6a 00                	push   $0x0
  802286:	e8 12 ea ff ff       	call   800c9d <sys_page_alloc>
  80228b:	89 c3                	mov    %eax,%ebx
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	85 c0                	test   %eax,%eax
  802292:	0f 88 04 01 00 00    	js     80239c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802298:	83 ec 0c             	sub    $0xc,%esp
  80229b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80229e:	50                   	push   %eax
  80229f:	e8 d5 ef ff ff       	call   801279 <fd_alloc>
  8022a4:	89 c3                	mov    %eax,%ebx
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	0f 88 db 00 00 00    	js     80238c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	68 07 04 00 00       	push   $0x407
  8022b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8022bc:	6a 00                	push   $0x0
  8022be:	e8 da e9 ff ff       	call   800c9d <sys_page_alloc>
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	0f 88 bc 00 00 00    	js     80238c <pipe+0x131>
	va = fd2data(fd0);
  8022d0:	83 ec 0c             	sub    $0xc,%esp
  8022d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d6:	e8 87 ef ff ff       	call   801262 <fd2data>
  8022db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022dd:	83 c4 0c             	add    $0xc,%esp
  8022e0:	68 07 04 00 00       	push   $0x407
  8022e5:	50                   	push   %eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	e8 b0 e9 ff ff       	call   800c9d <sys_page_alloc>
  8022ed:	89 c3                	mov    %eax,%ebx
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	0f 88 82 00 00 00    	js     80237c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fa:	83 ec 0c             	sub    $0xc,%esp
  8022fd:	ff 75 f0             	pushl  -0x10(%ebp)
  802300:	e8 5d ef ff ff       	call   801262 <fd2data>
  802305:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80230c:	50                   	push   %eax
  80230d:	6a 00                	push   $0x0
  80230f:	56                   	push   %esi
  802310:	6a 00                	push   $0x0
  802312:	e8 c9 e9 ff ff       	call   800ce0 <sys_page_map>
  802317:	89 c3                	mov    %eax,%ebx
  802319:	83 c4 20             	add    $0x20,%esp
  80231c:	85 c0                	test   %eax,%eax
  80231e:	78 4e                	js     80236e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802320:	a1 28 40 80 00       	mov    0x804028,%eax
  802325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802328:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802337:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	ff 75 f4             	pushl  -0xc(%ebp)
  802349:	e8 04 ef ff ff       	call   801252 <fd2num>
  80234e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802351:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802353:	83 c4 04             	add    $0x4,%esp
  802356:	ff 75 f0             	pushl  -0x10(%ebp)
  802359:	e8 f4 ee ff ff       	call   801252 <fd2num>
  80235e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802361:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	bb 00 00 00 00       	mov    $0x0,%ebx
  80236c:	eb 2e                	jmp    80239c <pipe+0x141>
	sys_page_unmap(0, va);
  80236e:	83 ec 08             	sub    $0x8,%esp
  802371:	56                   	push   %esi
  802372:	6a 00                	push   $0x0
  802374:	e8 a9 e9 ff ff       	call   800d22 <sys_page_unmap>
  802379:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	ff 75 f0             	pushl  -0x10(%ebp)
  802382:	6a 00                	push   $0x0
  802384:	e8 99 e9 ff ff       	call   800d22 <sys_page_unmap>
  802389:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80238c:	83 ec 08             	sub    $0x8,%esp
  80238f:	ff 75 f4             	pushl  -0xc(%ebp)
  802392:	6a 00                	push   $0x0
  802394:	e8 89 e9 ff ff       	call   800d22 <sys_page_unmap>
  802399:	83 c4 10             	add    $0x10,%esp
}
  80239c:	89 d8                	mov    %ebx,%eax
  80239e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    

008023a5 <pipeisclosed>:
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ae:	50                   	push   %eax
  8023af:	ff 75 08             	pushl  0x8(%ebp)
  8023b2:	e8 14 ef ff ff       	call   8012cb <fd_lookup>
  8023b7:	83 c4 10             	add    $0x10,%esp
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 18                	js     8023d6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8023be:	83 ec 0c             	sub    $0xc,%esp
  8023c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c4:	e8 99 ee ff ff       	call   801262 <fd2data>
	return _pipeisclosed(fd, p);
  8023c9:	89 c2                	mov    %eax,%edx
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	e8 2f fd ff ff       	call   802102 <_pipeisclosed>
  8023d3:	83 c4 10             	add    $0x10,%esp
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	56                   	push   %esi
  8023dc:	53                   	push   %ebx
  8023dd:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8023e0:	85 f6                	test   %esi,%esi
  8023e2:	74 13                	je     8023f7 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8023e4:	89 f3                	mov    %esi,%ebx
  8023e6:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023ec:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8023ef:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8023f5:	eb 1b                	jmp    802412 <wait+0x3a>
	assert(envid != 0);
  8023f7:	68 75 35 80 00       	push   $0x803575
  8023fc:	68 6c 34 80 00       	push   $0x80346c
  802401:	6a 09                	push   $0x9
  802403:	68 80 35 80 00       	push   $0x803580
  802408:	e8 e7 dd ff ff       	call   8001f4 <_panic>
		sys_yield();
  80240d:	e8 6c e8 ff ff       	call   800c7e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802412:	8b 43 48             	mov    0x48(%ebx),%eax
  802415:	39 f0                	cmp    %esi,%eax
  802417:	75 07                	jne    802420 <wait+0x48>
  802419:	8b 43 54             	mov    0x54(%ebx),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	75 ed                	jne    80240d <wait+0x35>
}
  802420:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802423:	5b                   	pop    %ebx
  802424:	5e                   	pop    %esi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    

00802427 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80242d:	68 8b 35 80 00       	push   $0x80358b
  802432:	ff 75 0c             	pushl  0xc(%ebp)
  802435:	e8 71 e4 ff ff       	call   8008ab <strcpy>
	return 0;
}
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <devsock_close>:
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	53                   	push   %ebx
  802445:	83 ec 10             	sub    $0x10,%esp
  802448:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80244b:	53                   	push   %ebx
  80244c:	e8 67 07 00 00       	call   802bb8 <pageref>
  802451:	83 c4 10             	add    $0x10,%esp
		return 0;
  802454:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802459:	83 f8 01             	cmp    $0x1,%eax
  80245c:	74 07                	je     802465 <devsock_close+0x24>
}
  80245e:	89 d0                	mov    %edx,%eax
  802460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802463:	c9                   	leave  
  802464:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802465:	83 ec 0c             	sub    $0xc,%esp
  802468:	ff 73 0c             	pushl  0xc(%ebx)
  80246b:	e8 b9 02 00 00       	call   802729 <nsipc_close>
  802470:	89 c2                	mov    %eax,%edx
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	eb e7                	jmp    80245e <devsock_close+0x1d>

00802477 <devsock_write>:
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	ff 75 10             	pushl  0x10(%ebp)
  802482:	ff 75 0c             	pushl  0xc(%ebp)
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	ff 70 0c             	pushl  0xc(%eax)
  80248b:	e8 76 03 00 00       	call   802806 <nsipc_send>
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <devsock_read>:
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802498:	6a 00                	push   $0x0
  80249a:	ff 75 10             	pushl  0x10(%ebp)
  80249d:	ff 75 0c             	pushl  0xc(%ebp)
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	ff 70 0c             	pushl  0xc(%eax)
  8024a6:	e8 ef 02 00 00       	call   80279a <nsipc_recv>
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <fd2sockid>:
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024b3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	e8 0e ee ff ff       	call   8012cb <fd_lookup>
  8024bd:	83 c4 10             	add    $0x10,%esp
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	78 10                	js     8024d4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 0d 44 40 80 00    	mov    0x804044,%ecx
  8024cd:	39 08                	cmp    %ecx,(%eax)
  8024cf:	75 05                	jne    8024d6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8024d1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    
		return -E_NOT_SUPP;
  8024d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024db:	eb f7                	jmp    8024d4 <fd2sockid+0x27>

008024dd <alloc_sockfd>:
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	83 ec 1c             	sub    $0x1c,%esp
  8024e5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8024e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ea:	50                   	push   %eax
  8024eb:	e8 89 ed ff ff       	call   801279 <fd_alloc>
  8024f0:	89 c3                	mov    %eax,%ebx
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 43                	js     80253c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	68 07 04 00 00       	push   $0x407
  802501:	ff 75 f4             	pushl  -0xc(%ebp)
  802504:	6a 00                	push   $0x0
  802506:	e8 92 e7 ff ff       	call   800c9d <sys_page_alloc>
  80250b:	89 c3                	mov    %eax,%ebx
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	85 c0                	test   %eax,%eax
  802512:	78 28                	js     80253c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80251d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802529:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	50                   	push   %eax
  802530:	e8 1d ed ff ff       	call   801252 <fd2num>
  802535:	89 c3                	mov    %eax,%ebx
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	eb 0c                	jmp    802548 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	56                   	push   %esi
  802540:	e8 e4 01 00 00       	call   802729 <nsipc_close>
		return r;
  802545:	83 c4 10             	add    $0x10,%esp
}
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    

00802551 <accept>:
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	e8 4e ff ff ff       	call   8024ad <fd2sockid>
  80255f:	85 c0                	test   %eax,%eax
  802561:	78 1b                	js     80257e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	ff 75 10             	pushl  0x10(%ebp)
  802569:	ff 75 0c             	pushl  0xc(%ebp)
  80256c:	50                   	push   %eax
  80256d:	e8 0e 01 00 00       	call   802680 <nsipc_accept>
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	85 c0                	test   %eax,%eax
  802577:	78 05                	js     80257e <accept+0x2d>
	return alloc_sockfd(r);
  802579:	e8 5f ff ff ff       	call   8024dd <alloc_sockfd>
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <bind>:
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	e8 1f ff ff ff       	call   8024ad <fd2sockid>
  80258e:	85 c0                	test   %eax,%eax
  802590:	78 12                	js     8025a4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	ff 75 10             	pushl  0x10(%ebp)
  802598:	ff 75 0c             	pushl  0xc(%ebp)
  80259b:	50                   	push   %eax
  80259c:	e8 31 01 00 00       	call   8026d2 <nsipc_bind>
  8025a1:	83 c4 10             	add    $0x10,%esp
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <shutdown>:
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	e8 f9 fe ff ff       	call   8024ad <fd2sockid>
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	78 0f                	js     8025c7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8025b8:	83 ec 08             	sub    $0x8,%esp
  8025bb:	ff 75 0c             	pushl  0xc(%ebp)
  8025be:	50                   	push   %eax
  8025bf:	e8 43 01 00 00       	call   802707 <nsipc_shutdown>
  8025c4:	83 c4 10             	add    $0x10,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <connect>:
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	e8 d6 fe ff ff       	call   8024ad <fd2sockid>
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	78 12                	js     8025ed <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	ff 75 10             	pushl  0x10(%ebp)
  8025e1:	ff 75 0c             	pushl  0xc(%ebp)
  8025e4:	50                   	push   %eax
  8025e5:	e8 59 01 00 00       	call   802743 <nsipc_connect>
  8025ea:	83 c4 10             	add    $0x10,%esp
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <listen>:
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	e8 b0 fe ff ff       	call   8024ad <fd2sockid>
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	78 0f                	js     802610 <listen+0x21>
	return nsipc_listen(r, backlog);
  802601:	83 ec 08             	sub    $0x8,%esp
  802604:	ff 75 0c             	pushl  0xc(%ebp)
  802607:	50                   	push   %eax
  802608:	e8 6b 01 00 00       	call   802778 <nsipc_listen>
  80260d:	83 c4 10             	add    $0x10,%esp
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <socket>:

int
socket(int domain, int type, int protocol)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802618:	ff 75 10             	pushl  0x10(%ebp)
  80261b:	ff 75 0c             	pushl  0xc(%ebp)
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	e8 3e 02 00 00       	call   802864 <nsipc_socket>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 05                	js     802632 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80262d:	e8 ab fe ff ff       	call   8024dd <alloc_sockfd>
}
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	53                   	push   %ebx
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80263d:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802644:	74 26                	je     80266c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802646:	6a 07                	push   $0x7
  802648:	68 00 70 80 00       	push   $0x807000
  80264d:	53                   	push   %ebx
  80264e:	ff 35 04 50 80 00    	pushl  0x805004
  802654:	e8 ba 04 00 00       	call   802b13 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802659:	83 c4 0c             	add    $0xc,%esp
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	e8 39 04 00 00       	call   802aa0 <ipc_recv>
}
  802667:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80266c:	83 ec 0c             	sub    $0xc,%esp
  80266f:	6a 02                	push   $0x2
  802671:	e8 09 05 00 00       	call   802b7f <ipc_find_env>
  802676:	a3 04 50 80 00       	mov    %eax,0x805004
  80267b:	83 c4 10             	add    $0x10,%esp
  80267e:	eb c6                	jmp    802646 <nsipc+0x12>

00802680 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	56                   	push   %esi
  802684:	53                   	push   %ebx
  802685:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802690:	8b 06                	mov    (%esi),%eax
  802692:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802697:	b8 01 00 00 00       	mov    $0x1,%eax
  80269c:	e8 93 ff ff ff       	call   802634 <nsipc>
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	79 09                	jns    8026b0 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8026a7:	89 d8                	mov    %ebx,%eax
  8026a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	ff 35 10 70 80 00    	pushl  0x807010
  8026b9:	68 00 70 80 00       	push   $0x807000
  8026be:	ff 75 0c             	pushl  0xc(%ebp)
  8026c1:	e8 73 e3 ff ff       	call   800a39 <memmove>
		*addrlen = ret->ret_addrlen;
  8026c6:	a1 10 70 80 00       	mov    0x807010,%eax
  8026cb:	89 06                	mov    %eax,(%esi)
  8026cd:	83 c4 10             	add    $0x10,%esp
	return r;
  8026d0:	eb d5                	jmp    8026a7 <nsipc_accept+0x27>

008026d2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	53                   	push   %ebx
  8026d6:	83 ec 08             	sub    $0x8,%esp
  8026d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8026e4:	53                   	push   %ebx
  8026e5:	ff 75 0c             	pushl  0xc(%ebp)
  8026e8:	68 04 70 80 00       	push   $0x807004
  8026ed:	e8 47 e3 ff ff       	call   800a39 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8026f2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8026f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8026fd:	e8 32 ff ff ff       	call   802634 <nsipc>
}
  802702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802715:	8b 45 0c             	mov    0xc(%ebp),%eax
  802718:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80271d:	b8 03 00 00 00       	mov    $0x3,%eax
  802722:	e8 0d ff ff ff       	call   802634 <nsipc>
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <nsipc_close>:

int
nsipc_close(int s)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802737:	b8 04 00 00 00       	mov    $0x4,%eax
  80273c:	e8 f3 fe ff ff       	call   802634 <nsipc>
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
  802746:	53                   	push   %ebx
  802747:	83 ec 08             	sub    $0x8,%esp
  80274a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802755:	53                   	push   %ebx
  802756:	ff 75 0c             	pushl  0xc(%ebp)
  802759:	68 04 70 80 00       	push   $0x807004
  80275e:	e8 d6 e2 ff ff       	call   800a39 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802763:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802769:	b8 05 00 00 00       	mov    $0x5,%eax
  80276e:	e8 c1 fe ff ff       	call   802634 <nsipc>
}
  802773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802786:	8b 45 0c             	mov    0xc(%ebp),%eax
  802789:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80278e:	b8 06 00 00 00       	mov    $0x6,%eax
  802793:	e8 9c fe ff ff       	call   802634 <nsipc>
}
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	56                   	push   %esi
  80279e:	53                   	push   %ebx
  80279f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8027aa:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8027b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8027b3:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8027b8:	b8 07 00 00 00       	mov    $0x7,%eax
  8027bd:	e8 72 fe ff ff       	call   802634 <nsipc>
  8027c2:	89 c3                	mov    %eax,%ebx
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 1f                	js     8027e7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8027c8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8027cd:	7f 21                	jg     8027f0 <nsipc_recv+0x56>
  8027cf:	39 c6                	cmp    %eax,%esi
  8027d1:	7c 1d                	jl     8027f0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	50                   	push   %eax
  8027d7:	68 00 70 80 00       	push   $0x807000
  8027dc:	ff 75 0c             	pushl  0xc(%ebp)
  8027df:	e8 55 e2 ff ff       	call   800a39 <memmove>
  8027e4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8027e7:	89 d8                	mov    %ebx,%eax
  8027e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8027f0:	68 97 35 80 00       	push   $0x803597
  8027f5:	68 6c 34 80 00       	push   $0x80346c
  8027fa:	6a 62                	push   $0x62
  8027fc:	68 ac 35 80 00       	push   $0x8035ac
  802801:	e8 ee d9 ff ff       	call   8001f4 <_panic>

00802806 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	53                   	push   %ebx
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802818:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80281e:	7f 2e                	jg     80284e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	53                   	push   %ebx
  802824:	ff 75 0c             	pushl  0xc(%ebp)
  802827:	68 0c 70 80 00       	push   $0x80700c
  80282c:	e8 08 e2 ff ff       	call   800a39 <memmove>
	nsipcbuf.send.req_size = size;
  802831:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802837:	8b 45 14             	mov    0x14(%ebp),%eax
  80283a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80283f:	b8 08 00 00 00       	mov    $0x8,%eax
  802844:	e8 eb fd ff ff       	call   802634 <nsipc>
}
  802849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284c:	c9                   	leave  
  80284d:	c3                   	ret    
	assert(size < 1600);
  80284e:	68 b8 35 80 00       	push   $0x8035b8
  802853:	68 6c 34 80 00       	push   $0x80346c
  802858:	6a 6d                	push   $0x6d
  80285a:	68 ac 35 80 00       	push   $0x8035ac
  80285f:	e8 90 d9 ff ff       	call   8001f4 <_panic>

00802864 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80287a:	8b 45 10             	mov    0x10(%ebp),%eax
  80287d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802882:	b8 09 00 00 00       	mov    $0x9,%eax
  802887:	e8 a8 fd ff ff       	call   802634 <nsipc>
}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	c3                   	ret    

00802894 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80289a:	68 c4 35 80 00       	push   $0x8035c4
  80289f:	ff 75 0c             	pushl  0xc(%ebp)
  8028a2:	e8 04 e0 ff ff       	call   8008ab <strcpy>
	return 0;
}
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <devcons_write>:
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8028ba:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8028bf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8028c5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028c8:	73 31                	jae    8028fb <devcons_write+0x4d>
		m = n - tot;
  8028ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028cd:	29 f3                	sub    %esi,%ebx
  8028cf:	83 fb 7f             	cmp    $0x7f,%ebx
  8028d2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8028d7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	53                   	push   %ebx
  8028de:	89 f0                	mov    %esi,%eax
  8028e0:	03 45 0c             	add    0xc(%ebp),%eax
  8028e3:	50                   	push   %eax
  8028e4:	57                   	push   %edi
  8028e5:	e8 4f e1 ff ff       	call   800a39 <memmove>
		sys_cputs(buf, m);
  8028ea:	83 c4 08             	add    $0x8,%esp
  8028ed:	53                   	push   %ebx
  8028ee:	57                   	push   %edi
  8028ef:	e8 ed e2 ff ff       	call   800be1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8028f4:	01 de                	add    %ebx,%esi
  8028f6:	83 c4 10             	add    $0x10,%esp
  8028f9:	eb ca                	jmp    8028c5 <devcons_write+0x17>
}
  8028fb:	89 f0                	mov    %esi,%eax
  8028fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802900:	5b                   	pop    %ebx
  802901:	5e                   	pop    %esi
  802902:	5f                   	pop    %edi
  802903:	5d                   	pop    %ebp
  802904:	c3                   	ret    

00802905 <devcons_read>:
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 08             	sub    $0x8,%esp
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802910:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802914:	74 21                	je     802937 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802916:	e8 e4 e2 ff ff       	call   800bff <sys_cgetc>
  80291b:	85 c0                	test   %eax,%eax
  80291d:	75 07                	jne    802926 <devcons_read+0x21>
		sys_yield();
  80291f:	e8 5a e3 ff ff       	call   800c7e <sys_yield>
  802924:	eb f0                	jmp    802916 <devcons_read+0x11>
	if (c < 0)
  802926:	78 0f                	js     802937 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802928:	83 f8 04             	cmp    $0x4,%eax
  80292b:	74 0c                	je     802939 <devcons_read+0x34>
	*(char*)vbuf = c;
  80292d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802930:	88 02                	mov    %al,(%edx)
	return 1;
  802932:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    
		return 0;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
  80293e:	eb f7                	jmp    802937 <devcons_read+0x32>

00802940 <cputchar>:
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80294c:	6a 01                	push   $0x1
  80294e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802951:	50                   	push   %eax
  802952:	e8 8a e2 ff ff       	call   800be1 <sys_cputs>
}
  802957:	83 c4 10             	add    $0x10,%esp
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <getchar>:
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
  80295f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802962:	6a 01                	push   $0x1
  802964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802967:	50                   	push   %eax
  802968:	6a 00                	push   $0x0
  80296a:	e8 cc eb ff ff       	call   80153b <read>
	if (r < 0)
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	85 c0                	test   %eax,%eax
  802974:	78 06                	js     80297c <getchar+0x20>
	if (r < 1)
  802976:	74 06                	je     80297e <getchar+0x22>
	return c;
  802978:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80297c:	c9                   	leave  
  80297d:	c3                   	ret    
		return -E_EOF;
  80297e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802983:	eb f7                	jmp    80297c <getchar+0x20>

00802985 <iscons>:
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80298b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80298e:	50                   	push   %eax
  80298f:	ff 75 08             	pushl  0x8(%ebp)
  802992:	e8 34 e9 ff ff       	call   8012cb <fd_lookup>
  802997:	83 c4 10             	add    $0x10,%esp
  80299a:	85 c0                	test   %eax,%eax
  80299c:	78 11                	js     8029af <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8029a7:	39 10                	cmp    %edx,(%eax)
  8029a9:	0f 94 c0             	sete   %al
  8029ac:	0f b6 c0             	movzbl %al,%eax
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <opencons>:
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8029b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ba:	50                   	push   %eax
  8029bb:	e8 b9 e8 ff ff       	call   801279 <fd_alloc>
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	78 3a                	js     802a01 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 07 04 00 00       	push   $0x407
  8029cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8029d2:	6a 00                	push   $0x0
  8029d4:	e8 c4 e2 ff ff       	call   800c9d <sys_page_alloc>
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	78 21                	js     802a01 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8029e9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029f5:	83 ec 0c             	sub    $0xc,%esp
  8029f8:	50                   	push   %eax
  8029f9:	e8 54 e8 ff ff       	call   801252 <fd2num>
  8029fe:	83 c4 10             	add    $0x10,%esp
}
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a09:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a10:	74 0a                	je     802a1c <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802a1c:	a1 08 50 80 00       	mov    0x805008,%eax
  802a21:	8b 40 48             	mov    0x48(%eax),%eax
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	6a 07                	push   $0x7
  802a29:	68 00 f0 bf ee       	push   $0xeebff000
  802a2e:	50                   	push   %eax
  802a2f:	e8 69 e2 ff ff       	call   800c9d <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802a34:	83 c4 10             	add    $0x10,%esp
  802a37:	85 c0                	test   %eax,%eax
  802a39:	78 2c                	js     802a67 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802a3b:	e8 1f e2 ff ff       	call   800c5f <sys_getenvid>
  802a40:	83 ec 08             	sub    $0x8,%esp
  802a43:	68 79 2a 80 00       	push   $0x802a79
  802a48:	50                   	push   %eax
  802a49:	e8 9a e3 ff ff       	call   800de8 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802a4e:	83 c4 10             	add    $0x10,%esp
  802a51:	85 c0                	test   %eax,%eax
  802a53:	79 bd                	jns    802a12 <set_pgfault_handler+0xf>
  802a55:	50                   	push   %eax
  802a56:	68 d0 35 80 00       	push   $0x8035d0
  802a5b:	6a 23                	push   $0x23
  802a5d:	68 e8 35 80 00       	push   $0x8035e8
  802a62:	e8 8d d7 ff ff       	call   8001f4 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802a67:	50                   	push   %eax
  802a68:	68 d0 35 80 00       	push   $0x8035d0
  802a6d:	6a 21                	push   $0x21
  802a6f:	68 e8 35 80 00       	push   $0x8035e8
  802a74:	e8 7b d7 ff ff       	call   8001f4 <_panic>

00802a79 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a79:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a7a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a7f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a81:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802a84:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802a88:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802a8b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802a8f:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802a93:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802a96:	83 c4 08             	add    $0x8,%esp
	popal
  802a99:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802a9a:	83 c4 04             	add    $0x4,%esp
	popfl
  802a9d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a9e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a9f:	c3                   	ret    

00802aa0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
  802aa3:	56                   	push   %esi
  802aa4:	53                   	push   %ebx
  802aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  802aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 4f                	je     802b01 <ipc_recv+0x61>
  802ab2:	83 ec 0c             	sub    $0xc,%esp
  802ab5:	50                   	push   %eax
  802ab6:	e8 92 e3 ff ff       	call   800e4d <sys_ipc_recv>
  802abb:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802abe:	85 f6                	test   %esi,%esi
  802ac0:	74 14                	je     802ad6 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	75 09                	jne    802ad4 <ipc_recv+0x34>
  802acb:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802ad1:	8b 52 74             	mov    0x74(%edx),%edx
  802ad4:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802ad6:	85 db                	test   %ebx,%ebx
  802ad8:	74 14                	je     802aee <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802ada:	ba 00 00 00 00       	mov    $0x0,%edx
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	75 09                	jne    802aec <ipc_recv+0x4c>
  802ae3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802ae9:	8b 52 78             	mov    0x78(%edx),%edx
  802aec:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802aee:	85 c0                	test   %eax,%eax
  802af0:	75 08                	jne    802afa <ipc_recv+0x5a>
  802af2:	a1 08 50 80 00       	mov    0x805008,%eax
  802af7:	8b 40 70             	mov    0x70(%eax),%eax
}
  802afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802b01:	83 ec 0c             	sub    $0xc,%esp
  802b04:	68 00 00 c0 ee       	push   $0xeec00000
  802b09:	e8 3f e3 ff ff       	call   800e4d <sys_ipc_recv>
  802b0e:	83 c4 10             	add    $0x10,%esp
  802b11:	eb ab                	jmp    802abe <ipc_recv+0x1e>

00802b13 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	57                   	push   %edi
  802b17:	56                   	push   %esi
  802b18:	53                   	push   %ebx
  802b19:	83 ec 0c             	sub    $0xc,%esp
  802b1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b1f:	8b 75 10             	mov    0x10(%ebp),%esi
  802b22:	eb 20                	jmp    802b44 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802b24:	6a 00                	push   $0x0
  802b26:	68 00 00 c0 ee       	push   $0xeec00000
  802b2b:	ff 75 0c             	pushl  0xc(%ebp)
  802b2e:	57                   	push   %edi
  802b2f:	e8 f6 e2 ff ff       	call   800e2a <sys_ipc_try_send>
  802b34:	89 c3                	mov    %eax,%ebx
  802b36:	83 c4 10             	add    $0x10,%esp
  802b39:	eb 1f                	jmp    802b5a <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802b3b:	e8 3e e1 ff ff       	call   800c7e <sys_yield>
	while(retval != 0) {
  802b40:	85 db                	test   %ebx,%ebx
  802b42:	74 33                	je     802b77 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802b44:	85 f6                	test   %esi,%esi
  802b46:	74 dc                	je     802b24 <ipc_send+0x11>
  802b48:	ff 75 14             	pushl  0x14(%ebp)
  802b4b:	56                   	push   %esi
  802b4c:	ff 75 0c             	pushl  0xc(%ebp)
  802b4f:	57                   	push   %edi
  802b50:	e8 d5 e2 ff ff       	call   800e2a <sys_ipc_try_send>
  802b55:	89 c3                	mov    %eax,%ebx
  802b57:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802b5a:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802b5d:	74 dc                	je     802b3b <ipc_send+0x28>
  802b5f:	85 db                	test   %ebx,%ebx
  802b61:	74 d8                	je     802b3b <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 f8 35 80 00       	push   $0x8035f8
  802b6b:	6a 35                	push   $0x35
  802b6d:	68 28 36 80 00       	push   $0x803628
  802b72:	e8 7d d6 ff ff       	call   8001f4 <_panic>
	}
}
  802b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b7a:	5b                   	pop    %ebx
  802b7b:	5e                   	pop    %esi
  802b7c:	5f                   	pop    %edi
  802b7d:	5d                   	pop    %ebp
  802b7e:	c3                   	ret    

00802b7f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b7f:	55                   	push   %ebp
  802b80:	89 e5                	mov    %esp,%ebp
  802b82:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b85:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b8a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b8d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b93:	8b 52 50             	mov    0x50(%edx),%edx
  802b96:	39 ca                	cmp    %ecx,%edx
  802b98:	74 11                	je     802bab <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802b9a:	83 c0 01             	add    $0x1,%eax
  802b9d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ba2:	75 e6                	jne    802b8a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba9:	eb 0b                	jmp    802bb6 <ipc_find_env+0x37>
			return envs[i].env_id;
  802bab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802bb3:	8b 40 48             	mov    0x48(%eax),%eax
}
  802bb6:	5d                   	pop    %ebp
  802bb7:	c3                   	ret    

00802bb8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
  802bbb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bbe:	89 d0                	mov    %edx,%eax
  802bc0:	c1 e8 16             	shr    $0x16,%eax
  802bc3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802bcf:	f6 c1 01             	test   $0x1,%cl
  802bd2:	74 1d                	je     802bf1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802bd4:	c1 ea 0c             	shr    $0xc,%edx
  802bd7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802bde:	f6 c2 01             	test   $0x1,%dl
  802be1:	74 0e                	je     802bf1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802be3:	c1 ea 0c             	shr    $0xc,%edx
  802be6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802bed:	ef 
  802bee:	0f b7 c0             	movzwl %ax,%eax
}
  802bf1:	5d                   	pop    %ebp
  802bf2:	c3                   	ret    
  802bf3:	66 90                	xchg   %ax,%ax
  802bf5:	66 90                	xchg   %ax,%ax
  802bf7:	66 90                	xchg   %ax,%ax
  802bf9:	66 90                	xchg   %ax,%ax
  802bfb:	66 90                	xchg   %ax,%ax
  802bfd:	66 90                	xchg   %ax,%ax
  802bff:	90                   	nop

00802c00 <__udivdi3>:
  802c00:	f3 0f 1e fb          	endbr32 
  802c04:	55                   	push   %ebp
  802c05:	57                   	push   %edi
  802c06:	56                   	push   %esi
  802c07:	53                   	push   %ebx
  802c08:	83 ec 1c             	sub    $0x1c,%esp
  802c0b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802c0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c1b:	85 d2                	test   %edx,%edx
  802c1d:	75 49                	jne    802c68 <__udivdi3+0x68>
  802c1f:	39 f3                	cmp    %esi,%ebx
  802c21:	76 15                	jbe    802c38 <__udivdi3+0x38>
  802c23:	31 ff                	xor    %edi,%edi
  802c25:	89 e8                	mov    %ebp,%eax
  802c27:	89 f2                	mov    %esi,%edx
  802c29:	f7 f3                	div    %ebx
  802c2b:	89 fa                	mov    %edi,%edx
  802c2d:	83 c4 1c             	add    $0x1c,%esp
  802c30:	5b                   	pop    %ebx
  802c31:	5e                   	pop    %esi
  802c32:	5f                   	pop    %edi
  802c33:	5d                   	pop    %ebp
  802c34:	c3                   	ret    
  802c35:	8d 76 00             	lea    0x0(%esi),%esi
  802c38:	89 d9                	mov    %ebx,%ecx
  802c3a:	85 db                	test   %ebx,%ebx
  802c3c:	75 0b                	jne    802c49 <__udivdi3+0x49>
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	31 d2                	xor    %edx,%edx
  802c45:	f7 f3                	div    %ebx
  802c47:	89 c1                	mov    %eax,%ecx
  802c49:	31 d2                	xor    %edx,%edx
  802c4b:	89 f0                	mov    %esi,%eax
  802c4d:	f7 f1                	div    %ecx
  802c4f:	89 c6                	mov    %eax,%esi
  802c51:	89 e8                	mov    %ebp,%eax
  802c53:	89 f7                	mov    %esi,%edi
  802c55:	f7 f1                	div    %ecx
  802c57:	89 fa                	mov    %edi,%edx
  802c59:	83 c4 1c             	add    $0x1c,%esp
  802c5c:	5b                   	pop    %ebx
  802c5d:	5e                   	pop    %esi
  802c5e:	5f                   	pop    %edi
  802c5f:	5d                   	pop    %ebp
  802c60:	c3                   	ret    
  802c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c68:	39 f2                	cmp    %esi,%edx
  802c6a:	77 1c                	ja     802c88 <__udivdi3+0x88>
  802c6c:	0f bd fa             	bsr    %edx,%edi
  802c6f:	83 f7 1f             	xor    $0x1f,%edi
  802c72:	75 2c                	jne    802ca0 <__udivdi3+0xa0>
  802c74:	39 f2                	cmp    %esi,%edx
  802c76:	72 06                	jb     802c7e <__udivdi3+0x7e>
  802c78:	31 c0                	xor    %eax,%eax
  802c7a:	39 eb                	cmp    %ebp,%ebx
  802c7c:	77 ad                	ja     802c2b <__udivdi3+0x2b>
  802c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c83:	eb a6                	jmp    802c2b <__udivdi3+0x2b>
  802c85:	8d 76 00             	lea    0x0(%esi),%esi
  802c88:	31 ff                	xor    %edi,%edi
  802c8a:	31 c0                	xor    %eax,%eax
  802c8c:	89 fa                	mov    %edi,%edx
  802c8e:	83 c4 1c             	add    $0x1c,%esp
  802c91:	5b                   	pop    %ebx
  802c92:	5e                   	pop    %esi
  802c93:	5f                   	pop    %edi
  802c94:	5d                   	pop    %ebp
  802c95:	c3                   	ret    
  802c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ca0:	89 f9                	mov    %edi,%ecx
  802ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ca7:	29 f8                	sub    %edi,%eax
  802ca9:	d3 e2                	shl    %cl,%edx
  802cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  802caf:	89 c1                	mov    %eax,%ecx
  802cb1:	89 da                	mov    %ebx,%edx
  802cb3:	d3 ea                	shr    %cl,%edx
  802cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cb9:	09 d1                	or     %edx,%ecx
  802cbb:	89 f2                	mov    %esi,%edx
  802cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc1:	89 f9                	mov    %edi,%ecx
  802cc3:	d3 e3                	shl    %cl,%ebx
  802cc5:	89 c1                	mov    %eax,%ecx
  802cc7:	d3 ea                	shr    %cl,%edx
  802cc9:	89 f9                	mov    %edi,%ecx
  802ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802ccf:	89 eb                	mov    %ebp,%ebx
  802cd1:	d3 e6                	shl    %cl,%esi
  802cd3:	89 c1                	mov    %eax,%ecx
  802cd5:	d3 eb                	shr    %cl,%ebx
  802cd7:	09 de                	or     %ebx,%esi
  802cd9:	89 f0                	mov    %esi,%eax
  802cdb:	f7 74 24 08          	divl   0x8(%esp)
  802cdf:	89 d6                	mov    %edx,%esi
  802ce1:	89 c3                	mov    %eax,%ebx
  802ce3:	f7 64 24 0c          	mull   0xc(%esp)
  802ce7:	39 d6                	cmp    %edx,%esi
  802ce9:	72 15                	jb     802d00 <__udivdi3+0x100>
  802ceb:	89 f9                	mov    %edi,%ecx
  802ced:	d3 e5                	shl    %cl,%ebp
  802cef:	39 c5                	cmp    %eax,%ebp
  802cf1:	73 04                	jae    802cf7 <__udivdi3+0xf7>
  802cf3:	39 d6                	cmp    %edx,%esi
  802cf5:	74 09                	je     802d00 <__udivdi3+0x100>
  802cf7:	89 d8                	mov    %ebx,%eax
  802cf9:	31 ff                	xor    %edi,%edi
  802cfb:	e9 2b ff ff ff       	jmp    802c2b <__udivdi3+0x2b>
  802d00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d03:	31 ff                	xor    %edi,%edi
  802d05:	e9 21 ff ff ff       	jmp    802c2b <__udivdi3+0x2b>
  802d0a:	66 90                	xchg   %ax,%ax
  802d0c:	66 90                	xchg   %ax,%ax
  802d0e:	66 90                	xchg   %ax,%ax

00802d10 <__umoddi3>:
  802d10:	f3 0f 1e fb          	endbr32 
  802d14:	55                   	push   %ebp
  802d15:	57                   	push   %edi
  802d16:	56                   	push   %esi
  802d17:	53                   	push   %ebx
  802d18:	83 ec 1c             	sub    $0x1c,%esp
  802d1b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d23:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d2b:	89 da                	mov    %ebx,%edx
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	75 3f                	jne    802d70 <__umoddi3+0x60>
  802d31:	39 df                	cmp    %ebx,%edi
  802d33:	76 13                	jbe    802d48 <__umoddi3+0x38>
  802d35:	89 f0                	mov    %esi,%eax
  802d37:	f7 f7                	div    %edi
  802d39:	89 d0                	mov    %edx,%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	83 c4 1c             	add    $0x1c,%esp
  802d40:	5b                   	pop    %ebx
  802d41:	5e                   	pop    %esi
  802d42:	5f                   	pop    %edi
  802d43:	5d                   	pop    %ebp
  802d44:	c3                   	ret    
  802d45:	8d 76 00             	lea    0x0(%esi),%esi
  802d48:	89 fd                	mov    %edi,%ebp
  802d4a:	85 ff                	test   %edi,%edi
  802d4c:	75 0b                	jne    802d59 <__umoddi3+0x49>
  802d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d53:	31 d2                	xor    %edx,%edx
  802d55:	f7 f7                	div    %edi
  802d57:	89 c5                	mov    %eax,%ebp
  802d59:	89 d8                	mov    %ebx,%eax
  802d5b:	31 d2                	xor    %edx,%edx
  802d5d:	f7 f5                	div    %ebp
  802d5f:	89 f0                	mov    %esi,%eax
  802d61:	f7 f5                	div    %ebp
  802d63:	89 d0                	mov    %edx,%eax
  802d65:	eb d4                	jmp    802d3b <__umoddi3+0x2b>
  802d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d6e:	66 90                	xchg   %ax,%ax
  802d70:	89 f1                	mov    %esi,%ecx
  802d72:	39 d8                	cmp    %ebx,%eax
  802d74:	76 0a                	jbe    802d80 <__umoddi3+0x70>
  802d76:	89 f0                	mov    %esi,%eax
  802d78:	83 c4 1c             	add    $0x1c,%esp
  802d7b:	5b                   	pop    %ebx
  802d7c:	5e                   	pop    %esi
  802d7d:	5f                   	pop    %edi
  802d7e:	5d                   	pop    %ebp
  802d7f:	c3                   	ret    
  802d80:	0f bd e8             	bsr    %eax,%ebp
  802d83:	83 f5 1f             	xor    $0x1f,%ebp
  802d86:	75 20                	jne    802da8 <__umoddi3+0x98>
  802d88:	39 d8                	cmp    %ebx,%eax
  802d8a:	0f 82 b0 00 00 00    	jb     802e40 <__umoddi3+0x130>
  802d90:	39 f7                	cmp    %esi,%edi
  802d92:	0f 86 a8 00 00 00    	jbe    802e40 <__umoddi3+0x130>
  802d98:	89 c8                	mov    %ecx,%eax
  802d9a:	83 c4 1c             	add    $0x1c,%esp
  802d9d:	5b                   	pop    %ebx
  802d9e:	5e                   	pop    %esi
  802d9f:	5f                   	pop    %edi
  802da0:	5d                   	pop    %ebp
  802da1:	c3                   	ret    
  802da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802da8:	89 e9                	mov    %ebp,%ecx
  802daa:	ba 20 00 00 00       	mov    $0x20,%edx
  802daf:	29 ea                	sub    %ebp,%edx
  802db1:	d3 e0                	shl    %cl,%eax
  802db3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802db7:	89 d1                	mov    %edx,%ecx
  802db9:	89 f8                	mov    %edi,%eax
  802dbb:	d3 e8                	shr    %cl,%eax
  802dbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802dc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802dc5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802dc9:	09 c1                	or     %eax,%ecx
  802dcb:	89 d8                	mov    %ebx,%eax
  802dcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dd1:	89 e9                	mov    %ebp,%ecx
  802dd3:	d3 e7                	shl    %cl,%edi
  802dd5:	89 d1                	mov    %edx,%ecx
  802dd7:	d3 e8                	shr    %cl,%eax
  802dd9:	89 e9                	mov    %ebp,%ecx
  802ddb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ddf:	d3 e3                	shl    %cl,%ebx
  802de1:	89 c7                	mov    %eax,%edi
  802de3:	89 d1                	mov    %edx,%ecx
  802de5:	89 f0                	mov    %esi,%eax
  802de7:	d3 e8                	shr    %cl,%eax
  802de9:	89 e9                	mov    %ebp,%ecx
  802deb:	89 fa                	mov    %edi,%edx
  802ded:	d3 e6                	shl    %cl,%esi
  802def:	09 d8                	or     %ebx,%eax
  802df1:	f7 74 24 08          	divl   0x8(%esp)
  802df5:	89 d1                	mov    %edx,%ecx
  802df7:	89 f3                	mov    %esi,%ebx
  802df9:	f7 64 24 0c          	mull   0xc(%esp)
  802dfd:	89 c6                	mov    %eax,%esi
  802dff:	89 d7                	mov    %edx,%edi
  802e01:	39 d1                	cmp    %edx,%ecx
  802e03:	72 06                	jb     802e0b <__umoddi3+0xfb>
  802e05:	75 10                	jne    802e17 <__umoddi3+0x107>
  802e07:	39 c3                	cmp    %eax,%ebx
  802e09:	73 0c                	jae    802e17 <__umoddi3+0x107>
  802e0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802e0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802e13:	89 d7                	mov    %edx,%edi
  802e15:	89 c6                	mov    %eax,%esi
  802e17:	89 ca                	mov    %ecx,%edx
  802e19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e1e:	29 f3                	sub    %esi,%ebx
  802e20:	19 fa                	sbb    %edi,%edx
  802e22:	89 d0                	mov    %edx,%eax
  802e24:	d3 e0                	shl    %cl,%eax
  802e26:	89 e9                	mov    %ebp,%ecx
  802e28:	d3 eb                	shr    %cl,%ebx
  802e2a:	d3 ea                	shr    %cl,%edx
  802e2c:	09 d8                	or     %ebx,%eax
  802e2e:	83 c4 1c             	add    $0x1c,%esp
  802e31:	5b                   	pop    %ebx
  802e32:	5e                   	pop    %esi
  802e33:	5f                   	pop    %edi
  802e34:	5d                   	pop    %ebp
  802e35:	c3                   	ret    
  802e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e3d:	8d 76 00             	lea    0x0(%esi),%esi
  802e40:	89 da                	mov    %ebx,%edx
  802e42:	29 fe                	sub    %edi,%esi
  802e44:	19 c2                	sbb    %eax,%edx
  802e46:	89 f1                	mov    %esi,%ecx
  802e48:	89 c8                	mov    %ecx,%eax
  802e4a:	e9 4b ff ff ff       	jmp    802d9a <__umoddi3+0x8a>
