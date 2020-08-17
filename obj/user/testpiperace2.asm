
obj/user/testpiperace2.debug：     文件格式 elf32-i386


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
  80002c:	e8 9f 01 00 00       	call   8001d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 40 28 80 00       	push   $0x802840
  800041:	e8 c5 02 00 00       	call   80030b <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 47 1c 00 00       	call   801c98 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5b                	js     8000b3 <umain+0x80>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 03 10 00 00       	call   801060 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 62                	js     8000c5 <umain+0x92>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	74 72                	je     8000d7 <umain+0xa4>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800065:	89 fb                	mov    %edi,%ebx
  800067:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006d:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800070:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800076:	8b 43 54             	mov    0x54(%ebx),%eax
  800079:	83 f8 02             	cmp    $0x2,%eax
  80007c:	0f 85 d1 00 00 00    	jne    800153 <umain+0x120>
		if (pipeisclosed(p[0]) != 0) {
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 75 e0             	pushl  -0x20(%ebp)
  800088:	e8 55 1d 00 00       	call   801de2 <pipeisclosed>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	74 e2                	je     800076 <umain+0x43>
			cprintf("\nRACE: pipe appears closed\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 b9 28 80 00       	push   $0x8028b9
  80009c:	e8 6a 02 00 00       	call   80030b <cprintf>
			sys_env_destroy(r);
  8000a1:	89 3c 24             	mov    %edi,(%esp)
  8000a4:	e8 b1 0b 00 00       	call   800c5a <sys_env_destroy>
			exit();
  8000a9:	e8 68 01 00 00       	call   800216 <exit>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	eb c3                	jmp    800076 <umain+0x43>
		panic("pipe: %e", r);
  8000b3:	50                   	push   %eax
  8000b4:	68 8e 28 80 00       	push   $0x80288e
  8000b9:	6a 0d                	push   $0xd
  8000bb:	68 97 28 80 00       	push   $0x802897
  8000c0:	e8 6b 01 00 00       	call   800230 <_panic>
		panic("fork: %e", r);
  8000c5:	50                   	push   %eax
  8000c6:	68 ac 28 80 00       	push   $0x8028ac
  8000cb:	6a 0f                	push   $0xf
  8000cd:	68 97 28 80 00       	push   $0x802897
  8000d2:	e8 59 01 00 00       	call   800230 <_panic>
		close(p[1]);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000dd:	e8 57 13 00 00       	call   801439 <close>
  8000e2:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e5:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ec:	eb 42                	jmp    800130 <umain+0xfd>
				cprintf("%d.", i);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	53                   	push   %ebx
  8000f2:	68 b5 28 80 00       	push   $0x8028b5
  8000f7:	e8 0f 02 00 00       	call   80030b <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	6a 0a                	push   $0xa
  800104:	ff 75 e0             	pushl  -0x20(%ebp)
  800107:	e8 7f 13 00 00       	call   80148b <dup>
			sys_yield();
  80010c:	e8 a9 0b 00 00       	call   800cba <sys_yield>
			close(10);
  800111:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800118:	e8 1c 13 00 00       	call   801439 <close>
			sys_yield();
  80011d:	e8 98 0b 00 00       	call   800cba <sys_yield>
		for (i = 0; i < 200; i++) {
  800122:	83 c3 01             	add    $0x1,%ebx
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80012e:	74 19                	je     800149 <umain+0x116>
			if (i % 10 == 0)
  800130:	89 d8                	mov    %ebx,%eax
  800132:	f7 ee                	imul   %esi
  800134:	c1 fa 02             	sar    $0x2,%edx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	c1 f8 1f             	sar    $0x1f,%eax
  80013c:	29 c2                	sub    %eax,%edx
  80013e:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800141:	01 c0                	add    %eax,%eax
  800143:	39 c3                	cmp    %eax,%ebx
  800145:	75 b8                	jne    8000ff <umain+0xcc>
  800147:	eb a5                	jmp    8000ee <umain+0xbb>
		exit();
  800149:	e8 c8 00 00 00       	call   800216 <exit>
  80014e:	e9 12 ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 d5 28 80 00       	push   $0x8028d5
  80015b:	e8 ab 01 00 00       	call   80030b <cprintf>
	if (pipeisclosed(p[0]))
  800160:	83 c4 04             	add    $0x4,%esp
  800163:	ff 75 e0             	pushl  -0x20(%ebp)
  800166:	e8 77 1c 00 00       	call   801de2 <pipeisclosed>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	85 c0                	test   %eax,%eax
  800170:	75 38                	jne    8001aa <umain+0x177>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	ff 75 e0             	pushl  -0x20(%ebp)
  80017c:	e8 86 11 00 00       	call   801307 <fd_lookup>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 36                	js     8001be <umain+0x18b>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 dc             	pushl  -0x24(%ebp)
  80018e:	e8 0b 11 00 00       	call   80129e <fd2data>
	cprintf("race didn't happen\n");
  800193:	c7 04 24 03 29 80 00 	movl   $0x802903,(%esp)
  80019a:	e8 6c 01 00 00       	call   80030b <cprintf>
}
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 64 28 80 00       	push   $0x802864
  8001b2:	6a 40                	push   $0x40
  8001b4:	68 97 28 80 00       	push   $0x802897
  8001b9:	e8 72 00 00 00       	call   800230 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001be:	50                   	push   %eax
  8001bf:	68 eb 28 80 00       	push   $0x8028eb
  8001c4:	6a 42                	push   $0x42
  8001c6:	68 97 28 80 00       	push   $0x802897
  8001cb:	e8 60 00 00 00       	call   800230 <_panic>

008001d0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001db:	e8 bb 0a 00 00       	call   800c9b <sys_getenvid>
  8001e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ed:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 07                	jle    8001fd <libmain+0x2d>
		binaryname = argv[0];
  8001f6:	8b 06                	mov    (%esi),%eax
  8001f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	56                   	push   %esi
  800201:	53                   	push   %ebx
  800202:	e8 2c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800207:	e8 0a 00 00 00       	call   800216 <exit>
}
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800212:	5b                   	pop    %ebx
  800213:	5e                   	pop    %esi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    

00800216 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021c:	e8 45 12 00 00       	call   801466 <close_all>
	sys_env_destroy(0);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	6a 00                	push   $0x0
  800226:	e8 2f 0a 00 00       	call   800c5a <sys_env_destroy>
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	c9                   	leave  
  80022f:	c3                   	ret    

00800230 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800235:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800238:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023e:	e8 58 0a 00 00       	call   800c9b <sys_getenvid>
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 75 0c             	pushl  0xc(%ebp)
  800249:	ff 75 08             	pushl  0x8(%ebp)
  80024c:	56                   	push   %esi
  80024d:	50                   	push   %eax
  80024e:	68 24 29 80 00       	push   $0x802924
  800253:	e8 b3 00 00 00       	call   80030b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	53                   	push   %ebx
  80025c:	ff 75 10             	pushl  0x10(%ebp)
  80025f:	e8 56 00 00 00       	call   8002ba <vcprintf>
	cprintf("\n");
  800264:	c7 04 24 b7 2e 80 00 	movl   $0x802eb7,(%esp)
  80026b:	e8 9b 00 00 00       	call   80030b <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800273:	cc                   	int3   
  800274:	eb fd                	jmp    800273 <_panic+0x43>

00800276 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	53                   	push   %ebx
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800280:	8b 13                	mov    (%ebx),%edx
  800282:	8d 42 01             	lea    0x1(%edx),%eax
  800285:	89 03                	mov    %eax,(%ebx)
  800287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800293:	74 09                	je     80029e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800295:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	68 ff 00 00 00       	push   $0xff
  8002a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a9:	50                   	push   %eax
  8002aa:	e8 6e 09 00 00       	call   800c1d <sys_cputs>
		b->idx = 0;
  8002af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	eb db                	jmp    800295 <putch+0x1f>

008002ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ca:	00 00 00 
	b.cnt = 0;
  8002cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	ff 75 08             	pushl  0x8(%ebp)
  8002dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	68 76 02 80 00       	push   $0x800276
  8002e9:	e8 19 01 00 00       	call   800407 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ee:	83 c4 08             	add    $0x8,%esp
  8002f1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	e8 1a 09 00 00       	call   800c1d <sys_cputs>

	return b.cnt;
}
  800303:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800311:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800314:	50                   	push   %eax
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	e8 9d ff ff ff       	call   8002ba <vcprintf>
	va_end(ap);

	return cnt;
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
  800325:	83 ec 1c             	sub    $0x1c,%esp
  800328:	89 c7                	mov    %eax,%edi
  80032a:	89 d6                	mov    %edx,%esi
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800335:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800338:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800340:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800343:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800346:	3b 45 10             	cmp    0x10(%ebp),%eax
  800349:	89 d0                	mov    %edx,%eax
  80034b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80034e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800351:	73 15                	jae    800368 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800353:	83 eb 01             	sub    $0x1,%ebx
  800356:	85 db                	test   %ebx,%ebx
  800358:	7e 43                	jle    80039d <printnum+0x7e>
			putch(padc, putdat);
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	56                   	push   %esi
  80035e:	ff 75 18             	pushl  0x18(%ebp)
  800361:	ff d7                	call   *%edi
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	eb eb                	jmp    800353 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	ff 75 18             	pushl  0x18(%ebp)
  80036e:	8b 45 14             	mov    0x14(%ebp),%eax
  800371:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800374:	53                   	push   %ebx
  800375:	ff 75 10             	pushl  0x10(%ebp)
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037e:	ff 75 e0             	pushl  -0x20(%ebp)
  800381:	ff 75 dc             	pushl  -0x24(%ebp)
  800384:	ff 75 d8             	pushl  -0x28(%ebp)
  800387:	e8 64 22 00 00       	call   8025f0 <__udivdi3>
  80038c:	83 c4 18             	add    $0x18,%esp
  80038f:	52                   	push   %edx
  800390:	50                   	push   %eax
  800391:	89 f2                	mov    %esi,%edx
  800393:	89 f8                	mov    %edi,%eax
  800395:	e8 85 ff ff ff       	call   80031f <printnum>
  80039a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	56                   	push   %esi
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	e8 4b 23 00 00       	call   802700 <__umoddi3>
  8003b5:	83 c4 14             	add    $0x14,%esp
  8003b8:	0f be 80 47 29 80 00 	movsbl 0x802947(%eax),%eax
  8003bf:	50                   	push   %eax
  8003c0:	ff d7                	call   *%edi
}
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c8:	5b                   	pop    %ebx
  8003c9:	5e                   	pop    %esi
  8003ca:	5f                   	pop    %edi
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d7:	8b 10                	mov    (%eax),%edx
  8003d9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003dc:	73 0a                	jae    8003e8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e1:	89 08                	mov    %ecx,(%eax)
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	88 02                	mov    %al,(%edx)
}
  8003e8:	5d                   	pop    %ebp
  8003e9:	c3                   	ret    

008003ea <printfmt>:
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f3:	50                   	push   %eax
  8003f4:	ff 75 10             	pushl  0x10(%ebp)
  8003f7:	ff 75 0c             	pushl  0xc(%ebp)
  8003fa:	ff 75 08             	pushl  0x8(%ebp)
  8003fd:	e8 05 00 00 00       	call   800407 <vprintfmt>
}
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <vprintfmt>:
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	57                   	push   %edi
  80040b:	56                   	push   %esi
  80040c:	53                   	push   %ebx
  80040d:	83 ec 3c             	sub    $0x3c,%esp
  800410:	8b 75 08             	mov    0x8(%ebp),%esi
  800413:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800416:	8b 7d 10             	mov    0x10(%ebp),%edi
  800419:	eb 0a                	jmp    800425 <vprintfmt+0x1e>
			putch(ch, putdat);
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	50                   	push   %eax
  800420:	ff d6                	call   *%esi
  800422:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800425:	83 c7 01             	add    $0x1,%edi
  800428:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80042c:	83 f8 25             	cmp    $0x25,%eax
  80042f:	74 0c                	je     80043d <vprintfmt+0x36>
			if (ch == '\0')
  800431:	85 c0                	test   %eax,%eax
  800433:	75 e6                	jne    80041b <vprintfmt+0x14>
}
  800435:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800438:	5b                   	pop    %ebx
  800439:	5e                   	pop    %esi
  80043a:	5f                   	pop    %edi
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    
		padc = ' ';
  80043d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800441:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800448:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800456:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8d 47 01             	lea    0x1(%edi),%eax
  80045e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800461:	0f b6 17             	movzbl (%edi),%edx
  800464:	8d 42 dd             	lea    -0x23(%edx),%eax
  800467:	3c 55                	cmp    $0x55,%al
  800469:	0f 87 ba 03 00 00    	ja     800829 <vprintfmt+0x422>
  80046f:	0f b6 c0             	movzbl %al,%eax
  800472:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  800479:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800480:	eb d9                	jmp    80045b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800485:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800489:	eb d0                	jmp    80045b <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	0f b6 d2             	movzbl %dl,%edx
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800499:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a6:	83 f9 09             	cmp    $0x9,%ecx
  8004a9:	77 55                	ja     800500 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ae:	eb e9                	jmp    800499 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8d 40 04             	lea    0x4(%eax),%eax
  8004be:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c8:	79 91                	jns    80045b <vprintfmt+0x54>
				width = precision, precision = -1;
  8004ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d7:	eb 82                	jmp    80045b <vprintfmt+0x54>
  8004d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dc:	85 c0                	test   %eax,%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	0f 49 d0             	cmovns %eax,%edx
  8004e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ec:	e9 6a ff ff ff       	jmp    80045b <vprintfmt+0x54>
  8004f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fb:	e9 5b ff ff ff       	jmp    80045b <vprintfmt+0x54>
  800500:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	eb bc                	jmp    8004c4 <vprintfmt+0xbd>
			lflag++;
  800508:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050e:	e9 48 ff ff ff       	jmp    80045b <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8d 78 04             	lea    0x4(%eax),%edi
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	53                   	push   %ebx
  80051d:	ff 30                	pushl  (%eax)
  80051f:	ff d6                	call   *%esi
			break;
  800521:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800524:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800527:	e9 9c 02 00 00       	jmp    8007c8 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 78 04             	lea    0x4(%eax),%edi
  800532:	8b 00                	mov    (%eax),%eax
  800534:	99                   	cltd   
  800535:	31 d0                	xor    %edx,%eax
  800537:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800539:	83 f8 0f             	cmp    $0xf,%eax
  80053c:	7f 23                	jg     800561 <vprintfmt+0x15a>
  80053e:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800545:	85 d2                	test   %edx,%edx
  800547:	74 18                	je     800561 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800549:	52                   	push   %edx
  80054a:	68 7e 2e 80 00       	push   $0x802e7e
  80054f:	53                   	push   %ebx
  800550:	56                   	push   %esi
  800551:	e8 94 fe ff ff       	call   8003ea <printfmt>
  800556:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800559:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055c:	e9 67 02 00 00       	jmp    8007c8 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800561:	50                   	push   %eax
  800562:	68 5f 29 80 00       	push   $0x80295f
  800567:	53                   	push   %ebx
  800568:	56                   	push   %esi
  800569:	e8 7c fe ff ff       	call   8003ea <printfmt>
  80056e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800571:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800574:	e9 4f 02 00 00       	jmp    8007c8 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	83 c0 04             	add    $0x4,%eax
  80057f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800587:	85 d2                	test   %edx,%edx
  800589:	b8 58 29 80 00       	mov    $0x802958,%eax
  80058e:	0f 45 c2             	cmovne %edx,%eax
  800591:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800594:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800598:	7e 06                	jle    8005a0 <vprintfmt+0x199>
  80059a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80059e:	75 0d                	jne    8005ad <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a3:	89 c7                	mov    %eax,%edi
  8005a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ab:	eb 3f                	jmp    8005ec <vprintfmt+0x1e5>
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b3:	50                   	push   %eax
  8005b4:	e8 0d 03 00 00       	call   8008c6 <strnlen>
  8005b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005bc:	29 c2                	sub    %eax,%edx
  8005be:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	85 ff                	test   %edi,%edi
  8005cf:	7e 58                	jle    800629 <vprintfmt+0x222>
					putch(padc, putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005da:	83 ef 01             	sub    $0x1,%edi
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	eb eb                	jmp    8005cd <vprintfmt+0x1c6>
					putch(ch, putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	52                   	push   %edx
  8005e7:	ff d6                	call   *%esi
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ef:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f1:	83 c7 01             	add    $0x1,%edi
  8005f4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f8:	0f be d0             	movsbl %al,%edx
  8005fb:	85 d2                	test   %edx,%edx
  8005fd:	74 45                	je     800644 <vprintfmt+0x23d>
  8005ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800603:	78 06                	js     80060b <vprintfmt+0x204>
  800605:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800609:	78 35                	js     800640 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80060b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80060f:	74 d1                	je     8005e2 <vprintfmt+0x1db>
  800611:	0f be c0             	movsbl %al,%eax
  800614:	83 e8 20             	sub    $0x20,%eax
  800617:	83 f8 5e             	cmp    $0x5e,%eax
  80061a:	76 c6                	jbe    8005e2 <vprintfmt+0x1db>
					putch('?', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	6a 3f                	push   $0x3f
  800622:	ff d6                	call   *%esi
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	eb c3                	jmp    8005ec <vprintfmt+0x1e5>
  800629:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80062c:	85 d2                	test   %edx,%edx
  80062e:	b8 00 00 00 00       	mov    $0x0,%eax
  800633:	0f 49 c2             	cmovns %edx,%eax
  800636:	29 c2                	sub    %eax,%edx
  800638:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80063b:	e9 60 ff ff ff       	jmp    8005a0 <vprintfmt+0x199>
  800640:	89 cf                	mov    %ecx,%edi
  800642:	eb 02                	jmp    800646 <vprintfmt+0x23f>
  800644:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800646:	85 ff                	test   %edi,%edi
  800648:	7e 10                	jle    80065a <vprintfmt+0x253>
				putch(' ', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 20                	push   $0x20
  800650:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800652:	83 ef 01             	sub    $0x1,%edi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb ec                	jmp    800646 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	e9 63 01 00 00       	jmp    8007c8 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800665:	83 f9 01             	cmp    $0x1,%ecx
  800668:	7f 1b                	jg     800685 <vprintfmt+0x27e>
	else if (lflag)
  80066a:	85 c9                	test   %ecx,%ecx
  80066c:	74 63                	je     8006d1 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800676:	99                   	cltd   
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
  800683:	eb 17                	jmp    80069c <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 50 04             	mov    0x4(%eax),%edx
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 08             	lea    0x8(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	0f 89 ff 00 00 00    	jns    8007ae <vprintfmt+0x3a7>
				putch('-', putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 2d                	push   $0x2d
  8006b5:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bd:	f7 da                	neg    %edx
  8006bf:	83 d1 00             	adc    $0x0,%ecx
  8006c2:	f7 d9                	neg    %ecx
  8006c4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cc:	e9 dd 00 00 00       	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d9:	99                   	cltd   
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e6:	eb b4                	jmp    80069c <vprintfmt+0x295>
	if (lflag >= 2)
  8006e8:	83 f9 01             	cmp    $0x1,%ecx
  8006eb:	7f 1e                	jg     80070b <vprintfmt+0x304>
	else if (lflag)
  8006ed:	85 c9                	test   %ecx,%ecx
  8006ef:	74 32                	je     800723 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 10                	mov    (%eax),%edx
  8006f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800701:	b8 0a 00 00 00       	mov    $0xa,%eax
  800706:	e9 a3 00 00 00       	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 10                	mov    (%eax),%edx
  800710:	8b 48 04             	mov    0x4(%eax),%ecx
  800713:	8d 40 08             	lea    0x8(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800719:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071e:	e9 8b 00 00 00       	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 10                	mov    (%eax),%edx
  800728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800733:	b8 0a 00 00 00       	mov    $0xa,%eax
  800738:	eb 74                	jmp    8007ae <vprintfmt+0x3a7>
	if (lflag >= 2)
  80073a:	83 f9 01             	cmp    $0x1,%ecx
  80073d:	7f 1b                	jg     80075a <vprintfmt+0x353>
	else if (lflag)
  80073f:	85 c9                	test   %ecx,%ecx
  800741:	74 2c                	je     80076f <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 10                	mov    (%eax),%edx
  800748:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800753:	b8 08 00 00 00       	mov    $0x8,%eax
  800758:	eb 54                	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 48 04             	mov    0x4(%eax),%ecx
  800762:	8d 40 08             	lea    0x8(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800768:	b8 08 00 00 00       	mov    $0x8,%eax
  80076d:	eb 3f                	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 10                	mov    (%eax),%edx
  800774:	b9 00 00 00 00       	mov    $0x0,%ecx
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 28                	jmp    8007ae <vprintfmt+0x3a7>
			putch('0', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 30                	push   $0x30
  80078c:	ff d6                	call   *%esi
			putch('x', putdat);
  80078e:	83 c4 08             	add    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 78                	push   $0x78
  800794:	ff d6                	call   *%esi
			num = (unsigned long long)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ae:	83 ec 0c             	sub    $0xc,%esp
  8007b1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b5:	57                   	push   %edi
  8007b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	51                   	push   %ecx
  8007bb:	52                   	push   %edx
  8007bc:	89 da                	mov    %ebx,%edx
  8007be:	89 f0                	mov    %esi,%eax
  8007c0:	e8 5a fb ff ff       	call   80031f <printnum>
			break;
  8007c5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	e9 55 fc ff ff       	jmp    800425 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007d0:	83 f9 01             	cmp    $0x1,%ecx
  8007d3:	7f 1b                	jg     8007f0 <vprintfmt+0x3e9>
	else if (lflag)
  8007d5:	85 c9                	test   %ecx,%ecx
  8007d7:	74 2c                	je     800805 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 10                	mov    (%eax),%edx
  8007de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e3:	8d 40 04             	lea    0x4(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ee:	eb be                	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f8:	8d 40 08             	lea    0x8(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fe:	b8 10 00 00 00       	mov    $0x10,%eax
  800803:	eb a9                	jmp    8007ae <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 10                	mov    (%eax),%edx
  80080a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080f:	8d 40 04             	lea    0x4(%eax),%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800815:	b8 10 00 00 00       	mov    $0x10,%eax
  80081a:	eb 92                	jmp    8007ae <vprintfmt+0x3a7>
			putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	6a 25                	push   $0x25
  800822:	ff d6                	call   *%esi
			break;
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	eb 9f                	jmp    8007c8 <vprintfmt+0x3c1>
			putch('%', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	53                   	push   %ebx
  80082d:	6a 25                	push   $0x25
  80082f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 f8                	mov    %edi,%eax
  800836:	eb 03                	jmp    80083b <vprintfmt+0x434>
  800838:	83 e8 01             	sub    $0x1,%eax
  80083b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083f:	75 f7                	jne    800838 <vprintfmt+0x431>
  800841:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800844:	eb 82                	jmp    8007c8 <vprintfmt+0x3c1>

00800846 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800855:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800859:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800863:	85 c0                	test   %eax,%eax
  800865:	74 26                	je     80088d <vsnprintf+0x47>
  800867:	85 d2                	test   %edx,%edx
  800869:	7e 22                	jle    80088d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086b:	ff 75 14             	pushl  0x14(%ebp)
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	68 cd 03 80 00       	push   $0x8003cd
  80087a:	e8 88 fb ff ff       	call   800407 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb f7                	jmp    80088b <vsnprintf+0x45>

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089d:	50                   	push   %eax
  80089e:	ff 75 10             	pushl  0x10(%ebp)
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 9a ff ff ff       	call   800846 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bd:	74 05                	je     8008c4 <strlen+0x16>
		n++;
  8008bf:	83 c0 01             	add    $0x1,%eax
  8008c2:	eb f5                	jmp    8008b9 <strlen+0xb>
	return n;
}
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 0d                	je     8008e5 <strnlen+0x1f>
  8008d8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008dc:	74 05                	je     8008e3 <strnlen+0x1d>
		n++;
  8008de:	83 c2 01             	add    $0x1,%edx
  8008e1:	eb f1                	jmp    8008d4 <strnlen+0xe>
  8008e3:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008fd:	83 c2 01             	add    $0x1,%edx
  800900:	84 c9                	test   %cl,%cl
  800902:	75 f2                	jne    8008f6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 10             	sub    $0x10,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	53                   	push   %ebx
  800912:	e8 97 ff ff ff       	call   8008ae <strlen>
  800917:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	01 d8                	add    %ebx,%eax
  80091f:	50                   	push   %eax
  800920:	e8 c2 ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  800925:	89 d8                	mov    %ebx,%eax
  800927:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	56                   	push   %esi
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800937:	89 c6                	mov    %eax,%esi
  800939:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	39 f2                	cmp    %esi,%edx
  800940:	74 11                	je     800953 <strncpy+0x27>
		*dst++ = *src;
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	0f b6 19             	movzbl (%ecx),%ebx
  800948:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094b:	80 fb 01             	cmp    $0x1,%bl
  80094e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800951:	eb eb                	jmp    80093e <strncpy+0x12>
	}
	return ret;
}
  800953:	5b                   	pop    %ebx
  800954:	5e                   	pop    %esi
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 75 08             	mov    0x8(%ebp),%esi
  80095f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800962:	8b 55 10             	mov    0x10(%ebp),%edx
  800965:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800967:	85 d2                	test   %edx,%edx
  800969:	74 21                	je     80098c <strlcpy+0x35>
  80096b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800971:	39 c2                	cmp    %eax,%edx
  800973:	74 14                	je     800989 <strlcpy+0x32>
  800975:	0f b6 19             	movzbl (%ecx),%ebx
  800978:	84 db                	test   %bl,%bl
  80097a:	74 0b                	je     800987 <strlcpy+0x30>
			*dst++ = *src++;
  80097c:	83 c1 01             	add    $0x1,%ecx
  80097f:	83 c2 01             	add    $0x1,%edx
  800982:	88 5a ff             	mov    %bl,-0x1(%edx)
  800985:	eb ea                	jmp    800971 <strlcpy+0x1a>
  800987:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800989:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098c:	29 f0                	sub    %esi,%eax
}
  80098e:	5b                   	pop    %ebx
  80098f:	5e                   	pop    %esi
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099b:	0f b6 01             	movzbl (%ecx),%eax
  80099e:	84 c0                	test   %al,%al
  8009a0:	74 0c                	je     8009ae <strcmp+0x1c>
  8009a2:	3a 02                	cmp    (%edx),%al
  8009a4:	75 08                	jne    8009ae <strcmp+0x1c>
		p++, q++;
  8009a6:	83 c1 01             	add    $0x1,%ecx
  8009a9:	83 c2 01             	add    $0x1,%edx
  8009ac:	eb ed                	jmp    80099b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ae:	0f b6 c0             	movzbl %al,%eax
  8009b1:	0f b6 12             	movzbl (%edx),%edx
  8009b4:	29 d0                	sub    %edx,%eax
}
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	53                   	push   %ebx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c2:	89 c3                	mov    %eax,%ebx
  8009c4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c7:	eb 06                	jmp    8009cf <strncmp+0x17>
		n--, p++, q++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009cf:	39 d8                	cmp    %ebx,%eax
  8009d1:	74 16                	je     8009e9 <strncmp+0x31>
  8009d3:	0f b6 08             	movzbl (%eax),%ecx
  8009d6:	84 c9                	test   %cl,%cl
  8009d8:	74 04                	je     8009de <strncmp+0x26>
  8009da:	3a 0a                	cmp    (%edx),%cl
  8009dc:	74 eb                	je     8009c9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009de:	0f b6 00             	movzbl (%eax),%eax
  8009e1:	0f b6 12             	movzbl (%edx),%edx
  8009e4:	29 d0                	sub    %edx,%eax
}
  8009e6:	5b                   	pop    %ebx
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    
		return 0;
  8009e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ee:	eb f6                	jmp    8009e6 <strncmp+0x2e>

008009f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fa:	0f b6 10             	movzbl (%eax),%edx
  8009fd:	84 d2                	test   %dl,%dl
  8009ff:	74 09                	je     800a0a <strchr+0x1a>
		if (*s == c)
  800a01:	38 ca                	cmp    %cl,%dl
  800a03:	74 0a                	je     800a0f <strchr+0x1f>
	for (; *s; s++)
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	eb f0                	jmp    8009fa <strchr+0xa>
			return (char *) s;
	return 0;
  800a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a1e:	38 ca                	cmp    %cl,%dl
  800a20:	74 09                	je     800a2b <strfind+0x1a>
  800a22:	84 d2                	test   %dl,%dl
  800a24:	74 05                	je     800a2b <strfind+0x1a>
	for (; *s; s++)
  800a26:	83 c0 01             	add    $0x1,%eax
  800a29:	eb f0                	jmp    800a1b <strfind+0xa>
			break;
	return (char *) s;
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	57                   	push   %edi
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a39:	85 c9                	test   %ecx,%ecx
  800a3b:	74 31                	je     800a6e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3d:	89 f8                	mov    %edi,%eax
  800a3f:	09 c8                	or     %ecx,%eax
  800a41:	a8 03                	test   $0x3,%al
  800a43:	75 23                	jne    800a68 <memset+0x3b>
		c &= 0xFF;
  800a45:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a49:	89 d3                	mov    %edx,%ebx
  800a4b:	c1 e3 08             	shl    $0x8,%ebx
  800a4e:	89 d0                	mov    %edx,%eax
  800a50:	c1 e0 18             	shl    $0x18,%eax
  800a53:	89 d6                	mov    %edx,%esi
  800a55:	c1 e6 10             	shl    $0x10,%esi
  800a58:	09 f0                	or     %esi,%eax
  800a5a:	09 c2                	or     %eax,%edx
  800a5c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a61:	89 d0                	mov    %edx,%eax
  800a63:	fc                   	cld    
  800a64:	f3 ab                	rep stos %eax,%es:(%edi)
  800a66:	eb 06                	jmp    800a6e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	fc                   	cld    
  800a6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6e:	89 f8                	mov    %edi,%eax
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	57                   	push   %edi
  800a79:	56                   	push   %esi
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a83:	39 c6                	cmp    %eax,%esi
  800a85:	73 32                	jae    800ab9 <memmove+0x44>
  800a87:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8a:	39 c2                	cmp    %eax,%edx
  800a8c:	76 2b                	jbe    800ab9 <memmove+0x44>
		s += n;
		d += n;
  800a8e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	89 fe                	mov    %edi,%esi
  800a93:	09 ce                	or     %ecx,%esi
  800a95:	09 d6                	or     %edx,%esi
  800a97:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9d:	75 0e                	jne    800aad <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9f:	83 ef 04             	sub    $0x4,%edi
  800aa2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa8:	fd                   	std    
  800aa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aab:	eb 09                	jmp    800ab6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aad:	83 ef 01             	sub    $0x1,%edi
  800ab0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab3:	fd                   	std    
  800ab4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab6:	fc                   	cld    
  800ab7:	eb 1a                	jmp    800ad3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab9:	89 c2                	mov    %eax,%edx
  800abb:	09 ca                	or     %ecx,%edx
  800abd:	09 f2                	or     %esi,%edx
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0a                	jne    800ace <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac7:	89 c7                	mov    %eax,%edi
  800ac9:	fc                   	cld    
  800aca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acc:	eb 05                	jmp    800ad3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	fc                   	cld    
  800ad1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad3:	5e                   	pop    %esi
  800ad4:	5f                   	pop    %edi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 8a ff ff ff       	call   800a75 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af8:	89 c6                	mov    %eax,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	39 f0                	cmp    %esi,%eax
  800aff:	74 1c                	je     800b1d <memcmp+0x30>
		if (*s1 != *s2)
  800b01:	0f b6 08             	movzbl (%eax),%ecx
  800b04:	0f b6 1a             	movzbl (%edx),%ebx
  800b07:	38 d9                	cmp    %bl,%cl
  800b09:	75 08                	jne    800b13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	83 c2 01             	add    $0x1,%edx
  800b11:	eb ea                	jmp    800afd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b13:	0f b6 c1             	movzbl %cl,%eax
  800b16:	0f b6 db             	movzbl %bl,%ebx
  800b19:	29 d8                	sub    %ebx,%eax
  800b1b:	eb 05                	jmp    800b22 <memcmp+0x35>
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	39 d0                	cmp    %edx,%eax
  800b36:	73 09                	jae    800b41 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b38:	38 08                	cmp    %cl,(%eax)
  800b3a:	74 05                	je     800b41 <memfind+0x1b>
	for (; s < ends; s++)
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	eb f3                	jmp    800b34 <memfind+0xe>
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 01             	movzbl (%ecx),%eax
  800b57:	3c 20                	cmp    $0x20,%al
  800b59:	74 f6                	je     800b51 <strtol+0xe>
  800b5b:	3c 09                	cmp    $0x9,%al
  800b5d:	74 f2                	je     800b51 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5f:	3c 2b                	cmp    $0x2b,%al
  800b61:	74 2a                	je     800b8d <strtol+0x4a>
	int neg = 0;
  800b63:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b68:	3c 2d                	cmp    $0x2d,%al
  800b6a:	74 2b                	je     800b97 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b72:	75 0f                	jne    800b83 <strtol+0x40>
  800b74:	80 39 30             	cmpb   $0x30,(%ecx)
  800b77:	74 28                	je     800ba1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b80:	0f 44 d8             	cmove  %eax,%ebx
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
  800b88:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8b:	eb 50                	jmp    800bdd <strtol+0x9a>
		s++;
  800b8d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
  800b95:	eb d5                	jmp    800b6c <strtol+0x29>
		s++, neg = 1;
  800b97:	83 c1 01             	add    $0x1,%ecx
  800b9a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9f:	eb cb                	jmp    800b6c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba5:	74 0e                	je     800bb5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	75 d8                	jne    800b83 <strtol+0x40>
		s++, base = 8;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb3:	eb ce                	jmp    800b83 <strtol+0x40>
		s += 2, base = 16;
  800bb5:	83 c1 02             	add    $0x2,%ecx
  800bb8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbd:	eb c4                	jmp    800b83 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bbf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc2:	89 f3                	mov    %esi,%ebx
  800bc4:	80 fb 19             	cmp    $0x19,%bl
  800bc7:	77 29                	ja     800bf2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc9:	0f be d2             	movsbl %dl,%edx
  800bcc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bcf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd2:	7d 30                	jge    800c04 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd4:	83 c1 01             	add    $0x1,%ecx
  800bd7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdd:	0f b6 11             	movzbl (%ecx),%edx
  800be0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be3:	89 f3                	mov    %esi,%ebx
  800be5:	80 fb 09             	cmp    $0x9,%bl
  800be8:	77 d5                	ja     800bbf <strtol+0x7c>
			dig = *s - '0';
  800bea:	0f be d2             	movsbl %dl,%edx
  800bed:	83 ea 30             	sub    $0x30,%edx
  800bf0:	eb dd                	jmp    800bcf <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 19             	cmp    $0x19,%bl
  800bfa:	77 08                	ja     800c04 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfc:	0f be d2             	movsbl %dl,%edx
  800bff:	83 ea 37             	sub    $0x37,%edx
  800c02:	eb cb                	jmp    800bcf <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c08:	74 05                	je     800c0f <strtol+0xcc>
		*endptr = (char *) s;
  800c0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	f7 da                	neg    %edx
  800c13:	85 ff                	test   %edi,%edi
  800c15:	0f 45 c2             	cmovne %edx,%eax
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2e:	89 c3                	mov    %eax,%ebx
  800c30:	89 c7                	mov    %eax,%edi
  800c32:	89 c6                	mov    %eax,%esi
  800c34:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c36:	5b                   	pop    %ebx
  800c37:	5e                   	pop    %esi
  800c38:	5f                   	pop    %edi
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c41:	ba 00 00 00 00       	mov    $0x0,%edx
  800c46:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4b:	89 d1                	mov    %edx,%ecx
  800c4d:	89 d3                	mov    %edx,%ebx
  800c4f:	89 d7                	mov    %edx,%edi
  800c51:	89 d6                	mov    %edx,%esi
  800c53:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c70:	89 cb                	mov    %ecx,%ebx
  800c72:	89 cf                	mov    %ecx,%edi
  800c74:	89 ce                	mov    %ecx,%esi
  800c76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	7f 08                	jg     800c84 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c84:	83 ec 0c             	sub    $0xc,%esp
  800c87:	50                   	push   %eax
  800c88:	6a 03                	push   $0x3
  800c8a:	68 3f 2c 80 00       	push   $0x802c3f
  800c8f:	6a 23                	push   $0x23
  800c91:	68 5c 2c 80 00       	push   $0x802c5c
  800c96:	e8 95 f5 ff ff       	call   800230 <_panic>

00800c9b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cab:	89 d1                	mov    %edx,%ecx
  800cad:	89 d3                	mov    %edx,%ebx
  800caf:	89 d7                	mov    %edx,%edi
  800cb1:	89 d6                	mov    %edx,%esi
  800cb3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_yield>:

void
sys_yield(void)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cca:	89 d1                	mov    %edx,%ecx
  800ccc:	89 d3                	mov    %edx,%ebx
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	89 d6                	mov    %edx,%esi
  800cd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce2:	be 00 00 00 00       	mov    $0x0,%esi
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf5:	89 f7                	mov    %esi,%edi
  800cf7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	7f 08                	jg     800d05 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d05:	83 ec 0c             	sub    $0xc,%esp
  800d08:	50                   	push   %eax
  800d09:	6a 04                	push   $0x4
  800d0b:	68 3f 2c 80 00       	push   $0x802c3f
  800d10:	6a 23                	push   $0x23
  800d12:	68 5c 2c 80 00       	push   $0x802c5c
  800d17:	e8 14 f5 ff ff       	call   800230 <_panic>

00800d1c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d36:	8b 75 18             	mov    0x18(%ebp),%esi
  800d39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	7f 08                	jg     800d47 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	50                   	push   %eax
  800d4b:	6a 05                	push   $0x5
  800d4d:	68 3f 2c 80 00       	push   $0x802c3f
  800d52:	6a 23                	push   $0x23
  800d54:	68 5c 2c 80 00       	push   $0x802c5c
  800d59:	e8 d2 f4 ff ff       	call   800230 <_panic>

00800d5e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	b8 06 00 00 00       	mov    $0x6,%eax
  800d77:	89 df                	mov    %ebx,%edi
  800d79:	89 de                	mov    %ebx,%esi
  800d7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	7f 08                	jg     800d89 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d89:	83 ec 0c             	sub    $0xc,%esp
  800d8c:	50                   	push   %eax
  800d8d:	6a 06                	push   $0x6
  800d8f:	68 3f 2c 80 00       	push   $0x802c3f
  800d94:	6a 23                	push   $0x23
  800d96:	68 5c 2c 80 00       	push   $0x802c5c
  800d9b:	e8 90 f4 ff ff       	call   800230 <_panic>

00800da0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	b8 08 00 00 00       	mov    $0x8,%eax
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	89 de                	mov    %ebx,%esi
  800dbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7f 08                	jg     800dcb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcb:	83 ec 0c             	sub    $0xc,%esp
  800dce:	50                   	push   %eax
  800dcf:	6a 08                	push   $0x8
  800dd1:	68 3f 2c 80 00       	push   $0x802c3f
  800dd6:	6a 23                	push   $0x23
  800dd8:	68 5c 2c 80 00       	push   $0x802c5c
  800ddd:	e8 4e f4 ff ff       	call   800230 <_panic>

00800de2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800deb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	b8 09 00 00 00       	mov    $0x9,%eax
  800dfb:	89 df                	mov    %ebx,%edi
  800dfd:	89 de                	mov    %ebx,%esi
  800dff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	7f 08                	jg     800e0d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	83 ec 0c             	sub    $0xc,%esp
  800e10:	50                   	push   %eax
  800e11:	6a 09                	push   $0x9
  800e13:	68 3f 2c 80 00       	push   $0x802c3f
  800e18:	6a 23                	push   $0x23
  800e1a:	68 5c 2c 80 00       	push   $0x802c5c
  800e1f:	e8 0c f4 ff ff       	call   800230 <_panic>

00800e24 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
  800e2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3d:	89 df                	mov    %ebx,%edi
  800e3f:	89 de                	mov    %ebx,%esi
  800e41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	7f 08                	jg     800e4f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4f:	83 ec 0c             	sub    $0xc,%esp
  800e52:	50                   	push   %eax
  800e53:	6a 0a                	push   $0xa
  800e55:	68 3f 2c 80 00       	push   $0x802c3f
  800e5a:	6a 23                	push   $0x23
  800e5c:	68 5c 2c 80 00       	push   $0x802c5c
  800e61:	e8 ca f3 ff ff       	call   800230 <_panic>

00800e66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e77:	be 00 00 00 00       	mov    $0x0,%esi
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e82:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9f:	89 cb                	mov    %ecx,%ebx
  800ea1:	89 cf                	mov    %ecx,%edi
  800ea3:	89 ce                	mov    %ecx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 0d                	push   $0xd
  800eb9:	68 3f 2c 80 00       	push   $0x802c3f
  800ebe:	6a 23                	push   $0x23
  800ec0:	68 5c 2c 80 00       	push   $0x802c5c
  800ec5:	e8 66 f3 ff ff       	call   800230 <_panic>

00800eca <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eda:	89 d1                	mov    %edx,%ecx
  800edc:	89 d3                	mov    %edx,%ebx
  800ede:	89 d7                	mov    %edx,%edi
  800ee0:	89 d6                	mov    %edx,%esi
  800ee2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	83 ec 0c             	sub    $0xc,%esp
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ef5:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ef7:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800efa:	89 d9                	mov    %ebx,%ecx
  800efc:	c1 e9 16             	shr    $0x16,%ecx
  800eff:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800f06:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f0b:	f6 c1 01             	test   $0x1,%cl
  800f0e:	74 0c                	je     800f1c <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800f10:	89 d9                	mov    %ebx,%ecx
  800f12:	c1 e9 0c             	shr    $0xc,%ecx
  800f15:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800f1c:	f6 c2 02             	test   $0x2,%dl
  800f1f:	0f 84 a3 00 00 00    	je     800fc8 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800f25:	89 da                	mov    %ebx,%edx
  800f27:	c1 ea 0c             	shr    $0xc,%edx
  800f2a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f31:	f6 c6 08             	test   $0x8,%dh
  800f34:	0f 84 b7 00 00 00    	je     800ff1 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800f3a:	e8 5c fd ff ff       	call   800c9b <sys_getenvid>
  800f3f:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	6a 07                	push   $0x7
  800f46:	68 00 f0 7f 00       	push   $0x7ff000
  800f4b:	50                   	push   %eax
  800f4c:	e8 88 fd ff ff       	call   800cd9 <sys_page_alloc>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	0f 88 bc 00 00 00    	js     801018 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800f5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800f62:	83 ec 04             	sub    $0x4,%esp
  800f65:	68 00 10 00 00       	push   $0x1000
  800f6a:	53                   	push   %ebx
  800f6b:	68 00 f0 7f 00       	push   $0x7ff000
  800f70:	e8 00 fb ff ff       	call   800a75 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f75:	83 c4 08             	add    $0x8,%esp
  800f78:	53                   	push   %ebx
  800f79:	56                   	push   %esi
  800f7a:	e8 df fd ff ff       	call   800d5e <sys_page_unmap>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	85 c0                	test   %eax,%eax
  800f84:	0f 88 a0 00 00 00    	js     80102a <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f8a:	83 ec 0c             	sub    $0xc,%esp
  800f8d:	6a 07                	push   $0x7
  800f8f:	53                   	push   %ebx
  800f90:	56                   	push   %esi
  800f91:	68 00 f0 7f 00       	push   $0x7ff000
  800f96:	56                   	push   %esi
  800f97:	e8 80 fd ff ff       	call   800d1c <sys_page_map>
  800f9c:	83 c4 20             	add    $0x20,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	0f 88 95 00 00 00    	js     80103c <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	68 00 f0 7f 00       	push   $0x7ff000
  800faf:	56                   	push   %esi
  800fb0:	e8 a9 fd ff ff       	call   800d5e <sys_page_unmap>
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	0f 88 8e 00 00 00    	js     80104e <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800fc8:	8b 70 28             	mov    0x28(%eax),%esi
  800fcb:	e8 cb fc ff ff       	call   800c9b <sys_getenvid>
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	50                   	push   %eax
  800fd3:	68 6c 2c 80 00       	push   $0x802c6c
  800fd8:	e8 2e f3 ff ff       	call   80030b <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800fdd:	83 c4 0c             	add    $0xc,%esp
  800fe0:	68 90 2c 80 00       	push   $0x802c90
  800fe5:	6a 27                	push   $0x27
  800fe7:	68 64 2d 80 00       	push   $0x802d64
  800fec:	e8 3f f2 ff ff       	call   800230 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800ff1:	8b 78 28             	mov    0x28(%eax),%edi
  800ff4:	e8 a2 fc ff ff       	call   800c9b <sys_getenvid>
  800ff9:	57                   	push   %edi
  800ffa:	53                   	push   %ebx
  800ffb:	50                   	push   %eax
  800ffc:	68 6c 2c 80 00       	push   $0x802c6c
  801001:	e8 05 f3 ff ff       	call   80030b <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801006:	56                   	push   %esi
  801007:	68 c4 2c 80 00       	push   $0x802cc4
  80100c:	6a 2b                	push   $0x2b
  80100e:	68 64 2d 80 00       	push   $0x802d64
  801013:	e8 18 f2 ff ff       	call   800230 <_panic>
      panic("pgfault: page allocation failed %e", r);
  801018:	50                   	push   %eax
  801019:	68 fc 2c 80 00       	push   $0x802cfc
  80101e:	6a 39                	push   $0x39
  801020:	68 64 2d 80 00       	push   $0x802d64
  801025:	e8 06 f2 ff ff       	call   800230 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  80102a:	50                   	push   %eax
  80102b:	68 20 2d 80 00       	push   $0x802d20
  801030:	6a 3e                	push   $0x3e
  801032:	68 64 2d 80 00       	push   $0x802d64
  801037:	e8 f4 f1 ff ff       	call   800230 <_panic>
      panic("pgfault: page map failed (%e)", r);
  80103c:	50                   	push   %eax
  80103d:	68 6f 2d 80 00       	push   $0x802d6f
  801042:	6a 40                	push   $0x40
  801044:	68 64 2d 80 00       	push   $0x802d64
  801049:	e8 e2 f1 ff ff       	call   800230 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  80104e:	50                   	push   %eax
  80104f:	68 20 2d 80 00       	push   $0x802d20
  801054:	6a 42                	push   $0x42
  801056:	68 64 2d 80 00       	push   $0x802d64
  80105b:	e8 d0 f1 ff ff       	call   800230 <_panic>

00801060 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  801069:	68 e9 0e 80 00       	push   $0x800ee9
  80106e:	e8 7e 13 00 00       	call   8023f1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801073:	b8 07 00 00 00       	mov    $0x7,%eax
  801078:	cd 30                	int    $0x30
  80107a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  80107d:	83 c4 10             	add    $0x10,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 2d                	js     8010b1 <fork+0x51>
  801084:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801086:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  80108b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108f:	0f 85 a6 00 00 00    	jne    80113b <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  801095:	e8 01 fc ff ff       	call   800c9b <sys_getenvid>
  80109a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a7:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  8010ac:	e9 79 01 00 00       	jmp    80122a <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8010b1:	50                   	push   %eax
  8010b2:	68 ac 28 80 00       	push   $0x8028ac
  8010b7:	68 aa 00 00 00       	push   $0xaa
  8010bc:	68 64 2d 80 00       	push   $0x802d64
  8010c1:	e8 6a f1 ff ff       	call   800230 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010c6:	83 ec 0c             	sub    $0xc,%esp
  8010c9:	6a 05                	push   $0x5
  8010cb:	53                   	push   %ebx
  8010cc:	57                   	push   %edi
  8010cd:	53                   	push   %ebx
  8010ce:	6a 00                	push   $0x0
  8010d0:	e8 47 fc ff ff       	call   800d1c <sys_page_map>
  8010d5:	83 c4 20             	add    $0x20,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	79 4d                	jns    801129 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010dc:	50                   	push   %eax
  8010dd:	68 8d 2d 80 00       	push   $0x802d8d
  8010e2:	6a 61                	push   $0x61
  8010e4:	68 64 2d 80 00       	push   $0x802d64
  8010e9:	e8 42 f1 ff ff       	call   800230 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	68 05 08 00 00       	push   $0x805
  8010f6:	53                   	push   %ebx
  8010f7:	57                   	push   %edi
  8010f8:	53                   	push   %ebx
  8010f9:	6a 00                	push   $0x0
  8010fb:	e8 1c fc ff ff       	call   800d1c <sys_page_map>
  801100:	83 c4 20             	add    $0x20,%esp
  801103:	85 c0                	test   %eax,%eax
  801105:	0f 88 b7 00 00 00    	js     8011c2 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	68 05 08 00 00       	push   $0x805
  801113:	53                   	push   %ebx
  801114:	6a 00                	push   $0x0
  801116:	53                   	push   %ebx
  801117:	6a 00                	push   $0x0
  801119:	e8 fe fb ff ff       	call   800d1c <sys_page_map>
  80111e:	83 c4 20             	add    $0x20,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	0f 88 ab 00 00 00    	js     8011d4 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801129:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80112f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801135:	0f 84 ab 00 00 00    	je     8011e6 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	c1 e8 16             	shr    $0x16,%eax
  801140:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801147:	a8 01                	test   $0x1,%al
  801149:	74 de                	je     801129 <fork+0xc9>
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	c1 e8 0c             	shr    $0xc,%eax
  801150:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801157:	f6 c2 01             	test   $0x1,%dl
  80115a:	74 cd                	je     801129 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  80115c:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  80115f:	89 c2                	mov    %eax,%edx
  801161:	c1 ea 16             	shr    $0x16,%edx
  801164:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116b:	f6 c2 01             	test   $0x1,%dl
  80116e:	74 b9                	je     801129 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801170:	c1 e8 0c             	shr    $0xc,%eax
  801173:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  80117a:	a8 01                	test   $0x1,%al
  80117c:	74 ab                	je     801129 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  80117e:	a9 02 08 00 00       	test   $0x802,%eax
  801183:	0f 84 3d ff ff ff    	je     8010c6 <fork+0x66>
	else if(pte & PTE_SHARE)
  801189:	f6 c4 04             	test   $0x4,%ah
  80118c:	0f 84 5c ff ff ff    	je     8010ee <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	25 07 0e 00 00       	and    $0xe07,%eax
  80119a:	50                   	push   %eax
  80119b:	53                   	push   %ebx
  80119c:	57                   	push   %edi
  80119d:	53                   	push   %ebx
  80119e:	6a 00                	push   $0x0
  8011a0:	e8 77 fb ff ff       	call   800d1c <sys_page_map>
  8011a5:	83 c4 20             	add    $0x20,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	0f 89 79 ff ff ff    	jns    801129 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8011b0:	50                   	push   %eax
  8011b1:	68 8d 2d 80 00       	push   $0x802d8d
  8011b6:	6a 67                	push   $0x67
  8011b8:	68 64 2d 80 00       	push   $0x802d64
  8011bd:	e8 6e f0 ff ff       	call   800230 <_panic>
			panic("Page Map Failed: %e", error_code);
  8011c2:	50                   	push   %eax
  8011c3:	68 8d 2d 80 00       	push   $0x802d8d
  8011c8:	6a 6d                	push   $0x6d
  8011ca:	68 64 2d 80 00       	push   $0x802d64
  8011cf:	e8 5c f0 ff ff       	call   800230 <_panic>
			panic("Page Map Failed: %e", error_code);
  8011d4:	50                   	push   %eax
  8011d5:	68 8d 2d 80 00       	push   $0x802d8d
  8011da:	6a 70                	push   $0x70
  8011dc:	68 64 2d 80 00       	push   $0x802d64
  8011e1:	e8 4a f0 ff ff       	call   800230 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	6a 07                	push   $0x7
  8011eb:	68 00 f0 bf ee       	push   $0xeebff000
  8011f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f3:	e8 e1 fa ff ff       	call   800cd9 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 36                	js     801235 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	68 67 24 80 00       	push   $0x802467
  801207:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120a:	e8 15 fc ff ff       	call   800e24 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 34                	js     80124a <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	6a 02                	push   $0x2
  80121b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121e:	e8 7d fb ff ff       	call   800da0 <sys_env_set_status>
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	78 35                	js     80125f <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  80122a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801230:	5b                   	pop    %ebx
  801231:	5e                   	pop    %esi
  801232:	5f                   	pop    %edi
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801235:	50                   	push   %eax
  801236:	68 ac 28 80 00       	push   $0x8028ac
  80123b:	68 ba 00 00 00       	push   $0xba
  801240:	68 64 2d 80 00       	push   $0x802d64
  801245:	e8 e6 ef ff ff       	call   800230 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80124a:	50                   	push   %eax
  80124b:	68 40 2d 80 00       	push   $0x802d40
  801250:	68 bf 00 00 00       	push   $0xbf
  801255:	68 64 2d 80 00       	push   $0x802d64
  80125a:	e8 d1 ef ff ff       	call   800230 <_panic>
      panic("sys_env_set_status: %e", r);
  80125f:	50                   	push   %eax
  801260:	68 a1 2d 80 00       	push   $0x802da1
  801265:	68 c3 00 00 00       	push   $0xc3
  80126a:	68 64 2d 80 00       	push   $0x802d64
  80126f:	e8 bc ef ff ff       	call   800230 <_panic>

00801274 <sfork>:

// Challenge!
int
sfork(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80127a:	68 b8 2d 80 00       	push   $0x802db8
  80127f:	68 cc 00 00 00       	push   $0xcc
  801284:	68 64 2d 80 00       	push   $0x802d64
  801289:	e8 a2 ef ff ff       	call   800230 <_panic>

0080128e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	05 00 00 00 30       	add    $0x30000000,%eax
  801299:	c1 e8 0c             	shr    $0xc,%eax
}
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ae:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012bd:	89 c2                	mov    %eax,%edx
  8012bf:	c1 ea 16             	shr    $0x16,%edx
  8012c2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c9:	f6 c2 01             	test   $0x1,%dl
  8012cc:	74 2d                	je     8012fb <fd_alloc+0x46>
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	c1 ea 0c             	shr    $0xc,%edx
  8012d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012da:	f6 c2 01             	test   $0x1,%dl
  8012dd:	74 1c                	je     8012fb <fd_alloc+0x46>
  8012df:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012e4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e9:	75 d2                	jne    8012bd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012f4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f9:	eb 0a                	jmp    801305 <fd_alloc+0x50>
			*fd_store = fd;
  8012fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80130d:	83 f8 1f             	cmp    $0x1f,%eax
  801310:	77 30                	ja     801342 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801312:	c1 e0 0c             	shl    $0xc,%eax
  801315:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80131a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801320:	f6 c2 01             	test   $0x1,%dl
  801323:	74 24                	je     801349 <fd_lookup+0x42>
  801325:	89 c2                	mov    %eax,%edx
  801327:	c1 ea 0c             	shr    $0xc,%edx
  80132a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801331:	f6 c2 01             	test   $0x1,%dl
  801334:	74 1a                	je     801350 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801336:	8b 55 0c             	mov    0xc(%ebp),%edx
  801339:	89 02                	mov    %eax,(%edx)
	return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    
		return -E_INVAL;
  801342:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801347:	eb f7                	jmp    801340 <fd_lookup+0x39>
		return -E_INVAL;
  801349:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134e:	eb f0                	jmp    801340 <fd_lookup+0x39>
  801350:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801355:	eb e9                	jmp    801340 <fd_lookup+0x39>

00801357 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801360:	ba 00 00 00 00       	mov    $0x0,%edx
  801365:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80136a:	39 08                	cmp    %ecx,(%eax)
  80136c:	74 38                	je     8013a6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80136e:	83 c2 01             	add    $0x1,%edx
  801371:	8b 04 95 4c 2e 80 00 	mov    0x802e4c(,%edx,4),%eax
  801378:	85 c0                	test   %eax,%eax
  80137a:	75 ee                	jne    80136a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80137c:	a1 08 40 80 00       	mov    0x804008,%eax
  801381:	8b 40 48             	mov    0x48(%eax),%eax
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	51                   	push   %ecx
  801388:	50                   	push   %eax
  801389:	68 d0 2d 80 00       	push   $0x802dd0
  80138e:	e8 78 ef ff ff       	call   80030b <cprintf>
	*dev = 0;
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    
			*dev = devtab[i];
  8013a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b0:	eb f2                	jmp    8013a4 <dev_lookup+0x4d>

008013b2 <fd_close>:
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	57                   	push   %edi
  8013b6:	56                   	push   %esi
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 24             	sub    $0x24,%esp
  8013bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8013be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ce:	50                   	push   %eax
  8013cf:	e8 33 ff ff ff       	call   801307 <fd_lookup>
  8013d4:	89 c3                	mov    %eax,%ebx
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 05                	js     8013e2 <fd_close+0x30>
	    || fd != fd2)
  8013dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013e0:	74 16                	je     8013f8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8013e2:	89 f8                	mov    %edi,%eax
  8013e4:	84 c0                	test   %al,%al
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ee:	89 d8                	mov    %ebx,%eax
  8013f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f3:	5b                   	pop    %ebx
  8013f4:	5e                   	pop    %esi
  8013f5:	5f                   	pop    %edi
  8013f6:	5d                   	pop    %ebp
  8013f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 36                	pushl  (%esi)
  801401:	e8 51 ff ff ff       	call   801357 <dev_lookup>
  801406:	89 c3                	mov    %eax,%ebx
  801408:	83 c4 10             	add    $0x10,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 1a                	js     801429 <fd_close+0x77>
		if (dev->dev_close)
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801415:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80141a:	85 c0                	test   %eax,%eax
  80141c:	74 0b                	je     801429 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	56                   	push   %esi
  801422:	ff d0                	call   *%eax
  801424:	89 c3                	mov    %eax,%ebx
  801426:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	56                   	push   %esi
  80142d:	6a 00                	push   $0x0
  80142f:	e8 2a f9 ff ff       	call   800d5e <sys_page_unmap>
	return r;
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	eb b5                	jmp    8013ee <fd_close+0x3c>

00801439 <close>:

int
close(int fdnum)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	ff 75 08             	pushl  0x8(%ebp)
  801446:	e8 bc fe ff ff       	call   801307 <fd_lookup>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	79 02                	jns    801454 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    
		return fd_close(fd, 1);
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	6a 01                	push   $0x1
  801459:	ff 75 f4             	pushl  -0xc(%ebp)
  80145c:	e8 51 ff ff ff       	call   8013b2 <fd_close>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	eb ec                	jmp    801452 <close+0x19>

00801466 <close_all>:

void
close_all(void)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80146d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	53                   	push   %ebx
  801476:	e8 be ff ff ff       	call   801439 <close>
	for (i = 0; i < MAXFD; i++)
  80147b:	83 c3 01             	add    $0x1,%ebx
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	83 fb 20             	cmp    $0x20,%ebx
  801484:	75 ec                	jne    801472 <close_all+0xc>
}
  801486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	57                   	push   %edi
  80148f:	56                   	push   %esi
  801490:	53                   	push   %ebx
  801491:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801494:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801497:	50                   	push   %eax
  801498:	ff 75 08             	pushl  0x8(%ebp)
  80149b:	e8 67 fe ff ff       	call   801307 <fd_lookup>
  8014a0:	89 c3                	mov    %eax,%ebx
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	0f 88 81 00 00 00    	js     80152e <dup+0xa3>
		return r;
	close(newfdnum);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 81 ff ff ff       	call   801439 <close>

	newfd = INDEX2FD(newfdnum);
  8014b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014bb:	c1 e6 0c             	shl    $0xc,%esi
  8014be:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014c4:	83 c4 04             	add    $0x4,%esp
  8014c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014ca:	e8 cf fd ff ff       	call   80129e <fd2data>
  8014cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014d1:	89 34 24             	mov    %esi,(%esp)
  8014d4:	e8 c5 fd ff ff       	call   80129e <fd2data>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014de:	89 d8                	mov    %ebx,%eax
  8014e0:	c1 e8 16             	shr    $0x16,%eax
  8014e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ea:	a8 01                	test   $0x1,%al
  8014ec:	74 11                	je     8014ff <dup+0x74>
  8014ee:	89 d8                	mov    %ebx,%eax
  8014f0:	c1 e8 0c             	shr    $0xc,%eax
  8014f3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014fa:	f6 c2 01             	test   $0x1,%dl
  8014fd:	75 39                	jne    801538 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801502:	89 d0                	mov    %edx,%eax
  801504:	c1 e8 0c             	shr    $0xc,%eax
  801507:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	25 07 0e 00 00       	and    $0xe07,%eax
  801516:	50                   	push   %eax
  801517:	56                   	push   %esi
  801518:	6a 00                	push   $0x0
  80151a:	52                   	push   %edx
  80151b:	6a 00                	push   $0x0
  80151d:	e8 fa f7 ff ff       	call   800d1c <sys_page_map>
  801522:	89 c3                	mov    %eax,%ebx
  801524:	83 c4 20             	add    $0x20,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 31                	js     80155c <dup+0xd1>
		goto err;

	return newfdnum;
  80152b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80152e:	89 d8                	mov    %ebx,%eax
  801530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5f                   	pop    %edi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801538:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	25 07 0e 00 00       	and    $0xe07,%eax
  801547:	50                   	push   %eax
  801548:	57                   	push   %edi
  801549:	6a 00                	push   $0x0
  80154b:	53                   	push   %ebx
  80154c:	6a 00                	push   $0x0
  80154e:	e8 c9 f7 ff ff       	call   800d1c <sys_page_map>
  801553:	89 c3                	mov    %eax,%ebx
  801555:	83 c4 20             	add    $0x20,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	79 a3                	jns    8014ff <dup+0x74>
	sys_page_unmap(0, newfd);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	56                   	push   %esi
  801560:	6a 00                	push   $0x0
  801562:	e8 f7 f7 ff ff       	call   800d5e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801567:	83 c4 08             	add    $0x8,%esp
  80156a:	57                   	push   %edi
  80156b:	6a 00                	push   $0x0
  80156d:	e8 ec f7 ff ff       	call   800d5e <sys_page_unmap>
	return r;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	eb b7                	jmp    80152e <dup+0xa3>

00801577 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	53                   	push   %ebx
  80157b:	83 ec 1c             	sub    $0x1c,%esp
  80157e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801581:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801584:	50                   	push   %eax
  801585:	53                   	push   %ebx
  801586:	e8 7c fd ff ff       	call   801307 <fd_lookup>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 3f                	js     8015d1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801592:	83 ec 08             	sub    $0x8,%esp
  801595:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	ff 30                	pushl  (%eax)
  80159e:	e8 b4 fd ff ff       	call   801357 <dev_lookup>
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	78 27                	js     8015d1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ad:	8b 42 08             	mov    0x8(%edx),%eax
  8015b0:	83 e0 03             	and    $0x3,%eax
  8015b3:	83 f8 01             	cmp    $0x1,%eax
  8015b6:	74 1e                	je     8015d6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	8b 40 08             	mov    0x8(%eax),%eax
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	74 35                	je     8015f7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	ff 75 10             	pushl  0x10(%ebp)
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	52                   	push   %edx
  8015cc:	ff d0                	call   *%eax
  8015ce:	83 c4 10             	add    $0x10,%esp
}
  8015d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8015db:	8b 40 48             	mov    0x48(%eax),%eax
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	53                   	push   %ebx
  8015e2:	50                   	push   %eax
  8015e3:	68 11 2e 80 00       	push   $0x802e11
  8015e8:	e8 1e ed ff ff       	call   80030b <cprintf>
		return -E_INVAL;
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f5:	eb da                	jmp    8015d1 <read+0x5a>
		return -E_NOT_SUPP;
  8015f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015fc:	eb d3                	jmp    8015d1 <read+0x5a>

008015fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	57                   	push   %edi
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
  801604:	83 ec 0c             	sub    $0xc,%esp
  801607:	8b 7d 08             	mov    0x8(%ebp),%edi
  80160a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80160d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801612:	39 f3                	cmp    %esi,%ebx
  801614:	73 23                	jae    801639 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	89 f0                	mov    %esi,%eax
  80161b:	29 d8                	sub    %ebx,%eax
  80161d:	50                   	push   %eax
  80161e:	89 d8                	mov    %ebx,%eax
  801620:	03 45 0c             	add    0xc(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	57                   	push   %edi
  801625:	e8 4d ff ff ff       	call   801577 <read>
		if (m < 0)
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 06                	js     801637 <readn+0x39>
			return m;
		if (m == 0)
  801631:	74 06                	je     801639 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801633:	01 c3                	add    %eax,%ebx
  801635:	eb db                	jmp    801612 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801637:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801639:	89 d8                	mov    %ebx,%eax
  80163b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163e:	5b                   	pop    %ebx
  80163f:	5e                   	pop    %esi
  801640:	5f                   	pop    %edi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	53                   	push   %ebx
  801647:	83 ec 1c             	sub    $0x1c,%esp
  80164a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801650:	50                   	push   %eax
  801651:	53                   	push   %ebx
  801652:	e8 b0 fc ff ff       	call   801307 <fd_lookup>
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 3a                	js     801698 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	ff 30                	pushl  (%eax)
  80166a:	e8 e8 fc ff ff       	call   801357 <dev_lookup>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 22                	js     801698 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801679:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80167d:	74 1e                	je     80169d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80167f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801682:	8b 52 0c             	mov    0xc(%edx),%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	74 35                	je     8016be <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	ff 75 10             	pushl  0x10(%ebp)
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	50                   	push   %eax
  801693:	ff d2                	call   *%edx
  801695:	83 c4 10             	add    $0x10,%esp
}
  801698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80169d:	a1 08 40 80 00       	mov    0x804008,%eax
  8016a2:	8b 40 48             	mov    0x48(%eax),%eax
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	53                   	push   %ebx
  8016a9:	50                   	push   %eax
  8016aa:	68 2d 2e 80 00       	push   $0x802e2d
  8016af:	e8 57 ec ff ff       	call   80030b <cprintf>
		return -E_INVAL;
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016bc:	eb da                	jmp    801698 <write+0x55>
		return -E_NOT_SUPP;
  8016be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c3:	eb d3                	jmp    801698 <write+0x55>

008016c5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ce:	50                   	push   %eax
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	e8 30 fc ff ff       	call   801307 <fd_lookup>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 0e                	js     8016ec <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	53                   	push   %ebx
  8016f2:	83 ec 1c             	sub    $0x1c,%esp
  8016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016fb:	50                   	push   %eax
  8016fc:	53                   	push   %ebx
  8016fd:	e8 05 fc ff ff       	call   801307 <fd_lookup>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 37                	js     801740 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170f:	50                   	push   %eax
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801713:	ff 30                	pushl  (%eax)
  801715:	e8 3d fc ff ff       	call   801357 <dev_lookup>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 1f                	js     801740 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801728:	74 1b                	je     801745 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80172a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172d:	8b 52 18             	mov    0x18(%edx),%edx
  801730:	85 d2                	test   %edx,%edx
  801732:	74 32                	je     801766 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	50                   	push   %eax
  80173b:	ff d2                	call   *%edx
  80173d:	83 c4 10             	add    $0x10,%esp
}
  801740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801743:	c9                   	leave  
  801744:	c3                   	ret    
			thisenv->env_id, fdnum);
  801745:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80174a:	8b 40 48             	mov    0x48(%eax),%eax
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	53                   	push   %ebx
  801751:	50                   	push   %eax
  801752:	68 f0 2d 80 00       	push   $0x802df0
  801757:	e8 af eb ff ff       	call   80030b <cprintf>
		return -E_INVAL;
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801764:	eb da                	jmp    801740 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801766:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80176b:	eb d3                	jmp    801740 <ftruncate+0x52>

0080176d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	53                   	push   %ebx
  801771:	83 ec 1c             	sub    $0x1c,%esp
  801774:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801777:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177a:	50                   	push   %eax
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 84 fb ff ff       	call   801307 <fd_lookup>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	78 4b                	js     8017d5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801790:	50                   	push   %eax
  801791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801794:	ff 30                	pushl  (%eax)
  801796:	e8 bc fb ff ff       	call   801357 <dev_lookup>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 33                	js     8017d5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017a9:	74 2f                	je     8017da <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017ab:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ae:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017b5:	00 00 00 
	stat->st_isdir = 0;
  8017b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017bf:	00 00 00 
	stat->st_dev = dev;
  8017c2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	53                   	push   %ebx
  8017cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8017cf:	ff 50 14             	call   *0x14(%eax)
  8017d2:	83 c4 10             	add    $0x10,%esp
}
  8017d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    
		return -E_NOT_SUPP;
  8017da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017df:	eb f4                	jmp    8017d5 <fstat+0x68>

008017e1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	6a 00                	push   $0x0
  8017eb:	ff 75 08             	pushl  0x8(%ebp)
  8017ee:	e8 2f 02 00 00       	call   801a22 <open>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 1b                	js     801817 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	50                   	push   %eax
  801803:	e8 65 ff ff ff       	call   80176d <fstat>
  801808:	89 c6                	mov    %eax,%esi
	close(fd);
  80180a:	89 1c 24             	mov    %ebx,(%esp)
  80180d:	e8 27 fc ff ff       	call   801439 <close>
	return r;
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	89 f3                	mov    %esi,%ebx
}
  801817:	89 d8                	mov    %ebx,%eax
  801819:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	89 c6                	mov    %eax,%esi
  801827:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801829:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801830:	74 27                	je     801859 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801832:	6a 07                	push   $0x7
  801834:	68 00 50 80 00       	push   $0x805000
  801839:	56                   	push   %esi
  80183a:	ff 35 00 40 80 00    	pushl  0x804000
  801840:	e8 bc 0c 00 00       	call   802501 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801845:	83 c4 0c             	add    $0xc,%esp
  801848:	6a 00                	push   $0x0
  80184a:	53                   	push   %ebx
  80184b:	6a 00                	push   $0x0
  80184d:	e8 3c 0c 00 00       	call   80248e <ipc_recv>
}
  801852:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801859:	83 ec 0c             	sub    $0xc,%esp
  80185c:	6a 01                	push   $0x1
  80185e:	e8 0a 0d 00 00       	call   80256d <ipc_find_env>
  801863:	a3 00 40 80 00       	mov    %eax,0x804000
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	eb c5                	jmp    801832 <fsipc+0x12>

0080186d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	8b 40 0c             	mov    0xc(%eax),%eax
  801879:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 02 00 00 00       	mov    $0x2,%eax
  801890:	e8 8b ff ff ff       	call   801820 <fsipc>
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <devfile_flush>:
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8018b2:	e8 69 ff ff ff       	call   801820 <fsipc>
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <devfile_stat>:
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d8:	e8 43 ff ff ff       	call   801820 <fsipc>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 2c                	js     80190d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	68 00 50 80 00       	push   $0x805000
  8018e9:	53                   	push   %ebx
  8018ea:	e8 f8 ef ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ef:	a1 80 50 80 00       	mov    0x805080,%eax
  8018f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018fa:	a1 84 50 80 00       	mov    0x805084,%eax
  8018ff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <devfile_write>:
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	53                   	push   %ebx
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80191c:	85 db                	test   %ebx,%ebx
  80191e:	75 07                	jne    801927 <devfile_write+0x15>
	return n_all;
  801920:	89 d8                	mov    %ebx,%eax
}
  801922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801925:	c9                   	leave  
  801926:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	8b 40 0c             	mov    0xc(%eax),%eax
  80192d:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801932:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	53                   	push   %ebx
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	68 08 50 80 00       	push   $0x805008
  801944:	e8 2c f1 ff ff       	call   800a75 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801949:	ba 00 00 00 00       	mov    $0x0,%edx
  80194e:	b8 04 00 00 00       	mov    $0x4,%eax
  801953:	e8 c8 fe ff ff       	call   801820 <fsipc>
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 c3                	js     801922 <devfile_write+0x10>
	  assert(r <= n_left);
  80195f:	39 d8                	cmp    %ebx,%eax
  801961:	77 0b                	ja     80196e <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801963:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801968:	7f 1d                	jg     801987 <devfile_write+0x75>
    n_all += r;
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	eb b2                	jmp    801920 <devfile_write+0xe>
	  assert(r <= n_left);
  80196e:	68 60 2e 80 00       	push   $0x802e60
  801973:	68 6c 2e 80 00       	push   $0x802e6c
  801978:	68 9f 00 00 00       	push   $0x9f
  80197d:	68 81 2e 80 00       	push   $0x802e81
  801982:	e8 a9 e8 ff ff       	call   800230 <_panic>
	  assert(r <= PGSIZE);
  801987:	68 8c 2e 80 00       	push   $0x802e8c
  80198c:	68 6c 2e 80 00       	push   $0x802e6c
  801991:	68 a0 00 00 00       	push   $0xa0
  801996:	68 81 2e 80 00       	push   $0x802e81
  80199b:	e8 90 e8 ff ff       	call   800230 <_panic>

008019a0 <devfile_read>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ae:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019b3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	b8 03 00 00 00       	mov    $0x3,%eax
  8019c3:	e8 58 fe ff ff       	call   801820 <fsipc>
  8019c8:	89 c3                	mov    %eax,%ebx
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 1f                	js     8019ed <devfile_read+0x4d>
	assert(r <= n);
  8019ce:	39 f0                	cmp    %esi,%eax
  8019d0:	77 24                	ja     8019f6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019d2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d7:	7f 33                	jg     801a0c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	50                   	push   %eax
  8019dd:	68 00 50 80 00       	push   $0x805000
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	e8 8b f0 ff ff       	call   800a75 <memmove>
	return r;
  8019ea:	83 c4 10             	add    $0x10,%esp
}
  8019ed:	89 d8                	mov    %ebx,%eax
  8019ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
	assert(r <= n);
  8019f6:	68 98 2e 80 00       	push   $0x802e98
  8019fb:	68 6c 2e 80 00       	push   $0x802e6c
  801a00:	6a 7c                	push   $0x7c
  801a02:	68 81 2e 80 00       	push   $0x802e81
  801a07:	e8 24 e8 ff ff       	call   800230 <_panic>
	assert(r <= PGSIZE);
  801a0c:	68 8c 2e 80 00       	push   $0x802e8c
  801a11:	68 6c 2e 80 00       	push   $0x802e6c
  801a16:	6a 7d                	push   $0x7d
  801a18:	68 81 2e 80 00       	push   $0x802e81
  801a1d:	e8 0e e8 ff ff       	call   800230 <_panic>

00801a22 <open>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	83 ec 1c             	sub    $0x1c,%esp
  801a2a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a2d:	56                   	push   %esi
  801a2e:	e8 7b ee ff ff       	call   8008ae <strlen>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a3b:	7f 6c                	jg     801aa9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a43:	50                   	push   %eax
  801a44:	e8 6c f8 ff ff       	call   8012b5 <fd_alloc>
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 3c                	js     801a8e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	56                   	push   %esi
  801a56:	68 00 50 80 00       	push   $0x805000
  801a5b:	e8 87 ee ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a63:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	e8 ab fd ff ff       	call   801820 <fsipc>
  801a75:	89 c3                	mov    %eax,%ebx
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 19                	js     801a97 <open+0x75>
	return fd2num(fd);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff 75 f4             	pushl  -0xc(%ebp)
  801a84:	e8 05 f8 ff ff       	call   80128e <fd2num>
  801a89:	89 c3                	mov    %eax,%ebx
  801a8b:	83 c4 10             	add    $0x10,%esp
}
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    
		fd_close(fd, 0);
  801a97:	83 ec 08             	sub    $0x8,%esp
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	e8 0e f9 ff ff       	call   8013b2 <fd_close>
		return r;
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	eb e5                	jmp    801a8e <open+0x6c>
		return -E_BAD_PATH;
  801aa9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aae:	eb de                	jmp    801a8e <open+0x6c>

00801ab0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  801abb:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac0:	e8 5b fd ff ff       	call   801820 <fsipc>
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	e8 c4 f7 ff ff       	call   80129e <fd2data>
  801ada:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801adc:	83 c4 08             	add    $0x8,%esp
  801adf:	68 9f 2e 80 00       	push   $0x802e9f
  801ae4:	53                   	push   %ebx
  801ae5:	e8 fd ed ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aea:	8b 46 04             	mov    0x4(%esi),%eax
  801aed:	2b 06                	sub    (%esi),%eax
  801aef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801af5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801afc:	00 00 00 
	stat->st_dev = &devpipe;
  801aff:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b06:	30 80 00 
	return 0;
}
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	53                   	push   %ebx
  801b19:	83 ec 0c             	sub    $0xc,%esp
  801b1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b1f:	53                   	push   %ebx
  801b20:	6a 00                	push   $0x0
  801b22:	e8 37 f2 ff ff       	call   800d5e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 6f f7 ff ff       	call   80129e <fd2data>
  801b2f:	83 c4 08             	add    $0x8,%esp
  801b32:	50                   	push   %eax
  801b33:	6a 00                	push   $0x0
  801b35:	e8 24 f2 ff ff       	call   800d5e <sys_page_unmap>
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <_pipeisclosed>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	57                   	push   %edi
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 1c             	sub    $0x1c,%esp
  801b48:	89 c7                	mov    %eax,%edi
  801b4a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b4c:	a1 08 40 80 00       	mov    0x804008,%eax
  801b51:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	57                   	push   %edi
  801b58:	e8 49 0a 00 00       	call   8025a6 <pageref>
  801b5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b60:	89 34 24             	mov    %esi,(%esp)
  801b63:	e8 3e 0a 00 00       	call   8025a6 <pageref>
		nn = thisenv->env_runs;
  801b68:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b6e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	39 cb                	cmp    %ecx,%ebx
  801b76:	74 1b                	je     801b93 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b78:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b7b:	75 cf                	jne    801b4c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b7d:	8b 42 58             	mov    0x58(%edx),%eax
  801b80:	6a 01                	push   $0x1
  801b82:	50                   	push   %eax
  801b83:	53                   	push   %ebx
  801b84:	68 a6 2e 80 00       	push   $0x802ea6
  801b89:	e8 7d e7 ff ff       	call   80030b <cprintf>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	eb b9                	jmp    801b4c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b96:	0f 94 c0             	sete   %al
  801b99:	0f b6 c0             	movzbl %al,%eax
}
  801b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <devpipe_write>:
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	57                   	push   %edi
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 28             	sub    $0x28,%esp
  801bad:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bb0:	56                   	push   %esi
  801bb1:	e8 e8 f6 ff ff       	call   80129e <fd2data>
  801bb6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bc3:	74 4f                	je     801c14 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bc5:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc8:	8b 0b                	mov    (%ebx),%ecx
  801bca:	8d 51 20             	lea    0x20(%ecx),%edx
  801bcd:	39 d0                	cmp    %edx,%eax
  801bcf:	72 14                	jb     801be5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bd1:	89 da                	mov    %ebx,%edx
  801bd3:	89 f0                	mov    %esi,%eax
  801bd5:	e8 65 ff ff ff       	call   801b3f <_pipeisclosed>
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	75 3b                	jne    801c19 <devpipe_write+0x75>
			sys_yield();
  801bde:	e8 d7 f0 ff ff       	call   800cba <sys_yield>
  801be3:	eb e0                	jmp    801bc5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bef:	89 c2                	mov    %eax,%edx
  801bf1:	c1 fa 1f             	sar    $0x1f,%edx
  801bf4:	89 d1                	mov    %edx,%ecx
  801bf6:	c1 e9 1b             	shr    $0x1b,%ecx
  801bf9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bfc:	83 e2 1f             	and    $0x1f,%edx
  801bff:	29 ca                	sub    %ecx,%edx
  801c01:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c05:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c09:	83 c0 01             	add    $0x1,%eax
  801c0c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c0f:	83 c7 01             	add    $0x1,%edi
  801c12:	eb ac                	jmp    801bc0 <devpipe_write+0x1c>
	return i;
  801c14:	8b 45 10             	mov    0x10(%ebp),%eax
  801c17:	eb 05                	jmp    801c1e <devpipe_write+0x7a>
				return 0;
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5f                   	pop    %edi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    

00801c26 <devpipe_read>:
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	57                   	push   %edi
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 18             	sub    $0x18,%esp
  801c2f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c32:	57                   	push   %edi
  801c33:	e8 66 f6 ff ff       	call   80129e <fd2data>
  801c38:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	be 00 00 00 00       	mov    $0x0,%esi
  801c42:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c45:	75 14                	jne    801c5b <devpipe_read+0x35>
	return i;
  801c47:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4a:	eb 02                	jmp    801c4e <devpipe_read+0x28>
				return i;
  801c4c:	89 f0                	mov    %esi,%eax
}
  801c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5f                   	pop    %edi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    
			sys_yield();
  801c56:	e8 5f f0 ff ff       	call   800cba <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c5b:	8b 03                	mov    (%ebx),%eax
  801c5d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c60:	75 18                	jne    801c7a <devpipe_read+0x54>
			if (i > 0)
  801c62:	85 f6                	test   %esi,%esi
  801c64:	75 e6                	jne    801c4c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c66:	89 da                	mov    %ebx,%edx
  801c68:	89 f8                	mov    %edi,%eax
  801c6a:	e8 d0 fe ff ff       	call   801b3f <_pipeisclosed>
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	74 e3                	je     801c56 <devpipe_read+0x30>
				return 0;
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
  801c78:	eb d4                	jmp    801c4e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c7a:	99                   	cltd   
  801c7b:	c1 ea 1b             	shr    $0x1b,%edx
  801c7e:	01 d0                	add    %edx,%eax
  801c80:	83 e0 1f             	and    $0x1f,%eax
  801c83:	29 d0                	sub    %edx,%eax
  801c85:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c90:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c93:	83 c6 01             	add    $0x1,%esi
  801c96:	eb aa                	jmp    801c42 <devpipe_read+0x1c>

00801c98 <pipe>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ca0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca3:	50                   	push   %eax
  801ca4:	e8 0c f6 ff ff       	call   8012b5 <fd_alloc>
  801ca9:	89 c3                	mov    %eax,%ebx
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	0f 88 23 01 00 00    	js     801dd9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 07 04 00 00       	push   $0x407
  801cbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc1:	6a 00                	push   $0x0
  801cc3:	e8 11 f0 ff ff       	call   800cd9 <sys_page_alloc>
  801cc8:	89 c3                	mov    %eax,%ebx
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	0f 88 04 01 00 00    	js     801dd9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cdb:	50                   	push   %eax
  801cdc:	e8 d4 f5 ff ff       	call   8012b5 <fd_alloc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	0f 88 db 00 00 00    	js     801dc9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	68 07 04 00 00       	push   $0x407
  801cf6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 d9 ef ff ff       	call   800cd9 <sys_page_alloc>
  801d00:	89 c3                	mov    %eax,%ebx
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	85 c0                	test   %eax,%eax
  801d07:	0f 88 bc 00 00 00    	js     801dc9 <pipe+0x131>
	va = fd2data(fd0);
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	ff 75 f4             	pushl  -0xc(%ebp)
  801d13:	e8 86 f5 ff ff       	call   80129e <fd2data>
  801d18:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1a:	83 c4 0c             	add    $0xc,%esp
  801d1d:	68 07 04 00 00       	push   $0x407
  801d22:	50                   	push   %eax
  801d23:	6a 00                	push   $0x0
  801d25:	e8 af ef ff ff       	call   800cd9 <sys_page_alloc>
  801d2a:	89 c3                	mov    %eax,%ebx
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	0f 88 82 00 00 00    	js     801db9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d37:	83 ec 0c             	sub    $0xc,%esp
  801d3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d3d:	e8 5c f5 ff ff       	call   80129e <fd2data>
  801d42:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d49:	50                   	push   %eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	56                   	push   %esi
  801d4d:	6a 00                	push   $0x0
  801d4f:	e8 c8 ef ff ff       	call   800d1c <sys_page_map>
  801d54:	89 c3                	mov    %eax,%ebx
  801d56:	83 c4 20             	add    $0x20,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 4e                	js     801dab <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d5d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d65:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d74:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d79:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	ff 75 f4             	pushl  -0xc(%ebp)
  801d86:	e8 03 f5 ff ff       	call   80128e <fd2num>
  801d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d90:	83 c4 04             	add    $0x4,%esp
  801d93:	ff 75 f0             	pushl  -0x10(%ebp)
  801d96:	e8 f3 f4 ff ff       	call   80128e <fd2num>
  801d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da9:	eb 2e                	jmp    801dd9 <pipe+0x141>
	sys_page_unmap(0, va);
  801dab:	83 ec 08             	sub    $0x8,%esp
  801dae:	56                   	push   %esi
  801daf:	6a 00                	push   $0x0
  801db1:	e8 a8 ef ff ff       	call   800d5e <sys_page_unmap>
  801db6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	ff 75 f0             	pushl  -0x10(%ebp)
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 98 ef ff ff       	call   800d5e <sys_page_unmap>
  801dc6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcf:	6a 00                	push   $0x0
  801dd1:	e8 88 ef ff ff       	call   800d5e <sys_page_unmap>
  801dd6:	83 c4 10             	add    $0x10,%esp
}
  801dd9:	89 d8                	mov    %ebx,%eax
  801ddb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    

00801de2 <pipeisclosed>:
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801deb:	50                   	push   %eax
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 13 f5 ff ff       	call   801307 <fd_lookup>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	85 c0                	test   %eax,%eax
  801df9:	78 18                	js     801e13 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801e01:	e8 98 f4 ff ff       	call   80129e <fd2data>
	return _pipeisclosed(fd, p);
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	e8 2f fd ff ff       	call   801b3f <_pipeisclosed>
  801e10:	83 c4 10             	add    $0x10,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e1b:	68 be 2e 80 00       	push   $0x802ebe
  801e20:	ff 75 0c             	pushl  0xc(%ebp)
  801e23:	e8 bf ea ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <devsock_close>:
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	53                   	push   %ebx
  801e33:	83 ec 10             	sub    $0x10,%esp
  801e36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e39:	53                   	push   %ebx
  801e3a:	e8 67 07 00 00       	call   8025a6 <pageref>
  801e3f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e47:	83 f8 01             	cmp    $0x1,%eax
  801e4a:	74 07                	je     801e53 <devsock_close+0x24>
}
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	ff 73 0c             	pushl  0xc(%ebx)
  801e59:	e8 b9 02 00 00       	call   802117 <nsipc_close>
  801e5e:	89 c2                	mov    %eax,%edx
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	eb e7                	jmp    801e4c <devsock_close+0x1d>

00801e65 <devsock_write>:
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 10             	pushl  0x10(%ebp)
  801e70:	ff 75 0c             	pushl  0xc(%ebp)
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	ff 70 0c             	pushl  0xc(%eax)
  801e79:	e8 76 03 00 00       	call   8021f4 <nsipc_send>
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <devsock_read>:
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	ff 75 10             	pushl  0x10(%ebp)
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	ff 70 0c             	pushl  0xc(%eax)
  801e94:	e8 ef 02 00 00       	call   802188 <nsipc_recv>
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <fd2sockid>:
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ea1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ea4:	52                   	push   %edx
  801ea5:	50                   	push   %eax
  801ea6:	e8 5c f4 ff ff       	call   801307 <fd_lookup>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 10                	js     801ec2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801ebb:	39 08                	cmp    %ecx,(%eax)
  801ebd:	75 05                	jne    801ec4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ebf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    
		return -E_NOT_SUPP;
  801ec4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ec9:	eb f7                	jmp    801ec2 <fd2sockid+0x27>

00801ecb <alloc_sockfd>:
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 1c             	sub    $0x1c,%esp
  801ed3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed8:	50                   	push   %eax
  801ed9:	e8 d7 f3 ff ff       	call   8012b5 <fd_alloc>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 43                	js     801f2a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	68 07 04 00 00       	push   $0x407
  801eef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef2:	6a 00                	push   $0x0
  801ef4:	e8 e0 ed ff ff       	call   800cd9 <sys_page_alloc>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 28                	js     801f2a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f0b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f17:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	50                   	push   %eax
  801f1e:	e8 6b f3 ff ff       	call   80128e <fd2num>
  801f23:	89 c3                	mov    %eax,%ebx
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	eb 0c                	jmp    801f36 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	56                   	push   %esi
  801f2e:	e8 e4 01 00 00       	call   802117 <nsipc_close>
		return r;
  801f33:	83 c4 10             	add    $0x10,%esp
}
  801f36:	89 d8                	mov    %ebx,%eax
  801f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <accept>:
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	e8 4e ff ff ff       	call   801e9b <fd2sockid>
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 1b                	js     801f6c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	ff 75 10             	pushl  0x10(%ebp)
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	e8 0e 01 00 00       	call   80206e <nsipc_accept>
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	85 c0                	test   %eax,%eax
  801f65:	78 05                	js     801f6c <accept+0x2d>
	return alloc_sockfd(r);
  801f67:	e8 5f ff ff ff       	call   801ecb <alloc_sockfd>
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <bind>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	e8 1f ff ff ff       	call   801e9b <fd2sockid>
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	78 12                	js     801f92 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	ff 75 10             	pushl  0x10(%ebp)
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	e8 31 01 00 00       	call   8020c0 <nsipc_bind>
  801f8f:	83 c4 10             	add    $0x10,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <shutdown>:
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	e8 f9 fe ff ff       	call   801e9b <fd2sockid>
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 0f                	js     801fb5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	50                   	push   %eax
  801fad:	e8 43 01 00 00       	call   8020f5 <nsipc_shutdown>
  801fb2:	83 c4 10             	add    $0x10,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <connect>:
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	e8 d6 fe ff ff       	call   801e9b <fd2sockid>
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 12                	js     801fdb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	ff 75 10             	pushl  0x10(%ebp)
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	50                   	push   %eax
  801fd3:	e8 59 01 00 00       	call   802131 <nsipc_connect>
  801fd8:	83 c4 10             	add    $0x10,%esp
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <listen>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	e8 b0 fe ff ff       	call   801e9b <fd2sockid>
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 0f                	js     801ffe <listen+0x21>
	return nsipc_listen(r, backlog);
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	50                   	push   %eax
  801ff6:	e8 6b 01 00 00       	call   802166 <nsipc_listen>
  801ffb:	83 c4 10             	add    $0x10,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <socket>:

int
socket(int domain, int type, int protocol)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802006:	ff 75 10             	pushl  0x10(%ebp)
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	e8 3e 02 00 00       	call   802252 <nsipc_socket>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 05                	js     802020 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80201b:	e8 ab fe ff ff       	call   801ecb <alloc_sockfd>
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	53                   	push   %ebx
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80202b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802032:	74 26                	je     80205a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802034:	6a 07                	push   $0x7
  802036:	68 00 60 80 00       	push   $0x806000
  80203b:	53                   	push   %ebx
  80203c:	ff 35 04 40 80 00    	pushl  0x804004
  802042:	e8 ba 04 00 00       	call   802501 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802047:	83 c4 0c             	add    $0xc,%esp
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	e8 39 04 00 00       	call   80248e <ipc_recv>
}
  802055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802058:	c9                   	leave  
  802059:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80205a:	83 ec 0c             	sub    $0xc,%esp
  80205d:	6a 02                	push   $0x2
  80205f:	e8 09 05 00 00       	call   80256d <ipc_find_env>
  802064:	a3 04 40 80 00       	mov    %eax,0x804004
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	eb c6                	jmp    802034 <nsipc+0x12>

0080206e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	56                   	push   %esi
  802072:	53                   	push   %ebx
  802073:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80207e:	8b 06                	mov    (%esi),%eax
  802080:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802085:	b8 01 00 00 00       	mov    $0x1,%eax
  80208a:	e8 93 ff ff ff       	call   802022 <nsipc>
  80208f:	89 c3                	mov    %eax,%ebx
  802091:	85 c0                	test   %eax,%eax
  802093:	79 09                	jns    80209e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802095:	89 d8                	mov    %ebx,%eax
  802097:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	ff 35 10 60 80 00    	pushl  0x806010
  8020a7:	68 00 60 80 00       	push   $0x806000
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	e8 c1 e9 ff ff       	call   800a75 <memmove>
		*addrlen = ret->ret_addrlen;
  8020b4:	a1 10 60 80 00       	mov    0x806010,%eax
  8020b9:	89 06                	mov    %eax,(%esi)
  8020bb:	83 c4 10             	add    $0x10,%esp
	return r;
  8020be:	eb d5                	jmp    802095 <nsipc_accept+0x27>

008020c0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 08             	sub    $0x8,%esp
  8020c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020d2:	53                   	push   %ebx
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	68 04 60 80 00       	push   $0x806004
  8020db:	e8 95 e9 ff ff       	call   800a75 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020e0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8020e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8020eb:	e8 32 ff ff ff       	call   802022 <nsipc>
}
  8020f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802103:	8b 45 0c             	mov    0xc(%ebp),%eax
  802106:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80210b:	b8 03 00 00 00       	mov    $0x3,%eax
  802110:	e8 0d ff ff ff       	call   802022 <nsipc>
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <nsipc_close>:

int
nsipc_close(int s)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802125:	b8 04 00 00 00       	mov    $0x4,%eax
  80212a:	e8 f3 fe ff ff       	call   802022 <nsipc>
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	53                   	push   %ebx
  802135:	83 ec 08             	sub    $0x8,%esp
  802138:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802143:	53                   	push   %ebx
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	68 04 60 80 00       	push   $0x806004
  80214c:	e8 24 e9 ff ff       	call   800a75 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802151:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802157:	b8 05 00 00 00       	mov    $0x5,%eax
  80215c:	e8 c1 fe ff ff       	call   802022 <nsipc>
}
  802161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80217c:	b8 06 00 00 00       	mov    $0x6,%eax
  802181:	e8 9c fe ff ff       	call   802022 <nsipc>
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	56                   	push   %esi
  80218c:	53                   	push   %ebx
  80218d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802198:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80219e:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021a6:	b8 07 00 00 00       	mov    $0x7,%eax
  8021ab:	e8 72 fe ff ff       	call   802022 <nsipc>
  8021b0:	89 c3                	mov    %eax,%ebx
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 1f                	js     8021d5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021b6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021bb:	7f 21                	jg     8021de <nsipc_recv+0x56>
  8021bd:	39 c6                	cmp    %eax,%esi
  8021bf:	7c 1d                	jl     8021de <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	50                   	push   %eax
  8021c5:	68 00 60 80 00       	push   $0x806000
  8021ca:	ff 75 0c             	pushl  0xc(%ebp)
  8021cd:	e8 a3 e8 ff ff       	call   800a75 <memmove>
  8021d2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021d5:	89 d8                	mov    %ebx,%eax
  8021d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021da:	5b                   	pop    %ebx
  8021db:	5e                   	pop    %esi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021de:	68 ca 2e 80 00       	push   $0x802eca
  8021e3:	68 6c 2e 80 00       	push   $0x802e6c
  8021e8:	6a 62                	push   $0x62
  8021ea:	68 df 2e 80 00       	push   $0x802edf
  8021ef:	e8 3c e0 ff ff       	call   800230 <_panic>

008021f4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802206:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80220c:	7f 2e                	jg     80223c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	53                   	push   %ebx
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	68 0c 60 80 00       	push   $0x80600c
  80221a:	e8 56 e8 ff ff       	call   800a75 <memmove>
	nsipcbuf.send.req_size = size;
  80221f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802225:	8b 45 14             	mov    0x14(%ebp),%eax
  802228:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80222d:	b8 08 00 00 00       	mov    $0x8,%eax
  802232:	e8 eb fd ff ff       	call   802022 <nsipc>
}
  802237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    
	assert(size < 1600);
  80223c:	68 eb 2e 80 00       	push   $0x802eeb
  802241:	68 6c 2e 80 00       	push   $0x802e6c
  802246:	6a 6d                	push   $0x6d
  802248:	68 df 2e 80 00       	push   $0x802edf
  80224d:	e8 de df ff ff       	call   800230 <_panic>

00802252 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802260:	8b 45 0c             	mov    0xc(%ebp),%eax
  802263:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802268:	8b 45 10             	mov    0x10(%ebp),%eax
  80226b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802270:	b8 09 00 00 00       	mov    $0x9,%eax
  802275:	e8 a8 fd ff ff       	call   802022 <nsipc>
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	c3                   	ret    

00802282 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802288:	68 f7 2e 80 00       	push   $0x802ef7
  80228d:	ff 75 0c             	pushl  0xc(%ebp)
  802290:	e8 52 e6 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  802295:	b8 00 00 00 00       	mov    $0x0,%eax
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <devcons_write>:
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	57                   	push   %edi
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022a8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022ad:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b6:	73 31                	jae    8022e9 <devcons_write+0x4d>
		m = n - tot;
  8022b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022bb:	29 f3                	sub    %esi,%ebx
  8022bd:	83 fb 7f             	cmp    $0x7f,%ebx
  8022c0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022c5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	53                   	push   %ebx
  8022cc:	89 f0                	mov    %esi,%eax
  8022ce:	03 45 0c             	add    0xc(%ebp),%eax
  8022d1:	50                   	push   %eax
  8022d2:	57                   	push   %edi
  8022d3:	e8 9d e7 ff ff       	call   800a75 <memmove>
		sys_cputs(buf, m);
  8022d8:	83 c4 08             	add    $0x8,%esp
  8022db:	53                   	push   %ebx
  8022dc:	57                   	push   %edi
  8022dd:	e8 3b e9 ff ff       	call   800c1d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022e2:	01 de                	add    %ebx,%esi
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	eb ca                	jmp    8022b3 <devcons_write+0x17>
}
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5f                   	pop    %edi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    

008022f3 <devcons_read>:
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 08             	sub    $0x8,%esp
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802302:	74 21                	je     802325 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802304:	e8 32 e9 ff ff       	call   800c3b <sys_cgetc>
  802309:	85 c0                	test   %eax,%eax
  80230b:	75 07                	jne    802314 <devcons_read+0x21>
		sys_yield();
  80230d:	e8 a8 e9 ff ff       	call   800cba <sys_yield>
  802312:	eb f0                	jmp    802304 <devcons_read+0x11>
	if (c < 0)
  802314:	78 0f                	js     802325 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802316:	83 f8 04             	cmp    $0x4,%eax
  802319:	74 0c                	je     802327 <devcons_read+0x34>
	*(char*)vbuf = c;
  80231b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231e:	88 02                	mov    %al,(%edx)
	return 1;
  802320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    
		return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	eb f7                	jmp    802325 <devcons_read+0x32>

0080232e <cputchar>:
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80233a:	6a 01                	push   $0x1
  80233c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80233f:	50                   	push   %eax
  802340:	e8 d8 e8 ff ff       	call   800c1d <sys_cputs>
}
  802345:	83 c4 10             	add    $0x10,%esp
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <getchar>:
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802350:	6a 01                	push   $0x1
  802352:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802355:	50                   	push   %eax
  802356:	6a 00                	push   $0x0
  802358:	e8 1a f2 ff ff       	call   801577 <read>
	if (r < 0)
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	85 c0                	test   %eax,%eax
  802362:	78 06                	js     80236a <getchar+0x20>
	if (r < 1)
  802364:	74 06                	je     80236c <getchar+0x22>
	return c;
  802366:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    
		return -E_EOF;
  80236c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802371:	eb f7                	jmp    80236a <getchar+0x20>

00802373 <iscons>:
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237c:	50                   	push   %eax
  80237d:	ff 75 08             	pushl  0x8(%ebp)
  802380:	e8 82 ef ff ff       	call   801307 <fd_lookup>
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	85 c0                	test   %eax,%eax
  80238a:	78 11                	js     80239d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802395:	39 10                	cmp    %edx,(%eax)
  802397:	0f 94 c0             	sete   %al
  80239a:	0f b6 c0             	movzbl %al,%eax
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <opencons>:
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a8:	50                   	push   %eax
  8023a9:	e8 07 ef ff ff       	call   8012b5 <fd_alloc>
  8023ae:	83 c4 10             	add    $0x10,%esp
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	78 3a                	js     8023ef <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	68 07 04 00 00       	push   $0x407
  8023bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c0:	6a 00                	push   $0x0
  8023c2:	e8 12 e9 ff ff       	call   800cd9 <sys_page_alloc>
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	78 21                	js     8023ef <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023d7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023e3:	83 ec 0c             	sub    $0xc,%esp
  8023e6:	50                   	push   %eax
  8023e7:	e8 a2 ee ff ff       	call   80128e <fd2num>
  8023ec:	83 c4 10             	add    $0x10,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8023f7:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8023fe:	74 0a                	je     80240a <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80240a:	a1 08 40 80 00       	mov    0x804008,%eax
  80240f:	8b 40 48             	mov    0x48(%eax),%eax
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	6a 07                	push   $0x7
  802417:	68 00 f0 bf ee       	push   $0xeebff000
  80241c:	50                   	push   %eax
  80241d:	e8 b7 e8 ff ff       	call   800cd9 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	85 c0                	test   %eax,%eax
  802427:	78 2c                	js     802455 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802429:	e8 6d e8 ff ff       	call   800c9b <sys_getenvid>
  80242e:	83 ec 08             	sub    $0x8,%esp
  802431:	68 67 24 80 00       	push   $0x802467
  802436:	50                   	push   %eax
  802437:	e8 e8 e9 ff ff       	call   800e24 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	79 bd                	jns    802400 <set_pgfault_handler+0xf>
  802443:	50                   	push   %eax
  802444:	68 03 2f 80 00       	push   $0x802f03
  802449:	6a 23                	push   $0x23
  80244b:	68 1b 2f 80 00       	push   $0x802f1b
  802450:	e8 db dd ff ff       	call   800230 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802455:	50                   	push   %eax
  802456:	68 03 2f 80 00       	push   $0x802f03
  80245b:	6a 21                	push   $0x21
  80245d:	68 1b 2f 80 00       	push   $0x802f1b
  802462:	e8 c9 dd ff ff       	call   800230 <_panic>

00802467 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802467:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802468:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80246d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80246f:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802472:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802476:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802479:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  80247d:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802481:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802484:	83 c4 08             	add    $0x8,%esp
	popal
  802487:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802488:	83 c4 04             	add    $0x4,%esp
	popfl
  80248b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80248c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80248d:	c3                   	ret    

0080248e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	56                   	push   %esi
  802492:	53                   	push   %ebx
  802493:	8b 75 08             	mov    0x8(%ebp),%esi
  802496:	8b 45 0c             	mov    0xc(%ebp),%eax
  802499:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 4f                	je     8024ef <ipc_recv+0x61>
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	50                   	push   %eax
  8024a4:	e8 e0 e9 ff ff       	call   800e89 <sys_ipc_recv>
  8024a9:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8024ac:	85 f6                	test   %esi,%esi
  8024ae:	74 14                	je     8024c4 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8024b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 09                	jne    8024c2 <ipc_recv+0x34>
  8024b9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8024bf:	8b 52 74             	mov    0x74(%edx),%edx
  8024c2:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8024c4:	85 db                	test   %ebx,%ebx
  8024c6:	74 14                	je     8024dc <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8024c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	75 09                	jne    8024da <ipc_recv+0x4c>
  8024d1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8024d7:	8b 52 78             	mov    0x78(%edx),%edx
  8024da:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	75 08                	jne    8024e8 <ipc_recv+0x5a>
  8024e0:	a1 08 40 80 00       	mov    0x804008,%eax
  8024e5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	68 00 00 c0 ee       	push   $0xeec00000
  8024f7:	e8 8d e9 ff ff       	call   800e89 <sys_ipc_recv>
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	eb ab                	jmp    8024ac <ipc_recv+0x1e>

00802501 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	57                   	push   %edi
  802505:	56                   	push   %esi
  802506:	53                   	push   %ebx
  802507:	83 ec 0c             	sub    $0xc,%esp
  80250a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80250d:	8b 75 10             	mov    0x10(%ebp),%esi
  802510:	eb 20                	jmp    802532 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802512:	6a 00                	push   $0x0
  802514:	68 00 00 c0 ee       	push   $0xeec00000
  802519:	ff 75 0c             	pushl  0xc(%ebp)
  80251c:	57                   	push   %edi
  80251d:	e8 44 e9 ff ff       	call   800e66 <sys_ipc_try_send>
  802522:	89 c3                	mov    %eax,%ebx
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	eb 1f                	jmp    802548 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802529:	e8 8c e7 ff ff       	call   800cba <sys_yield>
	while(retval != 0) {
  80252e:	85 db                	test   %ebx,%ebx
  802530:	74 33                	je     802565 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802532:	85 f6                	test   %esi,%esi
  802534:	74 dc                	je     802512 <ipc_send+0x11>
  802536:	ff 75 14             	pushl  0x14(%ebp)
  802539:	56                   	push   %esi
  80253a:	ff 75 0c             	pushl  0xc(%ebp)
  80253d:	57                   	push   %edi
  80253e:	e8 23 e9 ff ff       	call   800e66 <sys_ipc_try_send>
  802543:	89 c3                	mov    %eax,%ebx
  802545:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802548:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80254b:	74 dc                	je     802529 <ipc_send+0x28>
  80254d:	85 db                	test   %ebx,%ebx
  80254f:	74 d8                	je     802529 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 2c 2f 80 00       	push   $0x802f2c
  802559:	6a 35                	push   $0x35
  80255b:	68 5c 2f 80 00       	push   $0x802f5c
  802560:	e8 cb dc ff ff       	call   800230 <_panic>
	}
}
  802565:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802568:	5b                   	pop    %ebx
  802569:	5e                   	pop    %esi
  80256a:	5f                   	pop    %edi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    

0080256d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802578:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80257b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802581:	8b 52 50             	mov    0x50(%edx),%edx
  802584:	39 ca                	cmp    %ecx,%edx
  802586:	74 11                	je     802599 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802588:	83 c0 01             	add    $0x1,%eax
  80258b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802590:	75 e6                	jne    802578 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
  802597:	eb 0b                	jmp    8025a4 <ipc_find_env+0x37>
			return envs[i].env_id;
  802599:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80259c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025a1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    

008025a6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ac:	89 d0                	mov    %edx,%eax
  8025ae:	c1 e8 16             	shr    $0x16,%eax
  8025b1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025bd:	f6 c1 01             	test   $0x1,%cl
  8025c0:	74 1d                	je     8025df <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025c2:	c1 ea 0c             	shr    $0xc,%edx
  8025c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025cc:	f6 c2 01             	test   $0x1,%dl
  8025cf:	74 0e                	je     8025df <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025d1:	c1 ea 0c             	shr    $0xc,%edx
  8025d4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025db:	ef 
  8025dc:	0f b7 c0             	movzwl %ax,%eax
}
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    
  8025e1:	66 90                	xchg   %ax,%ax
  8025e3:	66 90                	xchg   %ax,%ax
  8025e5:	66 90                	xchg   %ax,%ax
  8025e7:	66 90                	xchg   %ax,%ax
  8025e9:	66 90                	xchg   %ax,%ax
  8025eb:	66 90                	xchg   %ax,%ax
  8025ed:	66 90                	xchg   %ax,%ax
  8025ef:	90                   	nop

008025f0 <__udivdi3>:
  8025f0:	f3 0f 1e fb          	endbr32 
  8025f4:	55                   	push   %ebp
  8025f5:	57                   	push   %edi
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 1c             	sub    $0x1c,%esp
  8025fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802603:	8b 74 24 34          	mov    0x34(%esp),%esi
  802607:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80260b:	85 d2                	test   %edx,%edx
  80260d:	75 49                	jne    802658 <__udivdi3+0x68>
  80260f:	39 f3                	cmp    %esi,%ebx
  802611:	76 15                	jbe    802628 <__udivdi3+0x38>
  802613:	31 ff                	xor    %edi,%edi
  802615:	89 e8                	mov    %ebp,%eax
  802617:	89 f2                	mov    %esi,%edx
  802619:	f7 f3                	div    %ebx
  80261b:	89 fa                	mov    %edi,%edx
  80261d:	83 c4 1c             	add    $0x1c,%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	89 d9                	mov    %ebx,%ecx
  80262a:	85 db                	test   %ebx,%ebx
  80262c:	75 0b                	jne    802639 <__udivdi3+0x49>
  80262e:	b8 01 00 00 00       	mov    $0x1,%eax
  802633:	31 d2                	xor    %edx,%edx
  802635:	f7 f3                	div    %ebx
  802637:	89 c1                	mov    %eax,%ecx
  802639:	31 d2                	xor    %edx,%edx
  80263b:	89 f0                	mov    %esi,%eax
  80263d:	f7 f1                	div    %ecx
  80263f:	89 c6                	mov    %eax,%esi
  802641:	89 e8                	mov    %ebp,%eax
  802643:	89 f7                	mov    %esi,%edi
  802645:	f7 f1                	div    %ecx
  802647:	89 fa                	mov    %edi,%edx
  802649:	83 c4 1c             	add    $0x1c,%esp
  80264c:	5b                   	pop    %ebx
  80264d:	5e                   	pop    %esi
  80264e:	5f                   	pop    %edi
  80264f:	5d                   	pop    %ebp
  802650:	c3                   	ret    
  802651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802658:	39 f2                	cmp    %esi,%edx
  80265a:	77 1c                	ja     802678 <__udivdi3+0x88>
  80265c:	0f bd fa             	bsr    %edx,%edi
  80265f:	83 f7 1f             	xor    $0x1f,%edi
  802662:	75 2c                	jne    802690 <__udivdi3+0xa0>
  802664:	39 f2                	cmp    %esi,%edx
  802666:	72 06                	jb     80266e <__udivdi3+0x7e>
  802668:	31 c0                	xor    %eax,%eax
  80266a:	39 eb                	cmp    %ebp,%ebx
  80266c:	77 ad                	ja     80261b <__udivdi3+0x2b>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	eb a6                	jmp    80261b <__udivdi3+0x2b>
  802675:	8d 76 00             	lea    0x0(%esi),%esi
  802678:	31 ff                	xor    %edi,%edi
  80267a:	31 c0                	xor    %eax,%eax
  80267c:	89 fa                	mov    %edi,%edx
  80267e:	83 c4 1c             	add    $0x1c,%esp
  802681:	5b                   	pop    %ebx
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80268d:	8d 76 00             	lea    0x0(%esi),%esi
  802690:	89 f9                	mov    %edi,%ecx
  802692:	b8 20 00 00 00       	mov    $0x20,%eax
  802697:	29 f8                	sub    %edi,%eax
  802699:	d3 e2                	shl    %cl,%edx
  80269b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	89 da                	mov    %ebx,%edx
  8026a3:	d3 ea                	shr    %cl,%edx
  8026a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a9:	09 d1                	or     %edx,%ecx
  8026ab:	89 f2                	mov    %esi,%edx
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 f9                	mov    %edi,%ecx
  8026b3:	d3 e3                	shl    %cl,%ebx
  8026b5:	89 c1                	mov    %eax,%ecx
  8026b7:	d3 ea                	shr    %cl,%edx
  8026b9:	89 f9                	mov    %edi,%ecx
  8026bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026bf:	89 eb                	mov    %ebp,%ebx
  8026c1:	d3 e6                	shl    %cl,%esi
  8026c3:	89 c1                	mov    %eax,%ecx
  8026c5:	d3 eb                	shr    %cl,%ebx
  8026c7:	09 de                	or     %ebx,%esi
  8026c9:	89 f0                	mov    %esi,%eax
  8026cb:	f7 74 24 08          	divl   0x8(%esp)
  8026cf:	89 d6                	mov    %edx,%esi
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	f7 64 24 0c          	mull   0xc(%esp)
  8026d7:	39 d6                	cmp    %edx,%esi
  8026d9:	72 15                	jb     8026f0 <__udivdi3+0x100>
  8026db:	89 f9                	mov    %edi,%ecx
  8026dd:	d3 e5                	shl    %cl,%ebp
  8026df:	39 c5                	cmp    %eax,%ebp
  8026e1:	73 04                	jae    8026e7 <__udivdi3+0xf7>
  8026e3:	39 d6                	cmp    %edx,%esi
  8026e5:	74 09                	je     8026f0 <__udivdi3+0x100>
  8026e7:	89 d8                	mov    %ebx,%eax
  8026e9:	31 ff                	xor    %edi,%edi
  8026eb:	e9 2b ff ff ff       	jmp    80261b <__udivdi3+0x2b>
  8026f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026f3:	31 ff                	xor    %edi,%edi
  8026f5:	e9 21 ff ff ff       	jmp    80261b <__udivdi3+0x2b>
  8026fa:	66 90                	xchg   %ax,%ax
  8026fc:	66 90                	xchg   %ax,%ax
  8026fe:	66 90                	xchg   %ax,%ax

00802700 <__umoddi3>:
  802700:	f3 0f 1e fb          	endbr32 
  802704:	55                   	push   %ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 1c             	sub    $0x1c,%esp
  80270b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80270f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802713:	8b 74 24 30          	mov    0x30(%esp),%esi
  802717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80271b:	89 da                	mov    %ebx,%edx
  80271d:	85 c0                	test   %eax,%eax
  80271f:	75 3f                	jne    802760 <__umoddi3+0x60>
  802721:	39 df                	cmp    %ebx,%edi
  802723:	76 13                	jbe    802738 <__umoddi3+0x38>
  802725:	89 f0                	mov    %esi,%eax
  802727:	f7 f7                	div    %edi
  802729:	89 d0                	mov    %edx,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	83 c4 1c             	add    $0x1c,%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    
  802735:	8d 76 00             	lea    0x0(%esi),%esi
  802738:	89 fd                	mov    %edi,%ebp
  80273a:	85 ff                	test   %edi,%edi
  80273c:	75 0b                	jne    802749 <__umoddi3+0x49>
  80273e:	b8 01 00 00 00       	mov    $0x1,%eax
  802743:	31 d2                	xor    %edx,%edx
  802745:	f7 f7                	div    %edi
  802747:	89 c5                	mov    %eax,%ebp
  802749:	89 d8                	mov    %ebx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f5                	div    %ebp
  80274f:	89 f0                	mov    %esi,%eax
  802751:	f7 f5                	div    %ebp
  802753:	89 d0                	mov    %edx,%eax
  802755:	eb d4                	jmp    80272b <__umoddi3+0x2b>
  802757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80275e:	66 90                	xchg   %ax,%ax
  802760:	89 f1                	mov    %esi,%ecx
  802762:	39 d8                	cmp    %ebx,%eax
  802764:	76 0a                	jbe    802770 <__umoddi3+0x70>
  802766:	89 f0                	mov    %esi,%eax
  802768:	83 c4 1c             	add    $0x1c,%esp
  80276b:	5b                   	pop    %ebx
  80276c:	5e                   	pop    %esi
  80276d:	5f                   	pop    %edi
  80276e:	5d                   	pop    %ebp
  80276f:	c3                   	ret    
  802770:	0f bd e8             	bsr    %eax,%ebp
  802773:	83 f5 1f             	xor    $0x1f,%ebp
  802776:	75 20                	jne    802798 <__umoddi3+0x98>
  802778:	39 d8                	cmp    %ebx,%eax
  80277a:	0f 82 b0 00 00 00    	jb     802830 <__umoddi3+0x130>
  802780:	39 f7                	cmp    %esi,%edi
  802782:	0f 86 a8 00 00 00    	jbe    802830 <__umoddi3+0x130>
  802788:	89 c8                	mov    %ecx,%eax
  80278a:	83 c4 1c             	add    $0x1c,%esp
  80278d:	5b                   	pop    %ebx
  80278e:	5e                   	pop    %esi
  80278f:	5f                   	pop    %edi
  802790:	5d                   	pop    %ebp
  802791:	c3                   	ret    
  802792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802798:	89 e9                	mov    %ebp,%ecx
  80279a:	ba 20 00 00 00       	mov    $0x20,%edx
  80279f:	29 ea                	sub    %ebp,%edx
  8027a1:	d3 e0                	shl    %cl,%eax
  8027a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a7:	89 d1                	mov    %edx,%ecx
  8027a9:	89 f8                	mov    %edi,%eax
  8027ab:	d3 e8                	shr    %cl,%eax
  8027ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027b9:	09 c1                	or     %eax,%ecx
  8027bb:	89 d8                	mov    %ebx,%eax
  8027bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027c1:	89 e9                	mov    %ebp,%ecx
  8027c3:	d3 e7                	shl    %cl,%edi
  8027c5:	89 d1                	mov    %edx,%ecx
  8027c7:	d3 e8                	shr    %cl,%eax
  8027c9:	89 e9                	mov    %ebp,%ecx
  8027cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027cf:	d3 e3                	shl    %cl,%ebx
  8027d1:	89 c7                	mov    %eax,%edi
  8027d3:	89 d1                	mov    %edx,%ecx
  8027d5:	89 f0                	mov    %esi,%eax
  8027d7:	d3 e8                	shr    %cl,%eax
  8027d9:	89 e9                	mov    %ebp,%ecx
  8027db:	89 fa                	mov    %edi,%edx
  8027dd:	d3 e6                	shl    %cl,%esi
  8027df:	09 d8                	or     %ebx,%eax
  8027e1:	f7 74 24 08          	divl   0x8(%esp)
  8027e5:	89 d1                	mov    %edx,%ecx
  8027e7:	89 f3                	mov    %esi,%ebx
  8027e9:	f7 64 24 0c          	mull   0xc(%esp)
  8027ed:	89 c6                	mov    %eax,%esi
  8027ef:	89 d7                	mov    %edx,%edi
  8027f1:	39 d1                	cmp    %edx,%ecx
  8027f3:	72 06                	jb     8027fb <__umoddi3+0xfb>
  8027f5:	75 10                	jne    802807 <__umoddi3+0x107>
  8027f7:	39 c3                	cmp    %eax,%ebx
  8027f9:	73 0c                	jae    802807 <__umoddi3+0x107>
  8027fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802803:	89 d7                	mov    %edx,%edi
  802805:	89 c6                	mov    %eax,%esi
  802807:	89 ca                	mov    %ecx,%edx
  802809:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80280e:	29 f3                	sub    %esi,%ebx
  802810:	19 fa                	sbb    %edi,%edx
  802812:	89 d0                	mov    %edx,%eax
  802814:	d3 e0                	shl    %cl,%eax
  802816:	89 e9                	mov    %ebp,%ecx
  802818:	d3 eb                	shr    %cl,%ebx
  80281a:	d3 ea                	shr    %cl,%edx
  80281c:	09 d8                	or     %ebx,%eax
  80281e:	83 c4 1c             	add    $0x1c,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5f                   	pop    %edi
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80282d:	8d 76 00             	lea    0x0(%esi),%esi
  802830:	89 da                	mov    %ebx,%edx
  802832:	29 fe                	sub    %edi,%esi
  802834:	19 c2                	sbb    %eax,%edx
  802836:	89 f1                	mov    %esi,%ecx
  802838:	89 c8                	mov    %ecx,%eax
  80283a:	e9 4b ff ff ff       	jmp    80278a <__umoddi3+0x8a>
