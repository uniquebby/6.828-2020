
obj/user/cat.debug：     文件格式 elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 e1 10 00 00       	call   80112f <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 94 11 00 00       	call   8011fb <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 60 24 80 00       	push   $0x802460
  80007a:	6a 0d                	push   $0xd
  80007c:	68 7b 24 80 00       	push   $0x80247b
  800081:	e8 07 01 00 00       	call   80018d <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 86 24 80 00       	push   $0x802486
  80009b:	6a 0f                	push   $0xf
  80009d:	68 7b 24 80 00       	push   $0x80247b
  8000a2:	e8 e6 00 00 00       	call   80018d <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 9b 	movl   $0x80249b,0x803000
  8000ba:	24 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 9f 24 80 00       	push   $0x80249f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 a7 24 80 00       	push   $0x8024a7
  8000ee:	e8 8a 16 00 00       	call   80177d <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 cf 14 00 00       	call   8015da <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 c9 0e 00 00       	call   800ff1 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800138:	e8 bb 0a 00 00       	call   800bf8 <sys_getenvid>
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800145:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014a:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014f:	85 db                	test   %ebx,%ebx
  800151:	7e 07                	jle    80015a <libmain+0x2d>
		binaryname = argv[0];
  800153:	8b 06                	mov    (%esi),%eax
  800155:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	e8 43 ff ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  800164:	e8 0a 00 00 00       	call   800173 <exit>
}
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800179:	e8 a0 0e 00 00       	call   80101e <close_all>
	sys_env_destroy(0);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	6a 00                	push   $0x0
  800183:	e8 2f 0a 00 00       	call   800bb7 <sys_env_destroy>
}
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800192:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800195:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019b:	e8 58 0a 00 00       	call   800bf8 <sys_getenvid>
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	56                   	push   %esi
  8001aa:	50                   	push   %eax
  8001ab:	68 c4 24 80 00       	push   $0x8024c4
  8001b0:	e8 b3 00 00 00       	call   800268 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b5:	83 c4 18             	add    $0x18,%esp
  8001b8:	53                   	push   %ebx
  8001b9:	ff 75 10             	pushl  0x10(%ebp)
  8001bc:	e8 56 00 00 00       	call   800217 <vcprintf>
	cprintf("\n");
  8001c1:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  8001c8:	e8 9b 00 00 00       	call   800268 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d0:	cc                   	int3   
  8001d1:	eb fd                	jmp    8001d0 <_panic+0x43>

008001d3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	53                   	push   %ebx
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001dd:	8b 13                	mov    (%ebx),%edx
  8001df:	8d 42 01             	lea    0x1(%edx),%eax
  8001e2:	89 03                	mov    %eax,(%ebx)
  8001e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001eb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f0:	74 09                	je     8001fb <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f9:	c9                   	leave  
  8001fa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	68 ff 00 00 00       	push   $0xff
  800203:	8d 43 08             	lea    0x8(%ebx),%eax
  800206:	50                   	push   %eax
  800207:	e8 6e 09 00 00       	call   800b7a <sys_cputs>
		b->idx = 0;
  80020c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	eb db                	jmp    8001f2 <putch+0x1f>

00800217 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800220:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800227:	00 00 00 
	b.cnt = 0;
  80022a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800231:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800240:	50                   	push   %eax
  800241:	68 d3 01 80 00       	push   $0x8001d3
  800246:	e8 19 01 00 00       	call   800364 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024b:	83 c4 08             	add    $0x8,%esp
  80024e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800254:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025a:	50                   	push   %eax
  80025b:	e8 1a 09 00 00       	call   800b7a <sys_cputs>

	return b.cnt;
}
  800260:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800271:	50                   	push   %eax
  800272:	ff 75 08             	pushl  0x8(%ebp)
  800275:	e8 9d ff ff ff       	call   800217 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	57                   	push   %edi
  800280:	56                   	push   %esi
  800281:	53                   	push   %ebx
  800282:	83 ec 1c             	sub    $0x1c,%esp
  800285:	89 c7                	mov    %eax,%edi
  800287:	89 d6                	mov    %edx,%esi
  800289:	8b 45 08             	mov    0x8(%ebp),%eax
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800292:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800295:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002a6:	89 d0                	mov    %edx,%eax
  8002a8:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8002ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ae:	73 15                	jae    8002c5 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b0:	83 eb 01             	sub    $0x1,%ebx
  8002b3:	85 db                	test   %ebx,%ebx
  8002b5:	7e 43                	jle    8002fa <printnum+0x7e>
			putch(padc, putdat);
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	56                   	push   %esi
  8002bb:	ff 75 18             	pushl  0x18(%ebp)
  8002be:	ff d7                	call   *%edi
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	eb eb                	jmp    8002b0 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	ff 75 18             	pushl  0x18(%ebp)
  8002cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002d1:	53                   	push   %ebx
  8002d2:	ff 75 10             	pushl  0x10(%ebp)
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002db:	ff 75 e0             	pushl  -0x20(%ebp)
  8002de:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e4:	e8 27 1f 00 00       	call   802210 <__udivdi3>
  8002e9:	83 c4 18             	add    $0x18,%esp
  8002ec:	52                   	push   %edx
  8002ed:	50                   	push   %eax
  8002ee:	89 f2                	mov    %esi,%edx
  8002f0:	89 f8                	mov    %edi,%eax
  8002f2:	e8 85 ff ff ff       	call   80027c <printnum>
  8002f7:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	56                   	push   %esi
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	ff 75 e4             	pushl  -0x1c(%ebp)
  800304:	ff 75 e0             	pushl  -0x20(%ebp)
  800307:	ff 75 dc             	pushl  -0x24(%ebp)
  80030a:	ff 75 d8             	pushl  -0x28(%ebp)
  80030d:	e8 0e 20 00 00       	call   802320 <__umoddi3>
  800312:	83 c4 14             	add    $0x14,%esp
  800315:	0f be 80 e7 24 80 00 	movsbl 0x8024e7(%eax),%eax
  80031c:	50                   	push   %eax
  80031d:	ff d7                	call   *%edi
}
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800325:	5b                   	pop    %ebx
  800326:	5e                   	pop    %esi
  800327:	5f                   	pop    %edi
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    

0080032a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800330:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800334:	8b 10                	mov    (%eax),%edx
  800336:	3b 50 04             	cmp    0x4(%eax),%edx
  800339:	73 0a                	jae    800345 <sprintputch+0x1b>
		*b->buf++ = ch;
  80033b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	88 02                	mov    %al,(%edx)
}
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <printfmt>:
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80034d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800350:	50                   	push   %eax
  800351:	ff 75 10             	pushl  0x10(%ebp)
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	e8 05 00 00 00       	call   800364 <vprintfmt>
}
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <vprintfmt>:
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	57                   	push   %edi
  800368:	56                   	push   %esi
  800369:	53                   	push   %ebx
  80036a:	83 ec 3c             	sub    $0x3c,%esp
  80036d:	8b 75 08             	mov    0x8(%ebp),%esi
  800370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800373:	8b 7d 10             	mov    0x10(%ebp),%edi
  800376:	eb 0a                	jmp    800382 <vprintfmt+0x1e>
			putch(ch, putdat);
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	53                   	push   %ebx
  80037c:	50                   	push   %eax
  80037d:	ff d6                	call   *%esi
  80037f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800382:	83 c7 01             	add    $0x1,%edi
  800385:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800389:	83 f8 25             	cmp    $0x25,%eax
  80038c:	74 0c                	je     80039a <vprintfmt+0x36>
			if (ch == '\0')
  80038e:	85 c0                	test   %eax,%eax
  800390:	75 e6                	jne    800378 <vprintfmt+0x14>
}
  800392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    
		padc = ' ';
  80039a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80039e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8d 47 01             	lea    0x1(%edi),%eax
  8003bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003be:	0f b6 17             	movzbl (%edi),%edx
  8003c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003c4:	3c 55                	cmp    $0x55,%al
  8003c6:	0f 87 ba 03 00 00    	ja     800786 <vprintfmt+0x422>
  8003cc:	0f b6 c0             	movzbl %al,%eax
  8003cf:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003d9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003dd:	eb d9                	jmp    8003b8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003e6:	eb d0                	jmp    8003b8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	0f b6 d2             	movzbl %dl,%edx
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800400:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800403:	83 f9 09             	cmp    $0x9,%ecx
  800406:	77 55                	ja     80045d <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800408:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80040b:	eb e9                	jmp    8003f6 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 40 04             	lea    0x4(%eax),%eax
  80041b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800421:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800425:	79 91                	jns    8003b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800427:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800434:	eb 82                	jmp    8003b8 <vprintfmt+0x54>
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	85 c0                	test   %eax,%eax
  80043b:	ba 00 00 00 00       	mov    $0x0,%edx
  800440:	0f 49 d0             	cmovns %eax,%edx
  800443:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800449:	e9 6a ff ff ff       	jmp    8003b8 <vprintfmt+0x54>
  80044e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800451:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800458:	e9 5b ff ff ff       	jmp    8003b8 <vprintfmt+0x54>
  80045d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800460:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800463:	eb bc                	jmp    800421 <vprintfmt+0xbd>
			lflag++;
  800465:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80046b:	e9 48 ff ff ff       	jmp    8003b8 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8d 78 04             	lea    0x4(%eax),%edi
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	53                   	push   %ebx
  80047a:	ff 30                	pushl  (%eax)
  80047c:	ff d6                	call   *%esi
			break;
  80047e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800481:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800484:	e9 9c 02 00 00       	jmp    800725 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	8d 78 04             	lea    0x4(%eax),%edi
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	99                   	cltd   
  800492:	31 d0                	xor    %edx,%eax
  800494:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800496:	83 f8 0f             	cmp    $0xf,%eax
  800499:	7f 23                	jg     8004be <vprintfmt+0x15a>
  80049b:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  8004a2:	85 d2                	test   %edx,%edx
  8004a4:	74 18                	je     8004be <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8004a6:	52                   	push   %edx
  8004a7:	68 ba 28 80 00       	push   $0x8028ba
  8004ac:	53                   	push   %ebx
  8004ad:	56                   	push   %esi
  8004ae:	e8 94 fe ff ff       	call   800347 <printfmt>
  8004b3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004b9:	e9 67 02 00 00       	jmp    800725 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8004be:	50                   	push   %eax
  8004bf:	68 ff 24 80 00       	push   $0x8024ff
  8004c4:	53                   	push   %ebx
  8004c5:	56                   	push   %esi
  8004c6:	e8 7c fe ff ff       	call   800347 <printfmt>
  8004cb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ce:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d1:	e9 4f 02 00 00       	jmp    800725 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d9:	83 c0 04             	add    $0x4,%eax
  8004dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004e4:	85 d2                	test   %edx,%edx
  8004e6:	b8 f8 24 80 00       	mov    $0x8024f8,%eax
  8004eb:	0f 45 c2             	cmovne %edx,%eax
  8004ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f5:	7e 06                	jle    8004fd <vprintfmt+0x199>
  8004f7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004fb:	75 0d                	jne    80050a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800500:	89 c7                	mov    %eax,%edi
  800502:	03 45 e0             	add    -0x20(%ebp),%eax
  800505:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800508:	eb 3f                	jmp    800549 <vprintfmt+0x1e5>
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	ff 75 d8             	pushl  -0x28(%ebp)
  800510:	50                   	push   %eax
  800511:	e8 0d 03 00 00       	call   800823 <strnlen>
  800516:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800519:	29 c2                	sub    %eax,%edx
  80051b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800523:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800527:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	85 ff                	test   %edi,%edi
  80052c:	7e 58                	jle    800586 <vprintfmt+0x222>
					putch(padc, putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	53                   	push   %ebx
  800532:	ff 75 e0             	pushl  -0x20(%ebp)
  800535:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800537:	83 ef 01             	sub    $0x1,%edi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb eb                	jmp    80052a <vprintfmt+0x1c6>
					putch(ch, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	52                   	push   %edx
  800544:	ff d6                	call   *%esi
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054e:	83 c7 01             	add    $0x1,%edi
  800551:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800555:	0f be d0             	movsbl %al,%edx
  800558:	85 d2                	test   %edx,%edx
  80055a:	74 45                	je     8005a1 <vprintfmt+0x23d>
  80055c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800560:	78 06                	js     800568 <vprintfmt+0x204>
  800562:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800566:	78 35                	js     80059d <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800568:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056c:	74 d1                	je     80053f <vprintfmt+0x1db>
  80056e:	0f be c0             	movsbl %al,%eax
  800571:	83 e8 20             	sub    $0x20,%eax
  800574:	83 f8 5e             	cmp    $0x5e,%eax
  800577:	76 c6                	jbe    80053f <vprintfmt+0x1db>
					putch('?', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	53                   	push   %ebx
  80057d:	6a 3f                	push   $0x3f
  80057f:	ff d6                	call   *%esi
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	eb c3                	jmp    800549 <vprintfmt+0x1e5>
  800586:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800589:	85 d2                	test   %edx,%edx
  80058b:	b8 00 00 00 00       	mov    $0x0,%eax
  800590:	0f 49 c2             	cmovns %edx,%eax
  800593:	29 c2                	sub    %eax,%edx
  800595:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800598:	e9 60 ff ff ff       	jmp    8004fd <vprintfmt+0x199>
  80059d:	89 cf                	mov    %ecx,%edi
  80059f:	eb 02                	jmp    8005a3 <vprintfmt+0x23f>
  8005a1:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8005a3:	85 ff                	test   %edi,%edi
  8005a5:	7e 10                	jle    8005b7 <vprintfmt+0x253>
				putch(' ', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 20                	push   $0x20
  8005ad:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005af:	83 ef 01             	sub    $0x1,%edi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	eb ec                	jmp    8005a3 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bd:	e9 63 01 00 00       	jmp    800725 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8005c2:	83 f9 01             	cmp    $0x1,%ecx
  8005c5:	7f 1b                	jg     8005e2 <vprintfmt+0x27e>
	else if (lflag)
  8005c7:	85 c9                	test   %ecx,%ecx
  8005c9:	74 63                	je     80062e <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	99                   	cltd   
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb 17                	jmp    8005f9 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 40 08             	lea    0x8(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800604:	85 c9                	test   %ecx,%ecx
  800606:	0f 89 ff 00 00 00    	jns    80070b <vprintfmt+0x3a7>
				putch('-', putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	53                   	push   %ebx
  800610:	6a 2d                	push   $0x2d
  800612:	ff d6                	call   *%esi
				num = -(long long) num;
  800614:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800617:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80061a:	f7 da                	neg    %edx
  80061c:	83 d1 00             	adc    $0x0,%ecx
  80061f:	f7 d9                	neg    %ecx
  800621:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
  800629:	e9 dd 00 00 00       	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	99                   	cltd   
  800637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
  800643:	eb b4                	jmp    8005f9 <vprintfmt+0x295>
	if (lflag >= 2)
  800645:	83 f9 01             	cmp    $0x1,%ecx
  800648:	7f 1e                	jg     800668 <vprintfmt+0x304>
	else if (lflag)
  80064a:	85 c9                	test   %ecx,%ecx
  80064c:	74 32                	je     800680 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 10                	mov    (%eax),%edx
  800653:	b9 00 00 00 00       	mov    $0x0,%ecx
  800658:	8d 40 04             	lea    0x4(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800663:	e9 a3 00 00 00       	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	8b 48 04             	mov    0x4(%eax),%ecx
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800676:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067b:	e9 8b 00 00 00       	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 10                	mov    (%eax),%edx
  800685:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800690:	b8 0a 00 00 00       	mov    $0xa,%eax
  800695:	eb 74                	jmp    80070b <vprintfmt+0x3a7>
	if (lflag >= 2)
  800697:	83 f9 01             	cmp    $0x1,%ecx
  80069a:	7f 1b                	jg     8006b7 <vprintfmt+0x353>
	else if (lflag)
  80069c:	85 c9                	test   %ecx,%ecx
  80069e:	74 2c                	je     8006cc <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 10                	mov    (%eax),%edx
  8006a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b5:	eb 54                	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 10                	mov    (%eax),%edx
  8006bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bf:	8d 40 08             	lea    0x8(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ca:	eb 3f                	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e1:	eb 28                	jmp    80070b <vprintfmt+0x3a7>
			putch('0', putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	6a 30                	push   $0x30
  8006e9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006eb:	83 c4 08             	add    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 78                	push   $0x78
  8006f1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006fd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800706:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800712:	57                   	push   %edi
  800713:	ff 75 e0             	pushl  -0x20(%ebp)
  800716:	50                   	push   %eax
  800717:	51                   	push   %ecx
  800718:	52                   	push   %edx
  800719:	89 da                	mov    %ebx,%edx
  80071b:	89 f0                	mov    %esi,%eax
  80071d:	e8 5a fb ff ff       	call   80027c <printnum>
			break;
  800722:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800725:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800728:	e9 55 fc ff ff       	jmp    800382 <vprintfmt+0x1e>
	if (lflag >= 2)
  80072d:	83 f9 01             	cmp    $0x1,%ecx
  800730:	7f 1b                	jg     80074d <vprintfmt+0x3e9>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	74 2c                	je     800762 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	b8 10 00 00 00       	mov    $0x10,%eax
  80074b:	eb be                	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 10                	mov    (%eax),%edx
  800752:	8b 48 04             	mov    0x4(%eax),%ecx
  800755:	8d 40 08             	lea    0x8(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075b:	b8 10 00 00 00       	mov    $0x10,%eax
  800760:	eb a9                	jmp    80070b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	b8 10 00 00 00       	mov    $0x10,%eax
  800777:	eb 92                	jmp    80070b <vprintfmt+0x3a7>
			putch(ch, putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 25                	push   $0x25
  80077f:	ff d6                	call   *%esi
			break;
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb 9f                	jmp    800725 <vprintfmt+0x3c1>
			putch('%', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 25                	push   $0x25
  80078c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 f8                	mov    %edi,%eax
  800793:	eb 03                	jmp    800798 <vprintfmt+0x434>
  800795:	83 e8 01             	sub    $0x1,%eax
  800798:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80079c:	75 f7                	jne    800795 <vprintfmt+0x431>
  80079e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a1:	eb 82                	jmp    800725 <vprintfmt+0x3c1>

008007a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	83 ec 18             	sub    $0x18,%esp
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	74 26                	je     8007ea <vsnprintf+0x47>
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	7e 22                	jle    8007ea <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c8:	ff 75 14             	pushl  0x14(%ebp)
  8007cb:	ff 75 10             	pushl  0x10(%ebp)
  8007ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	68 2a 03 80 00       	push   $0x80032a
  8007d7:	e8 88 fb ff ff       	call   800364 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    
		return -E_INVAL;
  8007ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ef:	eb f7                	jmp    8007e8 <vsnprintf+0x45>

008007f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007fa:	50                   	push   %eax
  8007fb:	ff 75 10             	pushl  0x10(%ebp)
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 9a ff ff ff       	call   8007a3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80081a:	74 05                	je     800821 <strlen+0x16>
		n++;
  80081c:	83 c0 01             	add    $0x1,%eax
  80081f:	eb f5                	jmp    800816 <strlen+0xb>
	return n;
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	39 c2                	cmp    %eax,%edx
  800833:	74 0d                	je     800842 <strnlen+0x1f>
  800835:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800839:	74 05                	je     800840 <strnlen+0x1d>
		n++;
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	eb f1                	jmp    800831 <strnlen+0xe>
  800840:	89 d0                	mov    %edx,%eax
	return n;
}
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084e:	ba 00 00 00 00       	mov    $0x0,%edx
  800853:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800857:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80085a:	83 c2 01             	add    $0x1,%edx
  80085d:	84 c9                	test   %cl,%cl
  80085f:	75 f2                	jne    800853 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800861:	5b                   	pop    %ebx
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	53                   	push   %ebx
  800868:	83 ec 10             	sub    $0x10,%esp
  80086b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086e:	53                   	push   %ebx
  80086f:	e8 97 ff ff ff       	call   80080b <strlen>
  800874:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	01 d8                	add    %ebx,%eax
  80087c:	50                   	push   %eax
  80087d:	e8 c2 ff ff ff       	call   800844 <strcpy>
	return dst;
}
  800882:	89 d8                	mov    %ebx,%eax
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	56                   	push   %esi
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800894:	89 c6                	mov    %eax,%esi
  800896:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800899:	89 c2                	mov    %eax,%edx
  80089b:	39 f2                	cmp    %esi,%edx
  80089d:	74 11                	je     8008b0 <strncpy+0x27>
		*dst++ = *src;
  80089f:	83 c2 01             	add    $0x1,%edx
  8008a2:	0f b6 19             	movzbl (%ecx),%ebx
  8008a5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a8:	80 fb 01             	cmp    $0x1,%bl
  8008ab:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8008ae:	eb eb                	jmp    80089b <strncpy+0x12>
	}
	return ret;
}
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
  8008b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bf:	8b 55 10             	mov    0x10(%ebp),%edx
  8008c2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	74 21                	je     8008e9 <strlcpy+0x35>
  8008c8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008cc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008ce:	39 c2                	cmp    %eax,%edx
  8008d0:	74 14                	je     8008e6 <strlcpy+0x32>
  8008d2:	0f b6 19             	movzbl (%ecx),%ebx
  8008d5:	84 db                	test   %bl,%bl
  8008d7:	74 0b                	je     8008e4 <strlcpy+0x30>
			*dst++ = *src++;
  8008d9:	83 c1 01             	add    $0x1,%ecx
  8008dc:	83 c2 01             	add    $0x1,%edx
  8008df:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e2:	eb ea                	jmp    8008ce <strlcpy+0x1a>
  8008e4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e9:	29 f0                	sub    %esi,%eax
}
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f8:	0f b6 01             	movzbl (%ecx),%eax
  8008fb:	84 c0                	test   %al,%al
  8008fd:	74 0c                	je     80090b <strcmp+0x1c>
  8008ff:	3a 02                	cmp    (%edx),%al
  800901:	75 08                	jne    80090b <strcmp+0x1c>
		p++, q++;
  800903:	83 c1 01             	add    $0x1,%ecx
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	eb ed                	jmp    8008f8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090b:	0f b6 c0             	movzbl %al,%eax
  80090e:	0f b6 12             	movzbl (%edx),%edx
  800911:	29 d0                	sub    %edx,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	89 c3                	mov    %eax,%ebx
  800921:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800924:	eb 06                	jmp    80092c <strncmp+0x17>
		n--, p++, q++;
  800926:	83 c0 01             	add    $0x1,%eax
  800929:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092c:	39 d8                	cmp    %ebx,%eax
  80092e:	74 16                	je     800946 <strncmp+0x31>
  800930:	0f b6 08             	movzbl (%eax),%ecx
  800933:	84 c9                	test   %cl,%cl
  800935:	74 04                	je     80093b <strncmp+0x26>
  800937:	3a 0a                	cmp    (%edx),%cl
  800939:	74 eb                	je     800926 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093b:	0f b6 00             	movzbl (%eax),%eax
  80093e:	0f b6 12             	movzbl (%edx),%edx
  800941:	29 d0                	sub    %edx,%eax
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    
		return 0;
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb f6                	jmp    800943 <strncmp+0x2e>

0080094d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800957:	0f b6 10             	movzbl (%eax),%edx
  80095a:	84 d2                	test   %dl,%dl
  80095c:	74 09                	je     800967 <strchr+0x1a>
		if (*s == c)
  80095e:	38 ca                	cmp    %cl,%dl
  800960:	74 0a                	je     80096c <strchr+0x1f>
	for (; *s; s++)
  800962:	83 c0 01             	add    $0x1,%eax
  800965:	eb f0                	jmp    800957 <strchr+0xa>
			return (char *) s;
	return 0;
  800967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800978:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80097b:	38 ca                	cmp    %cl,%dl
  80097d:	74 09                	je     800988 <strfind+0x1a>
  80097f:	84 d2                	test   %dl,%dl
  800981:	74 05                	je     800988 <strfind+0x1a>
	for (; *s; s++)
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	eb f0                	jmp    800978 <strfind+0xa>
			break;
	return (char *) s;
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	57                   	push   %edi
  80098e:	56                   	push   %esi
  80098f:	53                   	push   %ebx
  800990:	8b 7d 08             	mov    0x8(%ebp),%edi
  800993:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800996:	85 c9                	test   %ecx,%ecx
  800998:	74 31                	je     8009cb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099a:	89 f8                	mov    %edi,%eax
  80099c:	09 c8                	or     %ecx,%eax
  80099e:	a8 03                	test   $0x3,%al
  8009a0:	75 23                	jne    8009c5 <memset+0x3b>
		c &= 0xFF;
  8009a2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a6:	89 d3                	mov    %edx,%ebx
  8009a8:	c1 e3 08             	shl    $0x8,%ebx
  8009ab:	89 d0                	mov    %edx,%eax
  8009ad:	c1 e0 18             	shl    $0x18,%eax
  8009b0:	89 d6                	mov    %edx,%esi
  8009b2:	c1 e6 10             	shl    $0x10,%esi
  8009b5:	09 f0                	or     %esi,%eax
  8009b7:	09 c2                	or     %eax,%edx
  8009b9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009bb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	fc                   	cld    
  8009c1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c3:	eb 06                	jmp    8009cb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	fc                   	cld    
  8009c9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cb:	89 f8                	mov    %edi,%eax
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	57                   	push   %edi
  8009d6:	56                   	push   %esi
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e0:	39 c6                	cmp    %eax,%esi
  8009e2:	73 32                	jae    800a16 <memmove+0x44>
  8009e4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e7:	39 c2                	cmp    %eax,%edx
  8009e9:	76 2b                	jbe    800a16 <memmove+0x44>
		s += n;
		d += n;
  8009eb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ee:	89 fe                	mov    %edi,%esi
  8009f0:	09 ce                	or     %ecx,%esi
  8009f2:	09 d6                	or     %edx,%esi
  8009f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fa:	75 0e                	jne    800a0a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fc:	83 ef 04             	sub    $0x4,%edi
  8009ff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a02:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a05:	fd                   	std    
  800a06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a08:	eb 09                	jmp    800a13 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a0a:	83 ef 01             	sub    $0x1,%edi
  800a0d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a10:	fd                   	std    
  800a11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a13:	fc                   	cld    
  800a14:	eb 1a                	jmp    800a30 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	09 ca                	or     %ecx,%edx
  800a1a:	09 f2                	or     %esi,%edx
  800a1c:	f6 c2 03             	test   $0x3,%dl
  800a1f:	75 0a                	jne    800a2b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a24:	89 c7                	mov    %eax,%edi
  800a26:	fc                   	cld    
  800a27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a29:	eb 05                	jmp    800a30 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a2b:	89 c7                	mov    %eax,%edi
  800a2d:	fc                   	cld    
  800a2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3a:	ff 75 10             	pushl  0x10(%ebp)
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	ff 75 08             	pushl  0x8(%ebp)
  800a43:	e8 8a ff ff ff       	call   8009d2 <memmove>
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	56                   	push   %esi
  800a4e:	53                   	push   %ebx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a55:	89 c6                	mov    %eax,%esi
  800a57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5a:	39 f0                	cmp    %esi,%eax
  800a5c:	74 1c                	je     800a7a <memcmp+0x30>
		if (*s1 != *s2)
  800a5e:	0f b6 08             	movzbl (%eax),%ecx
  800a61:	0f b6 1a             	movzbl (%edx),%ebx
  800a64:	38 d9                	cmp    %bl,%cl
  800a66:	75 08                	jne    800a70 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a68:	83 c0 01             	add    $0x1,%eax
  800a6b:	83 c2 01             	add    $0x1,%edx
  800a6e:	eb ea                	jmp    800a5a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a70:	0f b6 c1             	movzbl %cl,%eax
  800a73:	0f b6 db             	movzbl %bl,%ebx
  800a76:	29 d8                	sub    %ebx,%eax
  800a78:	eb 05                	jmp    800a7f <memcmp+0x35>
	}

	return 0;
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a91:	39 d0                	cmp    %edx,%eax
  800a93:	73 09                	jae    800a9e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a95:	38 08                	cmp    %cl,(%eax)
  800a97:	74 05                	je     800a9e <memfind+0x1b>
	for (; s < ends; s++)
  800a99:	83 c0 01             	add    $0x1,%eax
  800a9c:	eb f3                	jmp    800a91 <memfind+0xe>
			break;
	return (void *) s;
}
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	57                   	push   %edi
  800aa4:	56                   	push   %esi
  800aa5:	53                   	push   %ebx
  800aa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aac:	eb 03                	jmp    800ab1 <strtol+0x11>
		s++;
  800aae:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab1:	0f b6 01             	movzbl (%ecx),%eax
  800ab4:	3c 20                	cmp    $0x20,%al
  800ab6:	74 f6                	je     800aae <strtol+0xe>
  800ab8:	3c 09                	cmp    $0x9,%al
  800aba:	74 f2                	je     800aae <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800abc:	3c 2b                	cmp    $0x2b,%al
  800abe:	74 2a                	je     800aea <strtol+0x4a>
	int neg = 0;
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ac5:	3c 2d                	cmp    $0x2d,%al
  800ac7:	74 2b                	je     800af4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800acf:	75 0f                	jne    800ae0 <strtol+0x40>
  800ad1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad4:	74 28                	je     800afe <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad6:	85 db                	test   %ebx,%ebx
  800ad8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800add:	0f 44 d8             	cmove  %eax,%ebx
  800ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ae8:	eb 50                	jmp    800b3a <strtol+0x9a>
		s++;
  800aea:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aed:	bf 00 00 00 00       	mov    $0x0,%edi
  800af2:	eb d5                	jmp    800ac9 <strtol+0x29>
		s++, neg = 1;
  800af4:	83 c1 01             	add    $0x1,%ecx
  800af7:	bf 01 00 00 00       	mov    $0x1,%edi
  800afc:	eb cb                	jmp    800ac9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b02:	74 0e                	je     800b12 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b04:	85 db                	test   %ebx,%ebx
  800b06:	75 d8                	jne    800ae0 <strtol+0x40>
		s++, base = 8;
  800b08:	83 c1 01             	add    $0x1,%ecx
  800b0b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b10:	eb ce                	jmp    800ae0 <strtol+0x40>
		s += 2, base = 16;
  800b12:	83 c1 02             	add    $0x2,%ecx
  800b15:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b1a:	eb c4                	jmp    800ae0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b1c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b1f:	89 f3                	mov    %esi,%ebx
  800b21:	80 fb 19             	cmp    $0x19,%bl
  800b24:	77 29                	ja     800b4f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b26:	0f be d2             	movsbl %dl,%edx
  800b29:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b2c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b2f:	7d 30                	jge    800b61 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b31:	83 c1 01             	add    $0x1,%ecx
  800b34:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b38:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3a:	0f b6 11             	movzbl (%ecx),%edx
  800b3d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b40:	89 f3                	mov    %esi,%ebx
  800b42:	80 fb 09             	cmp    $0x9,%bl
  800b45:	77 d5                	ja     800b1c <strtol+0x7c>
			dig = *s - '0';
  800b47:	0f be d2             	movsbl %dl,%edx
  800b4a:	83 ea 30             	sub    $0x30,%edx
  800b4d:	eb dd                	jmp    800b2c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800b4f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b52:	89 f3                	mov    %esi,%ebx
  800b54:	80 fb 19             	cmp    $0x19,%bl
  800b57:	77 08                	ja     800b61 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b59:	0f be d2             	movsbl %dl,%edx
  800b5c:	83 ea 37             	sub    $0x37,%edx
  800b5f:	eb cb                	jmp    800b2c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b65:	74 05                	je     800b6c <strtol+0xcc>
		*endptr = (char *) s;
  800b67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b6c:	89 c2                	mov    %eax,%edx
  800b6e:	f7 da                	neg    %edx
  800b70:	85 ff                	test   %edi,%edi
  800b72:	0f 45 c2             	cmovne %edx,%eax
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
  800b85:	8b 55 08             	mov    0x8(%ebp),%edx
  800b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	89 c7                	mov    %eax,%edi
  800b8f:	89 c6                	mov    %eax,%esi
  800b91:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba8:	89 d1                	mov    %edx,%ecx
  800baa:	89 d3                	mov    %edx,%ebx
  800bac:	89 d7                	mov    %edx,%edi
  800bae:	89 d6                	mov    %edx,%esi
  800bb0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5f                   	pop    %edi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcd:	89 cb                	mov    %ecx,%ebx
  800bcf:	89 cf                	mov    %ecx,%edi
  800bd1:	89 ce                	mov    %ecx,%esi
  800bd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	7f 08                	jg     800be1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be1:	83 ec 0c             	sub    $0xc,%esp
  800be4:	50                   	push   %eax
  800be5:	6a 03                	push   $0x3
  800be7:	68 df 27 80 00       	push   $0x8027df
  800bec:	6a 23                	push   $0x23
  800bee:	68 fc 27 80 00       	push   $0x8027fc
  800bf3:	e8 95 f5 ff ff       	call   80018d <_panic>

00800bf8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	b8 02 00 00 00       	mov    $0x2,%eax
  800c08:	89 d1                	mov    %edx,%ecx
  800c0a:	89 d3                	mov    %edx,%ebx
  800c0c:	89 d7                	mov    %edx,%edi
  800c0e:	89 d6                	mov    %edx,%esi
  800c10:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_yield>:

void
sys_yield(void)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c22:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c27:	89 d1                	mov    %edx,%ecx
  800c29:	89 d3                	mov    %edx,%ebx
  800c2b:	89 d7                	mov    %edx,%edi
  800c2d:	89 d6                	mov    %edx,%esi
  800c2f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3f:	be 00 00 00 00       	mov    $0x0,%esi
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c52:	89 f7                	mov    %esi,%edi
  800c54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7f 08                	jg     800c62 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	50                   	push   %eax
  800c66:	6a 04                	push   $0x4
  800c68:	68 df 27 80 00       	push   $0x8027df
  800c6d:	6a 23                	push   $0x23
  800c6f:	68 fc 27 80 00       	push   $0x8027fc
  800c74:	e8 14 f5 ff ff       	call   80018d <_panic>

00800c79 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
  800c7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c88:	b8 05 00 00 00       	mov    $0x5,%eax
  800c8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c90:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c93:	8b 75 18             	mov    0x18(%ebp),%esi
  800c96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c98:	85 c0                	test   %eax,%eax
  800c9a:	7f 08                	jg     800ca4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca4:	83 ec 0c             	sub    $0xc,%esp
  800ca7:	50                   	push   %eax
  800ca8:	6a 05                	push   $0x5
  800caa:	68 df 27 80 00       	push   $0x8027df
  800caf:	6a 23                	push   $0x23
  800cb1:	68 fc 27 80 00       	push   $0x8027fc
  800cb6:	e8 d2 f4 ff ff       	call   80018d <_panic>

00800cbb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
  800cc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cd4:	89 df                	mov    %ebx,%edi
  800cd6:	89 de                	mov    %ebx,%esi
  800cd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	7f 08                	jg     800ce6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce6:	83 ec 0c             	sub    $0xc,%esp
  800ce9:	50                   	push   %eax
  800cea:	6a 06                	push   $0x6
  800cec:	68 df 27 80 00       	push   $0x8027df
  800cf1:	6a 23                	push   $0x23
  800cf3:	68 fc 27 80 00       	push   $0x8027fc
  800cf8:	e8 90 f4 ff ff       	call   80018d <_panic>

00800cfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 08 00 00 00       	mov    $0x8,%eax
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	89 de                	mov    %ebx,%esi
  800d1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7f 08                	jg     800d28 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	50                   	push   %eax
  800d2c:	6a 08                	push   $0x8
  800d2e:	68 df 27 80 00       	push   $0x8027df
  800d33:	6a 23                	push   $0x23
  800d35:	68 fc 27 80 00       	push   $0x8027fc
  800d3a:	e8 4e f4 ff ff       	call   80018d <_panic>

00800d3f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 09 00 00 00       	mov    $0x9,%eax
  800d58:	89 df                	mov    %ebx,%edi
  800d5a:	89 de                	mov    %ebx,%esi
  800d5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	7f 08                	jg     800d6a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	83 ec 0c             	sub    $0xc,%esp
  800d6d:	50                   	push   %eax
  800d6e:	6a 09                	push   $0x9
  800d70:	68 df 27 80 00       	push   $0x8027df
  800d75:	6a 23                	push   $0x23
  800d77:	68 fc 27 80 00       	push   $0x8027fc
  800d7c:	e8 0c f4 ff ff       	call   80018d <_panic>

00800d81 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
  800d87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d9a:	89 df                	mov    %ebx,%edi
  800d9c:	89 de                	mov    %ebx,%esi
  800d9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7f 08                	jg     800dac <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	50                   	push   %eax
  800db0:	6a 0a                	push   $0xa
  800db2:	68 df 27 80 00       	push   $0x8027df
  800db7:	6a 23                	push   $0x23
  800db9:	68 fc 27 80 00       	push   $0x8027fc
  800dbe:	e8 ca f3 ff ff       	call   80018d <_panic>

00800dc3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd4:	be 00 00 00 00       	mov    $0x0,%esi
  800dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800def:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfc:	89 cb                	mov    %ecx,%ebx
  800dfe:	89 cf                	mov    %ecx,%edi
  800e00:	89 ce                	mov    %ecx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 0d                	push   $0xd
  800e16:	68 df 27 80 00       	push   $0x8027df
  800e1b:	6a 23                	push   $0x23
  800e1d:	68 fc 27 80 00       	push   $0x8027fc
  800e22:	e8 66 f3 ff ff       	call   80018d <_panic>

00800e27 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e37:	89 d1                	mov    %edx,%ecx
  800e39:	89 d3                	mov    %edx,%ebx
  800e3b:	89 d7                	mov    %edx,%edi
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	05 00 00 00 30       	add    $0x30000000,%eax
  800e51:	c1 e8 0c             	shr    $0xc,%eax
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e66:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	c1 ea 16             	shr    $0x16,%edx
  800e7a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e81:	f6 c2 01             	test   $0x1,%dl
  800e84:	74 2d                	je     800eb3 <fd_alloc+0x46>
  800e86:	89 c2                	mov    %eax,%edx
  800e88:	c1 ea 0c             	shr    $0xc,%edx
  800e8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e92:	f6 c2 01             	test   $0x1,%dl
  800e95:	74 1c                	je     800eb3 <fd_alloc+0x46>
  800e97:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e9c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ea1:	75 d2                	jne    800e75 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800eac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eb1:	eb 0a                	jmp    800ebd <fd_alloc+0x50>
			*fd_store = fd;
  800eb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb6:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ec5:	83 f8 1f             	cmp    $0x1f,%eax
  800ec8:	77 30                	ja     800efa <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eca:	c1 e0 0c             	shl    $0xc,%eax
  800ecd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ed2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ed8:	f6 c2 01             	test   $0x1,%dl
  800edb:	74 24                	je     800f01 <fd_lookup+0x42>
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	c1 ea 0c             	shr    $0xc,%edx
  800ee2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee9:	f6 c2 01             	test   $0x1,%dl
  800eec:	74 1a                	je     800f08 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef1:	89 02                	mov    %eax,(%edx)
	return 0;
  800ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
		return -E_INVAL;
  800efa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eff:	eb f7                	jmp    800ef8 <fd_lookup+0x39>
		return -E_INVAL;
  800f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f06:	eb f0                	jmp    800ef8 <fd_lookup+0x39>
  800f08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0d:	eb e9                	jmp    800ef8 <fd_lookup+0x39>

00800f0f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f18:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f22:	39 08                	cmp    %ecx,(%eax)
  800f24:	74 38                	je     800f5e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f26:	83 c2 01             	add    $0x1,%edx
  800f29:	8b 04 95 88 28 80 00 	mov    0x802888(,%edx,4),%eax
  800f30:	85 c0                	test   %eax,%eax
  800f32:	75 ee                	jne    800f22 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f34:	a1 20 60 80 00       	mov    0x806020,%eax
  800f39:	8b 40 48             	mov    0x48(%eax),%eax
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	51                   	push   %ecx
  800f40:	50                   	push   %eax
  800f41:	68 0c 28 80 00       	push   $0x80280c
  800f46:	e8 1d f3 ff ff       	call   800268 <cprintf>
	*dev = 0;
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    
			*dev = devtab[i];
  800f5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f61:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f63:	b8 00 00 00 00       	mov    $0x0,%eax
  800f68:	eb f2                	jmp    800f5c <dev_lookup+0x4d>

00800f6a <fd_close>:
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 24             	sub    $0x24,%esp
  800f73:	8b 75 08             	mov    0x8(%ebp),%esi
  800f76:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f79:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f7c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f7d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f83:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f86:	50                   	push   %eax
  800f87:	e8 33 ff ff ff       	call   800ebf <fd_lookup>
  800f8c:	89 c3                	mov    %eax,%ebx
  800f8e:	83 c4 10             	add    $0x10,%esp
  800f91:	85 c0                	test   %eax,%eax
  800f93:	78 05                	js     800f9a <fd_close+0x30>
	    || fd != fd2)
  800f95:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f98:	74 16                	je     800fb0 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f9a:	89 f8                	mov    %edi,%eax
  800f9c:	84 c0                	test   %al,%al
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa3:	0f 44 d8             	cmove  %eax,%ebx
}
  800fa6:	89 d8                	mov    %ebx,%eax
  800fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fb0:	83 ec 08             	sub    $0x8,%esp
  800fb3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	ff 36                	pushl  (%esi)
  800fb9:	e8 51 ff ff ff       	call   800f0f <dev_lookup>
  800fbe:	89 c3                	mov    %eax,%ebx
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	78 1a                	js     800fe1 <fd_close+0x77>
		if (dev->dev_close)
  800fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fca:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	74 0b                	je     800fe1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	56                   	push   %esi
  800fda:	ff d0                	call   *%eax
  800fdc:	89 c3                	mov    %eax,%ebx
  800fde:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fe1:	83 ec 08             	sub    $0x8,%esp
  800fe4:	56                   	push   %esi
  800fe5:	6a 00                	push   $0x0
  800fe7:	e8 cf fc ff ff       	call   800cbb <sys_page_unmap>
	return r;
  800fec:	83 c4 10             	add    $0x10,%esp
  800fef:	eb b5                	jmp    800fa6 <fd_close+0x3c>

00800ff1 <close>:

int
close(int fdnum)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ffa:	50                   	push   %eax
  800ffb:	ff 75 08             	pushl  0x8(%ebp)
  800ffe:	e8 bc fe ff ff       	call   800ebf <fd_lookup>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	79 02                	jns    80100c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    
		return fd_close(fd, 1);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	6a 01                	push   $0x1
  801011:	ff 75 f4             	pushl  -0xc(%ebp)
  801014:	e8 51 ff ff ff       	call   800f6a <fd_close>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	eb ec                	jmp    80100a <close+0x19>

0080101e <close_all>:

void
close_all(void)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	53                   	push   %ebx
  801022:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801025:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	53                   	push   %ebx
  80102e:	e8 be ff ff ff       	call   800ff1 <close>
	for (i = 0; i < MAXFD; i++)
  801033:	83 c3 01             	add    $0x1,%ebx
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	83 fb 20             	cmp    $0x20,%ebx
  80103c:	75 ec                	jne    80102a <close_all+0xc>
}
  80103e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80104c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80104f:	50                   	push   %eax
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	e8 67 fe ff ff       	call   800ebf <fd_lookup>
  801058:	89 c3                	mov    %eax,%ebx
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	85 c0                	test   %eax,%eax
  80105f:	0f 88 81 00 00 00    	js     8010e6 <dup+0xa3>
		return r;
	close(newfdnum);
  801065:	83 ec 0c             	sub    $0xc,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	e8 81 ff ff ff       	call   800ff1 <close>

	newfd = INDEX2FD(newfdnum);
  801070:	8b 75 0c             	mov    0xc(%ebp),%esi
  801073:	c1 e6 0c             	shl    $0xc,%esi
  801076:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80107c:	83 c4 04             	add    $0x4,%esp
  80107f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801082:	e8 cf fd ff ff       	call   800e56 <fd2data>
  801087:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801089:	89 34 24             	mov    %esi,(%esp)
  80108c:	e8 c5 fd ff ff       	call   800e56 <fd2data>
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801096:	89 d8                	mov    %ebx,%eax
  801098:	c1 e8 16             	shr    $0x16,%eax
  80109b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a2:	a8 01                	test   $0x1,%al
  8010a4:	74 11                	je     8010b7 <dup+0x74>
  8010a6:	89 d8                	mov    %ebx,%eax
  8010a8:	c1 e8 0c             	shr    $0xc,%eax
  8010ab:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b2:	f6 c2 01             	test   $0x1,%dl
  8010b5:	75 39                	jne    8010f0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	c1 e8 0c             	shr    $0xc,%eax
  8010bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c6:	83 ec 0c             	sub    $0xc,%esp
  8010c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ce:	50                   	push   %eax
  8010cf:	56                   	push   %esi
  8010d0:	6a 00                	push   $0x0
  8010d2:	52                   	push   %edx
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 9f fb ff ff       	call   800c79 <sys_page_map>
  8010da:	89 c3                	mov    %eax,%ebx
  8010dc:	83 c4 20             	add    $0x20,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 31                	js     801114 <dup+0xd1>
		goto err;

	return newfdnum;
  8010e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010e6:	89 d8                	mov    %ebx,%eax
  8010e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ff:	50                   	push   %eax
  801100:	57                   	push   %edi
  801101:	6a 00                	push   $0x0
  801103:	53                   	push   %ebx
  801104:	6a 00                	push   $0x0
  801106:	e8 6e fb ff ff       	call   800c79 <sys_page_map>
  80110b:	89 c3                	mov    %eax,%ebx
  80110d:	83 c4 20             	add    $0x20,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	79 a3                	jns    8010b7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801114:	83 ec 08             	sub    $0x8,%esp
  801117:	56                   	push   %esi
  801118:	6a 00                	push   $0x0
  80111a:	e8 9c fb ff ff       	call   800cbb <sys_page_unmap>
	sys_page_unmap(0, nva);
  80111f:	83 c4 08             	add    $0x8,%esp
  801122:	57                   	push   %edi
  801123:	6a 00                	push   $0x0
  801125:	e8 91 fb ff ff       	call   800cbb <sys_page_unmap>
	return r;
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	eb b7                	jmp    8010e6 <dup+0xa3>

0080112f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	53                   	push   %ebx
  801133:	83 ec 1c             	sub    $0x1c,%esp
  801136:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801139:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80113c:	50                   	push   %eax
  80113d:	53                   	push   %ebx
  80113e:	e8 7c fd ff ff       	call   800ebf <fd_lookup>
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	85 c0                	test   %eax,%eax
  801148:	78 3f                	js     801189 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801150:	50                   	push   %eax
  801151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801154:	ff 30                	pushl  (%eax)
  801156:	e8 b4 fd ff ff       	call   800f0f <dev_lookup>
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	78 27                	js     801189 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801162:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801165:	8b 42 08             	mov    0x8(%edx),%eax
  801168:	83 e0 03             	and    $0x3,%eax
  80116b:	83 f8 01             	cmp    $0x1,%eax
  80116e:	74 1e                	je     80118e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	8b 40 08             	mov    0x8(%eax),%eax
  801176:	85 c0                	test   %eax,%eax
  801178:	74 35                	je     8011af <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	ff 75 10             	pushl  0x10(%ebp)
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	52                   	push   %edx
  801184:	ff d0                	call   *%eax
  801186:	83 c4 10             	add    $0x10,%esp
}
  801189:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80118e:	a1 20 60 80 00       	mov    0x806020,%eax
  801193:	8b 40 48             	mov    0x48(%eax),%eax
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	53                   	push   %ebx
  80119a:	50                   	push   %eax
  80119b:	68 4d 28 80 00       	push   $0x80284d
  8011a0:	e8 c3 f0 ff ff       	call   800268 <cprintf>
		return -E_INVAL;
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ad:	eb da                	jmp    801189 <read+0x5a>
		return -E_NOT_SUPP;
  8011af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b4:	eb d3                	jmp    801189 <read+0x5a>

008011b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	57                   	push   %edi
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ca:	39 f3                	cmp    %esi,%ebx
  8011cc:	73 23                	jae    8011f1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	89 f0                	mov    %esi,%eax
  8011d3:	29 d8                	sub    %ebx,%eax
  8011d5:	50                   	push   %eax
  8011d6:	89 d8                	mov    %ebx,%eax
  8011d8:	03 45 0c             	add    0xc(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	57                   	push   %edi
  8011dd:	e8 4d ff ff ff       	call   80112f <read>
		if (m < 0)
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 06                	js     8011ef <readn+0x39>
			return m;
		if (m == 0)
  8011e9:	74 06                	je     8011f1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8011eb:	01 c3                	add    %eax,%ebx
  8011ed:	eb db                	jmp    8011ca <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ef:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011f1:	89 d8                	mov    %ebx,%eax
  8011f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 1c             	sub    $0x1c,%esp
  801202:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801205:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801208:	50                   	push   %eax
  801209:	53                   	push   %ebx
  80120a:	e8 b0 fc ff ff       	call   800ebf <fd_lookup>
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 3a                	js     801250 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121c:	50                   	push   %eax
  80121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801220:	ff 30                	pushl  (%eax)
  801222:	e8 e8 fc ff ff       	call   800f0f <dev_lookup>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 22                	js     801250 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801235:	74 1e                	je     801255 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123a:	8b 52 0c             	mov    0xc(%edx),%edx
  80123d:	85 d2                	test   %edx,%edx
  80123f:	74 35                	je     801276 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	ff 75 10             	pushl  0x10(%ebp)
  801247:	ff 75 0c             	pushl  0xc(%ebp)
  80124a:	50                   	push   %eax
  80124b:	ff d2                	call   *%edx
  80124d:	83 c4 10             	add    $0x10,%esp
}
  801250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801253:	c9                   	leave  
  801254:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801255:	a1 20 60 80 00       	mov    0x806020,%eax
  80125a:	8b 40 48             	mov    0x48(%eax),%eax
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	53                   	push   %ebx
  801261:	50                   	push   %eax
  801262:	68 69 28 80 00       	push   $0x802869
  801267:	e8 fc ef ff ff       	call   800268 <cprintf>
		return -E_INVAL;
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801274:	eb da                	jmp    801250 <write+0x55>
		return -E_NOT_SUPP;
  801276:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80127b:	eb d3                	jmp    801250 <write+0x55>

0080127d <seek>:

int
seek(int fdnum, off_t offset)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801286:	50                   	push   %eax
  801287:	ff 75 08             	pushl  0x8(%ebp)
  80128a:	e8 30 fc ff ff       	call   800ebf <fd_lookup>
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 0e                	js     8012a4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801296:	8b 55 0c             	mov    0xc(%ebp),%edx
  801299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80129f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	53                   	push   %ebx
  8012aa:	83 ec 1c             	sub    $0x1c,%esp
  8012ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b3:	50                   	push   %eax
  8012b4:	53                   	push   %ebx
  8012b5:	e8 05 fc ff ff       	call   800ebf <fd_lookup>
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 37                	js     8012f8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c7:	50                   	push   %eax
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cb:	ff 30                	pushl  (%eax)
  8012cd:	e8 3d fc ff ff       	call   800f0f <dev_lookup>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 1f                	js     8012f8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012e0:	74 1b                	je     8012fd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e5:	8b 52 18             	mov    0x18(%edx),%edx
  8012e8:	85 d2                	test   %edx,%edx
  8012ea:	74 32                	je     80131e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	50                   	push   %eax
  8012f3:	ff d2                	call   *%edx
  8012f5:	83 c4 10             	add    $0x10,%esp
}
  8012f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012fd:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801302:	8b 40 48             	mov    0x48(%eax),%eax
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	53                   	push   %ebx
  801309:	50                   	push   %eax
  80130a:	68 2c 28 80 00       	push   $0x80282c
  80130f:	e8 54 ef ff ff       	call   800268 <cprintf>
		return -E_INVAL;
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131c:	eb da                	jmp    8012f8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80131e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801323:	eb d3                	jmp    8012f8 <ftruncate+0x52>

00801325 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	53                   	push   %ebx
  801329:	83 ec 1c             	sub    $0x1c,%esp
  80132c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	ff 75 08             	pushl  0x8(%ebp)
  801336:	e8 84 fb ff ff       	call   800ebf <fd_lookup>
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 4b                	js     80138d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801342:	83 ec 08             	sub    $0x8,%esp
  801345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134c:	ff 30                	pushl  (%eax)
  80134e:	e8 bc fb ff ff       	call   800f0f <dev_lookup>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	85 c0                	test   %eax,%eax
  801358:	78 33                	js     80138d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801361:	74 2f                	je     801392 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801363:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801366:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80136d:	00 00 00 
	stat->st_isdir = 0;
  801370:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801377:	00 00 00 
	stat->st_dev = dev;
  80137a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	53                   	push   %ebx
  801384:	ff 75 f0             	pushl  -0x10(%ebp)
  801387:	ff 50 14             	call   *0x14(%eax)
  80138a:	83 c4 10             	add    $0x10,%esp
}
  80138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801390:	c9                   	leave  
  801391:	c3                   	ret    
		return -E_NOT_SUPP;
  801392:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801397:	eb f4                	jmp    80138d <fstat+0x68>

00801399 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	6a 00                	push   $0x0
  8013a3:	ff 75 08             	pushl  0x8(%ebp)
  8013a6:	e8 2f 02 00 00       	call   8015da <open>
  8013ab:	89 c3                	mov    %eax,%ebx
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 1b                	js     8013cf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	50                   	push   %eax
  8013bb:	e8 65 ff ff ff       	call   801325 <fstat>
  8013c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8013c2:	89 1c 24             	mov    %ebx,(%esp)
  8013c5:	e8 27 fc ff ff       	call   800ff1 <close>
	return r;
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	89 f3                	mov    %esi,%ebx
}
  8013cf:	89 d8                	mov    %ebx,%eax
  8013d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	56                   	push   %esi
  8013dc:	53                   	push   %ebx
  8013dd:	89 c6                	mov    %eax,%esi
  8013df:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013e1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013e8:	74 27                	je     801411 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013ea:	6a 07                	push   $0x7
  8013ec:	68 00 70 80 00       	push   $0x807000
  8013f1:	56                   	push   %esi
  8013f2:	ff 35 00 40 80 00    	pushl  0x804000
  8013f8:	e8 33 0d 00 00       	call   802130 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013fd:	83 c4 0c             	add    $0xc,%esp
  801400:	6a 00                	push   $0x0
  801402:	53                   	push   %ebx
  801403:	6a 00                	push   $0x0
  801405:	e8 b3 0c 00 00       	call   8020bd <ipc_recv>
}
  80140a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80140d:	5b                   	pop    %ebx
  80140e:	5e                   	pop    %esi
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	6a 01                	push   $0x1
  801416:	e8 81 0d 00 00       	call   80219c <ipc_find_env>
  80141b:	a3 00 40 80 00       	mov    %eax,0x804000
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	eb c5                	jmp    8013ea <fsipc+0x12>

00801425 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8b 40 0c             	mov    0xc(%eax),%eax
  801431:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80143e:	ba 00 00 00 00       	mov    $0x0,%edx
  801443:	b8 02 00 00 00       	mov    $0x2,%eax
  801448:	e8 8b ff ff ff       	call   8013d8 <fsipc>
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <devfile_flush>:
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8b 40 0c             	mov    0xc(%eax),%eax
  80145b:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801460:	ba 00 00 00 00       	mov    $0x0,%edx
  801465:	b8 06 00 00 00       	mov    $0x6,%eax
  80146a:	e8 69 ff ff ff       	call   8013d8 <fsipc>
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <devfile_stat>:
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8b 40 0c             	mov    0xc(%eax),%eax
  801481:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801486:	ba 00 00 00 00       	mov    $0x0,%edx
  80148b:	b8 05 00 00 00       	mov    $0x5,%eax
  801490:	e8 43 ff ff ff       	call   8013d8 <fsipc>
  801495:	85 c0                	test   %eax,%eax
  801497:	78 2c                	js     8014c5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	68 00 70 80 00       	push   $0x807000
  8014a1:	53                   	push   %ebx
  8014a2:	e8 9d f3 ff ff       	call   800844 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014a7:	a1 80 70 80 00       	mov    0x807080,%eax
  8014ac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b2:	a1 84 70 80 00       	mov    0x807084,%eax
  8014b7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <devfile_write>:
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8014d4:	85 db                	test   %ebx,%ebx
  8014d6:	75 07                	jne    8014df <devfile_write+0x15>
	return n_all;
  8014d8:	89 d8                	mov    %ebx,%eax
}
  8014da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e5:	a3 00 70 80 00       	mov    %eax,0x807000
	  fsipcbuf.write.req_n = n_left;
  8014ea:	89 1d 04 70 80 00    	mov    %ebx,0x807004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	53                   	push   %ebx
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	68 08 70 80 00       	push   $0x807008
  8014fc:	e8 d1 f4 ff ff       	call   8009d2 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	b8 04 00 00 00       	mov    $0x4,%eax
  80150b:	e8 c8 fe ff ff       	call   8013d8 <fsipc>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 c3                	js     8014da <devfile_write+0x10>
	  assert(r <= n_left);
  801517:	39 d8                	cmp    %ebx,%eax
  801519:	77 0b                	ja     801526 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  80151b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801520:	7f 1d                	jg     80153f <devfile_write+0x75>
    n_all += r;
  801522:	89 c3                	mov    %eax,%ebx
  801524:	eb b2                	jmp    8014d8 <devfile_write+0xe>
	  assert(r <= n_left);
  801526:	68 9c 28 80 00       	push   $0x80289c
  80152b:	68 a8 28 80 00       	push   $0x8028a8
  801530:	68 9f 00 00 00       	push   $0x9f
  801535:	68 bd 28 80 00       	push   $0x8028bd
  80153a:	e8 4e ec ff ff       	call   80018d <_panic>
	  assert(r <= PGSIZE);
  80153f:	68 c8 28 80 00       	push   $0x8028c8
  801544:	68 a8 28 80 00       	push   $0x8028a8
  801549:	68 a0 00 00 00       	push   $0xa0
  80154e:	68 bd 28 80 00       	push   $0x8028bd
  801553:	e8 35 ec ff ff       	call   80018d <_panic>

00801558 <devfile_read>:
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	56                   	push   %esi
  80155c:	53                   	push   %ebx
  80155d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8b 40 0c             	mov    0xc(%eax),%eax
  801566:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80156b:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	b8 03 00 00 00       	mov    $0x3,%eax
  80157b:	e8 58 fe ff ff       	call   8013d8 <fsipc>
  801580:	89 c3                	mov    %eax,%ebx
  801582:	85 c0                	test   %eax,%eax
  801584:	78 1f                	js     8015a5 <devfile_read+0x4d>
	assert(r <= n);
  801586:	39 f0                	cmp    %esi,%eax
  801588:	77 24                	ja     8015ae <devfile_read+0x56>
	assert(r <= PGSIZE);
  80158a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80158f:	7f 33                	jg     8015c4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	50                   	push   %eax
  801595:	68 00 70 80 00       	push   $0x807000
  80159a:	ff 75 0c             	pushl  0xc(%ebp)
  80159d:	e8 30 f4 ff ff       	call   8009d2 <memmove>
	return r;
  8015a2:	83 c4 10             	add    $0x10,%esp
}
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    
	assert(r <= n);
  8015ae:	68 d4 28 80 00       	push   $0x8028d4
  8015b3:	68 a8 28 80 00       	push   $0x8028a8
  8015b8:	6a 7c                	push   $0x7c
  8015ba:	68 bd 28 80 00       	push   $0x8028bd
  8015bf:	e8 c9 eb ff ff       	call   80018d <_panic>
	assert(r <= PGSIZE);
  8015c4:	68 c8 28 80 00       	push   $0x8028c8
  8015c9:	68 a8 28 80 00       	push   $0x8028a8
  8015ce:	6a 7d                	push   $0x7d
  8015d0:	68 bd 28 80 00       	push   $0x8028bd
  8015d5:	e8 b3 eb ff ff       	call   80018d <_panic>

008015da <open>:
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	56                   	push   %esi
  8015de:	53                   	push   %ebx
  8015df:	83 ec 1c             	sub    $0x1c,%esp
  8015e2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015e5:	56                   	push   %esi
  8015e6:	e8 20 f2 ff ff       	call   80080b <strlen>
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015f3:	7f 6c                	jg     801661 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	50                   	push   %eax
  8015fc:	e8 6c f8 ff ff       	call   800e6d <fd_alloc>
  801601:	89 c3                	mov    %eax,%ebx
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 3c                	js     801646 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	56                   	push   %esi
  80160e:	68 00 70 80 00       	push   $0x807000
  801613:	e8 2c f2 ff ff       	call   800844 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801623:	b8 01 00 00 00       	mov    $0x1,%eax
  801628:	e8 ab fd ff ff       	call   8013d8 <fsipc>
  80162d:	89 c3                	mov    %eax,%ebx
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 19                	js     80164f <open+0x75>
	return fd2num(fd);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	ff 75 f4             	pushl  -0xc(%ebp)
  80163c:	e8 05 f8 ff ff       	call   800e46 <fd2num>
  801641:	89 c3                	mov    %eax,%ebx
  801643:	83 c4 10             	add    $0x10,%esp
}
  801646:	89 d8                	mov    %ebx,%eax
  801648:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    
		fd_close(fd, 0);
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	6a 00                	push   $0x0
  801654:	ff 75 f4             	pushl  -0xc(%ebp)
  801657:	e8 0e f9 ff ff       	call   800f6a <fd_close>
		return r;
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	eb e5                	jmp    801646 <open+0x6c>
		return -E_BAD_PATH;
  801661:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801666:	eb de                	jmp    801646 <open+0x6c>

00801668 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80166e:	ba 00 00 00 00       	mov    $0x0,%edx
  801673:	b8 08 00 00 00       	mov    $0x8,%eax
  801678:	e8 5b fd ff ff       	call   8013d8 <fsipc>
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80167f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801683:	7f 01                	jg     801686 <writebuf+0x7>
  801685:	c3                   	ret    
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80168f:	ff 70 04             	pushl  0x4(%eax)
  801692:	8d 40 10             	lea    0x10(%eax),%eax
  801695:	50                   	push   %eax
  801696:	ff 33                	pushl  (%ebx)
  801698:	e8 5e fb ff ff       	call   8011fb <write>
		if (result > 0)
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	7e 03                	jle    8016a7 <writebuf+0x28>
			b->result += result;
  8016a4:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016a7:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016aa:	74 0d                	je     8016b9 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	0f 4f c2             	cmovg  %edx,%eax
  8016b6:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8016b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <putch>:

static void
putch(int ch, void *thunk)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	53                   	push   %ebx
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016c8:	8b 53 04             	mov    0x4(%ebx),%edx
  8016cb:	8d 42 01             	lea    0x1(%edx),%eax
  8016ce:	89 43 04             	mov    %eax,0x4(%ebx)
  8016d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d4:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016d8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8016dd:	74 06                	je     8016e5 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8016df:	83 c4 04             	add    $0x4,%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5d                   	pop    %ebp
  8016e4:	c3                   	ret    
		writebuf(b);
  8016e5:	89 d8                	mov    %ebx,%eax
  8016e7:	e8 93 ff ff ff       	call   80167f <writebuf>
		b->idx = 0;
  8016ec:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8016f3:	eb ea                	jmp    8016df <putch+0x21>

008016f5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801707:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80170e:	00 00 00 
	b.result = 0;
  801711:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801718:	00 00 00 
	b.error = 1;
  80171b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801722:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801725:	ff 75 10             	pushl  0x10(%ebp)
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	68 be 16 80 00       	push   $0x8016be
  801737:	e8 28 ec ff ff       	call   800364 <vprintfmt>
	if (b.idx > 0)
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801746:	7f 11                	jg     801759 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801748:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80174e:	85 c0                	test   %eax,%eax
  801750:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    
		writebuf(&b);
  801759:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80175f:	e8 1b ff ff ff       	call   80167f <writebuf>
  801764:	eb e2                	jmp    801748 <vfprintf+0x53>

00801766 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80176c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80176f:	50                   	push   %eax
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	e8 7a ff ff ff       	call   8016f5 <vfprintf>
	va_end(ap);

	return cnt;
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <printf>:

int
printf(const char *fmt, ...)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801783:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801786:	50                   	push   %eax
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 01                	push   $0x1
  80178c:	e8 64 ff ff ff       	call   8016f5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	56                   	push   %esi
  801797:	53                   	push   %ebx
  801798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	e8 b0 f6 ff ff       	call   800e56 <fd2data>
  8017a6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017a8:	83 c4 08             	add    $0x8,%esp
  8017ab:	68 db 28 80 00       	push   $0x8028db
  8017b0:	53                   	push   %ebx
  8017b1:	e8 8e f0 ff ff       	call   800844 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017b6:	8b 46 04             	mov    0x4(%esi),%eax
  8017b9:	2b 06                	sub    (%esi),%eax
  8017bb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017c1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017c8:	00 00 00 
	stat->st_dev = &devpipe;
  8017cb:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017d2:	30 80 00 
	return 0;
}
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017eb:	53                   	push   %ebx
  8017ec:	6a 00                	push   $0x0
  8017ee:	e8 c8 f4 ff ff       	call   800cbb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017f3:	89 1c 24             	mov    %ebx,(%esp)
  8017f6:	e8 5b f6 ff ff       	call   800e56 <fd2data>
  8017fb:	83 c4 08             	add    $0x8,%esp
  8017fe:	50                   	push   %eax
  8017ff:	6a 00                	push   $0x0
  801801:	e8 b5 f4 ff ff       	call   800cbb <sys_page_unmap>
}
  801806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <_pipeisclosed>:
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	57                   	push   %edi
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	83 ec 1c             	sub    $0x1c,%esp
  801814:	89 c7                	mov    %eax,%edi
  801816:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801818:	a1 20 60 80 00       	mov    0x806020,%eax
  80181d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	57                   	push   %edi
  801824:	e8 ac 09 00 00       	call   8021d5 <pageref>
  801829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80182c:	89 34 24             	mov    %esi,(%esp)
  80182f:	e8 a1 09 00 00       	call   8021d5 <pageref>
		nn = thisenv->env_runs;
  801834:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80183a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	39 cb                	cmp    %ecx,%ebx
  801842:	74 1b                	je     80185f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801844:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801847:	75 cf                	jne    801818 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801849:	8b 42 58             	mov    0x58(%edx),%eax
  80184c:	6a 01                	push   $0x1
  80184e:	50                   	push   %eax
  80184f:	53                   	push   %ebx
  801850:	68 e2 28 80 00       	push   $0x8028e2
  801855:	e8 0e ea ff ff       	call   800268 <cprintf>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	eb b9                	jmp    801818 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80185f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801862:	0f 94 c0             	sete   %al
  801865:	0f b6 c0             	movzbl %al,%eax
}
  801868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <devpipe_write>:
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	57                   	push   %edi
  801874:	56                   	push   %esi
  801875:	53                   	push   %ebx
  801876:	83 ec 28             	sub    $0x28,%esp
  801879:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80187c:	56                   	push   %esi
  80187d:	e8 d4 f5 ff ff       	call   800e56 <fd2data>
  801882:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	bf 00 00 00 00       	mov    $0x0,%edi
  80188c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80188f:	74 4f                	je     8018e0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801891:	8b 43 04             	mov    0x4(%ebx),%eax
  801894:	8b 0b                	mov    (%ebx),%ecx
  801896:	8d 51 20             	lea    0x20(%ecx),%edx
  801899:	39 d0                	cmp    %edx,%eax
  80189b:	72 14                	jb     8018b1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80189d:	89 da                	mov    %ebx,%edx
  80189f:	89 f0                	mov    %esi,%eax
  8018a1:	e8 65 ff ff ff       	call   80180b <_pipeisclosed>
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	75 3b                	jne    8018e5 <devpipe_write+0x75>
			sys_yield();
  8018aa:	e8 68 f3 ff ff       	call   800c17 <sys_yield>
  8018af:	eb e0                	jmp    801891 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018b8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018bb:	89 c2                	mov    %eax,%edx
  8018bd:	c1 fa 1f             	sar    $0x1f,%edx
  8018c0:	89 d1                	mov    %edx,%ecx
  8018c2:	c1 e9 1b             	shr    $0x1b,%ecx
  8018c5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018c8:	83 e2 1f             	and    $0x1f,%edx
  8018cb:	29 ca                	sub    %ecx,%edx
  8018cd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018d1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018d5:	83 c0 01             	add    $0x1,%eax
  8018d8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018db:	83 c7 01             	add    $0x1,%edi
  8018de:	eb ac                	jmp    80188c <devpipe_write+0x1c>
	return i;
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	eb 05                	jmp    8018ea <devpipe_write+0x7a>
				return 0;
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <devpipe_read>:
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	57                   	push   %edi
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
  8018f8:	83 ec 18             	sub    $0x18,%esp
  8018fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018fe:	57                   	push   %edi
  8018ff:	e8 52 f5 ff ff       	call   800e56 <fd2data>
  801904:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	be 00 00 00 00       	mov    $0x0,%esi
  80190e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801911:	75 14                	jne    801927 <devpipe_read+0x35>
	return i;
  801913:	8b 45 10             	mov    0x10(%ebp),%eax
  801916:	eb 02                	jmp    80191a <devpipe_read+0x28>
				return i;
  801918:	89 f0                	mov    %esi,%eax
}
  80191a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5f                   	pop    %edi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    
			sys_yield();
  801922:	e8 f0 f2 ff ff       	call   800c17 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801927:	8b 03                	mov    (%ebx),%eax
  801929:	3b 43 04             	cmp    0x4(%ebx),%eax
  80192c:	75 18                	jne    801946 <devpipe_read+0x54>
			if (i > 0)
  80192e:	85 f6                	test   %esi,%esi
  801930:	75 e6                	jne    801918 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801932:	89 da                	mov    %ebx,%edx
  801934:	89 f8                	mov    %edi,%eax
  801936:	e8 d0 fe ff ff       	call   80180b <_pipeisclosed>
  80193b:	85 c0                	test   %eax,%eax
  80193d:	74 e3                	je     801922 <devpipe_read+0x30>
				return 0;
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
  801944:	eb d4                	jmp    80191a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801946:	99                   	cltd   
  801947:	c1 ea 1b             	shr    $0x1b,%edx
  80194a:	01 d0                	add    %edx,%eax
  80194c:	83 e0 1f             	and    $0x1f,%eax
  80194f:	29 d0                	sub    %edx,%eax
  801951:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801956:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801959:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80195c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80195f:	83 c6 01             	add    $0x1,%esi
  801962:	eb aa                	jmp    80190e <devpipe_read+0x1c>

00801964 <pipe>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
  801969:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80196c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196f:	50                   	push   %eax
  801970:	e8 f8 f4 ff ff       	call   800e6d <fd_alloc>
  801975:	89 c3                	mov    %eax,%ebx
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	0f 88 23 01 00 00    	js     801aa5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 07 04 00 00       	push   $0x407
  80198a:	ff 75 f4             	pushl  -0xc(%ebp)
  80198d:	6a 00                	push   $0x0
  80198f:	e8 a2 f2 ff ff       	call   800c36 <sys_page_alloc>
  801994:	89 c3                	mov    %eax,%ebx
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	0f 88 04 01 00 00    	js     801aa5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	e8 c0 f4 ff ff       	call   800e6d <fd_alloc>
  8019ad:	89 c3                	mov    %eax,%ebx
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	0f 88 db 00 00 00    	js     801a95 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	68 07 04 00 00       	push   $0x407
  8019c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c5:	6a 00                	push   $0x0
  8019c7:	e8 6a f2 ff ff       	call   800c36 <sys_page_alloc>
  8019cc:	89 c3                	mov    %eax,%ebx
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	0f 88 bc 00 00 00    	js     801a95 <pipe+0x131>
	va = fd2data(fd0);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019df:	e8 72 f4 ff ff       	call   800e56 <fd2data>
  8019e4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e6:	83 c4 0c             	add    $0xc,%esp
  8019e9:	68 07 04 00 00       	push   $0x407
  8019ee:	50                   	push   %eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	e8 40 f2 ff ff       	call   800c36 <sys_page_alloc>
  8019f6:	89 c3                	mov    %eax,%ebx
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	0f 88 82 00 00 00    	js     801a85 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	ff 75 f0             	pushl  -0x10(%ebp)
  801a09:	e8 48 f4 ff ff       	call   800e56 <fd2data>
  801a0e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a15:	50                   	push   %eax
  801a16:	6a 00                	push   $0x0
  801a18:	56                   	push   %esi
  801a19:	6a 00                	push   $0x0
  801a1b:	e8 59 f2 ff ff       	call   800c79 <sys_page_map>
  801a20:	89 c3                	mov    %eax,%ebx
  801a22:	83 c4 20             	add    $0x20,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 4e                	js     801a77 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801a29:	a1 20 30 80 00       	mov    0x803020,%eax
  801a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a31:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a36:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a40:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a45:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a52:	e8 ef f3 ff ff       	call   800e46 <fd2num>
  801a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a5c:	83 c4 04             	add    $0x4,%esp
  801a5f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a62:	e8 df f3 ff ff       	call   800e46 <fd2num>
  801a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a75:	eb 2e                	jmp    801aa5 <pipe+0x141>
	sys_page_unmap(0, va);
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	56                   	push   %esi
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 39 f2 ff ff       	call   800cbb <sys_page_unmap>
  801a82:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a85:	83 ec 08             	sub    $0x8,%esp
  801a88:	ff 75 f0             	pushl  -0x10(%ebp)
  801a8b:	6a 00                	push   $0x0
  801a8d:	e8 29 f2 ff ff       	call   800cbb <sys_page_unmap>
  801a92:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9b:	6a 00                	push   $0x0
  801a9d:	e8 19 f2 ff ff       	call   800cbb <sys_page_unmap>
  801aa2:	83 c4 10             	add    $0x10,%esp
}
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    

00801aae <pipeisclosed>:
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab7:	50                   	push   %eax
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	e8 ff f3 ff ff       	call   800ebf <fd_lookup>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 18                	js     801adf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ac7:	83 ec 0c             	sub    $0xc,%esp
  801aca:	ff 75 f4             	pushl  -0xc(%ebp)
  801acd:	e8 84 f3 ff ff       	call   800e56 <fd2data>
	return _pipeisclosed(fd, p);
  801ad2:	89 c2                	mov    %eax,%edx
  801ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad7:	e8 2f fd ff ff       	call   80180b <_pipeisclosed>
  801adc:	83 c4 10             	add    $0x10,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ae7:	68 fa 28 80 00       	push   $0x8028fa
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	e8 50 ed ff ff       	call   800844 <strcpy>
	return 0;
}
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <devsock_close>:
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	53                   	push   %ebx
  801aff:	83 ec 10             	sub    $0x10,%esp
  801b02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b05:	53                   	push   %ebx
  801b06:	e8 ca 06 00 00       	call   8021d5 <pageref>
  801b0b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b0e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b13:	83 f8 01             	cmp    $0x1,%eax
  801b16:	74 07                	je     801b1f <devsock_close+0x24>
}
  801b18:	89 d0                	mov    %edx,%eax
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	ff 73 0c             	pushl  0xc(%ebx)
  801b25:	e8 b9 02 00 00       	call   801de3 <nsipc_close>
  801b2a:	89 c2                	mov    %eax,%edx
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	eb e7                	jmp    801b18 <devsock_close+0x1d>

00801b31 <devsock_write>:
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 10             	pushl  0x10(%ebp)
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	ff 70 0c             	pushl  0xc(%eax)
  801b45:	e8 76 03 00 00       	call   801ec0 <nsipc_send>
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <devsock_read>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 10             	pushl  0x10(%ebp)
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	ff 70 0c             	pushl  0xc(%eax)
  801b60:	e8 ef 02 00 00       	call   801e54 <nsipc_recv>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <fd2sockid>:
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b6d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	e8 48 f3 ff ff       	call   800ebf <fd_lookup>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 10                	js     801b8e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b81:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b87:	39 08                	cmp    %ecx,(%eax)
  801b89:	75 05                	jne    801b90 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b8b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    
		return -E_NOT_SUPP;
  801b90:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b95:	eb f7                	jmp    801b8e <fd2sockid+0x27>

00801b97 <alloc_sockfd>:
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ba1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba4:	50                   	push   %eax
  801ba5:	e8 c3 f2 ff ff       	call   800e6d <fd_alloc>
  801baa:	89 c3                	mov    %eax,%ebx
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 43                	js     801bf6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	68 07 04 00 00       	push   $0x407
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	6a 00                	push   $0x0
  801bc0:	e8 71 f0 ff ff       	call   800c36 <sys_page_alloc>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 28                	js     801bf6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bd7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801be3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801be6:	83 ec 0c             	sub    $0xc,%esp
  801be9:	50                   	push   %eax
  801bea:	e8 57 f2 ff ff       	call   800e46 <fd2num>
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	eb 0c                	jmp    801c02 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	56                   	push   %esi
  801bfa:	e8 e4 01 00 00       	call   801de3 <nsipc_close>
		return r;
  801bff:	83 c4 10             	add    $0x10,%esp
}
  801c02:	89 d8                	mov    %ebx,%eax
  801c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    

00801c0b <accept>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	e8 4e ff ff ff       	call   801b67 <fd2sockid>
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	78 1b                	js     801c38 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	ff 75 10             	pushl  0x10(%ebp)
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	50                   	push   %eax
  801c27:	e8 0e 01 00 00       	call   801d3a <nsipc_accept>
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 05                	js     801c38 <accept+0x2d>
	return alloc_sockfd(r);
  801c33:	e8 5f ff ff ff       	call   801b97 <alloc_sockfd>
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <bind>:
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	e8 1f ff ff ff       	call   801b67 <fd2sockid>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	78 12                	js     801c5e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	ff 75 10             	pushl  0x10(%ebp)
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	50                   	push   %eax
  801c56:	e8 31 01 00 00       	call   801d8c <nsipc_bind>
  801c5b:	83 c4 10             	add    $0x10,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <shutdown>:
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	e8 f9 fe ff ff       	call   801b67 <fd2sockid>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 0f                	js     801c81 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c72:	83 ec 08             	sub    $0x8,%esp
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	50                   	push   %eax
  801c79:	e8 43 01 00 00       	call   801dc1 <nsipc_shutdown>
  801c7e:	83 c4 10             	add    $0x10,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <connect>:
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	e8 d6 fe ff ff       	call   801b67 <fd2sockid>
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 12                	js     801ca7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	ff 75 10             	pushl  0x10(%ebp)
  801c9b:	ff 75 0c             	pushl  0xc(%ebp)
  801c9e:	50                   	push   %eax
  801c9f:	e8 59 01 00 00       	call   801dfd <nsipc_connect>
  801ca4:	83 c4 10             	add    $0x10,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <listen>:
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	e8 b0 fe ff ff       	call   801b67 <fd2sockid>
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	78 0f                	js     801cca <listen+0x21>
	return nsipc_listen(r, backlog);
  801cbb:	83 ec 08             	sub    $0x8,%esp
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	50                   	push   %eax
  801cc2:	e8 6b 01 00 00       	call   801e32 <nsipc_listen>
  801cc7:	83 c4 10             	add    $0x10,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <socket>:

int
socket(int domain, int type, int protocol)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cd2:	ff 75 10             	pushl  0x10(%ebp)
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	e8 3e 02 00 00       	call   801f1e <nsipc_socket>
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 05                	js     801cec <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ce7:	e8 ab fe ff ff       	call   801b97 <alloc_sockfd>
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	53                   	push   %ebx
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cf7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cfe:	74 26                	je     801d26 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d00:	6a 07                	push   $0x7
  801d02:	68 00 80 80 00       	push   $0x808000
  801d07:	53                   	push   %ebx
  801d08:	ff 35 04 40 80 00    	pushl  0x804004
  801d0e:	e8 1d 04 00 00       	call   802130 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d13:	83 c4 0c             	add    $0xc,%esp
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	e8 9c 03 00 00       	call   8020bd <ipc_recv>
}
  801d21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	6a 02                	push   $0x2
  801d2b:	e8 6c 04 00 00       	call   80219c <ipc_find_env>
  801d30:	a3 04 40 80 00       	mov    %eax,0x804004
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	eb c6                	jmp    801d00 <nsipc+0x12>

00801d3a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d4a:	8b 06                	mov    (%esi),%eax
  801d4c:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d51:	b8 01 00 00 00       	mov    $0x1,%eax
  801d56:	e8 93 ff ff ff       	call   801cee <nsipc>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	79 09                	jns    801d6a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	ff 35 10 80 80 00    	pushl  0x808010
  801d73:	68 00 80 80 00       	push   $0x808000
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	e8 52 ec ff ff       	call   8009d2 <memmove>
		*addrlen = ret->ret_addrlen;
  801d80:	a1 10 80 80 00       	mov    0x808010,%eax
  801d85:	89 06                	mov    %eax,(%esi)
  801d87:	83 c4 10             	add    $0x10,%esp
	return r;
  801d8a:	eb d5                	jmp    801d61 <nsipc_accept+0x27>

00801d8c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d9e:	53                   	push   %ebx
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	68 04 80 80 00       	push   $0x808004
  801da7:	e8 26 ec ff ff       	call   8009d2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dac:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801db2:	b8 02 00 00 00       	mov    $0x2,%eax
  801db7:	e8 32 ff ff ff       	call   801cee <nsipc>
}
  801dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd2:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801dd7:	b8 03 00 00 00       	mov    $0x3,%eax
  801ddc:	e8 0d ff ff ff       	call   801cee <nsipc>
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <nsipc_close>:

int
nsipc_close(int s)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801df1:	b8 04 00 00 00       	mov    $0x4,%eax
  801df6:	e8 f3 fe ff ff       	call   801cee <nsipc>
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	53                   	push   %ebx
  801e01:	83 ec 08             	sub    $0x8,%esp
  801e04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e0f:	53                   	push   %ebx
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	68 04 80 80 00       	push   $0x808004
  801e18:	e8 b5 eb ff ff       	call   8009d2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e1d:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801e23:	b8 05 00 00 00       	mov    $0x5,%eax
  801e28:	e8 c1 fe ff ff       	call   801cee <nsipc>
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801e48:	b8 06 00 00 00       	mov    $0x6,%eax
  801e4d:	e8 9c fe ff ff       	call   801cee <nsipc>
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	56                   	push   %esi
  801e58:	53                   	push   %ebx
  801e59:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801e64:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6d:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e72:	b8 07 00 00 00       	mov    $0x7,%eax
  801e77:	e8 72 fe ff ff       	call   801cee <nsipc>
  801e7c:	89 c3                	mov    %eax,%ebx
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 1f                	js     801ea1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e82:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e87:	7f 21                	jg     801eaa <nsipc_recv+0x56>
  801e89:	39 c6                	cmp    %eax,%esi
  801e8b:	7c 1d                	jl     801eaa <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	50                   	push   %eax
  801e91:	68 00 80 80 00       	push   $0x808000
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	e8 34 eb ff ff       	call   8009d2 <memmove>
  801e9e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ea1:	89 d8                	mov    %ebx,%eax
  801ea3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801eaa:	68 06 29 80 00       	push   $0x802906
  801eaf:	68 a8 28 80 00       	push   $0x8028a8
  801eb4:	6a 62                	push   $0x62
  801eb6:	68 1b 29 80 00       	push   $0x80291b
  801ebb:	e8 cd e2 ff ff       	call   80018d <_panic>

00801ec0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801ed2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ed8:	7f 2e                	jg     801f08 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	53                   	push   %ebx
  801ede:	ff 75 0c             	pushl  0xc(%ebp)
  801ee1:	68 0c 80 80 00       	push   $0x80800c
  801ee6:	e8 e7 ea ff ff       	call   8009d2 <memmove>
	nsipcbuf.send.req_size = size;
  801eeb:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef4:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801ef9:	b8 08 00 00 00       	mov    $0x8,%eax
  801efe:	e8 eb fd ff ff       	call   801cee <nsipc>
}
  801f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    
	assert(size < 1600);
  801f08:	68 27 29 80 00       	push   $0x802927
  801f0d:	68 a8 28 80 00       	push   $0x8028a8
  801f12:	6a 6d                	push   $0x6d
  801f14:	68 1b 29 80 00       	push   $0x80291b
  801f19:	e8 6f e2 ff ff       	call   80018d <_panic>

00801f1e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801f34:	8b 45 10             	mov    0x10(%ebp),%eax
  801f37:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801f3c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f41:	e8 a8 fd ff ff       	call   801cee <nsipc>
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4d:	c3                   	ret    

00801f4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f54:	68 33 29 80 00       	push   $0x802933
  801f59:	ff 75 0c             	pushl  0xc(%ebp)
  801f5c:	e8 e3 e8 ff ff       	call   800844 <strcpy>
	return 0;
}
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <devcons_write>:
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	57                   	push   %edi
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
  801f6e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f74:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f79:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f7f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f82:	73 31                	jae    801fb5 <devcons_write+0x4d>
		m = n - tot;
  801f84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f87:	29 f3                	sub    %esi,%ebx
  801f89:	83 fb 7f             	cmp    $0x7f,%ebx
  801f8c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f91:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f94:	83 ec 04             	sub    $0x4,%esp
  801f97:	53                   	push   %ebx
  801f98:	89 f0                	mov    %esi,%eax
  801f9a:	03 45 0c             	add    0xc(%ebp),%eax
  801f9d:	50                   	push   %eax
  801f9e:	57                   	push   %edi
  801f9f:	e8 2e ea ff ff       	call   8009d2 <memmove>
		sys_cputs(buf, m);
  801fa4:	83 c4 08             	add    $0x8,%esp
  801fa7:	53                   	push   %ebx
  801fa8:	57                   	push   %edi
  801fa9:	e8 cc eb ff ff       	call   800b7a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fae:	01 de                	add    %ebx,%esi
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	eb ca                	jmp    801f7f <devcons_write+0x17>
}
  801fb5:	89 f0                	mov    %esi,%eax
  801fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5e                   	pop    %esi
  801fbc:	5f                   	pop    %edi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <devcons_read>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fce:	74 21                	je     801ff1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801fd0:	e8 c3 eb ff ff       	call   800b98 <sys_cgetc>
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	75 07                	jne    801fe0 <devcons_read+0x21>
		sys_yield();
  801fd9:	e8 39 ec ff ff       	call   800c17 <sys_yield>
  801fde:	eb f0                	jmp    801fd0 <devcons_read+0x11>
	if (c < 0)
  801fe0:	78 0f                	js     801ff1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801fe2:	83 f8 04             	cmp    $0x4,%eax
  801fe5:	74 0c                	je     801ff3 <devcons_read+0x34>
	*(char*)vbuf = c;
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	88 02                	mov    %al,(%edx)
	return 1;
  801fec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    
		return 0;
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	eb f7                	jmp    801ff1 <devcons_read+0x32>

00801ffa <cputchar>:
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802006:	6a 01                	push   $0x1
  802008:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80200b:	50                   	push   %eax
  80200c:	e8 69 eb ff ff       	call   800b7a <sys_cputs>
}
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <getchar>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80201c:	6a 01                	push   $0x1
  80201e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802021:	50                   	push   %eax
  802022:	6a 00                	push   $0x0
  802024:	e8 06 f1 ff ff       	call   80112f <read>
	if (r < 0)
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 06                	js     802036 <getchar+0x20>
	if (r < 1)
  802030:	74 06                	je     802038 <getchar+0x22>
	return c;
  802032:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    
		return -E_EOF;
  802038:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80203d:	eb f7                	jmp    802036 <getchar+0x20>

0080203f <iscons>:
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802045:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802048:	50                   	push   %eax
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	e8 6e ee ff ff       	call   800ebf <fd_lookup>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	78 11                	js     802069 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802061:	39 10                	cmp    %edx,(%eax)
  802063:	0f 94 c0             	sete   %al
  802066:	0f b6 c0             	movzbl %al,%eax
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <opencons>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802074:	50                   	push   %eax
  802075:	e8 f3 ed ff ff       	call   800e6d <fd_alloc>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	85 c0                	test   %eax,%eax
  80207f:	78 3a                	js     8020bb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 07 04 00 00       	push   $0x407
  802089:	ff 75 f4             	pushl  -0xc(%ebp)
  80208c:	6a 00                	push   $0x0
  80208e:	e8 a3 eb ff ff       	call   800c36 <sys_page_alloc>
  802093:	83 c4 10             	add    $0x10,%esp
  802096:	85 c0                	test   %eax,%eax
  802098:	78 21                	js     8020bb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020a3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	50                   	push   %eax
  8020b3:	e8 8e ed ff ff       	call   800e46 <fd2num>
  8020b8:	83 c4 10             	add    $0x10,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8020c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	74 4f                	je     80211e <ipc_recv+0x61>
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	50                   	push   %eax
  8020d3:	e8 0e ed ff ff       	call   800de6 <sys_ipc_recv>
  8020d8:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8020db:	85 f6                	test   %esi,%esi
  8020dd:	74 14                	je     8020f3 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8020df:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	75 09                	jne    8020f1 <ipc_recv+0x34>
  8020e8:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8020ee:	8b 52 74             	mov    0x74(%edx),%edx
  8020f1:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8020f3:	85 db                	test   %ebx,%ebx
  8020f5:	74 14                	je     80210b <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8020f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 09                	jne    802109 <ipc_recv+0x4c>
  802100:	8b 15 20 60 80 00    	mov    0x806020,%edx
  802106:	8b 52 78             	mov    0x78(%edx),%edx
  802109:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80210b:	85 c0                	test   %eax,%eax
  80210d:	75 08                	jne    802117 <ipc_recv+0x5a>
  80210f:	a1 20 60 80 00       	mov    0x806020,%eax
  802114:	8b 40 70             	mov    0x70(%eax),%eax
}
  802117:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211a:	5b                   	pop    %ebx
  80211b:	5e                   	pop    %esi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	68 00 00 c0 ee       	push   $0xeec00000
  802126:	e8 bb ec ff ff       	call   800de6 <sys_ipc_recv>
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	eb ab                	jmp    8020db <ipc_recv+0x1e>

00802130 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	57                   	push   %edi
  802134:	56                   	push   %esi
  802135:	53                   	push   %ebx
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	8b 7d 08             	mov    0x8(%ebp),%edi
  80213c:	8b 75 10             	mov    0x10(%ebp),%esi
  80213f:	eb 20                	jmp    802161 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802141:	6a 00                	push   $0x0
  802143:	68 00 00 c0 ee       	push   $0xeec00000
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	57                   	push   %edi
  80214c:	e8 72 ec ff ff       	call   800dc3 <sys_ipc_try_send>
  802151:	89 c3                	mov    %eax,%ebx
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	eb 1f                	jmp    802177 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802158:	e8 ba ea ff ff       	call   800c17 <sys_yield>
	while(retval != 0) {
  80215d:	85 db                	test   %ebx,%ebx
  80215f:	74 33                	je     802194 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802161:	85 f6                	test   %esi,%esi
  802163:	74 dc                	je     802141 <ipc_send+0x11>
  802165:	ff 75 14             	pushl  0x14(%ebp)
  802168:	56                   	push   %esi
  802169:	ff 75 0c             	pushl  0xc(%ebp)
  80216c:	57                   	push   %edi
  80216d:	e8 51 ec ff ff       	call   800dc3 <sys_ipc_try_send>
  802172:	89 c3                	mov    %eax,%ebx
  802174:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802177:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80217a:	74 dc                	je     802158 <ipc_send+0x28>
  80217c:	85 db                	test   %ebx,%ebx
  80217e:	74 d8                	je     802158 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802180:	83 ec 04             	sub    $0x4,%esp
  802183:	68 40 29 80 00       	push   $0x802940
  802188:	6a 35                	push   $0x35
  80218a:	68 70 29 80 00       	push   $0x802970
  80218f:	e8 f9 df ff ff       	call   80018d <_panic>
	}
}
  802194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802197:	5b                   	pop    %ebx
  802198:	5e                   	pop    %esi
  802199:	5f                   	pop    %edi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021a7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021aa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b0:	8b 52 50             	mov    0x50(%edx),%edx
  8021b3:	39 ca                	cmp    %ecx,%edx
  8021b5:	74 11                	je     8021c8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021b7:	83 c0 01             	add    $0x1,%eax
  8021ba:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021bf:	75 e6                	jne    8021a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c6:	eb 0b                	jmp    8021d3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8021c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    

008021d5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021db:	89 d0                	mov    %edx,%eax
  8021dd:	c1 e8 16             	shr    $0x16,%eax
  8021e0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021ec:	f6 c1 01             	test   $0x1,%cl
  8021ef:	74 1d                	je     80220e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021f1:	c1 ea 0c             	shr    $0xc,%edx
  8021f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021fb:	f6 c2 01             	test   $0x1,%dl
  8021fe:	74 0e                	je     80220e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802200:	c1 ea 0c             	shr    $0xc,%edx
  802203:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80220a:	ef 
  80220b:	0f b7 c0             	movzwl %ax,%eax
}
  80220e:	5d                   	pop    %ebp
  80220f:	c3                   	ret    

00802210 <__udivdi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80222b:	85 d2                	test   %edx,%edx
  80222d:	75 49                	jne    802278 <__udivdi3+0x68>
  80222f:	39 f3                	cmp    %esi,%ebx
  802231:	76 15                	jbe    802248 <__udivdi3+0x38>
  802233:	31 ff                	xor    %edi,%edi
  802235:	89 e8                	mov    %ebp,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 f3                	div    %ebx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	89 d9                	mov    %ebx,%ecx
  80224a:	85 db                	test   %ebx,%ebx
  80224c:	75 0b                	jne    802259 <__udivdi3+0x49>
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f3                	div    %ebx
  802257:	89 c1                	mov    %eax,%ecx
  802259:	31 d2                	xor    %edx,%edx
  80225b:	89 f0                	mov    %esi,%eax
  80225d:	f7 f1                	div    %ecx
  80225f:	89 c6                	mov    %eax,%esi
  802261:	89 e8                	mov    %ebp,%eax
  802263:	89 f7                	mov    %esi,%edi
  802265:	f7 f1                	div    %ecx
  802267:	89 fa                	mov    %edi,%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	77 1c                	ja     802298 <__udivdi3+0x88>
  80227c:	0f bd fa             	bsr    %edx,%edi
  80227f:	83 f7 1f             	xor    $0x1f,%edi
  802282:	75 2c                	jne    8022b0 <__udivdi3+0xa0>
  802284:	39 f2                	cmp    %esi,%edx
  802286:	72 06                	jb     80228e <__udivdi3+0x7e>
  802288:	31 c0                	xor    %eax,%eax
  80228a:	39 eb                	cmp    %ebp,%ebx
  80228c:	77 ad                	ja     80223b <__udivdi3+0x2b>
  80228e:	b8 01 00 00 00       	mov    $0x1,%eax
  802293:	eb a6                	jmp    80223b <__udivdi3+0x2b>
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	31 ff                	xor    %edi,%edi
  80229a:	31 c0                	xor    %eax,%eax
  80229c:	89 fa                	mov    %edi,%edx
  80229e:	83 c4 1c             	add    $0x1c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 2b ff ff ff       	jmp    80223b <__udivdi3+0x2b>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 21 ff ff ff       	jmp    80223b <__udivdi3+0x2b>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80232f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802333:	8b 74 24 30          	mov    0x30(%esp),%esi
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	89 da                	mov    %ebx,%edx
  80233d:	85 c0                	test   %eax,%eax
  80233f:	75 3f                	jne    802380 <__umoddi3+0x60>
  802341:	39 df                	cmp    %ebx,%edi
  802343:	76 13                	jbe    802358 <__umoddi3+0x38>
  802345:	89 f0                	mov    %esi,%eax
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 fd                	mov    %edi,%ebp
  80235a:	85 ff                	test   %edi,%edi
  80235c:	75 0b                	jne    802369 <__umoddi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c5                	mov    %eax,%ebp
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f5                	div    %ebp
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f5                	div    %ebp
  802373:	89 d0                	mov    %edx,%eax
  802375:	eb d4                	jmp    80234b <__umoddi3+0x2b>
  802377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 f1                	mov    %esi,%ecx
  802382:	39 d8                	cmp    %ebx,%eax
  802384:	76 0a                	jbe    802390 <__umoddi3+0x70>
  802386:	89 f0                	mov    %esi,%eax
  802388:	83 c4 1c             	add    $0x1c,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    
  802390:	0f bd e8             	bsr    %eax,%ebp
  802393:	83 f5 1f             	xor    $0x1f,%ebp
  802396:	75 20                	jne    8023b8 <__umoddi3+0x98>
  802398:	39 d8                	cmp    %ebx,%eax
  80239a:	0f 82 b0 00 00 00    	jb     802450 <__umoddi3+0x130>
  8023a0:	39 f7                	cmp    %esi,%edi
  8023a2:	0f 86 a8 00 00 00    	jbe    802450 <__umoddi3+0x130>
  8023a8:	89 c8                	mov    %ecx,%eax
  8023aa:	83 c4 1c             	add    $0x1c,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0xfb>
  802415:	75 10                	jne    802427 <__umoddi3+0x107>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x107>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 da                	mov    %ebx,%edx
  802452:	29 fe                	sub    %edi,%esi
  802454:	19 c2                	sbb    %eax,%edx
  802456:	89 f1                	mov    %esi,%ecx
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	e9 4b ff ff ff       	jmp    8023aa <__umoddi3+0x8a>
