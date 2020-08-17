
obj/user/testpiperace.debug：     文件格式 elf32-i386


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
  80002c:	e8 c2 01 00 00       	call   8001f3 <libmain>
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
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 60 28 80 00       	push   $0x802860
  800040:	e8 e9 02 00 00       	call   80032e <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 be 1d 00 00       	call   801e0e <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 76                	js     8000cd <umain+0x9a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 27 10 00 00       	call   801083 <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 7d                	js     8000df <umain+0xac>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	0f 84 89 00 00 00    	je     8000f1 <umain+0xbe>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 ba 28 80 00       	push   $0x8028ba
  800071:	e8 b8 02 00 00       	call   80032e <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800082:	c1 f8 02             	sar    $0x2,%eax
  800085:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  80008b:	50                   	push   %eax
  80008c:	68 c5 28 80 00       	push   $0x8028c5
  800091:	e8 98 02 00 00       	call   80032e <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 23 15 00 00       	call   8015c6 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	8b 53 54             	mov    0x54(%ebx),%edx
  8000b2:	83 fa 02             	cmp    $0x2,%edx
  8000b5:	0f 85 94 00 00 00    	jne    80014f <umain+0x11c>
		dup(p[0], 10);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	6a 0a                	push   $0xa
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 fe 14 00 00       	call   8015c6 <dup>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	eb e2                	jmp    8000af <umain+0x7c>
		panic("pipe: %e", r);
  8000cd:	50                   	push   %eax
  8000ce:	68 79 28 80 00       	push   $0x802879
  8000d3:	6a 0d                	push   $0xd
  8000d5:	68 82 28 80 00       	push   $0x802882
  8000da:	e8 74 01 00 00       	call   800253 <_panic>
		panic("fork: %e", r);
  8000df:	50                   	push   %eax
  8000e0:	68 96 28 80 00       	push   $0x802896
  8000e5:	6a 10                	push   $0x10
  8000e7:	68 82 28 80 00       	push   $0x802882
  8000ec:	e8 62 01 00 00       	call   800253 <_panic>
		close(p[1]);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000f7:	e8 78 14 00 00       	call   801574 <close>
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	bb c8 00 00 00       	mov    $0xc8,%ebx
  800104:	eb 1f                	jmp    800125 <umain+0xf2>
				cprintf("RACE: pipe appears closed\n");
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 9f 28 80 00       	push   $0x80289f
  80010e:	e8 1b 02 00 00       	call   80032e <cprintf>
				exit();
  800113:	e8 21 01 00 00       	call   800239 <exit>
  800118:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  80011b:	e8 bd 0b 00 00       	call   800cdd <sys_yield>
		for (i=0; i<max; i++) {
  800120:	83 eb 01             	sub    $0x1,%ebx
  800123:	74 14                	je     800139 <umain+0x106>
			if(pipeisclosed(p[0])){
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	ff 75 f0             	pushl  -0x10(%ebp)
  80012b:	e8 28 1e 00 00       	call   801f58 <pipeisclosed>
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	85 c0                	test   %eax,%eax
  800135:	74 e4                	je     80011b <umain+0xe8>
  800137:	eb cd                	jmp    800106 <umain+0xd3>
		ipc_recv(0,0,0);
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	6a 00                	push   $0x0
  800140:	6a 00                	push   $0x0
  800142:	e8 6a 11 00 00       	call   8012b1 <ipc_recv>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 19 ff ff ff       	jmp    800068 <umain+0x35>

	cprintf("child done with loop\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 d0 28 80 00       	push   $0x8028d0
  800157:	e8 d2 01 00 00       	call   80032e <cprintf>
	if (pipeisclosed(p[0]))
  80015c:	83 c4 04             	add    $0x4,%esp
  80015f:	ff 75 f0             	pushl  -0x10(%ebp)
  800162:	e8 f1 1d 00 00       	call   801f58 <pipeisclosed>
  800167:	83 c4 10             	add    $0x10,%esp
  80016a:	85 c0                	test   %eax,%eax
  80016c:	75 48                	jne    8001b6 <umain+0x183>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800174:	50                   	push   %eax
  800175:	ff 75 f0             	pushl  -0x10(%ebp)
  800178:	e8 c5 12 00 00       	call   801442 <fd_lookup>
  80017d:	83 c4 10             	add    $0x10,%esp
  800180:	85 c0                	test   %eax,%eax
  800182:	78 46                	js     8001ca <umain+0x197>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	ff 75 ec             	pushl  -0x14(%ebp)
  80018a:	e8 4a 12 00 00       	call   8013d9 <fd2data>
	if (pageref(va) != 3+1)
  80018f:	89 04 24             	mov    %eax,(%esp)
  800192:	e8 6b 1a 00 00       	call   801c02 <pageref>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	83 f8 04             	cmp    $0x4,%eax
  80019d:	74 3d                	je     8001dc <umain+0x1a9>
		cprintf("\nchild detected race\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 fe 28 80 00       	push   $0x8028fe
  8001a7:	e8 82 01 00 00       	call   80032e <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b6:	83 ec 04             	sub    $0x4,%esp
  8001b9:	68 2c 29 80 00       	push   $0x80292c
  8001be:	6a 3a                	push   $0x3a
  8001c0:	68 82 28 80 00       	push   $0x802882
  8001c5:	e8 89 00 00 00       	call   800253 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 e6 28 80 00       	push   $0x8028e6
  8001d0:	6a 3c                	push   $0x3c
  8001d2:	68 82 28 80 00       	push   $0x802882
  8001d7:	e8 77 00 00 00       	call   800253 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	68 c8 00 00 00       	push   $0xc8
  8001e4:	68 14 29 80 00       	push   $0x802914
  8001e9:	e8 40 01 00 00       	call   80032e <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	eb bc                	jmp    8001af <umain+0x17c>

008001f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001fe:	e8 bb 0a 00 00       	call   800cbe <sys_getenvid>
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800210:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 db                	test   %ebx,%ebx
  800217:	7e 07                	jle    800220 <libmain+0x2d>
		binaryname = argv[0];
  800219:	8b 06                	mov    (%esi),%eax
  80021b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	56                   	push   %esi
  800224:	53                   	push   %ebx
  800225:	e8 09 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022a:	e8 0a 00 00 00       	call   800239 <exit>
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800235:	5b                   	pop    %ebx
  800236:	5e                   	pop    %esi
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023f:	e8 5d 13 00 00       	call   8015a1 <close_all>
	sys_env_destroy(0);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	6a 00                	push   $0x0
  800249:	e8 2f 0a 00 00       	call   800c7d <sys_env_destroy>
}
  80024e:	83 c4 10             	add    $0x10,%esp
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800258:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800261:	e8 58 0a 00 00       	call   800cbe <sys_getenvid>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 0c             	pushl  0xc(%ebp)
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	56                   	push   %esi
  800270:	50                   	push   %eax
  800271:	68 60 29 80 00       	push   $0x802960
  800276:	e8 b3 00 00 00       	call   80032e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80027b:	83 c4 18             	add    $0x18,%esp
  80027e:	53                   	push   %ebx
  80027f:	ff 75 10             	pushl  0x10(%ebp)
  800282:	e8 56 00 00 00       	call   8002dd <vcprintf>
	cprintf("\n");
  800287:	c7 04 24 77 28 80 00 	movl   $0x802877,(%esp)
  80028e:	e8 9b 00 00 00       	call   80032e <cprintf>
  800293:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800296:	cc                   	int3   
  800297:	eb fd                	jmp    800296 <_panic+0x43>

00800299 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	53                   	push   %ebx
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a3:	8b 13                	mov    (%ebx),%edx
  8002a5:	8d 42 01             	lea    0x1(%edx),%eax
  8002a8:	89 03                	mov    %eax,(%ebx)
  8002aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b6:	74 09                	je     8002c1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	68 ff 00 00 00       	push   $0xff
  8002c9:	8d 43 08             	lea    0x8(%ebx),%eax
  8002cc:	50                   	push   %eax
  8002cd:	e8 6e 09 00 00       	call   800c40 <sys_cputs>
		b->idx = 0;
  8002d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	eb db                	jmp    8002b8 <putch+0x1f>

008002dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 99 02 80 00       	push   $0x800299
  80030c:	e8 19 01 00 00       	call   80042a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800311:	83 c4 08             	add    $0x8,%esp
  800314:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80031a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800320:	50                   	push   %eax
  800321:	e8 1a 09 00 00       	call   800c40 <sys_cputs>

	return b.cnt;
}
  800326:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800334:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800337:	50                   	push   %eax
  800338:	ff 75 08             	pushl  0x8(%ebp)
  80033b:	e8 9d ff ff ff       	call   8002dd <vcprintf>
	va_end(ap);

	return cnt;
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
  800348:	83 ec 1c             	sub    $0x1c,%esp
  80034b:	89 c7                	mov    %eax,%edi
  80034d:	89 d6                	mov    %edx,%esi
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	8b 55 0c             	mov    0xc(%ebp),%edx
  800355:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800358:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80035e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800363:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800366:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800369:	3b 45 10             	cmp    0x10(%ebp),%eax
  80036c:	89 d0                	mov    %edx,%eax
  80036e:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800371:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800374:	73 15                	jae    80038b <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800376:	83 eb 01             	sub    $0x1,%ebx
  800379:	85 db                	test   %ebx,%ebx
  80037b:	7e 43                	jle    8003c0 <printnum+0x7e>
			putch(padc, putdat);
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	56                   	push   %esi
  800381:	ff 75 18             	pushl  0x18(%ebp)
  800384:	ff d7                	call   *%edi
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	eb eb                	jmp    800376 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	ff 75 18             	pushl  0x18(%ebp)
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800397:	53                   	push   %ebx
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8003aa:	e8 61 22 00 00       	call   802610 <__udivdi3>
  8003af:	83 c4 18             	add    $0x18,%esp
  8003b2:	52                   	push   %edx
  8003b3:	50                   	push   %eax
  8003b4:	89 f2                	mov    %esi,%edx
  8003b6:	89 f8                	mov    %edi,%eax
  8003b8:	e8 85 ff ff ff       	call   800342 <printnum>
  8003bd:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	56                   	push   %esi
  8003c4:	83 ec 04             	sub    $0x4,%esp
  8003c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d3:	e8 48 23 00 00       	call   802720 <__umoddi3>
  8003d8:	83 c4 14             	add    $0x14,%esp
  8003db:	0f be 80 83 29 80 00 	movsbl 0x802983(%eax),%eax
  8003e2:	50                   	push   %eax
  8003e3:	ff d7                	call   *%edi
}
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003eb:	5b                   	pop    %ebx
  8003ec:	5e                   	pop    %esi
  8003ed:	5f                   	pop    %edi
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fa:	8b 10                	mov    (%eax),%edx
  8003fc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ff:	73 0a                	jae    80040b <sprintputch+0x1b>
		*b->buf++ = ch;
  800401:	8d 4a 01             	lea    0x1(%edx),%ecx
  800404:	89 08                	mov    %ecx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	88 02                	mov    %al,(%edx)
}
  80040b:	5d                   	pop    %ebp
  80040c:	c3                   	ret    

0080040d <printfmt>:
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800413:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800416:	50                   	push   %eax
  800417:	ff 75 10             	pushl  0x10(%ebp)
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	ff 75 08             	pushl  0x8(%ebp)
  800420:	e8 05 00 00 00       	call   80042a <vprintfmt>
}
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <vprintfmt>:
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
  800430:	83 ec 3c             	sub    $0x3c,%esp
  800433:	8b 75 08             	mov    0x8(%ebp),%esi
  800436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800439:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043c:	eb 0a                	jmp    800448 <vprintfmt+0x1e>
			putch(ch, putdat);
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	53                   	push   %ebx
  800442:	50                   	push   %eax
  800443:	ff d6                	call   *%esi
  800445:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800448:	83 c7 01             	add    $0x1,%edi
  80044b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80044f:	83 f8 25             	cmp    $0x25,%eax
  800452:	74 0c                	je     800460 <vprintfmt+0x36>
			if (ch == '\0')
  800454:	85 c0                	test   %eax,%eax
  800456:	75 e6                	jne    80043e <vprintfmt+0x14>
}
  800458:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045b:	5b                   	pop    %ebx
  80045c:	5e                   	pop    %esi
  80045d:	5f                   	pop    %edi
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    
		padc = ' ';
  800460:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800464:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80046b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800472:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800479:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8d 47 01             	lea    0x1(%edi),%eax
  800481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800484:	0f b6 17             	movzbl (%edi),%edx
  800487:	8d 42 dd             	lea    -0x23(%edx),%eax
  80048a:	3c 55                	cmp    $0x55,%al
  80048c:	0f 87 ba 03 00 00    	ja     80084c <vprintfmt+0x422>
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	ff 24 85 c0 2a 80 00 	jmp    *0x802ac0(,%eax,4)
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a3:	eb d9                	jmp    80047e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004a8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004ac:	eb d0                	jmp    80047e <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	0f b6 d2             	movzbl %dl,%edx
  8004b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c9:	83 f9 09             	cmp    $0x9,%ecx
  8004cc:	77 55                	ja     800523 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004d1:	eb e9                	jmp    8004bc <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 04             	lea    0x4(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	79 91                	jns    80047e <vprintfmt+0x54>
				width = precision, precision = -1;
  8004ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fa:	eb 82                	jmp    80047e <vprintfmt+0x54>
  8004fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	0f 49 d0             	cmovns %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050f:	e9 6a ff ff ff       	jmp    80047e <vprintfmt+0x54>
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800517:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80051e:	e9 5b ff ff ff       	jmp    80047e <vprintfmt+0x54>
  800523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	eb bc                	jmp    8004e7 <vprintfmt+0xbd>
			lflag++;
  80052b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800531:	e9 48 ff ff ff       	jmp    80047e <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 78 04             	lea    0x4(%eax),%edi
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 30                	pushl  (%eax)
  800542:	ff d6                	call   *%esi
			break;
  800544:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80054a:	e9 9c 02 00 00       	jmp    8007eb <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 78 04             	lea    0x4(%eax),%edi
  800555:	8b 00                	mov    (%eax),%eax
  800557:	99                   	cltd   
  800558:	31 d0                	xor    %edx,%eax
  80055a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0f             	cmp    $0xf,%eax
  80055f:	7f 23                	jg     800584 <vprintfmt+0x15a>
  800561:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 18                	je     800584 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80056c:	52                   	push   %edx
  80056d:	68 fe 2e 80 00       	push   $0x802efe
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 94 fe ff ff       	call   80040d <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 67 02 00 00       	jmp    8007eb <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800584:	50                   	push   %eax
  800585:	68 9b 29 80 00       	push   $0x80299b
  80058a:	53                   	push   %ebx
  80058b:	56                   	push   %esi
  80058c:	e8 7c fe ff ff       	call   80040d <printfmt>
  800591:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800594:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800597:	e9 4f 02 00 00       	jmp    8007eb <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	b8 94 29 80 00       	mov    $0x802994,%eax
  8005b1:	0f 45 c2             	cmovne %edx,%eax
  8005b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bb:	7e 06                	jle    8005c3 <vprintfmt+0x199>
  8005bd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c1:	75 0d                	jne    8005d0 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c6:	89 c7                	mov    %eax,%edi
  8005c8:	03 45 e0             	add    -0x20(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	eb 3f                	jmp    80060f <vprintfmt+0x1e5>
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d6:	50                   	push   %eax
  8005d7:	e8 0d 03 00 00       	call   8008e9 <strnlen>
  8005dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005df:	29 c2                	sub    %eax,%edx
  8005e1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005e9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	85 ff                	test   %edi,%edi
  8005f2:	7e 58                	jle    80064c <vprintfmt+0x222>
					putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fd:	83 ef 01             	sub    $0x1,%edi
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	eb eb                	jmp    8005f0 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	52                   	push   %edx
  80060a:	ff d6                	call   *%esi
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800612:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800614:	83 c7 01             	add    $0x1,%edi
  800617:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061b:	0f be d0             	movsbl %al,%edx
  80061e:	85 d2                	test   %edx,%edx
  800620:	74 45                	je     800667 <vprintfmt+0x23d>
  800622:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800626:	78 06                	js     80062e <vprintfmt+0x204>
  800628:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062c:	78 35                	js     800663 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80062e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800632:	74 d1                	je     800605 <vprintfmt+0x1db>
  800634:	0f be c0             	movsbl %al,%eax
  800637:	83 e8 20             	sub    $0x20,%eax
  80063a:	83 f8 5e             	cmp    $0x5e,%eax
  80063d:	76 c6                	jbe    800605 <vprintfmt+0x1db>
					putch('?', putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	53                   	push   %ebx
  800643:	6a 3f                	push   $0x3f
  800645:	ff d6                	call   *%esi
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	eb c3                	jmp    80060f <vprintfmt+0x1e5>
  80064c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80064f:	85 d2                	test   %edx,%edx
  800651:	b8 00 00 00 00       	mov    $0x0,%eax
  800656:	0f 49 c2             	cmovns %edx,%eax
  800659:	29 c2                	sub    %eax,%edx
  80065b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80065e:	e9 60 ff ff ff       	jmp    8005c3 <vprintfmt+0x199>
  800663:	89 cf                	mov    %ecx,%edi
  800665:	eb 02                	jmp    800669 <vprintfmt+0x23f>
  800667:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800669:	85 ff                	test   %edi,%edi
  80066b:	7e 10                	jle    80067d <vprintfmt+0x253>
				putch(' ', putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	6a 20                	push   $0x20
  800673:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800675:	83 ef 01             	sub    $0x1,%edi
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	eb ec                	jmp    800669 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80067d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
  800683:	e9 63 01 00 00       	jmp    8007eb <vprintfmt+0x3c1>
	if (lflag >= 2)
  800688:	83 f9 01             	cmp    $0x1,%ecx
  80068b:	7f 1b                	jg     8006a8 <vprintfmt+0x27e>
	else if (lflag)
  80068d:	85 c9                	test   %ecx,%ecx
  80068f:	74 63                	je     8006f4 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	99                   	cltd   
  80069a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a6:	eb 17                	jmp    8006bf <vprintfmt+0x295>
		return va_arg(*ap, long long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 50 04             	mov    0x4(%eax),%edx
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 08             	lea    0x8(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ca:	85 c9                	test   %ecx,%ecx
  8006cc:	0f 89 ff 00 00 00    	jns    8007d1 <vprintfmt+0x3a7>
				putch('-', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 2d                	push   $0x2d
  8006d8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006e0:	f7 da                	neg    %edx
  8006e2:	83 d1 00             	adc    $0x0,%ecx
  8006e5:	f7 d9                	neg    %ecx
  8006e7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ef:	e9 dd 00 00 00       	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	99                   	cltd   
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
  800709:	eb b4                	jmp    8006bf <vprintfmt+0x295>
	if (lflag >= 2)
  80070b:	83 f9 01             	cmp    $0x1,%ecx
  80070e:	7f 1e                	jg     80072e <vprintfmt+0x304>
	else if (lflag)
  800710:	85 c9                	test   %ecx,%ecx
  800712:	74 32                	je     800746 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 10                	mov    (%eax),%edx
  800719:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800724:	b8 0a 00 00 00       	mov    $0xa,%eax
  800729:	e9 a3 00 00 00       	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	8b 48 04             	mov    0x4(%eax),%ecx
  800736:	8d 40 08             	lea    0x8(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800741:	e9 8b 00 00 00       	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800756:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075b:	eb 74                	jmp    8007d1 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80075d:	83 f9 01             	cmp    $0x1,%ecx
  800760:	7f 1b                	jg     80077d <vprintfmt+0x353>
	else if (lflag)
  800762:	85 c9                	test   %ecx,%ecx
  800764:	74 2c                	je     800792 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 10                	mov    (%eax),%edx
  80076b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
  80077b:	eb 54                	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 10                	mov    (%eax),%edx
  800782:	8b 48 04             	mov    0x4(%eax),%ecx
  800785:	8d 40 08             	lea    0x8(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078b:	b8 08 00 00 00       	mov    $0x8,%eax
  800790:	eb 3f                	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 10                	mov    (%eax),%edx
  800797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079c:	8d 40 04             	lea    0x4(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a7:	eb 28                	jmp    8007d1 <vprintfmt+0x3a7>
			putch('0', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	6a 30                	push   $0x30
  8007af:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b1:	83 c4 08             	add    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	6a 78                	push   $0x78
  8007b7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 10                	mov    (%eax),%edx
  8007be:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007c3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c6:	8d 40 04             	lea    0x4(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d1:	83 ec 0c             	sub    $0xc,%esp
  8007d4:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007d8:	57                   	push   %edi
  8007d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	51                   	push   %ecx
  8007de:	52                   	push   %edx
  8007df:	89 da                	mov    %ebx,%edx
  8007e1:	89 f0                	mov    %esi,%eax
  8007e3:	e8 5a fb ff ff       	call   800342 <printnum>
			break;
  8007e8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ee:	e9 55 fc ff ff       	jmp    800448 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007f3:	83 f9 01             	cmp    $0x1,%ecx
  8007f6:	7f 1b                	jg     800813 <vprintfmt+0x3e9>
	else if (lflag)
  8007f8:	85 c9                	test   %ecx,%ecx
  8007fa:	74 2c                	je     800828 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
  800811:	eb be                	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 10                	mov    (%eax),%edx
  800818:	8b 48 04             	mov    0x4(%eax),%ecx
  80081b:	8d 40 08             	lea    0x8(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
  800826:	eb a9                	jmp    8007d1 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 10                	mov    (%eax),%edx
  80082d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
  80083d:	eb 92                	jmp    8007d1 <vprintfmt+0x3a7>
			putch(ch, putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	53                   	push   %ebx
  800843:	6a 25                	push   $0x25
  800845:	ff d6                	call   *%esi
			break;
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	eb 9f                	jmp    8007eb <vprintfmt+0x3c1>
			putch('%', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	89 f8                	mov    %edi,%eax
  800859:	eb 03                	jmp    80085e <vprintfmt+0x434>
  80085b:	83 e8 01             	sub    $0x1,%eax
  80085e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800862:	75 f7                	jne    80085b <vprintfmt+0x431>
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	eb 82                	jmp    8007eb <vprintfmt+0x3c1>

00800869 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	83 ec 18             	sub    $0x18,%esp
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800875:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800878:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80087f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800886:	85 c0                	test   %eax,%eax
  800888:	74 26                	je     8008b0 <vsnprintf+0x47>
  80088a:	85 d2                	test   %edx,%edx
  80088c:	7e 22                	jle    8008b0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088e:	ff 75 14             	pushl  0x14(%ebp)
  800891:	ff 75 10             	pushl  0x10(%ebp)
  800894:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	68 f0 03 80 00       	push   $0x8003f0
  80089d:	e8 88 fb ff ff       	call   80042a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    
		return -E_INVAL;
  8008b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b5:	eb f7                	jmp    8008ae <vsnprintf+0x45>

008008b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 10             	pushl  0x10(%ebp)
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 9a ff ff ff       	call   800869 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e0:	74 05                	je     8008e7 <strlen+0x16>
		n++;
  8008e2:	83 c0 01             	add    $0x1,%eax
  8008e5:	eb f5                	jmp    8008dc <strlen+0xb>
	return n;
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	39 c2                	cmp    %eax,%edx
  8008f9:	74 0d                	je     800908 <strnlen+0x1f>
  8008fb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ff:	74 05                	je     800906 <strnlen+0x1d>
		n++;
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	eb f1                	jmp    8008f7 <strnlen+0xe>
  800906:	89 d0                	mov    %edx,%eax
	return n;
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	84 c9                	test   %cl,%cl
  800925:	75 f2                	jne    800919 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800927:	5b                   	pop    %ebx
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	53                   	push   %ebx
  80092e:	83 ec 10             	sub    $0x10,%esp
  800931:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800934:	53                   	push   %ebx
  800935:	e8 97 ff ff ff       	call   8008d1 <strlen>
  80093a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	01 d8                	add    %ebx,%eax
  800942:	50                   	push   %eax
  800943:	e8 c2 ff ff ff       	call   80090a <strcpy>
	return dst;
}
  800948:	89 d8                	mov    %ebx,%eax
  80094a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095a:	89 c6                	mov    %eax,%esi
  80095c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80095f:	89 c2                	mov    %eax,%edx
  800961:	39 f2                	cmp    %esi,%edx
  800963:	74 11                	je     800976 <strncpy+0x27>
		*dst++ = *src;
  800965:	83 c2 01             	add    $0x1,%edx
  800968:	0f b6 19             	movzbl (%ecx),%ebx
  80096b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80096e:	80 fb 01             	cmp    $0x1,%bl
  800971:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800974:	eb eb                	jmp    800961 <strncpy+0x12>
	}
	return ret;
}
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800985:	8b 55 10             	mov    0x10(%ebp),%edx
  800988:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098a:	85 d2                	test   %edx,%edx
  80098c:	74 21                	je     8009af <strlcpy+0x35>
  80098e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800992:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800994:	39 c2                	cmp    %eax,%edx
  800996:	74 14                	je     8009ac <strlcpy+0x32>
  800998:	0f b6 19             	movzbl (%ecx),%ebx
  80099b:	84 db                	test   %bl,%bl
  80099d:	74 0b                	je     8009aa <strlcpy+0x30>
			*dst++ = *src++;
  80099f:	83 c1 01             	add    $0x1,%ecx
  8009a2:	83 c2 01             	add    $0x1,%edx
  8009a5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a8:	eb ea                	jmp    800994 <strlcpy+0x1a>
  8009aa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009af:	29 f0                	sub    %esi,%eax
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	5e                   	pop    %esi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009be:	0f b6 01             	movzbl (%ecx),%eax
  8009c1:	84 c0                	test   %al,%al
  8009c3:	74 0c                	je     8009d1 <strcmp+0x1c>
  8009c5:	3a 02                	cmp    (%edx),%al
  8009c7:	75 08                	jne    8009d1 <strcmp+0x1c>
		p++, q++;
  8009c9:	83 c1 01             	add    $0x1,%ecx
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	eb ed                	jmp    8009be <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	0f b6 12             	movzbl (%edx),%edx
  8009d7:	29 d0                	sub    %edx,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	89 c3                	mov    %eax,%ebx
  8009e7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ea:	eb 06                	jmp    8009f2 <strncmp+0x17>
		n--, p++, q++;
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f2:	39 d8                	cmp    %ebx,%eax
  8009f4:	74 16                	je     800a0c <strncmp+0x31>
  8009f6:	0f b6 08             	movzbl (%eax),%ecx
  8009f9:	84 c9                	test   %cl,%cl
  8009fb:	74 04                	je     800a01 <strncmp+0x26>
  8009fd:	3a 0a                	cmp    (%edx),%cl
  8009ff:	74 eb                	je     8009ec <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a01:	0f b6 00             	movzbl (%eax),%eax
  800a04:	0f b6 12             	movzbl (%edx),%edx
  800a07:	29 d0                	sub    %edx,%eax
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    
		return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb f6                	jmp    800a09 <strncmp+0x2e>

00800a13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	0f b6 10             	movzbl (%eax),%edx
  800a20:	84 d2                	test   %dl,%dl
  800a22:	74 09                	je     800a2d <strchr+0x1a>
		if (*s == c)
  800a24:	38 ca                	cmp    %cl,%dl
  800a26:	74 0a                	je     800a32 <strchr+0x1f>
	for (; *s; s++)
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f0                	jmp    800a1d <strchr+0xa>
			return (char *) s;
	return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a41:	38 ca                	cmp    %cl,%dl
  800a43:	74 09                	je     800a4e <strfind+0x1a>
  800a45:	84 d2                	test   %dl,%dl
  800a47:	74 05                	je     800a4e <strfind+0x1a>
	for (; *s; s++)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	eb f0                	jmp    800a3e <strfind+0xa>
			break;
	return (char *) s;
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5c:	85 c9                	test   %ecx,%ecx
  800a5e:	74 31                	je     800a91 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 c8                	or     %ecx,%eax
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 23                	jne    800a8b <memset+0x3b>
		c &= 0xFF;
  800a68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6c:	89 d3                	mov    %edx,%ebx
  800a6e:	c1 e3 08             	shl    $0x8,%ebx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	c1 e0 18             	shl    $0x18,%eax
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	c1 e6 10             	shl    $0x10,%esi
  800a7b:	09 f0                	or     %esi,%eax
  800a7d:	09 c2                	or     %eax,%edx
  800a7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	fc                   	cld    
  800a87:	f3 ab                	rep stos %eax,%es:(%edi)
  800a89:	eb 06                	jmp    800a91 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa6:	39 c6                	cmp    %eax,%esi
  800aa8:	73 32                	jae    800adc <memmove+0x44>
  800aaa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aad:	39 c2                	cmp    %eax,%edx
  800aaf:	76 2b                	jbe    800adc <memmove+0x44>
		s += n;
		d += n;
  800ab1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab4:	89 fe                	mov    %edi,%esi
  800ab6:	09 ce                	or     %ecx,%esi
  800ab8:	09 d6                	or     %edx,%esi
  800aba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac0:	75 0e                	jne    800ad0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac2:	83 ef 04             	sub    $0x4,%edi
  800ac5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acb:	fd                   	std    
  800acc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ace:	eb 09                	jmp    800ad9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad0:	83 ef 01             	sub    $0x1,%edi
  800ad3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad6:	fd                   	std    
  800ad7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad9:	fc                   	cld    
  800ada:	eb 1a                	jmp    800af6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adc:	89 c2                	mov    %eax,%edx
  800ade:	09 ca                	or     %ecx,%edx
  800ae0:	09 f2                	or     %esi,%edx
  800ae2:	f6 c2 03             	test   $0x3,%dl
  800ae5:	75 0a                	jne    800af1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	fc                   	cld    
  800aed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aef:	eb 05                	jmp    800af6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af1:	89 c7                	mov    %eax,%edi
  800af3:	fc                   	cld    
  800af4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b00:	ff 75 10             	pushl  0x10(%ebp)
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 8a ff ff ff       	call   800a98 <memmove>
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b20:	39 f0                	cmp    %esi,%eax
  800b22:	74 1c                	je     800b40 <memcmp+0x30>
		if (*s1 != *s2)
  800b24:	0f b6 08             	movzbl (%eax),%ecx
  800b27:	0f b6 1a             	movzbl (%edx),%ebx
  800b2a:	38 d9                	cmp    %bl,%cl
  800b2c:	75 08                	jne    800b36 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2e:	83 c0 01             	add    $0x1,%eax
  800b31:	83 c2 01             	add    $0x1,%edx
  800b34:	eb ea                	jmp    800b20 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b36:	0f b6 c1             	movzbl %cl,%eax
  800b39:	0f b6 db             	movzbl %bl,%ebx
  800b3c:	29 d8                	sub    %ebx,%eax
  800b3e:	eb 05                	jmp    800b45 <memcmp+0x35>
	}

	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b52:	89 c2                	mov    %eax,%edx
  800b54:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b57:	39 d0                	cmp    %edx,%eax
  800b59:	73 09                	jae    800b64 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5b:	38 08                	cmp    %cl,(%eax)
  800b5d:	74 05                	je     800b64 <memfind+0x1b>
	for (; s < ends; s++)
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	eb f3                	jmp    800b57 <memfind+0xe>
			break;
	return (void *) s;
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b72:	eb 03                	jmp    800b77 <strtol+0x11>
		s++;
  800b74:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b77:	0f b6 01             	movzbl (%ecx),%eax
  800b7a:	3c 20                	cmp    $0x20,%al
  800b7c:	74 f6                	je     800b74 <strtol+0xe>
  800b7e:	3c 09                	cmp    $0x9,%al
  800b80:	74 f2                	je     800b74 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b82:	3c 2b                	cmp    $0x2b,%al
  800b84:	74 2a                	je     800bb0 <strtol+0x4a>
	int neg = 0;
  800b86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8b:	3c 2d                	cmp    $0x2d,%al
  800b8d:	74 2b                	je     800bba <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b95:	75 0f                	jne    800ba6 <strtol+0x40>
  800b97:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9a:	74 28                	je     800bc4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba3:	0f 44 d8             	cmove  %eax,%ebx
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bae:	eb 50                	jmp    800c00 <strtol+0x9a>
		s++;
  800bb0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb3:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb8:	eb d5                	jmp    800b8f <strtol+0x29>
		s++, neg = 1;
  800bba:	83 c1 01             	add    $0x1,%ecx
  800bbd:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc2:	eb cb                	jmp    800b8f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc8:	74 0e                	je     800bd8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	75 d8                	jne    800ba6 <strtol+0x40>
		s++, base = 8;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd6:	eb ce                	jmp    800ba6 <strtol+0x40>
		s += 2, base = 16;
  800bd8:	83 c1 02             	add    $0x2,%ecx
  800bdb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be0:	eb c4                	jmp    800ba6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 19             	cmp    $0x19,%bl
  800bea:	77 29                	ja     800c15 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf5:	7d 30                	jge    800c27 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bf7:	83 c1 01             	add    $0x1,%ecx
  800bfa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c00:	0f b6 11             	movzbl (%ecx),%edx
  800c03:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c06:	89 f3                	mov    %esi,%ebx
  800c08:	80 fb 09             	cmp    $0x9,%bl
  800c0b:	77 d5                	ja     800be2 <strtol+0x7c>
			dig = *s - '0';
  800c0d:	0f be d2             	movsbl %dl,%edx
  800c10:	83 ea 30             	sub    $0x30,%edx
  800c13:	eb dd                	jmp    800bf2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c18:	89 f3                	mov    %esi,%ebx
  800c1a:	80 fb 19             	cmp    $0x19,%bl
  800c1d:	77 08                	ja     800c27 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 37             	sub    $0x37,%edx
  800c25:	eb cb                	jmp    800bf2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 05                	je     800c32 <strtol+0xcc>
		*endptr = (char *) s;
  800c2d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c30:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c32:	89 c2                	mov    %eax,%edx
  800c34:	f7 da                	neg    %edx
  800c36:	85 ff                	test   %edi,%edi
  800c38:	0f 45 c2             	cmovne %edx,%eax
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c51:	89 c3                	mov    %eax,%ebx
  800c53:	89 c7                	mov    %eax,%edi
  800c55:	89 c6                	mov    %eax,%esi
  800c57:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6e:	89 d1                	mov    %edx,%ecx
  800c70:	89 d3                	mov    %edx,%ebx
  800c72:	89 d7                	mov    %edx,%edi
  800c74:	89 d6                	mov    %edx,%esi
  800c76:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	57                   	push   %edi
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
  800c83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c93:	89 cb                	mov    %ecx,%ebx
  800c95:	89 cf                	mov    %ecx,%edi
  800c97:	89 ce                	mov    %ecx,%esi
  800c99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	7f 08                	jg     800ca7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	83 ec 0c             	sub    $0xc,%esp
  800caa:	50                   	push   %eax
  800cab:	6a 03                	push   $0x3
  800cad:	68 7f 2c 80 00       	push   $0x802c7f
  800cb2:	6a 23                	push   $0x23
  800cb4:	68 9c 2c 80 00       	push   $0x802c9c
  800cb9:	e8 95 f5 ff ff       	call   800253 <_panic>

00800cbe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cce:	89 d1                	mov    %edx,%ecx
  800cd0:	89 d3                	mov    %edx,%ebx
  800cd2:	89 d7                	mov    %edx,%edi
  800cd4:	89 d6                	mov    %edx,%esi
  800cd6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_yield>:

void
sys_yield(void)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ced:	89 d1                	mov    %edx,%ecx
  800cef:	89 d3                	mov    %edx,%ebx
  800cf1:	89 d7                	mov    %edx,%edi
  800cf3:	89 d6                	mov    %edx,%esi
  800cf5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	be 00 00 00 00       	mov    $0x0,%esi
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	b8 04 00 00 00       	mov    $0x4,%eax
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	89 f7                	mov    %esi,%edi
  800d1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7f 08                	jg     800d28 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d2c:	6a 04                	push   $0x4
  800d2e:	68 7f 2c 80 00       	push   $0x802c7f
  800d33:	6a 23                	push   $0x23
  800d35:	68 9c 2c 80 00       	push   $0x802c9c
  800d3a:	e8 14 f5 ff ff       	call   800253 <_panic>

00800d3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d59:	8b 75 18             	mov    0x18(%ebp),%esi
  800d5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	7f 08                	jg     800d6a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d6e:	6a 05                	push   $0x5
  800d70:	68 7f 2c 80 00       	push   $0x802c7f
  800d75:	6a 23                	push   $0x23
  800d77:	68 9c 2c 80 00       	push   $0x802c9c
  800d7c:	e8 d2 f4 ff ff       	call   800253 <_panic>

00800d81 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d95:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9a:	89 df                	mov    %ebx,%edi
  800d9c:	89 de                	mov    %ebx,%esi
  800d9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7f 08                	jg     800dac <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800db0:	6a 06                	push   $0x6
  800db2:	68 7f 2c 80 00       	push   $0x802c7f
  800db7:	6a 23                	push   $0x23
  800db9:	68 9c 2c 80 00       	push   $0x802c9c
  800dbe:	e8 90 f4 ff ff       	call   800253 <_panic>

00800dc3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddc:	89 df                	mov    %ebx,%edi
  800dde:	89 de                	mov    %ebx,%esi
  800de0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	7f 08                	jg     800dee <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	50                   	push   %eax
  800df2:	6a 08                	push   $0x8
  800df4:	68 7f 2c 80 00       	push   $0x802c7f
  800df9:	6a 23                	push   $0x23
  800dfb:	68 9c 2c 80 00       	push   $0x802c9c
  800e00:	e8 4e f4 ff ff       	call   800253 <_panic>

00800e05 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	b8 09 00 00 00       	mov    $0x9,%eax
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	89 de                	mov    %ebx,%esi
  800e22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 09                	push   $0x9
  800e36:	68 7f 2c 80 00       	push   $0x802c7f
  800e3b:	6a 23                	push   $0x23
  800e3d:	68 9c 2c 80 00       	push   $0x802c9c
  800e42:	e8 0c f4 ff ff       	call   800253 <_panic>

00800e47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	89 de                	mov    %ebx,%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 0a                	push   $0xa
  800e78:	68 7f 2c 80 00       	push   $0x802c7f
  800e7d:	6a 23                	push   $0x23
  800e7f:	68 9c 2c 80 00       	push   $0x802c9c
  800e84:	e8 ca f3 ff ff       	call   800253 <_panic>

00800e89 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e95:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9a:	be 00 00 00 00       	mov    $0x0,%esi
  800e9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec2:	89 cb                	mov    %ecx,%ebx
  800ec4:	89 cf                	mov    %ecx,%edi
  800ec6:	89 ce                	mov    %ecx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 0d                	push   $0xd
  800edc:	68 7f 2c 80 00       	push   $0x802c7f
  800ee1:	6a 23                	push   $0x23
  800ee3:	68 9c 2c 80 00       	push   $0x802c9c
  800ee8:	e8 66 f3 ff ff       	call   800253 <_panic>

00800eed <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efd:	89 d1                	mov    %edx,%ecx
  800eff:	89 d3                	mov    %edx,%ebx
  800f01:	89 d7                	mov    %edx,%edi
  800f03:	89 d6                	mov    %edx,%esi
  800f05:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f18:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800f1a:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f1d:	89 d9                	mov    %ebx,%ecx
  800f1f:	c1 e9 16             	shr    $0x16,%ecx
  800f22:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f2e:	f6 c1 01             	test   $0x1,%cl
  800f31:	74 0c                	je     800f3f <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800f33:	89 d9                	mov    %ebx,%ecx
  800f35:	c1 e9 0c             	shr    $0xc,%ecx
  800f38:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800f3f:	f6 c2 02             	test   $0x2,%dl
  800f42:	0f 84 a3 00 00 00    	je     800feb <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800f48:	89 da                	mov    %ebx,%edx
  800f4a:	c1 ea 0c             	shr    $0xc,%edx
  800f4d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f54:	f6 c6 08             	test   $0x8,%dh
  800f57:	0f 84 b7 00 00 00    	je     801014 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800f5d:	e8 5c fd ff ff       	call   800cbe <sys_getenvid>
  800f62:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	6a 07                	push   $0x7
  800f69:	68 00 f0 7f 00       	push   $0x7ff000
  800f6e:	50                   	push   %eax
  800f6f:	e8 88 fd ff ff       	call   800cfc <sys_page_alloc>
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	0f 88 bc 00 00 00    	js     80103b <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800f7f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800f85:	83 ec 04             	sub    $0x4,%esp
  800f88:	68 00 10 00 00       	push   $0x1000
  800f8d:	53                   	push   %ebx
  800f8e:	68 00 f0 7f 00       	push   $0x7ff000
  800f93:	e8 00 fb ff ff       	call   800a98 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f98:	83 c4 08             	add    $0x8,%esp
  800f9b:	53                   	push   %ebx
  800f9c:	56                   	push   %esi
  800f9d:	e8 df fd ff ff       	call   800d81 <sys_page_unmap>
  800fa2:	83 c4 10             	add    $0x10,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	0f 88 a0 00 00 00    	js     80104d <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	6a 07                	push   $0x7
  800fb2:	53                   	push   %ebx
  800fb3:	56                   	push   %esi
  800fb4:	68 00 f0 7f 00       	push   $0x7ff000
  800fb9:	56                   	push   %esi
  800fba:	e8 80 fd ff ff       	call   800d3f <sys_page_map>
  800fbf:	83 c4 20             	add    $0x20,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	0f 88 95 00 00 00    	js     80105f <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	68 00 f0 7f 00       	push   $0x7ff000
  800fd2:	56                   	push   %esi
  800fd3:	e8 a9 fd ff ff       	call   800d81 <sys_page_unmap>
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	0f 88 8e 00 00 00    	js     801071 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800feb:	8b 70 28             	mov    0x28(%eax),%esi
  800fee:	e8 cb fc ff ff       	call   800cbe <sys_getenvid>
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
  800ff5:	50                   	push   %eax
  800ff6:	68 ac 2c 80 00       	push   $0x802cac
  800ffb:	e8 2e f3 ff ff       	call   80032e <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  801000:	83 c4 0c             	add    $0xc,%esp
  801003:	68 d0 2c 80 00       	push   $0x802cd0
  801008:	6a 27                	push   $0x27
  80100a:	68 a4 2d 80 00       	push   $0x802da4
  80100f:	e8 3f f2 ff ff       	call   800253 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  801014:	8b 78 28             	mov    0x28(%eax),%edi
  801017:	e8 a2 fc ff ff       	call   800cbe <sys_getenvid>
  80101c:	57                   	push   %edi
  80101d:	53                   	push   %ebx
  80101e:	50                   	push   %eax
  80101f:	68 ac 2c 80 00       	push   $0x802cac
  801024:	e8 05 f3 ff ff       	call   80032e <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801029:	56                   	push   %esi
  80102a:	68 04 2d 80 00       	push   $0x802d04
  80102f:	6a 2b                	push   $0x2b
  801031:	68 a4 2d 80 00       	push   $0x802da4
  801036:	e8 18 f2 ff ff       	call   800253 <_panic>
      panic("pgfault: page allocation failed %e", r);
  80103b:	50                   	push   %eax
  80103c:	68 3c 2d 80 00       	push   $0x802d3c
  801041:	6a 39                	push   $0x39
  801043:	68 a4 2d 80 00       	push   $0x802da4
  801048:	e8 06 f2 ff ff       	call   800253 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  80104d:	50                   	push   %eax
  80104e:	68 60 2d 80 00       	push   $0x802d60
  801053:	6a 3e                	push   $0x3e
  801055:	68 a4 2d 80 00       	push   $0x802da4
  80105a:	e8 f4 f1 ff ff       	call   800253 <_panic>
      panic("pgfault: page map failed (%e)", r);
  80105f:	50                   	push   %eax
  801060:	68 af 2d 80 00       	push   $0x802daf
  801065:	6a 40                	push   $0x40
  801067:	68 a4 2d 80 00       	push   $0x802da4
  80106c:	e8 e2 f1 ff ff       	call   800253 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801071:	50                   	push   %eax
  801072:	68 60 2d 80 00       	push   $0x802d60
  801077:	6a 42                	push   $0x42
  801079:	68 a4 2d 80 00       	push   $0x802da4
  80107e:	e8 d0 f1 ff ff       	call   800253 <_panic>

00801083 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  80108c:	68 0c 0f 80 00       	push   $0x800f0c
  801091:	e8 d1 14 00 00       	call   802567 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801096:	b8 07 00 00 00       	mov    $0x7,%eax
  80109b:	cd 30                	int    $0x30
  80109d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 2d                	js     8010d4 <fork+0x51>
  8010a7:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  8010ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b2:	0f 85 a6 00 00 00    	jne    80115e <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  8010b8:	e8 01 fc ff ff       	call   800cbe <sys_getenvid>
  8010bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010c2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010c5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ca:	a3 08 40 80 00       	mov    %eax,0x804008
      return 0;
  8010cf:	e9 79 01 00 00       	jmp    80124d <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8010d4:	50                   	push   %eax
  8010d5:	68 96 28 80 00       	push   $0x802896
  8010da:	68 aa 00 00 00       	push   $0xaa
  8010df:	68 a4 2d 80 00       	push   $0x802da4
  8010e4:	e8 6a f1 ff ff       	call   800253 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	6a 05                	push   $0x5
  8010ee:	53                   	push   %ebx
  8010ef:	57                   	push   %edi
  8010f0:	53                   	push   %ebx
  8010f1:	6a 00                	push   $0x0
  8010f3:	e8 47 fc ff ff       	call   800d3f <sys_page_map>
  8010f8:	83 c4 20             	add    $0x20,%esp
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	79 4d                	jns    80114c <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010ff:	50                   	push   %eax
  801100:	68 cd 2d 80 00       	push   $0x802dcd
  801105:	6a 61                	push   $0x61
  801107:	68 a4 2d 80 00       	push   $0x802da4
  80110c:	e8 42 f1 ff ff       	call   800253 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	68 05 08 00 00       	push   $0x805
  801119:	53                   	push   %ebx
  80111a:	57                   	push   %edi
  80111b:	53                   	push   %ebx
  80111c:	6a 00                	push   $0x0
  80111e:	e8 1c fc ff ff       	call   800d3f <sys_page_map>
  801123:	83 c4 20             	add    $0x20,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	0f 88 b7 00 00 00    	js     8011e5 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  80112e:	83 ec 0c             	sub    $0xc,%esp
  801131:	68 05 08 00 00       	push   $0x805
  801136:	53                   	push   %ebx
  801137:	6a 00                	push   $0x0
  801139:	53                   	push   %ebx
  80113a:	6a 00                	push   $0x0
  80113c:	e8 fe fb ff ff       	call   800d3f <sys_page_map>
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	0f 88 ab 00 00 00    	js     8011f7 <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80114c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801152:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801158:	0f 84 ab 00 00 00    	je     801209 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  80115e:	89 d8                	mov    %ebx,%eax
  801160:	c1 e8 16             	shr    $0x16,%eax
  801163:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80116a:	a8 01                	test   $0x1,%al
  80116c:	74 de                	je     80114c <fork+0xc9>
  80116e:	89 d8                	mov    %ebx,%eax
  801170:	c1 e8 0c             	shr    $0xc,%eax
  801173:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 cd                	je     80114c <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  80117f:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801182:	89 c2                	mov    %eax,%edx
  801184:	c1 ea 16             	shr    $0x16,%edx
  801187:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80118e:	f6 c2 01             	test   $0x1,%dl
  801191:	74 b9                	je     80114c <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801193:	c1 e8 0c             	shr    $0xc,%eax
  801196:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  80119d:	a8 01                	test   $0x1,%al
  80119f:	74 ab                	je     80114c <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  8011a1:	a9 02 08 00 00       	test   $0x802,%eax
  8011a6:	0f 84 3d ff ff ff    	je     8010e9 <fork+0x66>
	else if(pte & PTE_SHARE)
  8011ac:	f6 c4 04             	test   $0x4,%ah
  8011af:	0f 84 5c ff ff ff    	je     801111 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bd:	50                   	push   %eax
  8011be:	53                   	push   %ebx
  8011bf:	57                   	push   %edi
  8011c0:	53                   	push   %ebx
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 77 fb ff ff       	call   800d3f <sys_page_map>
  8011c8:	83 c4 20             	add    $0x20,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	0f 89 79 ff ff ff    	jns    80114c <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8011d3:	50                   	push   %eax
  8011d4:	68 cd 2d 80 00       	push   $0x802dcd
  8011d9:	6a 67                	push   $0x67
  8011db:	68 a4 2d 80 00       	push   $0x802da4
  8011e0:	e8 6e f0 ff ff       	call   800253 <_panic>
			panic("Page Map Failed: %e", error_code);
  8011e5:	50                   	push   %eax
  8011e6:	68 cd 2d 80 00       	push   $0x802dcd
  8011eb:	6a 6d                	push   $0x6d
  8011ed:	68 a4 2d 80 00       	push   $0x802da4
  8011f2:	e8 5c f0 ff ff       	call   800253 <_panic>
			panic("Page Map Failed: %e", error_code);
  8011f7:	50                   	push   %eax
  8011f8:	68 cd 2d 80 00       	push   $0x802dcd
  8011fd:	6a 70                	push   $0x70
  8011ff:	68 a4 2d 80 00       	push   $0x802da4
  801204:	e8 4a f0 ff ff       	call   800253 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	6a 07                	push   $0x7
  80120e:	68 00 f0 bf ee       	push   $0xeebff000
  801213:	ff 75 e4             	pushl  -0x1c(%ebp)
  801216:	e8 e1 fa ff ff       	call   800cfc <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 36                	js     801258 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	68 dd 25 80 00       	push   $0x8025dd
  80122a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80122d:	e8 15 fc ff ff       	call   800e47 <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 34                	js     80126d <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	6a 02                	push   $0x2
  80123e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801241:	e8 7d fb ff ff       	call   800dc3 <sys_env_set_status>
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 35                	js     801282 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  80124d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801258:	50                   	push   %eax
  801259:	68 96 28 80 00       	push   $0x802896
  80125e:	68 ba 00 00 00       	push   $0xba
  801263:	68 a4 2d 80 00       	push   $0x802da4
  801268:	e8 e6 ef ff ff       	call   800253 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80126d:	50                   	push   %eax
  80126e:	68 80 2d 80 00       	push   $0x802d80
  801273:	68 bf 00 00 00       	push   $0xbf
  801278:	68 a4 2d 80 00       	push   $0x802da4
  80127d:	e8 d1 ef ff ff       	call   800253 <_panic>
      panic("sys_env_set_status: %e", r);
  801282:	50                   	push   %eax
  801283:	68 e1 2d 80 00       	push   $0x802de1
  801288:	68 c3 00 00 00       	push   $0xc3
  80128d:	68 a4 2d 80 00       	push   $0x802da4
  801292:	e8 bc ef ff ff       	call   800253 <_panic>

00801297 <sfork>:

// Challenge!
int
sfork(void)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80129d:	68 f8 2d 80 00       	push   $0x802df8
  8012a2:	68 cc 00 00 00       	push   $0xcc
  8012a7:	68 a4 2d 80 00       	push   $0x802da4
  8012ac:	e8 a2 ef ff ff       	call   800253 <_panic>

008012b1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	74 4f                	je     801312 <ipc_recv+0x61>
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	50                   	push   %eax
  8012c7:	e8 e0 fb ff ff       	call   800eac <sys_ipc_recv>
  8012cc:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8012cf:	85 f6                	test   %esi,%esi
  8012d1:	74 14                	je     8012e7 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	75 09                	jne    8012e5 <ipc_recv+0x34>
  8012dc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8012e2:	8b 52 74             	mov    0x74(%edx),%edx
  8012e5:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8012e7:	85 db                	test   %ebx,%ebx
  8012e9:	74 14                	je     8012ff <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8012eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	75 09                	jne    8012fd <ipc_recv+0x4c>
  8012f4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8012fa:	8b 52 78             	mov    0x78(%edx),%edx
  8012fd:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8012ff:	85 c0                	test   %eax,%eax
  801301:	75 08                	jne    80130b <ipc_recv+0x5a>
  801303:	a1 08 40 80 00       	mov    0x804008,%eax
  801308:	8b 40 70             	mov    0x70(%eax),%eax
}
  80130b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130e:	5b                   	pop    %ebx
  80130f:	5e                   	pop    %esi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	68 00 00 c0 ee       	push   $0xeec00000
  80131a:	e8 8d fb ff ff       	call   800eac <sys_ipc_recv>
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	eb ab                	jmp    8012cf <ipc_recv+0x1e>

00801324 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	57                   	push   %edi
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
  80132a:	83 ec 0c             	sub    $0xc,%esp
  80132d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801330:	8b 75 10             	mov    0x10(%ebp),%esi
  801333:	eb 20                	jmp    801355 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801335:	6a 00                	push   $0x0
  801337:	68 00 00 c0 ee       	push   $0xeec00000
  80133c:	ff 75 0c             	pushl  0xc(%ebp)
  80133f:	57                   	push   %edi
  801340:	e8 44 fb ff ff       	call   800e89 <sys_ipc_try_send>
  801345:	89 c3                	mov    %eax,%ebx
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	eb 1f                	jmp    80136b <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80134c:	e8 8c f9 ff ff       	call   800cdd <sys_yield>
	while(retval != 0) {
  801351:	85 db                	test   %ebx,%ebx
  801353:	74 33                	je     801388 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801355:	85 f6                	test   %esi,%esi
  801357:	74 dc                	je     801335 <ipc_send+0x11>
  801359:	ff 75 14             	pushl  0x14(%ebp)
  80135c:	56                   	push   %esi
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	57                   	push   %edi
  801361:	e8 23 fb ff ff       	call   800e89 <sys_ipc_try_send>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80136b:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80136e:	74 dc                	je     80134c <ipc_send+0x28>
  801370:	85 db                	test   %ebx,%ebx
  801372:	74 d8                	je     80134c <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	68 10 2e 80 00       	push   $0x802e10
  80137c:	6a 35                	push   $0x35
  80137e:	68 40 2e 80 00       	push   $0x802e40
  801383:	e8 cb ee ff ff       	call   800253 <_panic>
	}
}
  801388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80139b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80139e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013a4:	8b 52 50             	mov    0x50(%edx),%edx
  8013a7:	39 ca                	cmp    %ecx,%edx
  8013a9:	74 11                	je     8013bc <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8013ab:	83 c0 01             	add    $0x1,%eax
  8013ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013b3:	75 e6                	jne    80139b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	eb 0b                	jmp    8013c7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8013bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    

008013c9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	05 00 00 00 30       	add    $0x30000000,%eax
  8013d4:	c1 e8 0c             	shr    $0xc,%eax
}
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    

008013d9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	c1 ea 16             	shr    $0x16,%edx
  8013fd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801404:	f6 c2 01             	test   $0x1,%dl
  801407:	74 2d                	je     801436 <fd_alloc+0x46>
  801409:	89 c2                	mov    %eax,%edx
  80140b:	c1 ea 0c             	shr    $0xc,%edx
  80140e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801415:	f6 c2 01             	test   $0x1,%dl
  801418:	74 1c                	je     801436 <fd_alloc+0x46>
  80141a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80141f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801424:	75 d2                	jne    8013f8 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80142f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801434:	eb 0a                	jmp    801440 <fd_alloc+0x50>
			*fd_store = fd;
  801436:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801439:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801448:	83 f8 1f             	cmp    $0x1f,%eax
  80144b:	77 30                	ja     80147d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80144d:	c1 e0 0c             	shl    $0xc,%eax
  801450:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801455:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80145b:	f6 c2 01             	test   $0x1,%dl
  80145e:	74 24                	je     801484 <fd_lookup+0x42>
  801460:	89 c2                	mov    %eax,%edx
  801462:	c1 ea 0c             	shr    $0xc,%edx
  801465:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80146c:	f6 c2 01             	test   $0x1,%dl
  80146f:	74 1a                	je     80148b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	89 02                	mov    %eax,(%edx)
	return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    
		return -E_INVAL;
  80147d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801482:	eb f7                	jmp    80147b <fd_lookup+0x39>
		return -E_INVAL;
  801484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801489:	eb f0                	jmp    80147b <fd_lookup+0x39>
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb e9                	jmp    80147b <fd_lookup+0x39>

00801492 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80149b:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014a5:	39 08                	cmp    %ecx,(%eax)
  8014a7:	74 38                	je     8014e1 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8014a9:	83 c2 01             	add    $0x1,%edx
  8014ac:	8b 04 95 cc 2e 80 00 	mov    0x802ecc(,%edx,4),%eax
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 ee                	jne    8014a5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014bc:	8b 40 48             	mov    0x48(%eax),%eax
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	51                   	push   %ecx
  8014c3:	50                   	push   %eax
  8014c4:	68 4c 2e 80 00       	push   $0x802e4c
  8014c9:	e8 60 ee ff ff       	call   80032e <cprintf>
	*dev = 0;
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    
			*dev = devtab[i];
  8014e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	eb f2                	jmp    8014df <dev_lookup+0x4d>

008014ed <fd_close>:
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 24             	sub    $0x24,%esp
  8014f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8014f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ff:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801500:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801506:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801509:	50                   	push   %eax
  80150a:	e8 33 ff ff ff       	call   801442 <fd_lookup>
  80150f:	89 c3                	mov    %eax,%ebx
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	78 05                	js     80151d <fd_close+0x30>
	    || fd != fd2)
  801518:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80151b:	74 16                	je     801533 <fd_close+0x46>
		return (must_exist ? r : 0);
  80151d:	89 f8                	mov    %edi,%eax
  80151f:	84 c0                	test   %al,%al
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	0f 44 d8             	cmove  %eax,%ebx
}
  801529:	89 d8                	mov    %ebx,%eax
  80152b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152e:	5b                   	pop    %ebx
  80152f:	5e                   	pop    %esi
  801530:	5f                   	pop    %edi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	ff 36                	pushl  (%esi)
  80153c:	e8 51 ff ff ff       	call   801492 <dev_lookup>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 1a                	js     801564 <fd_close+0x77>
		if (dev->dev_close)
  80154a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801550:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801555:	85 c0                	test   %eax,%eax
  801557:	74 0b                	je     801564 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	56                   	push   %esi
  80155d:	ff d0                	call   *%eax
  80155f:	89 c3                	mov    %eax,%ebx
  801561:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801564:	83 ec 08             	sub    $0x8,%esp
  801567:	56                   	push   %esi
  801568:	6a 00                	push   $0x0
  80156a:	e8 12 f8 ff ff       	call   800d81 <sys_page_unmap>
	return r;
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	eb b5                	jmp    801529 <fd_close+0x3c>

00801574 <close>:

int
close(int fdnum)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157d:	50                   	push   %eax
  80157e:	ff 75 08             	pushl  0x8(%ebp)
  801581:	e8 bc fe ff ff       	call   801442 <fd_lookup>
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	79 02                	jns    80158f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    
		return fd_close(fd, 1);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	6a 01                	push   $0x1
  801594:	ff 75 f4             	pushl  -0xc(%ebp)
  801597:	e8 51 ff ff ff       	call   8014ed <fd_close>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	eb ec                	jmp    80158d <close+0x19>

008015a1 <close_all>:

void
close_all(void)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015a8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015ad:	83 ec 0c             	sub    $0xc,%esp
  8015b0:	53                   	push   %ebx
  8015b1:	e8 be ff ff ff       	call   801574 <close>
	for (i = 0; i < MAXFD; i++)
  8015b6:	83 c3 01             	add    $0x1,%ebx
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	83 fb 20             	cmp    $0x20,%ebx
  8015bf:	75 ec                	jne    8015ad <close_all+0xc>
}
  8015c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	57                   	push   %edi
  8015ca:	56                   	push   %esi
  8015cb:	53                   	push   %ebx
  8015cc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 08             	pushl  0x8(%ebp)
  8015d6:	e8 67 fe ff ff       	call   801442 <fd_lookup>
  8015db:	89 c3                	mov    %eax,%ebx
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	0f 88 81 00 00 00    	js     801669 <dup+0xa3>
		return r;
	close(newfdnum);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ee:	e8 81 ff ff ff       	call   801574 <close>

	newfd = INDEX2FD(newfdnum);
  8015f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015f6:	c1 e6 0c             	shl    $0xc,%esi
  8015f9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015ff:	83 c4 04             	add    $0x4,%esp
  801602:	ff 75 e4             	pushl  -0x1c(%ebp)
  801605:	e8 cf fd ff ff       	call   8013d9 <fd2data>
  80160a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80160c:	89 34 24             	mov    %esi,(%esp)
  80160f:	e8 c5 fd ff ff       	call   8013d9 <fd2data>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801619:	89 d8                	mov    %ebx,%eax
  80161b:	c1 e8 16             	shr    $0x16,%eax
  80161e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801625:	a8 01                	test   $0x1,%al
  801627:	74 11                	je     80163a <dup+0x74>
  801629:	89 d8                	mov    %ebx,%eax
  80162b:	c1 e8 0c             	shr    $0xc,%eax
  80162e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	75 39                	jne    801673 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80163a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80163d:	89 d0                	mov    %edx,%eax
  80163f:	c1 e8 0c             	shr    $0xc,%eax
  801642:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	25 07 0e 00 00       	and    $0xe07,%eax
  801651:	50                   	push   %eax
  801652:	56                   	push   %esi
  801653:	6a 00                	push   $0x0
  801655:	52                   	push   %edx
  801656:	6a 00                	push   $0x0
  801658:	e8 e2 f6 ff ff       	call   800d3f <sys_page_map>
  80165d:	89 c3                	mov    %eax,%ebx
  80165f:	83 c4 20             	add    $0x20,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 31                	js     801697 <dup+0xd1>
		goto err;

	return newfdnum;
  801666:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801669:	89 d8                	mov    %ebx,%eax
  80166b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5e                   	pop    %esi
  801670:	5f                   	pop    %edi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801673:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	25 07 0e 00 00       	and    $0xe07,%eax
  801682:	50                   	push   %eax
  801683:	57                   	push   %edi
  801684:	6a 00                	push   $0x0
  801686:	53                   	push   %ebx
  801687:	6a 00                	push   $0x0
  801689:	e8 b1 f6 ff ff       	call   800d3f <sys_page_map>
  80168e:	89 c3                	mov    %eax,%ebx
  801690:	83 c4 20             	add    $0x20,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	79 a3                	jns    80163a <dup+0x74>
	sys_page_unmap(0, newfd);
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	56                   	push   %esi
  80169b:	6a 00                	push   $0x0
  80169d:	e8 df f6 ff ff       	call   800d81 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	57                   	push   %edi
  8016a6:	6a 00                	push   $0x0
  8016a8:	e8 d4 f6 ff ff       	call   800d81 <sys_page_unmap>
	return r;
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	eb b7                	jmp    801669 <dup+0xa3>

008016b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  8016c1:	e8 7c fd ff ff       	call   801442 <fd_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 3f                	js     80170c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d3:	50                   	push   %eax
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d7:	ff 30                	pushl  (%eax)
  8016d9:	e8 b4 fd ff ff       	call   801492 <dev_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 27                	js     80170c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e8:	8b 42 08             	mov    0x8(%edx),%eax
  8016eb:	83 e0 03             	and    $0x3,%eax
  8016ee:	83 f8 01             	cmp    $0x1,%eax
  8016f1:	74 1e                	je     801711 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	8b 40 08             	mov    0x8(%eax),%eax
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	74 35                	je     801732 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	ff 75 10             	pushl  0x10(%ebp)
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	52                   	push   %edx
  801707:	ff d0                	call   *%eax
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170f:	c9                   	leave  
  801710:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801711:	a1 08 40 80 00       	mov    0x804008,%eax
  801716:	8b 40 48             	mov    0x48(%eax),%eax
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	53                   	push   %ebx
  80171d:	50                   	push   %eax
  80171e:	68 90 2e 80 00       	push   $0x802e90
  801723:	e8 06 ec ff ff       	call   80032e <cprintf>
		return -E_INVAL;
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801730:	eb da                	jmp    80170c <read+0x5a>
		return -E_NOT_SUPP;
  801732:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801737:	eb d3                	jmp    80170c <read+0x5a>

00801739 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	57                   	push   %edi
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	8b 7d 08             	mov    0x8(%ebp),%edi
  801745:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801748:	bb 00 00 00 00       	mov    $0x0,%ebx
  80174d:	39 f3                	cmp    %esi,%ebx
  80174f:	73 23                	jae    801774 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	89 f0                	mov    %esi,%eax
  801756:	29 d8                	sub    %ebx,%eax
  801758:	50                   	push   %eax
  801759:	89 d8                	mov    %ebx,%eax
  80175b:	03 45 0c             	add    0xc(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	57                   	push   %edi
  801760:	e8 4d ff ff ff       	call   8016b2 <read>
		if (m < 0)
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 06                	js     801772 <readn+0x39>
			return m;
		if (m == 0)
  80176c:	74 06                	je     801774 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80176e:	01 c3                	add    %eax,%ebx
  801770:	eb db                	jmp    80174d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801772:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801774:	89 d8                	mov    %ebx,%eax
  801776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801779:	5b                   	pop    %ebx
  80177a:	5e                   	pop    %esi
  80177b:	5f                   	pop    %edi
  80177c:	5d                   	pop    %ebp
  80177d:	c3                   	ret    

0080177e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	53                   	push   %ebx
  801782:	83 ec 1c             	sub    $0x1c,%esp
  801785:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801788:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178b:	50                   	push   %eax
  80178c:	53                   	push   %ebx
  80178d:	e8 b0 fc ff ff       	call   801442 <fd_lookup>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 3a                	js     8017d3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	ff 30                	pushl  (%eax)
  8017a5:	e8 e8 fc ff ff       	call   801492 <dev_lookup>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 22                	js     8017d3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017b8:	74 1e                	je     8017d8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c0:	85 d2                	test   %edx,%edx
  8017c2:	74 35                	je     8017f9 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	ff 75 10             	pushl  0x10(%ebp)
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	50                   	push   %eax
  8017ce:	ff d2                	call   *%edx
  8017d0:	83 c4 10             	add    $0x10,%esp
}
  8017d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017d8:	a1 08 40 80 00       	mov    0x804008,%eax
  8017dd:	8b 40 48             	mov    0x48(%eax),%eax
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	53                   	push   %ebx
  8017e4:	50                   	push   %eax
  8017e5:	68 ac 2e 80 00       	push   $0x802eac
  8017ea:	e8 3f eb ff ff       	call   80032e <cprintf>
		return -E_INVAL;
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f7:	eb da                	jmp    8017d3 <write+0x55>
		return -E_NOT_SUPP;
  8017f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017fe:	eb d3                	jmp    8017d3 <write+0x55>

00801800 <seek>:

int
seek(int fdnum, off_t offset)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801809:	50                   	push   %eax
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	e8 30 fc ff ff       	call   801442 <fd_lookup>
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 0e                	js     801827 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	53                   	push   %ebx
  80182d:	83 ec 1c             	sub    $0x1c,%esp
  801830:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801833:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	53                   	push   %ebx
  801838:	e8 05 fc ff ff       	call   801442 <fd_lookup>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 37                	js     80187b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184a:	50                   	push   %eax
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184e:	ff 30                	pushl  (%eax)
  801850:	e8 3d fc ff ff       	call   801492 <dev_lookup>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 1f                	js     80187b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801863:	74 1b                	je     801880 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801868:	8b 52 18             	mov    0x18(%edx),%edx
  80186b:	85 d2                	test   %edx,%edx
  80186d:	74 32                	je     8018a1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	50                   	push   %eax
  801876:	ff d2                	call   *%edx
  801878:	83 c4 10             	add    $0x10,%esp
}
  80187b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801880:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801885:	8b 40 48             	mov    0x48(%eax),%eax
  801888:	83 ec 04             	sub    $0x4,%esp
  80188b:	53                   	push   %ebx
  80188c:	50                   	push   %eax
  80188d:	68 6c 2e 80 00       	push   $0x802e6c
  801892:	e8 97 ea ff ff       	call   80032e <cprintf>
		return -E_INVAL;
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189f:	eb da                	jmp    80187b <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a6:	eb d3                	jmp    80187b <ftruncate+0x52>

008018a8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 1c             	sub    $0x1c,%esp
  8018af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b5:	50                   	push   %eax
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	e8 84 fb ff ff       	call   801442 <fd_lookup>
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 4b                	js     801910 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	ff 30                	pushl  (%eax)
  8018d1:	e8 bc fb ff ff       	call   801492 <dev_lookup>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 33                	js     801910 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e4:	74 2f                	je     801915 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018e9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018f0:	00 00 00 
	stat->st_isdir = 0;
  8018f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fa:	00 00 00 
	stat->st_dev = dev;
  8018fd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	53                   	push   %ebx
  801907:	ff 75 f0             	pushl  -0x10(%ebp)
  80190a:	ff 50 14             	call   *0x14(%eax)
  80190d:	83 c4 10             	add    $0x10,%esp
}
  801910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801913:	c9                   	leave  
  801914:	c3                   	ret    
		return -E_NOT_SUPP;
  801915:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191a:	eb f4                	jmp    801910 <fstat+0x68>

0080191c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	6a 00                	push   $0x0
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	e8 2f 02 00 00       	call   801b5d <open>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	78 1b                	js     801952 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	50                   	push   %eax
  80193e:	e8 65 ff ff ff       	call   8018a8 <fstat>
  801943:	89 c6                	mov    %eax,%esi
	close(fd);
  801945:	89 1c 24             	mov    %ebx,(%esp)
  801948:	e8 27 fc ff ff       	call   801574 <close>
	return r;
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	89 f3                	mov    %esi,%ebx
}
  801952:	89 d8                	mov    %ebx,%eax
  801954:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	89 c6                	mov    %eax,%esi
  801962:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801964:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80196b:	74 27                	je     801994 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80196d:	6a 07                	push   $0x7
  80196f:	68 00 50 80 00       	push   $0x805000
  801974:	56                   	push   %esi
  801975:	ff 35 00 40 80 00    	pushl  0x804000
  80197b:	e8 a4 f9 ff ff       	call   801324 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801980:	83 c4 0c             	add    $0xc,%esp
  801983:	6a 00                	push   $0x0
  801985:	53                   	push   %ebx
  801986:	6a 00                	push   $0x0
  801988:	e8 24 f9 ff ff       	call   8012b1 <ipc_recv>
}
  80198d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	6a 01                	push   $0x1
  801999:	e8 f2 f9 ff ff       	call   801390 <ipc_find_env>
  80199e:	a3 00 40 80 00       	mov    %eax,0x804000
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	eb c5                	jmp    80196d <fsipc+0x12>

008019a8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	b8 02 00 00 00       	mov    $0x2,%eax
  8019cb:	e8 8b ff ff ff       	call   80195b <fsipc>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <devfile_flush>:
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	8b 40 0c             	mov    0xc(%eax),%eax
  8019de:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8019ed:	e8 69 ff ff ff       	call   80195b <fsipc>
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <devfile_stat>:
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	53                   	push   %ebx
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	8b 40 0c             	mov    0xc(%eax),%eax
  801a04:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a09:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0e:	b8 05 00 00 00       	mov    $0x5,%eax
  801a13:	e8 43 ff ff ff       	call   80195b <fsipc>
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 2c                	js     801a48 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	68 00 50 80 00       	push   $0x805000
  801a24:	53                   	push   %ebx
  801a25:	e8 e0 ee ff ff       	call   80090a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a2a:	a1 80 50 80 00       	mov    0x805080,%eax
  801a2f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a35:	a1 84 50 80 00       	mov    0x805084,%eax
  801a3a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <devfile_write>:
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	53                   	push   %ebx
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801a57:	85 db                	test   %ebx,%ebx
  801a59:	75 07                	jne    801a62 <devfile_write+0x15>
	return n_all;
  801a5b:	89 d8                	mov    %ebx,%eax
}
  801a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	8b 40 0c             	mov    0xc(%eax),%eax
  801a68:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801a6d:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	53                   	push   %ebx
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	68 08 50 80 00       	push   $0x805008
  801a7f:	e8 14 f0 ff ff       	call   800a98 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a84:	ba 00 00 00 00       	mov    $0x0,%edx
  801a89:	b8 04 00 00 00       	mov    $0x4,%eax
  801a8e:	e8 c8 fe ff ff       	call   80195b <fsipc>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 c3                	js     801a5d <devfile_write+0x10>
	  assert(r <= n_left);
  801a9a:	39 d8                	cmp    %ebx,%eax
  801a9c:	77 0b                	ja     801aa9 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801a9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa3:	7f 1d                	jg     801ac2 <devfile_write+0x75>
    n_all += r;
  801aa5:	89 c3                	mov    %eax,%ebx
  801aa7:	eb b2                	jmp    801a5b <devfile_write+0xe>
	  assert(r <= n_left);
  801aa9:	68 e0 2e 80 00       	push   $0x802ee0
  801aae:	68 ec 2e 80 00       	push   $0x802eec
  801ab3:	68 9f 00 00 00       	push   $0x9f
  801ab8:	68 01 2f 80 00       	push   $0x802f01
  801abd:	e8 91 e7 ff ff       	call   800253 <_panic>
	  assert(r <= PGSIZE);
  801ac2:	68 0c 2f 80 00       	push   $0x802f0c
  801ac7:	68 ec 2e 80 00       	push   $0x802eec
  801acc:	68 a0 00 00 00       	push   $0xa0
  801ad1:	68 01 2f 80 00       	push   $0x802f01
  801ad6:	e8 78 e7 ff ff       	call   800253 <_panic>

00801adb <devfile_read>:
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aee:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801af4:	ba 00 00 00 00       	mov    $0x0,%edx
  801af9:	b8 03 00 00 00       	mov    $0x3,%eax
  801afe:	e8 58 fe ff ff       	call   80195b <fsipc>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 1f                	js     801b28 <devfile_read+0x4d>
	assert(r <= n);
  801b09:	39 f0                	cmp    %esi,%eax
  801b0b:	77 24                	ja     801b31 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b12:	7f 33                	jg     801b47 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	50                   	push   %eax
  801b18:	68 00 50 80 00       	push   $0x805000
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	e8 73 ef ff ff       	call   800a98 <memmove>
	return r;
  801b25:	83 c4 10             	add    $0x10,%esp
}
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    
	assert(r <= n);
  801b31:	68 18 2f 80 00       	push   $0x802f18
  801b36:	68 ec 2e 80 00       	push   $0x802eec
  801b3b:	6a 7c                	push   $0x7c
  801b3d:	68 01 2f 80 00       	push   $0x802f01
  801b42:	e8 0c e7 ff ff       	call   800253 <_panic>
	assert(r <= PGSIZE);
  801b47:	68 0c 2f 80 00       	push   $0x802f0c
  801b4c:	68 ec 2e 80 00       	push   $0x802eec
  801b51:	6a 7d                	push   $0x7d
  801b53:	68 01 2f 80 00       	push   $0x802f01
  801b58:	e8 f6 e6 ff ff       	call   800253 <_panic>

00801b5d <open>:
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	83 ec 1c             	sub    $0x1c,%esp
  801b65:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b68:	56                   	push   %esi
  801b69:	e8 63 ed ff ff       	call   8008d1 <strlen>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b76:	7f 6c                	jg     801be4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7e:	50                   	push   %eax
  801b7f:	e8 6c f8 ff ff       	call   8013f0 <fd_alloc>
  801b84:	89 c3                	mov    %eax,%ebx
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 3c                	js     801bc9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	56                   	push   %esi
  801b91:	68 00 50 80 00       	push   $0x805000
  801b96:	e8 6f ed ff ff       	call   80090a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	e8 ab fd ff ff       	call   80195b <fsipc>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 19                	js     801bd2 <open+0x75>
	return fd2num(fd);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	e8 05 f8 ff ff       	call   8013c9 <fd2num>
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	83 c4 10             	add    $0x10,%esp
}
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    
		fd_close(fd, 0);
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bda:	e8 0e f9 ff ff       	call   8014ed <fd_close>
		return r;
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	eb e5                	jmp    801bc9 <open+0x6c>
		return -E_BAD_PATH;
  801be4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801be9:	eb de                	jmp    801bc9 <open+0x6c>

00801beb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf6:	b8 08 00 00 00       	mov    $0x8,%eax
  801bfb:	e8 5b fd ff ff       	call   80195b <fsipc>
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	c1 e8 16             	shr    $0x16,%eax
  801c0d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801c19:	f6 c1 01             	test   $0x1,%cl
  801c1c:	74 1d                	je     801c3b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801c1e:	c1 ea 0c             	shr    $0xc,%edx
  801c21:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c28:	f6 c2 01             	test   $0x1,%dl
  801c2b:	74 0e                	je     801c3b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c2d:	c1 ea 0c             	shr    $0xc,%edx
  801c30:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c37:	ef 
  801c38:	0f b7 c0             	movzwl %ax,%eax
}
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    

00801c3d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	e8 89 f7 ff ff       	call   8013d9 <fd2data>
  801c50:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c52:	83 c4 08             	add    $0x8,%esp
  801c55:	68 1f 2f 80 00       	push   $0x802f1f
  801c5a:	53                   	push   %ebx
  801c5b:	e8 aa ec ff ff       	call   80090a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c60:	8b 46 04             	mov    0x4(%esi),%eax
  801c63:	2b 06                	sub    (%esi),%eax
  801c65:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c72:	00 00 00 
	stat->st_dev = &devpipe;
  801c75:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c7c:	30 80 00 
	return 0;
}
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    

00801c8b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	53                   	push   %ebx
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c95:	53                   	push   %ebx
  801c96:	6a 00                	push   $0x0
  801c98:	e8 e4 f0 ff ff       	call   800d81 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c9d:	89 1c 24             	mov    %ebx,(%esp)
  801ca0:	e8 34 f7 ff ff       	call   8013d9 <fd2data>
  801ca5:	83 c4 08             	add    $0x8,%esp
  801ca8:	50                   	push   %eax
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 d1 f0 ff ff       	call   800d81 <sys_page_unmap>
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <_pipeisclosed>:
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 1c             	sub    $0x1c,%esp
  801cbe:	89 c7                	mov    %eax,%edi
  801cc0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc2:	a1 08 40 80 00       	mov    0x804008,%eax
  801cc7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	57                   	push   %edi
  801cce:	e8 2f ff ff ff       	call   801c02 <pageref>
  801cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd6:	89 34 24             	mov    %esi,(%esp)
  801cd9:	e8 24 ff ff ff       	call   801c02 <pageref>
		nn = thisenv->env_runs;
  801cde:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	39 cb                	cmp    %ecx,%ebx
  801cec:	74 1b                	je     801d09 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf1:	75 cf                	jne    801cc2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf3:	8b 42 58             	mov    0x58(%edx),%eax
  801cf6:	6a 01                	push   $0x1
  801cf8:	50                   	push   %eax
  801cf9:	53                   	push   %ebx
  801cfa:	68 26 2f 80 00       	push   $0x802f26
  801cff:	e8 2a e6 ff ff       	call   80032e <cprintf>
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	eb b9                	jmp    801cc2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d09:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d0c:	0f 94 c0             	sete   %al
  801d0f:	0f b6 c0             	movzbl %al,%eax
}
  801d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5f                   	pop    %edi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    

00801d1a <devpipe_write>:
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	57                   	push   %edi
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 28             	sub    $0x28,%esp
  801d23:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d26:	56                   	push   %esi
  801d27:	e8 ad f6 ff ff       	call   8013d9 <fd2data>
  801d2c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	bf 00 00 00 00       	mov    $0x0,%edi
  801d36:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d39:	74 4f                	je     801d8a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d3b:	8b 43 04             	mov    0x4(%ebx),%eax
  801d3e:	8b 0b                	mov    (%ebx),%ecx
  801d40:	8d 51 20             	lea    0x20(%ecx),%edx
  801d43:	39 d0                	cmp    %edx,%eax
  801d45:	72 14                	jb     801d5b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d47:	89 da                	mov    %ebx,%edx
  801d49:	89 f0                	mov    %esi,%eax
  801d4b:	e8 65 ff ff ff       	call   801cb5 <_pipeisclosed>
  801d50:	85 c0                	test   %eax,%eax
  801d52:	75 3b                	jne    801d8f <devpipe_write+0x75>
			sys_yield();
  801d54:	e8 84 ef ff ff       	call   800cdd <sys_yield>
  801d59:	eb e0                	jmp    801d3b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d5e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d62:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d65:	89 c2                	mov    %eax,%edx
  801d67:	c1 fa 1f             	sar    $0x1f,%edx
  801d6a:	89 d1                	mov    %edx,%ecx
  801d6c:	c1 e9 1b             	shr    $0x1b,%ecx
  801d6f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d72:	83 e2 1f             	and    $0x1f,%edx
  801d75:	29 ca                	sub    %ecx,%edx
  801d77:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d7b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d7f:	83 c0 01             	add    $0x1,%eax
  801d82:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d85:	83 c7 01             	add    $0x1,%edi
  801d88:	eb ac                	jmp    801d36 <devpipe_write+0x1c>
	return i;
  801d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8d:	eb 05                	jmp    801d94 <devpipe_write+0x7a>
				return 0;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    

00801d9c <devpipe_read>:
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	57                   	push   %edi
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	83 ec 18             	sub    $0x18,%esp
  801da5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801da8:	57                   	push   %edi
  801da9:	e8 2b f6 ff ff       	call   8013d9 <fd2data>
  801dae:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	be 00 00 00 00       	mov    $0x0,%esi
  801db8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dbb:	75 14                	jne    801dd1 <devpipe_read+0x35>
	return i;
  801dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc0:	eb 02                	jmp    801dc4 <devpipe_read+0x28>
				return i;
  801dc2:	89 f0                	mov    %esi,%eax
}
  801dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    
			sys_yield();
  801dcc:	e8 0c ef ff ff       	call   800cdd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dd1:	8b 03                	mov    (%ebx),%eax
  801dd3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd6:	75 18                	jne    801df0 <devpipe_read+0x54>
			if (i > 0)
  801dd8:	85 f6                	test   %esi,%esi
  801dda:	75 e6                	jne    801dc2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ddc:	89 da                	mov    %ebx,%edx
  801dde:	89 f8                	mov    %edi,%eax
  801de0:	e8 d0 fe ff ff       	call   801cb5 <_pipeisclosed>
  801de5:	85 c0                	test   %eax,%eax
  801de7:	74 e3                	je     801dcc <devpipe_read+0x30>
				return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	eb d4                	jmp    801dc4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df0:	99                   	cltd   
  801df1:	c1 ea 1b             	shr    $0x1b,%edx
  801df4:	01 d0                	add    %edx,%eax
  801df6:	83 e0 1f             	and    $0x1f,%eax
  801df9:	29 d0                	sub    %edx,%eax
  801dfb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e03:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e06:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e09:	83 c6 01             	add    $0x1,%esi
  801e0c:	eb aa                	jmp    801db8 <devpipe_read+0x1c>

00801e0e <pipe>:
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	56                   	push   %esi
  801e12:	53                   	push   %ebx
  801e13:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e19:	50                   	push   %eax
  801e1a:	e8 d1 f5 ff ff       	call   8013f0 <fd_alloc>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	0f 88 23 01 00 00    	js     801f4f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2c:	83 ec 04             	sub    $0x4,%esp
  801e2f:	68 07 04 00 00       	push   $0x407
  801e34:	ff 75 f4             	pushl  -0xc(%ebp)
  801e37:	6a 00                	push   $0x0
  801e39:	e8 be ee ff ff       	call   800cfc <sys_page_alloc>
  801e3e:	89 c3                	mov    %eax,%ebx
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	0f 88 04 01 00 00    	js     801f4f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e51:	50                   	push   %eax
  801e52:	e8 99 f5 ff ff       	call   8013f0 <fd_alloc>
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	0f 88 db 00 00 00    	js     801f3f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	68 07 04 00 00       	push   $0x407
  801e6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6f:	6a 00                	push   $0x0
  801e71:	e8 86 ee ff ff       	call   800cfc <sys_page_alloc>
  801e76:	89 c3                	mov    %eax,%ebx
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	0f 88 bc 00 00 00    	js     801f3f <pipe+0x131>
	va = fd2data(fd0);
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	ff 75 f4             	pushl  -0xc(%ebp)
  801e89:	e8 4b f5 ff ff       	call   8013d9 <fd2data>
  801e8e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e90:	83 c4 0c             	add    $0xc,%esp
  801e93:	68 07 04 00 00       	push   $0x407
  801e98:	50                   	push   %eax
  801e99:	6a 00                	push   $0x0
  801e9b:	e8 5c ee ff ff       	call   800cfc <sys_page_alloc>
  801ea0:	89 c3                	mov    %eax,%ebx
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	0f 88 82 00 00 00    	js     801f2f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb3:	e8 21 f5 ff ff       	call   8013d9 <fd2data>
  801eb8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ebf:	50                   	push   %eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	56                   	push   %esi
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 75 ee ff ff       	call   800d3f <sys_page_map>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 20             	add    $0x20,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 4e                	js     801f21 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ed3:	a1 20 30 80 00       	mov    0x803020,%eax
  801ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ee7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eea:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  801efc:	e8 c8 f4 ff ff       	call   8013c9 <fd2num>
  801f01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f04:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f06:	83 c4 04             	add    $0x4,%esp
  801f09:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0c:	e8 b8 f4 ff ff       	call   8013c9 <fd2num>
  801f11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f14:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f1f:	eb 2e                	jmp    801f4f <pipe+0x141>
	sys_page_unmap(0, va);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	56                   	push   %esi
  801f25:	6a 00                	push   $0x0
  801f27:	e8 55 ee ff ff       	call   800d81 <sys_page_unmap>
  801f2c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	ff 75 f0             	pushl  -0x10(%ebp)
  801f35:	6a 00                	push   $0x0
  801f37:	e8 45 ee ff ff       	call   800d81 <sys_page_unmap>
  801f3c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	ff 75 f4             	pushl  -0xc(%ebp)
  801f45:	6a 00                	push   $0x0
  801f47:	e8 35 ee ff ff       	call   800d81 <sys_page_unmap>
  801f4c:	83 c4 10             	add    $0x10,%esp
}
  801f4f:	89 d8                	mov    %ebx,%eax
  801f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <pipeisclosed>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f61:	50                   	push   %eax
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	e8 d8 f4 ff ff       	call   801442 <fd_lookup>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	78 18                	js     801f89 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	ff 75 f4             	pushl  -0xc(%ebp)
  801f77:	e8 5d f4 ff ff       	call   8013d9 <fd2data>
	return _pipeisclosed(fd, p);
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	e8 2f fd ff ff       	call   801cb5 <_pipeisclosed>
  801f86:	83 c4 10             	add    $0x10,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f91:	68 3e 2f 80 00       	push   $0x802f3e
  801f96:	ff 75 0c             	pushl  0xc(%ebp)
  801f99:	e8 6c e9 ff ff       	call   80090a <strcpy>
	return 0;
}
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <devsock_close>:
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 10             	sub    $0x10,%esp
  801fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801faf:	53                   	push   %ebx
  801fb0:	e8 4d fc ff ff       	call   801c02 <pageref>
  801fb5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fb8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fbd:	83 f8 01             	cmp    $0x1,%eax
  801fc0:	74 07                	je     801fc9 <devsock_close+0x24>
}
  801fc2:	89 d0                	mov    %edx,%eax
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	ff 73 0c             	pushl  0xc(%ebx)
  801fcf:	e8 b9 02 00 00       	call   80228d <nsipc_close>
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	eb e7                	jmp    801fc2 <devsock_close+0x1d>

00801fdb <devsock_write>:
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	ff 75 10             	pushl  0x10(%ebp)
  801fe6:	ff 75 0c             	pushl  0xc(%ebp)
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	ff 70 0c             	pushl  0xc(%eax)
  801fef:	e8 76 03 00 00       	call   80236a <nsipc_send>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <devsock_read>:
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ffc:	6a 00                	push   $0x0
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	ff 70 0c             	pushl  0xc(%eax)
  80200a:	e8 ef 02 00 00       	call   8022fe <nsipc_recv>
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <fd2sockid>:
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802017:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	e8 21 f4 ff ff       	call   801442 <fd_lookup>
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	85 c0                	test   %eax,%eax
  802026:	78 10                	js     802038 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802031:	39 08                	cmp    %ecx,(%eax)
  802033:	75 05                	jne    80203a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802035:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    
		return -E_NOT_SUPP;
  80203a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80203f:	eb f7                	jmp    802038 <fd2sockid+0x27>

00802041 <alloc_sockfd>:
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	56                   	push   %esi
  802045:	53                   	push   %ebx
  802046:	83 ec 1c             	sub    $0x1c,%esp
  802049:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80204b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204e:	50                   	push   %eax
  80204f:	e8 9c f3 ff ff       	call   8013f0 <fd_alloc>
  802054:	89 c3                	mov    %eax,%ebx
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	85 c0                	test   %eax,%eax
  80205b:	78 43                	js     8020a0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	68 07 04 00 00       	push   $0x407
  802065:	ff 75 f4             	pushl  -0xc(%ebp)
  802068:	6a 00                	push   $0x0
  80206a:	e8 8d ec ff ff       	call   800cfc <sys_page_alloc>
  80206f:	89 c3                	mov    %eax,%ebx
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	85 c0                	test   %eax,%eax
  802076:	78 28                	js     8020a0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802081:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80208d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	50                   	push   %eax
  802094:	e8 30 f3 ff ff       	call   8013c9 <fd2num>
  802099:	89 c3                	mov    %eax,%ebx
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	eb 0c                	jmp    8020ac <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	56                   	push   %esi
  8020a4:	e8 e4 01 00 00       	call   80228d <nsipc_close>
		return r;
  8020a9:	83 c4 10             	add    $0x10,%esp
}
  8020ac:	89 d8                	mov    %ebx,%eax
  8020ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    

008020b5 <accept>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	e8 4e ff ff ff       	call   802011 <fd2sockid>
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 1b                	js     8020e2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	ff 75 10             	pushl  0x10(%ebp)
  8020cd:	ff 75 0c             	pushl  0xc(%ebp)
  8020d0:	50                   	push   %eax
  8020d1:	e8 0e 01 00 00       	call   8021e4 <nsipc_accept>
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	78 05                	js     8020e2 <accept+0x2d>
	return alloc_sockfd(r);
  8020dd:	e8 5f ff ff ff       	call   802041 <alloc_sockfd>
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <bind>:
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	e8 1f ff ff ff       	call   802011 <fd2sockid>
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 12                	js     802108 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	ff 75 10             	pushl  0x10(%ebp)
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	50                   	push   %eax
  802100:	e8 31 01 00 00       	call   802236 <nsipc_bind>
  802105:	83 c4 10             	add    $0x10,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <shutdown>:
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	e8 f9 fe ff ff       	call   802011 <fd2sockid>
  802118:	85 c0                	test   %eax,%eax
  80211a:	78 0f                	js     80212b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80211c:	83 ec 08             	sub    $0x8,%esp
  80211f:	ff 75 0c             	pushl  0xc(%ebp)
  802122:	50                   	push   %eax
  802123:	e8 43 01 00 00       	call   80226b <nsipc_shutdown>
  802128:	83 c4 10             	add    $0x10,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <connect>:
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	e8 d6 fe ff ff       	call   802011 <fd2sockid>
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 12                	js     802151 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	ff 75 10             	pushl  0x10(%ebp)
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	50                   	push   %eax
  802149:	e8 59 01 00 00       	call   8022a7 <nsipc_connect>
  80214e:	83 c4 10             	add    $0x10,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <listen>:
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	e8 b0 fe ff ff       	call   802011 <fd2sockid>
  802161:	85 c0                	test   %eax,%eax
  802163:	78 0f                	js     802174 <listen+0x21>
	return nsipc_listen(r, backlog);
  802165:	83 ec 08             	sub    $0x8,%esp
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	50                   	push   %eax
  80216c:	e8 6b 01 00 00       	call   8022dc <nsipc_listen>
  802171:	83 c4 10             	add    $0x10,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <socket>:

int
socket(int domain, int type, int protocol)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	e8 3e 02 00 00       	call   8023c8 <nsipc_socket>
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	85 c0                	test   %eax,%eax
  80218f:	78 05                	js     802196 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802191:	e8 ab fe ff ff       	call   802041 <alloc_sockfd>
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	53                   	push   %ebx
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021a1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8021a8:	74 26                	je     8021d0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021aa:	6a 07                	push   $0x7
  8021ac:	68 00 60 80 00       	push   $0x806000
  8021b1:	53                   	push   %ebx
  8021b2:	ff 35 04 40 80 00    	pushl  0x804004
  8021b8:	e8 67 f1 ff ff       	call   801324 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021bd:	83 c4 0c             	add    $0xc,%esp
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	e8 e6 f0 ff ff       	call   8012b1 <ipc_recv>
}
  8021cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	6a 02                	push   $0x2
  8021d5:	e8 b6 f1 ff ff       	call   801390 <ipc_find_env>
  8021da:	a3 04 40 80 00       	mov    %eax,0x804004
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	eb c6                	jmp    8021aa <nsipc+0x12>

008021e4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021f4:	8b 06                	mov    (%esi),%eax
  8021f6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021fb:	b8 01 00 00 00       	mov    $0x1,%eax
  802200:	e8 93 ff ff ff       	call   802198 <nsipc>
  802205:	89 c3                	mov    %eax,%ebx
  802207:	85 c0                	test   %eax,%eax
  802209:	79 09                	jns    802214 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80220b:	89 d8                	mov    %ebx,%eax
  80220d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5d                   	pop    %ebp
  802213:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	ff 35 10 60 80 00    	pushl  0x806010
  80221d:	68 00 60 80 00       	push   $0x806000
  802222:	ff 75 0c             	pushl  0xc(%ebp)
  802225:	e8 6e e8 ff ff       	call   800a98 <memmove>
		*addrlen = ret->ret_addrlen;
  80222a:	a1 10 60 80 00       	mov    0x806010,%eax
  80222f:	89 06                	mov    %eax,(%esi)
  802231:	83 c4 10             	add    $0x10,%esp
	return r;
  802234:	eb d5                	jmp    80220b <nsipc_accept+0x27>

00802236 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	53                   	push   %ebx
  80223a:	83 ec 08             	sub    $0x8,%esp
  80223d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802248:	53                   	push   %ebx
  802249:	ff 75 0c             	pushl  0xc(%ebp)
  80224c:	68 04 60 80 00       	push   $0x806004
  802251:	e8 42 e8 ff ff       	call   800a98 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802256:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80225c:	b8 02 00 00 00       	mov    $0x2,%eax
  802261:	e8 32 ff ff ff       	call   802198 <nsipc>
}
  802266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802281:	b8 03 00 00 00       	mov    $0x3,%eax
  802286:	e8 0d ff ff ff       	call   802198 <nsipc>
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <nsipc_close>:

int
nsipc_close(int s)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80229b:	b8 04 00 00 00       	mov    $0x4,%eax
  8022a0:	e8 f3 fe ff ff       	call   802198 <nsipc>
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 08             	sub    $0x8,%esp
  8022ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022b9:	53                   	push   %ebx
  8022ba:	ff 75 0c             	pushl  0xc(%ebp)
  8022bd:	68 04 60 80 00       	push   $0x806004
  8022c2:	e8 d1 e7 ff ff       	call   800a98 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022c7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8022d2:	e8 c1 fe ff ff       	call   802198 <nsipc>
}
  8022d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8022ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ed:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8022f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8022f7:	e8 9c fe ff ff       	call   802198 <nsipc>
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	56                   	push   %esi
  802302:	53                   	push   %ebx
  802303:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80230e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802314:	8b 45 14             	mov    0x14(%ebp),%eax
  802317:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80231c:	b8 07 00 00 00       	mov    $0x7,%eax
  802321:	e8 72 fe ff ff       	call   802198 <nsipc>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	85 c0                	test   %eax,%eax
  80232a:	78 1f                	js     80234b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80232c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802331:	7f 21                	jg     802354 <nsipc_recv+0x56>
  802333:	39 c6                	cmp    %eax,%esi
  802335:	7c 1d                	jl     802354 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	50                   	push   %eax
  80233b:	68 00 60 80 00       	push   $0x806000
  802340:	ff 75 0c             	pushl  0xc(%ebp)
  802343:	e8 50 e7 ff ff       	call   800a98 <memmove>
  802348:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80234b:	89 d8                	mov    %ebx,%eax
  80234d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802354:	68 4a 2f 80 00       	push   $0x802f4a
  802359:	68 ec 2e 80 00       	push   $0x802eec
  80235e:	6a 62                	push   $0x62
  802360:	68 5f 2f 80 00       	push   $0x802f5f
  802365:	e8 e9 de ff ff       	call   800253 <_panic>

0080236a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	53                   	push   %ebx
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80237c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802382:	7f 2e                	jg     8023b2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	53                   	push   %ebx
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	68 0c 60 80 00       	push   $0x80600c
  802390:	e8 03 e7 ff ff       	call   800a98 <memmove>
	nsipcbuf.send.req_size = size;
  802395:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80239b:	8b 45 14             	mov    0x14(%ebp),%eax
  80239e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8023a8:	e8 eb fd ff ff       	call   802198 <nsipc>
}
  8023ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    
	assert(size < 1600);
  8023b2:	68 6b 2f 80 00       	push   $0x802f6b
  8023b7:	68 ec 2e 80 00       	push   $0x802eec
  8023bc:	6a 6d                	push   $0x6d
  8023be:	68 5f 2f 80 00       	push   $0x802f5f
  8023c3:	e8 8b de ff ff       	call   800253 <_panic>

008023c8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023de:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8023eb:	e8 a8 fd ff ff       	call   802198 <nsipc>
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	c3                   	ret    

008023f8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023fe:	68 77 2f 80 00       	push   $0x802f77
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	e8 ff e4 ff ff       	call   80090a <strcpy>
	return 0;
}
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <devcons_write>:
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80241e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802423:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802429:	3b 75 10             	cmp    0x10(%ebp),%esi
  80242c:	73 31                	jae    80245f <devcons_write+0x4d>
		m = n - tot;
  80242e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802431:	29 f3                	sub    %esi,%ebx
  802433:	83 fb 7f             	cmp    $0x7f,%ebx
  802436:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80243b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	53                   	push   %ebx
  802442:	89 f0                	mov    %esi,%eax
  802444:	03 45 0c             	add    0xc(%ebp),%eax
  802447:	50                   	push   %eax
  802448:	57                   	push   %edi
  802449:	e8 4a e6 ff ff       	call   800a98 <memmove>
		sys_cputs(buf, m);
  80244e:	83 c4 08             	add    $0x8,%esp
  802451:	53                   	push   %ebx
  802452:	57                   	push   %edi
  802453:	e8 e8 e7 ff ff       	call   800c40 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802458:	01 de                	add    %ebx,%esi
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	eb ca                	jmp    802429 <devcons_write+0x17>
}
  80245f:	89 f0                	mov    %esi,%eax
  802461:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802464:	5b                   	pop    %ebx
  802465:	5e                   	pop    %esi
  802466:	5f                   	pop    %edi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <devcons_read>:
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802474:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802478:	74 21                	je     80249b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80247a:	e8 df e7 ff ff       	call   800c5e <sys_cgetc>
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 07                	jne    80248a <devcons_read+0x21>
		sys_yield();
  802483:	e8 55 e8 ff ff       	call   800cdd <sys_yield>
  802488:	eb f0                	jmp    80247a <devcons_read+0x11>
	if (c < 0)
  80248a:	78 0f                	js     80249b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80248c:	83 f8 04             	cmp    $0x4,%eax
  80248f:	74 0c                	je     80249d <devcons_read+0x34>
	*(char*)vbuf = c;
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	88 02                	mov    %al,(%edx)
	return 1;
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    
		return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	eb f7                	jmp    80249b <devcons_read+0x32>

008024a4 <cputchar>:
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024b0:	6a 01                	push   $0x1
  8024b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b5:	50                   	push   %eax
  8024b6:	e8 85 e7 ff ff       	call   800c40 <sys_cputs>
}
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <getchar>:
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024c6:	6a 01                	push   $0x1
  8024c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024cb:	50                   	push   %eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	e8 df f1 ff ff       	call   8016b2 <read>
	if (r < 0)
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 06                	js     8024e0 <getchar+0x20>
	if (r < 1)
  8024da:	74 06                	je     8024e2 <getchar+0x22>
	return c;
  8024dc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    
		return -E_EOF;
  8024e2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024e7:	eb f7                	jmp    8024e0 <getchar+0x20>

008024e9 <iscons>:
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f2:	50                   	push   %eax
  8024f3:	ff 75 08             	pushl  0x8(%ebp)
  8024f6:	e8 47 ef ff ff       	call   801442 <fd_lookup>
  8024fb:	83 c4 10             	add    $0x10,%esp
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 11                	js     802513 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80250b:	39 10                	cmp    %edx,(%eax)
  80250d:	0f 94 c0             	sete   %al
  802510:	0f b6 c0             	movzbl %al,%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <opencons>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80251b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251e:	50                   	push   %eax
  80251f:	e8 cc ee ff ff       	call   8013f0 <fd_alloc>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	85 c0                	test   %eax,%eax
  802529:	78 3a                	js     802565 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	68 07 04 00 00       	push   $0x407
  802533:	ff 75 f4             	pushl  -0xc(%ebp)
  802536:	6a 00                	push   $0x0
  802538:	e8 bf e7 ff ff       	call   800cfc <sys_page_alloc>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	85 c0                	test   %eax,%eax
  802542:	78 21                	js     802565 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80254d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	50                   	push   %eax
  80255d:	e8 67 ee ff ff       	call   8013c9 <fd2num>
  802562:	83 c4 10             	add    $0x10,%esp
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80256d:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802574:	74 0a                	je     802580 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802580:	a1 08 40 80 00       	mov    0x804008,%eax
  802585:	8b 40 48             	mov    0x48(%eax),%eax
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	6a 07                	push   $0x7
  80258d:	68 00 f0 bf ee       	push   $0xeebff000
  802592:	50                   	push   %eax
  802593:	e8 64 e7 ff ff       	call   800cfc <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	78 2c                	js     8025cb <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80259f:	e8 1a e7 ff ff       	call   800cbe <sys_getenvid>
  8025a4:	83 ec 08             	sub    $0x8,%esp
  8025a7:	68 dd 25 80 00       	push   $0x8025dd
  8025ac:	50                   	push   %eax
  8025ad:	e8 95 e8 ff ff       	call   800e47 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	79 bd                	jns    802576 <set_pgfault_handler+0xf>
  8025b9:	50                   	push   %eax
  8025ba:	68 83 2f 80 00       	push   $0x802f83
  8025bf:	6a 23                	push   $0x23
  8025c1:	68 9b 2f 80 00       	push   $0x802f9b
  8025c6:	e8 88 dc ff ff       	call   800253 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8025cb:	50                   	push   %eax
  8025cc:	68 83 2f 80 00       	push   $0x802f83
  8025d1:	6a 21                	push   $0x21
  8025d3:	68 9b 2f 80 00       	push   $0x802f9b
  8025d8:	e8 76 dc ff ff       	call   800253 <_panic>

008025dd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025dd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025de:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025e3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025e5:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8025e8:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8025ec:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8025ef:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8025f3:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8025f7:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8025fa:	83 c4 08             	add    $0x8,%esp
	popal
  8025fd:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8025fe:	83 c4 04             	add    $0x4,%esp
	popfl
  802601:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802602:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802603:	c3                   	ret    
  802604:	66 90                	xchg   %ax,%ax
  802606:	66 90                	xchg   %ax,%ax
  802608:	66 90                	xchg   %ax,%ax
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__udivdi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80261f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802623:	8b 74 24 34          	mov    0x34(%esp),%esi
  802627:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80262b:	85 d2                	test   %edx,%edx
  80262d:	75 49                	jne    802678 <__udivdi3+0x68>
  80262f:	39 f3                	cmp    %esi,%ebx
  802631:	76 15                	jbe    802648 <__udivdi3+0x38>
  802633:	31 ff                	xor    %edi,%edi
  802635:	89 e8                	mov    %ebp,%eax
  802637:	89 f2                	mov    %esi,%edx
  802639:	f7 f3                	div    %ebx
  80263b:	89 fa                	mov    %edi,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	89 d9                	mov    %ebx,%ecx
  80264a:	85 db                	test   %ebx,%ebx
  80264c:	75 0b                	jne    802659 <__udivdi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f3                	div    %ebx
  802657:	89 c1                	mov    %eax,%ecx
  802659:	31 d2                	xor    %edx,%edx
  80265b:	89 f0                	mov    %esi,%eax
  80265d:	f7 f1                	div    %ecx
  80265f:	89 c6                	mov    %eax,%esi
  802661:	89 e8                	mov    %ebp,%eax
  802663:	89 f7                	mov    %esi,%edi
  802665:	f7 f1                	div    %ecx
  802667:	89 fa                	mov    %edi,%edx
  802669:	83 c4 1c             	add    $0x1c,%esp
  80266c:	5b                   	pop    %ebx
  80266d:	5e                   	pop    %esi
  80266e:	5f                   	pop    %edi
  80266f:	5d                   	pop    %ebp
  802670:	c3                   	ret    
  802671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802678:	39 f2                	cmp    %esi,%edx
  80267a:	77 1c                	ja     802698 <__udivdi3+0x88>
  80267c:	0f bd fa             	bsr    %edx,%edi
  80267f:	83 f7 1f             	xor    $0x1f,%edi
  802682:	75 2c                	jne    8026b0 <__udivdi3+0xa0>
  802684:	39 f2                	cmp    %esi,%edx
  802686:	72 06                	jb     80268e <__udivdi3+0x7e>
  802688:	31 c0                	xor    %eax,%eax
  80268a:	39 eb                	cmp    %ebp,%ebx
  80268c:	77 ad                	ja     80263b <__udivdi3+0x2b>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	eb a6                	jmp    80263b <__udivdi3+0x2b>
  802695:	8d 76 00             	lea    0x0(%esi),%esi
  802698:	31 ff                	xor    %edi,%edi
  80269a:	31 c0                	xor    %eax,%eax
  80269c:	89 fa                	mov    %edi,%edx
  80269e:	83 c4 1c             	add    $0x1c,%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    
  8026a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ad:	8d 76 00             	lea    0x0(%esi),%esi
  8026b0:	89 f9                	mov    %edi,%ecx
  8026b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b7:	29 f8                	sub    %edi,%eax
  8026b9:	d3 e2                	shl    %cl,%edx
  8026bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	89 da                	mov    %ebx,%edx
  8026c3:	d3 ea                	shr    %cl,%edx
  8026c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c9:	09 d1                	or     %edx,%ecx
  8026cb:	89 f2                	mov    %esi,%edx
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 f9                	mov    %edi,%ecx
  8026d3:	d3 e3                	shl    %cl,%ebx
  8026d5:	89 c1                	mov    %eax,%ecx
  8026d7:	d3 ea                	shr    %cl,%edx
  8026d9:	89 f9                	mov    %edi,%ecx
  8026db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026df:	89 eb                	mov    %ebp,%ebx
  8026e1:	d3 e6                	shl    %cl,%esi
  8026e3:	89 c1                	mov    %eax,%ecx
  8026e5:	d3 eb                	shr    %cl,%ebx
  8026e7:	09 de                	or     %ebx,%esi
  8026e9:	89 f0                	mov    %esi,%eax
  8026eb:	f7 74 24 08          	divl   0x8(%esp)
  8026ef:	89 d6                	mov    %edx,%esi
  8026f1:	89 c3                	mov    %eax,%ebx
  8026f3:	f7 64 24 0c          	mull   0xc(%esp)
  8026f7:	39 d6                	cmp    %edx,%esi
  8026f9:	72 15                	jb     802710 <__udivdi3+0x100>
  8026fb:	89 f9                	mov    %edi,%ecx
  8026fd:	d3 e5                	shl    %cl,%ebp
  8026ff:	39 c5                	cmp    %eax,%ebp
  802701:	73 04                	jae    802707 <__udivdi3+0xf7>
  802703:	39 d6                	cmp    %edx,%esi
  802705:	74 09                	je     802710 <__udivdi3+0x100>
  802707:	89 d8                	mov    %ebx,%eax
  802709:	31 ff                	xor    %edi,%edi
  80270b:	e9 2b ff ff ff       	jmp    80263b <__udivdi3+0x2b>
  802710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802713:	31 ff                	xor    %edi,%edi
  802715:	e9 21 ff ff ff       	jmp    80263b <__udivdi3+0x2b>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80272f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802733:	8b 74 24 30          	mov    0x30(%esp),%esi
  802737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80273b:	89 da                	mov    %ebx,%edx
  80273d:	85 c0                	test   %eax,%eax
  80273f:	75 3f                	jne    802780 <__umoddi3+0x60>
  802741:	39 df                	cmp    %ebx,%edi
  802743:	76 13                	jbe    802758 <__umoddi3+0x38>
  802745:	89 f0                	mov    %esi,%eax
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 fd                	mov    %edi,%ebp
  80275a:	85 ff                	test   %edi,%edi
  80275c:	75 0b                	jne    802769 <__umoddi3+0x49>
  80275e:	b8 01 00 00 00       	mov    $0x1,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	f7 f7                	div    %edi
  802767:	89 c5                	mov    %eax,%ebp
  802769:	89 d8                	mov    %ebx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	f7 f5                	div    %ebp
  80276f:	89 f0                	mov    %esi,%eax
  802771:	f7 f5                	div    %ebp
  802773:	89 d0                	mov    %edx,%eax
  802775:	eb d4                	jmp    80274b <__umoddi3+0x2b>
  802777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80277e:	66 90                	xchg   %ax,%ax
  802780:	89 f1                	mov    %esi,%ecx
  802782:	39 d8                	cmp    %ebx,%eax
  802784:	76 0a                	jbe    802790 <__umoddi3+0x70>
  802786:	89 f0                	mov    %esi,%eax
  802788:	83 c4 1c             	add    $0x1c,%esp
  80278b:	5b                   	pop    %ebx
  80278c:	5e                   	pop    %esi
  80278d:	5f                   	pop    %edi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    
  802790:	0f bd e8             	bsr    %eax,%ebp
  802793:	83 f5 1f             	xor    $0x1f,%ebp
  802796:	75 20                	jne    8027b8 <__umoddi3+0x98>
  802798:	39 d8                	cmp    %ebx,%eax
  80279a:	0f 82 b0 00 00 00    	jb     802850 <__umoddi3+0x130>
  8027a0:	39 f7                	cmp    %esi,%edi
  8027a2:	0f 86 a8 00 00 00    	jbe    802850 <__umoddi3+0x130>
  8027a8:	89 c8                	mov    %ecx,%eax
  8027aa:	83 c4 1c             	add    $0x1c,%esp
  8027ad:	5b                   	pop    %ebx
  8027ae:	5e                   	pop    %esi
  8027af:	5f                   	pop    %edi
  8027b0:	5d                   	pop    %ebp
  8027b1:	c3                   	ret    
  8027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027b8:	89 e9                	mov    %ebp,%ecx
  8027ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8027bf:	29 ea                	sub    %ebp,%edx
  8027c1:	d3 e0                	shl    %cl,%eax
  8027c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c7:	89 d1                	mov    %edx,%ecx
  8027c9:	89 f8                	mov    %edi,%eax
  8027cb:	d3 e8                	shr    %cl,%eax
  8027cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027d9:	09 c1                	or     %eax,%ecx
  8027db:	89 d8                	mov    %ebx,%eax
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 e9                	mov    %ebp,%ecx
  8027e3:	d3 e7                	shl    %cl,%edi
  8027e5:	89 d1                	mov    %edx,%ecx
  8027e7:	d3 e8                	shr    %cl,%eax
  8027e9:	89 e9                	mov    %ebp,%ecx
  8027eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ef:	d3 e3                	shl    %cl,%ebx
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	89 d1                	mov    %edx,%ecx
  8027f5:	89 f0                	mov    %esi,%eax
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 fa                	mov    %edi,%edx
  8027fd:	d3 e6                	shl    %cl,%esi
  8027ff:	09 d8                	or     %ebx,%eax
  802801:	f7 74 24 08          	divl   0x8(%esp)
  802805:	89 d1                	mov    %edx,%ecx
  802807:	89 f3                	mov    %esi,%ebx
  802809:	f7 64 24 0c          	mull   0xc(%esp)
  80280d:	89 c6                	mov    %eax,%esi
  80280f:	89 d7                	mov    %edx,%edi
  802811:	39 d1                	cmp    %edx,%ecx
  802813:	72 06                	jb     80281b <__umoddi3+0xfb>
  802815:	75 10                	jne    802827 <__umoddi3+0x107>
  802817:	39 c3                	cmp    %eax,%ebx
  802819:	73 0c                	jae    802827 <__umoddi3+0x107>
  80281b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80281f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802823:	89 d7                	mov    %edx,%edi
  802825:	89 c6                	mov    %eax,%esi
  802827:	89 ca                	mov    %ecx,%edx
  802829:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80282e:	29 f3                	sub    %esi,%ebx
  802830:	19 fa                	sbb    %edi,%edx
  802832:	89 d0                	mov    %edx,%eax
  802834:	d3 e0                	shl    %cl,%eax
  802836:	89 e9                	mov    %ebp,%ecx
  802838:	d3 eb                	shr    %cl,%ebx
  80283a:	d3 ea                	shr    %cl,%edx
  80283c:	09 d8                	or     %ebx,%eax
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	89 da                	mov    %ebx,%edx
  802852:	29 fe                	sub    %edi,%esi
  802854:	19 c2                	sbb    %eax,%edx
  802856:	89 f1                	mov    %esi,%ecx
  802858:	89 c8                	mov    %ecx,%eax
  80285a:	e9 4b ff ff ff       	jmp    8027aa <__umoddi3+0x8a>
