
obj/user/testfdsharing.debug：     文件格式 elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 80 28 80 00       	push   $0x802880
  800043:	e8 d4 19 00 00       	call   801a1c <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 5f 16 00 00       	call   8016bf <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 85 15 00 00       	call   8015f8 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 d5 0f 00 00       	call   80105a <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 23 16 00 00       	call   8016bf <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 f0 28 80 00 	movl   $0x8028f0,(%esp)
  8000a3:	e8 5d 02 00 00       	call   800305 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 3d 15 00 00       	call   8015f8 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 50 80 00       	push   $0x805020
  8000cf:	68 20 52 80 00       	push   $0x805220
  8000d4:	e8 0e 0a 00 00       	call   800ae7 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 bb 28 80 00       	push   $0x8028bb
  8000ec:	e8 14 02 00 00       	call   800305 <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 c3 15 00 00       	call   8016bf <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 2f 13 00 00       	call   801433 <close>
		exit();
  800104:	e8 07 01 00 00       	call   800210 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 fa 1c 00 00       	call   801e0f <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 d0 14 00 00       	call   8015f8 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 d4 28 80 00       	push   $0x8028d4
  80013b:	e8 c5 01 00 00       	call   800305 <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 eb 12 00 00       	call   801433 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 85 28 80 00       	push   $0x802885
  80015a:	6a 0c                	push   $0xc
  80015c:	68 93 28 80 00       	push   $0x802893
  800161:	e8 c4 00 00 00       	call   80022a <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 a8 28 80 00       	push   $0x8028a8
  80016c:	6a 0f                	push   $0xf
  80016e:	68 93 28 80 00       	push   $0x802893
  800173:	e8 b2 00 00 00       	call   80022a <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 b2 28 80 00       	push   $0x8028b2
  80017e:	6a 12                	push   $0x12
  800180:	68 93 28 80 00       	push   $0x802893
  800185:	e8 a0 00 00 00       	call   80022a <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 34 29 80 00       	push   $0x802934
  800194:	6a 17                	push   $0x17
  800196:	68 93 28 80 00       	push   $0x802893
  80019b:	e8 8a 00 00 00       	call   80022a <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 60 29 80 00       	push   $0x802960
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 93 28 80 00       	push   $0x802893
  8001af:	e8 76 00 00 00       	call   80022a <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 98 29 80 00       	push   $0x802998
  8001be:	6a 21                	push   $0x21
  8001c0:	68 93 28 80 00       	push   $0x802893
  8001c5:	e8 60 00 00 00       	call   80022a <_panic>

008001ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d5:	e8 bb 0a 00 00       	call   800c95 <sys_getenvid>
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e7:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ec:	85 db                	test   %ebx,%ebx
  8001ee:	7e 07                	jle    8001f7 <libmain+0x2d>
		binaryname = argv[0];
  8001f0:	8b 06                	mov    (%esi),%eax
  8001f2:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	e8 32 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800201:	e8 0a 00 00 00       	call   800210 <exit>
}
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5d                   	pop    %ebp
  80020f:	c3                   	ret    

00800210 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800216:	e8 45 12 00 00       	call   801460 <close_all>
	sys_env_destroy(0);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	6a 00                	push   $0x0
  800220:	e8 2f 0a 00 00       	call   800c54 <sys_env_destroy>
}
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800232:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800238:	e8 58 0a 00 00       	call   800c95 <sys_getenvid>
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	56                   	push   %esi
  800247:	50                   	push   %eax
  800248:	68 c8 29 80 00       	push   $0x8029c8
  80024d:	e8 b3 00 00 00       	call   800305 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800252:	83 c4 18             	add    $0x18,%esp
  800255:	53                   	push   %ebx
  800256:	ff 75 10             	pushl  0x10(%ebp)
  800259:	e8 56 00 00 00       	call   8002b4 <vcprintf>
	cprintf("\n");
  80025e:	c7 04 24 d2 28 80 00 	movl   $0x8028d2,(%esp)
  800265:	e8 9b 00 00 00       	call   800305 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026d:	cc                   	int3   
  80026e:	eb fd                	jmp    80026d <_panic+0x43>

00800270 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	53                   	push   %ebx
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027a:	8b 13                	mov    (%ebx),%edx
  80027c:	8d 42 01             	lea    0x1(%edx),%eax
  80027f:	89 03                	mov    %eax,(%ebx)
  800281:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800284:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800288:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028d:	74 09                	je     800298 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80028f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800296:	c9                   	leave  
  800297:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	68 ff 00 00 00       	push   $0xff
  8002a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a3:	50                   	push   %eax
  8002a4:	e8 6e 09 00 00       	call   800c17 <sys_cputs>
		b->idx = 0;
  8002a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	eb db                	jmp    80028f <putch+0x1f>

008002b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c4:	00 00 00 
	b.cnt = 0;
  8002c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d1:	ff 75 0c             	pushl  0xc(%ebp)
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	68 70 02 80 00       	push   $0x800270
  8002e3:	e8 19 01 00 00       	call   800401 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e8:	83 c4 08             	add    $0x8,%esp
  8002eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f7:	50                   	push   %eax
  8002f8:	e8 1a 09 00 00       	call   800c17 <sys_cputs>

	return b.cnt;
}
  8002fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030e:	50                   	push   %eax
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	e8 9d ff ff ff       	call   8002b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	57                   	push   %edi
  80031d:	56                   	push   %esi
  80031e:	53                   	push   %ebx
  80031f:	83 ec 1c             	sub    $0x1c,%esp
  800322:	89 c7                	mov    %eax,%edi
  800324:	89 d6                	mov    %edx,%esi
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800340:	3b 45 10             	cmp    0x10(%ebp),%eax
  800343:	89 d0                	mov    %edx,%eax
  800345:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800348:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80034b:	73 15                	jae    800362 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034d:	83 eb 01             	sub    $0x1,%ebx
  800350:	85 db                	test   %ebx,%ebx
  800352:	7e 43                	jle    800397 <printnum+0x7e>
			putch(padc, putdat);
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	56                   	push   %esi
  800358:	ff 75 18             	pushl  0x18(%ebp)
  80035b:	ff d7                	call   *%edi
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	eb eb                	jmp    80034d <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 18             	pushl  0x18(%ebp)
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80036e:	53                   	push   %ebx
  80036f:	ff 75 10             	pushl  0x10(%ebp)
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	ff 75 e4             	pushl  -0x1c(%ebp)
  800378:	ff 75 e0             	pushl  -0x20(%ebp)
  80037b:	ff 75 dc             	pushl  -0x24(%ebp)
  80037e:	ff 75 d8             	pushl  -0x28(%ebp)
  800381:	e8 aa 22 00 00       	call   802630 <__udivdi3>
  800386:	83 c4 18             	add    $0x18,%esp
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	89 f2                	mov    %esi,%edx
  80038d:	89 f8                	mov    %edi,%eax
  80038f:	e8 85 ff ff ff       	call   800319 <printnum>
  800394:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	56                   	push   %esi
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8003aa:	e8 91 23 00 00       	call   802740 <__umoddi3>
  8003af:	83 c4 14             	add    $0x14,%esp
  8003b2:	0f be 80 eb 29 80 00 	movsbl 0x8029eb(%eax),%eax
  8003b9:	50                   	push   %eax
  8003ba:	ff d7                	call   *%edi
}
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c2:	5b                   	pop    %ebx
  8003c3:	5e                   	pop    %esi
  8003c4:	5f                   	pop    %edi
  8003c5:	5d                   	pop    %ebp
  8003c6:	c3                   	ret    

008003c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003cd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d1:	8b 10                	mov    (%eax),%edx
  8003d3:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d6:	73 0a                	jae    8003e2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003db:	89 08                	mov    %ecx,(%eax)
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	88 02                	mov    %al,(%edx)
}
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <printfmt>:
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ea:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ed:	50                   	push   %eax
  8003ee:	ff 75 10             	pushl  0x10(%ebp)
  8003f1:	ff 75 0c             	pushl  0xc(%ebp)
  8003f4:	ff 75 08             	pushl  0x8(%ebp)
  8003f7:	e8 05 00 00 00       	call   800401 <vprintfmt>
}
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <vprintfmt>:
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	57                   	push   %edi
  800405:	56                   	push   %esi
  800406:	53                   	push   %ebx
  800407:	83 ec 3c             	sub    $0x3c,%esp
  80040a:	8b 75 08             	mov    0x8(%ebp),%esi
  80040d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800410:	8b 7d 10             	mov    0x10(%ebp),%edi
  800413:	eb 0a                	jmp    80041f <vprintfmt+0x1e>
			putch(ch, putdat);
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	53                   	push   %ebx
  800419:	50                   	push   %eax
  80041a:	ff d6                	call   *%esi
  80041c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80041f:	83 c7 01             	add    $0x1,%edi
  800422:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800426:	83 f8 25             	cmp    $0x25,%eax
  800429:	74 0c                	je     800437 <vprintfmt+0x36>
			if (ch == '\0')
  80042b:	85 c0                	test   %eax,%eax
  80042d:	75 e6                	jne    800415 <vprintfmt+0x14>
}
  80042f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800432:	5b                   	pop    %ebx
  800433:	5e                   	pop    %esi
  800434:	5f                   	pop    %edi
  800435:	5d                   	pop    %ebp
  800436:	c3                   	ret    
		padc = ' ';
  800437:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800442:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800449:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800450:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800455:	8d 47 01             	lea    0x1(%edi),%eax
  800458:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045b:	0f b6 17             	movzbl (%edi),%edx
  80045e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800461:	3c 55                	cmp    $0x55,%al
  800463:	0f 87 ba 03 00 00    	ja     800823 <vprintfmt+0x422>
  800469:	0f b6 c0             	movzbl %al,%eax
  80046c:	ff 24 85 20 2b 80 00 	jmp    *0x802b20(,%eax,4)
  800473:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800476:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047a:	eb d9                	jmp    800455 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80047f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800483:	eb d0                	jmp    800455 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800485:	0f b6 d2             	movzbl %dl,%edx
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800493:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800496:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a0:	83 f9 09             	cmp    $0x9,%ecx
  8004a3:	77 55                	ja     8004fa <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a8:	eb e9                	jmp    800493 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 04             	lea    0x4(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c2:	79 91                	jns    800455 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d1:	eb 82                	jmp    800455 <vprintfmt+0x54>
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	0f 49 d0             	cmovns %eax,%edx
  8004e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e6:	e9 6a ff ff ff       	jmp    800455 <vprintfmt+0x54>
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ee:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004f5:	e9 5b ff ff ff       	jmp    800455 <vprintfmt+0x54>
  8004fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800500:	eb bc                	jmp    8004be <vprintfmt+0xbd>
			lflag++;
  800502:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800508:	e9 48 ff ff ff       	jmp    800455 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 78 04             	lea    0x4(%eax),%edi
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	53                   	push   %ebx
  800517:	ff 30                	pushl  (%eax)
  800519:	ff d6                	call   *%esi
			break;
  80051b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80051e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800521:	e9 9c 02 00 00       	jmp    8007c2 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 78 04             	lea    0x4(%eax),%edi
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	99                   	cltd   
  80052f:	31 d0                	xor    %edx,%eax
  800531:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800533:	83 f8 0f             	cmp    $0xf,%eax
  800536:	7f 23                	jg     80055b <vprintfmt+0x15a>
  800538:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  80053f:	85 d2                	test   %edx,%edx
  800541:	74 18                	je     80055b <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800543:	52                   	push   %edx
  800544:	68 1e 2f 80 00       	push   $0x802f1e
  800549:	53                   	push   %ebx
  80054a:	56                   	push   %esi
  80054b:	e8 94 fe ff ff       	call   8003e4 <printfmt>
  800550:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800553:	89 7d 14             	mov    %edi,0x14(%ebp)
  800556:	e9 67 02 00 00       	jmp    8007c2 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80055b:	50                   	push   %eax
  80055c:	68 03 2a 80 00       	push   $0x802a03
  800561:	53                   	push   %ebx
  800562:	56                   	push   %esi
  800563:	e8 7c fe ff ff       	call   8003e4 <printfmt>
  800568:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056e:	e9 4f 02 00 00       	jmp    8007c2 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800581:	85 d2                	test   %edx,%edx
  800583:	b8 fc 29 80 00       	mov    $0x8029fc,%eax
  800588:	0f 45 c2             	cmovne %edx,%eax
  80058b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80058e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800592:	7e 06                	jle    80059a <vprintfmt+0x199>
  800594:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800598:	75 0d                	jne    8005a7 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a5:	eb 3f                	jmp    8005e6 <vprintfmt+0x1e5>
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 0d 03 00 00       	call   8008c0 <strnlen>
  8005b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b6:	29 c2                	sub    %eax,%edx
  8005b8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7e 58                	jle    800623 <vprintfmt+0x222>
					putch(padc, putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	53                   	push   %ebx
  8005cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	83 ef 01             	sub    $0x1,%edi
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	eb eb                	jmp    8005c7 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	52                   	push   %edx
  8005e1:	ff d6                	call   *%esi
  8005e3:	83 c4 10             	add    $0x10,%esp
  8005e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005eb:	83 c7 01             	add    $0x1,%edi
  8005ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f2:	0f be d0             	movsbl %al,%edx
  8005f5:	85 d2                	test   %edx,%edx
  8005f7:	74 45                	je     80063e <vprintfmt+0x23d>
  8005f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fd:	78 06                	js     800605 <vprintfmt+0x204>
  8005ff:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800603:	78 35                	js     80063a <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800605:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800609:	74 d1                	je     8005dc <vprintfmt+0x1db>
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 e8 20             	sub    $0x20,%eax
  800611:	83 f8 5e             	cmp    $0x5e,%eax
  800614:	76 c6                	jbe    8005dc <vprintfmt+0x1db>
					putch('?', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	6a 3f                	push   $0x3f
  80061c:	ff d6                	call   *%esi
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	eb c3                	jmp    8005e6 <vprintfmt+0x1e5>
  800623:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	b8 00 00 00 00       	mov    $0x0,%eax
  80062d:	0f 49 c2             	cmovns %edx,%eax
  800630:	29 c2                	sub    %eax,%edx
  800632:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800635:	e9 60 ff ff ff       	jmp    80059a <vprintfmt+0x199>
  80063a:	89 cf                	mov    %ecx,%edi
  80063c:	eb 02                	jmp    800640 <vprintfmt+0x23f>
  80063e:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800640:	85 ff                	test   %edi,%edi
  800642:	7e 10                	jle    800654 <vprintfmt+0x253>
				putch(' ', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 20                	push   $0x20
  80064a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064c:	83 ef 01             	sub    $0x1,%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	eb ec                	jmp    800640 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	e9 63 01 00 00       	jmp    8007c2 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80065f:	83 f9 01             	cmp    $0x1,%ecx
  800662:	7f 1b                	jg     80067f <vprintfmt+0x27e>
	else if (lflag)
  800664:	85 c9                	test   %ecx,%ecx
  800666:	74 63                	je     8006cb <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	99                   	cltd   
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 04             	lea    0x4(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
  80067d:	eb 17                	jmp    800696 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 50 04             	mov    0x4(%eax),%edx
  800685:	8b 00                	mov    (%eax),%eax
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 08             	lea    0x8(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800696:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800699:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80069c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a1:	85 c9                	test   %ecx,%ecx
  8006a3:	0f 89 ff 00 00 00    	jns    8007a8 <vprintfmt+0x3a7>
				putch('-', putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	53                   	push   %ebx
  8006ad:	6a 2d                	push   $0x2d
  8006af:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006b7:	f7 da                	neg    %edx
  8006b9:	83 d1 00             	adc    $0x0,%ecx
  8006bc:	f7 d9                	neg    %ecx
  8006be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	e9 dd 00 00 00       	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	99                   	cltd   
  8006d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 40 04             	lea    0x4(%eax),%eax
  8006dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e0:	eb b4                	jmp    800696 <vprintfmt+0x295>
	if (lflag >= 2)
  8006e2:	83 f9 01             	cmp    $0x1,%ecx
  8006e5:	7f 1e                	jg     800705 <vprintfmt+0x304>
	else if (lflag)
  8006e7:	85 c9                	test   %ecx,%ecx
  8006e9:	74 32                	je     80071d <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800700:	e9 a3 00 00 00       	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 10                	mov    (%eax),%edx
  80070a:	8b 48 04             	mov    0x4(%eax),%ecx
  80070d:	8d 40 08             	lea    0x8(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800713:	b8 0a 00 00 00       	mov    $0xa,%eax
  800718:	e9 8b 00 00 00       	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 10                	mov    (%eax),%edx
  800722:	b9 00 00 00 00       	mov    $0x0,%ecx
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800732:	eb 74                	jmp    8007a8 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800734:	83 f9 01             	cmp    $0x1,%ecx
  800737:	7f 1b                	jg     800754 <vprintfmt+0x353>
	else if (lflag)
  800739:	85 c9                	test   %ecx,%ecx
  80073b:	74 2c                	je     800769 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074d:	b8 08 00 00 00       	mov    $0x8,%eax
  800752:	eb 54                	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 10                	mov    (%eax),%edx
  800759:	8b 48 04             	mov    0x4(%eax),%ecx
  80075c:	8d 40 08             	lea    0x8(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800762:	b8 08 00 00 00       	mov    $0x8,%eax
  800767:	eb 3f                	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800779:	b8 08 00 00 00       	mov    $0x8,%eax
  80077e:	eb 28                	jmp    8007a8 <vprintfmt+0x3a7>
			putch('0', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 30                	push   $0x30
  800786:	ff d6                	call   *%esi
			putch('x', putdat);
  800788:	83 c4 08             	add    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 78                	push   $0x78
  80078e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 10                	mov    (%eax),%edx
  800795:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80079a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007af:	57                   	push   %edi
  8007b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	51                   	push   %ecx
  8007b5:	52                   	push   %edx
  8007b6:	89 da                	mov    %ebx,%edx
  8007b8:	89 f0                	mov    %esi,%eax
  8007ba:	e8 5a fb ff ff       	call   800319 <printnum>
			break;
  8007bf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c5:	e9 55 fc ff ff       	jmp    80041f <vprintfmt+0x1e>
	if (lflag >= 2)
  8007ca:	83 f9 01             	cmp    $0x1,%ecx
  8007cd:	7f 1b                	jg     8007ea <vprintfmt+0x3e9>
	else if (lflag)
  8007cf:	85 c9                	test   %ecx,%ecx
  8007d1:	74 2c                	je     8007ff <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 10                	mov    (%eax),%edx
  8007d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e8:	eb be                	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 10                	mov    (%eax),%edx
  8007ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fd:	eb a9                	jmp    8007a8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
  800809:	8d 40 04             	lea    0x4(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080f:	b8 10 00 00 00       	mov    $0x10,%eax
  800814:	eb 92                	jmp    8007a8 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 25                	push   $0x25
  80081c:	ff d6                	call   *%esi
			break;
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	eb 9f                	jmp    8007c2 <vprintfmt+0x3c1>
			putch('%', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 25                	push   $0x25
  800829:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 f8                	mov    %edi,%eax
  800830:	eb 03                	jmp    800835 <vprintfmt+0x434>
  800832:	83 e8 01             	sub    $0x1,%eax
  800835:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800839:	75 f7                	jne    800832 <vprintfmt+0x431>
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	eb 82                	jmp    8007c2 <vprintfmt+0x3c1>

00800840 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800853:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085d:	85 c0                	test   %eax,%eax
  80085f:	74 26                	je     800887 <vsnprintf+0x47>
  800861:	85 d2                	test   %edx,%edx
  800863:	7e 22                	jle    800887 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800865:	ff 75 14             	pushl  0x14(%ebp)
  800868:	ff 75 10             	pushl  0x10(%ebp)
  80086b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	68 c7 03 80 00       	push   $0x8003c7
  800874:	e8 88 fb ff ff       	call   800401 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800882:	83 c4 10             	add    $0x10,%esp
}
  800885:	c9                   	leave  
  800886:	c3                   	ret    
		return -E_INVAL;
  800887:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088c:	eb f7                	jmp    800885 <vsnprintf+0x45>

0080088e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800897:	50                   	push   %eax
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 9a ff ff ff       	call   800840 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    

008008a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	74 05                	je     8008be <strlen+0x16>
		n++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	eb f5                	jmp    8008b3 <strlen+0xb>
	return n;
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ce:	39 c2                	cmp    %eax,%edx
  8008d0:	74 0d                	je     8008df <strnlen+0x1f>
  8008d2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008d6:	74 05                	je     8008dd <strnlen+0x1d>
		n++;
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	eb f1                	jmp    8008ce <strnlen+0xe>
  8008dd:	89 d0                	mov    %edx,%eax
	return n;
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f7:	83 c2 01             	add    $0x1,%edx
  8008fa:	84 c9                	test   %cl,%cl
  8008fc:	75 f2                	jne    8008f0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008fe:	5b                   	pop    %ebx
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	53                   	push   %ebx
  800905:	83 ec 10             	sub    $0x10,%esp
  800908:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090b:	53                   	push   %ebx
  80090c:	e8 97 ff ff ff       	call   8008a8 <strlen>
  800911:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	01 d8                	add    %ebx,%eax
  800919:	50                   	push   %eax
  80091a:	e8 c2 ff ff ff       	call   8008e1 <strcpy>
	return dst;
}
  80091f:	89 d8                	mov    %ebx,%eax
  800921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	56                   	push   %esi
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800931:	89 c6                	mov    %eax,%esi
  800933:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800936:	89 c2                	mov    %eax,%edx
  800938:	39 f2                	cmp    %esi,%edx
  80093a:	74 11                	je     80094d <strncpy+0x27>
		*dst++ = *src;
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	0f b6 19             	movzbl (%ecx),%ebx
  800942:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800945:	80 fb 01             	cmp    $0x1,%bl
  800948:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80094b:	eb eb                	jmp    800938 <strncpy+0x12>
	}
	return ret;
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 75 08             	mov    0x8(%ebp),%esi
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	8b 55 10             	mov    0x10(%ebp),%edx
  80095f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800961:	85 d2                	test   %edx,%edx
  800963:	74 21                	je     800986 <strlcpy+0x35>
  800965:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800969:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	74 14                	je     800983 <strlcpy+0x32>
  80096f:	0f b6 19             	movzbl (%ecx),%ebx
  800972:	84 db                	test   %bl,%bl
  800974:	74 0b                	je     800981 <strlcpy+0x30>
			*dst++ = *src++;
  800976:	83 c1 01             	add    $0x1,%ecx
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80097f:	eb ea                	jmp    80096b <strlcpy+0x1a>
  800981:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800983:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	0f b6 01             	movzbl (%ecx),%eax
  800998:	84 c0                	test   %al,%al
  80099a:	74 0c                	je     8009a8 <strcmp+0x1c>
  80099c:	3a 02                	cmp    (%edx),%al
  80099e:	75 08                	jne    8009a8 <strcmp+0x1c>
		p++, q++;
  8009a0:	83 c1 01             	add    $0x1,%ecx
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	eb ed                	jmp    800995 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 16                	je     8009e3 <strncmp+0x31>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    
		return 0;
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e8:	eb f6                	jmp    8009e0 <strncmp+0x2e>

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	0f b6 10             	movzbl (%eax),%edx
  8009f7:	84 d2                	test   %dl,%dl
  8009f9:	74 09                	je     800a04 <strchr+0x1a>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	74 0a                	je     800a09 <strchr+0x1f>
	for (; *s; s++)
  8009ff:	83 c0 01             	add    $0x1,%eax
  800a02:	eb f0                	jmp    8009f4 <strchr+0xa>
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a18:	38 ca                	cmp    %cl,%dl
  800a1a:	74 09                	je     800a25 <strfind+0x1a>
  800a1c:	84 d2                	test   %dl,%dl
  800a1e:	74 05                	je     800a25 <strfind+0x1a>
	for (; *s; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	eb f0                	jmp    800a15 <strfind+0xa>
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 31                	je     800a68 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	89 f8                	mov    %edi,%eax
  800a39:	09 c8                	or     %ecx,%eax
  800a3b:	a8 03                	test   $0x3,%al
  800a3d:	75 23                	jne    800a62 <memset+0x3b>
		c &= 0xFF;
  800a3f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a43:	89 d3                	mov    %edx,%ebx
  800a45:	c1 e3 08             	shl    $0x8,%ebx
  800a48:	89 d0                	mov    %edx,%eax
  800a4a:	c1 e0 18             	shl    $0x18,%eax
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 10             	shl    $0x10,%esi
  800a52:	09 f0                	or     %esi,%eax
  800a54:	09 c2                	or     %eax,%edx
  800a56:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a58:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	fc                   	cld    
  800a5e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a60:	eb 06                	jmp    800a68 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	fc                   	cld    
  800a66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a68:	89 f8                	mov    %edi,%eax
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5f                   	pop    %edi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7d:	39 c6                	cmp    %eax,%esi
  800a7f:	73 32                	jae    800ab3 <memmove+0x44>
  800a81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a84:	39 c2                	cmp    %eax,%edx
  800a86:	76 2b                	jbe    800ab3 <memmove+0x44>
		s += n;
		d += n;
  800a88:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8b:	89 fe                	mov    %edi,%esi
  800a8d:	09 ce                	or     %ecx,%esi
  800a8f:	09 d6                	or     %edx,%esi
  800a91:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a97:	75 0e                	jne    800aa7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a99:	83 ef 04             	sub    $0x4,%edi
  800a9c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa2:	fd                   	std    
  800aa3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa5:	eb 09                	jmp    800ab0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa7:	83 ef 01             	sub    $0x1,%edi
  800aaa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aad:	fd                   	std    
  800aae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab0:	fc                   	cld    
  800ab1:	eb 1a                	jmp    800acd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab3:	89 c2                	mov    %eax,%edx
  800ab5:	09 ca                	or     %ecx,%edx
  800ab7:	09 f2                	or     %esi,%edx
  800ab9:	f6 c2 03             	test   $0x3,%dl
  800abc:	75 0a                	jne    800ac8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac1:	89 c7                	mov    %eax,%edi
  800ac3:	fc                   	cld    
  800ac4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac6:	eb 05                	jmp    800acd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ac8:	89 c7                	mov    %eax,%edi
  800aca:	fc                   	cld    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad7:	ff 75 10             	pushl  0x10(%ebp)
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 8a ff ff ff       	call   800a6f <memmove>
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 c6                	mov    %eax,%esi
  800af4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af7:	39 f0                	cmp    %esi,%eax
  800af9:	74 1c                	je     800b17 <memcmp+0x30>
		if (*s1 != *s2)
  800afb:	0f b6 08             	movzbl (%eax),%ecx
  800afe:	0f b6 1a             	movzbl (%edx),%ebx
  800b01:	38 d9                	cmp    %bl,%cl
  800b03:	75 08                	jne    800b0d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	eb ea                	jmp    800af7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b0d:	0f b6 c1             	movzbl %cl,%eax
  800b10:	0f b6 db             	movzbl %bl,%ebx
  800b13:	29 d8                	sub    %ebx,%eax
  800b15:	eb 05                	jmp    800b1c <memcmp+0x35>
	}

	return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2e:	39 d0                	cmp    %edx,%eax
  800b30:	73 09                	jae    800b3b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b32:	38 08                	cmp    %cl,(%eax)
  800b34:	74 05                	je     800b3b <memfind+0x1b>
	for (; s < ends; s++)
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	eb f3                	jmp    800b2e <memfind+0xe>
			break;
	return (void *) s;
}
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b49:	eb 03                	jmp    800b4e <strtol+0x11>
		s++;
  800b4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b4e:	0f b6 01             	movzbl (%ecx),%eax
  800b51:	3c 20                	cmp    $0x20,%al
  800b53:	74 f6                	je     800b4b <strtol+0xe>
  800b55:	3c 09                	cmp    $0x9,%al
  800b57:	74 f2                	je     800b4b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b59:	3c 2b                	cmp    $0x2b,%al
  800b5b:	74 2a                	je     800b87 <strtol+0x4a>
	int neg = 0;
  800b5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b62:	3c 2d                	cmp    $0x2d,%al
  800b64:	74 2b                	je     800b91 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b6c:	75 0f                	jne    800b7d <strtol+0x40>
  800b6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b71:	74 28                	je     800b9b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b73:	85 db                	test   %ebx,%ebx
  800b75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7a:	0f 44 d8             	cmove  %eax,%ebx
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b85:	eb 50                	jmp    800bd7 <strtol+0x9a>
		s++;
  800b87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8f:	eb d5                	jmp    800b66 <strtol+0x29>
		s++, neg = 1;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bf 01 00 00 00       	mov    $0x1,%edi
  800b99:	eb cb                	jmp    800b66 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b9f:	74 0e                	je     800baf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	75 d8                	jne    800b7d <strtol+0x40>
		s++, base = 8;
  800ba5:	83 c1 01             	add    $0x1,%ecx
  800ba8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bad:	eb ce                	jmp    800b7d <strtol+0x40>
		s += 2, base = 16;
  800baf:	83 c1 02             	add    $0x2,%ecx
  800bb2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb7:	eb c4                	jmp    800b7d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bb9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 19             	cmp    $0x19,%bl
  800bc1:	77 29                	ja     800bec <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc3:	0f be d2             	movsbl %dl,%edx
  800bc6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcc:	7d 30                	jge    800bfe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd7:	0f b6 11             	movzbl (%ecx),%edx
  800bda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 09             	cmp    $0x9,%bl
  800be2:	77 d5                	ja     800bb9 <strtol+0x7c>
			dig = *s - '0';
  800be4:	0f be d2             	movsbl %dl,%edx
  800be7:	83 ea 30             	sub    $0x30,%edx
  800bea:	eb dd                	jmp    800bc9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 37             	sub    $0x37,%edx
  800bfc:	eb cb                	jmp    800bc9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c02:	74 05                	je     800c09 <strtol+0xcc>
		*endptr = (char *) s;
  800c04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	f7 da                	neg    %edx
  800c0d:	85 ff                	test   %edi,%edi
  800c0f:	0f 45 c2             	cmovne %edx,%eax
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	89 c7                	mov    %eax,%edi
  800c2c:	89 c6                	mov    %eax,%esi
  800c2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 01 00 00 00       	mov    $0x1,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6a:	89 cb                	mov    %ecx,%ebx
  800c6c:	89 cf                	mov    %ecx,%edi
  800c6e:	89 ce                	mov    %ecx,%esi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 03                	push   $0x3
  800c84:	68 df 2c 80 00       	push   $0x802cdf
  800c89:	6a 23                	push   $0x23
  800c8b:	68 fc 2c 80 00       	push   $0x802cfc
  800c90:	e8 95 f5 ff ff       	call   80022a <_panic>

00800c95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_yield>:

void
sys_yield(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdc:	be 00 00 00 00       	mov    $0x0,%esi
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cef:	89 f7                	mov    %esi,%edi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 04                	push   $0x4
  800d05:	68 df 2c 80 00       	push   $0x802cdf
  800d0a:	6a 23                	push   $0x23
  800d0c:	68 fc 2c 80 00       	push   $0x802cfc
  800d11:	e8 14 f5 ff ff       	call   80022a <_panic>

00800d16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d30:	8b 75 18             	mov    0x18(%ebp),%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 05                	push   $0x5
  800d47:	68 df 2c 80 00       	push   $0x802cdf
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 fc 2c 80 00       	push   $0x802cfc
  800d53:	e8 d2 f4 ff ff       	call   80022a <_panic>

00800d58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	89 de                	mov    %ebx,%esi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 06                	push   $0x6
  800d89:	68 df 2c 80 00       	push   $0x802cdf
  800d8e:	6a 23                	push   $0x23
  800d90:	68 fc 2c 80 00       	push   $0x802cfc
  800d95:	e8 90 f4 ff ff       	call   80022a <_panic>

00800d9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 08 00 00 00       	mov    $0x8,%eax
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 08                	push   $0x8
  800dcb:	68 df 2c 80 00       	push   $0x802cdf
  800dd0:	6a 23                	push   $0x23
  800dd2:	68 fc 2c 80 00       	push   $0x802cfc
  800dd7:	e8 4e f4 ff ff       	call   80022a <_panic>

00800ddc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 09 00 00 00       	mov    $0x9,%eax
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 09                	push   $0x9
  800e0d:	68 df 2c 80 00       	push   $0x802cdf
  800e12:	6a 23                	push   $0x23
  800e14:	68 fc 2c 80 00       	push   $0x802cfc
  800e19:	e8 0c f4 ff ff       	call   80022a <_panic>

00800e1e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 0a                	push   $0xa
  800e4f:	68 df 2c 80 00       	push   $0x802cdf
  800e54:	6a 23                	push   $0x23
  800e56:	68 fc 2c 80 00       	push   $0x802cfc
  800e5b:	e8 ca f3 ff ff       	call   80022a <_panic>

00800e60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e71:	be 00 00 00 00       	mov    $0x0,%esi
  800e76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e99:	89 cb                	mov    %ecx,%ebx
  800e9b:	89 cf                	mov    %ecx,%edi
  800e9d:	89 ce                	mov    %ecx,%esi
  800e9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7f 08                	jg     800ead <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ead:	83 ec 0c             	sub    $0xc,%esp
  800eb0:	50                   	push   %eax
  800eb1:	6a 0d                	push   $0xd
  800eb3:	68 df 2c 80 00       	push   $0x802cdf
  800eb8:	6a 23                	push   $0x23
  800eba:	68 fc 2c 80 00       	push   $0x802cfc
  800ebf:	e8 66 f3 ff ff       	call   80022a <_panic>

00800ec4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed4:	89 d1                	mov    %edx,%ecx
  800ed6:	89 d3                	mov    %edx,%ebx
  800ed8:	89 d7                	mov    %edx,%edi
  800eda:	89 d6                	mov    %edx,%esi
  800edc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eef:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ef1:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ef4:	89 d9                	mov    %ebx,%ecx
  800ef6:	c1 e9 16             	shr    $0x16,%ecx
  800ef9:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800f00:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f05:	f6 c1 01             	test   $0x1,%cl
  800f08:	74 0c                	je     800f16 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800f0a:	89 d9                	mov    %ebx,%ecx
  800f0c:	c1 e9 0c             	shr    $0xc,%ecx
  800f0f:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800f16:	f6 c2 02             	test   $0x2,%dl
  800f19:	0f 84 a3 00 00 00    	je     800fc2 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800f1f:	89 da                	mov    %ebx,%edx
  800f21:	c1 ea 0c             	shr    $0xc,%edx
  800f24:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f2b:	f6 c6 08             	test   $0x8,%dh
  800f2e:	0f 84 b7 00 00 00    	je     800feb <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800f34:	e8 5c fd ff ff       	call   800c95 <sys_getenvid>
  800f39:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f3b:	83 ec 04             	sub    $0x4,%esp
  800f3e:	6a 07                	push   $0x7
  800f40:	68 00 f0 7f 00       	push   $0x7ff000
  800f45:	50                   	push   %eax
  800f46:	e8 88 fd ff ff       	call   800cd3 <sys_page_alloc>
  800f4b:	83 c4 10             	add    $0x10,%esp
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	0f 88 bc 00 00 00    	js     801012 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800f56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800f5c:	83 ec 04             	sub    $0x4,%esp
  800f5f:	68 00 10 00 00       	push   $0x1000
  800f64:	53                   	push   %ebx
  800f65:	68 00 f0 7f 00       	push   $0x7ff000
  800f6a:	e8 00 fb ff ff       	call   800a6f <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f6f:	83 c4 08             	add    $0x8,%esp
  800f72:	53                   	push   %ebx
  800f73:	56                   	push   %esi
  800f74:	e8 df fd ff ff       	call   800d58 <sys_page_unmap>
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	0f 88 a0 00 00 00    	js     801024 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	6a 07                	push   $0x7
  800f89:	53                   	push   %ebx
  800f8a:	56                   	push   %esi
  800f8b:	68 00 f0 7f 00       	push   $0x7ff000
  800f90:	56                   	push   %esi
  800f91:	e8 80 fd ff ff       	call   800d16 <sys_page_map>
  800f96:	83 c4 20             	add    $0x20,%esp
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	0f 88 95 00 00 00    	js     801036 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	68 00 f0 7f 00       	push   $0x7ff000
  800fa9:	56                   	push   %esi
  800faa:	e8 a9 fd ff ff       	call   800d58 <sys_page_unmap>
  800faf:	83 c4 10             	add    $0x10,%esp
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	0f 88 8e 00 00 00    	js     801048 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800fc2:	8b 70 28             	mov    0x28(%eax),%esi
  800fc5:	e8 cb fc ff ff       	call   800c95 <sys_getenvid>
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
  800fcc:	50                   	push   %eax
  800fcd:	68 0c 2d 80 00       	push   $0x802d0c
  800fd2:	e8 2e f3 ff ff       	call   800305 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800fd7:	83 c4 0c             	add    $0xc,%esp
  800fda:	68 30 2d 80 00       	push   $0x802d30
  800fdf:	6a 27                	push   $0x27
  800fe1:	68 04 2e 80 00       	push   $0x802e04
  800fe6:	e8 3f f2 ff ff       	call   80022a <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800feb:	8b 78 28             	mov    0x28(%eax),%edi
  800fee:	e8 a2 fc ff ff       	call   800c95 <sys_getenvid>
  800ff3:	57                   	push   %edi
  800ff4:	53                   	push   %ebx
  800ff5:	50                   	push   %eax
  800ff6:	68 0c 2d 80 00       	push   $0x802d0c
  800ffb:	e8 05 f3 ff ff       	call   800305 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801000:	56                   	push   %esi
  801001:	68 64 2d 80 00       	push   $0x802d64
  801006:	6a 2b                	push   $0x2b
  801008:	68 04 2e 80 00       	push   $0x802e04
  80100d:	e8 18 f2 ff ff       	call   80022a <_panic>
      panic("pgfault: page allocation failed %e", r);
  801012:	50                   	push   %eax
  801013:	68 9c 2d 80 00       	push   $0x802d9c
  801018:	6a 39                	push   $0x39
  80101a:	68 04 2e 80 00       	push   $0x802e04
  80101f:	e8 06 f2 ff ff       	call   80022a <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801024:	50                   	push   %eax
  801025:	68 c0 2d 80 00       	push   $0x802dc0
  80102a:	6a 3e                	push   $0x3e
  80102c:	68 04 2e 80 00       	push   $0x802e04
  801031:	e8 f4 f1 ff ff       	call   80022a <_panic>
      panic("pgfault: page map failed (%e)", r);
  801036:	50                   	push   %eax
  801037:	68 0f 2e 80 00       	push   $0x802e0f
  80103c:	6a 40                	push   $0x40
  80103e:	68 04 2e 80 00       	push   $0x802e04
  801043:	e8 e2 f1 ff ff       	call   80022a <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801048:	50                   	push   %eax
  801049:	68 c0 2d 80 00       	push   $0x802dc0
  80104e:	6a 42                	push   $0x42
  801050:	68 04 2e 80 00       	push   $0x802e04
  801055:	e8 d0 f1 ff ff       	call   80022a <_panic>

0080105a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  801063:	68 e3 0e 80 00       	push   $0x800ee3
  801068:	e8 cd 13 00 00       	call   80243a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80106d:	b8 07 00 00 00       	mov    $0x7,%eax
  801072:	cd 30                	int    $0x30
  801074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	85 c0                	test   %eax,%eax
  80107c:	78 2d                	js     8010ab <fork+0x51>
  80107e:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801080:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  801085:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801089:	0f 85 a6 00 00 00    	jne    801135 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  80108f:	e8 01 fc ff ff       	call   800c95 <sys_getenvid>
  801094:	25 ff 03 00 00       	and    $0x3ff,%eax
  801099:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80109c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a1:	a3 20 54 80 00       	mov    %eax,0x805420
      return 0;
  8010a6:	e9 79 01 00 00       	jmp    801224 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8010ab:	50                   	push   %eax
  8010ac:	68 b2 28 80 00       	push   $0x8028b2
  8010b1:	68 aa 00 00 00       	push   $0xaa
  8010b6:	68 04 2e 80 00       	push   $0x802e04
  8010bb:	e8 6a f1 ff ff       	call   80022a <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	6a 05                	push   $0x5
  8010c5:	53                   	push   %ebx
  8010c6:	57                   	push   %edi
  8010c7:	53                   	push   %ebx
  8010c8:	6a 00                	push   $0x0
  8010ca:	e8 47 fc ff ff       	call   800d16 <sys_page_map>
  8010cf:	83 c4 20             	add    $0x20,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	79 4d                	jns    801123 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010d6:	50                   	push   %eax
  8010d7:	68 2d 2e 80 00       	push   $0x802e2d
  8010dc:	6a 61                	push   $0x61
  8010de:	68 04 2e 80 00       	push   $0x802e04
  8010e3:	e8 42 f1 ff ff       	call   80022a <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8010e8:	83 ec 0c             	sub    $0xc,%esp
  8010eb:	68 05 08 00 00       	push   $0x805
  8010f0:	53                   	push   %ebx
  8010f1:	57                   	push   %edi
  8010f2:	53                   	push   %ebx
  8010f3:	6a 00                	push   $0x0
  8010f5:	e8 1c fc ff ff       	call   800d16 <sys_page_map>
  8010fa:	83 c4 20             	add    $0x20,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	0f 88 b7 00 00 00    	js     8011bc <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	68 05 08 00 00       	push   $0x805
  80110d:	53                   	push   %ebx
  80110e:	6a 00                	push   $0x0
  801110:	53                   	push   %ebx
  801111:	6a 00                	push   $0x0
  801113:	e8 fe fb ff ff       	call   800d16 <sys_page_map>
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	85 c0                	test   %eax,%eax
  80111d:	0f 88 ab 00 00 00    	js     8011ce <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801123:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801129:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80112f:	0f 84 ab 00 00 00    	je     8011e0 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801135:	89 d8                	mov    %ebx,%eax
  801137:	c1 e8 16             	shr    $0x16,%eax
  80113a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801141:	a8 01                	test   $0x1,%al
  801143:	74 de                	je     801123 <fork+0xc9>
  801145:	89 d8                	mov    %ebx,%eax
  801147:	c1 e8 0c             	shr    $0xc,%eax
  80114a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801151:	f6 c2 01             	test   $0x1,%dl
  801154:	74 cd                	je     801123 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801156:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	c1 ea 16             	shr    $0x16,%edx
  80115e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801165:	f6 c2 01             	test   $0x1,%dl
  801168:	74 b9                	je     801123 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80116a:	c1 e8 0c             	shr    $0xc,%eax
  80116d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801174:	a8 01                	test   $0x1,%al
  801176:	74 ab                	je     801123 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801178:	a9 02 08 00 00       	test   $0x802,%eax
  80117d:	0f 84 3d ff ff ff    	je     8010c0 <fork+0x66>
	else if(pte & PTE_SHARE)
  801183:	f6 c4 04             	test   $0x4,%ah
  801186:	0f 84 5c ff ff ff    	je     8010e8 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	25 07 0e 00 00       	and    $0xe07,%eax
  801194:	50                   	push   %eax
  801195:	53                   	push   %ebx
  801196:	57                   	push   %edi
  801197:	53                   	push   %ebx
  801198:	6a 00                	push   $0x0
  80119a:	e8 77 fb ff ff       	call   800d16 <sys_page_map>
  80119f:	83 c4 20             	add    $0x20,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	0f 89 79 ff ff ff    	jns    801123 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8011aa:	50                   	push   %eax
  8011ab:	68 2d 2e 80 00       	push   $0x802e2d
  8011b0:	6a 67                	push   $0x67
  8011b2:	68 04 2e 80 00       	push   $0x802e04
  8011b7:	e8 6e f0 ff ff       	call   80022a <_panic>
			panic("Page Map Failed: %e", error_code);
  8011bc:	50                   	push   %eax
  8011bd:	68 2d 2e 80 00       	push   $0x802e2d
  8011c2:	6a 6d                	push   $0x6d
  8011c4:	68 04 2e 80 00       	push   $0x802e04
  8011c9:	e8 5c f0 ff ff       	call   80022a <_panic>
			panic("Page Map Failed: %e", error_code);
  8011ce:	50                   	push   %eax
  8011cf:	68 2d 2e 80 00       	push   $0x802e2d
  8011d4:	6a 70                	push   $0x70
  8011d6:	68 04 2e 80 00       	push   $0x802e04
  8011db:	e8 4a f0 ff ff       	call   80022a <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	6a 07                	push   $0x7
  8011e5:	68 00 f0 bf ee       	push   $0xeebff000
  8011ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ed:	e8 e1 fa ff ff       	call   800cd3 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 36                	js     80122f <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	68 b0 24 80 00       	push   $0x8024b0
  801201:	ff 75 e4             	pushl  -0x1c(%ebp)
  801204:	e8 15 fc ff ff       	call   800e1e <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 34                	js     801244 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801210:	83 ec 08             	sub    $0x8,%esp
  801213:	6a 02                	push   $0x2
  801215:	ff 75 e4             	pushl  -0x1c(%ebp)
  801218:	e8 7d fb ff ff       	call   800d9a <sys_env_set_status>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	78 35                	js     801259 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  801224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801227:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122a:	5b                   	pop    %ebx
  80122b:	5e                   	pop    %esi
  80122c:	5f                   	pop    %edi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  80122f:	50                   	push   %eax
  801230:	68 b2 28 80 00       	push   $0x8028b2
  801235:	68 ba 00 00 00       	push   $0xba
  80123a:	68 04 2e 80 00       	push   $0x802e04
  80123f:	e8 e6 ef ff ff       	call   80022a <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801244:	50                   	push   %eax
  801245:	68 e0 2d 80 00       	push   $0x802de0
  80124a:	68 bf 00 00 00       	push   $0xbf
  80124f:	68 04 2e 80 00       	push   $0x802e04
  801254:	e8 d1 ef ff ff       	call   80022a <_panic>
      panic("sys_env_set_status: %e", r);
  801259:	50                   	push   %eax
  80125a:	68 41 2e 80 00       	push   $0x802e41
  80125f:	68 c3 00 00 00       	push   $0xc3
  801264:	68 04 2e 80 00       	push   $0x802e04
  801269:	e8 bc ef ff ff       	call   80022a <_panic>

0080126e <sfork>:

// Challenge!
int
sfork(void)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801274:	68 58 2e 80 00       	push   $0x802e58
  801279:	68 cc 00 00 00       	push   $0xcc
  80127e:	68 04 2e 80 00       	push   $0x802e04
  801283:	e8 a2 ef ff ff       	call   80022a <_panic>

00801288 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	05 00 00 00 30       	add    $0x30000000,%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
}
  801296:	5d                   	pop    %ebp
  801297:	c3                   	ret    

00801298 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    

008012af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 16             	shr    $0x16,%edx
  8012bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c3:	f6 c2 01             	test   $0x1,%dl
  8012c6:	74 2d                	je     8012f5 <fd_alloc+0x46>
  8012c8:	89 c2                	mov    %eax,%edx
  8012ca:	c1 ea 0c             	shr    $0xc,%edx
  8012cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012d4:	f6 c2 01             	test   $0x1,%dl
  8012d7:	74 1c                	je     8012f5 <fd_alloc+0x46>
  8012d9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012de:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e3:	75 d2                	jne    8012b7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f3:	eb 0a                	jmp    8012ff <fd_alloc+0x50>
			*fd_store = fd;
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801307:	83 f8 1f             	cmp    $0x1f,%eax
  80130a:	77 30                	ja     80133c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80130c:	c1 e0 0c             	shl    $0xc,%eax
  80130f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801314:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80131a:	f6 c2 01             	test   $0x1,%dl
  80131d:	74 24                	je     801343 <fd_lookup+0x42>
  80131f:	89 c2                	mov    %eax,%edx
  801321:	c1 ea 0c             	shr    $0xc,%edx
  801324:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132b:	f6 c2 01             	test   $0x1,%dl
  80132e:	74 1a                	je     80134a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801330:	8b 55 0c             	mov    0xc(%ebp),%edx
  801333:	89 02                	mov    %eax,(%edx)
	return 0;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
		return -E_INVAL;
  80133c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801341:	eb f7                	jmp    80133a <fd_lookup+0x39>
		return -E_INVAL;
  801343:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801348:	eb f0                	jmp    80133a <fd_lookup+0x39>
  80134a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134f:	eb e9                	jmp    80133a <fd_lookup+0x39>

00801351 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80135a:	ba 00 00 00 00       	mov    $0x0,%edx
  80135f:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801364:	39 08                	cmp    %ecx,(%eax)
  801366:	74 38                	je     8013a0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801368:	83 c2 01             	add    $0x1,%edx
  80136b:	8b 04 95 ec 2e 80 00 	mov    0x802eec(,%edx,4),%eax
  801372:	85 c0                	test   %eax,%eax
  801374:	75 ee                	jne    801364 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801376:	a1 20 54 80 00       	mov    0x805420,%eax
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	51                   	push   %ecx
  801382:	50                   	push   %eax
  801383:	68 70 2e 80 00       	push   $0x802e70
  801388:	e8 78 ef ff ff       	call   800305 <cprintf>
	*dev = 0;
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
			*dev = devtab[i];
  8013a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb f2                	jmp    80139e <dev_lookup+0x4d>

008013ac <fd_close>:
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 24             	sub    $0x24,%esp
  8013b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013be:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bf:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013c5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c8:	50                   	push   %eax
  8013c9:	e8 33 ff ff ff       	call   801301 <fd_lookup>
  8013ce:	89 c3                	mov    %eax,%ebx
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 05                	js     8013dc <fd_close+0x30>
	    || fd != fd2)
  8013d7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013da:	74 16                	je     8013f2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8013dc:	89 f8                	mov    %edi,%eax
  8013de:	84 c0                	test   %al,%al
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	0f 44 d8             	cmove  %eax,%ebx
}
  8013e8:	89 d8                	mov    %ebx,%eax
  8013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5e                   	pop    %esi
  8013ef:	5f                   	pop    %edi
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013f8:	50                   	push   %eax
  8013f9:	ff 36                	pushl  (%esi)
  8013fb:	e8 51 ff ff ff       	call   801351 <dev_lookup>
  801400:	89 c3                	mov    %eax,%ebx
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 1a                	js     801423 <fd_close+0x77>
		if (dev->dev_close)
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80140f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801414:	85 c0                	test   %eax,%eax
  801416:	74 0b                	je     801423 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	56                   	push   %esi
  80141c:	ff d0                	call   *%eax
  80141e:	89 c3                	mov    %eax,%ebx
  801420:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	56                   	push   %esi
  801427:	6a 00                	push   $0x0
  801429:	e8 2a f9 ff ff       	call   800d58 <sys_page_unmap>
	return r;
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	eb b5                	jmp    8013e8 <fd_close+0x3c>

00801433 <close>:

int
close(int fdnum)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 bc fe ff ff       	call   801301 <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	79 02                	jns    80144e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    
		return fd_close(fd, 1);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	6a 01                	push   $0x1
  801453:	ff 75 f4             	pushl  -0xc(%ebp)
  801456:	e8 51 ff ff ff       	call   8013ac <fd_close>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	eb ec                	jmp    80144c <close+0x19>

00801460 <close_all>:

void
close_all(void)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801467:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	53                   	push   %ebx
  801470:	e8 be ff ff ff       	call   801433 <close>
	for (i = 0; i < MAXFD; i++)
  801475:	83 c3 01             	add    $0x1,%ebx
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	83 fb 20             	cmp    $0x20,%ebx
  80147e:	75 ec                	jne    80146c <close_all+0xc>
}
  801480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	57                   	push   %edi
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80148e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801491:	50                   	push   %eax
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 67 fe ff ff       	call   801301 <fd_lookup>
  80149a:	89 c3                	mov    %eax,%ebx
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	0f 88 81 00 00 00    	js     801528 <dup+0xa3>
		return r;
	close(newfdnum);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	e8 81 ff ff ff       	call   801433 <close>

	newfd = INDEX2FD(newfdnum);
  8014b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014b5:	c1 e6 0c             	shl    $0xc,%esi
  8014b8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014be:	83 c4 04             	add    $0x4,%esp
  8014c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014c4:	e8 cf fd ff ff       	call   801298 <fd2data>
  8014c9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014cb:	89 34 24             	mov    %esi,(%esp)
  8014ce:	e8 c5 fd ff ff       	call   801298 <fd2data>
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014d8:	89 d8                	mov    %ebx,%eax
  8014da:	c1 e8 16             	shr    $0x16,%eax
  8014dd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e4:	a8 01                	test   $0x1,%al
  8014e6:	74 11                	je     8014f9 <dup+0x74>
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	c1 e8 0c             	shr    $0xc,%eax
  8014ed:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014f4:	f6 c2 01             	test   $0x1,%dl
  8014f7:	75 39                	jne    801532 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014fc:	89 d0                	mov    %edx,%eax
  8014fe:	c1 e8 0c             	shr    $0xc,%eax
  801501:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801508:	83 ec 0c             	sub    $0xc,%esp
  80150b:	25 07 0e 00 00       	and    $0xe07,%eax
  801510:	50                   	push   %eax
  801511:	56                   	push   %esi
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	6a 00                	push   $0x0
  801517:	e8 fa f7 ff ff       	call   800d16 <sys_page_map>
  80151c:	89 c3                	mov    %eax,%ebx
  80151e:	83 c4 20             	add    $0x20,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 31                	js     801556 <dup+0xd1>
		goto err;

	return newfdnum;
  801525:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5f                   	pop    %edi
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801532:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	25 07 0e 00 00       	and    $0xe07,%eax
  801541:	50                   	push   %eax
  801542:	57                   	push   %edi
  801543:	6a 00                	push   $0x0
  801545:	53                   	push   %ebx
  801546:	6a 00                	push   $0x0
  801548:	e8 c9 f7 ff ff       	call   800d16 <sys_page_map>
  80154d:	89 c3                	mov    %eax,%ebx
  80154f:	83 c4 20             	add    $0x20,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	79 a3                	jns    8014f9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	56                   	push   %esi
  80155a:	6a 00                	push   $0x0
  80155c:	e8 f7 f7 ff ff       	call   800d58 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801561:	83 c4 08             	add    $0x8,%esp
  801564:	57                   	push   %edi
  801565:	6a 00                	push   $0x0
  801567:	e8 ec f7 ff ff       	call   800d58 <sys_page_unmap>
	return r;
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	eb b7                	jmp    801528 <dup+0xa3>

00801571 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	53                   	push   %ebx
  801575:	83 ec 1c             	sub    $0x1c,%esp
  801578:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157e:	50                   	push   %eax
  80157f:	53                   	push   %ebx
  801580:	e8 7c fd ff ff       	call   801301 <fd_lookup>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 3f                	js     8015cb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	ff 30                	pushl  (%eax)
  801598:	e8 b4 fd ff ff       	call   801351 <dev_lookup>
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 27                	js     8015cb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a7:	8b 42 08             	mov    0x8(%edx),%eax
  8015aa:	83 e0 03             	and    $0x3,%eax
  8015ad:	83 f8 01             	cmp    $0x1,%eax
  8015b0:	74 1e                	je     8015d0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	8b 40 08             	mov    0x8(%eax),%eax
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	74 35                	je     8015f1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	52                   	push   %edx
  8015c6:	ff d0                	call   *%eax
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d0:	a1 20 54 80 00       	mov    0x805420,%eax
  8015d5:	8b 40 48             	mov    0x48(%eax),%eax
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	53                   	push   %ebx
  8015dc:	50                   	push   %eax
  8015dd:	68 b1 2e 80 00       	push   $0x802eb1
  8015e2:	e8 1e ed ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ef:	eb da                	jmp    8015cb <read+0x5a>
		return -E_NOT_SUPP;
  8015f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f6:	eb d3                	jmp    8015cb <read+0x5a>

008015f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	57                   	push   %edi
  8015fc:	56                   	push   %esi
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	8b 7d 08             	mov    0x8(%ebp),%edi
  801604:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801607:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160c:	39 f3                	cmp    %esi,%ebx
  80160e:	73 23                	jae    801633 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	89 f0                	mov    %esi,%eax
  801615:	29 d8                	sub    %ebx,%eax
  801617:	50                   	push   %eax
  801618:	89 d8                	mov    %ebx,%eax
  80161a:	03 45 0c             	add    0xc(%ebp),%eax
  80161d:	50                   	push   %eax
  80161e:	57                   	push   %edi
  80161f:	e8 4d ff ff ff       	call   801571 <read>
		if (m < 0)
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	85 c0                	test   %eax,%eax
  801629:	78 06                	js     801631 <readn+0x39>
			return m;
		if (m == 0)
  80162b:	74 06                	je     801633 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80162d:	01 c3                	add    %eax,%ebx
  80162f:	eb db                	jmp    80160c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801631:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801633:	89 d8                	mov    %ebx,%eax
  801635:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5f                   	pop    %edi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	53                   	push   %ebx
  801641:	83 ec 1c             	sub    $0x1c,%esp
  801644:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801647:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164a:	50                   	push   %eax
  80164b:	53                   	push   %ebx
  80164c:	e8 b0 fc ff ff       	call   801301 <fd_lookup>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	85 c0                	test   %eax,%eax
  801656:	78 3a                	js     801692 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165e:	50                   	push   %eax
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	ff 30                	pushl  (%eax)
  801664:	e8 e8 fc ff ff       	call   801351 <dev_lookup>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 22                	js     801692 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801677:	74 1e                	je     801697 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167c:	8b 52 0c             	mov    0xc(%edx),%edx
  80167f:	85 d2                	test   %edx,%edx
  801681:	74 35                	je     8016b8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	ff 75 10             	pushl  0x10(%ebp)
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	50                   	push   %eax
  80168d:	ff d2                	call   *%edx
  80168f:	83 c4 10             	add    $0x10,%esp
}
  801692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801695:	c9                   	leave  
  801696:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801697:	a1 20 54 80 00       	mov    0x805420,%eax
  80169c:	8b 40 48             	mov    0x48(%eax),%eax
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	53                   	push   %ebx
  8016a3:	50                   	push   %eax
  8016a4:	68 cd 2e 80 00       	push   $0x802ecd
  8016a9:	e8 57 ec ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b6:	eb da                	jmp    801692 <write+0x55>
		return -E_NOT_SUPP;
  8016b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016bd:	eb d3                	jmp    801692 <write+0x55>

008016bf <seek>:

int
seek(int fdnum, off_t offset)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 08             	pushl  0x8(%ebp)
  8016cc:	e8 30 fc ff ff       	call   801301 <fd_lookup>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 0e                	js     8016e6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016de:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	53                   	push   %ebx
  8016ec:	83 ec 1c             	sub    $0x1c,%esp
  8016ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f5:	50                   	push   %eax
  8016f6:	53                   	push   %ebx
  8016f7:	e8 05 fc ff ff       	call   801301 <fd_lookup>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 37                	js     80173a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801703:	83 ec 08             	sub    $0x8,%esp
  801706:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801709:	50                   	push   %eax
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	ff 30                	pushl  (%eax)
  80170f:	e8 3d fc ff ff       	call   801351 <dev_lookup>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 1f                	js     80173a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801722:	74 1b                	je     80173f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801727:	8b 52 18             	mov    0x18(%edx),%edx
  80172a:	85 d2                	test   %edx,%edx
  80172c:	74 32                	je     801760 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80172e:	83 ec 08             	sub    $0x8,%esp
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	50                   	push   %eax
  801735:	ff d2                	call   *%edx
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80173f:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801744:	8b 40 48             	mov    0x48(%eax),%eax
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	53                   	push   %ebx
  80174b:	50                   	push   %eax
  80174c:	68 90 2e 80 00       	push   $0x802e90
  801751:	e8 af eb ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175e:	eb da                	jmp    80173a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801760:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801765:	eb d3                	jmp    80173a <ftruncate+0x52>

00801767 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	53                   	push   %ebx
  80176b:	83 ec 1c             	sub    $0x1c,%esp
  80176e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801771:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	e8 84 fb ff ff       	call   801301 <fd_lookup>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	78 4b                	js     8017cf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178e:	ff 30                	pushl  (%eax)
  801790:	e8 bc fb ff ff       	call   801351 <dev_lookup>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 33                	js     8017cf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017a3:	74 2f                	je     8017d4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017af:	00 00 00 
	stat->st_isdir = 0;
  8017b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017b9:	00 00 00 
	stat->st_dev = dev;
  8017bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	53                   	push   %ebx
  8017c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c9:	ff 50 14             	call   *0x14(%eax)
  8017cc:	83 c4 10             	add    $0x10,%esp
}
  8017cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8017d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d9:	eb f4                	jmp    8017cf <fstat+0x68>

008017db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	6a 00                	push   $0x0
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 2f 02 00 00       	call   801a1c <open>
  8017ed:	89 c3                	mov    %eax,%ebx
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	78 1b                	js     801811 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017f6:	83 ec 08             	sub    $0x8,%esp
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	50                   	push   %eax
  8017fd:	e8 65 ff ff ff       	call   801767 <fstat>
  801802:	89 c6                	mov    %eax,%esi
	close(fd);
  801804:	89 1c 24             	mov    %ebx,(%esp)
  801807:	e8 27 fc ff ff       	call   801433 <close>
	return r;
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	89 f3                	mov    %esi,%ebx
}
  801811:	89 d8                	mov    %ebx,%eax
  801813:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801816:	5b                   	pop    %ebx
  801817:	5e                   	pop    %esi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	89 c6                	mov    %eax,%esi
  801821:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801823:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80182a:	74 27                	je     801853 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80182c:	6a 07                	push   $0x7
  80182e:	68 00 60 80 00       	push   $0x806000
  801833:	56                   	push   %esi
  801834:	ff 35 00 50 80 00    	pushl  0x805000
  80183a:	e8 0b 0d 00 00       	call   80254a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80183f:	83 c4 0c             	add    $0xc,%esp
  801842:	6a 00                	push   $0x0
  801844:	53                   	push   %ebx
  801845:	6a 00                	push   $0x0
  801847:	e8 8b 0c 00 00       	call   8024d7 <ipc_recv>
}
  80184c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	6a 01                	push   $0x1
  801858:	e8 59 0d 00 00       	call   8025b6 <ipc_find_env>
  80185d:	a3 00 50 80 00       	mov    %eax,0x805000
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	eb c5                	jmp    80182c <fsipc+0x12>

00801867 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8b 40 0c             	mov    0xc(%eax),%eax
  801873:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801880:	ba 00 00 00 00       	mov    $0x0,%edx
  801885:	b8 02 00 00 00       	mov    $0x2,%eax
  80188a:	e8 8b ff ff ff       	call   80181a <fsipc>
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <devfile_flush>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8b 40 0c             	mov    0xc(%eax),%eax
  80189d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8018ac:	e8 69 ff ff ff       	call   80181a <fsipc>
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <devfile_stat>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d2:	e8 43 ff ff ff       	call   80181a <fsipc>
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 2c                	js     801907 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	68 00 60 80 00       	push   $0x806000
  8018e3:	53                   	push   %ebx
  8018e4:	e8 f8 ef ff ff       	call   8008e1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018e9:	a1 80 60 80 00       	mov    0x806080,%eax
  8018ee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018f4:	a1 84 60 80 00       	mov    0x806084,%eax
  8018f9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <devfile_write>:
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	53                   	push   %ebx
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801916:	85 db                	test   %ebx,%ebx
  801918:	75 07                	jne    801921 <devfile_write+0x15>
	return n_all;
  80191a:	89 d8                	mov    %ebx,%eax
}
  80191c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191f:	c9                   	leave  
  801920:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8b 40 0c             	mov    0xc(%eax),%eax
  801927:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  80192c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	53                   	push   %ebx
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	68 08 60 80 00       	push   $0x806008
  80193e:	e8 2c f1 ff ff       	call   800a6f <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	b8 04 00 00 00       	mov    $0x4,%eax
  80194d:	e8 c8 fe ff ff       	call   80181a <fsipc>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 c3                	js     80191c <devfile_write+0x10>
	  assert(r <= n_left);
  801959:	39 d8                	cmp    %ebx,%eax
  80195b:	77 0b                	ja     801968 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  80195d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801962:	7f 1d                	jg     801981 <devfile_write+0x75>
    n_all += r;
  801964:	89 c3                	mov    %eax,%ebx
  801966:	eb b2                	jmp    80191a <devfile_write+0xe>
	  assert(r <= n_left);
  801968:	68 00 2f 80 00       	push   $0x802f00
  80196d:	68 0c 2f 80 00       	push   $0x802f0c
  801972:	68 9f 00 00 00       	push   $0x9f
  801977:	68 21 2f 80 00       	push   $0x802f21
  80197c:	e8 a9 e8 ff ff       	call   80022a <_panic>
	  assert(r <= PGSIZE);
  801981:	68 2c 2f 80 00       	push   $0x802f2c
  801986:	68 0c 2f 80 00       	push   $0x802f0c
  80198b:	68 a0 00 00 00       	push   $0xa0
  801990:	68 21 2f 80 00       	push   $0x802f21
  801995:	e8 90 e8 ff ff       	call   80022a <_panic>

0080199a <devfile_read>:
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
  80199f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019ad:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8019bd:	e8 58 fe ff ff       	call   80181a <fsipc>
  8019c2:	89 c3                	mov    %eax,%ebx
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 1f                	js     8019e7 <devfile_read+0x4d>
	assert(r <= n);
  8019c8:	39 f0                	cmp    %esi,%eax
  8019ca:	77 24                	ja     8019f0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d1:	7f 33                	jg     801a06 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	50                   	push   %eax
  8019d7:	68 00 60 80 00       	push   $0x806000
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	e8 8b f0 ff ff       	call   800a6f <memmove>
	return r;
  8019e4:	83 c4 10             	add    $0x10,%esp
}
  8019e7:	89 d8                	mov    %ebx,%eax
  8019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
	assert(r <= n);
  8019f0:	68 38 2f 80 00       	push   $0x802f38
  8019f5:	68 0c 2f 80 00       	push   $0x802f0c
  8019fa:	6a 7c                	push   $0x7c
  8019fc:	68 21 2f 80 00       	push   $0x802f21
  801a01:	e8 24 e8 ff ff       	call   80022a <_panic>
	assert(r <= PGSIZE);
  801a06:	68 2c 2f 80 00       	push   $0x802f2c
  801a0b:	68 0c 2f 80 00       	push   $0x802f0c
  801a10:	6a 7d                	push   $0x7d
  801a12:	68 21 2f 80 00       	push   $0x802f21
  801a17:	e8 0e e8 ff ff       	call   80022a <_panic>

00801a1c <open>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	56                   	push   %esi
  801a20:	53                   	push   %ebx
  801a21:	83 ec 1c             	sub    $0x1c,%esp
  801a24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a27:	56                   	push   %esi
  801a28:	e8 7b ee ff ff       	call   8008a8 <strlen>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a35:	7f 6c                	jg     801aa3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3d:	50                   	push   %eax
  801a3e:	e8 6c f8 ff ff       	call   8012af <fd_alloc>
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 3c                	js     801a88 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a4c:	83 ec 08             	sub    $0x8,%esp
  801a4f:	56                   	push   %esi
  801a50:	68 00 60 80 00       	push   $0x806000
  801a55:	e8 87 ee ff ff       	call   8008e1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	e8 ab fd ff ff       	call   80181a <fsipc>
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 19                	js     801a91 <open+0x75>
	return fd2num(fd);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7e:	e8 05 f8 ff ff       	call   801288 <fd2num>
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	83 c4 10             	add    $0x10,%esp
}
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
		fd_close(fd, 0);
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 f4             	pushl  -0xc(%ebp)
  801a99:	e8 0e f9 ff ff       	call   8013ac <fd_close>
		return r;
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	eb e5                	jmp    801a88 <open+0x6c>
		return -E_BAD_PATH;
  801aa3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa8:	eb de                	jmp    801a88 <open+0x6c>

00801aaa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	b8 08 00 00 00       	mov    $0x8,%eax
  801aba:	e8 5b fd ff ff       	call   80181a <fsipc>
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	e8 c4 f7 ff ff       	call   801298 <fd2data>
  801ad4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ad6:	83 c4 08             	add    $0x8,%esp
  801ad9:	68 3f 2f 80 00       	push   $0x802f3f
  801ade:	53                   	push   %ebx
  801adf:	e8 fd ed ff ff       	call   8008e1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ae4:	8b 46 04             	mov    0x4(%esi),%eax
  801ae7:	2b 06                	sub    (%esi),%eax
  801ae9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801af6:	00 00 00 
	stat->st_dev = &devpipe;
  801af9:	c7 83 88 00 00 00 20 	movl   $0x804020,0x88(%ebx)
  801b00:	40 80 00 
	return 0;
}
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    

00801b0f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	53                   	push   %ebx
  801b13:	83 ec 0c             	sub    $0xc,%esp
  801b16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b19:	53                   	push   %ebx
  801b1a:	6a 00                	push   $0x0
  801b1c:	e8 37 f2 ff ff       	call   800d58 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b21:	89 1c 24             	mov    %ebx,(%esp)
  801b24:	e8 6f f7 ff ff       	call   801298 <fd2data>
  801b29:	83 c4 08             	add    $0x8,%esp
  801b2c:	50                   	push   %eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	e8 24 f2 ff ff       	call   800d58 <sys_page_unmap>
}
  801b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <_pipeisclosed>:
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	57                   	push   %edi
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 1c             	sub    $0x1c,%esp
  801b42:	89 c7                	mov    %eax,%edi
  801b44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b46:	a1 20 54 80 00       	mov    0x805420,%eax
  801b4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	57                   	push   %edi
  801b52:	e8 98 0a 00 00       	call   8025ef <pageref>
  801b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b5a:	89 34 24             	mov    %esi,(%esp)
  801b5d:	e8 8d 0a 00 00       	call   8025ef <pageref>
		nn = thisenv->env_runs;
  801b62:	8b 15 20 54 80 00    	mov    0x805420,%edx
  801b68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	39 cb                	cmp    %ecx,%ebx
  801b70:	74 1b                	je     801b8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b75:	75 cf                	jne    801b46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b77:	8b 42 58             	mov    0x58(%edx),%eax
  801b7a:	6a 01                	push   $0x1
  801b7c:	50                   	push   %eax
  801b7d:	53                   	push   %ebx
  801b7e:	68 46 2f 80 00       	push   $0x802f46
  801b83:	e8 7d e7 ff ff       	call   800305 <cprintf>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	eb b9                	jmp    801b46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b90:	0f 94 c0             	sete   %al
  801b93:	0f b6 c0             	movzbl %al,%eax
}
  801b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <devpipe_write>:
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	57                   	push   %edi
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 28             	sub    $0x28,%esp
  801ba7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801baa:	56                   	push   %esi
  801bab:	e8 e8 f6 ff ff       	call   801298 <fd2data>
  801bb0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bbd:	74 4f                	je     801c0e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bbf:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc2:	8b 0b                	mov    (%ebx),%ecx
  801bc4:	8d 51 20             	lea    0x20(%ecx),%edx
  801bc7:	39 d0                	cmp    %edx,%eax
  801bc9:	72 14                	jb     801bdf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bcb:	89 da                	mov    %ebx,%edx
  801bcd:	89 f0                	mov    %esi,%eax
  801bcf:	e8 65 ff ff ff       	call   801b39 <_pipeisclosed>
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	75 3b                	jne    801c13 <devpipe_write+0x75>
			sys_yield();
  801bd8:	e8 d7 f0 ff ff       	call   800cb4 <sys_yield>
  801bdd:	eb e0                	jmp    801bbf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801be6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801be9:	89 c2                	mov    %eax,%edx
  801beb:	c1 fa 1f             	sar    $0x1f,%edx
  801bee:	89 d1                	mov    %edx,%ecx
  801bf0:	c1 e9 1b             	shr    $0x1b,%ecx
  801bf3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bf6:	83 e2 1f             	and    $0x1f,%edx
  801bf9:	29 ca                	sub    %ecx,%edx
  801bfb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c03:	83 c0 01             	add    $0x1,%eax
  801c06:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c09:	83 c7 01             	add    $0x1,%edi
  801c0c:	eb ac                	jmp    801bba <devpipe_write+0x1c>
	return i;
  801c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c11:	eb 05                	jmp    801c18 <devpipe_write+0x7a>
				return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <devpipe_read>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	57                   	push   %edi
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	83 ec 18             	sub    $0x18,%esp
  801c29:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c2c:	57                   	push   %edi
  801c2d:	e8 66 f6 ff ff       	call   801298 <fd2data>
  801c32:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	be 00 00 00 00       	mov    $0x0,%esi
  801c3c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c3f:	75 14                	jne    801c55 <devpipe_read+0x35>
	return i;
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	eb 02                	jmp    801c48 <devpipe_read+0x28>
				return i;
  801c46:	89 f0                	mov    %esi,%eax
}
  801c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
			sys_yield();
  801c50:	e8 5f f0 ff ff       	call   800cb4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c55:	8b 03                	mov    (%ebx),%eax
  801c57:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c5a:	75 18                	jne    801c74 <devpipe_read+0x54>
			if (i > 0)
  801c5c:	85 f6                	test   %esi,%esi
  801c5e:	75 e6                	jne    801c46 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c60:	89 da                	mov    %ebx,%edx
  801c62:	89 f8                	mov    %edi,%eax
  801c64:	e8 d0 fe ff ff       	call   801b39 <_pipeisclosed>
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	74 e3                	je     801c50 <devpipe_read+0x30>
				return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c72:	eb d4                	jmp    801c48 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c74:	99                   	cltd   
  801c75:	c1 ea 1b             	shr    $0x1b,%edx
  801c78:	01 d0                	add    %edx,%eax
  801c7a:	83 e0 1f             	and    $0x1f,%eax
  801c7d:	29 d0                	sub    %edx,%eax
  801c7f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c87:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c8a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c8d:	83 c6 01             	add    $0x1,%esi
  801c90:	eb aa                	jmp    801c3c <devpipe_read+0x1c>

00801c92 <pipe>:
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	56                   	push   %esi
  801c96:	53                   	push   %ebx
  801c97:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9d:	50                   	push   %eax
  801c9e:	e8 0c f6 ff ff       	call   8012af <fd_alloc>
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 88 23 01 00 00    	js     801dd3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	68 07 04 00 00       	push   $0x407
  801cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 11 f0 ff ff       	call   800cd3 <sys_page_alloc>
  801cc2:	89 c3                	mov    %eax,%ebx
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 88 04 01 00 00    	js     801dd3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd5:	50                   	push   %eax
  801cd6:	e8 d4 f5 ff ff       	call   8012af <fd_alloc>
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	0f 88 db 00 00 00    	js     801dc3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	68 07 04 00 00       	push   $0x407
  801cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf3:	6a 00                	push   $0x0
  801cf5:	e8 d9 ef ff ff       	call   800cd3 <sys_page_alloc>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	85 c0                	test   %eax,%eax
  801d01:	0f 88 bc 00 00 00    	js     801dc3 <pipe+0x131>
	va = fd2data(fd0);
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0d:	e8 86 f5 ff ff       	call   801298 <fd2data>
  801d12:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d14:	83 c4 0c             	add    $0xc,%esp
  801d17:	68 07 04 00 00       	push   $0x407
  801d1c:	50                   	push   %eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 af ef ff ff       	call   800cd3 <sys_page_alloc>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 88 82 00 00 00    	js     801db3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	ff 75 f0             	pushl  -0x10(%ebp)
  801d37:	e8 5c f5 ff ff       	call   801298 <fd2data>
  801d3c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d43:	50                   	push   %eax
  801d44:	6a 00                	push   $0x0
  801d46:	56                   	push   %esi
  801d47:	6a 00                	push   $0x0
  801d49:	e8 c8 ef ff ff       	call   800d16 <sys_page_map>
  801d4e:	89 c3                	mov    %eax,%ebx
  801d50:	83 c4 20             	add    $0x20,%esp
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 4e                	js     801da5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d57:	a1 20 40 80 00       	mov    0x804020,%eax
  801d5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d64:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d80:	e8 03 f5 ff ff       	call   801288 <fd2num>
  801d85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d88:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d8a:	83 c4 04             	add    $0x4,%esp
  801d8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d90:	e8 f3 f4 ff ff       	call   801288 <fd2num>
  801d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d98:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da3:	eb 2e                	jmp    801dd3 <pipe+0x141>
	sys_page_unmap(0, va);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	56                   	push   %esi
  801da9:	6a 00                	push   $0x0
  801dab:	e8 a8 ef ff ff       	call   800d58 <sys_page_unmap>
  801db0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801db3:	83 ec 08             	sub    $0x8,%esp
  801db6:	ff 75 f0             	pushl  -0x10(%ebp)
  801db9:	6a 00                	push   $0x0
  801dbb:	e8 98 ef ff ff       	call   800d58 <sys_page_unmap>
  801dc0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dc3:	83 ec 08             	sub    $0x8,%esp
  801dc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc9:	6a 00                	push   $0x0
  801dcb:	e8 88 ef ff ff       	call   800d58 <sys_page_unmap>
  801dd0:	83 c4 10             	add    $0x10,%esp
}
  801dd3:	89 d8                	mov    %ebx,%eax
  801dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <pipeisclosed>:
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801de2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de5:	50                   	push   %eax
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	e8 13 f5 ff ff       	call   801301 <fd_lookup>
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 18                	js     801e0d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	e8 98 f4 ff ff       	call   801298 <fd2data>
	return _pipeisclosed(fd, p);
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	e8 2f fd ff ff       	call   801b39 <_pipeisclosed>
  801e0a:	83 c4 10             	add    $0x10,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e17:	85 f6                	test   %esi,%esi
  801e19:	74 13                	je     801e2e <wait+0x1f>
	e = &envs[ENVX(envid)];
  801e1b:	89 f3                	mov    %esi,%ebx
  801e1d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e23:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e26:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e2c:	eb 1b                	jmp    801e49 <wait+0x3a>
	assert(envid != 0);
  801e2e:	68 5e 2f 80 00       	push   $0x802f5e
  801e33:	68 0c 2f 80 00       	push   $0x802f0c
  801e38:	6a 09                	push   $0x9
  801e3a:	68 69 2f 80 00       	push   $0x802f69
  801e3f:	e8 e6 e3 ff ff       	call   80022a <_panic>
		sys_yield();
  801e44:	e8 6b ee ff ff       	call   800cb4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e49:	8b 43 48             	mov    0x48(%ebx),%eax
  801e4c:	39 f0                	cmp    %esi,%eax
  801e4e:	75 07                	jne    801e57 <wait+0x48>
  801e50:	8b 43 54             	mov    0x54(%ebx),%eax
  801e53:	85 c0                	test   %eax,%eax
  801e55:	75 ed                	jne    801e44 <wait+0x35>
}
  801e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5e                   	pop    %esi
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    

00801e5e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e64:	68 74 2f 80 00       	push   $0x802f74
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	e8 70 ea ff ff       	call   8008e1 <strcpy>
	return 0;
}
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <devsock_close>:
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 10             	sub    $0x10,%esp
  801e7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e82:	53                   	push   %ebx
  801e83:	e8 67 07 00 00       	call   8025ef <pageref>
  801e88:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e8b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e90:	83 f8 01             	cmp    $0x1,%eax
  801e93:	74 07                	je     801e9c <devsock_close+0x24>
}
  801e95:	89 d0                	mov    %edx,%eax
  801e97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	ff 73 0c             	pushl  0xc(%ebx)
  801ea2:	e8 b9 02 00 00       	call   802160 <nsipc_close>
  801ea7:	89 c2                	mov    %eax,%edx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	eb e7                	jmp    801e95 <devsock_close+0x1d>

00801eae <devsock_write>:
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	ff 75 10             	pushl  0x10(%ebp)
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	ff 70 0c             	pushl  0xc(%eax)
  801ec2:	e8 76 03 00 00       	call   80223d <nsipc_send>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <devsock_read>:
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	ff 75 10             	pushl  0x10(%ebp)
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	ff 70 0c             	pushl  0xc(%eax)
  801edd:	e8 ef 02 00 00       	call   8021d1 <nsipc_recv>
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <fd2sockid>:
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801eea:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	e8 0d f4 ff ff       	call   801301 <fd_lookup>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 10                	js     801f0b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  801f04:	39 08                	cmp    %ecx,(%eax)
  801f06:	75 05                	jne    801f0d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    
		return -E_NOT_SUPP;
  801f0d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f12:	eb f7                	jmp    801f0b <fd2sockid+0x27>

00801f14 <alloc_sockfd>:
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	83 ec 1c             	sub    $0x1c,%esp
  801f1c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f21:	50                   	push   %eax
  801f22:	e8 88 f3 ff ff       	call   8012af <fd_alloc>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 43                	js     801f73 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	68 07 04 00 00       	push   $0x407
  801f38:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3b:	6a 00                	push   $0x0
  801f3d:	e8 91 ed ff ff       	call   800cd3 <sys_page_alloc>
  801f42:	89 c3                	mov    %eax,%ebx
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	85 c0                	test   %eax,%eax
  801f49:	78 28                	js     801f73 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  801f54:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f60:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	50                   	push   %eax
  801f67:	e8 1c f3 ff ff       	call   801288 <fd2num>
  801f6c:	89 c3                	mov    %eax,%ebx
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	eb 0c                	jmp    801f7f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	56                   	push   %esi
  801f77:	e8 e4 01 00 00       	call   802160 <nsipc_close>
		return r;
  801f7c:	83 c4 10             	add    $0x10,%esp
}
  801f7f:	89 d8                	mov    %ebx,%eax
  801f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <accept>:
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	e8 4e ff ff ff       	call   801ee4 <fd2sockid>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 1b                	js     801fb5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	ff 75 10             	pushl  0x10(%ebp)
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	50                   	push   %eax
  801fa4:	e8 0e 01 00 00       	call   8020b7 <nsipc_accept>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 05                	js     801fb5 <accept+0x2d>
	return alloc_sockfd(r);
  801fb0:	e8 5f ff ff ff       	call   801f14 <alloc_sockfd>
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <bind>:
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	e8 1f ff ff ff       	call   801ee4 <fd2sockid>
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 12                	js     801fdb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	ff 75 10             	pushl  0x10(%ebp)
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	50                   	push   %eax
  801fd3:	e8 31 01 00 00       	call   802109 <nsipc_bind>
  801fd8:	83 c4 10             	add    $0x10,%esp
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <shutdown>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	e8 f9 fe ff ff       	call   801ee4 <fd2sockid>
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 0f                	js     801ffe <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	50                   	push   %eax
  801ff6:	e8 43 01 00 00       	call   80213e <nsipc_shutdown>
  801ffb:	83 c4 10             	add    $0x10,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <connect>:
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	e8 d6 fe ff ff       	call   801ee4 <fd2sockid>
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 12                	js     802024 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	50                   	push   %eax
  80201c:	e8 59 01 00 00       	call   80217a <nsipc_connect>
  802021:	83 c4 10             	add    $0x10,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <listen>:
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	e8 b0 fe ff ff       	call   801ee4 <fd2sockid>
  802034:	85 c0                	test   %eax,%eax
  802036:	78 0f                	js     802047 <listen+0x21>
	return nsipc_listen(r, backlog);
  802038:	83 ec 08             	sub    $0x8,%esp
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	50                   	push   %eax
  80203f:	e8 6b 01 00 00       	call   8021af <nsipc_listen>
  802044:	83 c4 10             	add    $0x10,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <socket>:

int
socket(int domain, int type, int protocol)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204f:	ff 75 10             	pushl  0x10(%ebp)
  802052:	ff 75 0c             	pushl  0xc(%ebp)
  802055:	ff 75 08             	pushl  0x8(%ebp)
  802058:	e8 3e 02 00 00       	call   80229b <nsipc_socket>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	78 05                	js     802069 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802064:	e8 ab fe ff ff       	call   801f14 <alloc_sockfd>
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	53                   	push   %ebx
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802074:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80207b:	74 26                	je     8020a3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80207d:	6a 07                	push   $0x7
  80207f:	68 00 70 80 00       	push   $0x807000
  802084:	53                   	push   %ebx
  802085:	ff 35 04 50 80 00    	pushl  0x805004
  80208b:	e8 ba 04 00 00       	call   80254a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802090:	83 c4 0c             	add    $0xc,%esp
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	e8 39 04 00 00       	call   8024d7 <ipc_recv>
}
  80209e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	6a 02                	push   $0x2
  8020a8:	e8 09 05 00 00       	call   8025b6 <ipc_find_env>
  8020ad:	a3 04 50 80 00       	mov    %eax,0x805004
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	eb c6                	jmp    80207d <nsipc+0x12>

008020b7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	56                   	push   %esi
  8020bb:	53                   	push   %ebx
  8020bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020c7:	8b 06                	mov    (%esi),%eax
  8020c9:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d3:	e8 93 ff ff ff       	call   80206b <nsipc>
  8020d8:	89 c3                	mov    %eax,%ebx
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	79 09                	jns    8020e7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020de:	89 d8                	mov    %ebx,%eax
  8020e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020e7:	83 ec 04             	sub    $0x4,%esp
  8020ea:	ff 35 10 70 80 00    	pushl  0x807010
  8020f0:	68 00 70 80 00       	push   $0x807000
  8020f5:	ff 75 0c             	pushl  0xc(%ebp)
  8020f8:	e8 72 e9 ff ff       	call   800a6f <memmove>
		*addrlen = ret->ret_addrlen;
  8020fd:	a1 10 70 80 00       	mov    0x807010,%eax
  802102:	89 06                	mov    %eax,(%esi)
  802104:	83 c4 10             	add    $0x10,%esp
	return r;
  802107:	eb d5                	jmp    8020de <nsipc_accept+0x27>

00802109 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	53                   	push   %ebx
  80210d:	83 ec 08             	sub    $0x8,%esp
  802110:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80211b:	53                   	push   %ebx
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	68 04 70 80 00       	push   $0x807004
  802124:	e8 46 e9 ff ff       	call   800a6f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802129:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80212f:	b8 02 00 00 00       	mov    $0x2,%eax
  802134:	e8 32 ff ff ff       	call   80206b <nsipc>
}
  802139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802154:	b8 03 00 00 00       	mov    $0x3,%eax
  802159:	e8 0d ff ff ff       	call   80206b <nsipc>
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <nsipc_close>:

int
nsipc_close(int s)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80216e:	b8 04 00 00 00       	mov    $0x4,%eax
  802173:	e8 f3 fe ff ff       	call   80206b <nsipc>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80218c:	53                   	push   %ebx
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	68 04 70 80 00       	push   $0x807004
  802195:	e8 d5 e8 ff ff       	call   800a6f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80219a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8021a5:	e8 c1 fe ff ff       	call   80206b <nsipc>
}
  8021aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021c5:	b8 06 00 00 00       	mov    $0x6,%eax
  8021ca:	e8 9c fe ff ff       	call   80206b <nsipc>
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	56                   	push   %esi
  8021d5:	53                   	push   %ebx
  8021d6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021e1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ea:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ef:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f4:	e8 72 fe ff ff       	call   80206b <nsipc>
  8021f9:	89 c3                	mov    %eax,%ebx
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 1f                	js     80221e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021ff:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802204:	7f 21                	jg     802227 <nsipc_recv+0x56>
  802206:	39 c6                	cmp    %eax,%esi
  802208:	7c 1d                	jl     802227 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	50                   	push   %eax
  80220e:	68 00 70 80 00       	push   $0x807000
  802213:	ff 75 0c             	pushl  0xc(%ebp)
  802216:	e8 54 e8 ff ff       	call   800a6f <memmove>
  80221b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80221e:	89 d8                	mov    %ebx,%eax
  802220:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5d                   	pop    %ebp
  802226:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802227:	68 80 2f 80 00       	push   $0x802f80
  80222c:	68 0c 2f 80 00       	push   $0x802f0c
  802231:	6a 62                	push   $0x62
  802233:	68 95 2f 80 00       	push   $0x802f95
  802238:	e8 ed df ff ff       	call   80022a <_panic>

0080223d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	53                   	push   %ebx
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80224f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802255:	7f 2e                	jg     802285 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	53                   	push   %ebx
  80225b:	ff 75 0c             	pushl  0xc(%ebp)
  80225e:	68 0c 70 80 00       	push   $0x80700c
  802263:	e8 07 e8 ff ff       	call   800a6f <memmove>
	nsipcbuf.send.req_size = size;
  802268:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80226e:	8b 45 14             	mov    0x14(%ebp),%eax
  802271:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802276:	b8 08 00 00 00       	mov    $0x8,%eax
  80227b:	e8 eb fd ff ff       	call   80206b <nsipc>
}
  802280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802283:	c9                   	leave  
  802284:	c3                   	ret    
	assert(size < 1600);
  802285:	68 a1 2f 80 00       	push   $0x802fa1
  80228a:	68 0c 2f 80 00       	push   $0x802f0c
  80228f:	6a 6d                	push   $0x6d
  802291:	68 95 2f 80 00       	push   $0x802f95
  802296:	e8 8f df ff ff       	call   80022a <_panic>

0080229b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ac:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022b9:	b8 09 00 00 00       	mov    $0x9,%eax
  8022be:	e8 a8 fd ff ff       	call   80206b <nsipc>
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ca:	c3                   	ret    

008022cb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022d1:	68 ad 2f 80 00       	push   $0x802fad
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	e8 03 e6 ff ff       	call   8008e1 <strcpy>
	return 0;
}
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <devcons_write>:
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	57                   	push   %edi
  8022e9:	56                   	push   %esi
  8022ea:	53                   	push   %ebx
  8022eb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022f1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022ff:	73 31                	jae    802332 <devcons_write+0x4d>
		m = n - tot;
  802301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802304:	29 f3                	sub    %esi,%ebx
  802306:	83 fb 7f             	cmp    $0x7f,%ebx
  802309:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80230e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	53                   	push   %ebx
  802315:	89 f0                	mov    %esi,%eax
  802317:	03 45 0c             	add    0xc(%ebp),%eax
  80231a:	50                   	push   %eax
  80231b:	57                   	push   %edi
  80231c:	e8 4e e7 ff ff       	call   800a6f <memmove>
		sys_cputs(buf, m);
  802321:	83 c4 08             	add    $0x8,%esp
  802324:	53                   	push   %ebx
  802325:	57                   	push   %edi
  802326:	e8 ec e8 ff ff       	call   800c17 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80232b:	01 de                	add    %ebx,%esi
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	eb ca                	jmp    8022fc <devcons_write+0x17>
}
  802332:	89 f0                	mov    %esi,%eax
  802334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <devcons_read>:
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802347:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234b:	74 21                	je     80236e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80234d:	e8 e3 e8 ff ff       	call   800c35 <sys_cgetc>
  802352:	85 c0                	test   %eax,%eax
  802354:	75 07                	jne    80235d <devcons_read+0x21>
		sys_yield();
  802356:	e8 59 e9 ff ff       	call   800cb4 <sys_yield>
  80235b:	eb f0                	jmp    80234d <devcons_read+0x11>
	if (c < 0)
  80235d:	78 0f                	js     80236e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80235f:	83 f8 04             	cmp    $0x4,%eax
  802362:	74 0c                	je     802370 <devcons_read+0x34>
	*(char*)vbuf = c;
  802364:	8b 55 0c             	mov    0xc(%ebp),%edx
  802367:	88 02                	mov    %al,(%edx)
	return 1;
  802369:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    
		return 0;
  802370:	b8 00 00 00 00       	mov    $0x0,%eax
  802375:	eb f7                	jmp    80236e <devcons_read+0x32>

00802377 <cputchar>:
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802383:	6a 01                	push   $0x1
  802385:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802388:	50                   	push   %eax
  802389:	e8 89 e8 ff ff       	call   800c17 <sys_cputs>
}
  80238e:	83 c4 10             	add    $0x10,%esp
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <getchar>:
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802399:	6a 01                	push   $0x1
  80239b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80239e:	50                   	push   %eax
  80239f:	6a 00                	push   $0x0
  8023a1:	e8 cb f1 ff ff       	call   801571 <read>
	if (r < 0)
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	78 06                	js     8023b3 <getchar+0x20>
	if (r < 1)
  8023ad:	74 06                	je     8023b5 <getchar+0x22>
	return c;
  8023af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    
		return -E_EOF;
  8023b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023ba:	eb f7                	jmp    8023b3 <getchar+0x20>

008023bc <iscons>:
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c5:	50                   	push   %eax
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	e8 33 ef ff ff       	call   801301 <fd_lookup>
  8023ce:	83 c4 10             	add    $0x10,%esp
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	78 11                	js     8023e6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8023de:	39 10                	cmp    %edx,(%eax)
  8023e0:	0f 94 c0             	sete   %al
  8023e3:	0f b6 c0             	movzbl %al,%eax
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <opencons>:
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f1:	50                   	push   %eax
  8023f2:	e8 b8 ee ff ff       	call   8012af <fd_alloc>
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	78 3a                	js     802438 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 07 04 00 00       	push   $0x407
  802406:	ff 75 f4             	pushl  -0xc(%ebp)
  802409:	6a 00                	push   $0x0
  80240b:	e8 c3 e8 ff ff       	call   800cd3 <sys_page_alloc>
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	85 c0                	test   %eax,%eax
  802415:	78 21                	js     802438 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802420:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	50                   	push   %eax
  802430:	e8 53 ee ff ff       	call   801288 <fd2num>
  802435:	83 c4 10             	add    $0x10,%esp
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802440:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802447:	74 0a                	je     802453 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802453:	a1 20 54 80 00       	mov    0x805420,%eax
  802458:	8b 40 48             	mov    0x48(%eax),%eax
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	6a 07                	push   $0x7
  802460:	68 00 f0 bf ee       	push   $0xeebff000
  802465:	50                   	push   %eax
  802466:	e8 68 e8 ff ff       	call   800cd3 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80246b:	83 c4 10             	add    $0x10,%esp
  80246e:	85 c0                	test   %eax,%eax
  802470:	78 2c                	js     80249e <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802472:	e8 1e e8 ff ff       	call   800c95 <sys_getenvid>
  802477:	83 ec 08             	sub    $0x8,%esp
  80247a:	68 b0 24 80 00       	push   $0x8024b0
  80247f:	50                   	push   %eax
  802480:	e8 99 e9 ff ff       	call   800e1e <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802485:	83 c4 10             	add    $0x10,%esp
  802488:	85 c0                	test   %eax,%eax
  80248a:	79 bd                	jns    802449 <set_pgfault_handler+0xf>
  80248c:	50                   	push   %eax
  80248d:	68 b9 2f 80 00       	push   $0x802fb9
  802492:	6a 23                	push   $0x23
  802494:	68 d1 2f 80 00       	push   $0x802fd1
  802499:	e8 8c dd ff ff       	call   80022a <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80249e:	50                   	push   %eax
  80249f:	68 b9 2f 80 00       	push   $0x802fb9
  8024a4:	6a 21                	push   $0x21
  8024a6:	68 d1 2f 80 00       	push   $0x802fd1
  8024ab:	e8 7a dd ff ff       	call   80022a <_panic>

008024b0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024b0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024b1:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8024b6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024b8:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8024bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8024bf:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8024c2:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8024c6:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8024ca:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8024cd:	83 c4 08             	add    $0x8,%esp
	popal
  8024d0:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024d1:	83 c4 04             	add    $0x4,%esp
	popfl
  8024d4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024d5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8024d6:	c3                   	ret    

008024d7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	56                   	push   %esi
  8024db:	53                   	push   %ebx
  8024dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8024df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 4f                	je     802538 <ipc_recv+0x61>
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	50                   	push   %eax
  8024ed:	e8 91 e9 ff ff       	call   800e83 <sys_ipc_recv>
  8024f2:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8024f5:	85 f6                	test   %esi,%esi
  8024f7:	74 14                	je     80250d <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8024f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	75 09                	jne    80250b <ipc_recv+0x34>
  802502:	8b 15 20 54 80 00    	mov    0x805420,%edx
  802508:	8b 52 74             	mov    0x74(%edx),%edx
  80250b:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80250d:	85 db                	test   %ebx,%ebx
  80250f:	74 14                	je     802525 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802511:	ba 00 00 00 00       	mov    $0x0,%edx
  802516:	85 c0                	test   %eax,%eax
  802518:	75 09                	jne    802523 <ipc_recv+0x4c>
  80251a:	8b 15 20 54 80 00    	mov    0x805420,%edx
  802520:	8b 52 78             	mov    0x78(%edx),%edx
  802523:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802525:	85 c0                	test   %eax,%eax
  802527:	75 08                	jne    802531 <ipc_recv+0x5a>
  802529:	a1 20 54 80 00       	mov    0x805420,%eax
  80252e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802531:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802534:	5b                   	pop    %ebx
  802535:	5e                   	pop    %esi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	68 00 00 c0 ee       	push   $0xeec00000
  802540:	e8 3e e9 ff ff       	call   800e83 <sys_ipc_recv>
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	eb ab                	jmp    8024f5 <ipc_recv+0x1e>

0080254a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	57                   	push   %edi
  80254e:	56                   	push   %esi
  80254f:	53                   	push   %ebx
  802550:	83 ec 0c             	sub    $0xc,%esp
  802553:	8b 7d 08             	mov    0x8(%ebp),%edi
  802556:	8b 75 10             	mov    0x10(%ebp),%esi
  802559:	eb 20                	jmp    80257b <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80255b:	6a 00                	push   $0x0
  80255d:	68 00 00 c0 ee       	push   $0xeec00000
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	57                   	push   %edi
  802566:	e8 f5 e8 ff ff       	call   800e60 <sys_ipc_try_send>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	eb 1f                	jmp    802591 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802572:	e8 3d e7 ff ff       	call   800cb4 <sys_yield>
	while(retval != 0) {
  802577:	85 db                	test   %ebx,%ebx
  802579:	74 33                	je     8025ae <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80257b:	85 f6                	test   %esi,%esi
  80257d:	74 dc                	je     80255b <ipc_send+0x11>
  80257f:	ff 75 14             	pushl  0x14(%ebp)
  802582:	56                   	push   %esi
  802583:	ff 75 0c             	pushl  0xc(%ebp)
  802586:	57                   	push   %edi
  802587:	e8 d4 e8 ff ff       	call   800e60 <sys_ipc_try_send>
  80258c:	89 c3                	mov    %eax,%ebx
  80258e:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802591:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802594:	74 dc                	je     802572 <ipc_send+0x28>
  802596:	85 db                	test   %ebx,%ebx
  802598:	74 d8                	je     802572 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 e0 2f 80 00       	push   $0x802fe0
  8025a2:	6a 35                	push   $0x35
  8025a4:	68 10 30 80 00       	push   $0x803010
  8025a9:	e8 7c dc ff ff       	call   80022a <_panic>
	}
}
  8025ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025c1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025c4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025ca:	8b 52 50             	mov    0x50(%edx),%edx
  8025cd:	39 ca                	cmp    %ecx,%edx
  8025cf:	74 11                	je     8025e2 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025d1:	83 c0 01             	add    $0x1,%eax
  8025d4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025d9:	75 e6                	jne    8025c1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	eb 0b                	jmp    8025ed <ipc_find_env+0x37>
			return envs[i].env_id;
  8025e2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025ea:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    

008025ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025f5:	89 d0                	mov    %edx,%eax
  8025f7:	c1 e8 16             	shr    $0x16,%eax
  8025fa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802606:	f6 c1 01             	test   $0x1,%cl
  802609:	74 1d                	je     802628 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80260b:	c1 ea 0c             	shr    $0xc,%edx
  80260e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802615:	f6 c2 01             	test   $0x1,%dl
  802618:	74 0e                	je     802628 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80261a:	c1 ea 0c             	shr    $0xc,%edx
  80261d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802624:	ef 
  802625:	0f b7 c0             	movzwl %ax,%eax
}
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__udivdi3>:
  802630:	f3 0f 1e fb          	endbr32 
  802634:	55                   	push   %ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	83 ec 1c             	sub    $0x1c,%esp
  80263b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80263f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802643:	8b 74 24 34          	mov    0x34(%esp),%esi
  802647:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80264b:	85 d2                	test   %edx,%edx
  80264d:	75 49                	jne    802698 <__udivdi3+0x68>
  80264f:	39 f3                	cmp    %esi,%ebx
  802651:	76 15                	jbe    802668 <__udivdi3+0x38>
  802653:	31 ff                	xor    %edi,%edi
  802655:	89 e8                	mov    %ebp,%eax
  802657:	89 f2                	mov    %esi,%edx
  802659:	f7 f3                	div    %ebx
  80265b:	89 fa                	mov    %edi,%edx
  80265d:	83 c4 1c             	add    $0x1c,%esp
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	89 d9                	mov    %ebx,%ecx
  80266a:	85 db                	test   %ebx,%ebx
  80266c:	75 0b                	jne    802679 <__udivdi3+0x49>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f3                	div    %ebx
  802677:	89 c1                	mov    %eax,%ecx
  802679:	31 d2                	xor    %edx,%edx
  80267b:	89 f0                	mov    %esi,%eax
  80267d:	f7 f1                	div    %ecx
  80267f:	89 c6                	mov    %eax,%esi
  802681:	89 e8                	mov    %ebp,%eax
  802683:	89 f7                	mov    %esi,%edi
  802685:	f7 f1                	div    %ecx
  802687:	89 fa                	mov    %edi,%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	39 f2                	cmp    %esi,%edx
  80269a:	77 1c                	ja     8026b8 <__udivdi3+0x88>
  80269c:	0f bd fa             	bsr    %edx,%edi
  80269f:	83 f7 1f             	xor    $0x1f,%edi
  8026a2:	75 2c                	jne    8026d0 <__udivdi3+0xa0>
  8026a4:	39 f2                	cmp    %esi,%edx
  8026a6:	72 06                	jb     8026ae <__udivdi3+0x7e>
  8026a8:	31 c0                	xor    %eax,%eax
  8026aa:	39 eb                	cmp    %ebp,%ebx
  8026ac:	77 ad                	ja     80265b <__udivdi3+0x2b>
  8026ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b3:	eb a6                	jmp    80265b <__udivdi3+0x2b>
  8026b5:	8d 76 00             	lea    0x0(%esi),%esi
  8026b8:	31 ff                	xor    %edi,%edi
  8026ba:	31 c0                	xor    %eax,%eax
  8026bc:	89 fa                	mov    %edi,%edx
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	89 f9                	mov    %edi,%ecx
  8026d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026d7:	29 f8                	sub    %edi,%eax
  8026d9:	d3 e2                	shl    %cl,%edx
  8026db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026df:	89 c1                	mov    %eax,%ecx
  8026e1:	89 da                	mov    %ebx,%edx
  8026e3:	d3 ea                	shr    %cl,%edx
  8026e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e9:	09 d1                	or     %edx,%ecx
  8026eb:	89 f2                	mov    %esi,%edx
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 f9                	mov    %edi,%ecx
  8026f3:	d3 e3                	shl    %cl,%ebx
  8026f5:	89 c1                	mov    %eax,%ecx
  8026f7:	d3 ea                	shr    %cl,%edx
  8026f9:	89 f9                	mov    %edi,%ecx
  8026fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026ff:	89 eb                	mov    %ebp,%ebx
  802701:	d3 e6                	shl    %cl,%esi
  802703:	89 c1                	mov    %eax,%ecx
  802705:	d3 eb                	shr    %cl,%ebx
  802707:	09 de                	or     %ebx,%esi
  802709:	89 f0                	mov    %esi,%eax
  80270b:	f7 74 24 08          	divl   0x8(%esp)
  80270f:	89 d6                	mov    %edx,%esi
  802711:	89 c3                	mov    %eax,%ebx
  802713:	f7 64 24 0c          	mull   0xc(%esp)
  802717:	39 d6                	cmp    %edx,%esi
  802719:	72 15                	jb     802730 <__udivdi3+0x100>
  80271b:	89 f9                	mov    %edi,%ecx
  80271d:	d3 e5                	shl    %cl,%ebp
  80271f:	39 c5                	cmp    %eax,%ebp
  802721:	73 04                	jae    802727 <__udivdi3+0xf7>
  802723:	39 d6                	cmp    %edx,%esi
  802725:	74 09                	je     802730 <__udivdi3+0x100>
  802727:	89 d8                	mov    %ebx,%eax
  802729:	31 ff                	xor    %edi,%edi
  80272b:	e9 2b ff ff ff       	jmp    80265b <__udivdi3+0x2b>
  802730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802733:	31 ff                	xor    %edi,%edi
  802735:	e9 21 ff ff ff       	jmp    80265b <__udivdi3+0x2b>
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	f3 0f 1e fb          	endbr32 
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80274f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802753:	8b 74 24 30          	mov    0x30(%esp),%esi
  802757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80275b:	89 da                	mov    %ebx,%edx
  80275d:	85 c0                	test   %eax,%eax
  80275f:	75 3f                	jne    8027a0 <__umoddi3+0x60>
  802761:	39 df                	cmp    %ebx,%edi
  802763:	76 13                	jbe    802778 <__umoddi3+0x38>
  802765:	89 f0                	mov    %esi,%eax
  802767:	f7 f7                	div    %edi
  802769:	89 d0                	mov    %edx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	89 fd                	mov    %edi,%ebp
  80277a:	85 ff                	test   %edi,%edi
  80277c:	75 0b                	jne    802789 <__umoddi3+0x49>
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	31 d2                	xor    %edx,%edx
  802785:	f7 f7                	div    %edi
  802787:	89 c5                	mov    %eax,%ebp
  802789:	89 d8                	mov    %ebx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	f7 f5                	div    %ebp
  80278f:	89 f0                	mov    %esi,%eax
  802791:	f7 f5                	div    %ebp
  802793:	89 d0                	mov    %edx,%eax
  802795:	eb d4                	jmp    80276b <__umoddi3+0x2b>
  802797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	89 f1                	mov    %esi,%ecx
  8027a2:	39 d8                	cmp    %ebx,%eax
  8027a4:	76 0a                	jbe    8027b0 <__umoddi3+0x70>
  8027a6:	89 f0                	mov    %esi,%eax
  8027a8:	83 c4 1c             	add    $0x1c,%esp
  8027ab:	5b                   	pop    %ebx
  8027ac:	5e                   	pop    %esi
  8027ad:	5f                   	pop    %edi
  8027ae:	5d                   	pop    %ebp
  8027af:	c3                   	ret    
  8027b0:	0f bd e8             	bsr    %eax,%ebp
  8027b3:	83 f5 1f             	xor    $0x1f,%ebp
  8027b6:	75 20                	jne    8027d8 <__umoddi3+0x98>
  8027b8:	39 d8                	cmp    %ebx,%eax
  8027ba:	0f 82 b0 00 00 00    	jb     802870 <__umoddi3+0x130>
  8027c0:	39 f7                	cmp    %esi,%edi
  8027c2:	0f 86 a8 00 00 00    	jbe    802870 <__umoddi3+0x130>
  8027c8:	89 c8                	mov    %ecx,%eax
  8027ca:	83 c4 1c             	add    $0x1c,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5f                   	pop    %edi
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    
  8027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027d8:	89 e9                	mov    %ebp,%ecx
  8027da:	ba 20 00 00 00       	mov    $0x20,%edx
  8027df:	29 ea                	sub    %ebp,%edx
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e7:	89 d1                	mov    %edx,%ecx
  8027e9:	89 f8                	mov    %edi,%eax
  8027eb:	d3 e8                	shr    %cl,%eax
  8027ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027f9:	09 c1                	or     %eax,%ecx
  8027fb:	89 d8                	mov    %ebx,%eax
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 e9                	mov    %ebp,%ecx
  802803:	d3 e7                	shl    %cl,%edi
  802805:	89 d1                	mov    %edx,%ecx
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80280f:	d3 e3                	shl    %cl,%ebx
  802811:	89 c7                	mov    %eax,%edi
  802813:	89 d1                	mov    %edx,%ecx
  802815:	89 f0                	mov    %esi,%eax
  802817:	d3 e8                	shr    %cl,%eax
  802819:	89 e9                	mov    %ebp,%ecx
  80281b:	89 fa                	mov    %edi,%edx
  80281d:	d3 e6                	shl    %cl,%esi
  80281f:	09 d8                	or     %ebx,%eax
  802821:	f7 74 24 08          	divl   0x8(%esp)
  802825:	89 d1                	mov    %edx,%ecx
  802827:	89 f3                	mov    %esi,%ebx
  802829:	f7 64 24 0c          	mull   0xc(%esp)
  80282d:	89 c6                	mov    %eax,%esi
  80282f:	89 d7                	mov    %edx,%edi
  802831:	39 d1                	cmp    %edx,%ecx
  802833:	72 06                	jb     80283b <__umoddi3+0xfb>
  802835:	75 10                	jne    802847 <__umoddi3+0x107>
  802837:	39 c3                	cmp    %eax,%ebx
  802839:	73 0c                	jae    802847 <__umoddi3+0x107>
  80283b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80283f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802843:	89 d7                	mov    %edx,%edi
  802845:	89 c6                	mov    %eax,%esi
  802847:	89 ca                	mov    %ecx,%edx
  802849:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80284e:	29 f3                	sub    %esi,%ebx
  802850:	19 fa                	sbb    %edi,%edx
  802852:	89 d0                	mov    %edx,%eax
  802854:	d3 e0                	shl    %cl,%eax
  802856:	89 e9                	mov    %ebp,%ecx
  802858:	d3 eb                	shr    %cl,%ebx
  80285a:	d3 ea                	shr    %cl,%edx
  80285c:	09 d8                	or     %ebx,%eax
  80285e:	83 c4 1c             	add    $0x1c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	89 da                	mov    %ebx,%edx
  802872:	29 fe                	sub    %edi,%esi
  802874:	19 c2                	sbb    %eax,%edx
  802876:	89 f1                	mov    %esi,%ecx
  802878:	89 c8                	mov    %ecx,%eax
  80287a:	e9 4b ff ff ff       	jmp    8027ca <__umoddi3+0x8a>
