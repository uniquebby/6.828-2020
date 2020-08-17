
obj/user/primes.debug：     文件格式 elf32-i386


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

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 68 11 00 00       	call   8011b4 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 40 80 00       	mov    0x804008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 60 27 80 00       	push   $0x802760
  800060:	e8 cc 01 00 00       	call   800231 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 1c 0f 00 00       	call   800f86 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 07                	js     80007a <primeproc+0x47>
		panic("fork: %e", id);
	if (id == 0)
  800073:	74 ca                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800075:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800078:	eb 20                	jmp    80009a <primeproc+0x67>
		panic("fork: %e", id);
  80007a:	50                   	push   %eax
  80007b:	68 6c 27 80 00       	push   $0x80276c
  800080:	6a 1a                	push   $0x1a
  800082:	68 75 27 80 00       	push   $0x802775
  800087:	e8 ca 00 00 00       	call   800156 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 90 11 00 00       	call   801227 <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 0d 11 00 00       	call   8011b4 <ipc_recv>
  8000a7:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000a9:	99                   	cltd   
  8000aa:	f7 fb                	idiv   %ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 d2                	test   %edx,%edx
  8000b1:	74 e7                	je     80009a <primeproc+0x67>
  8000b3:	eb d7                	jmp    80008c <primeproc+0x59>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 c7 0e 00 00       	call   800f86 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1a                	js     8000df <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	74 25                	je     8000f1 <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	6a 00                	push   $0x0
  8000d0:	53                   	push   %ebx
  8000d1:	56                   	push   %esi
  8000d2:	e8 50 11 00 00       	call   801227 <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 6c 27 80 00       	push   $0x80276c
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 75 27 80 00       	push   $0x802775
  8000ec:	e8 65 00 00 00       	call   800156 <_panic>
		primeproc();
  8000f1:	e8 3d ff ff ff       	call   800033 <primeproc>

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
  800128:	e8 88 ff ff ff       	call   8000b5 <umain>

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
  800142:	e8 5d 13 00 00       	call   8014a4 <close_all>
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
  800174:	68 90 27 80 00       	push   $0x802790
  800179:	e8 b3 00 00 00       	call   800231 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017e:	83 c4 18             	add    $0x18,%esp
  800181:	53                   	push   %ebx
  800182:	ff 75 10             	pushl  0x10(%ebp)
  800185:	e8 56 00 00 00       	call   8001e0 <vcprintf>
	cprintf("\n");
  80018a:	c7 04 24 77 2d 80 00 	movl   $0x802d77,(%esp)
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
  8002ad:	e8 5e 22 00 00       	call   802510 <__udivdi3>
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
  8002d6:	e8 45 23 00 00       	call   802620 <__umoddi3>
  8002db:	83 c4 14             	add    $0x14,%esp
  8002de:	0f be 80 b3 27 80 00 	movsbl 0x8027b3(%eax),%eax
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
  800398:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
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
  800464:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 18                	je     800487 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80046f:	52                   	push   %edx
  800470:	68 3e 2d 80 00       	push   $0x802d3e
  800475:	53                   	push   %ebx
  800476:	56                   	push   %esi
  800477:	e8 94 fe ff ff       	call   800310 <printfmt>
  80047c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800482:	e9 67 02 00 00       	jmp    8006ee <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800487:	50                   	push   %eax
  800488:	68 cb 27 80 00       	push   $0x8027cb
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
  8004af:	b8 c4 27 80 00       	mov    $0x8027c4,%eax
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
  800bb0:	68 bf 2a 80 00       	push   $0x802abf
  800bb5:	6a 23                	push   $0x23
  800bb7:	68 dc 2a 80 00       	push   $0x802adc
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
  800c31:	68 bf 2a 80 00       	push   $0x802abf
  800c36:	6a 23                	push   $0x23
  800c38:	68 dc 2a 80 00       	push   $0x802adc
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
  800c73:	68 bf 2a 80 00       	push   $0x802abf
  800c78:	6a 23                	push   $0x23
  800c7a:	68 dc 2a 80 00       	push   $0x802adc
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
  800cb5:	68 bf 2a 80 00       	push   $0x802abf
  800cba:	6a 23                	push   $0x23
  800cbc:	68 dc 2a 80 00       	push   $0x802adc
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
  800cf7:	68 bf 2a 80 00       	push   $0x802abf
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 dc 2a 80 00       	push   $0x802adc
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
  800d39:	68 bf 2a 80 00       	push   $0x802abf
  800d3e:	6a 23                	push   $0x23
  800d40:	68 dc 2a 80 00       	push   $0x802adc
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
  800d7b:	68 bf 2a 80 00       	push   $0x802abf
  800d80:	6a 23                	push   $0x23
  800d82:	68 dc 2a 80 00       	push   $0x802adc
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
  800ddf:	68 bf 2a 80 00       	push   $0x802abf
  800de4:	6a 23                	push   $0x23
  800de6:	68 dc 2a 80 00       	push   $0x802adc
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

00800e0f <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e1b:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800e1d:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e20:	89 d9                	mov    %ebx,%ecx
  800e22:	c1 e9 16             	shr    $0x16,%ecx
  800e25:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800e2c:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800e31:	f6 c1 01             	test   $0x1,%cl
  800e34:	74 0c                	je     800e42 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800e36:	89 d9                	mov    %ebx,%ecx
  800e38:	c1 e9 0c             	shr    $0xc,%ecx
  800e3b:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800e42:	f6 c2 02             	test   $0x2,%dl
  800e45:	0f 84 a3 00 00 00    	je     800eee <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800e4b:	89 da                	mov    %ebx,%edx
  800e4d:	c1 ea 0c             	shr    $0xc,%edx
  800e50:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e57:	f6 c6 08             	test   $0x8,%dh
  800e5a:	0f 84 b7 00 00 00    	je     800f17 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800e60:	e8 5c fd ff ff       	call   800bc1 <sys_getenvid>
  800e65:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e67:	83 ec 04             	sub    $0x4,%esp
  800e6a:	6a 07                	push   $0x7
  800e6c:	68 00 f0 7f 00       	push   $0x7ff000
  800e71:	50                   	push   %eax
  800e72:	e8 88 fd ff ff       	call   800bff <sys_page_alloc>
  800e77:	83 c4 10             	add    $0x10,%esp
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	0f 88 bc 00 00 00    	js     800f3e <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800e82:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800e88:	83 ec 04             	sub    $0x4,%esp
  800e8b:	68 00 10 00 00       	push   $0x1000
  800e90:	53                   	push   %ebx
  800e91:	68 00 f0 7f 00       	push   $0x7ff000
  800e96:	e8 00 fb ff ff       	call   80099b <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800e9b:	83 c4 08             	add    $0x8,%esp
  800e9e:	53                   	push   %ebx
  800e9f:	56                   	push   %esi
  800ea0:	e8 df fd ff ff       	call   800c84 <sys_page_unmap>
  800ea5:	83 c4 10             	add    $0x10,%esp
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	0f 88 a0 00 00 00    	js     800f50 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	6a 07                	push   $0x7
  800eb5:	53                   	push   %ebx
  800eb6:	56                   	push   %esi
  800eb7:	68 00 f0 7f 00       	push   $0x7ff000
  800ebc:	56                   	push   %esi
  800ebd:	e8 80 fd ff ff       	call   800c42 <sys_page_map>
  800ec2:	83 c4 20             	add    $0x20,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	0f 88 95 00 00 00    	js     800f62 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	68 00 f0 7f 00       	push   $0x7ff000
  800ed5:	56                   	push   %esi
  800ed6:	e8 a9 fd ff ff       	call   800c84 <sys_page_unmap>
  800edb:	83 c4 10             	add    $0x10,%esp
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	0f 88 8e 00 00 00    	js     800f74 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800eee:	8b 70 28             	mov    0x28(%eax),%esi
  800ef1:	e8 cb fc ff ff       	call   800bc1 <sys_getenvid>
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	50                   	push   %eax
  800ef9:	68 ec 2a 80 00       	push   $0x802aec
  800efe:	e8 2e f3 ff ff       	call   800231 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800f03:	83 c4 0c             	add    $0xc,%esp
  800f06:	68 10 2b 80 00       	push   $0x802b10
  800f0b:	6a 27                	push   $0x27
  800f0d:	68 e4 2b 80 00       	push   $0x802be4
  800f12:	e8 3f f2 ff ff       	call   800156 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800f17:	8b 78 28             	mov    0x28(%eax),%edi
  800f1a:	e8 a2 fc ff ff       	call   800bc1 <sys_getenvid>
  800f1f:	57                   	push   %edi
  800f20:	53                   	push   %ebx
  800f21:	50                   	push   %eax
  800f22:	68 ec 2a 80 00       	push   $0x802aec
  800f27:	e8 05 f3 ff ff       	call   800231 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  800f2c:	56                   	push   %esi
  800f2d:	68 44 2b 80 00       	push   $0x802b44
  800f32:	6a 2b                	push   $0x2b
  800f34:	68 e4 2b 80 00       	push   $0x802be4
  800f39:	e8 18 f2 ff ff       	call   800156 <_panic>
      panic("pgfault: page allocation failed %e", r);
  800f3e:	50                   	push   %eax
  800f3f:	68 7c 2b 80 00       	push   $0x802b7c
  800f44:	6a 39                	push   $0x39
  800f46:	68 e4 2b 80 00       	push   $0x802be4
  800f4b:	e8 06 f2 ff ff       	call   800156 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f50:	50                   	push   %eax
  800f51:	68 a0 2b 80 00       	push   $0x802ba0
  800f56:	6a 3e                	push   $0x3e
  800f58:	68 e4 2b 80 00       	push   $0x802be4
  800f5d:	e8 f4 f1 ff ff       	call   800156 <_panic>
      panic("pgfault: page map failed (%e)", r);
  800f62:	50                   	push   %eax
  800f63:	68 ef 2b 80 00       	push   $0x802bef
  800f68:	6a 40                	push   $0x40
  800f6a:	68 e4 2b 80 00       	push   $0x802be4
  800f6f:	e8 e2 f1 ff ff       	call   800156 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  800f74:	50                   	push   %eax
  800f75:	68 a0 2b 80 00       	push   $0x802ba0
  800f7a:	6a 42                	push   $0x42
  800f7c:	68 e4 2b 80 00       	push   $0x802be4
  800f81:	e8 d0 f1 ff ff       	call   800156 <_panic>

00800f86 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
  800f8c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  800f8f:	68 0f 0e 80 00       	push   $0x800e0f
  800f94:	e8 96 14 00 00       	call   80242f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f99:	b8 07 00 00 00       	mov    $0x7,%eax
  800f9e:	cd 30                	int    $0x30
  800fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 2d                	js     800fd7 <fork+0x51>
  800faa:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  800fb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb5:	0f 85 a6 00 00 00    	jne    801061 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  800fbb:	e8 01 fc ff ff       	call   800bc1 <sys_getenvid>
  800fc0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fc5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fc8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fcd:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  800fd2:	e9 79 01 00 00       	jmp    801150 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  800fd7:	50                   	push   %eax
  800fd8:	68 6c 27 80 00       	push   $0x80276c
  800fdd:	68 aa 00 00 00       	push   $0xaa
  800fe2:	68 e4 2b 80 00       	push   $0x802be4
  800fe7:	e8 6a f1 ff ff       	call   800156 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	6a 05                	push   $0x5
  800ff1:	53                   	push   %ebx
  800ff2:	57                   	push   %edi
  800ff3:	53                   	push   %ebx
  800ff4:	6a 00                	push   $0x0
  800ff6:	e8 47 fc ff ff       	call   800c42 <sys_page_map>
  800ffb:	83 c4 20             	add    $0x20,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	79 4d                	jns    80104f <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801002:	50                   	push   %eax
  801003:	68 0d 2c 80 00       	push   $0x802c0d
  801008:	6a 61                	push   $0x61
  80100a:	68 e4 2b 80 00       	push   $0x802be4
  80100f:	e8 42 f1 ff ff       	call   800156 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	68 05 08 00 00       	push   $0x805
  80101c:	53                   	push   %ebx
  80101d:	57                   	push   %edi
  80101e:	53                   	push   %ebx
  80101f:	6a 00                	push   $0x0
  801021:	e8 1c fc ff ff       	call   800c42 <sys_page_map>
  801026:	83 c4 20             	add    $0x20,%esp
  801029:	85 c0                	test   %eax,%eax
  80102b:	0f 88 b7 00 00 00    	js     8010e8 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	68 05 08 00 00       	push   $0x805
  801039:	53                   	push   %ebx
  80103a:	6a 00                	push   $0x0
  80103c:	53                   	push   %ebx
  80103d:	6a 00                	push   $0x0
  80103f:	e8 fe fb ff ff       	call   800c42 <sys_page_map>
  801044:	83 c4 20             	add    $0x20,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	0f 88 ab 00 00 00    	js     8010fa <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80104f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801055:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80105b:	0f 84 ab 00 00 00    	je     80110c <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801061:	89 d8                	mov    %ebx,%eax
  801063:	c1 e8 16             	shr    $0x16,%eax
  801066:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80106d:	a8 01                	test   $0x1,%al
  80106f:	74 de                	je     80104f <fork+0xc9>
  801071:	89 d8                	mov    %ebx,%eax
  801073:	c1 e8 0c             	shr    $0xc,%eax
  801076:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80107d:	f6 c2 01             	test   $0x1,%dl
  801080:	74 cd                	je     80104f <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801082:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801085:	89 c2                	mov    %eax,%edx
  801087:	c1 ea 16             	shr    $0x16,%edx
  80108a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801091:	f6 c2 01             	test   $0x1,%dl
  801094:	74 b9                	je     80104f <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801096:	c1 e8 0c             	shr    $0xc,%eax
  801099:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  8010a0:	a8 01                	test   $0x1,%al
  8010a2:	74 ab                	je     80104f <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  8010a4:	a9 02 08 00 00       	test   $0x802,%eax
  8010a9:	0f 84 3d ff ff ff    	je     800fec <fork+0x66>
	else if(pte & PTE_SHARE)
  8010af:	f6 c4 04             	test   $0x4,%ah
  8010b2:	0f 84 5c ff ff ff    	je     801014 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8010b8:	83 ec 0c             	sub    $0xc,%esp
  8010bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c0:	50                   	push   %eax
  8010c1:	53                   	push   %ebx
  8010c2:	57                   	push   %edi
  8010c3:	53                   	push   %ebx
  8010c4:	6a 00                	push   $0x0
  8010c6:	e8 77 fb ff ff       	call   800c42 <sys_page_map>
  8010cb:	83 c4 20             	add    $0x20,%esp
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	0f 89 79 ff ff ff    	jns    80104f <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010d6:	50                   	push   %eax
  8010d7:	68 0d 2c 80 00       	push   $0x802c0d
  8010dc:	6a 67                	push   $0x67
  8010de:	68 e4 2b 80 00       	push   $0x802be4
  8010e3:	e8 6e f0 ff ff       	call   800156 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010e8:	50                   	push   %eax
  8010e9:	68 0d 2c 80 00       	push   $0x802c0d
  8010ee:	6a 6d                	push   $0x6d
  8010f0:	68 e4 2b 80 00       	push   $0x802be4
  8010f5:	e8 5c f0 ff ff       	call   800156 <_panic>
			panic("Page Map Failed: %e", error_code);
  8010fa:	50                   	push   %eax
  8010fb:	68 0d 2c 80 00       	push   $0x802c0d
  801100:	6a 70                	push   $0x70
  801102:	68 e4 2b 80 00       	push   $0x802be4
  801107:	e8 4a f0 ff ff       	call   800156 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	6a 07                	push   $0x7
  801111:	68 00 f0 bf ee       	push   $0xeebff000
  801116:	ff 75 e4             	pushl  -0x1c(%ebp)
  801119:	e8 e1 fa ff ff       	call   800bff <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	78 36                	js     80115b <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801125:	83 ec 08             	sub    $0x8,%esp
  801128:	68 a5 24 80 00       	push   $0x8024a5
  80112d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801130:	e8 15 fc ff ff       	call   800d4a <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	78 34                	js     801170 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  80113c:	83 ec 08             	sub    $0x8,%esp
  80113f:	6a 02                	push   $0x2
  801141:	ff 75 e4             	pushl  -0x1c(%ebp)
  801144:	e8 7d fb ff ff       	call   800cc6 <sys_env_set_status>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 35                	js     801185 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  801150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  80115b:	50                   	push   %eax
  80115c:	68 6c 27 80 00       	push   $0x80276c
  801161:	68 ba 00 00 00       	push   $0xba
  801166:	68 e4 2b 80 00       	push   $0x802be4
  80116b:	e8 e6 ef ff ff       	call   800156 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801170:	50                   	push   %eax
  801171:	68 c0 2b 80 00       	push   $0x802bc0
  801176:	68 bf 00 00 00       	push   $0xbf
  80117b:	68 e4 2b 80 00       	push   $0x802be4
  801180:	e8 d1 ef ff ff       	call   800156 <_panic>
      panic("sys_env_set_status: %e", r);
  801185:	50                   	push   %eax
  801186:	68 21 2c 80 00       	push   $0x802c21
  80118b:	68 c3 00 00 00       	push   $0xc3
  801190:	68 e4 2b 80 00       	push   $0x802be4
  801195:	e8 bc ef ff ff       	call   800156 <_panic>

0080119a <sfork>:

// Challenge!
int
sfork(void)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011a0:	68 38 2c 80 00       	push   $0x802c38
  8011a5:	68 cc 00 00 00       	push   $0xcc
  8011aa:	68 e4 2b 80 00       	push   $0x802be4
  8011af:	e8 a2 ef ff ff       	call   800156 <_panic>

008011b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	74 4f                	je     801215 <ipc_recv+0x61>
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 e0 fb ff ff       	call   800daf <sys_ipc_recv>
  8011cf:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8011d2:	85 f6                	test   %esi,%esi
  8011d4:	74 14                	je     8011ea <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8011d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	75 09                	jne    8011e8 <ipc_recv+0x34>
  8011df:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011e5:	8b 52 74             	mov    0x74(%edx),%edx
  8011e8:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8011ea:	85 db                	test   %ebx,%ebx
  8011ec:	74 14                	je     801202 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8011ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	75 09                	jne    801200 <ipc_recv+0x4c>
  8011f7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011fd:	8b 52 78             	mov    0x78(%edx),%edx
  801200:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801202:	85 c0                	test   %eax,%eax
  801204:	75 08                	jne    80120e <ipc_recv+0x5a>
  801206:	a1 08 40 80 00       	mov    0x804008,%eax
  80120b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80120e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	68 00 00 c0 ee       	push   $0xeec00000
  80121d:	e8 8d fb ff ff       	call   800daf <sys_ipc_recv>
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	eb ab                	jmp    8011d2 <ipc_recv+0x1e>

00801227 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	57                   	push   %edi
  80122b:	56                   	push   %esi
  80122c:	53                   	push   %ebx
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	8b 7d 08             	mov    0x8(%ebp),%edi
  801233:	8b 75 10             	mov    0x10(%ebp),%esi
  801236:	eb 20                	jmp    801258 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801238:	6a 00                	push   $0x0
  80123a:	68 00 00 c0 ee       	push   $0xeec00000
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	57                   	push   %edi
  801243:	e8 44 fb ff ff       	call   800d8c <sys_ipc_try_send>
  801248:	89 c3                	mov    %eax,%ebx
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	eb 1f                	jmp    80126e <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80124f:	e8 8c f9 ff ff       	call   800be0 <sys_yield>
	while(retval != 0) {
  801254:	85 db                	test   %ebx,%ebx
  801256:	74 33                	je     80128b <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801258:	85 f6                	test   %esi,%esi
  80125a:	74 dc                	je     801238 <ipc_send+0x11>
  80125c:	ff 75 14             	pushl  0x14(%ebp)
  80125f:	56                   	push   %esi
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	57                   	push   %edi
  801264:	e8 23 fb ff ff       	call   800d8c <sys_ipc_try_send>
  801269:	89 c3                	mov    %eax,%ebx
  80126b:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80126e:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801271:	74 dc                	je     80124f <ipc_send+0x28>
  801273:	85 db                	test   %ebx,%ebx
  801275:	74 d8                	je     80124f <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801277:	83 ec 04             	sub    $0x4,%esp
  80127a:	68 50 2c 80 00       	push   $0x802c50
  80127f:	6a 35                	push   $0x35
  801281:	68 80 2c 80 00       	push   $0x802c80
  801286:	e8 cb ee ff ff       	call   800156 <_panic>
	}
}
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80129e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012a1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012a7:	8b 52 50             	mov    0x50(%edx),%edx
  8012aa:	39 ca                	cmp    %ecx,%edx
  8012ac:	74 11                	je     8012bf <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012ae:	83 c0 01             	add    $0x1,%eax
  8012b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012b6:	75 e6                	jne    80129e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 0b                	jmp    8012ca <ipc_find_env+0x37>
			return envs[i].env_id;
  8012bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8012d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012fb:	89 c2                	mov    %eax,%edx
  8012fd:	c1 ea 16             	shr    $0x16,%edx
  801300:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801307:	f6 c2 01             	test   $0x1,%dl
  80130a:	74 2d                	je     801339 <fd_alloc+0x46>
  80130c:	89 c2                	mov    %eax,%edx
  80130e:	c1 ea 0c             	shr    $0xc,%edx
  801311:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801318:	f6 c2 01             	test   $0x1,%dl
  80131b:	74 1c                	je     801339 <fd_alloc+0x46>
  80131d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801322:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801327:	75 d2                	jne    8012fb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801332:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801337:	eb 0a                	jmp    801343 <fd_alloc+0x50>
			*fd_store = fd;
  801339:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80134b:	83 f8 1f             	cmp    $0x1f,%eax
  80134e:	77 30                	ja     801380 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801350:	c1 e0 0c             	shl    $0xc,%eax
  801353:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801358:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80135e:	f6 c2 01             	test   $0x1,%dl
  801361:	74 24                	je     801387 <fd_lookup+0x42>
  801363:	89 c2                	mov    %eax,%edx
  801365:	c1 ea 0c             	shr    $0xc,%edx
  801368:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136f:	f6 c2 01             	test   $0x1,%dl
  801372:	74 1a                	je     80138e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	89 02                	mov    %eax,(%edx)
	return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    
		return -E_INVAL;
  801380:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801385:	eb f7                	jmp    80137e <fd_lookup+0x39>
		return -E_INVAL;
  801387:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138c:	eb f0                	jmp    80137e <fd_lookup+0x39>
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb e9                	jmp    80137e <fd_lookup+0x39>

00801395 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80139e:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013a8:	39 08                	cmp    %ecx,(%eax)
  8013aa:	74 38                	je     8013e4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8013ac:	83 c2 01             	add    $0x1,%edx
  8013af:	8b 04 95 0c 2d 80 00 	mov    0x802d0c(,%edx,4),%eax
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	75 ee                	jne    8013a8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8013bf:	8b 40 48             	mov    0x48(%eax),%eax
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	51                   	push   %ecx
  8013c6:	50                   	push   %eax
  8013c7:	68 8c 2c 80 00       	push   $0x802c8c
  8013cc:	e8 60 ee ff ff       	call   800231 <cprintf>
	*dev = 0;
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
			*dev = devtab[i];
  8013e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ee:	eb f2                	jmp    8013e2 <dev_lookup+0x4d>

008013f0 <fd_close>:
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 24             	sub    $0x24,%esp
  8013f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8013fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801402:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801409:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80140c:	50                   	push   %eax
  80140d:	e8 33 ff ff ff       	call   801345 <fd_lookup>
  801412:	89 c3                	mov    %eax,%ebx
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	78 05                	js     801420 <fd_close+0x30>
	    || fd != fd2)
  80141b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80141e:	74 16                	je     801436 <fd_close+0x46>
		return (must_exist ? r : 0);
  801420:	89 f8                	mov    %edi,%eax
  801422:	84 c0                	test   %al,%al
  801424:	b8 00 00 00 00       	mov    $0x0,%eax
  801429:	0f 44 d8             	cmove  %eax,%ebx
}
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 36                	pushl  (%esi)
  80143f:	e8 51 ff ff ff       	call   801395 <dev_lookup>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 1a                	js     801467 <fd_close+0x77>
		if (dev->dev_close)
  80144d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801450:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801453:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801458:	85 c0                	test   %eax,%eax
  80145a:	74 0b                	je     801467 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	56                   	push   %esi
  801460:	ff d0                	call   *%eax
  801462:	89 c3                	mov    %eax,%ebx
  801464:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	56                   	push   %esi
  80146b:	6a 00                	push   $0x0
  80146d:	e8 12 f8 ff ff       	call   800c84 <sys_page_unmap>
	return r;
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	eb b5                	jmp    80142c <fd_close+0x3c>

00801477 <close>:

int
close(int fdnum)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	ff 75 08             	pushl  0x8(%ebp)
  801484:	e8 bc fe ff ff       	call   801345 <fd_lookup>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	79 02                	jns    801492 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    
		return fd_close(fd, 1);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	6a 01                	push   $0x1
  801497:	ff 75 f4             	pushl  -0xc(%ebp)
  80149a:	e8 51 ff ff ff       	call   8013f0 <fd_close>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	eb ec                	jmp    801490 <close+0x19>

008014a4 <close_all>:

void
close_all(void)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	53                   	push   %ebx
  8014b4:	e8 be ff ff ff       	call   801477 <close>
	for (i = 0; i < MAXFD; i++)
  8014b9:	83 c3 01             	add    $0x1,%ebx
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	83 fb 20             	cmp    $0x20,%ebx
  8014c2:	75 ec                	jne    8014b0 <close_all+0xc>
}
  8014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 67 fe ff ff       	call   801345 <fd_lookup>
  8014de:	89 c3                	mov    %eax,%ebx
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	0f 88 81 00 00 00    	js     80156c <dup+0xa3>
		return r;
	close(newfdnum);
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	e8 81 ff ff ff       	call   801477 <close>

	newfd = INDEX2FD(newfdnum);
  8014f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014f9:	c1 e6 0c             	shl    $0xc,%esi
  8014fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801502:	83 c4 04             	add    $0x4,%esp
  801505:	ff 75 e4             	pushl  -0x1c(%ebp)
  801508:	e8 cf fd ff ff       	call   8012dc <fd2data>
  80150d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80150f:	89 34 24             	mov    %esi,(%esp)
  801512:	e8 c5 fd ff ff       	call   8012dc <fd2data>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80151c:	89 d8                	mov    %ebx,%eax
  80151e:	c1 e8 16             	shr    $0x16,%eax
  801521:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801528:	a8 01                	test   $0x1,%al
  80152a:	74 11                	je     80153d <dup+0x74>
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	c1 e8 0c             	shr    $0xc,%eax
  801531:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801538:	f6 c2 01             	test   $0x1,%dl
  80153b:	75 39                	jne    801576 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80153d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801540:	89 d0                	mov    %edx,%eax
  801542:	c1 e8 0c             	shr    $0xc,%eax
  801545:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	25 07 0e 00 00       	and    $0xe07,%eax
  801554:	50                   	push   %eax
  801555:	56                   	push   %esi
  801556:	6a 00                	push   $0x0
  801558:	52                   	push   %edx
  801559:	6a 00                	push   $0x0
  80155b:	e8 e2 f6 ff ff       	call   800c42 <sys_page_map>
  801560:	89 c3                	mov    %eax,%ebx
  801562:	83 c4 20             	add    $0x20,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 31                	js     80159a <dup+0xd1>
		goto err;

	return newfdnum;
  801569:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80156c:	89 d8                	mov    %ebx,%eax
  80156e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801571:	5b                   	pop    %ebx
  801572:	5e                   	pop    %esi
  801573:	5f                   	pop    %edi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801576:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	25 07 0e 00 00       	and    $0xe07,%eax
  801585:	50                   	push   %eax
  801586:	57                   	push   %edi
  801587:	6a 00                	push   $0x0
  801589:	53                   	push   %ebx
  80158a:	6a 00                	push   $0x0
  80158c:	e8 b1 f6 ff ff       	call   800c42 <sys_page_map>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	83 c4 20             	add    $0x20,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	79 a3                	jns    80153d <dup+0x74>
	sys_page_unmap(0, newfd);
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	56                   	push   %esi
  80159e:	6a 00                	push   $0x0
  8015a0:	e8 df f6 ff ff       	call   800c84 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015a5:	83 c4 08             	add    $0x8,%esp
  8015a8:	57                   	push   %edi
  8015a9:	6a 00                	push   $0x0
  8015ab:	e8 d4 f6 ff ff       	call   800c84 <sys_page_unmap>
	return r;
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	eb b7                	jmp    80156c <dup+0xa3>

008015b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 1c             	sub    $0x1c,%esp
  8015bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c2:	50                   	push   %eax
  8015c3:	53                   	push   %ebx
  8015c4:	e8 7c fd ff ff       	call   801345 <fd_lookup>
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 3f                	js     80160f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d6:	50                   	push   %eax
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	ff 30                	pushl  (%eax)
  8015dc:	e8 b4 fd ff ff       	call   801395 <dev_lookup>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	78 27                	js     80160f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015eb:	8b 42 08             	mov    0x8(%edx),%eax
  8015ee:	83 e0 03             	and    $0x3,%eax
  8015f1:	83 f8 01             	cmp    $0x1,%eax
  8015f4:	74 1e                	je     801614 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	8b 40 08             	mov    0x8(%eax),%eax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 35                	je     801635 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	ff 75 10             	pushl  0x10(%ebp)
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	52                   	push   %edx
  80160a:	ff d0                	call   *%eax
  80160c:	83 c4 10             	add    $0x10,%esp
}
  80160f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801612:	c9                   	leave  
  801613:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801614:	a1 08 40 80 00       	mov    0x804008,%eax
  801619:	8b 40 48             	mov    0x48(%eax),%eax
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	53                   	push   %ebx
  801620:	50                   	push   %eax
  801621:	68 d0 2c 80 00       	push   $0x802cd0
  801626:	e8 06 ec ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb da                	jmp    80160f <read+0x5a>
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163a:	eb d3                	jmp    80160f <read+0x5a>

0080163c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	8b 7d 08             	mov    0x8(%ebp),%edi
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801650:	39 f3                	cmp    %esi,%ebx
  801652:	73 23                	jae    801677 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	89 f0                	mov    %esi,%eax
  801659:	29 d8                	sub    %ebx,%eax
  80165b:	50                   	push   %eax
  80165c:	89 d8                	mov    %ebx,%eax
  80165e:	03 45 0c             	add    0xc(%ebp),%eax
  801661:	50                   	push   %eax
  801662:	57                   	push   %edi
  801663:	e8 4d ff ff ff       	call   8015b5 <read>
		if (m < 0)
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 06                	js     801675 <readn+0x39>
			return m;
		if (m == 0)
  80166f:	74 06                	je     801677 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801671:	01 c3                	add    %eax,%ebx
  801673:	eb db                	jmp    801650 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801675:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801677:	89 d8                	mov    %ebx,%eax
  801679:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167c:	5b                   	pop    %ebx
  80167d:	5e                   	pop    %esi
  80167e:	5f                   	pop    %edi
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
  801685:	83 ec 1c             	sub    $0x1c,%esp
  801688:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	53                   	push   %ebx
  801690:	e8 b0 fc ff ff       	call   801345 <fd_lookup>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 3a                	js     8016d6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169c:	83 ec 08             	sub    $0x8,%esp
  80169f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a2:	50                   	push   %eax
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	ff 30                	pushl  (%eax)
  8016a8:	e8 e8 fc ff ff       	call   801395 <dev_lookup>
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 22                	js     8016d6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016bb:	74 1e                	je     8016db <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c3:	85 d2                	test   %edx,%edx
  8016c5:	74 35                	je     8016fc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	ff 75 10             	pushl  0x10(%ebp)
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	50                   	push   %eax
  8016d1:	ff d2                	call   *%edx
  8016d3:	83 c4 10             	add    $0x10,%esp
}
  8016d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016db:	a1 08 40 80 00       	mov    0x804008,%eax
  8016e0:	8b 40 48             	mov    0x48(%eax),%eax
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	53                   	push   %ebx
  8016e7:	50                   	push   %eax
  8016e8:	68 ec 2c 80 00       	push   $0x802cec
  8016ed:	e8 3f eb ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fa:	eb da                	jmp    8016d6 <write+0x55>
		return -E_NOT_SUPP;
  8016fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801701:	eb d3                	jmp    8016d6 <write+0x55>

00801703 <seek>:

int
seek(int fdnum, off_t offset)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801709:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170c:	50                   	push   %eax
  80170d:	ff 75 08             	pushl  0x8(%ebp)
  801710:	e8 30 fc ff ff       	call   801345 <fd_lookup>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 0e                	js     80172a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80171c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801722:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	53                   	push   %ebx
  801730:	83 ec 1c             	sub    $0x1c,%esp
  801733:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801736:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801739:	50                   	push   %eax
  80173a:	53                   	push   %ebx
  80173b:	e8 05 fc ff ff       	call   801345 <fd_lookup>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 37                	js     80177e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174d:	50                   	push   %eax
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801751:	ff 30                	pushl  (%eax)
  801753:	e8 3d fc ff ff       	call   801395 <dev_lookup>
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 1f                	js     80177e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801766:	74 1b                	je     801783 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176b:	8b 52 18             	mov    0x18(%edx),%edx
  80176e:	85 d2                	test   %edx,%edx
  801770:	74 32                	je     8017a4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	50                   	push   %eax
  801779:	ff d2                	call   *%edx
  80177b:	83 c4 10             	add    $0x10,%esp
}
  80177e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801781:	c9                   	leave  
  801782:	c3                   	ret    
			thisenv->env_id, fdnum);
  801783:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801788:	8b 40 48             	mov    0x48(%eax),%eax
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	53                   	push   %ebx
  80178f:	50                   	push   %eax
  801790:	68 ac 2c 80 00       	push   $0x802cac
  801795:	e8 97 ea ff ff       	call   800231 <cprintf>
		return -E_INVAL;
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a2:	eb da                	jmp    80177e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a9:	eb d3                	jmp    80177e <ftruncate+0x52>

008017ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 1c             	sub    $0x1c,%esp
  8017b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b8:	50                   	push   %eax
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	e8 84 fb ff ff       	call   801345 <fd_lookup>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 4b                	js     801813 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	ff 30                	pushl  (%eax)
  8017d4:	e8 bc fb ff ff       	call   801395 <dev_lookup>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 33                	js     801813 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e7:	74 2f                	je     801818 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017f3:	00 00 00 
	stat->st_isdir = 0;
  8017f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017fd:	00 00 00 
	stat->st_dev = dev;
  801800:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	53                   	push   %ebx
  80180a:	ff 75 f0             	pushl  -0x10(%ebp)
  80180d:	ff 50 14             	call   *0x14(%eax)
  801810:	83 c4 10             	add    $0x10,%esp
}
  801813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801816:	c9                   	leave  
  801817:	c3                   	ret    
		return -E_NOT_SUPP;
  801818:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181d:	eb f4                	jmp    801813 <fstat+0x68>

0080181f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	56                   	push   %esi
  801823:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	6a 00                	push   $0x0
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 2f 02 00 00       	call   801a60 <open>
  801831:	89 c3                	mov    %eax,%ebx
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 1b                	js     801855 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	e8 65 ff ff ff       	call   8017ab <fstat>
  801846:	89 c6                	mov    %eax,%esi
	close(fd);
  801848:	89 1c 24             	mov    %ebx,(%esp)
  80184b:	e8 27 fc ff ff       	call   801477 <close>
	return r;
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	89 f3                	mov    %esi,%ebx
}
  801855:	89 d8                	mov    %ebx,%eax
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
  801863:	89 c6                	mov    %eax,%esi
  801865:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801867:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80186e:	74 27                	je     801897 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801870:	6a 07                	push   $0x7
  801872:	68 00 50 80 00       	push   $0x805000
  801877:	56                   	push   %esi
  801878:	ff 35 00 40 80 00    	pushl  0x804000
  80187e:	e8 a4 f9 ff ff       	call   801227 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801883:	83 c4 0c             	add    $0xc,%esp
  801886:	6a 00                	push   $0x0
  801888:	53                   	push   %ebx
  801889:	6a 00                	push   $0x0
  80188b:	e8 24 f9 ff ff       	call   8011b4 <ipc_recv>
}
  801890:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	6a 01                	push   $0x1
  80189c:	e8 f2 f9 ff ff       	call   801293 <ipc_find_env>
  8018a1:	a3 00 40 80 00       	mov    %eax,0x804000
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	eb c5                	jmp    801870 <fsipc+0x12>

008018ab <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8018ce:	e8 8b ff ff ff       	call   80185e <fsipc>
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <devfile_flush>:
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8018f0:	e8 69 ff ff ff       	call   80185e <fsipc>
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <devfile_stat>:
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8b 40 0c             	mov    0xc(%eax),%eax
  801907:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80190c:	ba 00 00 00 00       	mov    $0x0,%edx
  801911:	b8 05 00 00 00       	mov    $0x5,%eax
  801916:	e8 43 ff ff ff       	call   80185e <fsipc>
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 2c                	js     80194b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	68 00 50 80 00       	push   $0x805000
  801927:	53                   	push   %ebx
  801928:	e8 e0 ee ff ff       	call   80080d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80192d:	a1 80 50 80 00       	mov    0x805080,%eax
  801932:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801938:	a1 84 50 80 00       	mov    0x805084,%eax
  80193d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <devfile_write>:
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80195a:	85 db                	test   %ebx,%ebx
  80195c:	75 07                	jne    801965 <devfile_write+0x15>
	return n_all;
  80195e:	89 d8                	mov    %ebx,%eax
}
  801960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801963:	c9                   	leave  
  801964:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8b 40 0c             	mov    0xc(%eax),%eax
  80196b:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801970:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	53                   	push   %ebx
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	68 08 50 80 00       	push   $0x805008
  801982:	e8 14 f0 ff ff       	call   80099b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	b8 04 00 00 00       	mov    $0x4,%eax
  801991:	e8 c8 fe ff ff       	call   80185e <fsipc>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 c3                	js     801960 <devfile_write+0x10>
	  assert(r <= n_left);
  80199d:	39 d8                	cmp    %ebx,%eax
  80199f:	77 0b                	ja     8019ac <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8019a1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019a6:	7f 1d                	jg     8019c5 <devfile_write+0x75>
    n_all += r;
  8019a8:	89 c3                	mov    %eax,%ebx
  8019aa:	eb b2                	jmp    80195e <devfile_write+0xe>
	  assert(r <= n_left);
  8019ac:	68 20 2d 80 00       	push   $0x802d20
  8019b1:	68 2c 2d 80 00       	push   $0x802d2c
  8019b6:	68 9f 00 00 00       	push   $0x9f
  8019bb:	68 41 2d 80 00       	push   $0x802d41
  8019c0:	e8 91 e7 ff ff       	call   800156 <_panic>
	  assert(r <= PGSIZE);
  8019c5:	68 4c 2d 80 00       	push   $0x802d4c
  8019ca:	68 2c 2d 80 00       	push   $0x802d2c
  8019cf:	68 a0 00 00 00       	push   $0xa0
  8019d4:	68 41 2d 80 00       	push   $0x802d41
  8019d9:	e8 78 e7 ff ff       	call   800156 <_panic>

008019de <devfile_read>:
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	56                   	push   %esi
  8019e2:	53                   	push   %ebx
  8019e3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ec:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019f1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801a01:	e8 58 fe ff ff       	call   80185e <fsipc>
  801a06:	89 c3                	mov    %eax,%ebx
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 1f                	js     801a2b <devfile_read+0x4d>
	assert(r <= n);
  801a0c:	39 f0                	cmp    %esi,%eax
  801a0e:	77 24                	ja     801a34 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a10:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a15:	7f 33                	jg     801a4a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	50                   	push   %eax
  801a1b:	68 00 50 80 00       	push   $0x805000
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	e8 73 ef ff ff       	call   80099b <memmove>
	return r;
  801a28:	83 c4 10             	add    $0x10,%esp
}
  801a2b:	89 d8                	mov    %ebx,%eax
  801a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
	assert(r <= n);
  801a34:	68 58 2d 80 00       	push   $0x802d58
  801a39:	68 2c 2d 80 00       	push   $0x802d2c
  801a3e:	6a 7c                	push   $0x7c
  801a40:	68 41 2d 80 00       	push   $0x802d41
  801a45:	e8 0c e7 ff ff       	call   800156 <_panic>
	assert(r <= PGSIZE);
  801a4a:	68 4c 2d 80 00       	push   $0x802d4c
  801a4f:	68 2c 2d 80 00       	push   $0x802d2c
  801a54:	6a 7d                	push   $0x7d
  801a56:	68 41 2d 80 00       	push   $0x802d41
  801a5b:	e8 f6 e6 ff ff       	call   800156 <_panic>

00801a60 <open>:
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	83 ec 1c             	sub    $0x1c,%esp
  801a68:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a6b:	56                   	push   %esi
  801a6c:	e8 63 ed ff ff       	call   8007d4 <strlen>
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a79:	7f 6c                	jg     801ae7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a81:	50                   	push   %eax
  801a82:	e8 6c f8 ff ff       	call   8012f3 <fd_alloc>
  801a87:	89 c3                	mov    %eax,%ebx
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 3c                	js     801acc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	56                   	push   %esi
  801a94:	68 00 50 80 00       	push   $0x805000
  801a99:	e8 6f ed ff ff       	call   80080d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aae:	e8 ab fd ff ff       	call   80185e <fsipc>
  801ab3:	89 c3                	mov    %eax,%ebx
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	78 19                	js     801ad5 <open+0x75>
	return fd2num(fd);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac2:	e8 05 f8 ff ff       	call   8012cc <fd2num>
  801ac7:	89 c3                	mov    %eax,%ebx
  801ac9:	83 c4 10             	add    $0x10,%esp
}
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    
		fd_close(fd, 0);
  801ad5:	83 ec 08             	sub    $0x8,%esp
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 f4             	pushl  -0xc(%ebp)
  801add:	e8 0e f9 ff ff       	call   8013f0 <fd_close>
		return r;
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	eb e5                	jmp    801acc <open+0x6c>
		return -E_BAD_PATH;
  801ae7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aec:	eb de                	jmp    801acc <open+0x6c>

00801aee <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801af4:	ba 00 00 00 00       	mov    $0x0,%edx
  801af9:	b8 08 00 00 00       	mov    $0x8,%eax
  801afe:	e8 5b fd ff ff       	call   80185e <fsipc>
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	56                   	push   %esi
  801b09:	53                   	push   %ebx
  801b0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	ff 75 08             	pushl  0x8(%ebp)
  801b13:	e8 c4 f7 ff ff       	call   8012dc <fd2data>
  801b18:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	68 5f 2d 80 00       	push   $0x802d5f
  801b22:	53                   	push   %ebx
  801b23:	e8 e5 ec ff ff       	call   80080d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b28:	8b 46 04             	mov    0x4(%esi),%eax
  801b2b:	2b 06                	sub    (%esi),%eax
  801b2d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b33:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3a:	00 00 00 
	stat->st_dev = &devpipe;
  801b3d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b44:	30 80 00 
	return 0;
}
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	53                   	push   %ebx
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b5d:	53                   	push   %ebx
  801b5e:	6a 00                	push   $0x0
  801b60:	e8 1f f1 ff ff       	call   800c84 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b65:	89 1c 24             	mov    %ebx,(%esp)
  801b68:	e8 6f f7 ff ff       	call   8012dc <fd2data>
  801b6d:	83 c4 08             	add    $0x8,%esp
  801b70:	50                   	push   %eax
  801b71:	6a 00                	push   $0x0
  801b73:	e8 0c f1 ff ff       	call   800c84 <sys_page_unmap>
}
  801b78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <_pipeisclosed>:
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	57                   	push   %edi
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	83 ec 1c             	sub    $0x1c,%esp
  801b86:	89 c7                	mov    %eax,%edi
  801b88:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b8a:	a1 08 40 80 00       	mov    0x804008,%eax
  801b8f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	57                   	push   %edi
  801b96:	e8 31 09 00 00       	call   8024cc <pageref>
  801b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b9e:	89 34 24             	mov    %esi,(%esp)
  801ba1:	e8 26 09 00 00       	call   8024cc <pageref>
		nn = thisenv->env_runs;
  801ba6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	39 cb                	cmp    %ecx,%ebx
  801bb4:	74 1b                	je     801bd1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bb6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bb9:	75 cf                	jne    801b8a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbb:	8b 42 58             	mov    0x58(%edx),%eax
  801bbe:	6a 01                	push   $0x1
  801bc0:	50                   	push   %eax
  801bc1:	53                   	push   %ebx
  801bc2:	68 66 2d 80 00       	push   $0x802d66
  801bc7:	e8 65 e6 ff ff       	call   800231 <cprintf>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	eb b9                	jmp    801b8a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bd1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd4:	0f 94 c0             	sete   %al
  801bd7:	0f b6 c0             	movzbl %al,%eax
}
  801bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bdd:	5b                   	pop    %ebx
  801bde:	5e                   	pop    %esi
  801bdf:	5f                   	pop    %edi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    

00801be2 <devpipe_write>:
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	57                   	push   %edi
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 28             	sub    $0x28,%esp
  801beb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bee:	56                   	push   %esi
  801bef:	e8 e8 f6 ff ff       	call   8012dc <fd2data>
  801bf4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bfe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c01:	74 4f                	je     801c52 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c03:	8b 43 04             	mov    0x4(%ebx),%eax
  801c06:	8b 0b                	mov    (%ebx),%ecx
  801c08:	8d 51 20             	lea    0x20(%ecx),%edx
  801c0b:	39 d0                	cmp    %edx,%eax
  801c0d:	72 14                	jb     801c23 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c0f:	89 da                	mov    %ebx,%edx
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	e8 65 ff ff ff       	call   801b7d <_pipeisclosed>
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 3b                	jne    801c57 <devpipe_write+0x75>
			sys_yield();
  801c1c:	e8 bf ef ff ff       	call   800be0 <sys_yield>
  801c21:	eb e0                	jmp    801c03 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c26:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c2a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c2d:	89 c2                	mov    %eax,%edx
  801c2f:	c1 fa 1f             	sar    $0x1f,%edx
  801c32:	89 d1                	mov    %edx,%ecx
  801c34:	c1 e9 1b             	shr    $0x1b,%ecx
  801c37:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c3a:	83 e2 1f             	and    $0x1f,%edx
  801c3d:	29 ca                	sub    %ecx,%edx
  801c3f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c43:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c47:	83 c0 01             	add    $0x1,%eax
  801c4a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c4d:	83 c7 01             	add    $0x1,%edi
  801c50:	eb ac                	jmp    801bfe <devpipe_write+0x1c>
	return i;
  801c52:	8b 45 10             	mov    0x10(%ebp),%eax
  801c55:	eb 05                	jmp    801c5c <devpipe_write+0x7a>
				return 0;
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    

00801c64 <devpipe_read>:
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	57                   	push   %edi
  801c68:	56                   	push   %esi
  801c69:	53                   	push   %ebx
  801c6a:	83 ec 18             	sub    $0x18,%esp
  801c6d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c70:	57                   	push   %edi
  801c71:	e8 66 f6 ff ff       	call   8012dc <fd2data>
  801c76:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	be 00 00 00 00       	mov    $0x0,%esi
  801c80:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c83:	75 14                	jne    801c99 <devpipe_read+0x35>
	return i;
  801c85:	8b 45 10             	mov    0x10(%ebp),%eax
  801c88:	eb 02                	jmp    801c8c <devpipe_read+0x28>
				return i;
  801c8a:	89 f0                	mov    %esi,%eax
}
  801c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
			sys_yield();
  801c94:	e8 47 ef ff ff       	call   800be0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c99:	8b 03                	mov    (%ebx),%eax
  801c9b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c9e:	75 18                	jne    801cb8 <devpipe_read+0x54>
			if (i > 0)
  801ca0:	85 f6                	test   %esi,%esi
  801ca2:	75 e6                	jne    801c8a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ca4:	89 da                	mov    %ebx,%edx
  801ca6:	89 f8                	mov    %edi,%eax
  801ca8:	e8 d0 fe ff ff       	call   801b7d <_pipeisclosed>
  801cad:	85 c0                	test   %eax,%eax
  801caf:	74 e3                	je     801c94 <devpipe_read+0x30>
				return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb6:	eb d4                	jmp    801c8c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb8:	99                   	cltd   
  801cb9:	c1 ea 1b             	shr    $0x1b,%edx
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	83 e0 1f             	and    $0x1f,%eax
  801cc1:	29 d0                	sub    %edx,%eax
  801cc3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ccb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cce:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cd1:	83 c6 01             	add    $0x1,%esi
  801cd4:	eb aa                	jmp    801c80 <devpipe_read+0x1c>

00801cd6 <pipe>:
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce1:	50                   	push   %eax
  801ce2:	e8 0c f6 ff ff       	call   8012f3 <fd_alloc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	0f 88 23 01 00 00    	js     801e17 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	68 07 04 00 00       	push   $0x407
  801cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cff:	6a 00                	push   $0x0
  801d01:	e8 f9 ee ff ff       	call   800bff <sys_page_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	0f 88 04 01 00 00    	js     801e17 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d19:	50                   	push   %eax
  801d1a:	e8 d4 f5 ff ff       	call   8012f3 <fd_alloc>
  801d1f:	89 c3                	mov    %eax,%ebx
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	85 c0                	test   %eax,%eax
  801d26:	0f 88 db 00 00 00    	js     801e07 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	68 07 04 00 00       	push   $0x407
  801d34:	ff 75 f0             	pushl  -0x10(%ebp)
  801d37:	6a 00                	push   $0x0
  801d39:	e8 c1 ee ff ff       	call   800bff <sys_page_alloc>
  801d3e:	89 c3                	mov    %eax,%ebx
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	85 c0                	test   %eax,%eax
  801d45:	0f 88 bc 00 00 00    	js     801e07 <pipe+0x131>
	va = fd2data(fd0);
  801d4b:	83 ec 0c             	sub    $0xc,%esp
  801d4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d51:	e8 86 f5 ff ff       	call   8012dc <fd2data>
  801d56:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d58:	83 c4 0c             	add    $0xc,%esp
  801d5b:	68 07 04 00 00       	push   $0x407
  801d60:	50                   	push   %eax
  801d61:	6a 00                	push   $0x0
  801d63:	e8 97 ee ff ff       	call   800bff <sys_page_alloc>
  801d68:	89 c3                	mov    %eax,%ebx
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	0f 88 82 00 00 00    	js     801df7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7b:	e8 5c f5 ff ff       	call   8012dc <fd2data>
  801d80:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d87:	50                   	push   %eax
  801d88:	6a 00                	push   $0x0
  801d8a:	56                   	push   %esi
  801d8b:	6a 00                	push   $0x0
  801d8d:	e8 b0 ee ff ff       	call   800c42 <sys_page_map>
  801d92:	89 c3                	mov    %eax,%ebx
  801d94:	83 c4 20             	add    $0x20,%esp
  801d97:	85 c0                	test   %eax,%eax
  801d99:	78 4e                	js     801de9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d9b:	a1 20 30 80 00       	mov    0x803020,%eax
  801da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801daf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801db2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dbe:	83 ec 0c             	sub    $0xc,%esp
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	e8 03 f5 ff ff       	call   8012cc <fd2num>
  801dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dce:	83 c4 04             	add    $0x4,%esp
  801dd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd4:	e8 f3 f4 ff ff       	call   8012cc <fd2num>
  801dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de7:	eb 2e                	jmp    801e17 <pipe+0x141>
	sys_page_unmap(0, va);
  801de9:	83 ec 08             	sub    $0x8,%esp
  801dec:	56                   	push   %esi
  801ded:	6a 00                	push   $0x0
  801def:	e8 90 ee ff ff       	call   800c84 <sys_page_unmap>
  801df4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfd:	6a 00                	push   $0x0
  801dff:	e8 80 ee ff ff       	call   800c84 <sys_page_unmap>
  801e04:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0d:	6a 00                	push   $0x0
  801e0f:	e8 70 ee ff ff       	call   800c84 <sys_page_unmap>
  801e14:	83 c4 10             	add    $0x10,%esp
}
  801e17:	89 d8                	mov    %ebx,%eax
  801e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    

00801e20 <pipeisclosed>:
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e29:	50                   	push   %eax
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	e8 13 f5 ff ff       	call   801345 <fd_lookup>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 18                	js     801e51 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3f:	e8 98 f4 ff ff       	call   8012dc <fd2data>
	return _pipeisclosed(fd, p);
  801e44:	89 c2                	mov    %eax,%edx
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	e8 2f fd ff ff       	call   801b7d <_pipeisclosed>
  801e4e:	83 c4 10             	add    $0x10,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e59:	68 7e 2d 80 00       	push   $0x802d7e
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	e8 a7 e9 ff ff       	call   80080d <strcpy>
	return 0;
}
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <devsock_close>:
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	53                   	push   %ebx
  801e71:	83 ec 10             	sub    $0x10,%esp
  801e74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e77:	53                   	push   %ebx
  801e78:	e8 4f 06 00 00       	call   8024cc <pageref>
  801e7d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e80:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e85:	83 f8 01             	cmp    $0x1,%eax
  801e88:	74 07                	je     801e91 <devsock_close+0x24>
}
  801e8a:	89 d0                	mov    %edx,%eax
  801e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 73 0c             	pushl  0xc(%ebx)
  801e97:	e8 b9 02 00 00       	call   802155 <nsipc_close>
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	eb e7                	jmp    801e8a <devsock_close+0x1d>

00801ea3 <devsock_write>:
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 10             	pushl  0x10(%ebp)
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	ff 70 0c             	pushl  0xc(%eax)
  801eb7:	e8 76 03 00 00       	call   802232 <nsipc_send>
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <devsock_read>:
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	ff 75 10             	pushl  0x10(%ebp)
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	ff 70 0c             	pushl  0xc(%eax)
  801ed2:	e8 ef 02 00 00       	call   8021c6 <nsipc_recv>
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <fd2sockid>:
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801edf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ee2:	52                   	push   %edx
  801ee3:	50                   	push   %eax
  801ee4:	e8 5c f4 ff ff       	call   801345 <fd_lookup>
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 10                	js     801f00 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ef9:	39 08                	cmp    %ecx,(%eax)
  801efb:	75 05                	jne    801f02 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801efd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    
		return -E_NOT_SUPP;
  801f02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f07:	eb f7                	jmp    801f00 <fd2sockid+0x27>

00801f09 <alloc_sockfd>:
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 1c             	sub    $0x1c,%esp
  801f11:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f16:	50                   	push   %eax
  801f17:	e8 d7 f3 ff ff       	call   8012f3 <fd_alloc>
  801f1c:	89 c3                	mov    %eax,%ebx
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 43                	js     801f68 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 07 04 00 00       	push   $0x407
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	6a 00                	push   $0x0
  801f32:	e8 c8 ec ff ff       	call   800bff <sys_page_alloc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 28                	js     801f68 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f49:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f55:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	50                   	push   %eax
  801f5c:	e8 6b f3 ff ff       	call   8012cc <fd2num>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	eb 0c                	jmp    801f74 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	56                   	push   %esi
  801f6c:	e8 e4 01 00 00       	call   802155 <nsipc_close>
		return r;
  801f71:	83 c4 10             	add    $0x10,%esp
}
  801f74:	89 d8                	mov    %ebx,%eax
  801f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f79:	5b                   	pop    %ebx
  801f7a:	5e                   	pop    %esi
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    

00801f7d <accept>:
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	e8 4e ff ff ff       	call   801ed9 <fd2sockid>
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	78 1b                	js     801faa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f8f:	83 ec 04             	sub    $0x4,%esp
  801f92:	ff 75 10             	pushl  0x10(%ebp)
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	50                   	push   %eax
  801f99:	e8 0e 01 00 00       	call   8020ac <nsipc_accept>
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 05                	js     801faa <accept+0x2d>
	return alloc_sockfd(r);
  801fa5:	e8 5f ff ff ff       	call   801f09 <alloc_sockfd>
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <bind>:
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	e8 1f ff ff ff       	call   801ed9 <fd2sockid>
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 12                	js     801fd0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	ff 75 10             	pushl  0x10(%ebp)
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	50                   	push   %eax
  801fc8:	e8 31 01 00 00       	call   8020fe <nsipc_bind>
  801fcd:	83 c4 10             	add    $0x10,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <shutdown>:
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	e8 f9 fe ff ff       	call   801ed9 <fd2sockid>
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 0f                	js     801ff3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fe4:	83 ec 08             	sub    $0x8,%esp
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	50                   	push   %eax
  801feb:	e8 43 01 00 00       	call   802133 <nsipc_shutdown>
  801ff0:	83 c4 10             	add    $0x10,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <connect>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	e8 d6 fe ff ff       	call   801ed9 <fd2sockid>
  802003:	85 c0                	test   %eax,%eax
  802005:	78 12                	js     802019 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	50                   	push   %eax
  802011:	e8 59 01 00 00       	call   80216f <nsipc_connect>
  802016:	83 c4 10             	add    $0x10,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <listen>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	e8 b0 fe ff ff       	call   801ed9 <fd2sockid>
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 0f                	js     80203c <listen+0x21>
	return nsipc_listen(r, backlog);
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	e8 6b 01 00 00       	call   8021a4 <nsipc_listen>
  802039:	83 c4 10             	add    $0x10,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <socket>:

int
socket(int domain, int type, int protocol)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802044:	ff 75 10             	pushl  0x10(%ebp)
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	ff 75 08             	pushl  0x8(%ebp)
  80204d:	e8 3e 02 00 00       	call   802290 <nsipc_socket>
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 05                	js     80205e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802059:	e8 ab fe ff ff       	call   801f09 <alloc_sockfd>
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	53                   	push   %ebx
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802069:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802070:	74 26                	je     802098 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802072:	6a 07                	push   $0x7
  802074:	68 00 60 80 00       	push   $0x806000
  802079:	53                   	push   %ebx
  80207a:	ff 35 04 40 80 00    	pushl  0x804004
  802080:	e8 a2 f1 ff ff       	call   801227 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802085:	83 c4 0c             	add    $0xc,%esp
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	e8 21 f1 ff ff       	call   8011b4 <ipc_recv>
}
  802093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802096:	c9                   	leave  
  802097:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	6a 02                	push   $0x2
  80209d:	e8 f1 f1 ff ff       	call   801293 <ipc_find_env>
  8020a2:	a3 04 40 80 00       	mov    %eax,0x804004
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	eb c6                	jmp    802072 <nsipc+0x12>

008020ac <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	56                   	push   %esi
  8020b0:	53                   	push   %ebx
  8020b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020bc:	8b 06                	mov    (%esi),%eax
  8020be:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c8:	e8 93 ff ff ff       	call   802060 <nsipc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	79 09                	jns    8020dc <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020d3:	89 d8                	mov    %ebx,%eax
  8020d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	ff 35 10 60 80 00    	pushl  0x806010
  8020e5:	68 00 60 80 00       	push   $0x806000
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	e8 a9 e8 ff ff       	call   80099b <memmove>
		*addrlen = ret->ret_addrlen;
  8020f2:	a1 10 60 80 00       	mov    0x806010,%eax
  8020f7:	89 06                	mov    %eax,(%esi)
  8020f9:	83 c4 10             	add    $0x10,%esp
	return r;
  8020fc:	eb d5                	jmp    8020d3 <nsipc_accept+0x27>

008020fe <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	53                   	push   %ebx
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802110:	53                   	push   %ebx
  802111:	ff 75 0c             	pushl  0xc(%ebp)
  802114:	68 04 60 80 00       	push   $0x806004
  802119:	e8 7d e8 ff ff       	call   80099b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80211e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802124:	b8 02 00 00 00       	mov    $0x2,%eax
  802129:	e8 32 ff ff ff       	call   802060 <nsipc>
}
  80212e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802141:	8b 45 0c             	mov    0xc(%ebp),%eax
  802144:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802149:	b8 03 00 00 00       	mov    $0x3,%eax
  80214e:	e8 0d ff ff ff       	call   802060 <nsipc>
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <nsipc_close>:

int
nsipc_close(int s)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802163:	b8 04 00 00 00       	mov    $0x4,%eax
  802168:	e8 f3 fe ff ff       	call   802060 <nsipc>
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	53                   	push   %ebx
  802173:	83 ec 08             	sub    $0x8,%esp
  802176:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802181:	53                   	push   %ebx
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	68 04 60 80 00       	push   $0x806004
  80218a:	e8 0c e8 ff ff       	call   80099b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80218f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802195:	b8 05 00 00 00       	mov    $0x5,%eax
  80219a:	e8 c1 fe ff ff       	call   802060 <nsipc>
}
  80219f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021ba:	b8 06 00 00 00       	mov    $0x6,%eax
  8021bf:	e8 9c fe ff ff       	call   802060 <nsipc>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	56                   	push   %esi
  8021ca:	53                   	push   %ebx
  8021cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8021d6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8021dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8021df:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021e4:	b8 07 00 00 00       	mov    $0x7,%eax
  8021e9:	e8 72 fe ff ff       	call   802060 <nsipc>
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	78 1f                	js     802213 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021f4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021f9:	7f 21                	jg     80221c <nsipc_recv+0x56>
  8021fb:	39 c6                	cmp    %eax,%esi
  8021fd:	7c 1d                	jl     80221c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	50                   	push   %eax
  802203:	68 00 60 80 00       	push   $0x806000
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	e8 8b e7 ff ff       	call   80099b <memmove>
  802210:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802213:	89 d8                	mov    %ebx,%eax
  802215:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802218:	5b                   	pop    %ebx
  802219:	5e                   	pop    %esi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80221c:	68 8a 2d 80 00       	push   $0x802d8a
  802221:	68 2c 2d 80 00       	push   $0x802d2c
  802226:	6a 62                	push   $0x62
  802228:	68 9f 2d 80 00       	push   $0x802d9f
  80222d:	e8 24 df ff ff       	call   800156 <_panic>

00802232 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	53                   	push   %ebx
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802244:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80224a:	7f 2e                	jg     80227a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	53                   	push   %ebx
  802250:	ff 75 0c             	pushl  0xc(%ebp)
  802253:	68 0c 60 80 00       	push   $0x80600c
  802258:	e8 3e e7 ff ff       	call   80099b <memmove>
	nsipcbuf.send.req_size = size;
  80225d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802263:	8b 45 14             	mov    0x14(%ebp),%eax
  802266:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80226b:	b8 08 00 00 00       	mov    $0x8,%eax
  802270:	e8 eb fd ff ff       	call   802060 <nsipc>
}
  802275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802278:	c9                   	leave  
  802279:	c3                   	ret    
	assert(size < 1600);
  80227a:	68 ab 2d 80 00       	push   $0x802dab
  80227f:	68 2c 2d 80 00       	push   $0x802d2c
  802284:	6a 6d                	push   $0x6d
  802286:	68 9f 2d 80 00       	push   $0x802d9f
  80228b:	e8 c6 de ff ff       	call   800156 <_panic>

00802290 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8022b3:	e8 a8 fd ff ff       	call   802060 <nsipc>
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bf:	c3                   	ret    

008022c0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022c6:	68 b7 2d 80 00       	push   $0x802db7
  8022cb:	ff 75 0c             	pushl  0xc(%ebp)
  8022ce:	e8 3a e5 ff ff       	call   80080d <strcpy>
	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <devcons_write>:
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022e6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f4:	73 31                	jae    802327 <devcons_write+0x4d>
		m = n - tot;
  8022f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022f9:	29 f3                	sub    %esi,%ebx
  8022fb:	83 fb 7f             	cmp    $0x7f,%ebx
  8022fe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802303:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	53                   	push   %ebx
  80230a:	89 f0                	mov    %esi,%eax
  80230c:	03 45 0c             	add    0xc(%ebp),%eax
  80230f:	50                   	push   %eax
  802310:	57                   	push   %edi
  802311:	e8 85 e6 ff ff       	call   80099b <memmove>
		sys_cputs(buf, m);
  802316:	83 c4 08             	add    $0x8,%esp
  802319:	53                   	push   %ebx
  80231a:	57                   	push   %edi
  80231b:	e8 23 e8 ff ff       	call   800b43 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802320:	01 de                	add    %ebx,%esi
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	eb ca                	jmp    8022f1 <devcons_write+0x17>
}
  802327:	89 f0                	mov    %esi,%eax
  802329:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    

00802331 <devcons_read>:
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 08             	sub    $0x8,%esp
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80233c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802340:	74 21                	je     802363 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802342:	e8 1a e8 ff ff       	call   800b61 <sys_cgetc>
  802347:	85 c0                	test   %eax,%eax
  802349:	75 07                	jne    802352 <devcons_read+0x21>
		sys_yield();
  80234b:	e8 90 e8 ff ff       	call   800be0 <sys_yield>
  802350:	eb f0                	jmp    802342 <devcons_read+0x11>
	if (c < 0)
  802352:	78 0f                	js     802363 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802354:	83 f8 04             	cmp    $0x4,%eax
  802357:	74 0c                	je     802365 <devcons_read+0x34>
	*(char*)vbuf = c;
  802359:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235c:	88 02                	mov    %al,(%edx)
	return 1;
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    
		return 0;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	eb f7                	jmp    802363 <devcons_read+0x32>

0080236c <cputchar>:
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802378:	6a 01                	push   $0x1
  80237a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80237d:	50                   	push   %eax
  80237e:	e8 c0 e7 ff ff       	call   800b43 <sys_cputs>
}
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <getchar>:
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80238e:	6a 01                	push   $0x1
  802390:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802393:	50                   	push   %eax
  802394:	6a 00                	push   $0x0
  802396:	e8 1a f2 ff ff       	call   8015b5 <read>
	if (r < 0)
  80239b:	83 c4 10             	add    $0x10,%esp
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 06                	js     8023a8 <getchar+0x20>
	if (r < 1)
  8023a2:	74 06                	je     8023aa <getchar+0x22>
	return c;
  8023a4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    
		return -E_EOF;
  8023aa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023af:	eb f7                	jmp    8023a8 <getchar+0x20>

008023b1 <iscons>:
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ba:	50                   	push   %eax
  8023bb:	ff 75 08             	pushl  0x8(%ebp)
  8023be:	e8 82 ef ff ff       	call   801345 <fd_lookup>
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	78 11                	js     8023db <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023d3:	39 10                	cmp    %edx,(%eax)
  8023d5:	0f 94 c0             	sete   %al
  8023d8:	0f b6 c0             	movzbl %al,%eax
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <opencons>:
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e6:	50                   	push   %eax
  8023e7:	e8 07 ef ff ff       	call   8012f3 <fd_alloc>
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 3a                	js     80242d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	68 07 04 00 00       	push   $0x407
  8023fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8023fe:	6a 00                	push   $0x0
  802400:	e8 fa e7 ff ff       	call   800bff <sys_page_alloc>
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 21                	js     80242d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802415:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	50                   	push   %eax
  802425:	e8 a2 ee ff ff       	call   8012cc <fd2num>
  80242a:	83 c4 10             	add    $0x10,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802435:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80243c:	74 0a                	je     802448 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802448:	a1 08 40 80 00       	mov    0x804008,%eax
  80244d:	8b 40 48             	mov    0x48(%eax),%eax
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	6a 07                	push   $0x7
  802455:	68 00 f0 bf ee       	push   $0xeebff000
  80245a:	50                   	push   %eax
  80245b:	e8 9f e7 ff ff       	call   800bff <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	85 c0                	test   %eax,%eax
  802465:	78 2c                	js     802493 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802467:	e8 55 e7 ff ff       	call   800bc1 <sys_getenvid>
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	68 a5 24 80 00       	push   $0x8024a5
  802474:	50                   	push   %eax
  802475:	e8 d0 e8 ff ff       	call   800d4a <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	85 c0                	test   %eax,%eax
  80247f:	79 bd                	jns    80243e <set_pgfault_handler+0xf>
  802481:	50                   	push   %eax
  802482:	68 c3 2d 80 00       	push   $0x802dc3
  802487:	6a 23                	push   $0x23
  802489:	68 db 2d 80 00       	push   $0x802ddb
  80248e:	e8 c3 dc ff ff       	call   800156 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802493:	50                   	push   %eax
  802494:	68 c3 2d 80 00       	push   $0x802dc3
  802499:	6a 21                	push   $0x21
  80249b:	68 db 2d 80 00       	push   $0x802ddb
  8024a0:	e8 b1 dc ff ff       	call   800156 <_panic>

008024a5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024a5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024a6:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024ab:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024ad:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8024b0:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8024b4:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8024b7:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8024bb:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8024bf:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8024c2:	83 c4 08             	add    $0x8,%esp
	popal
  8024c5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024c6:	83 c4 04             	add    $0x4,%esp
	popfl
  8024c9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024ca:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8024cb:	c3                   	ret    

008024cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	c1 e8 16             	shr    $0x16,%eax
  8024d7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024e3:	f6 c1 01             	test   $0x1,%cl
  8024e6:	74 1d                	je     802505 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024e8:	c1 ea 0c             	shr    $0xc,%edx
  8024eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024f2:	f6 c2 01             	test   $0x1,%dl
  8024f5:	74 0e                	je     802505 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024f7:	c1 ea 0c             	shr    $0xc,%edx
  8024fa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802501:	ef 
  802502:	0f b7 c0             	movzwl %ax,%eax
}
  802505:	5d                   	pop    %ebp
  802506:	c3                   	ret    
  802507:	66 90                	xchg   %ax,%ax
  802509:	66 90                	xchg   %ax,%ax
  80250b:	66 90                	xchg   %ax,%ax
  80250d:	66 90                	xchg   %ax,%ax
  80250f:	90                   	nop

00802510 <__udivdi3>:
  802510:	f3 0f 1e fb          	endbr32 
  802514:	55                   	push   %ebp
  802515:	57                   	push   %edi
  802516:	56                   	push   %esi
  802517:	53                   	push   %ebx
  802518:	83 ec 1c             	sub    $0x1c,%esp
  80251b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80251f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802523:	8b 74 24 34          	mov    0x34(%esp),%esi
  802527:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80252b:	85 d2                	test   %edx,%edx
  80252d:	75 49                	jne    802578 <__udivdi3+0x68>
  80252f:	39 f3                	cmp    %esi,%ebx
  802531:	76 15                	jbe    802548 <__udivdi3+0x38>
  802533:	31 ff                	xor    %edi,%edi
  802535:	89 e8                	mov    %ebp,%eax
  802537:	89 f2                	mov    %esi,%edx
  802539:	f7 f3                	div    %ebx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	83 c4 1c             	add    $0x1c,%esp
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5f                   	pop    %edi
  802543:	5d                   	pop    %ebp
  802544:	c3                   	ret    
  802545:	8d 76 00             	lea    0x0(%esi),%esi
  802548:	89 d9                	mov    %ebx,%ecx
  80254a:	85 db                	test   %ebx,%ebx
  80254c:	75 0b                	jne    802559 <__udivdi3+0x49>
  80254e:	b8 01 00 00 00       	mov    $0x1,%eax
  802553:	31 d2                	xor    %edx,%edx
  802555:	f7 f3                	div    %ebx
  802557:	89 c1                	mov    %eax,%ecx
  802559:	31 d2                	xor    %edx,%edx
  80255b:	89 f0                	mov    %esi,%eax
  80255d:	f7 f1                	div    %ecx
  80255f:	89 c6                	mov    %eax,%esi
  802561:	89 e8                	mov    %ebp,%eax
  802563:	89 f7                	mov    %esi,%edi
  802565:	f7 f1                	div    %ecx
  802567:	89 fa                	mov    %edi,%edx
  802569:	83 c4 1c             	add    $0x1c,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802578:	39 f2                	cmp    %esi,%edx
  80257a:	77 1c                	ja     802598 <__udivdi3+0x88>
  80257c:	0f bd fa             	bsr    %edx,%edi
  80257f:	83 f7 1f             	xor    $0x1f,%edi
  802582:	75 2c                	jne    8025b0 <__udivdi3+0xa0>
  802584:	39 f2                	cmp    %esi,%edx
  802586:	72 06                	jb     80258e <__udivdi3+0x7e>
  802588:	31 c0                	xor    %eax,%eax
  80258a:	39 eb                	cmp    %ebp,%ebx
  80258c:	77 ad                	ja     80253b <__udivdi3+0x2b>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	eb a6                	jmp    80253b <__udivdi3+0x2b>
  802595:	8d 76 00             	lea    0x0(%esi),%esi
  802598:	31 ff                	xor    %edi,%edi
  80259a:	31 c0                	xor    %eax,%eax
  80259c:	89 fa                	mov    %edi,%edx
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 f9                	mov    %edi,%ecx
  8025b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b7:	29 f8                	sub    %edi,%eax
  8025b9:	d3 e2                	shl    %cl,%edx
  8025bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	89 da                	mov    %ebx,%edx
  8025c3:	d3 ea                	shr    %cl,%edx
  8025c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c9:	09 d1                	or     %edx,%ecx
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 f9                	mov    %edi,%ecx
  8025d3:	d3 e3                	shl    %cl,%ebx
  8025d5:	89 c1                	mov    %eax,%ecx
  8025d7:	d3 ea                	shr    %cl,%edx
  8025d9:	89 f9                	mov    %edi,%ecx
  8025db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025df:	89 eb                	mov    %ebp,%ebx
  8025e1:	d3 e6                	shl    %cl,%esi
  8025e3:	89 c1                	mov    %eax,%ecx
  8025e5:	d3 eb                	shr    %cl,%ebx
  8025e7:	09 de                	or     %ebx,%esi
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	f7 74 24 08          	divl   0x8(%esp)
  8025ef:	89 d6                	mov    %edx,%esi
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	f7 64 24 0c          	mull   0xc(%esp)
  8025f7:	39 d6                	cmp    %edx,%esi
  8025f9:	72 15                	jb     802610 <__udivdi3+0x100>
  8025fb:	89 f9                	mov    %edi,%ecx
  8025fd:	d3 e5                	shl    %cl,%ebp
  8025ff:	39 c5                	cmp    %eax,%ebp
  802601:	73 04                	jae    802607 <__udivdi3+0xf7>
  802603:	39 d6                	cmp    %edx,%esi
  802605:	74 09                	je     802610 <__udivdi3+0x100>
  802607:	89 d8                	mov    %ebx,%eax
  802609:	31 ff                	xor    %edi,%edi
  80260b:	e9 2b ff ff ff       	jmp    80253b <__udivdi3+0x2b>
  802610:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802613:	31 ff                	xor    %edi,%edi
  802615:	e9 21 ff ff ff       	jmp    80253b <__udivdi3+0x2b>
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__umoddi3>:
  802620:	f3 0f 1e fb          	endbr32 
  802624:	55                   	push   %ebp
  802625:	57                   	push   %edi
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	83 ec 1c             	sub    $0x1c,%esp
  80262b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80262f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802633:	8b 74 24 30          	mov    0x30(%esp),%esi
  802637:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80263b:	89 da                	mov    %ebx,%edx
  80263d:	85 c0                	test   %eax,%eax
  80263f:	75 3f                	jne    802680 <__umoddi3+0x60>
  802641:	39 df                	cmp    %ebx,%edi
  802643:	76 13                	jbe    802658 <__umoddi3+0x38>
  802645:	89 f0                	mov    %esi,%eax
  802647:	f7 f7                	div    %edi
  802649:	89 d0                	mov    %edx,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	83 c4 1c             	add    $0x1c,%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	89 fd                	mov    %edi,%ebp
  80265a:	85 ff                	test   %edi,%edi
  80265c:	75 0b                	jne    802669 <__umoddi3+0x49>
  80265e:	b8 01 00 00 00       	mov    $0x1,%eax
  802663:	31 d2                	xor    %edx,%edx
  802665:	f7 f7                	div    %edi
  802667:	89 c5                	mov    %eax,%ebp
  802669:	89 d8                	mov    %ebx,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	f7 f5                	div    %ebp
  80266f:	89 f0                	mov    %esi,%eax
  802671:	f7 f5                	div    %ebp
  802673:	89 d0                	mov    %edx,%eax
  802675:	eb d4                	jmp    80264b <__umoddi3+0x2b>
  802677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80267e:	66 90                	xchg   %ax,%ax
  802680:	89 f1                	mov    %esi,%ecx
  802682:	39 d8                	cmp    %ebx,%eax
  802684:	76 0a                	jbe    802690 <__umoddi3+0x70>
  802686:	89 f0                	mov    %esi,%eax
  802688:	83 c4 1c             	add    $0x1c,%esp
  80268b:	5b                   	pop    %ebx
  80268c:	5e                   	pop    %esi
  80268d:	5f                   	pop    %edi
  80268e:	5d                   	pop    %ebp
  80268f:	c3                   	ret    
  802690:	0f bd e8             	bsr    %eax,%ebp
  802693:	83 f5 1f             	xor    $0x1f,%ebp
  802696:	75 20                	jne    8026b8 <__umoddi3+0x98>
  802698:	39 d8                	cmp    %ebx,%eax
  80269a:	0f 82 b0 00 00 00    	jb     802750 <__umoddi3+0x130>
  8026a0:	39 f7                	cmp    %esi,%edi
  8026a2:	0f 86 a8 00 00 00    	jbe    802750 <__umoddi3+0x130>
  8026a8:	89 c8                	mov    %ecx,%eax
  8026aa:	83 c4 1c             	add    $0x1c,%esp
  8026ad:	5b                   	pop    %ebx
  8026ae:	5e                   	pop    %esi
  8026af:	5f                   	pop    %edi
  8026b0:	5d                   	pop    %ebp
  8026b1:	c3                   	ret    
  8026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8026bf:	29 ea                	sub    %ebp,%edx
  8026c1:	d3 e0                	shl    %cl,%eax
  8026c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c7:	89 d1                	mov    %edx,%ecx
  8026c9:	89 f8                	mov    %edi,%eax
  8026cb:	d3 e8                	shr    %cl,%eax
  8026cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026d9:	09 c1                	or     %eax,%ecx
  8026db:	89 d8                	mov    %ebx,%eax
  8026dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e1:	89 e9                	mov    %ebp,%ecx
  8026e3:	d3 e7                	shl    %cl,%edi
  8026e5:	89 d1                	mov    %edx,%ecx
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	d3 e3                	shl    %cl,%ebx
  8026f1:	89 c7                	mov    %eax,%edi
  8026f3:	89 d1                	mov    %edx,%ecx
  8026f5:	89 f0                	mov    %esi,%eax
  8026f7:	d3 e8                	shr    %cl,%eax
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	89 fa                	mov    %edi,%edx
  8026fd:	d3 e6                	shl    %cl,%esi
  8026ff:	09 d8                	or     %ebx,%eax
  802701:	f7 74 24 08          	divl   0x8(%esp)
  802705:	89 d1                	mov    %edx,%ecx
  802707:	89 f3                	mov    %esi,%ebx
  802709:	f7 64 24 0c          	mull   0xc(%esp)
  80270d:	89 c6                	mov    %eax,%esi
  80270f:	89 d7                	mov    %edx,%edi
  802711:	39 d1                	cmp    %edx,%ecx
  802713:	72 06                	jb     80271b <__umoddi3+0xfb>
  802715:	75 10                	jne    802727 <__umoddi3+0x107>
  802717:	39 c3                	cmp    %eax,%ebx
  802719:	73 0c                	jae    802727 <__umoddi3+0x107>
  80271b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80271f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802723:	89 d7                	mov    %edx,%edi
  802725:	89 c6                	mov    %eax,%esi
  802727:	89 ca                	mov    %ecx,%edx
  802729:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80272e:	29 f3                	sub    %esi,%ebx
  802730:	19 fa                	sbb    %edi,%edx
  802732:	89 d0                	mov    %edx,%eax
  802734:	d3 e0                	shl    %cl,%eax
  802736:	89 e9                	mov    %ebp,%ecx
  802738:	d3 eb                	shr    %cl,%ebx
  80273a:	d3 ea                	shr    %cl,%edx
  80273c:	09 d8                	or     %ebx,%eax
  80273e:	83 c4 1c             	add    $0x1c,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    
  802746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80274d:	8d 76 00             	lea    0x0(%esi),%esi
  802750:	89 da                	mov    %ebx,%edx
  802752:	29 fe                	sub    %edi,%esi
  802754:	19 c2                	sbb    %eax,%edx
  802756:	89 f1                	mov    %esi,%ecx
  802758:	89 c8                	mov    %ecx,%eax
  80275a:	e9 4b ff ff ff       	jmp    8026aa <__umoddi3+0x8a>
