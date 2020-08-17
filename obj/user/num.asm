
obj/user/num.debug：     文件格式 elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 c0 24 80 00       	push   $0x8024c0
  800059:	e8 73 17 00 00       	call   8017d1 <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 d7 11 00 00       	call   80124f <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 f1 10 00 00       	call   801183 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 c5 24 80 00       	push   $0x8024c5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 e0 24 80 00       	push   $0x8024e0
  8000b7:	e8 25 01 00 00       	call   8001e1 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 eb 24 80 00       	push   $0x8024eb
  8000dd:	6a 18                	push   $0x18
  8000df:	68 e0 24 80 00       	push   $0x8024e0
  8000e4:	e8 f8 00 00 00       	call   8001e1 <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 00 	movl   $0x802500,0x803004
  8000f9:	25 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 0d 15 00 00       	call   80162e <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 08 0f 00 00       	call   801045 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 25 80 00       	push   $0x802504
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 68 00 00 00       	call   8001c7 <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 0c 25 80 00       	push   $0x80250c
  800175:	6a 27                	push   $0x27
  800177:	68 e0 24 80 00       	push   $0x8024e0
  80017c:	e8 60 00 00 00       	call   8001e1 <_panic>

00800181 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800189:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018c:	e8 bb 0a 00 00       	call   800c4c <sys_getenvid>
  800191:	25 ff 03 00 00       	and    $0x3ff,%eax
  800196:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800199:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80019e:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a3:	85 db                	test   %ebx,%ebx
  8001a5:	7e 07                	jle    8001ae <libmain+0x2d>
		binaryname = argv[0];
  8001a7:	8b 06                	mov    (%esi),%eax
  8001a9:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	e8 31 ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001b8:	e8 0a 00 00 00       	call   8001c7 <exit>
}
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001cd:	e8 a0 0e 00 00       	call   801072 <close_all>
	sys_env_destroy(0);
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	6a 00                	push   $0x0
  8001d7:	e8 2f 0a 00 00       	call   800c0b <sys_env_destroy>
}
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e9:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001ef:	e8 58 0a 00 00       	call   800c4c <sys_getenvid>
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	56                   	push   %esi
  8001fe:	50                   	push   %eax
  8001ff:	68 28 25 80 00       	push   $0x802528
  800204:	e8 b3 00 00 00       	call   8002bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800209:	83 c4 18             	add    $0x18,%esp
  80020c:	53                   	push   %ebx
  80020d:	ff 75 10             	pushl  0x10(%ebp)
  800210:	e8 56 00 00 00       	call   80026b <vcprintf>
	cprintf("\n");
  800215:	c7 04 24 53 29 80 00 	movl   $0x802953,(%esp)
  80021c:	e8 9b 00 00 00       	call   8002bc <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800224:	cc                   	int3   
  800225:	eb fd                	jmp    800224 <_panic+0x43>

00800227 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	53                   	push   %ebx
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800231:	8b 13                	mov    (%ebx),%edx
  800233:	8d 42 01             	lea    0x1(%edx),%eax
  800236:	89 03                	mov    %eax,(%ebx)
  800238:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80023f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800244:	74 09                	je     80024f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800246:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	68 ff 00 00 00       	push   $0xff
  800257:	8d 43 08             	lea    0x8(%ebx),%eax
  80025a:	50                   	push   %eax
  80025b:	e8 6e 09 00 00       	call   800bce <sys_cputs>
		b->idx = 0;
  800260:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb db                	jmp    800246 <putch+0x1f>

0080026b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800274:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027b:	00 00 00 
	b.cnt = 0;
  80027e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800285:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800288:	ff 75 0c             	pushl  0xc(%ebp)
  80028b:	ff 75 08             	pushl  0x8(%ebp)
  80028e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800294:	50                   	push   %eax
  800295:	68 27 02 80 00       	push   $0x800227
  80029a:	e8 19 01 00 00       	call   8003b8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029f:	83 c4 08             	add    $0x8,%esp
  8002a2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ae:	50                   	push   %eax
  8002af:	e8 1a 09 00 00       	call   800bce <sys_cputs>

	return b.cnt;
}
  8002b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c5:	50                   	push   %eax
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	e8 9d ff ff ff       	call   80026b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 1c             	sub    $0x1c,%esp
  8002d9:	89 c7                	mov    %eax,%edi
  8002db:	89 d6                	mov    %edx,%esi
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002f4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002f7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fa:	89 d0                	mov    %edx,%eax
  8002fc:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8002ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800302:	73 15                	jae    800319 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800304:	83 eb 01             	sub    $0x1,%ebx
  800307:	85 db                	test   %ebx,%ebx
  800309:	7e 43                	jle    80034e <printnum+0x7e>
			putch(padc, putdat);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	ff 75 18             	pushl  0x18(%ebp)
  800312:	ff d7                	call   *%edi
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	eb eb                	jmp    800304 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 18             	pushl  0x18(%ebp)
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800325:	53                   	push   %ebx
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032f:	ff 75 e0             	pushl  -0x20(%ebp)
  800332:	ff 75 dc             	pushl  -0x24(%ebp)
  800335:	ff 75 d8             	pushl  -0x28(%ebp)
  800338:	e8 33 1f 00 00       	call   802270 <__udivdi3>
  80033d:	83 c4 18             	add    $0x18,%esp
  800340:	52                   	push   %edx
  800341:	50                   	push   %eax
  800342:	89 f2                	mov    %esi,%edx
  800344:	89 f8                	mov    %edi,%eax
  800346:	e8 85 ff ff ff       	call   8002d0 <printnum>
  80034b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	56                   	push   %esi
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	ff 75 e4             	pushl  -0x1c(%ebp)
  800358:	ff 75 e0             	pushl  -0x20(%ebp)
  80035b:	ff 75 dc             	pushl  -0x24(%ebp)
  80035e:	ff 75 d8             	pushl  -0x28(%ebp)
  800361:	e8 1a 20 00 00       	call   802380 <__umoddi3>
  800366:	83 c4 14             	add    $0x14,%esp
  800369:	0f be 80 4b 25 80 00 	movsbl 0x80254b(%eax),%eax
  800370:	50                   	push   %eax
  800371:	ff d7                	call   *%edi
}
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800379:	5b                   	pop    %ebx
  80037a:	5e                   	pop    %esi
  80037b:	5f                   	pop    %edi
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800384:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800388:	8b 10                	mov    (%eax),%edx
  80038a:	3b 50 04             	cmp    0x4(%eax),%edx
  80038d:	73 0a                	jae    800399 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800392:	89 08                	mov    %ecx,(%eax)
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	88 02                	mov    %al,(%edx)
}
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    

0080039b <printfmt>:
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a4:	50                   	push   %eax
  8003a5:	ff 75 10             	pushl  0x10(%ebp)
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 08             	pushl  0x8(%ebp)
  8003ae:	e8 05 00 00 00       	call   8003b8 <vprintfmt>
}
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    

008003b8 <vprintfmt>:
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	57                   	push   %edi
  8003bc:	56                   	push   %esi
  8003bd:	53                   	push   %ebx
  8003be:	83 ec 3c             	sub    $0x3c,%esp
  8003c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ca:	eb 0a                	jmp    8003d6 <vprintfmt+0x1e>
			putch(ch, putdat);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	53                   	push   %ebx
  8003d0:	50                   	push   %eax
  8003d1:	ff d6                	call   *%esi
  8003d3:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d6:	83 c7 01             	add    $0x1,%edi
  8003d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003dd:	83 f8 25             	cmp    $0x25,%eax
  8003e0:	74 0c                	je     8003ee <vprintfmt+0x36>
			if (ch == '\0')
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	75 e6                	jne    8003cc <vprintfmt+0x14>
}
  8003e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5f                   	pop    %edi
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    
		padc = ' ';
  8003ee:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003f2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003f9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800400:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800407:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040c:	8d 47 01             	lea    0x1(%edi),%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800412:	0f b6 17             	movzbl (%edi),%edx
  800415:	8d 42 dd             	lea    -0x23(%edx),%eax
  800418:	3c 55                	cmp    $0x55,%al
  80041a:	0f 87 ba 03 00 00    	ja     8007da <vprintfmt+0x422>
  800420:	0f b6 c0             	movzbl %al,%eax
  800423:	ff 24 85 80 26 80 00 	jmp    *0x802680(,%eax,4)
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80042d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800431:	eb d9                	jmp    80040c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800436:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80043a:	eb d0                	jmp    80040c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80043c:	0f b6 d2             	movzbl %dl,%edx
  80043f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80044a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80044d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800451:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800454:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800457:	83 f9 09             	cmp    $0x9,%ecx
  80045a:	77 55                	ja     8004b1 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80045c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80045f:	eb e9                	jmp    80044a <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800461:	8b 45 14             	mov    0x14(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800469:	8b 45 14             	mov    0x14(%ebp),%eax
  80046c:	8d 40 04             	lea    0x4(%eax),%eax
  80046f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	79 91                	jns    80040c <vprintfmt+0x54>
				width = precision, precision = -1;
  80047b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800481:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800488:	eb 82                	jmp    80040c <vprintfmt+0x54>
  80048a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048d:	85 c0                	test   %eax,%eax
  80048f:	ba 00 00 00 00       	mov    $0x0,%edx
  800494:	0f 49 d0             	cmovns %eax,%edx
  800497:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80049d:	e9 6a ff ff ff       	jmp    80040c <vprintfmt+0x54>
  8004a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004a5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004ac:	e9 5b ff ff ff       	jmp    80040c <vprintfmt+0x54>
  8004b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	eb bc                	jmp    800475 <vprintfmt+0xbd>
			lflag++;
  8004b9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004bf:	e9 48 ff ff ff       	jmp    80040c <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 78 04             	lea    0x4(%eax),%edi
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	53                   	push   %ebx
  8004ce:	ff 30                	pushl  (%eax)
  8004d0:	ff d6                	call   *%esi
			break;
  8004d2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004d8:	e9 9c 02 00 00       	jmp    800779 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 78 04             	lea    0x4(%eax),%edi
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	99                   	cltd   
  8004e6:	31 d0                	xor    %edx,%eax
  8004e8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ea:	83 f8 0f             	cmp    $0xf,%eax
  8004ed:	7f 23                	jg     800512 <vprintfmt+0x15a>
  8004ef:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8004f6:	85 d2                	test   %edx,%edx
  8004f8:	74 18                	je     800512 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8004fa:	52                   	push   %edx
  8004fb:	68 1a 29 80 00       	push   $0x80291a
  800500:	53                   	push   %ebx
  800501:	56                   	push   %esi
  800502:	e8 94 fe ff ff       	call   80039b <printfmt>
  800507:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80050d:	e9 67 02 00 00       	jmp    800779 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800512:	50                   	push   %eax
  800513:	68 63 25 80 00       	push   $0x802563
  800518:	53                   	push   %ebx
  800519:	56                   	push   %esi
  80051a:	e8 7c fe ff ff       	call   80039b <printfmt>
  80051f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800522:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800525:	e9 4f 02 00 00       	jmp    800779 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	83 c0 04             	add    $0x4,%eax
  800530:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800538:	85 d2                	test   %edx,%edx
  80053a:	b8 5c 25 80 00       	mov    $0x80255c,%eax
  80053f:	0f 45 c2             	cmovne %edx,%eax
  800542:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800549:	7e 06                	jle    800551 <vprintfmt+0x199>
  80054b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80054f:	75 0d                	jne    80055e <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800554:	89 c7                	mov    %eax,%edi
  800556:	03 45 e0             	add    -0x20(%ebp),%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055c:	eb 3f                	jmp    80059d <vprintfmt+0x1e5>
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 d8             	pushl  -0x28(%ebp)
  800564:	50                   	push   %eax
  800565:	e8 0d 03 00 00       	call   800877 <strnlen>
  80056a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056d:	29 c2                	sub    %eax,%edx
  80056f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800577:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80057b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80057e:	85 ff                	test   %edi,%edi
  800580:	7e 58                	jle    8005da <vprintfmt+0x222>
					putch(padc, putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	53                   	push   %ebx
  800586:	ff 75 e0             	pushl  -0x20(%ebp)
  800589:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	83 ef 01             	sub    $0x1,%edi
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	eb eb                	jmp    80057e <vprintfmt+0x1c6>
					putch(ch, putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	52                   	push   %edx
  800598:	ff d6                	call   *%esi
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a2:	83 c7 01             	add    $0x1,%edi
  8005a5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a9:	0f be d0             	movsbl %al,%edx
  8005ac:	85 d2                	test   %edx,%edx
  8005ae:	74 45                	je     8005f5 <vprintfmt+0x23d>
  8005b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b4:	78 06                	js     8005bc <vprintfmt+0x204>
  8005b6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ba:	78 35                	js     8005f1 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8005bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c0:	74 d1                	je     800593 <vprintfmt+0x1db>
  8005c2:	0f be c0             	movsbl %al,%eax
  8005c5:	83 e8 20             	sub    $0x20,%eax
  8005c8:	83 f8 5e             	cmp    $0x5e,%eax
  8005cb:	76 c6                	jbe    800593 <vprintfmt+0x1db>
					putch('?', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 3f                	push   $0x3f
  8005d3:	ff d6                	call   *%esi
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	eb c3                	jmp    80059d <vprintfmt+0x1e5>
  8005da:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005dd:	85 d2                	test   %edx,%edx
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	0f 49 c2             	cmovns %edx,%eax
  8005e7:	29 c2                	sub    %eax,%edx
  8005e9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005ec:	e9 60 ff ff ff       	jmp    800551 <vprintfmt+0x199>
  8005f1:	89 cf                	mov    %ecx,%edi
  8005f3:	eb 02                	jmp    8005f7 <vprintfmt+0x23f>
  8005f5:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8005f7:	85 ff                	test   %edi,%edi
  8005f9:	7e 10                	jle    80060b <vprintfmt+0x253>
				putch(' ', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 20                	push   $0x20
  800601:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800603:	83 ef 01             	sub    $0x1,%edi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	eb ec                	jmp    8005f7 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80060b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	e9 63 01 00 00       	jmp    800779 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800616:	83 f9 01             	cmp    $0x1,%ecx
  800619:	7f 1b                	jg     800636 <vprintfmt+0x27e>
	else if (lflag)
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	74 63                	je     800682 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	99                   	cltd   
  800628:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	eb 17                	jmp    80064d <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 50 04             	mov    0x4(%eax),%edx
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 08             	lea    0x8(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80064d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800650:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800658:	85 c9                	test   %ecx,%ecx
  80065a:	0f 89 ff 00 00 00    	jns    80075f <vprintfmt+0x3a7>
				putch('-', putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 2d                	push   $0x2d
  800666:	ff d6                	call   *%esi
				num = -(long long) num;
  800668:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80066e:	f7 da                	neg    %edx
  800670:	83 d1 00             	adc    $0x0,%ecx
  800673:	f7 d9                	neg    %ecx
  800675:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800678:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067d:	e9 dd 00 00 00       	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	99                   	cltd   
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
  800697:	eb b4                	jmp    80064d <vprintfmt+0x295>
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7f 1e                	jg     8006bc <vprintfmt+0x304>
	else if (lflag)
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	74 32                	je     8006d4 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b7:	e9 a3 00 00 00       	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 10                	mov    (%eax),%edx
  8006c1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c4:	8d 40 08             	lea    0x8(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cf:	e9 8b 00 00 00       	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	eb 74                	jmp    80075f <vprintfmt+0x3a7>
	if (lflag >= 2)
  8006eb:	83 f9 01             	cmp    $0x1,%ecx
  8006ee:	7f 1b                	jg     80070b <vprintfmt+0x353>
	else if (lflag)
  8006f0:	85 c9                	test   %ecx,%ecx
  8006f2:	74 2c                	je     800720 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 10                	mov    (%eax),%edx
  8006f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800704:	b8 08 00 00 00       	mov    $0x8,%eax
  800709:	eb 54                	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 10                	mov    (%eax),%edx
  800710:	8b 48 04             	mov    0x4(%eax),%ecx
  800713:	8d 40 08             	lea    0x8(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800719:	b8 08 00 00 00       	mov    $0x8,%eax
  80071e:	eb 3f                	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 10                	mov    (%eax),%edx
  800725:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800730:	b8 08 00 00 00       	mov    $0x8,%eax
  800735:	eb 28                	jmp    80075f <vprintfmt+0x3a7>
			putch('0', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	53                   	push   %ebx
  80073b:	6a 30                	push   $0x30
  80073d:	ff d6                	call   *%esi
			putch('x', putdat);
  80073f:	83 c4 08             	add    $0x8,%esp
  800742:	53                   	push   %ebx
  800743:	6a 78                	push   $0x78
  800745:	ff d6                	call   *%esi
			num = (unsigned long long)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 10                	mov    (%eax),%edx
  80074c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800751:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80075f:	83 ec 0c             	sub    $0xc,%esp
  800762:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800766:	57                   	push   %edi
  800767:	ff 75 e0             	pushl  -0x20(%ebp)
  80076a:	50                   	push   %eax
  80076b:	51                   	push   %ecx
  80076c:	52                   	push   %edx
  80076d:	89 da                	mov    %ebx,%edx
  80076f:	89 f0                	mov    %esi,%eax
  800771:	e8 5a fb ff ff       	call   8002d0 <printnum>
			break;
  800776:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800779:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077c:	e9 55 fc ff ff       	jmp    8003d6 <vprintfmt+0x1e>
	if (lflag >= 2)
  800781:	83 f9 01             	cmp    $0x1,%ecx
  800784:	7f 1b                	jg     8007a1 <vprintfmt+0x3e9>
	else if (lflag)
  800786:	85 c9                	test   %ecx,%ecx
  800788:	74 2c                	je     8007b6 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8b 10                	mov    (%eax),%edx
  80078f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079a:	b8 10 00 00 00       	mov    $0x10,%eax
  80079f:	eb be                	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8b 10                	mov    (%eax),%edx
  8007a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a9:	8d 40 08             	lea    0x8(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b4:	eb a9                	jmp    80075f <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 10                	mov    (%eax),%edx
  8007bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cb:	eb 92                	jmp    80075f <vprintfmt+0x3a7>
			putch(ch, putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 25                	push   $0x25
  8007d3:	ff d6                	call   *%esi
			break;
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	eb 9f                	jmp    800779 <vprintfmt+0x3c1>
			putch('%', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	53                   	push   %ebx
  8007de:	6a 25                	push   $0x25
  8007e0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 f8                	mov    %edi,%eax
  8007e7:	eb 03                	jmp    8007ec <vprintfmt+0x434>
  8007e9:	83 e8 01             	sub    $0x1,%eax
  8007ec:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f0:	75 f7                	jne    8007e9 <vprintfmt+0x431>
  8007f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f5:	eb 82                	jmp    800779 <vprintfmt+0x3c1>

008007f7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	83 ec 18             	sub    $0x18,%esp
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800803:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800806:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80080a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800814:	85 c0                	test   %eax,%eax
  800816:	74 26                	je     80083e <vsnprintf+0x47>
  800818:	85 d2                	test   %edx,%edx
  80081a:	7e 22                	jle    80083e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081c:	ff 75 14             	pushl  0x14(%ebp)
  80081f:	ff 75 10             	pushl  0x10(%ebp)
  800822:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	68 7e 03 80 00       	push   $0x80037e
  80082b:	e8 88 fb ff ff       	call   8003b8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800833:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800839:	83 c4 10             	add    $0x10,%esp
}
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    
		return -E_INVAL;
  80083e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800843:	eb f7                	jmp    80083c <vsnprintf+0x45>

00800845 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80084b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80084e:	50                   	push   %eax
  80084f:	ff 75 10             	pushl  0x10(%ebp)
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 9a ff ff ff       	call   8007f7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    

0080085f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800865:	b8 00 00 00 00       	mov    $0x0,%eax
  80086a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086e:	74 05                	je     800875 <strlen+0x16>
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
  800873:	eb f5                	jmp    80086a <strlen+0xb>
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800880:	ba 00 00 00 00       	mov    $0x0,%edx
  800885:	39 c2                	cmp    %eax,%edx
  800887:	74 0d                	je     800896 <strnlen+0x1f>
  800889:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80088d:	74 05                	je     800894 <strnlen+0x1d>
		n++;
  80088f:	83 c2 01             	add    $0x1,%edx
  800892:	eb f1                	jmp    800885 <strnlen+0xe>
  800894:	89 d0                	mov    %edx,%eax
	return n;
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	53                   	push   %ebx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ae:	83 c2 01             	add    $0x1,%edx
  8008b1:	84 c9                	test   %cl,%cl
  8008b3:	75 f2                	jne    8008a7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	83 ec 10             	sub    $0x10,%esp
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c2:	53                   	push   %ebx
  8008c3:	e8 97 ff ff ff       	call   80085f <strlen>
  8008c8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	01 d8                	add    %ebx,%eax
  8008d0:	50                   	push   %eax
  8008d1:	e8 c2 ff ff ff       	call   800898 <strcpy>
	return dst;
}
  8008d6:	89 d8                	mov    %ebx,%eax
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e8:	89 c6                	mov    %eax,%esi
  8008ea:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	39 f2                	cmp    %esi,%edx
  8008f1:	74 11                	je     800904 <strncpy+0x27>
		*dst++ = *src;
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	0f b6 19             	movzbl (%ecx),%ebx
  8008f9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008fc:	80 fb 01             	cmp    $0x1,%bl
  8008ff:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800902:	eb eb                	jmp    8008ef <strncpy+0x12>
	}
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	8b 75 08             	mov    0x8(%ebp),%esi
  800910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800913:	8b 55 10             	mov    0x10(%ebp),%edx
  800916:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800918:	85 d2                	test   %edx,%edx
  80091a:	74 21                	je     80093d <strlcpy+0x35>
  80091c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800920:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800922:	39 c2                	cmp    %eax,%edx
  800924:	74 14                	je     80093a <strlcpy+0x32>
  800926:	0f b6 19             	movzbl (%ecx),%ebx
  800929:	84 db                	test   %bl,%bl
  80092b:	74 0b                	je     800938 <strlcpy+0x30>
			*dst++ = *src++;
  80092d:	83 c1 01             	add    $0x1,%ecx
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	88 5a ff             	mov    %bl,-0x1(%edx)
  800936:	eb ea                	jmp    800922 <strlcpy+0x1a>
  800938:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80093a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80093d:	29 f0                	sub    %esi,%eax
}
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094c:	0f b6 01             	movzbl (%ecx),%eax
  80094f:	84 c0                	test   %al,%al
  800951:	74 0c                	je     80095f <strcmp+0x1c>
  800953:	3a 02                	cmp    (%edx),%al
  800955:	75 08                	jne    80095f <strcmp+0x1c>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
  80095d:	eb ed                	jmp    80094c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80095f:	0f b6 c0             	movzbl %al,%eax
  800962:	0f b6 12             	movzbl (%edx),%edx
  800965:	29 d0                	sub    %edx,%eax
}
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	89 c3                	mov    %eax,%ebx
  800975:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800978:	eb 06                	jmp    800980 <strncmp+0x17>
		n--, p++, q++;
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800980:	39 d8                	cmp    %ebx,%eax
  800982:	74 16                	je     80099a <strncmp+0x31>
  800984:	0f b6 08             	movzbl (%eax),%ecx
  800987:	84 c9                	test   %cl,%cl
  800989:	74 04                	je     80098f <strncmp+0x26>
  80098b:	3a 0a                	cmp    (%edx),%cl
  80098d:	74 eb                	je     80097a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80098f:	0f b6 00             	movzbl (%eax),%eax
  800992:	0f b6 12             	movzbl (%edx),%edx
  800995:	29 d0                	sub    %edx,%eax
}
  800997:	5b                   	pop    %ebx
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    
		return 0;
  80099a:	b8 00 00 00 00       	mov    $0x0,%eax
  80099f:	eb f6                	jmp    800997 <strncmp+0x2e>

008009a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ab:	0f b6 10             	movzbl (%eax),%edx
  8009ae:	84 d2                	test   %dl,%dl
  8009b0:	74 09                	je     8009bb <strchr+0x1a>
		if (*s == c)
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 0a                	je     8009c0 <strchr+0x1f>
	for (; *s; s++)
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	eb f0                	jmp    8009ab <strchr+0xa>
			return (char *) s;
	return 0;
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009cc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009cf:	38 ca                	cmp    %cl,%dl
  8009d1:	74 09                	je     8009dc <strfind+0x1a>
  8009d3:	84 d2                	test   %dl,%dl
  8009d5:	74 05                	je     8009dc <strfind+0x1a>
	for (; *s; s++)
  8009d7:	83 c0 01             	add    $0x1,%eax
  8009da:	eb f0                	jmp    8009cc <strfind+0xa>
			break;
	return (char *) s;
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	57                   	push   %edi
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ea:	85 c9                	test   %ecx,%ecx
  8009ec:	74 31                	je     800a1f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ee:	89 f8                	mov    %edi,%eax
  8009f0:	09 c8                	or     %ecx,%eax
  8009f2:	a8 03                	test   $0x3,%al
  8009f4:	75 23                	jne    800a19 <memset+0x3b>
		c &= 0xFF;
  8009f6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fa:	89 d3                	mov    %edx,%ebx
  8009fc:	c1 e3 08             	shl    $0x8,%ebx
  8009ff:	89 d0                	mov    %edx,%eax
  800a01:	c1 e0 18             	shl    $0x18,%eax
  800a04:	89 d6                	mov    %edx,%esi
  800a06:	c1 e6 10             	shl    $0x10,%esi
  800a09:	09 f0                	or     %esi,%eax
  800a0b:	09 c2                	or     %eax,%edx
  800a0d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a0f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	fc                   	cld    
  800a15:	f3 ab                	rep stos %eax,%es:(%edi)
  800a17:	eb 06                	jmp    800a1f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	fc                   	cld    
  800a1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1f:	89 f8                	mov    %edi,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a34:	39 c6                	cmp    %eax,%esi
  800a36:	73 32                	jae    800a6a <memmove+0x44>
  800a38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3b:	39 c2                	cmp    %eax,%edx
  800a3d:	76 2b                	jbe    800a6a <memmove+0x44>
		s += n;
		d += n;
  800a3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a42:	89 fe                	mov    %edi,%esi
  800a44:	09 ce                	or     %ecx,%esi
  800a46:	09 d6                	or     %edx,%esi
  800a48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4e:	75 0e                	jne    800a5e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a50:	83 ef 04             	sub    $0x4,%edi
  800a53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a59:	fd                   	std    
  800a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5c:	eb 09                	jmp    800a67 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5e:	83 ef 01             	sub    $0x1,%edi
  800a61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a64:	fd                   	std    
  800a65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a67:	fc                   	cld    
  800a68:	eb 1a                	jmp    800a84 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	09 ca                	or     %ecx,%edx
  800a6e:	09 f2                	or     %esi,%edx
  800a70:	f6 c2 03             	test   $0x3,%dl
  800a73:	75 0a                	jne    800a7f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a78:	89 c7                	mov    %eax,%edi
  800a7a:	fc                   	cld    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb 05                	jmp    800a84 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a7f:	89 c7                	mov    %eax,%edi
  800a81:	fc                   	cld    
  800a82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a8e:	ff 75 10             	pushl  0x10(%ebp)
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 8a ff ff ff       	call   800a26 <memmove>
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa9:	89 c6                	mov    %eax,%esi
  800aab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aae:	39 f0                	cmp    %esi,%eax
  800ab0:	74 1c                	je     800ace <memcmp+0x30>
		if (*s1 != *s2)
  800ab2:	0f b6 08             	movzbl (%eax),%ecx
  800ab5:	0f b6 1a             	movzbl (%edx),%ebx
  800ab8:	38 d9                	cmp    %bl,%cl
  800aba:	75 08                	jne    800ac4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	83 c2 01             	add    $0x1,%edx
  800ac2:	eb ea                	jmp    800aae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ac4:	0f b6 c1             	movzbl %cl,%eax
  800ac7:	0f b6 db             	movzbl %bl,%ebx
  800aca:	29 d8                	sub    %ebx,%eax
  800acc:	eb 05                	jmp    800ad3 <memcmp+0x35>
	}

	return 0;
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae5:	39 d0                	cmp    %edx,%eax
  800ae7:	73 09                	jae    800af2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae9:	38 08                	cmp    %cl,(%eax)
  800aeb:	74 05                	je     800af2 <memfind+0x1b>
	for (; s < ends; s++)
  800aed:	83 c0 01             	add    $0x1,%eax
  800af0:	eb f3                	jmp    800ae5 <memfind+0xe>
			break;
	return (void *) s;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	eb 03                	jmp    800b05 <strtol+0x11>
		s++;
  800b02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b05:	0f b6 01             	movzbl (%ecx),%eax
  800b08:	3c 20                	cmp    $0x20,%al
  800b0a:	74 f6                	je     800b02 <strtol+0xe>
  800b0c:	3c 09                	cmp    $0x9,%al
  800b0e:	74 f2                	je     800b02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b10:	3c 2b                	cmp    $0x2b,%al
  800b12:	74 2a                	je     800b3e <strtol+0x4a>
	int neg = 0;
  800b14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b19:	3c 2d                	cmp    $0x2d,%al
  800b1b:	74 2b                	je     800b48 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b23:	75 0f                	jne    800b34 <strtol+0x40>
  800b25:	80 39 30             	cmpb   $0x30,(%ecx)
  800b28:	74 28                	je     800b52 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2a:	85 db                	test   %ebx,%ebx
  800b2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b31:	0f 44 d8             	cmove  %eax,%ebx
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b3c:	eb 50                	jmp    800b8e <strtol+0x9a>
		s++;
  800b3e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b41:	bf 00 00 00 00       	mov    $0x0,%edi
  800b46:	eb d5                	jmp    800b1d <strtol+0x29>
		s++, neg = 1;
  800b48:	83 c1 01             	add    $0x1,%ecx
  800b4b:	bf 01 00 00 00       	mov    $0x1,%edi
  800b50:	eb cb                	jmp    800b1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b52:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b56:	74 0e                	je     800b66 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	75 d8                	jne    800b34 <strtol+0x40>
		s++, base = 8;
  800b5c:	83 c1 01             	add    $0x1,%ecx
  800b5f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b64:	eb ce                	jmp    800b34 <strtol+0x40>
		s += 2, base = 16;
  800b66:	83 c1 02             	add    $0x2,%ecx
  800b69:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b6e:	eb c4                	jmp    800b34 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b73:	89 f3                	mov    %esi,%ebx
  800b75:	80 fb 19             	cmp    $0x19,%bl
  800b78:	77 29                	ja     800ba3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b7a:	0f be d2             	movsbl %dl,%edx
  800b7d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b80:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b83:	7d 30                	jge    800bb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b85:	83 c1 01             	add    $0x1,%ecx
  800b88:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b8c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b8e:	0f b6 11             	movzbl (%ecx),%edx
  800b91:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b94:	89 f3                	mov    %esi,%ebx
  800b96:	80 fb 09             	cmp    $0x9,%bl
  800b99:	77 d5                	ja     800b70 <strtol+0x7c>
			dig = *s - '0';
  800b9b:	0f be d2             	movsbl %dl,%edx
  800b9e:	83 ea 30             	sub    $0x30,%edx
  800ba1:	eb dd                	jmp    800b80 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ba3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba6:	89 f3                	mov    %esi,%ebx
  800ba8:	80 fb 19             	cmp    $0x19,%bl
  800bab:	77 08                	ja     800bb5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bad:	0f be d2             	movsbl %dl,%edx
  800bb0:	83 ea 37             	sub    $0x37,%edx
  800bb3:	eb cb                	jmp    800b80 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	74 05                	je     800bc0 <strtol+0xcc>
		*endptr = (char *) s;
  800bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bc0:	89 c2                	mov    %eax,%edx
  800bc2:	f7 da                	neg    %edx
  800bc4:	85 ff                	test   %edi,%edi
  800bc6:	0f 45 c2             	cmovne %edx,%eax
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdf:	89 c3                	mov    %eax,%ebx
  800be1:	89 c7                	mov    %eax,%edi
  800be3:	89 c6                	mov    %eax,%esi
  800be5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <sys_cgetc>:

int
sys_cgetc(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfc:	89 d1                	mov    %edx,%ecx
  800bfe:	89 d3                	mov    %edx,%ebx
  800c00:	89 d7                	mov    %edx,%edi
  800c02:	89 d6                	mov    %edx,%esi
  800c04:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c21:	89 cb                	mov    %ecx,%ebx
  800c23:	89 cf                	mov    %ecx,%edi
  800c25:	89 ce                	mov    %ecx,%esi
  800c27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	7f 08                	jg     800c35 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c35:	83 ec 0c             	sub    $0xc,%esp
  800c38:	50                   	push   %eax
  800c39:	6a 03                	push   $0x3
  800c3b:	68 3f 28 80 00       	push   $0x80283f
  800c40:	6a 23                	push   $0x23
  800c42:	68 5c 28 80 00       	push   $0x80285c
  800c47:	e8 95 f5 ff ff       	call   8001e1 <_panic>

00800c4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5c:	89 d1                	mov    %edx,%ecx
  800c5e:	89 d3                	mov    %edx,%ebx
  800c60:	89 d7                	mov    %edx,%edi
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <sys_yield>:

void
sys_yield(void)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c7b:	89 d1                	mov    %edx,%ecx
  800c7d:	89 d3                	mov    %edx,%ebx
  800c7f:	89 d7                	mov    %edx,%edi
  800c81:	89 d6                	mov    %edx,%esi
  800c83:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c93:	be 00 00 00 00       	mov    $0x0,%esi
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca6:	89 f7                	mov    %esi,%edi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 04                	push   $0x4
  800cbc:	68 3f 28 80 00       	push   $0x80283f
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 5c 28 80 00       	push   $0x80285c
  800cc8:	e8 14 f5 ff ff       	call   8001e1 <_panic>

00800ccd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 05                	push   $0x5
  800cfe:	68 3f 28 80 00       	push   $0x80283f
  800d03:	6a 23                	push   $0x23
  800d05:	68 5c 28 80 00       	push   $0x80285c
  800d0a:	e8 d2 f4 ff ff       	call   8001e1 <_panic>

00800d0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	b8 06 00 00 00       	mov    $0x6,%eax
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 06                	push   $0x6
  800d40:	68 3f 28 80 00       	push   $0x80283f
  800d45:	6a 23                	push   $0x23
  800d47:	68 5c 28 80 00       	push   $0x80285c
  800d4c:	e8 90 f4 ff ff       	call   8001e1 <_panic>

00800d51 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6a:	89 df                	mov    %ebx,%edi
  800d6c:	89 de                	mov    %ebx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 08                	push   $0x8
  800d82:	68 3f 28 80 00       	push   $0x80283f
  800d87:	6a 23                	push   $0x23
  800d89:	68 5c 28 80 00       	push   $0x80285c
  800d8e:	e8 4e f4 ff ff       	call   8001e1 <_panic>

00800d93 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 09 00 00 00       	mov    $0x9,%eax
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 09                	push   $0x9
  800dc4:	68 3f 28 80 00       	push   $0x80283f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 5c 28 80 00       	push   $0x80285c
  800dd0:	e8 0c f4 ff ff       	call   8001e1 <_panic>

00800dd5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dee:	89 df                	mov    %ebx,%edi
  800df0:	89 de                	mov    %ebx,%esi
  800df2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	7f 08                	jg     800e00 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	50                   	push   %eax
  800e04:	6a 0a                	push   $0xa
  800e06:	68 3f 28 80 00       	push   $0x80283f
  800e0b:	6a 23                	push   $0x23
  800e0d:	68 5c 28 80 00       	push   $0x80285c
  800e12:	e8 ca f3 ff ff       	call   8001e1 <_panic>

00800e17 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e28:	be 00 00 00 00       	mov    $0x0,%esi
  800e2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e30:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e33:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e50:	89 cb                	mov    %ecx,%ebx
  800e52:	89 cf                	mov    %ecx,%edi
  800e54:	89 ce                	mov    %ecx,%esi
  800e56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	7f 08                	jg     800e64 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	50                   	push   %eax
  800e68:	6a 0d                	push   $0xd
  800e6a:	68 3f 28 80 00       	push   $0x80283f
  800e6f:	6a 23                	push   $0x23
  800e71:	68 5c 28 80 00       	push   $0x80285c
  800e76:	e8 66 f3 ff ff       	call   8001e1 <_panic>

00800e7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e81:	ba 00 00 00 00       	mov    $0x0,%edx
  800e86:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8b:	89 d1                	mov    %edx,%ecx
  800e8d:	89 d3                	mov    %edx,%ebx
  800e8f:	89 d7                	mov    %edx,%edi
  800e91:	89 d6                	mov    %edx,%esi
  800e93:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	05 00 00 00 30       	add    $0x30000000,%eax
  800ea5:	c1 e8 0c             	shr    $0xc,%eax
}
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    

00800eaa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800eb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eba:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec9:	89 c2                	mov    %eax,%edx
  800ecb:	c1 ea 16             	shr    $0x16,%edx
  800ece:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed5:	f6 c2 01             	test   $0x1,%dl
  800ed8:	74 2d                	je     800f07 <fd_alloc+0x46>
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	c1 ea 0c             	shr    $0xc,%edx
  800edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee6:	f6 c2 01             	test   $0x1,%dl
  800ee9:	74 1c                	je     800f07 <fd_alloc+0x46>
  800eeb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ef0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef5:	75 d2                	jne    800ec9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f00:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f05:	eb 0a                	jmp    800f11 <fd_alloc+0x50>
			*fd_store = fd;
  800f07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f19:	83 f8 1f             	cmp    $0x1f,%eax
  800f1c:	77 30                	ja     800f4e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f1e:	c1 e0 0c             	shl    $0xc,%eax
  800f21:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f26:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f2c:	f6 c2 01             	test   $0x1,%dl
  800f2f:	74 24                	je     800f55 <fd_lookup+0x42>
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	c1 ea 0c             	shr    $0xc,%edx
  800f36:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3d:	f6 c2 01             	test   $0x1,%dl
  800f40:	74 1a                	je     800f5c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	89 02                	mov    %eax,(%edx)
	return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
		return -E_INVAL;
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f53:	eb f7                	jmp    800f4c <fd_lookup+0x39>
		return -E_INVAL;
  800f55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5a:	eb f0                	jmp    800f4c <fd_lookup+0x39>
  800f5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f61:	eb e9                	jmp    800f4c <fd_lookup+0x39>

00800f63 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f71:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f76:	39 08                	cmp    %ecx,(%eax)
  800f78:	74 38                	je     800fb2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800f7a:	83 c2 01             	add    $0x1,%edx
  800f7d:	8b 04 95 e8 28 80 00 	mov    0x8028e8(,%edx,4),%eax
  800f84:	85 c0                	test   %eax,%eax
  800f86:	75 ee                	jne    800f76 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f88:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800f8d:	8b 40 48             	mov    0x48(%eax),%eax
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	51                   	push   %ecx
  800f94:	50                   	push   %eax
  800f95:	68 6c 28 80 00       	push   $0x80286c
  800f9a:	e8 1d f3 ff ff       	call   8002bc <cprintf>
	*dev = 0;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    
			*dev = devtab[i];
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbc:	eb f2                	jmp    800fb0 <dev_lookup+0x4d>

00800fbe <fd_close>:
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
  800fc4:	83 ec 24             	sub    $0x24,%esp
  800fc7:	8b 75 08             	mov    0x8(%ebp),%esi
  800fca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fcd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fd7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fda:	50                   	push   %eax
  800fdb:	e8 33 ff ff ff       	call   800f13 <fd_lookup>
  800fe0:	89 c3                	mov    %eax,%ebx
  800fe2:	83 c4 10             	add    $0x10,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	78 05                	js     800fee <fd_close+0x30>
	    || fd != fd2)
  800fe9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fec:	74 16                	je     801004 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fee:	89 f8                	mov    %edi,%eax
  800ff0:	84 c0                	test   %al,%al
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	0f 44 d8             	cmove  %eax,%ebx
}
  800ffa:	89 d8                	mov    %ebx,%eax
  800ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	ff 36                	pushl  (%esi)
  80100d:	e8 51 ff ff ff       	call   800f63 <dev_lookup>
  801012:	89 c3                	mov    %eax,%ebx
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 1a                	js     801035 <fd_close+0x77>
		if (dev->dev_close)
  80101b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801021:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801026:	85 c0                	test   %eax,%eax
  801028:	74 0b                	je     801035 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	56                   	push   %esi
  80102e:	ff d0                	call   *%eax
  801030:	89 c3                	mov    %eax,%ebx
  801032:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	56                   	push   %esi
  801039:	6a 00                	push   $0x0
  80103b:	e8 cf fc ff ff       	call   800d0f <sys_page_unmap>
	return r;
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	eb b5                	jmp    800ffa <fd_close+0x3c>

00801045 <close>:

int
close(int fdnum)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80104b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	e8 bc fe ff ff       	call   800f13 <fd_lookup>
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	85 c0                	test   %eax,%eax
  80105c:	79 02                	jns    801060 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    
		return fd_close(fd, 1);
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	6a 01                	push   $0x1
  801065:	ff 75 f4             	pushl  -0xc(%ebp)
  801068:	e8 51 ff ff ff       	call   800fbe <fd_close>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	eb ec                	jmp    80105e <close+0x19>

00801072 <close_all>:

void
close_all(void)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	53                   	push   %ebx
  801076:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	53                   	push   %ebx
  801082:	e8 be ff ff ff       	call   801045 <close>
	for (i = 0; i < MAXFD; i++)
  801087:	83 c3 01             	add    $0x1,%ebx
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	83 fb 20             	cmp    $0x20,%ebx
  801090:	75 ec                	jne    80107e <close_all+0xc>
}
  801092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	ff 75 08             	pushl  0x8(%ebp)
  8010a7:	e8 67 fe ff ff       	call   800f13 <fd_lookup>
  8010ac:	89 c3                	mov    %eax,%ebx
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	0f 88 81 00 00 00    	js     80113a <dup+0xa3>
		return r;
	close(newfdnum);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	e8 81 ff ff ff       	call   801045 <close>

	newfd = INDEX2FD(newfdnum);
  8010c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010c7:	c1 e6 0c             	shl    $0xc,%esi
  8010ca:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010d0:	83 c4 04             	add    $0x4,%esp
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	e8 cf fd ff ff       	call   800eaa <fd2data>
  8010db:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010dd:	89 34 24             	mov    %esi,(%esp)
  8010e0:	e8 c5 fd ff ff       	call   800eaa <fd2data>
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010ea:	89 d8                	mov    %ebx,%eax
  8010ec:	c1 e8 16             	shr    $0x16,%eax
  8010ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010f6:	a8 01                	test   $0x1,%al
  8010f8:	74 11                	je     80110b <dup+0x74>
  8010fa:	89 d8                	mov    %ebx,%eax
  8010fc:	c1 e8 0c             	shr    $0xc,%eax
  8010ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801106:	f6 c2 01             	test   $0x1,%dl
  801109:	75 39                	jne    801144 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80110b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e8 0c             	shr    $0xc,%eax
  801113:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	25 07 0e 00 00       	and    $0xe07,%eax
  801122:	50                   	push   %eax
  801123:	56                   	push   %esi
  801124:	6a 00                	push   $0x0
  801126:	52                   	push   %edx
  801127:	6a 00                	push   $0x0
  801129:	e8 9f fb ff ff       	call   800ccd <sys_page_map>
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	83 c4 20             	add    $0x20,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 31                	js     801168 <dup+0xd1>
		goto err;

	return newfdnum;
  801137:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80113a:	89 d8                	mov    %ebx,%eax
  80113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113f:	5b                   	pop    %ebx
  801140:	5e                   	pop    %esi
  801141:	5f                   	pop    %edi
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801144:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	25 07 0e 00 00       	and    $0xe07,%eax
  801153:	50                   	push   %eax
  801154:	57                   	push   %edi
  801155:	6a 00                	push   $0x0
  801157:	53                   	push   %ebx
  801158:	6a 00                	push   $0x0
  80115a:	e8 6e fb ff ff       	call   800ccd <sys_page_map>
  80115f:	89 c3                	mov    %eax,%ebx
  801161:	83 c4 20             	add    $0x20,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	79 a3                	jns    80110b <dup+0x74>
	sys_page_unmap(0, newfd);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	56                   	push   %esi
  80116c:	6a 00                	push   $0x0
  80116e:	e8 9c fb ff ff       	call   800d0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801173:	83 c4 08             	add    $0x8,%esp
  801176:	57                   	push   %edi
  801177:	6a 00                	push   $0x0
  801179:	e8 91 fb ff ff       	call   800d0f <sys_page_unmap>
	return r;
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	eb b7                	jmp    80113a <dup+0xa3>

00801183 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	53                   	push   %ebx
  801187:	83 ec 1c             	sub    $0x1c,%esp
  80118a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80118d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	53                   	push   %ebx
  801192:	e8 7c fd ff ff       	call   800f13 <fd_lookup>
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	85 c0                	test   %eax,%eax
  80119c:	78 3f                	js     8011dd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a4:	50                   	push   %eax
  8011a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a8:	ff 30                	pushl  (%eax)
  8011aa:	e8 b4 fd ff ff       	call   800f63 <dev_lookup>
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	78 27                	js     8011dd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b9:	8b 42 08             	mov    0x8(%edx),%eax
  8011bc:	83 e0 03             	and    $0x3,%eax
  8011bf:	83 f8 01             	cmp    $0x1,%eax
  8011c2:	74 1e                	je     8011e2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c7:	8b 40 08             	mov    0x8(%eax),%eax
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	74 35                	je     801203 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	ff 75 10             	pushl  0x10(%ebp)
  8011d4:	ff 75 0c             	pushl  0xc(%ebp)
  8011d7:	52                   	push   %edx
  8011d8:	ff d0                	call   *%eax
  8011da:	83 c4 10             	add    $0x10,%esp
}
  8011dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011e7:	8b 40 48             	mov    0x48(%eax),%eax
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	53                   	push   %ebx
  8011ee:	50                   	push   %eax
  8011ef:	68 ad 28 80 00       	push   $0x8028ad
  8011f4:	e8 c3 f0 ff ff       	call   8002bc <cprintf>
		return -E_INVAL;
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801201:	eb da                	jmp    8011dd <read+0x5a>
		return -E_NOT_SUPP;
  801203:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801208:	eb d3                	jmp    8011dd <read+0x5a>

0080120a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	8b 7d 08             	mov    0x8(%ebp),%edi
  801216:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801219:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121e:	39 f3                	cmp    %esi,%ebx
  801220:	73 23                	jae    801245 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	89 f0                	mov    %esi,%eax
  801227:	29 d8                	sub    %ebx,%eax
  801229:	50                   	push   %eax
  80122a:	89 d8                	mov    %ebx,%eax
  80122c:	03 45 0c             	add    0xc(%ebp),%eax
  80122f:	50                   	push   %eax
  801230:	57                   	push   %edi
  801231:	e8 4d ff ff ff       	call   801183 <read>
		if (m < 0)
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 06                	js     801243 <readn+0x39>
			return m;
		if (m == 0)
  80123d:	74 06                	je     801245 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80123f:	01 c3                	add    %eax,%ebx
  801241:	eb db                	jmp    80121e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801243:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801245:	89 d8                	mov    %ebx,%eax
  801247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124a:	5b                   	pop    %ebx
  80124b:	5e                   	pop    %esi
  80124c:	5f                   	pop    %edi
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	53                   	push   %ebx
  801253:	83 ec 1c             	sub    $0x1c,%esp
  801256:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801259:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80125c:	50                   	push   %eax
  80125d:	53                   	push   %ebx
  80125e:	e8 b0 fc ff ff       	call   800f13 <fd_lookup>
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	78 3a                	js     8012a4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801270:	50                   	push   %eax
  801271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801274:	ff 30                	pushl  (%eax)
  801276:	e8 e8 fc ff ff       	call   800f63 <dev_lookup>
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 22                	js     8012a4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801285:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801289:	74 1e                	je     8012a9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 52 0c             	mov    0xc(%edx),%edx
  801291:	85 d2                	test   %edx,%edx
  801293:	74 35                	je     8012ca <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	ff 75 10             	pushl  0x10(%ebp)
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	50                   	push   %eax
  80129f:	ff d2                	call   *%edx
  8012a1:	83 c4 10             	add    $0x10,%esp
}
  8012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012ae:	8b 40 48             	mov    0x48(%eax),%eax
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	53                   	push   %ebx
  8012b5:	50                   	push   %eax
  8012b6:	68 c9 28 80 00       	push   $0x8028c9
  8012bb:	e8 fc ef ff ff       	call   8002bc <cprintf>
		return -E_INVAL;
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c8:	eb da                	jmp    8012a4 <write+0x55>
		return -E_NOT_SUPP;
  8012ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012cf:	eb d3                	jmp    8012a4 <write+0x55>

008012d1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012da:	50                   	push   %eax
  8012db:	ff 75 08             	pushl  0x8(%ebp)
  8012de:	e8 30 fc ff ff       	call   800f13 <fd_lookup>
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 0e                	js     8012f8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 1c             	sub    $0x1c,%esp
  801301:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801304:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801307:	50                   	push   %eax
  801308:	53                   	push   %ebx
  801309:	e8 05 fc ff ff       	call   800f13 <fd_lookup>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 37                	js     80134c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131f:	ff 30                	pushl  (%eax)
  801321:	e8 3d fc ff ff       	call   800f63 <dev_lookup>
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	78 1f                	js     80134c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801334:	74 1b                	je     801351 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801339:	8b 52 18             	mov    0x18(%edx),%edx
  80133c:	85 d2                	test   %edx,%edx
  80133e:	74 32                	je     801372 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	ff 75 0c             	pushl  0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff d2                	call   *%edx
  801349:	83 c4 10             	add    $0x10,%esp
}
  80134c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134f:	c9                   	leave  
  801350:	c3                   	ret    
			thisenv->env_id, fdnum);
  801351:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801356:	8b 40 48             	mov    0x48(%eax),%eax
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	53                   	push   %ebx
  80135d:	50                   	push   %eax
  80135e:	68 8c 28 80 00       	push   $0x80288c
  801363:	e8 54 ef ff ff       	call   8002bc <cprintf>
		return -E_INVAL;
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801370:	eb da                	jmp    80134c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801372:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801377:	eb d3                	jmp    80134c <ftruncate+0x52>

00801379 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	53                   	push   %ebx
  80137d:	83 ec 1c             	sub    $0x1c,%esp
  801380:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801383:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	e8 84 fb ff ff       	call   800f13 <fd_lookup>
  80138f:	83 c4 10             	add    $0x10,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	78 4b                	js     8013e1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139c:	50                   	push   %eax
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	ff 30                	pushl  (%eax)
  8013a2:	e8 bc fb ff ff       	call   800f63 <dev_lookup>
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 33                	js     8013e1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013b5:	74 2f                	je     8013e6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013b7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013ba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013c1:	00 00 00 
	stat->st_isdir = 0;
  8013c4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013cb:	00 00 00 
	stat->st_dev = dev;
  8013ce:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013db:	ff 50 14             	call   *0x14(%eax)
  8013de:	83 c4 10             	add    $0x10,%esp
}
  8013e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    
		return -E_NOT_SUPP;
  8013e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013eb:	eb f4                	jmp    8013e1 <fstat+0x68>

008013ed <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	6a 00                	push   $0x0
  8013f7:	ff 75 08             	pushl  0x8(%ebp)
  8013fa:	e8 2f 02 00 00       	call   80162e <open>
  8013ff:	89 c3                	mov    %eax,%ebx
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 1b                	js     801423 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	50                   	push   %eax
  80140f:	e8 65 ff ff ff       	call   801379 <fstat>
  801414:	89 c6                	mov    %eax,%esi
	close(fd);
  801416:	89 1c 24             	mov    %ebx,(%esp)
  801419:	e8 27 fc ff ff       	call   801045 <close>
	return r;
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	89 f3                	mov    %esi,%ebx
}
  801423:	89 d8                	mov    %ebx,%eax
  801425:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	56                   	push   %esi
  801430:	53                   	push   %ebx
  801431:	89 c6                	mov    %eax,%esi
  801433:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801435:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80143c:	74 27                	je     801465 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80143e:	6a 07                	push   $0x7
  801440:	68 00 50 80 00       	push   $0x805000
  801445:	56                   	push   %esi
  801446:	ff 35 04 40 80 00    	pushl  0x804004
  80144c:	e8 33 0d 00 00       	call   802184 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801451:	83 c4 0c             	add    $0xc,%esp
  801454:	6a 00                	push   $0x0
  801456:	53                   	push   %ebx
  801457:	6a 00                	push   $0x0
  801459:	e8 b3 0c 00 00       	call   802111 <ipc_recv>
}
  80145e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	6a 01                	push   $0x1
  80146a:	e8 81 0d 00 00       	call   8021f0 <ipc_find_env>
  80146f:	a3 04 40 80 00       	mov    %eax,0x804004
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	eb c5                	jmp    80143e <fsipc+0x12>

00801479 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8b 40 0c             	mov    0xc(%eax),%eax
  801485:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801492:	ba 00 00 00 00       	mov    $0x0,%edx
  801497:	b8 02 00 00 00       	mov    $0x2,%eax
  80149c:	e8 8b ff ff ff       	call   80142c <fsipc>
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <devfile_flush>:
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8014af:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8014be:	e8 69 ff ff ff       	call   80142c <fsipc>
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <devfile_stat>:
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014da:	ba 00 00 00 00       	mov    $0x0,%edx
  8014df:	b8 05 00 00 00       	mov    $0x5,%eax
  8014e4:	e8 43 ff ff ff       	call   80142c <fsipc>
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 2c                	js     801519 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014ed:	83 ec 08             	sub    $0x8,%esp
  8014f0:	68 00 50 80 00       	push   $0x805000
  8014f5:	53                   	push   %ebx
  8014f6:	e8 9d f3 ff ff       	call   800898 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014fb:	a1 80 50 80 00       	mov    0x805080,%eax
  801500:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801506:	a1 84 50 80 00       	mov    0x805084,%eax
  80150b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <devfile_write>:
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801528:	85 db                	test   %ebx,%ebx
  80152a:	75 07                	jne    801533 <devfile_write+0x15>
	return n_all;
  80152c:	89 d8                	mov    %ebx,%eax
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8b 40 0c             	mov    0xc(%eax),%eax
  801539:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  80153e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	53                   	push   %ebx
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	68 08 50 80 00       	push   $0x805008
  801550:	e8 d1 f4 ff ff       	call   800a26 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801555:	ba 00 00 00 00       	mov    $0x0,%edx
  80155a:	b8 04 00 00 00       	mov    $0x4,%eax
  80155f:	e8 c8 fe ff ff       	call   80142c <fsipc>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 c3                	js     80152e <devfile_write+0x10>
	  assert(r <= n_left);
  80156b:	39 d8                	cmp    %ebx,%eax
  80156d:	77 0b                	ja     80157a <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  80156f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801574:	7f 1d                	jg     801593 <devfile_write+0x75>
    n_all += r;
  801576:	89 c3                	mov    %eax,%ebx
  801578:	eb b2                	jmp    80152c <devfile_write+0xe>
	  assert(r <= n_left);
  80157a:	68 fc 28 80 00       	push   $0x8028fc
  80157f:	68 08 29 80 00       	push   $0x802908
  801584:	68 9f 00 00 00       	push   $0x9f
  801589:	68 1d 29 80 00       	push   $0x80291d
  80158e:	e8 4e ec ff ff       	call   8001e1 <_panic>
	  assert(r <= PGSIZE);
  801593:	68 28 29 80 00       	push   $0x802928
  801598:	68 08 29 80 00       	push   $0x802908
  80159d:	68 a0 00 00 00       	push   $0xa0
  8015a2:	68 1d 29 80 00       	push   $0x80291d
  8015a7:	e8 35 ec ff ff       	call   8001e1 <_panic>

008015ac <devfile_read>:
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	56                   	push   %esi
  8015b0:	53                   	push   %ebx
  8015b1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ba:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015bf:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ca:	b8 03 00 00 00       	mov    $0x3,%eax
  8015cf:	e8 58 fe ff ff       	call   80142c <fsipc>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 1f                	js     8015f9 <devfile_read+0x4d>
	assert(r <= n);
  8015da:	39 f0                	cmp    %esi,%eax
  8015dc:	77 24                	ja     801602 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015de:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015e3:	7f 33                	jg     801618 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	50                   	push   %eax
  8015e9:	68 00 50 80 00       	push   $0x805000
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	e8 30 f4 ff ff       	call   800a26 <memmove>
	return r;
  8015f6:	83 c4 10             	add    $0x10,%esp
}
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5d                   	pop    %ebp
  801601:	c3                   	ret    
	assert(r <= n);
  801602:	68 34 29 80 00       	push   $0x802934
  801607:	68 08 29 80 00       	push   $0x802908
  80160c:	6a 7c                	push   $0x7c
  80160e:	68 1d 29 80 00       	push   $0x80291d
  801613:	e8 c9 eb ff ff       	call   8001e1 <_panic>
	assert(r <= PGSIZE);
  801618:	68 28 29 80 00       	push   $0x802928
  80161d:	68 08 29 80 00       	push   $0x802908
  801622:	6a 7d                	push   $0x7d
  801624:	68 1d 29 80 00       	push   $0x80291d
  801629:	e8 b3 eb ff ff       	call   8001e1 <_panic>

0080162e <open>:
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 1c             	sub    $0x1c,%esp
  801636:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801639:	56                   	push   %esi
  80163a:	e8 20 f2 ff ff       	call   80085f <strlen>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801647:	7f 6c                	jg     8016b5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164f:	50                   	push   %eax
  801650:	e8 6c f8 ff ff       	call   800ec1 <fd_alloc>
  801655:	89 c3                	mov    %eax,%ebx
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 3c                	js     80169a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	56                   	push   %esi
  801662:	68 00 50 80 00       	push   $0x805000
  801667:	e8 2c f2 ff ff       	call   800898 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80166c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801677:	b8 01 00 00 00       	mov    $0x1,%eax
  80167c:	e8 ab fd ff ff       	call   80142c <fsipc>
  801681:	89 c3                	mov    %eax,%ebx
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 19                	js     8016a3 <open+0x75>
	return fd2num(fd);
  80168a:	83 ec 0c             	sub    $0xc,%esp
  80168d:	ff 75 f4             	pushl  -0xc(%ebp)
  801690:	e8 05 f8 ff ff       	call   800e9a <fd2num>
  801695:	89 c3                	mov    %eax,%ebx
  801697:	83 c4 10             	add    $0x10,%esp
}
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    
		fd_close(fd, 0);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	6a 00                	push   $0x0
  8016a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ab:	e8 0e f9 ff ff       	call   800fbe <fd_close>
		return r;
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	eb e5                	jmp    80169a <open+0x6c>
		return -E_BAD_PATH;
  8016b5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016ba:	eb de                	jmp    80169a <open+0x6c>

008016bc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8016cc:	e8 5b fd ff ff       	call   80142c <fsipc>
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016d3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8016d7:	7f 01                	jg     8016da <writebuf+0x7>
  8016d9:	c3                   	ret    
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8016e3:	ff 70 04             	pushl  0x4(%eax)
  8016e6:	8d 40 10             	lea    0x10(%eax),%eax
  8016e9:	50                   	push   %eax
  8016ea:	ff 33                	pushl  (%ebx)
  8016ec:	e8 5e fb ff ff       	call   80124f <write>
		if (result > 0)
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	7e 03                	jle    8016fb <writebuf+0x28>
			b->result += result;
  8016f8:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016fb:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016fe:	74 0d                	je     80170d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801700:	85 c0                	test   %eax,%eax
  801702:	ba 00 00 00 00       	mov    $0x0,%edx
  801707:	0f 4f c2             	cmovg  %edx,%eax
  80170a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <putch>:

static void
putch(int ch, void *thunk)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80171c:	8b 53 04             	mov    0x4(%ebx),%edx
  80171f:	8d 42 01             	lea    0x1(%edx),%eax
  801722:	89 43 04             	mov    %eax,0x4(%ebx)
  801725:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801728:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80172c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801731:	74 06                	je     801739 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801733:	83 c4 04             	add    $0x4,%esp
  801736:	5b                   	pop    %ebx
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    
		writebuf(b);
  801739:	89 d8                	mov    %ebx,%eax
  80173b:	e8 93 ff ff ff       	call   8016d3 <writebuf>
		b->idx = 0;
  801740:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801747:	eb ea                	jmp    801733 <putch+0x21>

00801749 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80175b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801762:	00 00 00 
	b.result = 0;
  801765:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80176c:	00 00 00 
	b.error = 1;
  80176f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801776:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801779:	ff 75 10             	pushl  0x10(%ebp)
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	68 12 17 80 00       	push   $0x801712
  80178b:	e8 28 ec ff ff       	call   8003b8 <vprintfmt>
	if (b.idx > 0)
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80179a:	7f 11                	jg     8017ad <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80179c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    
		writebuf(&b);
  8017ad:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017b3:	e8 1b ff ff ff       	call   8016d3 <writebuf>
  8017b8:	eb e2                	jmp    80179c <vfprintf+0x53>

008017ba <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017c0:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8017c3:	50                   	push   %eax
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 7a ff ff ff       	call   801749 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <printf>:

int
printf(const char *fmt, ...)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8017da:	50                   	push   %eax
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 01                	push   $0x1
  8017e0:	e8 64 ff ff ff       	call   801749 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017ef:	83 ec 0c             	sub    $0xc,%esp
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 b0 f6 ff ff       	call   800eaa <fd2data>
  8017fa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017fc:	83 c4 08             	add    $0x8,%esp
  8017ff:	68 3b 29 80 00       	push   $0x80293b
  801804:	53                   	push   %ebx
  801805:	e8 8e f0 ff ff       	call   800898 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80180a:	8b 46 04             	mov    0x4(%esi),%eax
  80180d:	2b 06                	sub    (%esi),%eax
  80180f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801815:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80181c:	00 00 00 
	stat->st_dev = &devpipe;
  80181f:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801826:	30 80 00 
	return 0;
}
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5d                   	pop    %ebp
  801834:	c3                   	ret    

00801835 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	53                   	push   %ebx
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80183f:	53                   	push   %ebx
  801840:	6a 00                	push   $0x0
  801842:	e8 c8 f4 ff ff       	call   800d0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801847:	89 1c 24             	mov    %ebx,(%esp)
  80184a:	e8 5b f6 ff ff       	call   800eaa <fd2data>
  80184f:	83 c4 08             	add    $0x8,%esp
  801852:	50                   	push   %eax
  801853:	6a 00                	push   $0x0
  801855:	e8 b5 f4 ff ff       	call   800d0f <sys_page_unmap>
}
  80185a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <_pipeisclosed>:
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	57                   	push   %edi
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	83 ec 1c             	sub    $0x1c,%esp
  801868:	89 c7                	mov    %eax,%edi
  80186a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80186c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801871:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801874:	83 ec 0c             	sub    $0xc,%esp
  801877:	57                   	push   %edi
  801878:	e8 ac 09 00 00       	call   802229 <pageref>
  80187d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801880:	89 34 24             	mov    %esi,(%esp)
  801883:	e8 a1 09 00 00       	call   802229 <pageref>
		nn = thisenv->env_runs;
  801888:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80188e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	39 cb                	cmp    %ecx,%ebx
  801896:	74 1b                	je     8018b3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801898:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80189b:	75 cf                	jne    80186c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80189d:	8b 42 58             	mov    0x58(%edx),%eax
  8018a0:	6a 01                	push   $0x1
  8018a2:	50                   	push   %eax
  8018a3:	53                   	push   %ebx
  8018a4:	68 42 29 80 00       	push   $0x802942
  8018a9:	e8 0e ea ff ff       	call   8002bc <cprintf>
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	eb b9                	jmp    80186c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018b6:	0f 94 c0             	sete   %al
  8018b9:	0f b6 c0             	movzbl %al,%eax
}
  8018bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <devpipe_write>:
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	57                   	push   %edi
  8018c8:	56                   	push   %esi
  8018c9:	53                   	push   %ebx
  8018ca:	83 ec 28             	sub    $0x28,%esp
  8018cd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018d0:	56                   	push   %esi
  8018d1:	e8 d4 f5 ff ff       	call   800eaa <fd2data>
  8018d6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	bf 00 00 00 00       	mov    $0x0,%edi
  8018e0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018e3:	74 4f                	je     801934 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018e5:	8b 43 04             	mov    0x4(%ebx),%eax
  8018e8:	8b 0b                	mov    (%ebx),%ecx
  8018ea:	8d 51 20             	lea    0x20(%ecx),%edx
  8018ed:	39 d0                	cmp    %edx,%eax
  8018ef:	72 14                	jb     801905 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018f1:	89 da                	mov    %ebx,%edx
  8018f3:	89 f0                	mov    %esi,%eax
  8018f5:	e8 65 ff ff ff       	call   80185f <_pipeisclosed>
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	75 3b                	jne    801939 <devpipe_write+0x75>
			sys_yield();
  8018fe:	e8 68 f3 ff ff       	call   800c6b <sys_yield>
  801903:	eb e0                	jmp    8018e5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801905:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801908:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80190c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80190f:	89 c2                	mov    %eax,%edx
  801911:	c1 fa 1f             	sar    $0x1f,%edx
  801914:	89 d1                	mov    %edx,%ecx
  801916:	c1 e9 1b             	shr    $0x1b,%ecx
  801919:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80191c:	83 e2 1f             	and    $0x1f,%edx
  80191f:	29 ca                	sub    %ecx,%edx
  801921:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801925:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801929:	83 c0 01             	add    $0x1,%eax
  80192c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80192f:	83 c7 01             	add    $0x1,%edi
  801932:	eb ac                	jmp    8018e0 <devpipe_write+0x1c>
	return i;
  801934:	8b 45 10             	mov    0x10(%ebp),%eax
  801937:	eb 05                	jmp    80193e <devpipe_write+0x7a>
				return 0;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5f                   	pop    %edi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <devpipe_read>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	57                   	push   %edi
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	83 ec 18             	sub    $0x18,%esp
  80194f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801952:	57                   	push   %edi
  801953:	e8 52 f5 ff ff       	call   800eaa <fd2data>
  801958:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	be 00 00 00 00       	mov    $0x0,%esi
  801962:	3b 75 10             	cmp    0x10(%ebp),%esi
  801965:	75 14                	jne    80197b <devpipe_read+0x35>
	return i;
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	eb 02                	jmp    80196e <devpipe_read+0x28>
				return i;
  80196c:	89 f0                	mov    %esi,%eax
}
  80196e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    
			sys_yield();
  801976:	e8 f0 f2 ff ff       	call   800c6b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80197b:	8b 03                	mov    (%ebx),%eax
  80197d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801980:	75 18                	jne    80199a <devpipe_read+0x54>
			if (i > 0)
  801982:	85 f6                	test   %esi,%esi
  801984:	75 e6                	jne    80196c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801986:	89 da                	mov    %ebx,%edx
  801988:	89 f8                	mov    %edi,%eax
  80198a:	e8 d0 fe ff ff       	call   80185f <_pipeisclosed>
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 e3                	je     801976 <devpipe_read+0x30>
				return 0;
  801993:	b8 00 00 00 00       	mov    $0x0,%eax
  801998:	eb d4                	jmp    80196e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80199a:	99                   	cltd   
  80199b:	c1 ea 1b             	shr    $0x1b,%edx
  80199e:	01 d0                	add    %edx,%eax
  8019a0:	83 e0 1f             	and    $0x1f,%eax
  8019a3:	29 d0                	sub    %edx,%eax
  8019a5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ad:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019b0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019b3:	83 c6 01             	add    $0x1,%esi
  8019b6:	eb aa                	jmp    801962 <devpipe_read+0x1c>

008019b8 <pipe>:
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	56                   	push   %esi
  8019bc:	53                   	push   %ebx
  8019bd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	e8 f8 f4 ff ff       	call   800ec1 <fd_alloc>
  8019c9:	89 c3                	mov    %eax,%ebx
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	0f 88 23 01 00 00    	js     801af9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	68 07 04 00 00       	push   $0x407
  8019de:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e1:	6a 00                	push   $0x0
  8019e3:	e8 a2 f2 ff ff       	call   800c8a <sys_page_alloc>
  8019e8:	89 c3                	mov    %eax,%ebx
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	0f 88 04 01 00 00    	js     801af9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fb:	50                   	push   %eax
  8019fc:	e8 c0 f4 ff ff       	call   800ec1 <fd_alloc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	0f 88 db 00 00 00    	js     801ae9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	68 07 04 00 00       	push   $0x407
  801a16:	ff 75 f0             	pushl  -0x10(%ebp)
  801a19:	6a 00                	push   $0x0
  801a1b:	e8 6a f2 ff ff       	call   800c8a <sys_page_alloc>
  801a20:	89 c3                	mov    %eax,%ebx
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	0f 88 bc 00 00 00    	js     801ae9 <pipe+0x131>
	va = fd2data(fd0);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	ff 75 f4             	pushl  -0xc(%ebp)
  801a33:	e8 72 f4 ff ff       	call   800eaa <fd2data>
  801a38:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a3a:	83 c4 0c             	add    $0xc,%esp
  801a3d:	68 07 04 00 00       	push   $0x407
  801a42:	50                   	push   %eax
  801a43:	6a 00                	push   $0x0
  801a45:	e8 40 f2 ff ff       	call   800c8a <sys_page_alloc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	0f 88 82 00 00 00    	js     801ad9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5d:	e8 48 f4 ff ff       	call   800eaa <fd2data>
  801a62:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a69:	50                   	push   %eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	56                   	push   %esi
  801a6d:	6a 00                	push   $0x0
  801a6f:	e8 59 f2 ff ff       	call   800ccd <sys_page_map>
  801a74:	89 c3                	mov    %eax,%ebx
  801a76:	83 c4 20             	add    $0x20,%esp
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 4e                	js     801acb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801a7d:	a1 24 30 80 00       	mov    0x803024,%eax
  801a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a85:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a94:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801aa0:	83 ec 0c             	sub    $0xc,%esp
  801aa3:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa6:	e8 ef f3 ff ff       	call   800e9a <fd2num>
  801aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aae:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ab0:	83 c4 04             	add    $0x4,%esp
  801ab3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab6:	e8 df f3 ff ff       	call   800e9a <fd2num>
  801abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abe:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac9:	eb 2e                	jmp    801af9 <pipe+0x141>
	sys_page_unmap(0, va);
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	56                   	push   %esi
  801acf:	6a 00                	push   $0x0
  801ad1:	e8 39 f2 ff ff       	call   800d0f <sys_page_unmap>
  801ad6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	ff 75 f0             	pushl  -0x10(%ebp)
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 29 f2 ff ff       	call   800d0f <sys_page_unmap>
  801ae6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	ff 75 f4             	pushl  -0xc(%ebp)
  801aef:	6a 00                	push   $0x0
  801af1:	e8 19 f2 ff ff       	call   800d0f <sys_page_unmap>
  801af6:	83 c4 10             	add    $0x10,%esp
}
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5d                   	pop    %ebp
  801b01:	c3                   	ret    

00801b02 <pipeisclosed>:
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0b:	50                   	push   %eax
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	e8 ff f3 ff ff       	call   800f13 <fd_lookup>
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 18                	js     801b33 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b21:	e8 84 f3 ff ff       	call   800eaa <fd2data>
	return _pipeisclosed(fd, p);
  801b26:	89 c2                	mov    %eax,%edx
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	e8 2f fd ff ff       	call   80185f <_pipeisclosed>
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b3b:	68 5a 29 80 00       	push   $0x80295a
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	e8 50 ed ff ff       	call   800898 <strcpy>
	return 0;
}
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <devsock_close>:
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
  801b53:	83 ec 10             	sub    $0x10,%esp
  801b56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b59:	53                   	push   %ebx
  801b5a:	e8 ca 06 00 00       	call   802229 <pageref>
  801b5f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b67:	83 f8 01             	cmp    $0x1,%eax
  801b6a:	74 07                	je     801b73 <devsock_close+0x24>
}
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 73 0c             	pushl  0xc(%ebx)
  801b79:	e8 b9 02 00 00       	call   801e37 <nsipc_close>
  801b7e:	89 c2                	mov    %eax,%edx
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	eb e7                	jmp    801b6c <devsock_close+0x1d>

00801b85 <devsock_write>:
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	ff 75 10             	pushl  0x10(%ebp)
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	ff 70 0c             	pushl  0xc(%eax)
  801b99:	e8 76 03 00 00       	call   801f14 <nsipc_send>
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <devsock_read>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	ff 75 10             	pushl  0x10(%ebp)
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	ff 70 0c             	pushl  0xc(%eax)
  801bb4:	e8 ef 02 00 00       	call   801ea8 <nsipc_recv>
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <fd2sockid>:
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bc1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bc4:	52                   	push   %edx
  801bc5:	50                   	push   %eax
  801bc6:	e8 48 f3 ff ff       	call   800f13 <fd_lookup>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 10                	js     801be2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd5:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  801bdb:	39 08                	cmp    %ecx,(%eax)
  801bdd:	75 05                	jne    801be4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bdf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    
		return -E_NOT_SUPP;
  801be4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be9:	eb f7                	jmp    801be2 <fd2sockid+0x27>

00801beb <alloc_sockfd>:
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 1c             	sub    $0x1c,%esp
  801bf3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf8:	50                   	push   %eax
  801bf9:	e8 c3 f2 ff ff       	call   800ec1 <fd_alloc>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	85 c0                	test   %eax,%eax
  801c05:	78 43                	js     801c4a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	68 07 04 00 00       	push   $0x407
  801c0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c12:	6a 00                	push   $0x0
  801c14:	e8 71 f0 ff ff       	call   800c8a <sys_page_alloc>
  801c19:	89 c3                	mov    %eax,%ebx
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 28                	js     801c4a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c2b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c37:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	50                   	push   %eax
  801c3e:	e8 57 f2 ff ff       	call   800e9a <fd2num>
  801c43:	89 c3                	mov    %eax,%ebx
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	eb 0c                	jmp    801c56 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	56                   	push   %esi
  801c4e:	e8 e4 01 00 00       	call   801e37 <nsipc_close>
		return r;
  801c53:	83 c4 10             	add    $0x10,%esp
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <accept>:
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	e8 4e ff ff ff       	call   801bbb <fd2sockid>
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 1b                	js     801c8c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	ff 75 10             	pushl  0x10(%ebp)
  801c77:	ff 75 0c             	pushl  0xc(%ebp)
  801c7a:	50                   	push   %eax
  801c7b:	e8 0e 01 00 00       	call   801d8e <nsipc_accept>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 05                	js     801c8c <accept+0x2d>
	return alloc_sockfd(r);
  801c87:	e8 5f ff ff ff       	call   801beb <alloc_sockfd>
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <bind>:
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	e8 1f ff ff ff       	call   801bbb <fd2sockid>
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 12                	js     801cb2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	ff 75 10             	pushl  0x10(%ebp)
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	50                   	push   %eax
  801caa:	e8 31 01 00 00       	call   801de0 <nsipc_bind>
  801caf:	83 c4 10             	add    $0x10,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <shutdown>:
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	e8 f9 fe ff ff       	call   801bbb <fd2sockid>
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 0f                	js     801cd5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	50                   	push   %eax
  801ccd:	e8 43 01 00 00       	call   801e15 <nsipc_shutdown>
  801cd2:	83 c4 10             	add    $0x10,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <connect>:
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	e8 d6 fe ff ff       	call   801bbb <fd2sockid>
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	78 12                	js     801cfb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	50                   	push   %eax
  801cf3:	e8 59 01 00 00       	call   801e51 <nsipc_connect>
  801cf8:	83 c4 10             	add    $0x10,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <listen>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	e8 b0 fe ff ff       	call   801bbb <fd2sockid>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 0f                	js     801d1e <listen+0x21>
	return nsipc_listen(r, backlog);
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	50                   	push   %eax
  801d16:	e8 6b 01 00 00       	call   801e86 <nsipc_listen>
  801d1b:	83 c4 10             	add    $0x10,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	e8 3e 02 00 00       	call   801f72 <nsipc_socket>
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 05                	js     801d40 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d3b:	e8 ab fe ff ff       	call   801beb <alloc_sockfd>
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d4b:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801d52:	74 26                	je     801d7a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d54:	6a 07                	push   $0x7
  801d56:	68 00 60 80 00       	push   $0x806000
  801d5b:	53                   	push   %ebx
  801d5c:	ff 35 08 40 80 00    	pushl  0x804008
  801d62:	e8 1d 04 00 00       	call   802184 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d67:	83 c4 0c             	add    $0xc,%esp
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	e8 9c 03 00 00       	call   802111 <ipc_recv>
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	6a 02                	push   $0x2
  801d7f:	e8 6c 04 00 00       	call   8021f0 <ipc_find_env>
  801d84:	a3 08 40 80 00       	mov    %eax,0x804008
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	eb c6                	jmp    801d54 <nsipc+0x12>

00801d8e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	56                   	push   %esi
  801d92:	53                   	push   %ebx
  801d93:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d9e:	8b 06                	mov    (%esi),%eax
  801da0:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801da5:	b8 01 00 00 00       	mov    $0x1,%eax
  801daa:	e8 93 ff ff ff       	call   801d42 <nsipc>
  801daf:	89 c3                	mov    %eax,%ebx
  801db1:	85 c0                	test   %eax,%eax
  801db3:	79 09                	jns    801dbe <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801db5:	89 d8                	mov    %ebx,%eax
  801db7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5e                   	pop    %esi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	ff 35 10 60 80 00    	pushl  0x806010
  801dc7:	68 00 60 80 00       	push   $0x806000
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	e8 52 ec ff ff       	call   800a26 <memmove>
		*addrlen = ret->ret_addrlen;
  801dd4:	a1 10 60 80 00       	mov    0x806010,%eax
  801dd9:	89 06                	mov    %eax,(%esi)
  801ddb:	83 c4 10             	add    $0x10,%esp
	return r;
  801dde:	eb d5                	jmp    801db5 <nsipc_accept+0x27>

00801de0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	53                   	push   %ebx
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801df2:	53                   	push   %ebx
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	68 04 60 80 00       	push   $0x806004
  801dfb:	e8 26 ec ff ff       	call   800a26 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e00:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e06:	b8 02 00 00 00       	mov    $0x2,%eax
  801e0b:	e8 32 ff ff ff       	call   801d42 <nsipc>
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e26:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  801e30:	e8 0d ff ff ff       	call   801d42 <nsipc>
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <nsipc_close>:

int
nsipc_close(int s)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e45:	b8 04 00 00 00       	mov    $0x4,%eax
  801e4a:	e8 f3 fe ff ff       	call   801d42 <nsipc>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e63:	53                   	push   %ebx
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	68 04 60 80 00       	push   $0x806004
  801e6c:	e8 b5 eb ff ff       	call   800a26 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e71:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e77:	b8 05 00 00 00       	mov    $0x5,%eax
  801e7c:	e8 c1 fe ff ff       	call   801d42 <nsipc>
}
  801e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e9c:	b8 06 00 00 00       	mov    $0x6,%eax
  801ea1:	e8 9c fe ff ff       	call   801d42 <nsipc>
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801eb8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ec6:	b8 07 00 00 00       	mov    $0x7,%eax
  801ecb:	e8 72 fe ff ff       	call   801d42 <nsipc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 1f                	js     801ef5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ed6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801edb:	7f 21                	jg     801efe <nsipc_recv+0x56>
  801edd:	39 c6                	cmp    %eax,%esi
  801edf:	7c 1d                	jl     801efe <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	50                   	push   %eax
  801ee5:	68 00 60 80 00       	push   $0x806000
  801eea:	ff 75 0c             	pushl  0xc(%ebp)
  801eed:	e8 34 eb ff ff       	call   800a26 <memmove>
  801ef2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ef5:	89 d8                	mov    %ebx,%eax
  801ef7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5e                   	pop    %esi
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801efe:	68 66 29 80 00       	push   $0x802966
  801f03:	68 08 29 80 00       	push   $0x802908
  801f08:	6a 62                	push   $0x62
  801f0a:	68 7b 29 80 00       	push   $0x80297b
  801f0f:	e8 cd e2 ff ff       	call   8001e1 <_panic>

00801f14 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	53                   	push   %ebx
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f26:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f2c:	7f 2e                	jg     801f5c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	53                   	push   %ebx
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	68 0c 60 80 00       	push   $0x80600c
  801f3a:	e8 e7 ea ff ff       	call   800a26 <memmove>
	nsipcbuf.send.req_size = size;
  801f3f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f45:	8b 45 14             	mov    0x14(%ebp),%eax
  801f48:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f4d:	b8 08 00 00 00       	mov    $0x8,%eax
  801f52:	e8 eb fd ff ff       	call   801d42 <nsipc>
}
  801f57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    
	assert(size < 1600);
  801f5c:	68 87 29 80 00       	push   $0x802987
  801f61:	68 08 29 80 00       	push   $0x802908
  801f66:	6a 6d                	push   $0x6d
  801f68:	68 7b 29 80 00       	push   $0x80297b
  801f6d:	e8 6f e2 ff ff       	call   8001e1 <_panic>

00801f72 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f83:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f88:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f90:	b8 09 00 00 00       	mov    $0x9,%eax
  801f95:	e8 a8 fd ff ff       	call   801d42 <nsipc>
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	c3                   	ret    

00801fa2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa8:	68 93 29 80 00       	push   $0x802993
  801fad:	ff 75 0c             	pushl  0xc(%ebp)
  801fb0:	e8 e3 e8 ff ff       	call   800898 <strcpy>
	return 0;
}
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <devcons_write>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	57                   	push   %edi
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fcd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd6:	73 31                	jae    802009 <devcons_write+0x4d>
		m = n - tot;
  801fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fdb:	29 f3                	sub    %esi,%ebx
  801fdd:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	53                   	push   %ebx
  801fec:	89 f0                	mov    %esi,%eax
  801fee:	03 45 0c             	add    0xc(%ebp),%eax
  801ff1:	50                   	push   %eax
  801ff2:	57                   	push   %edi
  801ff3:	e8 2e ea ff ff       	call   800a26 <memmove>
		sys_cputs(buf, m);
  801ff8:	83 c4 08             	add    $0x8,%esp
  801ffb:	53                   	push   %ebx
  801ffc:	57                   	push   %edi
  801ffd:	e8 cc eb ff ff       	call   800bce <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802002:	01 de                	add    %ebx,%esi
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	eb ca                	jmp    801fd3 <devcons_write+0x17>
}
  802009:	89 f0                	mov    %esi,%eax
  80200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5e                   	pop    %esi
  802010:	5f                   	pop    %edi
  802011:	5d                   	pop    %ebp
  802012:	c3                   	ret    

00802013 <devcons_read>:
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 08             	sub    $0x8,%esp
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80201e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802022:	74 21                	je     802045 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802024:	e8 c3 eb ff ff       	call   800bec <sys_cgetc>
  802029:	85 c0                	test   %eax,%eax
  80202b:	75 07                	jne    802034 <devcons_read+0x21>
		sys_yield();
  80202d:	e8 39 ec ff ff       	call   800c6b <sys_yield>
  802032:	eb f0                	jmp    802024 <devcons_read+0x11>
	if (c < 0)
  802034:	78 0f                	js     802045 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802036:	83 f8 04             	cmp    $0x4,%eax
  802039:	74 0c                	je     802047 <devcons_read+0x34>
	*(char*)vbuf = c;
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	88 02                	mov    %al,(%edx)
	return 1;
  802040:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    
		return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	eb f7                	jmp    802045 <devcons_read+0x32>

0080204e <cputchar>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80205a:	6a 01                	push   $0x1
  80205c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205f:	50                   	push   %eax
  802060:	e8 69 eb ff ff       	call   800bce <sys_cputs>
}
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <getchar>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802070:	6a 01                	push   $0x1
  802072:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	6a 00                	push   $0x0
  802078:	e8 06 f1 ff ff       	call   801183 <read>
	if (r < 0)
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	78 06                	js     80208a <getchar+0x20>
	if (r < 1)
  802084:	74 06                	je     80208c <getchar+0x22>
	return c;
  802086:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    
		return -E_EOF;
  80208c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802091:	eb f7                	jmp    80208a <getchar+0x20>

00802093 <iscons>:
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802099:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209c:	50                   	push   %eax
  80209d:	ff 75 08             	pushl  0x8(%ebp)
  8020a0:	e8 6e ee ff ff       	call   800f13 <fd_lookup>
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	78 11                	js     8020bd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8020b5:	39 10                	cmp    %edx,(%eax)
  8020b7:	0f 94 c0             	sete   %al
  8020ba:	0f b6 c0             	movzbl %al,%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <opencons>:
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c8:	50                   	push   %eax
  8020c9:	e8 f3 ed ff ff       	call   800ec1 <fd_alloc>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 3a                	js     80210f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 07 04 00 00       	push   $0x407
  8020dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 a3 eb ff ff       	call   800c8a <sys_page_alloc>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 21                	js     80210f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8020f7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802103:	83 ec 0c             	sub    $0xc,%esp
  802106:	50                   	push   %eax
  802107:	e8 8e ed ff ff       	call   800e9a <fd2num>
  80210c:	83 c4 10             	add    $0x10,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
  802116:	8b 75 08             	mov    0x8(%ebp),%esi
  802119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80211f:	85 c0                	test   %eax,%eax
  802121:	74 4f                	je     802172 <ipc_recv+0x61>
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	50                   	push   %eax
  802127:	e8 0e ed ff ff       	call   800e3a <sys_ipc_recv>
  80212c:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  80212f:	85 f6                	test   %esi,%esi
  802131:	74 14                	je     802147 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 09                	jne    802145 <ipc_recv+0x34>
  80213c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802142:	8b 52 74             	mov    0x74(%edx),%edx
  802145:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802147:	85 db                	test   %ebx,%ebx
  802149:	74 14                	je     80215f <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80214b:	ba 00 00 00 00       	mov    $0x0,%edx
  802150:	85 c0                	test   %eax,%eax
  802152:	75 09                	jne    80215d <ipc_recv+0x4c>
  802154:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80215a:	8b 52 78             	mov    0x78(%edx),%edx
  80215d:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80215f:	85 c0                	test   %eax,%eax
  802161:	75 08                	jne    80216b <ipc_recv+0x5a>
  802163:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802168:	8b 40 70             	mov    0x70(%eax),%eax
}
  80216b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5e                   	pop    %esi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802172:	83 ec 0c             	sub    $0xc,%esp
  802175:	68 00 00 c0 ee       	push   $0xeec00000
  80217a:	e8 bb ec ff ff       	call   800e3a <sys_ipc_recv>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	eb ab                	jmp    80212f <ipc_recv+0x1e>

00802184 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	57                   	push   %edi
  802188:	56                   	push   %esi
  802189:	53                   	push   %ebx
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802190:	8b 75 10             	mov    0x10(%ebp),%esi
  802193:	eb 20                	jmp    8021b5 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802195:	6a 00                	push   $0x0
  802197:	68 00 00 c0 ee       	push   $0xeec00000
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	57                   	push   %edi
  8021a0:	e8 72 ec ff ff       	call   800e17 <sys_ipc_try_send>
  8021a5:	89 c3                	mov    %eax,%ebx
  8021a7:	83 c4 10             	add    $0x10,%esp
  8021aa:	eb 1f                	jmp    8021cb <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8021ac:	e8 ba ea ff ff       	call   800c6b <sys_yield>
	while(retval != 0) {
  8021b1:	85 db                	test   %ebx,%ebx
  8021b3:	74 33                	je     8021e8 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8021b5:	85 f6                	test   %esi,%esi
  8021b7:	74 dc                	je     802195 <ipc_send+0x11>
  8021b9:	ff 75 14             	pushl  0x14(%ebp)
  8021bc:	56                   	push   %esi
  8021bd:	ff 75 0c             	pushl  0xc(%ebp)
  8021c0:	57                   	push   %edi
  8021c1:	e8 51 ec ff ff       	call   800e17 <sys_ipc_try_send>
  8021c6:	89 c3                	mov    %eax,%ebx
  8021c8:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8021cb:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8021ce:	74 dc                	je     8021ac <ipc_send+0x28>
  8021d0:	85 db                	test   %ebx,%ebx
  8021d2:	74 d8                	je     8021ac <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 a0 29 80 00       	push   $0x8029a0
  8021dc:	6a 35                	push   $0x35
  8021de:	68 d0 29 80 00       	push   $0x8029d0
  8021e3:	e8 f9 df ff ff       	call   8001e1 <_panic>
	}
}
  8021e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021eb:	5b                   	pop    %ebx
  8021ec:	5e                   	pop    %esi
  8021ed:	5f                   	pop    %edi
  8021ee:	5d                   	pop    %ebp
  8021ef:	c3                   	ret    

008021f0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021fb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021fe:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802204:	8b 52 50             	mov    0x50(%edx),%edx
  802207:	39 ca                	cmp    %ecx,%edx
  802209:	74 11                	je     80221c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80220b:	83 c0 01             	add    $0x1,%eax
  80220e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802213:	75 e6                	jne    8021fb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	eb 0b                	jmp    802227 <ipc_find_env+0x37>
			return envs[i].env_id;
  80221c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80221f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802224:	8b 40 48             	mov    0x48(%eax),%eax
}
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    

00802229 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80222f:	89 d0                	mov    %edx,%eax
  802231:	c1 e8 16             	shr    $0x16,%eax
  802234:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802240:	f6 c1 01             	test   $0x1,%cl
  802243:	74 1d                	je     802262 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802245:	c1 ea 0c             	shr    $0xc,%edx
  802248:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80224f:	f6 c2 01             	test   $0x1,%dl
  802252:	74 0e                	je     802262 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802254:	c1 ea 0c             	shr    $0xc,%edx
  802257:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80225e:	ef 
  80225f:	0f b7 c0             	movzwl %ax,%eax
}
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    
  802264:	66 90                	xchg   %ax,%ax
  802266:	66 90                	xchg   %ax,%ax
  802268:	66 90                	xchg   %ax,%ax
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	66 90                	xchg   %ax,%ax
  80226e:	66 90                	xchg   %ax,%ax

00802270 <__udivdi3>:
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	57                   	push   %edi
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	83 ec 1c             	sub    $0x1c,%esp
  80227b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80227f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802283:	8b 74 24 34          	mov    0x34(%esp),%esi
  802287:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80228b:	85 d2                	test   %edx,%edx
  80228d:	75 49                	jne    8022d8 <__udivdi3+0x68>
  80228f:	39 f3                	cmp    %esi,%ebx
  802291:	76 15                	jbe    8022a8 <__udivdi3+0x38>
  802293:	31 ff                	xor    %edi,%edi
  802295:	89 e8                	mov    %ebp,%eax
  802297:	89 f2                	mov    %esi,%edx
  802299:	f7 f3                	div    %ebx
  80229b:	89 fa                	mov    %edi,%edx
  80229d:	83 c4 1c             	add    $0x1c,%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5f                   	pop    %edi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    
  8022a5:	8d 76 00             	lea    0x0(%esi),%esi
  8022a8:	89 d9                	mov    %ebx,%ecx
  8022aa:	85 db                	test   %ebx,%ebx
  8022ac:	75 0b                	jne    8022b9 <__udivdi3+0x49>
  8022ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	f7 f3                	div    %ebx
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	31 d2                	xor    %edx,%edx
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 c6                	mov    %eax,%esi
  8022c1:	89 e8                	mov    %ebp,%eax
  8022c3:	89 f7                	mov    %esi,%edi
  8022c5:	f7 f1                	div    %ecx
  8022c7:	89 fa                	mov    %edi,%edx
  8022c9:	83 c4 1c             	add    $0x1c,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5f                   	pop    %edi
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    
  8022d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	77 1c                	ja     8022f8 <__udivdi3+0x88>
  8022dc:	0f bd fa             	bsr    %edx,%edi
  8022df:	83 f7 1f             	xor    $0x1f,%edi
  8022e2:	75 2c                	jne    802310 <__udivdi3+0xa0>
  8022e4:	39 f2                	cmp    %esi,%edx
  8022e6:	72 06                	jb     8022ee <__udivdi3+0x7e>
  8022e8:	31 c0                	xor    %eax,%eax
  8022ea:	39 eb                	cmp    %ebp,%ebx
  8022ec:	77 ad                	ja     80229b <__udivdi3+0x2b>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	eb a6                	jmp    80229b <__udivdi3+0x2b>
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	31 ff                	xor    %edi,%edi
  8022fa:	31 c0                	xor    %eax,%eax
  8022fc:	89 fa                	mov    %edi,%edx
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	89 f9                	mov    %edi,%ecx
  802312:	b8 20 00 00 00       	mov    $0x20,%eax
  802317:	29 f8                	sub    %edi,%eax
  802319:	d3 e2                	shl    %cl,%edx
  80231b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80231f:	89 c1                	mov    %eax,%ecx
  802321:	89 da                	mov    %ebx,%edx
  802323:	d3 ea                	shr    %cl,%edx
  802325:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802329:	09 d1                	or     %edx,%ecx
  80232b:	89 f2                	mov    %esi,%edx
  80232d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802331:	89 f9                	mov    %edi,%ecx
  802333:	d3 e3                	shl    %cl,%ebx
  802335:	89 c1                	mov    %eax,%ecx
  802337:	d3 ea                	shr    %cl,%edx
  802339:	89 f9                	mov    %edi,%ecx
  80233b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80233f:	89 eb                	mov    %ebp,%ebx
  802341:	d3 e6                	shl    %cl,%esi
  802343:	89 c1                	mov    %eax,%ecx
  802345:	d3 eb                	shr    %cl,%ebx
  802347:	09 de                	or     %ebx,%esi
  802349:	89 f0                	mov    %esi,%eax
  80234b:	f7 74 24 08          	divl   0x8(%esp)
  80234f:	89 d6                	mov    %edx,%esi
  802351:	89 c3                	mov    %eax,%ebx
  802353:	f7 64 24 0c          	mull   0xc(%esp)
  802357:	39 d6                	cmp    %edx,%esi
  802359:	72 15                	jb     802370 <__udivdi3+0x100>
  80235b:	89 f9                	mov    %edi,%ecx
  80235d:	d3 e5                	shl    %cl,%ebp
  80235f:	39 c5                	cmp    %eax,%ebp
  802361:	73 04                	jae    802367 <__udivdi3+0xf7>
  802363:	39 d6                	cmp    %edx,%esi
  802365:	74 09                	je     802370 <__udivdi3+0x100>
  802367:	89 d8                	mov    %ebx,%eax
  802369:	31 ff                	xor    %edi,%edi
  80236b:	e9 2b ff ff ff       	jmp    80229b <__udivdi3+0x2b>
  802370:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802373:	31 ff                	xor    %edi,%edi
  802375:	e9 21 ff ff ff       	jmp    80229b <__udivdi3+0x2b>
  80237a:	66 90                	xchg   %ax,%ax
  80237c:	66 90                	xchg   %ax,%ax
  80237e:	66 90                	xchg   %ax,%ax

00802380 <__umoddi3>:
  802380:	f3 0f 1e fb          	endbr32 
  802384:	55                   	push   %ebp
  802385:	57                   	push   %edi
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	83 ec 1c             	sub    $0x1c,%esp
  80238b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80238f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802393:	8b 74 24 30          	mov    0x30(%esp),%esi
  802397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80239b:	89 da                	mov    %ebx,%edx
  80239d:	85 c0                	test   %eax,%eax
  80239f:	75 3f                	jne    8023e0 <__umoddi3+0x60>
  8023a1:	39 df                	cmp    %ebx,%edi
  8023a3:	76 13                	jbe    8023b8 <__umoddi3+0x38>
  8023a5:	89 f0                	mov    %esi,%eax
  8023a7:	f7 f7                	div    %edi
  8023a9:	89 d0                	mov    %edx,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	83 c4 1c             	add    $0x1c,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5e                   	pop    %esi
  8023b2:	5f                   	pop    %edi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	89 fd                	mov    %edi,%ebp
  8023ba:	85 ff                	test   %edi,%edi
  8023bc:	75 0b                	jne    8023c9 <__umoddi3+0x49>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f7                	div    %edi
  8023c7:	89 c5                	mov    %eax,%ebp
  8023c9:	89 d8                	mov    %ebx,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f5                	div    %ebp
  8023cf:	89 f0                	mov    %esi,%eax
  8023d1:	f7 f5                	div    %ebp
  8023d3:	89 d0                	mov    %edx,%eax
  8023d5:	eb d4                	jmp    8023ab <__umoddi3+0x2b>
  8023d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023de:	66 90                	xchg   %ax,%ax
  8023e0:	89 f1                	mov    %esi,%ecx
  8023e2:	39 d8                	cmp    %ebx,%eax
  8023e4:	76 0a                	jbe    8023f0 <__umoddi3+0x70>
  8023e6:	89 f0                	mov    %esi,%eax
  8023e8:	83 c4 1c             	add    $0x1c,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5e                   	pop    %esi
  8023ed:	5f                   	pop    %edi
  8023ee:	5d                   	pop    %ebp
  8023ef:	c3                   	ret    
  8023f0:	0f bd e8             	bsr    %eax,%ebp
  8023f3:	83 f5 1f             	xor    $0x1f,%ebp
  8023f6:	75 20                	jne    802418 <__umoddi3+0x98>
  8023f8:	39 d8                	cmp    %ebx,%eax
  8023fa:	0f 82 b0 00 00 00    	jb     8024b0 <__umoddi3+0x130>
  802400:	39 f7                	cmp    %esi,%edi
  802402:	0f 86 a8 00 00 00    	jbe    8024b0 <__umoddi3+0x130>
  802408:	89 c8                	mov    %ecx,%eax
  80240a:	83 c4 1c             	add    $0x1c,%esp
  80240d:	5b                   	pop    %ebx
  80240e:	5e                   	pop    %esi
  80240f:	5f                   	pop    %edi
  802410:	5d                   	pop    %ebp
  802411:	c3                   	ret    
  802412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802418:	89 e9                	mov    %ebp,%ecx
  80241a:	ba 20 00 00 00       	mov    $0x20,%edx
  80241f:	29 ea                	sub    %ebp,%edx
  802421:	d3 e0                	shl    %cl,%eax
  802423:	89 44 24 08          	mov    %eax,0x8(%esp)
  802427:	89 d1                	mov    %edx,%ecx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	d3 e8                	shr    %cl,%eax
  80242d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802431:	89 54 24 04          	mov    %edx,0x4(%esp)
  802435:	8b 54 24 04          	mov    0x4(%esp),%edx
  802439:	09 c1                	or     %eax,%ecx
  80243b:	89 d8                	mov    %ebx,%eax
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 e9                	mov    %ebp,%ecx
  802443:	d3 e7                	shl    %cl,%edi
  802445:	89 d1                	mov    %edx,%ecx
  802447:	d3 e8                	shr    %cl,%eax
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80244f:	d3 e3                	shl    %cl,%ebx
  802451:	89 c7                	mov    %eax,%edi
  802453:	89 d1                	mov    %edx,%ecx
  802455:	89 f0                	mov    %esi,%eax
  802457:	d3 e8                	shr    %cl,%eax
  802459:	89 e9                	mov    %ebp,%ecx
  80245b:	89 fa                	mov    %edi,%edx
  80245d:	d3 e6                	shl    %cl,%esi
  80245f:	09 d8                	or     %ebx,%eax
  802461:	f7 74 24 08          	divl   0x8(%esp)
  802465:	89 d1                	mov    %edx,%ecx
  802467:	89 f3                	mov    %esi,%ebx
  802469:	f7 64 24 0c          	mull   0xc(%esp)
  80246d:	89 c6                	mov    %eax,%esi
  80246f:	89 d7                	mov    %edx,%edi
  802471:	39 d1                	cmp    %edx,%ecx
  802473:	72 06                	jb     80247b <__umoddi3+0xfb>
  802475:	75 10                	jne    802487 <__umoddi3+0x107>
  802477:	39 c3                	cmp    %eax,%ebx
  802479:	73 0c                	jae    802487 <__umoddi3+0x107>
  80247b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80247f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802483:	89 d7                	mov    %edx,%edi
  802485:	89 c6                	mov    %eax,%esi
  802487:	89 ca                	mov    %ecx,%edx
  802489:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80248e:	29 f3                	sub    %esi,%ebx
  802490:	19 fa                	sbb    %edi,%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	d3 e0                	shl    %cl,%eax
  802496:	89 e9                	mov    %ebp,%ecx
  802498:	d3 eb                	shr    %cl,%ebx
  80249a:	d3 ea                	shr    %cl,%edx
  80249c:	09 d8                	or     %ebx,%eax
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	89 da                	mov    %ebx,%edx
  8024b2:	29 fe                	sub    %edi,%esi
  8024b4:	19 c2                	sbb    %eax,%edx
  8024b6:	89 f1                	mov    %esi,%ecx
  8024b8:	89 c8                	mov    %ecx,%eax
  8024ba:	e9 4b ff ff ff       	jmp    80240a <__umoddi3+0x8a>
